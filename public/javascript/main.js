'use-strict';
hidePhoneForm();
hideErrors();
readyAddressForm();


//////Functions///////

function readyAddressForm() { //process address form
  let addressForm = document.getElementById('address');
  addressForm.addEventListener('submit', function(e) {
    e.preventDefault();
    if (this["address"].value !== '') {
      let address = this["address"].value;
      getOfficials(address);
    } else {
      searchError();
    }
  });
}

function getOfficials(address) {
  clearAddress();
  $.post('/officials/queryAPI', {address: address}, function(res){
    makePostRequest(res)
  })
}

function makePostRequest(officials) {
  officials.forEach(function(official) {
      makeDisplayTemplate(official);
      showPhoneForm();
  });
}

function makeDisplayTemplate(data) {
  var civicTemplate = document.getElementById('civic').innerHTML;
  var template = Handlebars.compile(civicTemplate);
  var html = template(data);
  document.getElementsByClassName('officials')[0].innerHTML += html;
}

function hidePhoneForm() {
  document.getElementById('phone').style.visibility = "hidden";
}

function hideErrors(){
  document.getElementById('searchError').style.visibility = "hidden";

}

function showPhoneForm() {
  document.getElementById('phone').style.visibility = "visible";
}

function clearAddress() {
  hidePhoneForm();
  let cleared = $.post('/officials/delete');
  cleared.done(function(data) {
    document.getElementsByClassName('officials')[0].innerHTML = "";
  });
}

if ($('#message')) {
  setTimeout(function() {
    $('#message').fadeOut('slow');
  }, 3000);

}

function searchError() {
  $('#searchError').css('visibility', 'visible');
  $('#searchError p').text("Please enter an address or zipcode.");
  setTimeout(function() {
    $('#searchError').fadeOut('slow');
  }, 3000);
}
