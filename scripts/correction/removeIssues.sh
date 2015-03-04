cat removeIssues.txt | parallel curl -s -uedoweb-admin:edoweb-admin -XDELETE localhost:9000/resource/edoweb:{}/all?contentType=issue >> removeIssues-`date +"%Y%m%d"`.log 2>&1


