from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():
    return 'cmtr-test1238'


@app.route('/health')
def health():
    return 'ok', 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
