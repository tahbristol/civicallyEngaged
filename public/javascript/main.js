'use-strict';
hidePhoneForm();

//process address form
let addressForm = document.getElementById('address');
addressForm.addEventListener('submit', function(e) {
  e.preventDefault();
  let address = this["address"].value;
  getOfficials(address);
});

         //////Functions///////

function getOfficials(address) {
  clearAddress();
  const API_KEY = "AIzaSyD5JWZW3JJSHUYyE8wKCLUOnesa5Udd1AI";   //for development, should be hidden otherwise
  let url = `https://www.googleapis.com/civicinfo/v2/representatives?address=${address}&key=${API_KEY}`
  clearThenRequestOfficials(url);
}

function clearThenRequestOfficials(url){
  $.post('/officials/delete', [], function() {
     fetch(url)
      .then(res => res.json())
      .then(data => {
        const officials = data.officials;
        const division = data.division;
        const offices = data.offices;
        let values = makeOfficalsJSON(officials, offices);
        makePostRequest(values);
      });
   });
}
function makeOfficalsJSON(officials, offices){
  let index = 0;
  let values = [];
  officials.forEach(function(data) {
    let officialObj = `{"name": "${data.name}", "party": "${data.party}", "phone": "${data.phones}", "url": "${data.urls}", "position": "${offices[index].name}"}`
    if (index < offices.length - 1) {
      index = index + 1;
    }
      values.push(JSON.parse(officialObj));
  });
  return values;
}

function makePostRequest(officials){
  officials.forEach(function(official) {
    let officialObj = $.post('/officials', official);
    officialObj.done(function(data) {
      makeDisplayTemplate(data);
      showPhoneForm();
    });
  });
}

function makeDisplayTemplate(data){
  var civicTemplate = document.getElementById('civic').innerHTML;
  var template = Handlebars.compile(civicTemplate);
  var html = template(data);
  document.getElementsByClassName('officials')[0].innerHTML += html;
}

function hidePhoneForm() {
  document.getElementById('phone').style.visibility = "hidden";
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
