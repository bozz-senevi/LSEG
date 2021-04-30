#!/bin/sh

#Send webserver logs to webserver/logs
cp /var/log/httpd/access_log /home/webserver/logs
cp /var/log/httpd/error_log /home/webserver/logs

#get the content of the webpage

curl -i http://35.154.14.218/index.html > /home/webserver/webcontent.txt

#Declare variable to store date
DATE=$(date +%Y-%m-%d)

#Create compressed file from logs
tar -cvf /home/webserver/$DATE.tar /home/webserver/logs
cp /home/webserver/$DATE.tar /tmp


#Send the compressed folder  to S3 and send error report if the upload unsuccessfull
aws s3 cp /tmp/$DATE.tar s3://bhanuwebserver/ > /tmp/upload.txt
if [[ $(grep 'upload' /tmp/upload.txt) ]]; then
        echo "Upload successfull"
        rm /tmp/$DATE.tar
else
        echo "Upload not successfull" | mail -s "File upload failed" bhanusenevirathne@gmail.com
fi
