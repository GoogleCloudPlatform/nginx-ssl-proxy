#!/bin/bash

# If SSL key and cert are provided, configure nginx appropriately
if [ -n "${SSL_CERT_GCS_URL+1}" ] && [ -n "${SSL_KEY_GCS_URL+1}" ]; then
  echo "Configuring nginx SSL"
  gsutil cp ${SSL_CERT_GCS_URL} /etc/ssl/certs/service-cert
  gsutil cp ${SSL_KEY_GCS_URL} /etc/ssl/private/service-key
fi

sed -i "s/<target_service_host>/${!SERVICE_HOST_ENV_NAME}:${!SERVICE_PORT_ENV_NAME}/g;" /usr/src/target_service.conf
cp /usr/src/target_service.conf /etc/nginx/conf.d/target_service.conf
nginx -g 'daemon off;'
