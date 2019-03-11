#!/bin/bash

# This script builds the project, 
# deletes the old version of the project 
# from apache-tomcat-8.5.35 webapps folder and
# adds the newly packed app.

#alter this to project directory.
proj_dir="/home/project/app"

cd

cd ../../opt/apache-tomcat-8.5.35/bin

if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null ; then
    echo "Tomcat may be running on port 8080. Shutting it down..."
		sh shutdown.sh
		sleep 5s
		# TODO: fix this to only carry on if shutdown is sucessful
		echo "Hopefully its shut down."
else
    echo "Great! Port 8080 is not in use. Carrying on..."
fi

cd

cd proj_dir 

mvn clean package

cd

cd ../../opt/apache-tomcat-8.5.35/

cd webapps

echo "Removing the current app out of the Tomcat webapps folder."
rm -r pims-ng pims-ng.war

echo "Copying the new .war file to the Tomcat webapps folder"
cp proj_dir .

cd ../bin
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null ; then
    echo "Something went wrong!"
		echo "port 8080 is in use. To start up the Tomcat server with the new pims-ng app, stop port 8080 and manually start the server."
else
    echo "Starting up the Tomcat Server with new pims-ng application..."
		sh startup.sh
fi

