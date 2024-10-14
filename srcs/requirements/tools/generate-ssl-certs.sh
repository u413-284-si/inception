#!/bin/bash

# based on: https://docs.docker.com/engine/swarm/configs/#advanced-example-use-configs-with-a-nginx-service

# First half: Create a root certificate authority (CA).
# It is used to sign other certificates, ensuring their authenticity and 
# integrity.

# Second half: Create the certificate for the site (server) and sign it with
# the root CA

# Step 1: Generate a root key.
openssl genrsa -out "root-ca.key" 4096

# Step 2: Generate a CSR using the root key.
openssl req \
	-new \
	-key "root-ca.key" \
	-out "root-ca.csr" \
	-sha256 \
	-subj '/C=AT/ST=9/L=Vienna/O=42Vienna/CN=QiuIndustriesCA'

# Step 3: Configure the root CA. Constrains the root CA to only sign leaf
# certificates and not intermediate CAs.
touch root-ca.cnf
echo "[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash" > root-ca.cnf

# Step 4: Sign the certificate.
openssl x509 \
	-req \
	-days 3650 \
	-in "root-ca.csr" \
	-signkey "root-ca.key" \
	-sha256 \
	-out "root-ca.crt" \
	-extfile "root-ca.cnf" \
	-extensions root_ca

# Step 5: Generate the site key.
openssl genrsa -out "site.key" 4096

# Step 6: Generate a CSR using the site key.
openssl req \
	-new \
	-key "site.key" \
	-out "site.csr" \
	-sha256 \
	-subj '/C=AT/ST=9/L=Vienna/O=42Vienna/CN=QiuIndustriesCA'

# Step 7: Configure the site certificate.
# This constrains the site certificate so that it can only be used to
# authenticate a server and can't be used to sign certificates.
touch site.cnf
echo "[server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = DNS:localhost, IP:127.0.0.1
subjectKeyIdentifier=hash" > site.cnf

# Step 8: Sign the site certificate.
openssl x509 \
	-req \
	-days 750 \
	-in "site.csr" \
	-sha256 \
	-CA "root-ca.crt" \
	-CAkey "root-ca.key" \
	-CAcreateserial \
	-out "site.crt" \
	-extfile "site.cnf" \
	-extensions server
