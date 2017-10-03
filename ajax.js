function getXMLHTTPObject(){
    var xmlhttpObject = null;
    try {
        xmlhttpObject = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            xmlhttpObject = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (el) {
            xmlhttpObject = false;
        }
    }
    if (!xmlhttpObject && typeof XMLHttpRequest != 'undefined') {
        xmlhttpObject = new XMLHttpRequest();
    }
    return xmlhttpObject;
}

function setAjaxOutput() {
    document.getElementById('responseDiv').innerHTML = "Set AJAX OUTPUTTTTTTTTTT";
    document.getElementById('responseDiv').innerHTML = xmlhttpObject.responseText;
}

function handleServerResponse() {
    document.getElementById('responseDiv').innerHTML = "HANDLE SERVER RESPONSE";
    if (xmlhttpObject.readyState == 4 && xmlhttpObject.status == 200) {
        setAjaxOutput();
        /*if (xmlhttpObject.status == 200) {
//            setAjaxOutput();
        } else {
            alert("Error during AJAX call. Please try again");
        }*/
    }
}

function doAjaxCall() {
    xmlhttpObject = getXMLHTTPObject();
    document.getElementById('responseDiv').innerHTML = "doAjaxCall called";
    if (xmlhttpObject != null) {
        var URL = "http://hbagu753.kutztown.edu:8080/SunMoonInfo/SunMoonServlet";
        xmlhttpObject.open("POST", URL, true);
        xmlhttpObject.send(null);
        xmlhttpObject.onreadystatechange = handleServerResponse;
    }
}