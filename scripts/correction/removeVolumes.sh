cat removeVolumes.txt | parallel curl -s -uedoweb-admin:edoweb-admin -XDELETE localhost:9000/resource/edoweb:{}/all?contentType=volume >> removeVolumes-`date +"%Y%m%d"`.log 2>&1

