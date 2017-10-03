 function createRequestObject() {
    var ro;
    var browser = navigator.appName;
    if(browser == "Microsoft Internet Explorer"){
        ro = new ActiveXObject("Microsoft.XMLHTTP");
    }else{
        ro = new XMLHttpRequest();
    }
    return ro;
 }

 var http = createRequestObject();

 function sndReq() {

    http.open('POST', 'http://hbagu753.kutztown.edu:8080/SunMoonInfo/SunMoonServlet', true);
    //document.TheForm.textfield3.value="The action is "+action;
    
    //document.TheForm.area.value="The http object is "+http;
    http.send(null);
    document.getElementById('responseDiv').innerHTML = "<p align=\"center\">";
    document.getElementById('responseDiv').innerHTML = "PLEASE WAIT WAIT WAIT WAIT WAIT!</p>";
    http.onreadystatechange = handleResponse;
    return false;
 }

 function handleResponse() {
    if(http.readyState == 4){
        // && http.status == 200
        var response = http.responseText;
     //   document.TheForm.textfield4.value="Response is "+http.responseText;
        var TheDiv = document.getElementById('responseDiv');
        TheDiv.innerHTML = "THIS IS SOME MORE RANDOM STUFF RESPONSE!";
        document.getElementById('responseDiv').innerHTML = response;
        
        //TheDiv.innerHTML=response;
     //   var update = new Array();
     //   document.TheForm.textfield2.value="Index of | is "+response.indexOf('|');
        /*if() {
//        if(response.indexOf('|' != -1)) {
            
            // update = response.split('|');
//            document.TheForm.textfield2.value=update[0];
            //document.getElementById(update[0]).innerHTML = update[1];
           // document.TheForm.textfield5.value=update[0];
        }
        else{
            alert("Error during AJAX call. Please try again.")
        }*/
    }
 }
