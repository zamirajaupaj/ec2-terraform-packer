#!/bin/bash
#################
sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart
timedatectl set-timezone ${Timezone}
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
/home/ubuntu/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path /
crontab -u root -l | { cat; echo "* * * * * /home/ubuntu/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path /"; } | crontab 
###################################################################
#######################################################
#managed log of database 
touch /etc/logrotate.d/bakcup_log_mongodb
echo "/var/log/mongodb/*.log {" >> /etc/logrotate.d/bakcup_log_mongodb
echo "daily" >> /etc/logrotate.d/bakcup_log_mongodb
echo "compress" >> /etc/logrotate.d/bakcup_log_mongodb
echo "maxage 7" >> /etc/logrotate.d/bakcup_log_mongodb
echo "rotate 7" >> /etc/logrotate.d/bakcup_log_mongodb
echo "copytruncate" >> /etc/logrotate.d/bakcup_log_mongodb
echo "}" >> /etc/logrotate.d/bakcup_log_mongodb
logrotate /etc/logrotate.d/bakcup_log_mongodb
touch /root/script.sh
zip -r -X /data/backup/db.zip /data/backup/
aws s3 cp  /data/backup/db.zip  s3://bucket-zamira/ --region eu-west-1
echo "mongodump --host localhost --port 27017 --collection myCollection --db mydatabase --out /data/backup/" >> /root/script.sh
echo "zip -r -X /data/backup/db.zip /data/backup/" >> /root/script.sh
echo "aws s3 cp  /data/backup/db.zip  s3://bucket-zamira/ --region eu-west-1" >> /root/script.sh
echo "rm -rf /data/backup/*" >> /root/script.sh
mkdir -p /data/backup/
chmod +x /root/script.sh
crontab -u root -l | { cat; echo "0 0* * * /root/script.sh --from-cron"; } | crontab 
##################### install code deploy #############
service codedeploy-agent status
service codedeploy-agent start
systemctl start mongod
mongo <<EOF
    use mydatabase
EOF
apt-get update
