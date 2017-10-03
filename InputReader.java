// File: InputReader.java
// Methods for Reading char and int

import java.io.*;

public class InputReader {

public static char readChar() throws java.io.IOException
{ BufferedReader DataIn=new BufferedReader(new InputStreamReader(System.in));
  String Line;
  do 
	Line=DataIn.readLine().trim();
  while (Line.length()==0);
  return((Line.toUpperCase().toCharArray())[0]);
}

static char getChoice(String OK)  throws java.io.IOException
{char Reply;
 do {
  Reply=readChar();
 } while (OK.indexOf(Reply,0)==-1);
 return(Reply);
}

 static int ReadInt() throws java.io.IOException
 {BufferedReader DataIn = new BufferedReader(new InputStreamReader(System.in));
  String Input=DataIn.readLine();
  return (Integer.valueOf(Input).intValue());
 }

} // end of ReadInput Class