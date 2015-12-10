#!/bin/bash

LOCATION=${1:-'/tmp'}

# Files required by nginx proxy
SERVER_CERT="${LOCATION}/proxycert"
SERVER_KEY="${LOCATION}/proxykey"
DHPARAM="${LOCATION}/dhparam"

# Files used in generating the required files.
CA_KEY="${LOCATION}/ca.key"
CA_CRT="${LOCATION}/ca.crt"
SERVER_CSR="${LOCATION}/server.csr"

echo $SERVER_KEY, $SERVER_CERT, $DHPARAM, $CA_KEY

printf "# Create new dhparam. This may take a few minutes...\n"
# openssl dhparam -out $DHPARAM 2048

printf "\n# Create the CA...\n"
# Create the CA Key and Certificate for signing Client Certs
# Just enter 'pass' for the passphrase.
# All other details can be left blank.
openssl genrsa -des3 -out $CA_KEY 4096
openssl req -new -x509 -days 365 -key $CA_KEY -out $CA_CRT

printf "\n# Create the Server Key...\n"
# Create the Server Key, CSR, and Certificate
# I don't want a passphrase here.
# All fields can be left blank
openssl genrsa -out $SERVER_KEY 4096

printf "\n# Create the Server CSR...\n"
openssl req -new -key $SERVER_KEY -out $SERVER_CSR

printf "\n# Self-sign the Server CSR...\n"
# We're self signing our own server cert here. This is a no-no in production.
# Just need to enter same passphrase used in creating the CA.
openssl x509 -req -days 365 -in $SERVER_CSR -CA $CA_CRT -CAkey $CA_KEY -set_serial 01 -out $SERVER_CERT
