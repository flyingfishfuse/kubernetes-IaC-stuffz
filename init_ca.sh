#!/bin/bash
sudo apt update
sudo apt install easy-rsa
mkdir ./easy-rsa
ln -s /usr/share/easy-rsa/* ./easy-rsa/
chmod 700 ./easy-rsa
cd ./easy-rsa
./easyrsa init-pki

cat <<EOF | sudo tee ./easy-rsa/vars
set_var EASYRSA_REQ_COUNTRY    "US"
set_var EASYRSA_REQ_PROVINCE   "TheMoon"
set_var EASYRSA_REQ_CITY       "Moon City"
set_var EASYRSA_REQ_ORG        "DigitalMoon"
set_var EASYRSA_REQ_EMAIL      "admin@MoonHQ.com"
set_var EASYRSA_REQ_OU         "Community"
set_var EASYRSA_ALGO           "ec"
set_var EASYRSA_DIGEST         "sha512"
EOF

./easyrsa build-ca nopass

#Common Name (eg: your user, host, or server name) [Easy-RSA CA]:moonman

#CA creation complete and you may now import and sign cert requests.
#Your new CA certificate file for publishing is at:
#/home/moop/Desktop/sysadmin_package/lib/easy-rsa/pki/ca.crt
