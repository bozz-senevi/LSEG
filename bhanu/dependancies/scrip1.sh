#!/bin/sh
TIME=$(date)


#Declare a function to update the databse with time and Webserver content status
update_db () {
	mysql -h webserver-db.chcxcp3rinlf.ap-south-1.rds.amazonaws.com -P 3306 -u admin -pBHch1215# lseg_support -e "INSERT INTO status(date_time,status) VALUES('"$1" "$2" "$3" "$4" "$5" "$6"','"$7"')";
}

#Condition to check the status of httpd service and start the service if not started
if [[ $(systemctl status httpd | grep 'running') ]]; then
    echo 'Apache_Service_is_Running'
	
else
    systemctl start httpd
#Send an error report and update the db using update_db function if the service is not started	
	if [[ $(systemctl status httpd | grep 'running') ]]; then
		echo "Service is Running"
	else
		echo "Service Failed to Start"
		echo "Apache service is down. Please check it." | mail -s "Error Report" bhanuseneviratne@gmail.com
		update_db $TIME 'Service_Failed_to_Start.'
	fi
fi
#Check the content of the web server and update the database using update_db function
if [[ $(curl -i 35.154.14.218/index.html | grep "HTTP/1.1 200 OK") ]]; then
	echo "HTTP/1.1 200 OK"
	update_db $TIME "Website_is_up_and_Running."
else
	echo "Website is down. Please check it." | mail -s "Error Report" bhanuseneviratne@gmail.com
fi
