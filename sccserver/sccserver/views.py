from sccserver import app

@app.route('/')
def index():
    return "Hello world!"
