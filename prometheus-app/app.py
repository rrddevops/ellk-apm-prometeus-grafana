from flask import Flask, Response
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

REQUESTS = Counter('prometheus_app_requests_total', 'Total HTTP Requests', ['path', 'method'])

app = Flask(__name__)

@app.route('/')
def index():
    REQUESTS.labels(path='/', method='GET').inc()
    return 'prometheus-app OK'

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
