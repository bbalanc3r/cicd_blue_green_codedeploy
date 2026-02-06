from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():
    return 'ac8bmr88'


@app.route('/health')
def health():
    return 'not ok', 500


if __name__ == '__main__':
    import os
    app.run(host='0.0.0.0', port=8000, debug=os.environ.get('FLASK_DEBUG', 'False') == 'True')