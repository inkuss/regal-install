#!/bin/bash
# Kontrolle Meldung an den Katalog und URN-Vergabe für kürzlich angelegte Objekte
# Autor: Ingolf Kuss
# Datum: 07.12.2015

# alle neulich erzeugten Objekte ausgeben lassen
# Objekte, die vor sieben bis 21 Tagen angelegt wurden
# Ergebnisliste in eine Datei schreiben
outdatei=/opt/regal/cronjobs/tmp/ctrl_urn.$$.out.txt
if [ -f $outdatei ]; then
 rm $outdatei
fi
# E-Mail Inhalt anlegen
mailbodydatei=/opt/regal/cronjobs/tmp/mailbody.$$.out.txt
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
echo "Objekte mit Anlagedatum von $vondatum_hr bis $bisdatum_hr:" >> $mailbodydatei
# for found in `curl -s -XGET https://api.edoweb-rlp.de/search/edoweb/_search -d'{"query":{"range" : {"isDescribedBy.created":{"from":"2014-01-01","to":"2015-01-01"}} },"fields":["isDescribedBy.created"],"size":"50000"}' | grep -Eo '("isDescribedBy\.created":\["............................"\]|"_id":"edoweb:.......")'`
for found in `curl -s -XGET https://api.edoweb-rlp.de/search/edoweb/_search -d'{"query":{"range" : {"isDescribedBy.created":{"from":"'$vondatum'","to":"'$bisdatum'"}} },"fields":["isDescribedBy.created"],"size":"50000"}' | grep -Eo '("isDescribedBy\.created":\["............................"\]|"_id":"edoweb:.......")'`
do
    # echo "found=$found"
    if [[ $found =~ "\"_id\"" ]]; then
      # echo "found an id in $found"
      id=${found:7:14}
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
    url=http://edoweb-rlp.de/resource/$id
    # Ist das Objekt an der OAI-Schnittstelle "da" ?
    # 1. Meldung an den Katalog
    cat="?";
    curlout_kat=/opt/regal/cronjobs/tmp/curlout.$$.kat.xml
    curl -s -o $curlout_kat "http://api.edoweb-rlp.de/dnb-urn/?verb=GetRecord&metadataPrefix=mabxml-1&identifier=info:fedora/$id"
    istda_kat=$(grep -c "<identifier>info:fedora/$id</identifier>" $curlout_kat);
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
    curlout_dnb=/opt/regal/cronjobs/tmp/curlout.$$.dnb.xml
    curl -s -o $curlout_dnb "http://api.edoweb-rlp.de/dnb-urn/?verb=GetRecord&metadataPrefix=epicur&identifier=info:fedora/$id"
    istda_dnb=$(grep -c "<identifier>info:fedora/$id</identifier>" $curlout_dnb);
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

outdateisort=/opt/regal/cronjobs/tmp/ctrl_urn.$$.out.sort.txt
sort $outdatei > $outdateisort
rm $outdatei

echo -e "URL                                         \tAnlagedatum          \tKatalog\tDNB" >> $mailbodydatei
cat $outdateisort >> $mailbodydatei
rm $outdateisort

# Versenden des Ergebnisses der Pruefung als E-Mail
recipients="edoweb-admin\@hbz-nrw.de";
# recipients="kuss\@hbz-nrw.de";
subject="Edoweb 3.0 : URN-Vergabe Kontroll-Report";
return_address="$0\@edoweb-rlp.hbz-nrw.de";
mailx -s "$subject" $recipients < $mailbodydatei
# rm $mailbodydatei
