# Hello Docker (Mac) — Flask, Docker, GitHub Actions → GHCR

This is a minimal end‑to‑end example:
- Run locally on your Mac with Docker
- Push code to GitHub
- GitHub Actions builds a multi‑arch image (arm64 + amd64) and pushes it to **GHCR** (GitHub Container Registry).

## Prereqs on Mac
1) Install Docker Desktop: https://www.docker.com/products/docker-desktop/
2) Install Git (Homebrew): `brew install git`
3) Sign in to GitHub and create a new empty repo (without README).

## Local run
```bash
# From project root
docker build -t hello-docker:local .
docker run --rm -p 8000:8000 hello-docker:local
# Visit http://localhost:8000
```

## Push to GitHub
```bash
git init
git branch -m main
git add .
git commit -m "init: tiny docker app + workflow"
git remote add origin https://github.com/<YOUR_GH_USERNAME>/<YOUR_REPO>.git
git push -u origin main
```

## Image publish (automatic via Actions → GHCR)
The provided workflow builds and pushes `ghcr.io/<OWNER>/<REPO>:latest` on every push to `main`.

### One-time repo settings
- Go to **Settings → Actions → General**: allow GitHub Actions to create and approve pull requests (default OK).
- Go to **Settings → Packages**: ensure packages visibility is set as you prefer (private/public).

### Pull & run your image from GHCR (anywhere)
```bash
echo $CR_PAT | docker login ghcr.io -u <YOUR_GH_USERNAME> --password-stdin
docker pull ghcr.io/<YOUR_GH_USERNAME>/<YOUR_REPO>:latest
docker run --rm -p 8000:8000 ghcr.io/<YOUR_GH_USERNAME>/<YOUR_REPO>:latest
```
Where `CR_PAT` is a GitHub Personal Access Token with `read:packages` (or use `docker login` with the UI prompt).

## Notes for Apple Silicon (M1/M2/M3)
- The workflow builds **multi-arch** (linux/amd64 + linux/arm64) so your image runs on both Intel & Apple Silicon.
- Local build can also target a specific platform:
  ```bash
  docker buildx build --platform linux/arm64 -t hello-docker:arm64 .
  ```
