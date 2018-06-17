#!/bin/bash
set -e
sudo apt-get update
sudo systemctl start mongod
sudo rm -rf /home/ubuntu/ansible
sudo apt-get install unzip curl wget -y
sudo apt-get install libwww-perl libdatetime-perl -y 
sudo curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O
unzip CloudWatchMonitoringScripts-1.2.1.zip
sudo rm CloudWatchMonitoringScripts-1.2.1.zip
############# install aws cli and codedeploy #################
 curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
 unzip awscli-bundle.zip
 sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws


 