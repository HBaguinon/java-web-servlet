<!--/
********************************************************************************
* NAME: HAROLD DANE C. BAGUINON                                                *
* DATE: 12/10/2015                                                             *
* DATE DUE: 12/12/2015 04:00:00 PM                                             *
* COURSE: CSC521 010                                                           *
* PROFESSOR: DR. SPIEGEL                                                       *
* PROJECT: #4                                                                  *
* FILENAME: SunMoonServlet.jsp                                                 *
* PURPOSE: This program is the second project, but it's numbered as "3" due to *
*          Project 2 being skipped. This program is a website/servlet that will*
*          provide outputs depending on the user's selection. It can display   *
*          information on sun and moon data for one day, a duration of         *
*          lightness/darkness for one day, dates of primary phases of the moon,*
*          the fraction of the moon illuminated, or the altitude and azimuth of*
*          the sun or moon during the day. This program uses several languages *
*          and techniques, including AJAX, HTML, Java, Javascript, and PHP.    *
* Website link: http://hbagu753.kutztown.edu:8080/SunMoonInfo/index.html       *
* JAVADOC LOCATION: http://acad.kutztown.edu/~hbagu753/project4/javadoc        *
* pkill -u hbagu753 	// to reset Java if it runs out of memory.             *
*******************************************************************************/
-->

<!--// To access DB though PuTTY: sqlplus (username)/(password)@csdb.kutztown.edu:1521/orcl-->
<html>
    <head>
<%@ page 
	import = "java.io.*"
	import = "java.net.URL"
	import = "java.sql.*"
	import = "java.util.*"
	import = "java.net.URL"
	import = "java.text.DecimalFormat"
	import = "java.text.DateFormat"
	import = "java.text.SimpleDateFormat"
	import = "javax.servlet.*"
	import = "javax.servlet.http.*"
	import = "java.net.MalformedURLException" 
%>
    
        <title>SunMoonServlet</title>
    </head>
    <body>
        <div id="overall">
            <h1>USNO Sun and Moon Data</h1>
            <div id="menu">
            <ul>
              <li><a href="index.html">1. One Day</a></li>
              <li><a href="duration.html">2. Duration</a></li>
              <li><a href="phases.html">3. Phases</a></li>
              <li><a href="illumination.html">4. Illumination</a></li>
              <li><a href="azimuth.html">5. Azimuth</a></li>
            </ul>
            </div>
<%
/** SunMoonServlet is the class which contains the servlet and code for this
 *  project, as well as the file reader, the two-dimensional array object, and
 *  all of the major methods. The servlet is designed to output data from the 
 *  USNO website regarding sun and moon information at a specific date and 
 *  location, based on user input. The input is done via forms on an HTML site.
 * 
 *  @author Harold Baguinon
 *  @version 2.0 Build 1000 December 10, 2015.
 */
