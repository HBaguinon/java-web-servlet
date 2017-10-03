/*******************************************************************************
* NAME: HAROLD DANE C. BAGUINON                                                *
* DATE: 12/10/2015                                                             *
* DATE DUE: 12/12/2015 04:00:00 PM                                             *
* COURSE: CSC521 010                                                           *
* PROFESSOR: DR. SPIEGEL                                                       *
* PROJECT: #4                                                                  *
* FILENAME: readme.txt                                                         *
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

Design Decisions
    
    Background:
    
    This project is a continuation of Project 3. It was to contain the following
updates: access to cookies, access to session information, a Java Server Page,
and output using Ajax such that the data appears in the same window or area as
the menu/form inputs. The JSP was also meant to use a Java Bean.

    From my understanding, a JSP is meant to act as a Servlet, with similar 
functionality. The JSP version of the servlet would contain all of the same or
similar methods and variables, but would also allow for HTML to be placed on the
page for usage/access of the variables and Java Beans.

    My original interpretation of the assignment was that we needed to create a
.jsp file from the .java servlet file which we created from Project 3. This new
file would replace the old .java file and act as the servlet. But one of my
peers in class asked "How much JSP do we need to use?" to which the professor
implied that it's up to us to make that decision as developers. That got me to
thinking. The project could be done in two ways:

    1. Convert the existing HTML files to JSP files, adding Java bean, cookie,
       and session functionality to the new JSP files. This would allow us to 
       keep the .java servlets which we made intact, with zero to minimal need
       to modify an already "perfect" piece of software. One classmate and I 
       agreed that our Project 3 servlets were already exactly where we wanted
       them to be, and we were dismayed at the thought of having to modify them.
    2. Convert the Servlet into a JSP, which would act as the servlet. This
       would let us keep our HTML files as-is, unless we wanted to modify any of
       the functionality, aesthetics, or other code (like Ajax or Javascript).
    3. (Bonus idea) Create a sort of middleman.jsp which would receive the form
       data, and access the servlet as an object. This JSP could also, in
       theory, have access to the Beans, cookies, and session information. This
       way, both the HTML files and the Servlet would not need to be modified
       much.
       
    I first thought that #3 would work best, since it would allow me to keep
my existing files intact and just create a new JSP file. But I quickly scrapped 
that concept because I had no idea of how I would be able to send response data
from the servlet to the JSP and back to the original HTML. So I decided to look
into #1.
    The problem with #1 however, is that it fails to comply with one of the
points on the assignment: to change the action of the request to a JSP file
rather than the servlet. That leaves us with #2, which calls for modification of
the Servlet.

    The Vision:

    Before changing the Servlet, I wanted to add Ajax functionality to my HTML 
pages, so that the output data would appear below the form inputs. I wanted to 
create a cookie that would identify a returning user. I wanted to create a 
session that would fill in form data for returners and count the number of times
someone submitted a query. I wanted to create a Java Bean that would act as the
list of tables, which would be used to keep track of which tables were requested
in order to call a function that would purge the tables when the table count
reached 10. The bean would be necessary since a JSP is compiled every time it is
accessed, so the original method by which I kept track of tables wouldn't work,
since it relied on the perpetual nature of Java Servlets (where they only get
compiled once, and universal variables are everlasting).
    This was a grand vision, but unfortunately several problems and even
compilation errors caused me to scrap it. First, I spent several days trying out
different Ajax examples (including the professor's) to get code to appear in the
appropriate DIV of the HTML files. Nothing I did worked. All of the examples
were able to print some test text that I had written ("This is the response."),
but nothing would print when the Servlet was to return data. At this point, I
have speculated that it may have to do with how I've been sending data, but
unfortunately I don't have time to test it out. (I know that I was able to send
data to the servlet, but for some reason the servlet never returned data. Or 
if it did, the data was empty.)
    Because much time was sacrificed trying to incorporate Ajax into my project,
I had little time to fix the other problems. First, I tried to access the
cookies. It was a success! I was able to give a message to new users and to
change the message for returning users. Next, I accessed the session info. I was
able to store user input into the session, and it would fill in the form info
when they accessed the form again, but only when pressing the back button on the
browser. I'm speculating that my Javascript caused the form to reset itself if
the HTML page was accessed directly again by clicking the link in the menu. Then
I created a bean to hold the table names for use with the JSP file. Lastly, I 
tried converting my Java Servlet into a JSP file. But several compilation errors
at run-time (or access-time) caused the JSP file to be worthless and not 
functional. I had to go back and just use my original servlet, with some
modifcations like cookie and session usage.

    Suggestions for improvement:
    
    The professor noticed that my design for database access was flawed. Not 
that it didn't work, but that it wasn't as efficient as it should be. The
database access was based on the professor's StatesDBAccess and StatesDBCreate
classes. In those examples, the servlet takes the user input and creates an SQL
query statement to send a query to the oracle database on the school's database
server. If the table was there, the SELECT statement would work, and results 
would be printed out. If the table was not there, the SELECT statement would
fail, causing an exception to be thrown, and calling upon the StatesDBCreate 
class to create a table and printing out the results.
    I decided to follow the professor's example, and I merged the two classes 
and turned their functions into methods of my servlet. When the user inputs
data, a query would be created to access the database. If the table did not 
exist, the SELECT statement would fail, and an exception would be thrown, with 
accompanying error text. If the exception is called, then I designed it so that
a create table method was called to create the table based on the query data,
and then the table would be outputted to the user. Unfortunately, the professor
pointed out that it's bad practice to have too many error messages and to access
the database to check if the table exists. It is better to figure out whether or
not the table exists first before accessing the database.
    In this way, the Access vs Create methods would be separated, and either one
would be called depending on whether or not the table exists. So taking this
knowledge, I created a new method to check for the existence of the table in my
list of tables. The servlet compiles fine, but for whatever reason, the method
itself fails at run-time. I have left the function in the code, but commented
out. The purpose of the function was to compare the table name to each element 
in the array (list) of table names. If true, then the table exists, and only a
SELECT query would be sent to the database for output. If false, then the table
does not yet exist, and a CREATE statement would be sent instead. But because 
the method failed at run-time (I'm completely stumped!), I had to resort to
using my previous method of querying the database to check for the existence 
of the table. I did, however, remove the error messages and other extraneous
text, to leave just input information, the table of data, cookie test, and 
number of queries.

    Bonus Extra Stuff:
    
    I had considered making the website secure, with a login and password, if I
had more time. I would have made the connection secure, and if possible, added
encryption to the site. It's not really necessary, as all of this is public
knowledge anyway, but it would have just been a test on methodology. Due to time
constrains as well as focusing on fixing the other, more important issues, I 
was unable to test this out.



Readme from Project 3 follows below, for reference, and for information about 
the design decisions for the original project:

Design Decisions

    Website (HTML Files) and GUI
    
I have very little experience with coding and producing websites, so there was
much I had to learn. I wanted to set up the forms in such a way as to have each
form on its own page, so that there is no extraneous information that is meant
for one form but not another. As such, I ended up created an entire HTML file
for each of the forms. Also, I was able to limit the input of dates by the user 
to match certain criteria; for example, the user cannot choose February 30, as 
that date does not exist. Originally, I thought that the assignment was to 
simply query the USNO site and to output the table. Much to my dismay, I
realized that for certain sections, it called for the information of one day,
and not the entire year, specifically forms 2 and 4. Thus, I had to re-create
the duration.html and illumination.html files. I also had to recode the query
and the java code in the servlet to fix this.

In the beginning of the project, I didn't understand javascript or how it was
used to change input. I had to restart the project several times, because I
kept changing the javascript files used in the project. In the web forums, one
classmate and suggested the use of moment.js. I spent much time trying to figure
out how it worked, because other students affirmed its benefit. Unfortunately,
it ended up just being a big waste of time, since I couldn't understand it, and
I ended up scrapping it for simpler code.

I wanted a clean look, but something with enough information so that the user 
knows how to input parameters for the forms. Each form also contains a brief
description, modified from the description on the USNO website. I originally
wanted the results to be output into a DIV, but I didn't get around to doing
that. Instead, I was able to simply output it using the PrintWriter, and keep
the original formatting of the website, so it simulates an updated DIV.

The CSS file that I'm using is actually from another website which I manage. It
was much easier to just use this file that I had already created, and modify it
for use with this project.

The background image was retrieved from a site that hosts free-for-use images.

You'll notice that there is a dysfunctional "Search" bar at the bottom. Again,
it's there from the website I borrowed. Even though it doesn't work, it sends
the user to a page saying so. I want to keep it there because I think it makes
the site's overall appearance nicer than without it.

    Servlet

This project was a monster. I had much to learn, especially with how information
is passed from a website into a servlet, how to use that info, how to contact
another website from a servlet, how to retrieve new data and parse it into
something usable, and how to output the desired data from the retrieved data
onto the original website. What a doozy.     

I decided not to create any additional classes besides the ones provided by the
professor (DBConnection and OracleConnection), and the servlet class. In doing
this, the servlet java file was enormous (almost 1400 lines!), but it kept 
things simpler for me. The only difficult part was knowing where to scroll in
order to get to the section I needed.

The servlet works like so:

1. Init, connect to the database, create variables to keep track of tables.
2. Get user input.
3. Set up the connection, and print out the HTML (so it looks nice).
4. Analyze the input to figure out which form the user sent data from.
5. Output the input info so the user has what he or she entered.
6. Create a table name for the query and a URL to access USNO's site.
7. Query the Database to see if the table exists. 
8. If it exists, print it out.
9. If it doesn't exist, prepare to create the table.
10. Query the USNO website and get the data.
11. Check for how many tables exist.
12. If 10 tables exist, delete the table which is oldest; move tables up queue.
13. Create the table, and place its name into back of the queue.
14. Increment the table counter.
15. Parse through the data for what is desired and insert it into the table.
16. Output the table.

    Dropping Tables

I decided to create two variables and a function that would keep track of tables
created. One variable is just an integer, which keeps track of the number of
tables. The other variable is a String array, which houses the names of each 
table that is created. Before a table is created, the checkTables function is
called, which updates the tableCount variable, and checks if it equals 10. If
so, then the very first table in the tableList array is dropped, and each
element in the array is moved forward. The tableCount is decremented, and this
determines which index the new table name is inserted into. Note: when outside
the checkTables function, the tableCount is always one less than the actual
number of tables that exist. This is because it represents the index in which a
table is to be inserted. For example, in the beginning, there are 0 tables, so
its count is 0. A table is created and its name is placed in the array, in 
index 0. When a new table is created, the checkTables function is called, which
will increment the tableCount to 1 and return that value. The new table's name
will then be inserted into index 1. The tableCount variable will not be updated
until a new table needs to be created.

    Other Notes
    
I was hoping to be able to use much of my code from Project 1, such as the 
parsing of the data, converting it from Military Time, and outputting the data.
Unfortunately, I used almost none of it, because the manner in which I parsed 
though the data was completely different. In Project 1, I used a scanner. Here,
however, I used a buffered reader. Now that I've used both, I can see that
either can work, but it just changes how things are done. For example, in one
form, I had to use Split to separate an entire line because of HTML code between
desired values. But in other ones, I used substring after just reading a full
line.