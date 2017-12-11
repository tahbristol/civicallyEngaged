
'use-strict'
const API_KEY = "AIzaSyD5JWZW3JJSHUYyE8wKCLUOnesa5Udd1AI";
console.log(API_KEY);
let url = `https://www.googleapis.com/civicinfo/v2/representatives?address=1621 valencia way reston va&key=${API_KEY}`
//  let url =  'https://jsonplaceholder.typicode.com/posts/1';

fetch(url)
  .then(res => res.json())
  .then(data => {


    const officials = data.officials;
    const division = data.division;
    const offices = data.offices;

    let index = 0;
    let values = [];

    officials.forEach(function(data) {

      let officialObj = `{"name": "${data.name}", "party": "${data.party}", "phone": "${data.phones}", "url": "${data.urls}", "position": "${offices[index].name}"}`
      if (index < offices.length - 1) {
        index = index + 1;
      }
      values.push(JSON.parse(officialObj));
    });

    values.forEach(function(official) {
      let officialObj = $.post('/officials', official);
      officialObj.done(function(data) {
        var civicTemplate = document.getElementById('civic').innerHTML;
        var template = Handlebars.compile(civicTemplate);
        var html = template(data);
        document.getElementsByClassName('main')[0].innerHTML += html;
      });

    });

  });




//let postOfficials = $.post('/officials', values);

/*postOfficials.done(function(data){
      console.log(data);
    })
    var civicTemplate = document.getElementById('civic').innerHTML;
    var template = Handlebars.compile(civicTemplate);
    var html = template(data.officials);
    document.getElementsByClassName('main')[0].innerHTML += html;


  });*/

/*$.getJSON(url, function(data){
    var civicTemplate = document.getElementById('civic').innerHTML;
    var template = Handlebars.compile(civicTemplate);
    let values = data.officials.map( function(data) {
      let officialsObjs = []
      let officialObj = `{"name": "${data.name}", "party": "${data.party}"}`
      //  return JSON.parse(officialObj);
        let officials = $.post('/officials', JSON.parse(officialObj));

         officials.done(function(data){
            console.log(data);
           //var html = template(data.name);

          // document.getElementsByClassName('main')[0].innerHTML += html;
        });



    });
  //  console.log(values);

})*/
