#!/bin/bash

nginxPid=$(ps -ef | grep nginx | grep -v grep | awk '{print $2}')
if [ -z "$nginxPid" ]
then
    sudo nginx
fi

phpPid=$(ps -ef | grep php-fpm | grep -v grep | awk '{print $2}')
if [ -z "$phpPid" ]
then
    sudo php-fpm &
fi
