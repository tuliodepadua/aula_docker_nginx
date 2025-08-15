from flask import Flask, jsonify
from datetime import datetime

app = Flask(__name__)

@app.get("/py")
def hello_py():
    return jsonify({
        "service": "python",
        "message": "Hello from Python + Flask!",
        "timestamp": datetime.utcnow().isoformat() + "Z"
    })

@app.get("/")
def root():
    return "Python service is up. Try GET /py"

if __name__ == "__main__":
    app.run(port=5000, host="0.0.0.0")
