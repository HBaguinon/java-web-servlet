/*******************************************************************************
* NAME: HAROLD DANE C. BAGUINON                                                *
* DATE: 12/10/2015                                                             *
* DATE DUE: 12/12/2015 04:00:00 PM                                             *
* COURSE: CSC521 010                                                           *
* PROFESSOR: DR. SPIEGEL                                                       *
* PROJECT: #4                                                                  *
* FILENAME: script.js                                                          *
* PURPOSE: This program is the third project, but it's numbered as "4" due to  *
*          Project 2 being skipped. This program is a website/servlet that will*
*          provide outputs depending on the user's selection. It can display   *
*          information on sun and moon data for one day, a duration of         *
*          lightness/darkness for one day, dates of primary phases of the moon,*
*          the fraction of the moon illuminated, or the altitude and azimuth of*
*          the sun or moon during the day. This program uses several languages *
*          and techniques, including AJAX, HTML, Java, Javascript, and Beans.  *
*          It is a continuation of Project 3.                                  *
* Website link: http://hbagu753.kutztown.edu:8080/SunMoonInfo/index.html       *
* JAVADOC LOCATION: http://acad.kutztown.edu/~hbagu753/project4/javadoc        *
*******************************************************************************/

var numDays=[	
	["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"],
	["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"],
	["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29"],
	["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"],
];

window.onload = function(){UpdateDay(false); todaysDate();};

function UpdateDay(isLeap) {
	var theForm=document.servletForm;
	theForm.daySelect.options.length=null;
	// ValidateYear(document.getElementByName("yearEntry").value);
	var monthValue = theForm.monthSelect.value;
	
	switch(monthValue) {
		case "1":
		case "3":
		case "5":
		case "7":
		case "8":
		case "10":
		case "12":
		for(i=0; i<numDays[0].length; i++) {
			theForm.daySelect.options[i]=new Option(numDays[0][i], numDays[0][i]); 
		} 
		break;
		case "4":
		case "6":
		case "9":
		case "11":
		for(i=0; i<numDays[1].length; i++) {
			theForm.daySelect.options[i]=new Option(numDays[1][i], numDays[1][i]); 
		} 
		break;
		case "2":
		if (isLeap == true) {
			for(i=0; i<numDays[2].length; i++) {
				theForm.daySelect.options[i]=new Option(numDays[2][i], numDays[2][i]); 
			} 
			} else {
			monthValue++;
			for(i=0; i<numDays[3].length; i++) {
				theForm.daySelect.options[i]=new Option(numDays[3][i], numDays[3][i]); 
			} 
		}
		break;
	}
}//UpdateDay

function ValidateYear(year_input) {
	var year_output = +year_input;
	if (year_output < 1700 || year_output > 2100) 
    {
        alert("Please input a year between 1700 and 2100.");
    }
    else
    {
        var leap = LeapYear(year_output);
        UpdateDay(leap);
    }
}//ValidateYear

function LeapYear(valid_year) {
    if ( ( valid_year % 4 == 0 && valid_year % 100 != 0 ) || valid_year % 400 == 0 ) 
    {
        return true;	
    }
    else
    {
        return false;
    }
}//isLeap

function todaysDate() {
    var today = new Date();
    var dd = Date().getDate();
    var mm = Date().getMonth()+1; //Jan is 0
    var yyyy = Date().getFullYear();
    
    if(dd<10) {
        dd='0'+dd
    } 
    
    if(mm<10) {
        mm='0'+mm
    } 
    
    today = mm+'/'+dd+'/'+yyyy;
    
    // document.getElementById("monthSelect").setAttribute("value",mm);
    //document.getElementById("servletForm").monthSelect[(mm-1)].selected = true;
    document.getElementById("daySelect").setAttribute("value", today.getDate());
}