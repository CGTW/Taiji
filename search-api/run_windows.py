"""轻量搜索 API 服务 — 基于 Tavily"""
import os
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

# Load .env manually to avoid python-dotenv dependency
_env_path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(_env_path):
    with open(_env_path, encoding='utf-8') as _f:
        for _line in _f:
            _line = _line.strip()
            if _line and not _line.startswith('#'):
                _k, _, _v = _line.partition('=')
                os.environ.setdefault(_k.strip(), _v.strip())

TAVILY_API_KEY = os.environ.get('TAVILY_API_KEY')
TAVILY_URL = 'https://api.tavily.com/search'

@app.route('/search')
def search():
    q = request.args.get('q', '')
    if not q:
        return jsonify([])
    try:
        resp = requests.post(TAVILY_URL, json={
            'api_key': TAVILY_API_KEY,
            'query': q,
            'max_results': 5,
            'search_depth': 'basic'
        }, timeout=10)
        data = resp.json()
        results = data.get('results', [])
        return jsonify([{
            'title': r.get('title', ''),
            'url': r.get('url', ''),
            'content': r.get('content', '')
        } for r in results])
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health')
def health():
    return 'ok'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4000, debug=True)
