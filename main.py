from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.get("/")
def root():
    return jsonify(
        message="Hello from Docker on Mac!",
        env=dict(os.environ),
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8000")), debug=True)
