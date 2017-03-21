docker run -it \
-e ENABLE_SSL=true \
-e TARGET_SERVICE=ec2-52-14-175-123.us-east-2.compute.amazonaws.com:8000 \
-e XFRAME_OPTION='ALLOW-FROM localhost' \
-p 80:80 \
-p 443:443 \
-v $(pwd)/cert.pem:/etc/secrets/proxycert \
-v $(pwd)/key.pem:/etc/secrets/proxykey \
-v $(pwd)/dhparam.pem:/etc/secrets/dhparam \
nginx-ssl-proxy-onshift

