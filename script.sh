#!/bin/bash

cd ~/webapps/
rm -rf SunMoonInfo.war
cd ~/SunMoonInfo/WEB-INF/classes/
rm -f *.class
javac *.java
cd ~/SunMoonInfo/
rm -rf SunMoonInfo.war
jar cvf SunMoonInfo.war .
cd ~/webapps/
cp ~/SunMoonInfo/SunMoonInfo.war .
cd /www/student/hbagu753/project4
cp ~/SunMoonInfo/* .