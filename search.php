<!--
/*******************************************************************************
* NAME: HAROLD DANE C. BAGUINON                                                *
* DATE: 12/10/2015                                                             *
* DATE DUE: 12/12/2015 04:00:00 PM                                             *
* COURSE: CSC521 010                                                           *
* PROFESSOR: DR. SPIEGEL                                                       *
* PROJECT: #4                                                                  *
* FILENAME: search.php                                                         *
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
-->
<html>
    <head>
        <meta name="Author" content="Harold Baguinon">
        <title>CSC521 Project 3</title>
            <link rel="stylesheet" type="text/css" href="style.css" />
        <script src="moment.js"></script>
        <script src="req.js" type="text/javascript"/></script>
        <script>
        var currentMomentState = moment();

        function initPage()
        {
            currentMomentState.year(2015).month(11).date(14);
            populateMonthList('monthSelect');
            populateDayList('daySelect');
        }

        function populateMonthList(id)
        {
            var monthSelect = document.getElementById(id);
            for(count = 0; count < moment.months().length; count++)
            {
                var option = document.createElement('option');
                option.text = moment.months()[count];
                monthSelect.add(option);
            }
        }

        function populateDayList(id)
        {
            var daySelect = document.getElementById(id);
            var daysInMonth = numDaysInCurrentMonth();
            var selectLength = daySelect.length;
            if(selectLength < daysInMonth)
            {
                for(count = selectLength + 1; count <= daysInMonth; count++)
                {
                    var option = document.createElement('option');
                    option.text = count;
                    daySelect.add(option);
                }
            }
            else if(selectLength > daysInMonth)
            {
                for(count = selectLength - 1; count >= daysInMonth; count--)
                {
                    daySelect.remove(count);
                }
                daySelect.value = currentMomentState.date();
            }
        }

        function setCurrentMomentYear(year, daySelectId)
        {
            var tempMoment = moment().year(year).month(1);
            if(currentMomentState.month() == 1 && currentMomentState.isLeapYear() && !tempMoment.isLeapYear())
            {
                var daySelect = document.getElementById(daySelectId);
                daySelect.value = tempMoment.endOf('month').date();
                setCurrentMomentDay(tempMoment.date());
                currentMomentState.year(year);
                populateDayList(daySelectId);
            }
            else if(currentMomentState.month() == 1 && !currentMomentState.isLeapYear() && tempMoment.isLeapYear())
            {
                currentMomentState.year(year);
                populateDayList(daySelectId);
            }
            else
            {
                currentMomentState.year(year);
            }
            sndReq();
        }

        function setCurrentMomentMonth(month, daySelectId)
        {
            currentMomentState.month(month);
            populateDayList(daySelectId);
            sndReq();
        }

        function setCurrentMomentDay(day)
        {
            currentMomentState.date(day);
            sndReq();
        }

        function numDaysInCurrentMonth()
        {
            var tempMoment = moment().year(currentMomentState.year()).month(currentMomentState.month()).endOf('month');
            return tempMoment.date();
        }

        
        
        </script>
        
    </head>

    <body onload="initPage()">
        <div id="overall">
            <h1>USNO Sun and Moon Data</h1>
            <div id="menu">
            <ul>
              <li><a href="index.html">1. Complete</a></li>
              <li><a href="duration.html">2. Duration</a></li>
              <li><a href="phases.html">3. Phases</a></li>
              <li><a href="illumination.html">4. Illumination</a></li>
              <li><a href="azimuth.html">5. Azimuth</a></li>
            </ul>
            </div>
            
            <div id="size">
            <h2> <span class="style3">
            <p align="center">JUST KIDDING!<br />
            </p>
            </span></h2>
            
                        
            <p align="center">
            There is no search page!
            </p>
            </div>
            
            
            
            
            <div id="menu2">
            <ul>
              <li>Search:
                <form method="get" action="search.php"><input id="search" name="search" type="text" />&nbsp;&nbsp;<input value="Submit" id="submit" type="submit" /></form>
              </li>
              <h6><span class="special">Copyright &copy; Harold Baguinon. All rights reserved.</span></h6>
            </ul>
            </div>
            </div>

            
        
        <div id="responseDiv"></div>
    </body>
</html>
