#!/bin/bash

# Env says we're using SSL 
if [ -n "${ENABLE_SSL+1}" ] && [ "${ENABLE_SSL,,}" = "true" ]; then
  echo "Enabling SSL..."
  cp /usr/src/proxy_ssl.conf /etc/nginx/conf.d/proxy.conf
else
  # No SSL
  cp /usr/src/proxy_nossl.conf /etc/nginx/conf.d/proxy.conf
fi

# If an htpasswd file is provided, download and configure nginx 
if [ -n "${ENABLE_BASIC_AUTH+1}" ] && [ "${ENABLE_BASIC_AUTH,,}" = "true" ]; then
  echo "Enabling basic auth..."
   sed -i "s/#auth_basic/auth_basic/g;" /etc/nginx/conf.d/proxy.conf
fi

# Tell nginx the address and port of the service to proxy to
sed -i "s/{{TARGET_SERVICE_HOST}}/${!SERVICE_HOST_ENV_NAME}:${!SERVICE_PORT_ENV_NAME}/g;" /etc/nginx/conf.d/proxy.conf

echo "Starting nginx..."
nginx -g 'daemon off;'
