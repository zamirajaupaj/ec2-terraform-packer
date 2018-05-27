#!/bin/bash
rm -rf /home/ubuntu/ansible
sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart
timedatectl set-timezone ${Timezone}
hostname ${Hostname}
hostnamectl set-hostname ${Hostname}
###############################################################################
############################## Create Superuser User Administrator ############
###############################################################################
groupadd -g 1001 myuser
mkdir -p /home/myuser
useradd -c "Administrator System user" -u 1001 -g 1001 -d /home/myuser myuser
passwd myuser <<-EOF
${Password}
${Password}
EOF
sh -c "echo '%myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
#############################################################################
apt-get install unzip curl -y
apt-get install libwww-perl libdatetime-perl -y 
curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O
unzip CloudWatchMonitoringScripts-1.2.1.zip
rm CloudWatchMonitoringScripts-1.2.1.zip
/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path /usr/sap
apt-get -n install cronie
crontab -u root -l | { cat; echo "* * * * * /aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path /"; } | crontab 
