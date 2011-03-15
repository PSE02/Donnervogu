

var hello = {
  click: function() {
    getHttpRequest();
  },
};

 
function getHttpRequest() {
   
    var xmlhttp = null;
   
    if (window.XMLHttpRequest) {
        xmlhttp = new XMLHttpRequest();
    }

   
    xmlhttp.open("GET", 'http://localhost/getZip.php', true);
    xmlhttp.onreadystatechange = function() {

        if(xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            alert(xmlhttp.responseText);
        }
    }
    xmlhttp.send(null);
}