//  class SunMoonServlet extends HttpServlet
//{
    /** This section contains all of the info for the variables.*/
    String USERNAME = "hbagu753";
    String PASSWORD = "wr7Frath";

    Statement stmnt;
    Connection con;
    
    String table1Name;
    String monthReq;
    String dayReq;
    String yearReq;
    String cityReq;
    String stateReq;
    String baseURL1 = "http://aa.usno.navy.mil/rstt/onedaytable?";
    URL targetURL;
    
    String form1Query = "SELECT timeEvent, timeDigital FROM " + table1Name;
    
    String table2Name;
    String tableTypeReq;
    String baseURL2 = "http://aa.usno.navy.mil/cgi-bin/aa_durtablew.pl?";
    String form2Query =
       "SELECT timeDur FROM " + table2Name + " WHERE monthDur = ? AND dayDur " +
	   "= ?";
    
    String table3Name;
    String numPhasesReq;
    String baseURL3 = "http://aa.usno.navy.mil/cgi-bin/aa_phases.pl?";
    String form3Query = "SELECT moonPhase, phaseDate FROM " + table3Name;
        
    String table4Name;
    String timeZoneReq;
    String timeZoneWord;
    String baseURL4 = "http://aa.usno.navy.mil/cgi-bin/aa_moonill2.pl?";
    String form4Query =
       "SELECT fracMoon FROM " + table4Name + " WHERE monthFrac = ? AND dayFrac " +
	   "= ?";
    
     String table5Name;
     String tabIntReq;
     String baseURL5 = "http://aa.usno.navy.mil/cgi-bin/aa_altazw.pl?";
     String form5Query = "SELECT timeAlt, Altitude, Azimuth FROM " + table5Name;
    
     int tableCount;
     String[] tableList;
    
    /**
     * This method builds a URL which is used to connect to USNO website.
     * @param monthReq      This is the monthReq data member.
     * @param dayReq        This is the dayReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param cityReq       This is the cityReq data member.
     * @param stateReq      This is the stateReq data member.
     * @param baseURL1      This is the baseURL1 data member.
     * @return targetURL    This is the new URL which was created.
     */
     URL buildURL1(String monthReq, String dayReq, String yearReq,
                          String cityReq, String stateReq, String baseURL1) 
                          throws MalformedURLException
    {
        String tempURL = baseURL1 + "ID=AA" + "&year=" + yearReq + "&month=" + 
                    monthReq + "&day=" + dayReq + "&state=" + stateReq +
                    "&place=" + cityReq;
        targetURL = new URL(tempURL);
        return targetURL;
    }
    
    /**
     * This method creates a table name.
     * @param monthReq      This is the monthReq data member.
     * @param dayReq        This is the dayReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param cityReq       This is the cityReq data member.
     * @param stateReq      This is the stateReq data member.
     * @return table1Name    This is the new table name which was created.
     */
     String buildTable1Name(String monthReq, String dayReq, String yearReq,
                          String cityReq, String stateReq)
    {
        table1Name = "Table1" + monthReq + dayReq + yearReq + cityReq + stateReq;
        return table1Name;
    }
    
    /**
     * This method builds a URL which is used to connect to USNO website.
     * @param tableTypeReq  This is the tableTypeReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param cityReq       This is the cityReq data member.
     * @param stateReq      This is the stateReq data member.
     * @param baseURL2      This is the baseURL2 data member.
     * @return targetURL    This is the new URL which was created.
     */
     URL buildURL2(String tableTypeReq, String yearReq,
                          String cityReq, String stateReq, String baseURL2) 
                          throws MalformedURLException
    { 
        String tempURL = baseURL2 + "form=1" + "&year=" + yearReq + "&task=" +
                         tableTypeReq + "&state=" + stateReq + "&place=" + cityReq;
        targetURL = new URL(tempURL);
        return targetURL;
    }
    
    /**
     * This method creates a table name.
     * @param tableTypeReq  This is the tableTypeReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param cityReq       This is the cityReq data member.
     * @param stateReq      This is the stateReq data member.
     * @return table2Name   This is the new table name which was created.
     */
     String buildTable2Name(String tableTypeReq, String yearReq, 
                          String cityReq, String stateReq)
    {
        String tableTypeWord;
        if (tableTypeReq.equals("-1"))
            tableTypeWord = "Light";
        else
            tableTypeWord = "Dark";
        table2Name = "Table2" + tableTypeWord + yearReq + cityReq + stateReq;
        return table2Name;
    }
    
    /**
     * This method builds a URL which is used to connect to USNO website.
     * @param tableTypeReq  This is the tableTypeReq data member.
     * @param monthReq      This is the monthReq data member.
     * @param dayReq        This is the dayReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param numPhasesReq  This is the numPhasesReq data member.
     * @param baseURL3      This is the baseURL3 data member.
     * @return targetURL    This is the new URL which was created.
     */
     URL buildURL3(String tableTypeReq, String monthReq, String dayReq, 
                         String yearReq, String numPhasesReq, String baseURL3)
                          throws MalformedURLException
    {
        String tempURL = baseURL3 + "year=" + yearReq + "&month=" + monthReq +
                         "&day=" + dayReq + "&nump=" + numPhasesReq + "&format=" +
                          tableTypeReq;
        targetURL = new URL(tempURL);
        return targetURL;
    }
    
    /**
     * This method creates a table name.
     * @param tableTypeReq  This is the tableTypeReq data member.
     * @param monthReq      This is the monthReq data member.
     * @param dayReq        This is the dayReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param numPhasesReq  This is the numPhasesReq data member.
     * @return table3Name    This is the new table name which was created.
     */
     String buildTable3Name(String tableTypeReq, String monthReq, String dayReq, 
                                    String yearReq, String numPhasesReq)
    {
        table3Name = "Table3" + tableTypeReq + monthReq + dayReq + yearReq + numPhasesReq;
        return table3Name;
    }
    
    /**
     * This method builds a URL which is used to connect to USNO website.
     * @param tableTypeReq  This is the tableTypeReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param timeZoneReq  This is the timeZoneReq data member.
     * @param baseURL4      This is the baseURL4 data member.
     * @return targetURL    This is the new URL which was created.
     */
     URL buildURL4(String tableTypeReq, String yearReq,
                          String timeZoneReq, String baseURL4) 
                          throws MalformedURLException
    { 
        String tempURL = baseURL4 + "form=1" + "&year=" + yearReq + "&task=" +
                         tableTypeReq + "&tz=" + timeZoneReq;
        targetURL = new URL(tempURL);
        return targetURL;
    }
    
    /**
     * This method creates a table name.
     * @param tableTypeReq  This is the tableTypeReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param timeZoneReq  This is the timeZoneReq data member.
     * @return table4Name    This is the new table name which was created.
     */
     String buildTable4Name(String tableTypeReq, String yearReq, 
                          String timeZoneReq, String timeZoneWord)
    {
        String tableTypeWord;
        
        if (tableTypeReq.equals("00"))
            tableTypeWord = "Night";
        else
            tableTypeWord = "Noon";
        
        if (timeZoneReq.equals("+00"))
            timeZoneWord = "UT";
        else if (timeZoneReq.equals("-04"))
            timeZoneWord = "AST";
        else if (timeZoneReq.equals("-05"))
            timeZoneWord = "EST";
        else if (timeZoneReq.equals("-06"))
            timeZoneWord = "CST";
        else if (timeZoneReq.equals("-07"))
            timeZoneWord = "MST";
        else if (timeZoneReq.equals("-08"))
            timeZoneWord = "PST";
        else if (timeZoneReq.equals("-09"))
            timeZoneWord = "ALST";
        else if (timeZoneReq.equals("-10"))
            timeZoneWord = "HAST";
        else if (timeZoneReq.equals("-11"))
            timeZoneWord = "SST";
        else if (timeZoneReq.equals("+10"))
            timeZoneWord = "CHST";
        
        table4Name = "Table4" + tableTypeWord + yearReq + timeZoneWord;
        return table4Name;
    }
    
    /**
     * This method builds a URL which is used to connect to USNO website.
     * @param tableTypeReq  This is the tableTypeReq data member.
     * @param monthReq      This is the monthReq data member.
     * @param dayReq        This is the dayReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param tabIntReq     This is the tabIntReq data member.
     * @param cityReq       This is the cityReq data member.
     * @param stateReq      This is the stateReq data member.
     * @param baseURL5      This is the baseURL5 data member.
     * @return targetURL    This is the new URL which was created.
     */
     URL buildURL5(String tableTypeReq, String monthReq, String dayReq, 
                         String yearReq, String tabIntReq, String cityReq, 
                         String stateReq, String baseURL5)
                          throws MalformedURLException
    {  
        String tempURL = baseURL5 + "form=1" + "&body=" + tableTypeReq + "&year=" +
        yearReq + "&month=" + monthReq + "&day=" + dayReq + "&intv_mag=" + tabIntReq +
        "&state=" + stateReq + "&place=" + cityReq;
        targetURL = new URL(tempURL);
        return targetURL;
    }
    
    /**
     * This method creates a table name.
     * @param tableTypeReq  This is the tableTypeReq data member.
     * @param monthReq      This is the monthReq data member.
     * @param dayReq        This is the dayReq data member.
     * @param yearReq       This is the yearReq data member.
     * @param tabIntReq     This is the tabIntReq data member.
     * @param cityReq       This is the cityReq data member.
     * @param stateReq      This is the stateReq data member.
     * @return table5Name    This is the new table name which was created.
     */
     String buildTable5Name(String tableTypeReq, String monthReq, String dayReq, 
                                    String yearReq, String tabIntReq, String cityReq,
                                    String stateReq)
    {
        table5Name = "Table5" + tableTypeReq + monthReq + dayReq + yearReq + tabIntReq +
                         cityReq + stateReq;
        return table5Name;
    }
    
    // Need to open DB connection here. In doPost, it would close at end of fn
    /**
     * This method is init. It is run when the servlet is first accessed.
     * @param config    This is the Servlet Configuration.
     */
     void init(ServletConfig config)  throws ServletException
    {     super.init(config);
        // Set up JDBC stuff
        try { // Get a connection
            con = new OracleConnection().getConnection(USERNAME,PASSWORD);
            tableList = new String[10];
            tableCount = 0;
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * This method creates a table by parsing through data from the USNO
     * website, and inserts the data into the table in the database.
     * @param toClient      This is used for printing output.
     * @param targetURL     This is the URL which will be used for the query.
     * @param res           This is the HTTP Servlet Response.
     */
	 void createForm1Table(PrintWriter toClient, URL targetURL, HttpServletResponse res) throws java.io.IOException
    {
        toClient = res.getWriter();
        InputStream stream = null;
        
        try { // Hook up to the file on the server
            stream = targetURL.openStream();
        }
        catch (Exception e)  {
            e.printStackTrace();
            System.err.println("!! Stream open failed !!");
        }
        BufferedReader Inf = null;
        try {
            Inf = new BufferedReader(new InputStreamReader(stream));
        }
        catch (Exception e){
            e.printStackTrace();
        }
        int next;
        next=Inf.read();
        for (int i = 0; i < 80; i++)
        {
            Inf.readLine();
        }
            
        /*
        while (next>=0) {
        toClient.print((char)next);
        next=Inf.read();
        }   */ 
    
        // Set up JDBC stuff
        Statement stmnt;
        try {
            Connection con = new OracleConnection().getConnection(USERNAME, PASSWORD);
            stmnt=con.createStatement();
            // Need to use unique names (Area messed things up!)
            String createString = "CREATE TABLE " + table1Name + " (timeEvent VARCHAR2(30), "+
                      "timeDigital VARCHAR2(30))";
            // toClient.println("tableCount before: " + tableCount);
            tableCount = checkTables(tableCount, tableList, toClient);
            tableList[tableCount] = table1Name;
            stmnt.executeUpdate(createString);
            // toClient.println("tableCount after: " + tableCount);
            // toClient.println("Table Name Array: " + Arrays.toString(tableList));
            toClient.println("<TABLE Caption=\"Query Results\" " +
                "align=\"center\" cellspacing=20><TR><TH>Event</TH><TH>"+
                "Time</TH></TR>");
            for (int idx = 0; idx < 8; idx++) {
                String preSplit = new String(Inf.readLine());
                String[] splitOne = preSplit.split(">");
                String[] splitTwo1 = splitOne[2].split("<");
                String[] splitTwo2 = splitOne[4].split("<");
                // toClient.print(splitTwo1[0] + ": " + splitTwo2[0] + " <BR>");
                // Form the string representing the insertion statement for this state
                // Note use of ' to delimit strings in the SQL statement
                String InsertForm1String = ("INSERT INTO " + table1Name + " VALUES('" +
                   splitTwo1[0] + "', '" + splitTwo2[0] + "')");
                
                //toClient.println(splitTwo1[0] + ": " + splitTwo2[0] + " <BR>");
                
                toClient.println("<TR><TD>"+splitTwo1[0] + ": "+"</TD><TD>"+
                            splitTwo2[0] + "</TD></TR>");
                
                stmnt.executeUpdate(InsertForm1String);
            } // for
            toClient.println("</TABLE>");
            
            // We can remove the table (use when table needs to go)
            // String dropTable1Name = "DROP TABLE" + table1Name;
            // stmnt.executeUpdate(dropTable1Name);
            stmnt.close();
            }
        catch (Exception e) {
          toClient.println("Database table create error:"+e+"<BR>");
        }
        
    }
    
    /**
     * This method creates a table by parsing through data from the USNO
     * website, and inserts the data into the table in the database.
     * @param toClient      This is used for printing output.
     * @param targetURL     This is the URL which will be used for the query.
     * @param res           This is the HTTP Servlet Response.
     */
     void createForm2Table(PrintWriter toClient, URL targetURL, HttpServletResponse res) throws java.io.IOException
    {
        toClient = res.getWriter();
        InputStream stream = null;
        
        try { // Hook up to the file on the server
            stream = targetURL.openStream();
        }
        catch (Exception e)  {
            e.printStackTrace();
            System.err.println("!! Stream open failed !!");
        }
        BufferedReader Inf = null;
        try {
            Inf = new BufferedReader(new InputStreamReader(stream));
        }
        catch (Exception e){
            e.printStackTrace();
        }
        int next;
        next=Inf.read();
        for (int i = 0; i < 18; i++)
        {
            Inf.readLine();
        }
            
        /*
        while (next>=0) {
        toClient.print((char)next);
        next=Inf.read();
        }   */ 
    
        // Set up JDBC stuff
        Statement stmnt;
        try {
            Connection con = new OracleConnection().getConnection(USERNAME, PASSWORD);
            stmnt=con.createStatement();
            // Need to use unique names (Area messed things up!)
            String createString = "CREATE TABLE " + table2Name + " (timeDur VARCHAR2(30), " +
                      "monthDur VARCHAR2(15), dayDur VARCHAR2(15))";
            // toClient.println("createString: " + createString);
            tableCount = checkTables(tableCount, tableList, toClient);
            tableList[tableCount] = table2Name;
            stmnt.executeUpdate(createString);
            
            //toClient.println("<TABLE Caption=\"Query Results\" " +
            //    "align=\"center\" cellspacing=20><TR><TH>Duration (hh:mm): </TH></TR>");
            for (int idx = 0; idx < 32; idx++) {
                String preSplit = new String(Inf.readLine());
                String[] splitOne = new String[] {preSplit.substring(8, 13),
                    preSplit.substring(17, 22),
                    preSplit.substring(26, 31),
                    preSplit.substring(35, 40),
                    preSplit.substring(44, 49),
                    preSplit.substring(53, 58),
                    preSplit.substring(62, 67),
                    preSplit.substring(71, 76),
                    preSplit.substring(80, 85),
                    preSplit.substring(89, 94),
                    preSplit.substring(98, 103),
                    preSplit.substring(107, 112)
                };
                //toClient.print(Arrays.toString(splitOne));
                //toClient.print("<BR>");
                // Form the string representing the insertion statement for this state
                // Note use of ' to delimit strings in the SQL statement
                
                for (int m = 1; m < 13; m++)
                {
                    String InsertForm2String = "INSERT INTO " + table2Name + " VALUES('" +
                       splitOne[(m-1)] + "', '" + Integer.toString(m) + "', '" + 
                       Integer.toString((idx+1)) + "')";
                    stmnt.executeUpdate(InsertForm2String);
                }
                //toClient.println(splitTwo1[0] + ": " + splitTwo2[0] + " <BR>");
                
                //toClient.println("<TR><TD>"+splitTwo1[0] + ": "+"</TD><TD>"+
                //            splitTwo2[0] + "</TD></TR>");
                
            } // for
            
            //toClient.println("</TABLE>");
            
            // We can remove the table (use when table needs to go)
            // String dropTable1Name = "DROP TABLE" + table1Name;
            // stmnt.executeUpdate(dropTable1Name);
            stmnt.close();
        }
        catch (Exception e) {
          toClient.println("Database table create error:"+e+"<BR>");
        }
    }
    
    /**
     * This method creates a table by parsing through data from the USNO
     * website, and inserts the data into the table in the database.
     * @param toClient      This is used for printing output.
     * @param targetURL     This is the URL which will be used for the query.
     * @param res           This is the HTTP Servlet Response.
     */
     void createForm3Table(PrintWriter toClient, URL targetURL, HttpServletResponse res) throws java.io.IOException
    {
        toClient = res.getWriter();
        InputStream stream = null;
        
        try { // Hook up to the file on the server
            stream = targetURL.openStream();
        }
        catch (Exception e)  {
            e.printStackTrace();
            System.err.println("!! Stream open failed !!");
        }
        BufferedReader Inf = null;
        try {
            Inf = new BufferedReader(new InputStreamReader(stream));
        }
        catch (Exception e){
            e.printStackTrace();
        }
        int next;
        next=Inf.read();
        for (int i = 0; i < 51; i++)
        {
            Inf.readLine();
        }
            
        /*
        while (next>=0) {
        toClient.print((char)next);
        next=Inf.read();
        }   */ 
    
        // Set up JDBC stuff
        Statement stmnt;
        try {
            Connection con = new OracleConnection().getConnection(USERNAME, PASSWORD);
            stmnt=con.createStatement();
            // Need to use unique names (Area messed things up!)
            String createString = "CREATE TABLE " + table3Name + " (moonPhase VARCHAR2(30), "+
                      "phaseDate VARCHAR2(30))";
            tableCount = checkTables(tableCount, tableList, toClient);
            tableList[tableCount] = table3Name;
            stmnt.executeUpdate(createString);
            
            toClient.println("<TABLE Caption=\"Query Results\" " +
                "align=\"center\" cellspacing=20><TR><TH>Moon Phase</TH><TH>"+
                "Date</TH></TR>");
            for (int idx = 0; idx < 4; idx++) {
                String preSplit = new String(Inf.readLine());
                String[] splitOne = preSplit.split(">");
                String[] splitTwo = splitOne[1].split("<");
                String phaseDateString = new String(Inf.readLine());
                String phaseDateSubstring = phaseDateString.substring(7, 18);
                // toClient.print(splitTwo1[0] + ": " + splitTwo2[0] + " <BR>");
                // Form the string representing the insertion statement for this state
                // Note use of ' to delimit strings in the SQL statement
                String InsertForm3String = ("INSERT INTO " + table3Name + " VALUES('" +
                   splitTwo[0] + "', '" + phaseDateSubstring + "')");
                Inf.readLine();
                //toClient.println(splitTwo1[0] + ": " + splitTwo2[0] + " <BR>");
                
                toClient.println("<TR><TD>" + splitTwo[0] + "</TD><TD>" +
                            phaseDateSubstring + "</TD></TR>");
                
                stmnt.executeUpdate(InsertForm3String);
            } // for
            toClient.println("</TABLE>");
            
            // We can remove the table (use when table needs to go)
            // String dropTable1Name = "DROP TABLE" + table1Name;
            // stmnt.executeUpdate(dropTable1Name);
            stmnt.close();
            }
        catch (Exception e) {
          toClient.println("Database table create error:"+e+"<BR>");
        }
    }
    
    /**
     * This method creates a table by parsing through data from the USNO
     * website, and inserts the data into the table in the database.
     * @param toClient      This is used for printing output.
     * @param targetURL     This is the URL which will be used for the query.
     * @param res           This is the HTTP Servlet Response.
     */
     void createForm4Table(PrintWriter toClient, URL targetURL, HttpServletResponse res) throws java.io.IOException
    {
        toClient = res.getWriter();
        InputStream stream = null;
        try { // Hook up to the file on the server
            stream = targetURL.openStream();
        }
        catch (Exception e)  {
            e.printStackTrace();
            System.err.println("!! Stream open failed !!");
        }
        BufferedReader Inf = null;
        try {
            Inf = new BufferedReader(new InputStreamReader(stream));
        }
        catch (Exception e){
            e.printStackTrace();
        }
        int next;
        next=Inf.read();
        for (int i = 0; i < 17; i++)
        {
            Inf.readLine();
        }
          
        // Set up JDBC stuff
        Statement stmnt;
        try {
            Connection con = new OracleConnection().getConnection(USERNAME, PASSWORD);
            stmnt=con.createStatement();
            // Need to use unique names (Area messed things up!)
            String createString = "CREATE TABLE " + table4Name + " (fracMoon VARCHAR2(30), " +
                      "monthFrac VARCHAR2(15), dayFrac VARCHAR2(15))";
            // toClient.println("createString: " + createString);
            tableCount = checkTables(tableCount, tableList, toClient);
            tableList[tableCount] = table4Name;
            stmnt.executeUpdate(createString);
            
            //toClient.println("<TABLE Caption=\"Query Results\" " +
            //    "align=\"center\" cellspacing=20><TR><TH>Duration: </TH></TR>");
            for (int idx = 0; idx < 32; idx++) {
                String preSplit = new String(Inf.readLine());
                //toClient.print("preSplit: " + preSplit);
                String[] splitOne = new String[] {preSplit.substring(8, 12),
                preSplit.substring(17, 21),
                preSplit.substring(26, 30),
                preSplit.substring(35, 39),
                preSplit.substring(44, 48),
                preSplit.substring(53, 57),
                preSplit.substring(62, 66),
                preSplit.substring(71, 75),
                preSplit.substring(80, 84),
                preSplit.substring(89, 93),
                preSplit.substring(98, 102),
                preSplit.substring(107, 111)
                };
                
                
                // Form the string representing the insertion statement for this state
                // Note use of ' to delimit strings in the SQL statement
                
                for (int m = 1; m < 13; m++)
                {
                    String InsertForm4String = "INSERT INTO " + table4Name + " VALUES('" +
                       splitOne[(m-1)] + "', '" + Integer.toString(m) + "', '" + 
                       Integer.toString((idx+1)) + "')";
                    stmnt.executeUpdate(InsertForm4String);
                }
                //toClient.println(splitTwo1[0] + ": " + splitTwo2[0] + " <BR>");
                
                //toClient.println("<TR><TD>"+splitTwo1[0] + ": "+"</TD><TD>"+
                //            splitTwo2[0] + "</TD></TR>");
                
            } // for
            
            //toClient.println("</TABLE>");
            
            // We can remove the table (use when table needs to go)
            // String dropTable1Name = "DROP TABLE" + table1Name;
            // stmnt.executeUpdate(dropTable1Name);
            stmnt.close();
        }
        catch (Exception e) {
          toClient.println("Database table create error:"+e+"<BR>");
        }
    }
    
    /**
     * This method creates a table by parsing through data from the USNO
     * website, and inserts the data into the table in the database.
     * @param toClient      This is used for printing output.
     * @param targetURL     This is the URL which will be used for the query.
     * @param res           This is the HTTP Servlet Response.
     */
     void createForm5Table(PrintWriter toClient, URL targetURL, HttpServletResponse res) throws java.io.IOException
    {
        toClient = res.getWriter();
        InputStream stream = null;
        
        try { // Hook up to the file on the server
            stream = targetURL.openStream();
        }
        catch (Exception e)  {
            e.printStackTrace();
            System.err.println("!! Stream open failed !!");
        }
        BufferedReader Inf = null;
        try {
            Inf = new BufferedReader(new InputStreamReader(stream));
        }
        catch (Exception e){
            e.printStackTrace();
        }
        int next;
        next=Inf.read();
        for (int i = 0; i < 28; i++)
        {
            Inf.readLine();
        }
            
        /*
        while (next>=0) {
        toClient.print((char)next);
        next=Inf.read();
        }   */ 
    
        // Set up JDBC stuff
        Statement stmnt;
        try {
            Connection con = new OracleConnection().getConnection(USERNAME, PASSWORD);
            stmnt=con.createStatement();
            // Need to use unique names (Area messed things up!)
            if (tableTypeReq.equals("10"))
            {
                String createString = "CREATE TABLE " + table5Name + " (timeAlt VARCHAR2(15), " +
                    "Altitude VARCHAR2(15), " + "Azimuth VARCHAR2(15))";
                tableCount = checkTables(tableCount, tableList, toClient);
                tableList[tableCount] = table5Name;
                stmnt.executeUpdate(createString);
            }
            else if (tableTypeReq.equals("11"))
            {
                String createString = "CREATE TABLE " + table5Name + " (timeAlt VARCHAR2(15), " +
                    "Altitude VARCHAR2(15), Azimuth VARCHAR2(15), fracMoon VARCHAR2(15))";
                tableCount = checkTables(tableCount, tableList, toClient);
                tableList[tableCount] = table5Name;
                stmnt.executeUpdate(createString);
            }
            
            if (tableTypeReq.equals("10"))
            {
                String line;
                while ((line = Inf.readLine()) != null) {
                    // String preSplit = new String(Inf.readLine());
                    String[] splitOne = new String[] {line.substring(0, 5),
                    line.substring(11, 16),
                    line.substring(23, 28)
                    };
                    // toClient.println("splitOne[0] Pre: " + splitOne[0]);
                    String newTime = MilitaryTime(splitOne[0]);
                    // toClient.println("newTime Post: " + newTime);
                    // Form the string representing the insertion statement for this state
                    // Note use of ' to delimit strings in the SQL statement
                    
                    String InsertForm5String = ("INSERT INTO " + table5Name + " VALUES('" +
                       newTime + "', '" + splitOne[1] + "', '" + splitOne[2] + "')");
                    
                    //toClient.println("<TR><TD>" + splitOne[0] + "</TD><TD>" +
                    //   splitOne[1] + "</TD><TD>" + splitOne[2] + "</TD></TR>");
                    
                    stmnt.executeUpdate(InsertForm5String);
                } // for
                
            }
            else if (tableTypeReq.equals("11"))
            {
                String line;
                while ((line = Inf.readLine()) != null) {
                    // String preSplit = new String(Inf.readLine());
                    String[] splitOne = new String[] {line.substring(0, 5),
                    line.substring(11, 16),
                    line.substring(23, 28),
                    line.substring(35, 39)
                    };
                    String newTime = MilitaryTime(splitOne[0]);
                    // Form the string representing the insertion statement for this state
                    // Note use of ' to delimit strings in the SQL statement
                    
                    String InsertForm5String = ("INSERT INTO " + table5Name + " VALUES('" +
                       newTime + "', '" + splitOne[1] + "', '" + splitOne[2] +
                       "', '" + splitOne[3] + "')");
                    
                   // toClient.println("<TR><TD>" + splitOne[0] + "</TD><TD>" +
                   //    splitOne[1] + "</TD><TD>" + splitOne[2] + "</TD><TD>" +
                   //    splitOne[3] + "</TD></TR>");
                    
                    stmnt.executeUpdate(InsertForm5String);
                } // for
                
            }
            
            // We can remove the table (use when table needs to go)
            // String dropTable1Name = "DROP TABLE" + table1Name;
            // stmnt.executeUpdate(dropTable1Name);
            stmnt.close();
            }
        catch (Exception e) {
          toClient.println("Database table create error:"+e+"<BR>");
        }
        
    }
    
    /**
     * This method is doGet. It runs when the user submits input. It is passed
     * into the doPost method.
     * @param req           This is the HTTP Servlet Request.
     * @param res           This is the HTTP Servlet Response.
     */
     void doGet(HttpServletRequest req, HttpServletResponse res)
					throws ServletException, IOException
    {doPost(req,res);
    }

    /**
     * This method is doPost. It handles the request. First it creates a 
     * PrintWriter and makes a connection with the oracle database. It prints
     * out HTML for the results for aesthetics. It analyzes user input to
     * determine which form was used. It then queries the database to check if
     * the table exists. If it exists, it simply outputs the data. If not, 
     * the createFormTable functions are called in order to create the table.
     * @param req           This is the HTTP Servlet Request.
     * @param res           This is the HTTP Servlet Response.
     */
     void doPost(HttpServletRequest req, HttpServletResponse res)
					throws ServletException, IOException
    {    //Get the response's PrintWriter to return text to the client.
        PrintWriter toClient = res.getWriter();
        // No matter what, set the "content type" header of the response
        res.setContentType("text/html");
        //res.getWriter().write("OUTPUT FROM THE DIV");
        
        try {
            Connection con = new OracleConnection().getConnection(USERNAME,PASSWORD);
            // Create a statement to access database
            stmnt=con.createStatement();

            toClient.println("<html><head><title>CSC521 Project 3</title>");
            toClient.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"http://acad.kutztown.edu/~hbagu753/project3/style.css\" />");
            toClient.println("<script src=\"http://acad.kutztown.edu/~hbagu753/project3/script.js\" type=\"text/javascript\"/></script>");
            toClient.println("</head>");
            toClient.println("<body><!--body onload=\"initPage()\"-->");
            toClient.println("<div id=\"overall\">");
            toClient.println("<h1>USNO Sun and Moon Data</h1>");
            toClient.println("<div id=\"menu\">");
            toClient.println("<ul>");
            toClient.println("<li><a href=\"http://acad.kutztown.edu/~hbagu753/project4/index.html\">1. One Day</a></li>");
            toClient.println("<li><a href=\"http://acad.kutztown.edu/~hbagu753/project4/duration.html\">2. Duration</a></li>");
            toClient.println("<li><a href=\"http://acad.kutztown.edu/~hbagu753/project4/phases.html\">3. Phases</a></li>");
            toClient.println("<li><a href=\"http://acad.kutztown.edu/~hbagu753/project4/illumination.html\">4. Illumination</a></li>");
            toClient.println("<li><a href=\"http://acad.kutztown.edu/~hbagu753/project4/azimuth.html\">5. Azimuth</a></li>");
            toClient.println("</ul>");
            toClient.println("</div>");
            toClient.println("<div id=\"size\">");
            toClient.println("<h2> <span class=\"style3\">");
            toClient.println("<p align=\"center\">Query Results: <br />");
            toClient.println("</p>");
            toClient.println("</span></h2>");
            toClient.println("<p align=\"center\">");
            toClient.println("<center>");
            
	    String formChoice=(String)req.getParameterValues("formInput")[0];
	    toClient.println("Form Data Read in! " + "<BR>");
        
        if (formChoice.equals("formInput1")) {  // Which form?
            Form1Results(req, res, toClient);
            buildTable1Name(monthReq, dayReq, yearReq, cityReq, stateReq);
            buildURL1(monthReq, dayReq, yearReq, cityReq, stateReq, baseURL1);
            // toClient.println("TargetURL is: " + targetURL + "<BR>");
            form1Query = "SELECT timeEvent, timeDigital FROM " + table1Name;
            // test for the table exists
            try {
                PreparedStatement qStmnt=con.prepareStatement(form1Query);
                toClient.println("TABLE QUERIED!" + "<BR>");
                // Set up for test query
                ResultSet r = qStmnt.executeQuery();
                outputQuery1Results(r, toClient);
            }
            catch(SQLException e) {  // no table (likely)
                toClient.println("-SQL error: "+e+"- <BR>");
                try {   // make the table
                createForm1Table(toClient, targetURL, res);
                toClient.println("TABLE CREATED!" + "<BR>");
                }
                catch (Exception ee) {     
                toClient.println("Unspecified error creating table:"+ee);
                }    
            }
            
            // ReadWeb1(targetURL, res);
            toClient.println("</p>");
            toClient.println("</center>");
            toClient.println("</div>");
            toClient.println("</body>");
            toClient.println("</html>");
            
            // Get parameters
            //int low=Integer.parseInt(req.getParameterValues("low")[0]);
            //int high=Integer.parseInt(req.getParameterValues("hi")[0]);
         
        }
        else if (formChoice.equals("formInput2")) {
            Form2Results(req, res, toClient);
            buildTable2Name(tableTypeReq, yearReq, cityReq, stateReq);
            buildURL2(tableTypeReq, yearReq, cityReq, stateReq, baseURL2);
            // toClient.println("TargetURL is: " + targetURL + "<BR>");
            form2Query = "SELECT timeDur FROM " + table2Name +
                " WHERE monthDur = '" + monthReq + "'" + " AND dayDur = '" + 
                dayReq + "'";
    
            // test for the table exists
            try {
                PreparedStatement qStmnt=con.prepareStatement(form2Query);
                toClient.println("TABLE QUERIED!" + "<BR>");
                // Set up for test query
                ResultSet r = qStmnt.executeQuery();
                outputQuery2Results(r, toClient);
            }
            catch(SQLException e) {  // no table (likely)
                toClient.println("-SQL error: "+e+"- <BR>");
                try {   // make the table
                createForm2Table(toClient, targetURL, res);
                toClient.println("TABLE CREATED!" + "<BR>");
                PreparedStatement qStmnt=con.prepareStatement(form2Query);
                ResultSet r = qStmnt.executeQuery();
                outputQuery2Results(r, toClient);
                }
                catch (Exception ee) {     
                toClient.println("Unspecified error creating table:"+ee);
                }    
            }
            
            // ReadWeb2(targetURL, res);
            toClient.println("</p>");
            toClient.println("</center>");
            toClient.println("</div>");
            toClient.println("</body>");
            toClient.println("</html>");
        }
        else if (formChoice.equals("formInput3")) {
            Form3Results(req, res, toClient);
            buildTable3Name(tableTypeReq, monthReq, dayReq, yearReq, numPhasesReq);
            buildURL3(tableTypeReq, monthReq, dayReq, yearReq, numPhasesReq, baseURL3);
            // toClient.println("TargetURL is: " + targetURL + "<BR>");
            form3Query = "SELECT moonPhase, phaseDate FROM " + table3Name;
            // test for the table exists
            try {
                PreparedStatement qStmnt=con.prepareStatement(form3Query);
                toClient.println("TABLE QUERIED!" + "<BR>");
                // Set up for test query
                ResultSet r = qStmnt.executeQuery();
                outputQuery3Results(r, toClient);
            }
            catch(SQLException e) {  // no table (likely)
                toClient.println("-SQL error: "+e+"- <BR>");
                try {   // make the table
                createForm3Table(toClient, targetURL, res);
                toClient.println("TABLE CREATED!" + "<BR>");
                }
                catch (Exception ee) {     
                toClient.println("Unspecified error creating table:"+ee);
                }    
            }
            
            // ReadWeb1(targetURL, res);
            toClient.println("</p>");
            toClient.println("</center>");
            toClient.println("</div>");
            toClient.println("</body>");
            toClient.println("</html>");
            
        }
        else if (formChoice.equals("formInput4")) {
            Form4Results(req, res, toClient);
            buildTable4Name(tableTypeReq, yearReq, timeZoneReq, timeZoneWord);
            buildURL4(tableTypeReq, yearReq, timeZoneReq, baseURL4);
            // toClient.println("TargetURL is: " + targetURL + "<BR>");
            form4Query = "SELECT fracMoon FROM " + table4Name +
                " WHERE monthFrac = '" + monthReq + "'" + " AND dayFrac = '" + 
                dayReq + "'";
    
            // test for the table exists
            try {
                PreparedStatement qStmnt=con.prepareStatement(form4Query);
                toClient.println("TABLE QUERIED!" + "<BR>");
                // Set up for test query
                ResultSet r = qStmnt.executeQuery();
                outputQuery4Results(r, toClient);
            }
            catch(SQLException e) {  // no table (likely)
                toClient.println("-SQL error: "+e+"- <BR>");
                try {   // make the table
                createForm4Table(toClient, targetURL, res);
                toClient.println("TABLE CREATED!" + "<BR>");
                PreparedStatement qStmnt=con.prepareStatement(form4Query);
                ResultSet r = qStmnt.executeQuery();
                outputQuery4Results(r, toClient);
                }
                catch (Exception ee) {     
                toClient.println("Unspecified error creating table:"+ee);
                }    
            }
            
            // ReadWeb4(targetURL, res);
            toClient.println("</p>");
            toClient.println("</center>");
            toClient.println("</div>");
            toClient.println("</body>");
            toClient.println("</html>");
        }
        else if (formChoice.equals("formInput5")) {
            Form5Results(req, res, toClient);
            buildTable5Name(tableTypeReq, monthReq, dayReq, yearReq, tabIntReq, 
                              cityReq, stateReq);
            buildURL5(tableTypeReq, monthReq, dayReq, yearReq, tabIntReq, cityReq, 
                         stateReq, baseURL5);
            // toClient.println("TargetURL is: " + targetURL + "<BR>");
            if (tableTypeReq.equals("10"))
                form5Query = "SELECT timeAlt, Altitude, Azimuth FROM " + table5Name;
            else if (tableTypeReq.equals("11"))
                form5Query = "SELECT timeAlt, Altitude, Azimuth, fracMoon FROM " +
                                table5Name;
            // test for the table exists
            try {
                PreparedStatement qStmnt=con.prepareStatement(form5Query);
                toClient.println("TABLE QUERIED!" + "<BR>");
                // Set up for test query
                ResultSet r = qStmnt.executeQuery();
                outputQuery5Results(r, toClient);
            }
            catch(SQLException e) {  // no table (likely)
                toClient.println("-SQL error: "+e+"- <BR>");
                try {   // make the table
                createForm5Table(toClient, targetURL, res);
                toClient.println("TABLE CREATED!" + "<BR>");
                PreparedStatement qStmnt=con.prepareStatement(form5Query);
                ResultSet r = qStmnt.executeQuery();
                outputQuery5Results(r, toClient);
                }
                catch (Exception ee) {     
                toClient.println("Unspecified error creating table:"+ee);
                }    
            }
            
            // ReadWeb4(targetURL, res);
            toClient.println("</p>");
            toClient.println("</center>");
            toClient.println("</div>");
            toClient.println("</body>");
            toClient.println("</html>");
        }
        // Close the statement
        stmnt.close();
        }
        catch (Exception e) {
            toClient.println(stmnt+"Unspecified error:"+e+" 2 <BR>");
        }
    }
    
    /**
     * This method takes the results from the form and passes them into 
     * variables for use by the servlet, such as URL creation and queries.
     * @param req           This is the HTTP Servlet Request.
     * @param res           This is the HTTP Servlet Response.
     * @param toClient      This is used for printing output.
     */
     void Form1Results(HttpServletRequest req, HttpServletResponse res, PrintWriter toClient) 
                    throws java.io.IOException
    {
        toClient.println("<TABLE Caption=\"Query Results\" " +
        "align=\"center\" cellspacing=20><TR><TH>Parameters</TH><TH>"+
        "Results</TH></TR>");
        monthReq = req.getParameterValues("monthSelect")[0];
        toClient.println("<TR><TD>Month is:</TD><TD>" + monthReq + "</TD></TR>");
        dayReq = req.getParameterValues("daySelect")[0];
        toClient.println("<TR><TD>Day is:</TD><TD>" + dayReq + "</TD></TR>");
        yearReq = req.getParameterValues("yearEntry")[0];
        toClient.println("<TR><TD>Year is:</TD><TD>" + yearReq + "</TD></TR>");
        cityReq = req.getParameterValues("location")[0];
        toClient.println("<TR><TD>City is:</TD><TD>" + cityReq + "</TD></TR>");
        stateReq = req.getParameterValues("st")[0];
        toClient.println("<TR><TD>State is:</TD><TD>" + stateReq + "</TD></TR>");
        
    }
    
    /**
     * This method was only used for parsing and outputting the data before the
     * database was used. It only outputs results; it does not create tables.
     * In theory, this method can be used if the database server is down.
     * @param targetURL     This is the URL which will be used for the query.
     * @param res           This is the HTTP Servlet Response.
     */
    // Used before using Database/SQL. Queries into direct output on website.
     void ReadWeb1(URL targetURL, HttpServletResponse res) throws java.io.IOException
    {
     PrintWriter toClient = res.getWriter();
     InputStream stream = null;
     try { // Hook up to the file on the server
       stream = targetURL.openStream();
     }
     catch (Exception e)  {
       e.printStackTrace();
       System.err.println("!! Stream open failed !!");
     }
     BufferedReader Inf = null;
     try {
       Inf = new BufferedReader(new InputStreamReader(stream));
     }
     catch (Exception e){
       e.printStackTrace();
     }
     int next;
     next=Inf.read();
     for (int i = 0; i < 80; i++)
     {
         Inf.readLine();
     }
     for (int i = 0; i < 8; i++)
     {
         String preSplit = new String(Inf.readLine());
         //toClient.print("preSplit: " + preSplit);
         String[] splitOne = preSplit.split(">");
         //toClient.print("Split 1: " + Arrays.toString(splitOne));
         String[] splitTwo1 = splitOne[2].split("<");
         String[] splitTwo2 = splitOne[4].split("<");
         toClient.print(splitTwo1[0] + ": " + splitTwo2[0] + " <BR>");
         /*String[] splitTwo = splitOne.split(">");
         toClient.print("Split 2: " + Arrays.toString(splitTwo));
         */
     }
     
     /*
     while (next>=0) {
       toClient.print((char)next);
       next=Inf.read();
     } */ 
    }
    
    /**
     * This method takes the results from the form and passes them into 
     * variables for use by the servlet, such as URL creation and queries.
     * @param req           This is the HTTP Servlet Request.
     * @param res           This is the HTTP Servlet Response.
     * @param toClient      This is used for printing output.
     */
     void Form2Results(HttpServletRequest req, HttpServletResponse res, PrintWriter toClient) 
                    throws java.io.IOException
    {   
        toClient.println("<TABLE Caption=\"Query Results\" " +
        "align=\"center\" cellspacing=20><TR><TH>Parameters</TH><TH>"+
        "Results</TH></TR>");
        tableTypeReq = req.getParameterValues("tableType")[0];
        toClient.println("<TR><TD>Type of Table is:</TD><TD>" + tableTypeReq + "</TD></TR>");
        monthReq = req.getParameterValues("monthSelect")[0];
        toClient.println("<TR><TD>Month is:</TD><TD>" + monthReq + "</TD></TR>");
        dayReq = req.getParameterValues("daySelect")[0];
        toClient.println("<TR><TD>Day is:</TD><TD>" + dayReq + "</TD></TR>");
        yearReq = req.getParameterValues("yearEntry")[0];
        toClient.println("<TR><TD>Year is:</TD><TD>" + yearReq + "</TD></TR>");
        cityReq = req.getParameterValues("location")[0];
        toClient.println("<TR><TD>City is:</TD><TD>" + cityReq + "</TD></TR>");
        stateReq = req.getParameterValues("st")[0];
        toClient.println("<TR><TD>State is:</TD><TD>" + stateReq + "</TD></TR>");
    }
    
    /**
     * This method was only used for parsing and outputting the data before the
     * database was used. It only outputs results; it does not create tables.
     * In theory, this method can be used if the database server is down.
     * @param targetURL     This is the URL which will be used for the query.
     * @param res           This is the HTTP Servlet Response.
     */
     void ReadWeb2(URL targetURL, HttpServletResponse res) throws java.io.IOException
    {
     PrintWriter toClient = res.getWriter();
     InputStream stream = null;
     try { // Hook up to the file on the server
       stream = targetURL.openStream();
     }
     catch (Exception e)  {
       e.printStackTrace();
       System.err.println("!! Stream open failed !!");
     }
     BufferedReader Inf = null;
     try {
       Inf = new BufferedReader(new InputStreamReader(stream));
     }
     catch (Exception e){
       e.printStackTrace();
     }
     int next;
     next=Inf.read();
     for (int i = 0; i < 18; i++)
     {
         Inf.readLine();
     }
     for (int i = 0; i < 31; i++)
     {
         String preSplit = new String(Inf.readLine());
         //toClient.print("preSplit: " + preSplit);
         String[] splitOne = new String[] {preSplit.substring(8, 13),
            preSplit.substring(17, 22),
            preSplit.substring(26, 31),
            preSplit.substring(35, 40),
            preSplit.substring(44, 49),
            preSplit.substring(53, 58),
            preSplit.substring(62, 67),
            preSplit.substring(71, 76),
            preSplit.substring(80, 85),
            preSplit.substring(89, 94),
            preSplit.substring(98, 103),
            preSplit.substring(107, 112)
         };
         //toClient.print("Split 1: " + Arrays.toString(splitOne));
         toClient.print(Arrays.toString(splitOne));
         toClient.print("<BR>");
         /*String[] splitTwo = splitOne.split(">");
         toClient.print("Split 2: " + Arrays.toString(splitTwo));
         */
     }
     
     /*
     while (next>=0) {
       toClient.print((char)next);
       next=Inf.read();
     } */ 
    }
    
    /**
     * This method takes the results from the form and passes them into 
     * variables for use by the servlet, such as URL creation and queries.
     * @param req           This is the HTTP Servlet Request.
     * @param res           This is the HTTP Servlet Response.
     * @param toClient      This is used for printing output.
     */
     void Form3Results(HttpServletRequest req, HttpServletResponse res, PrintWriter toClient) 
                    throws java.io.IOException
    {
        Calendar cal = Calendar.getInstance();
	    DateFormat dateFormat = new SimpleDateFormat("yyy/MM/dd HH:mm:ss");
        toClient.println("<table><TR><TD>Date is:</TD><TD>" + dateFormat.format(cal.getTime()) + "</TD></TR>");
	    
        tableTypeReq = "t";
        toClient.println("<TR><TD>Type of Table is:</TD><TD>" + tableTypeReq + "</TD></TR>");
        numPhasesReq = "10";
        toClient.println("<TR><TD>Number of Phases is:</TD><TD>" + numPhasesReq + "</TD></TR>");

        monthReq = Integer.toString(cal.get(Calendar.MONTH) + 1);
        toClient.println("<TR><TD>Month is:</TD><TD>" + monthReq + "</TD></TR>");
        dayReq = "1";
        toClient.println("<TR><TD>Day is:</TD><TD>" + dayReq + "</TD></TR>");
        yearReq = Integer.toString(cal.get(Calendar.YEAR));
        toClient.println("<TR><TD>Year is:</TD><TD>" + yearReq + "</TD></TR></table>");
    }
    
    /**
     * This method was only used for parsing and outputting the data before the
     * database was used. It only outputs results; it does not create tables.
     * In theory, this method can be used if the database server is down.
     * @param targetURL     This is the URL which will be used for the query.
     * @param res           This is the HTTP Servlet Response.
     */
     void ReadWeb3(URL targetURL, HttpServletResponse res) throws java.io.IOException
    {
     PrintWriter toClient = res.getWriter();
     InputStream stream = null;
     try { // Hook up to the file on the server
       stream = targetURL.openStream();
     }
     catch (Exception e)  {
       e.printStackTrace();
       System.err.println("!! Stream open failed !!");
     }
     BufferedReader Inf = null;
     try {
       Inf = new BufferedReader(new InputStreamReader(stream));
     }
     catch (Exception e){
       e.printStackTrace();
     }
     int next;
     next=Inf.read();
     for (int i = 0; i < 18; i++)
     {
         Inf.readLine();
     }
     for (int i = 0; i < 31; i++)
     {
         String preSplit = new String(Inf.readLine());
         //toClient.print("preSplit: " + preSplit);
         String[] splitOne = new String[] {preSplit.substring(8, 13),
            preSplit.substring(17, 22),
            preSplit.substring(26, 31),
            preSplit.substring(35, 40),
            preSplit.substring(44, 49),
            preSplit.substring(53, 58),
            preSplit.substring(62, 67),
            preSplit.substring(71, 76),
            preSplit.substring(80, 85),
            preSplit.substring(89, 94),
            preSplit.substring(98, 103),
            preSplit.substring(107, 112)
         };
         //toClient.print("Split 1: " + Arrays.toString(splitOne));
         toClient.print(Arrays.toString(splitOne));
         toClient.print("<BR>");
         /*String[] splitTwo = splitOne.split(">");
         toClient.print("Split 2: " + Arrays.toString(splitTwo));
         */
     }
     
     /*
     while (next>=0) {
       toClient.print((char)next);
       next=Inf.read();
     } */ 
    }
    
    /**
     * This method takes the results from the form and passes them into 
     * variables for use by the servlet, such as URL creation and queries.
     * @param req           This is the HTTP Servlet Request.
     * @param res           This is the HTTP Servlet Response.
     * @param toClient      This is used for printing output.
     */
     void Form4Results(HttpServletRequest req, HttpServletResponse res, PrintWriter toClient) 
                    throws java.io.IOException
    {
        tableTypeReq = req.getParameterValues("tableType")[0];
        toClient.println("<TR><TD>Type of Table is:</TD><TD>" + tableTypeReq + "</TD></TR>");
        monthReq = req.getParameterValues("monthSelect")[0];
        toClient.println("<TR><TD>Month is:</TD><TD>" + monthReq + "</TD></TR>");
        dayReq = req.getParameterValues("daySelect")[0];
        toClient.println("<TR><TD>Day is:</TD><TD>" + dayReq + "</TD></TR>");
        yearReq = req.getParameterValues("yearEntry")[0];
        toClient.println("<TR><TD>Year is:</TD><TD>" + yearReq + "</TD></TR>");
        timeZoneReq = req.getParameterValues("timeZone")[0];
        toClient.println("<TR><TD>Time Zone is:</TD><TD>" + timeZoneReq + "</TD></TR>");
    }
    
    /**
     * This method was only used for parsing and outputting the data before the
     * database was used. It only outputs results; it does not create tables.
     * In theory, this method can be used if the database server is down.
     * @param targetURL     This is the URL which will be used for the query.
     * @param res           This is the HTTP Servlet Response.
     */
     void ReadWeb4(URL targetURL, HttpServletResponse res) throws java.io.IOException
    {
     PrintWriter toClient = res.getWriter();
     InputStream stream = null;
     try { // Hook up to the file on the server
       stream = targetURL.openStream();
     }
     catch (Exception e)  {
       e.printStackTrace();
       System.err.println("!! Stream open failed !!");
     }
     BufferedReader Inf = null;
     try {
       Inf = new BufferedReader(new InputStreamReader(stream));
     }
     catch (Exception e){
       e.printStackTrace();
     }
     int next;
     next=Inf.read();
     for (int i = 0; i < 17; i++)
     {
         Inf.readLine();
     }
     for (int i = 0; i < 31; i++)
     {
         String preSplit = new String(Inf.readLine());
         //toClient.print("preSplit: " + preSplit);
         String[] splitOne = new String[] {preSplit.substring(8, 12),
            preSplit.substring(17, 21),
            preSplit.substring(26, 30),
            preSplit.substring(35, 39),
            preSplit.substring(44, 48),
            preSplit.substring(53, 57),
            preSplit.substring(62, 66),
            preSplit.substring(71, 75),
            preSplit.substring(80, 84),
            preSplit.substring(89, 93),
            preSplit.substring(98, 102),
            preSplit.substring(107, 111)
         };
         //toClient.print("Split 1: " + Arrays.toString(splitOne));
         toClient.print(Arrays.toString(splitOne));
         toClient.print("<BR>");
         /*String[] splitTwo = splitOne.split(">");
         toClient.print("Split 2: " + Arrays.toString(splitTwo));
         */
     }
     
     /*
     while (next>=0) {
       toClient.print((char)next);
       next=Inf.read();
     } */ 
    }
    
    /**
     * This method takes the results from the form and passes them into 
     * variables for use by the servlet, such as URL creation and queries.
     * @param req           This is the HTTP Servlet Request.
     * @param res           This is the HTTP Servlet Response.
     * @param toClient      This is used for printing output.
     */
     void Form5Results(HttpServletRequest req, HttpServletResponse res, PrintWriter toClient) 
                    throws java.io.IOException
    {
        tableTypeReq = req.getParameterValues("sunOrMoon")[0];
        toClient.println("<TR><TD>Object is:</TD><TD>" + tableTypeReq + "</TD></TR>");
        tabIntReq = req.getParameterValues("tabInterval")[0];
        toClient.println("<TR><TD>Tabular Interval is:</TD><TD>" + tabIntReq + "</TD></TR>");
        monthReq = req.getParameterValues("monthSelect")[0];
        toClient.println("<TR><TD>Month is:</TD><TD>" + monthReq + "</TD></TR>");
        dayReq = req.getParameterValues("daySelect")[0];
        toClient.println("<TR><TD>Day is:</TD><TD>" + dayReq + "</TD></TR>");
        yearReq = req.getParameterValues("yearEntry")[0];
        toClient.println("<TR><TD>Year is:</TD><TD>" + yearReq + "</TD></TR>");
        cityReq = req.getParameterValues("location")[0];
        toClient.println("<TR><TD>City is:</TD><TD>" + cityReq + "</TD></TR>");
        stateReq = req.getParameterValues("st")[0];
        toClient.println("<TR><TD>State is:</TD><TD>" + stateReq + "</TD></TR>");
    }
    
    /**
     * This method outputs the results from the query into an HTML table.
     * @param data     This is the ResultSet of the query, which is printed out.
     * @param out      This is used for printing output.
     */
     void outputQuery1Results(ResultSet data,PrintWriter out)
                                              throws java.sql.SQLException
    // Won't use try..catch here
    {
        out.println("<TABLE Caption=\"Query Results\" " +
        "align=\"center\" cellspacing=20><TR><TH>Event</TH><TH>"+
        "Time</TH></TR>");
        while (data.next()) {// once for each line in the database
          // ResultSet has functions to obtain elements; we need for String & int
          // Note we could use field # insteasd of "Name"; also null terminate. Why?
            out.println("<TR><TD>"+data.getString("timeEvent")+"</TD><TD>"+
                    data.getString("timeDigital")+"</TD></TR>");
        }
        out.println("</TABLE>");
    }
    
    /**
     * This method outputs the results from the query into an HTML table.
     * @param data     This is the ResultSet of the query, which is printed out.
     * @param out      This is used for printing output.
     */
     void outputQuery2Results(ResultSet data,PrintWriter out)
                                              throws java.sql.SQLException
    // Won't use try..catch here
    {
        out.println("<TABLE Caption=\"Query Results\" " +
        "align=\"center\" cellspacing=20><TR><TH>Duration: </TH></TR>");
        while (data.next()) {// once for each line in the database
          // ResultSet has functions to obtain elements; we need for String & int
          // Note we could use field # insteasd of "Name"; also null terminate. Why?
            out.println("<TR><TD>"+data.getString("timeDur")+"</TD></TR>");
        }
        out.println("</TABLE>");
    }
    
    /**
     * This method outputs the results from the query into an HTML table.
     * @param data     This is the ResultSet of the query, which is printed out.
     * @param out      This is used for printing output.
     */
     void outputQuery3Results(ResultSet data,PrintWriter out)
                                              throws java.sql.SQLException
    // Won't use try..catch here
    {
        out.println("<TABLE Caption=\"Query Results\" " +
        "align=\"center\" cellspacing=20><TR><TH>Moon Phase</TH><TH>"+
        "Date</TH></TR>");
        while (data.next()) {// once for each line in the database
          // ResultSet has functions to obtain elements; we need for String & int
          // Note we could use field # insteasd of "Name"; also null terminate. Why?
            out.println("<TR><TD>"+data.getString("moonPhase")+"</TD><TD>"+
                    data.getString("phaseDate")+"</TD></TR>");
        }
        out.println("</TABLE>");
    }
    
    /**
     * This method outputs the results from the query into an HTML table.
     * @param data     This is the ResultSet of the query, which is printed out.
     * @param out      This is used for printing output.
     */
     void outputQuery4Results(ResultSet data,PrintWriter out)
                                              throws java.sql.SQLException
    // Won't use try..catch here
    {
        out.println("<TABLE Caption=\"Query Results\" " +
        "align=\"center\" cellspacing=20><TR><TH>Fraction of the Moon Illuminated: </TH></TR>");
        while (data.next()) {// once for each line in the database
          // ResultSet has functions to obtain elements; we need for String & int
          // Note we could use field # insteasd of "Name"; also null terminate. Why?
            out.println("<TR><TD>"+data.getString("fracMoon")+"</TD></TR>");
        }
        out.println("</TABLE>");
    }
    
    /**
     * This method outputs the results from the query into an HTML table.
     * @param data     This is the ResultSet of the query, which is printed out.
     * @param out      This is used for printing output.
     */
     void outputQuery5Results(ResultSet data,PrintWriter out)
                                              throws java.sql.SQLException
    // Won't use try..catch here
    {
        if (tableTypeReq.equals("10"))
        {
            out.println("<TABLE Caption=\"Query Results\" " +
            "align=\"center\" cellspacing=20><TR><TH>Time</TH><TH>"+
            "Altitude</TH><TH>Azimuth</TH></TR>");
            while (data.next()) {// once for each line in the database
              // ResultSet has functions to obtain elements; we need for String & int
              // Note we could use field # insteasd of "Name"; also null terminate. Why?
                out.println("<TR><TD>"+data.getString("timeAlt")+"</TD><TD>"+
                        data.getString("Altitude")+"</TD><TD>"+
                        data.getString("Azimuth")+"</TD></TR>");
            }
            out.println("</TABLE>");
        }
        else if (tableTypeReq.equals("11"))
        {
            out.println("<TABLE Caption=\"Query Results\" " +
            "align=\"center\" cellspacing=20><TR><TH>Time</TH><TH>"+
            "Altitude</TH><TH>Azimuth</TH><TH>Fraction Illuminated</TH></TR>");
            while (data.next()) {// once for each line in the database
              // ResultSet has functions to obtain elements; we need for String & int
              // Note we could use field # insteasd of "Name"; also null terminate. Why?
                out.println("<TR><TD>"+data.getString("timeAlt")+"</TD><TD>"+
                        data.getString("Altitude")+"</TD><TD>"+
                        data.getString("Azimuth")+"</TD><TD>"+
                        data.getString("fracMoon")+"</TD></TR>");
            }
            out.println("</TABLE>");
        }
        
    }
    
    /**
     * This method takes the input as military time and converts it into
     * standard time which uses AM and PM.
     * @param preMilitary       String preMilitary data member.
     * @return postMilitary     String postMilitary data member.
     */
     String MilitaryTime(String preMilitary)
    {
        String postMilitary;
        
        int hours = Integer.parseInt(preMilitary.substring(0,2));
        String minutes = preMilitary.substring(3,5);
        int newHour;
        if (hours==0)
        {
            postMilitary = "12:" + minutes + " AM";
        }
        else if (hours<12)
        {
            postMilitary = String.valueOf(hours) + ":" + minutes + " AM";
        }
        else if (hours>12)
        {
            newHour = hours - 12;
            postMilitary = String.valueOf(newHour) + ":" + minutes + " PM";
        }
        else
        {
            postMilitary = String.valueOf(hours) + ":" + minutes + " PM";
        }
        return postMilitary;
    }
    
    /**
     * This method counts the number of tables by checking the tableList array
     * and counting its non-null elements. It increments tableCount for each
     * element, and returns the count. If the count is 10, it calls dropTable.
     * @param tableCount    This int data member keeps track of table count.
     * @param tableList     This array of strings houses table names.
     * @param toClient      This is used for printing output.
     * @return tableCount   Updated table count is returned.
     */
     int checkTables(int tableCount, String[] tableList, PrintWriter toClient) 
                     throws java.io.IOException
    {
        tableCount = 0;
        for (int i = 0; i < tableList.length; i++)
        {
            if (tableList[i] != null)
            {
                tableCount++;
            }
            
        }
        // toClient.println("Table Count in checkTables: " + tableCount + "<BR>");
        if (tableCount == 10)
        {
            dropTable(tableList[0], toClient);
            tableList[0] = tableList[1];
            tableList[1] = tableList[2];
            tableList[2] = tableList[3];
            tableList[3] = tableList[4];
            tableList[4] = tableList[5];
            tableList[5] = tableList[6];
            tableList[6] = tableList[7];
            tableList[7] = tableList[8];
            tableList[8] = tableList[9];
            tableCount--;
        }
        // toClient.println("Table Count in checkTables after dropcheck: " + tableCount + "<BR>");
        return tableCount;
    }
    
    /**
     * This method drops the table whose name was passed in from checkTables.
     * It uses a database connection and executes an SQL command to do so.
     * @param tableName     This is the name of the table to drop.
     * @param toClient      This is used for printing output.
     */
     void dropTable(String tableName, PrintWriter toClient) throws java.io.IOException
    {
        Statement stmnt;
        
        try {
            Connection con = new OracleConnection().getConnection(USERNAME, PASSWORD);
            stmnt=con.createStatement();    
            String dropCommand = "DROP TABLE " + tableName;
            stmnt.executeUpdate(dropCommand);
            toClient.println("Table Dropped! <BR>");
            stmnt.close();
        } catch (Exception e) {
            toClient.println("Database drop table error:"+e+"<BR>");
        }
        
    }
//}
%>
        </div>
