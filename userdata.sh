#!/bin/bash
#################
sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart
timedatectl set-timezone ${Timezone}
#############################################################################
/home/ubuntu/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path /
crontab -u root -l | { cat; echo "* * * * * /home/ubuntu/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path /"; } | crontab 