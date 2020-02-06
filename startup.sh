#!/bin/bash

cd /bin

cron -f &

nginx -g "daemon off;"