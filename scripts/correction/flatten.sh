cat pidlist.txt | parallel curl -s -uedoweb-admin:edoweb-admin -XPOST localhost:9000/resource/edoweb:{}/all/flatten >> flatten-`date +"%Y%m%d"`.log 2>&1

