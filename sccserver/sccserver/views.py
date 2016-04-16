from sccserver import app
import fitbit, pprint
from scripts.secrets import *
from flask import redirect, request
from firebase import firebase

oauth = fitbit.FitbitOauth2Client(CLIENT_ID, CLIENT_SECRET)
redirect_uri = 'http://localhost:1738/auth/callback'
access_token = None
refresh_token = None
client = None
ref = firebase.FirebaseApplication('https://snackattack.firebaseio.com', None)

@app.route('/')
def index():
    return "Hello world! <a href='/auth'>Login</a>"

@app.route('/auth')
def auth():
    redirect_url = oauth.authorize_token_url(redirect_uri=redirect_uri)[0]
    return redirect(redirect_url)

@app.route('/auth/callback')
def auth_callback():
    code = request.args.get('code')
    state = request.args.get('state')
    results = oauth.fetch_access_token(code, redirect_uri)
    global access_token
    global refresh_token
    global client
    access_token = oauth.token['access_token']
    refresh_token = oauth.token['refresh_token']
    client = fitbit.Fitbit(CLIENT_ID, CLIENT_SECRET, access_token=access_token)
    return 'Success'

def fitbit_steps():
    # pull steps data from fitbit and push to firebase
    if client is None:
        return redirect('/auth')
    stuff = client.activities()
    steps = stuff['summary']['steps']
    calories = stuff['summary']['calories']
    firebase.put('/fitbit', {'steps': steps, 'calories': calories})
