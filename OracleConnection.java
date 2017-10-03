/*******************************************************************************
* NAME: HAROLD DANE C. BAGUINON                                                *
* DATE: 12/10/2015                                                             *
* DATE DUE: 12/12/2015 04:00:00 PM                                             *
* COURSE: CSC521 010                                                           *
* PROFESSOR: DR. SPIEGEL                                                       *
* PROJECT: #4                                                                  *
* FILENAME: DBConnection.java                                                  *
* PURPOSE: This program is the third project, but it's numbered as "4" due to  *
*          Project 2 being skipped. This program is a website/servlet that will*
*          provide outputs depending on the user's selection. It can display   *
*          information on sun and moon data for one day, a duration of         *
*          lightness/darkness for one day, dates of primary phases of the moon,*
*          the fraction of the moon illuminated, or the altitude and azimuth of*
*          the sun or moon during the day. This program uses several languages *
*          and techniques, including AJAX, HTML, Java, Javascript, and Beans.  *
*          It is a continuation of Project 3.                                  *
*          This class provides a getConnection method for the creation         *
*          and retrieval of an oracle connection.                              *
* Website link: http://hbagu753.kutztown.edu:8080/SunMoonInfo/index.html       *
* JAVADOC LOCATION: http://acad.kutztown.edu/~hbagu753/project4/javadoc        *
* AUTHOR: Harold Baguinon, Adapted from work by Joe Schick & Chris Walck, and  *
*                                                              Dr. Spiegel     *
*******************************************************************************/

 import java.sql.*;
 import java.sql.DriverManager;
 import java.sql.Connection;
 import java.sql.SQLException;

public class OracleConnection extends DBConnection
{
    private static final String DRIVER_TYPE = "thin";
    // private static final String DRIVER_TYPE = "oci8";

    // private OracleDataSource ods;
    private Connection conn;

    public OracleConnection()
    {
    }
    public Connection getConnection(String userName, String password) 
                          				 throws SQLException
    {
        try 
        {
            Class.forName ("oracle.jdbc.driver.OracleDriver");
        } 
        catch (Exception e) 
        {
            System.out.println ("Could not load the driver"); 
        }
        String ConnectString="jdbc:oracle:thin:@csdb.kutztown.edu:1521:orcl";
        conn=DriverManager.getConnection(ConnectString,userName,password);

        return conn;
    }
}
