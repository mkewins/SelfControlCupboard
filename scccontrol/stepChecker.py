#!/usr/bin/env python

from firebase import firebase
import RPi.GPIO as GPIO
import time

# Door control functions
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
GPIO.setup(11,GPIO.OUT)
p = GPIO.PWM(11,50)        #sets pin 11 to PWM and sends 50 signals per second

def lockDoor():
    	print 'LOCKING DOOR'
	p.start(7.5)
	firebase.put('/', "state", "1")

def unlockDoor():
    	print 'UNLOCKING DOOR'
	p.start(2.5)
	firebase.put('/', "state", "0")


firebase = firebase.FirebaseApplication('https://snackattack.firebaseio.com', None)
activeMetric = firebase.get('/metrics/activeMetric', None)
setCalories = int(firebase.get('/metrics/setCalories', None))
setSteps = int(firebase.get('/metrics/setSteps', None))
locked = int(firebase.get('/state', None))

# Now get the data from the devices
activeDevice = firebase.get('/devices/activeDevice', None)
print activeDevice


# Now compare the steps fam
if activeMetric == 'steps':
    currentSteps = int(firebase.get('/' + activeDevice +'/steps', None))
    if currentSteps >= setSteps and locked == 1:
        unlockDoor()
    elif currentSteps < setSteps and locked == 0:
        lockDoor()

if activeMetric == 'calories':
    currentCalories = int(firebase.get('/' + activeDevice +'/calories', None))
    if currentCalories >= setCalories and locked == 1:
        unlockDoor()
    elif currentCalories < setCalories and locked == 0:
        lockDoor()
