#!/bin/bash
#

scp -i webserver.pem -r ../bhanu ec2-user@35.154.14.218:/tmp

USERNAME=ec2-user
HOSTS=35.154.14.218
SCRIPT='sudo -u root -H sh -c "dos2unix /tmp/bhanu/dependancies/scrip1.sh && bash /tmp/bhanu/dependancies/scrip1.sh > /tmp/script_output.txt"'

for HOSTNAME in ${HOSTS} ; do
    ssh -i webserver.pem -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
done


