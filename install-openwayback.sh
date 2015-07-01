#! /bin/bash

. variables.conf
#Download tomcat
wget http://ftp.halifax.rwth-aachen.de/apache/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.zip
#Install tomcat
unzip apache-tomcat-8.0.23.zip
mv apache-tomcat-8.0.23 $ARCHIVE_HOME
ln -s $ARCHIVE_HOME/apache-tomcat-8.0.23 $ARCHIVE_HOME/tomcat-for-openwayback
#Configure tomcat
cp $ARCHIVE_HOME/templates/openwayback-tomcate-server.xml $ARCHIVE_HOME/tomcat-for-openwayback/conf
cp $ARCHIVE_HOME/templates/setenv.sh $ARCHIVE_HOME/tomcat-for-openwayback/bin
rm -rf $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT* 
#Get openwayback code
cd $ARCHIVE_HOME
git clone https://github.com/iipc/openwayback.git
#Check out tag
git checkout tags/openwayback-2.2.0
cd -
#Build openwayback
cd $ARCHIVE_HOME/openwayback
mvn package
#Copy build to tomcat
cp wayback-webapp/target/openwayback-2.2.0.war $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT.war
#start tomcat
$ARCHIVE_HOME/tomcat-for-openwayback/bin/startup.sh
cd -
#copy openwayback config
cp templates/wayback.xml $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT/WEB-INF/
cp templates/BDBCollection.xml $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT/WEB-INF/
cp templates/CDXCollection.xml $ARCHIVE_HOME/tomcat-for-openwayback/webapps/ROOT/WEB-INF/
#stop tomcat
$ARCHIVE_HOME/tomcat-for-openwayback/bin/shutdown.sh

