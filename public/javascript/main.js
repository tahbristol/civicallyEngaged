'use-strict'

let url = `https://www.googleapis.com/civicinfo/v2/representatives?address=4027 vistaview street west mifflin pa&key=${ENV['GOOGLE_API_KEY']}`
//  let url =  'https://jsonplaceholder.typicode.com/posts/1';
var civicData;
fetch(url)
  .then(res => res.json())
  .then(data => {

    var civicTemplate = document.getElementById('civic').innerHTML;
    var template = Handlebars.compile(civicTemplate);
    var html = template(data.officials);
    document.getElementsByClassName('main')[0].innerHTML += html;


  });
