#!/bin/bash

CERTS_DIRECTORY=$(dirname $0)/../certs
SCRIPTS_DIRECTORY=$(dirname $0)

if [ -f $CERTS_DIRECTORY/certificate-authority.pem ]; then
    exit 0
fi

# output relevant info on failing commands 
exit_with_error() {
    exit_code=$1
    last_command=${@:2}
    if [ $exit_code -ne 0 ]; then
        >&2 echo "\"${last_command}\" command failed with exit code ${exit_code}."
        exit $exit_code
    fi
}

# enable !! command completion
set -o history -o histexpand

# set certificates directory
CERTS_DIR=$(dirname $0)/../certs

# generate CA key
echo 'Generating CA key'
openssl genrsa \
    -out $CERTS_DIR/certificate-authority.key \
    2048 \
    || exit_with_error $? !!

# self-sign the CA key
echo 'Generating CA cert'
openssl req -x509 -new -nodes \
    -config $CERTS_DIR/certificate-authority.conf \
    -key $CERTS_DIR/certificate-authority.key \
    -out $CERTS_DIR/certificate-authority.pem \
    -sha256 \
    -days 10000 \
    || exit_with_error $? !!

# generate key
echo 'Generating localhost key'
openssl genrsa \
    -out $CERTS_DIR/certificate.key \
    2048 \
    || exit_with_error $? !!

# Generate CSR
echo 'Generating localhost CSR'
openssl req -new \
    -key $CERTS_DIR/certificate.key \
    -out $CERTS_DIR/certificate.csr \
    -subj '/CN=localhost' \
    || exit_with_error $? !!

# Generate cert with CA and CSR
echo 'Generating localhost cert'
openssl x509 -req \
    -in $CERTS_DIR/certificate.csr \
    -out $CERTS_DIR/certificate.crt \
    -CA $CERTS_DIR/certificate-authority.pem \
    -CAkey $CERTS_DIR/certificate-authority.key \
    -extfile $CERTS_DIR/certificate.conf \
    -CAcreateserial \
    -days 10000 \
    -sha256 \
    || exit_with_error $? !!

echo 'Priviledged - Add CA to MacOS Keychain'
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain $CERTS_DIR/certificate-authority.pem || exit 1
