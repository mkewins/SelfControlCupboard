import RPi.GPIO as GPIO
import time
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
GPIO.setup(11,GPIO.OUT)
p = GPIO.PWM(11,50)        #sets pin 21 to PWM and sends 50 signals per second
p.start(7.5) #Start the door unlocked

def lockDoor():
	p.ChangeDutyCycle(7.5)

def unlockDoor():
	p.ChangeDutyCycle(2.5)

try:                      
    while True:       #starts an infinite loop
        lockDoor()
	time.sleep(1.5)                   #continues for a half a second
        unlockDoor()
	time.sleep(2.5)                   #continues for a half a second
except KeyboardInterrupt:
    p.stop()
    GPIO.cleanup()

