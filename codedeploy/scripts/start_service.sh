#!/bin/bash
cd /var/www
systemctl start mongod
DB_CONNECTION_STRING=mongodb://localhost:27017/mydatabase PORT=80 npm start > stdout.txt 2> stderr.txt &
