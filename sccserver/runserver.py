from sccserver import app
from flask_apscheduler import APScheduler
from firebase import firebase

ref = firebase.FirebaseApplication('https://snackattack.firebaseio.com', None)

class Config(object):
    JOBS = [
        {
            'id': 'fitbit_steps',
            'func': '__main__:fitbit_steps',
            'args': (),
            'trigger': 'interval',
            'seconds': 30,
        }
    ]
    SCHEDULER_VIEWS_ENABLED = True

def fitbit_steps():
    # pull steps data from fitbit and push to firebase
    from sccserver.views import client
    if client is None:
        print 'No client available'
        return
    stuff = client.activities()
    steps = stuff['summary']['steps']
    calories = stuff['summary']['caloriesOut']
    print 'Trying to update'
    try:
        ref.put('/', 'fitbit', {'steps': steps, 'calories': calories})
        print 'Updated data with', steps, 'steps and', calories, 'calories'
    except Exception as e:
        print 'Failed to update'
        print e

app.config.from_object(Config())

scheduler = APScheduler()
scheduler.init_app(app)
scheduler.start()

app.run(host='0.0.0.0', debug=True, port=1738)
