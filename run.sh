#!/bin/bash
cp /usr/src/jenkins_service.conf /tmp/jenkins_service.conf
xyz=$(sed "s/<jenkins_service_host>/${JENKINS_SERVICE_HOST}/g;" /tmp/jenkins_service.conf)
echo "$xyz" > /etc/nginx/conf.d/jenkins_service.conf
nginx -g 'daemon off;'
