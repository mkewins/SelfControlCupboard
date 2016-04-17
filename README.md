# SelfControlCupboard

### Snack Attack

A smart snack cupboard that helps with self control. It works by only unlocking once the user hits their daily target of calories or steps which are tracked by the users' Fitbit or iPhone through HealthKit.

The prototype consists of a physical cupboard with Raspberry Pi and Servo which switches between lock & unlock positions. The Raspberry Pi runs a Python server powered by Flask web framework, which includes a web app to reveal current status and goals. The web app interacts with Firebase; iPhone and Fitbit push data to Firebase. iPhone app shows current metric values.

Additional hardware required: Raspberry Pi, Servo motor locking mechanism.

### Future development

* Extend support directly to Apple Watch.
* Improve iPhone app to also set the daily goal.
* Fix limitations with pushing data to Firebase from iPhone.

Software/Frameworks/Tools: Flask, Python, Firebase, jQuery, Bootstrap, HTML, CSS
Hardware: Raspberry Pi, Servo Motor, Snack Cupboard
