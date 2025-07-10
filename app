from flask import Flask, request, jsonify
import requests
import os

app = Flask(__name__)

MAKE_WEBHOOK_URL = os.getenv("MAKE_WEBHOOK_URL")
API_KEY = os.getenv("HQ_API_KEY")

@app.route("/forward", methods=["POST"])
def forward():
    auth = request.headers.get("Authorization")
    if auth != f"Bearer {API_KEY}":
        return jsonify({"error": "Unauthorized"}), 401

    payload = request.get_json()
    if not payload:
        return jsonify({"error": "No JSON payload received"}), 400

    try:
        res = requests.post(MAKE_WEBHOOK_URL, json=payload)
        return jsonify({
            "status": res.status_code,
            "response": res.text
        }), res.status_code
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
