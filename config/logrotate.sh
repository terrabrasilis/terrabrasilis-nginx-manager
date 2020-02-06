#!/bin/bash
DATE=$(date '+%d_%m_%Y_%H_%M')
mv /var/log/nginx/access.log /var/log/nginx/access.log.$DATE
mv /var/log/nginx/error.log /var/log/nginx/error.log.$DATE
kill -USR1 `cat /var/run/nginx.pid`
sleep 1
gzip /var/log/nginx/access.log.$DATE
gzip /var/log/nginx/error.log.$DATE
# remove files older than 30 days
find . -mtime +30 -type f -delete