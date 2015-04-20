#!/bin/bash

# If SSL key and cert are provided, download and configure nginx
if [ -n "${SSL_CERT_GCS_URL+1}" ] && [ -n "${SSL_KEY_GCS_URL+1}" ]; then
  echo "Downloading SSL components..."
  # Download cert and key
  gsutil cp ${SSL_CERT_GCS_URL} /etc/ssl/certs/service-cert
  gsutil cp ${SSL_KEY_GCS_URL} /etc/ssl/private/service-key
  # Install correct nginx conf
  cp /usr/src/proxy_ssl.conf /etc/nginx/conf.d/proxy.conf
else
  # No SSL
  cp /usr/src/proxy_nossl.conf /etc/nginx/conf.d/proxy.conf
fi

# If an htpasswd file is provided, download and configure nginx 
if [ -n "${HTPASSWD_GCS_URL+1}" ]; then
  echo "Downloading htpasswd components..."
   gsutil cp ${HTPASSWD_GCS_URL} /etc/nginx/target_service.htpasswd
   sed -i "s/#auth_basic/auth_basic/g;" /etc/nginx/conf.d/proxy.conf
fi

# Tell nginx the address and port of the service to proxy to
sed -i "s/{{TARGET_SERVICE_HOST}}/${!SERVICE_HOST_ENV_NAME}:${!SERVICE_PORT_ENV_NAME}/g;" /etc/nginx/conf.d/proxy.conf

echo "Starting nginx..."
nginx -g 'daemon off;'
