from sccserver import app
import fitbit, pprint
from scripts.secrets import *
from flask import redirect, request, render_template, url_for

oauth = fitbit.FitbitOauth2Client(CLIENT_ID, CLIENT_SECRET)
redirect_path = '/auth/callback'
access_token = None
refresh_token = None
client = None

@app.route('/')
def index():
    # return "Hello world! <a href='/auth'>Login</a>"
    return render_template('index.html', client=client)

@app.route('/auth')
def auth():
    redirect_url = oauth.authorize_token_url(redirect_uri='http://'+request.host+redirect_path)[0]
    return redirect(redirect_url)

@app.route('/auth/callback')
def auth_callback():
    code = request.args.get('code')
    state = request.args.get('state')
    results = oauth.fetch_access_token(code, 'http://'+request.host+redirect_path)
    global access_token
    global refresh_token
    global client
    access_token = oauth.token['access_token']
    refresh_token = oauth.token['refresh_token']
    client = fitbit.Fitbit(CLIENT_ID, CLIENT_SECRET, access_token=access_token)
    return """
        Success. <a href='/'>Redirecting to home...</a>
        <script>
        window.location.href = '/';
        </script>
        """

