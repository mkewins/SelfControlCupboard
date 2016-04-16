import RPi.GPIO as GPIO
import time

# Door control functions
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
GPIO.setup(11,GPIO.OUT)
p = GPIO.PWM(11,50)        #sets pin 11 to PWM and sends 50 signals per second
p.start(2.5) # unlock the cupboard
time.sleep(2)
