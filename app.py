from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():
    return 'test1235'


@app.route('/health')
def health():
    return 'ok', 200


if __name__ == '__main__':
    import os
    app.run(host='0.0.0.0', port=1000, debug=os.environ.get('FLASK_DEBUG', 'False') == 'True')