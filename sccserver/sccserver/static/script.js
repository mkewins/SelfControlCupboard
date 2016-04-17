// Firebase Reference
var metricRef = new Firebase('https://snackattack.firebaseio.com/metrics');
var deviceRef = new Firebase('https://snackattack.firebaseio.com/devices');
var activeDeviceRef;

var calField = $('#calInput');
var stepField = $('#stepInput');

var setSteps;
var setCalories;
var currentSteps;
var currentCalories;

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
  console.log(name, ' child changed to ', data);
  if (name == 'setCalories') {
    $("#calCur").html(data);
  } else if (name == 'setSteps') {
    $("#stepCur").html(data);
  }
});

// Update current goals on page load
$(document).ready( function() {
  metricRef.once("value", function(data) {
    setSteps = data.child('setSteps').val();
    setCalories = data.child('setCalories').val();
    $("#calCur").html(setCalories);
    $("#stepCur").html(setSteps);
    // By default, display calories
    $('#calories-container').show();
    $('#steps-container').hide();
  });

  // Highlight the active device
  deviceRef.once("value", function(data) {
    var activeDeviceName = data.child('activeDevice').val();
    var activeDevice = '#' + data.child('activeDevice').val();
    $(activeDevice).parent().addClass("active");
    $('#device-chooser').html(activeDeviceName + " &#9660");
    // Get the reference for the active device
    var activeDeviceRefLink = 'https://snackattack.firebaseio.com/' + activeDeviceName;
    activeDeviceRef = new Firebase(activeDeviceRefLink);

    // Compute and set the charts.
    activeDeviceRef.once("value", function(data) {
      var currentSteps = data.child('steps').val();
      var currentCalories = data.child('calories').val();

      // Compute the charts
      var stepRatio = currentSteps / setSteps;
      var calorieRatio = currentCalories / setCalories;
      console.log(currentCalories, setCalories, calorieRatio)
      if(calorieRatio >= 100) {
        calorieRatio = 100;
      }
      if(stepRatio >= 100) {
        stepRatio = 100;
      }
      console.log(calorieRatio);
      $('.progress-front').width( (calorieRatio*100)-10 + '%' );
      $('.progress-back').html(setCalories);
      $('.progress-front').html(currentCalories);
    });
  });



});

function showCalories(){
  $('#calories-container').show();
  $('#steps-container').hide();
  $('.dropdown-title').html('Calories &#9660')
  // set active metric to calories
  metricRef.child('activeMetric').set("calories", onComplete);
}

function showSteps(){
  $('#steps-container').show();
  $('#calories-container').hide();
  $('.dropdown-title').html('Steps &#9660')
  // set active metric to steps
    metricRef.child('activeMetric').set("steps", onComplete);
}

function changeActiveDevice(deviceName) {
  deviceRef.child('activeDevice').set(deviceName);
  $('#device-chooser').html(deviceName + " &#9660")
}
