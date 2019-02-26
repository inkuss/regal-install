#! /bin/bash

. variables.conf
#Download tomcat
if [ -f apache-tomcat-8.5.38.zip ]
then
	echo "Tomcat is already here! Stop downloading!"
else
    wget http://ftp.halifax.rwth-aachen.de/apache/tomcat/tomcat-8/v8.5.38/bin/apache-tomcat-8.5.38.zip
    #Install tomcat
    unzip apache-tomcat-8.5.38.zip
    mv apache-tomcat-8.5.38 $ARCHIVE_HOME
    ln -s $ARCHIVE_HOME/apache-tomcat-8.5.38 $ARCHIVE_HOME/tomcat-for-openwayback
fi
#Configure tomcat
cp templates/openwayback-server.xml $ARCHIVE_HOME/tomcat-for-openwayback/conf/server.xml
cp templates/setenv.sh $ARCHIVE_HOME/tomcat-for-openwayback/bin
rm -rf $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT* 
#Get openwayback code
cd $ARCHIVE_HOME
git clone ssh://kuss@alkyoneus.hbz-nrw.de/files/var/git/openwayback.git
#cd -
cd $ARCHIVE_HOME/openwayback
#Check out hbz Branch
git checkout hbz-2.3.2
# Überprufe Wayback-Konfiguration
vim ./wayback-webapp/src/main/webapp/WEB-INF/wayback.xml
# - Editiere Server-Namen
# - Stelle sicher, dass er die ArchiveDirs gibt (diese ggfs. anlegen)
vim ./wayback-webapp/src/main/webapp/WEB-INF/BDBCollection.xml
# - Überprüfe, dass alle ArchiveDirs in der Collection enthalten sind.
#Build openwayback
mvn package -DskipTests
#Copy build to tomcat
cp wayback-webapp/target/openwayback-2.3.2.war $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT.war
#start tomcat
chmod u+x $ARCHIVE_HOME/tomcat-for-openwayback/bin/*.sh
$ARCHIVE_HOME/tomcat-for-openwayback/bin/startup.sh
cd -
sleep 5
# (Tomcat deploys the Webapp)
tail -99f $ARCHIVE_HOME/tomcat-for-openwayback/logs/catalina.out
#copy openwayback config
# Nein, ist schon in hbz Branch angepasst + s.o.
#cp templates/wayback.xml $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT/WEB-INF/
#cp templates/BDBCollection.xml $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT/WEB-INF/
#cp templates/CDXCollection.xml $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT/WEB-INF/
#stop tomcat
#$ARCHIVE_HOME/tomcat-for-openwayback/bin/shutdown.sh

