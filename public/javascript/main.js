'use-strict';
hidePhoneForm();
hideErrors();
readyAddressForm();

//////Functions///////
window.CurrentOfficials = {
  records: []
}

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

function readySendText() {
  $('#phone').on('click', function(event){
    event.preventDefault();
    let number = $('#toPhoneNumber').val();
    let officialsToSend = $('.sendOfficials');
    let officials = [];

    $.each(officialsToSend, function(idx, official) {
      let sendIt = $(official).prop('checked');
      if(sendIt) {
        officials.push(CurrentOfficials.records[idx]);
      }
    });
    $.post('/officials/send', { officials: JSON.stringify(officials), toNumber: number})
    .then(res => res.to_json())
    .then(data => {
      debugger   FIX FLASH MESSAGE
      $('#message').text(data.message);
    })
  })
}

function getOfficials(address) {
  clearAddress();
  $.post('/officials/queryAPI', {address: address}, function(res){
    window.CurrentOfficials.records = res;
    makePostRequest(res)
  })
}

function makePostRequest(officials) {
  officials.forEach(function(official) {
      makeDisplayTemplate(official);
    });
    showPhoneForm();
}

function makeDisplayTemplate(data) {
  var civicTemplate = document.getElementById('civic').innerHTML;
  var template = Handlebars.compile(civicTemplate);
  var html = template(data);
  document.getElementsByClassName('officials')[0].innerHTML += html;
}

function hidePhoneForm() {
  document.getElementById('phoneForm').style.display = "none";
}

function hideErrors(){
  document.getElementById('searchError').style.visibility = "hidden";

}

function showPhoneForm() {
  document.getElementById('phoneForm').style.display = "block";
  readySendText();
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
