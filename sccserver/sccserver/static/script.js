// Firebase Reference
var metricRef = new Firebase('https://snackattack.firebaseio.com/metrics');

var calField = $('#calInput');
var stepField = $('#stepInput');

// Error handling
var onComplete = function(error) {
  if(error) {
    console.log('Synchronization failed');
  } else {
    console.log('Synchronization succeeded');
  }
}

// On enter, update new calorie goal, clear input box
calField.keypress(function(event){
  if(event.keyCode == 13){
    var numCalories = calField.val();
    metricRef.child('setCalories').set(numCalories, onComplete);
    calField.val('');
  }
});

// On enter, update new step goal, clear input box
stepField.keypress(function(event){
  if(event.keyCode == 13){
    var numSteps = stepField.val();
    metricRef.child('setSteps').set(numSteps, onComplete);
    stepField.val('');
  }
});

// Feedback: Update new values on change
metricRef.on('child_changed', function(snapshot) {
  var data = snapshot.val();
  var name = snapshot.key();
  console.log('name = ', name);
  if (name == 'setCalories') {
    $("#calCur").html(data);
  } else if (name == 'setSteps') {
    $("#stepCur").html(data);
  }
});

// Update current goals on page load
$(document).ready( function() {
  metricRef.once("value", function(data) {
    $("#calCur").html(data.child('setCalories').val());
    $("#stepCur").html(data.child('setSteps').val());
  });
});