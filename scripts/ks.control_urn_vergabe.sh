#!/bin/bash
# Kontrolle Meldung an den Katalog und URN-Vergabe für kürzlich angelegte Objekte
# Autor: Ingolf Kuss
# Datum: 07.12.2015

# Umgebungsvariablen
# der Pfad, in dem dieses Skript steht:
home_dir=/opt/regal/cronjobs
server=edoweb-rlp.de
project=edoweb
urn_api=api.$server/dnb-urn
oai-id=oai:$server:

if [ ! -d $home_dir/log ]; then
    mkdir $home_dir/log
fi
if [ ! -d $home_dir/tmp ]; then
    mkdir $home_dir/tmp
fi

# alle neulich erzeugten Objekte ausgeben lassen
# Objekte, die vor sieben bis 21 Tagen angelegt wurden
# Ergebnisliste in eine Datei schreiben
outdatei=$home_dir/tmp/ctrl_urn.$$.out.txt
if [ -f $outdatei ]; then
 rm $outdatei
fi
# E-Mail Inhalt anlegen
mailbodydatei=$home_dir/tmp/mailbody.$$.out.txt
if [ -f $mailbodydatei ]; then
 rm $mailbodydatei
fi

# auswerten:
# z.B. "isDescribedBy.created":["2015-12-02T10:00:57.399+0000"]
# z.B. "_id":"edoweb:7002468"
# erhält nun immer abwechselnd ID und Anlagedatum
id=""
cdate=""
echo "Aktuelles Datum: "`date +"%d.%m.%Y"` >> $mailbodydatei
echo "home-Verzeichnis: $home_dir" >> $mailbodydatei
echo "Projekt: $project" >> $mailbodydatei
echo "Server: $server" >> $mailbodydatei
typeset -i sekundenseit1970
typeset -i vonsekunden
typeset -i bissekunden
sekundenseit1970=`date +"%s"`
vonsekunden=$sekundenseit1970-1814400;
bissekunden=$sekundenseit1970-604800;
vondatum=`date -d @$vonsekunden +"%Y-%m-%d"`
bisdatum=`date -d @$bissekunden +"%Y-%m-%d"`
vondatum_hr=`date -d @$vonsekunden +"%d.%m.%Y"`
bisdatum_hr=`date -d @$bissekunden +"%d.%m.%Y"`
typeset -i idlength
idlength=${#project}+8;
echo "Objekte mit Anlagedatum von $vondatum_hr bis $bisdatum_hr:" >> $mailbodydatei
for found in `curl -s -XGET https://api.$server/search/$project/_search -d'{"query":{"range" : {"isDescribedBy.created":{"from":"'$vondatum'","to":"'$bisdatum'"}} },"fields":["isDescribedBy.created"],"size":"50000"}' | grep -Eo '("isDescribedBy\.created":\["............................"\]|"_id":"'$project':.......")'`
do
    # echo "found=$found"
    if [[ $found =~ "\"_id\"" ]]; then
      # echo "found an id in $found"
      id=${found:7:$idlength}
      # echo "found id $id"
    fi
    if [[ $found =~ "\"isDescribedBy.created\"" ]]; then
      # echo "found a creation date in $found"
      cdate=${found:26:19};
      # echo "found creation date $cdate"
    fi
    if [ -z "$id" ]; then
        continue;
    fi
    if [ -z "$cdate" ]; then
        continue;
    fi
    # Bearbeitung dieser id,cdate
    # echo "Bearbeite id=$id, cdate=$cdate";
    # id=edoweb:4243387
    url=http://$server/resource/$id
    # Ist das Objekt an der OAI-Schnittstelle "da" ?
    # 1. Meldung an den Katalog
    cat="?";
    curlout_kat=$home_dir/tmp/curlout.$$.kat.xml
    curl -s -o $curlout_kat "http://$urn_api/?verb=GetRecord&metadataPrefix=mabxml-1&identifier=$oai-id$id"
    istda_kat=$(grep -c "<identifier>$oai-id$id</identifier>" $curlout_kat);
    if [ $istda_kat -gt 0 ]
    then
      # echo "ist im Kataog da"
      cat="J"
    else
      istnichtda_kat=$(grep -c "<error code=\"idDoesNotExist\">" $curlout_kat);
      if [ $istnichtda_kat ]
      then
        # echo "ist im Kataog nicht da"
       cat="N"
      # else
        # echo "WARN! Undefinierter Status!"
      fi
    fi
    rm $curlout_kat
    # 2. Meldung an die DNB (für URN-Vergabe)
    dnb="?"
    curlout_dnb=$home_dir/tmp/curlout.$$.dnb.xml
    curl -s -o $curlout_dnb "http://$urn_api/?verb=GetRecord&metadataPrefix=epicur&identifier=$oai-id$id"
    istda_dnb=$(grep -c "<identifier>$oai-id$id</identifier>" $curlout_dnb);
    if [ $istda_dnb -gt 0 ]
    then
      # echo "ist bei der DNB da"
      dnb="J"
    else
      istnichtda_dnb=$(grep -c "<error code=\"idDoesNotExist\">" $curlout_dnb);
      if [ $istnichtda_dnb ]
      then
        # echo "ist bei der DNB nicht da"
        dnb="N"
      # else
        # echo "WARN! Undefinierter Status!"
      fi
    fi
    rm $curlout_dnb
    echo -e "$url\t$cdate\t$cat\t$dnb" >> $outdatei
    id="";
    cdate="";
done

outdateisort=$home_dir/tmp/ctrl_urn.$$.out.sort.txt
sort $outdatei > $outdateisort
rm $outdatei

echo -e "URL                                         \tAnlagedatum          \tKatalog\tDNB" >> $mailbodydatei
cat $outdateisort >> $mailbodydatei
rm $outdateisort

# Versenden des Ergebnisses der Pruefung als E-Mail
recipients="$project-admin\@hbz-nrw.de";
# recipients="kuss\@hbz-nrw.de";
subject="$project : URN-Vergabe Kontroll-Report";
mailx -s "$subject" $recipients < $mailbodydatei
# rm $mailbodydatei
