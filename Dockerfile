# ---- Builder (cache deps) ----
FROM python:3.12-slim AS builder
WORKDIR /app
# Prevent Python from writing .pyc files and buffering stdout/err
ENV PYTHONDONTWRITEBYTECODE=1             PYTHONUNBUFFERED=1
# System deps for building wheels (kept in builder only)
RUN apt-get update && apt-get install -y --no-install-recommends             build-essential          && rm -rf /var/lib/apt/lists/*

# Install dependencies separately for better layer caching
COPY requirements.txt .
RUN pip install --upgrade pip && pip wheel --no-cache-dir --no-deps -r requirements.txt -w /wheels

# Copy app code
COPY app ./app

# ---- Runtime (small) ----
FROM python:3.12-slim
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1             PYTHONUNBUFFERED=1             PORT=8000
# Only runtime deps
RUN useradd -m -u 10001 appuser
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/* && rm -rf /wheels
COPY --from=builder /app /app

# Use a non-root user
USER appuser

EXPOSE 8000
# Start the app (Gunicorn serves Flask)
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "app.main:app"]
