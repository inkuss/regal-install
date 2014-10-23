#! /bin/bash

source variables.conf

function makeDir()
{
if [ ! -d $1 ]
then
mkdir -v -p $1
fi
}
function makeDirs()
{
makeDir $ARCHIVE_HOME/sync
makeDir $ARCHIVE_HOME/fedora
makeDir $ARCHIVE_HOME/logs
makeDir $ARCHIVE_HOME/conf
makeDir $ARCHIVE_HOME/proai/cache
makeDir $ARCHIVE_HOME/proai/sessions
makeDir $ARCHIVE_HOME/proai/schemas
if [ ! -f $ARCHIVE_HOME/regal-install/scripts/variables.conf ]
then
ln -s $ARCHIVE_HOME/regal-install/variables.conf $ARCHIVE_HOME/regal-install/scripts/variables.conf
fi
}

function createConfig()
{
substituteVars install.properties $ARCHIVE_HOME/conf/install.properties
substituteVars fedora-users.xml $ARCHIVE_HOME/conf/fedora-users.xml
substituteVars api.properties $ARCHIVE_HOME/conf/api.properties
substituteVars tomcat-users.xml $ARCHIVE_HOME/conf/tomcat-users.xml
substituteVars setenv.sh $ARCHIVE_HOME/conf/setenv.sh
substituteVars elasticsearch.yml $ARCHIVE_HOME/conf/elasticsearch.yml
substituteVars site.conf $ARCHIVE_HOME/conf/site.conf
substituteVars logging.properties $ARCHIVE_HOME/conf/logging.properties
substituteVars catalina.out $ARCHIVE_HOME/conf/catalina.out
substituteVars Identify.xml $ARCHIVE_HOME/conf/Identify.xml
substituteVars proai.properties $ARCHIVE_HOME/conf/proai.properties
substituteVars robots.txt $ARCHIVE_HOME/conf/robots.txt
substituteVars tomcat.conf $ARCHIVE_HOME/conf/tomcat.conf
substituteVars application.conf $ARCHIVE_HOME/conf/application.conf
substituteVars fedora.fcfg $ARCHIVE_HOME/conf/fedora.fcfg
cp templates/favicon.ico $ARCHIVE_HOME/conf/favicon.ico
}

function substituteVars()
{
file=templates/$1
target=$2
sed -e "s,\$ARCHIVE_HOME,$ARCHIVE_HOME,g" \
-e "s,\$FEDORA_USER,$FEDORA_USER,g" \
-e "s,\$API_USER,$API_USER,g" \
-e "s,\$PASSWORD,$PASSWORD,g" \
-e "s,\$SERVER,$SERVER,g" \
-e "s,\$BACKEND,$BACKEND,g" \
-e "s,\$FRONTEND,$FRONTEND,g" \
-e "s,\$URNBASE,$URNBASE,g" \
-e "s,\$IP,$IP,g" \
-e "s,\$TOMCAT_PORT,$TOMCAT_PORT,g" \
-e "s,\$EMAIL,$EMAIL,g" \
-e "s,\$PLAYPORT,$PLAYPORT,g" \
-e "s,\$TOMCAT_HOME,$TOMCAT_HOME,g" \
-e "s,\$TOMCAT_CONF,$TOMCAT_CONF,g" \
-e "s,\$ELASTICSEARCH_CONF,$ELASTICSEARCH_CONF,g" \
-e "s,\$VERSION,$VERSION,g" \
-e "s,\$ELASTICSEARCH_PORT,$ELASTICSEARCH_PORT,g" $file > $target
}



makeDirs
createConfig
