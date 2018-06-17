#!/bin/bash
mkdir -p /var/www
cd /var/www/
npm install
rm /var/www/package-lock.json
npm i npm@latest -g
npm i -g npm

