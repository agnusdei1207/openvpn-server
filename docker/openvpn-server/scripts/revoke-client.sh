#!/bin/bash
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <client_name>"
  exit 1
fi

CLIENT_NAME=$1

# Check if client exists
if [ ! -f "$EASYRSA_DIR/pki/issued/$CLIENT_NAME.crt" ]; then
  echo "Error: Client certificate for '$CLIENT_NAME' not found"
  exit 1
fi

# Move to Easy-RSA directory
cd $EASYRSA_DIR

# Revoke client certificate
./easyrsa revoke "$CLIENT_NAME"
./easyrsa gen-crl

# Copy CRL to OpenVPN directory
cp pki/crl.pem /etc/openvpn/

# Remove client configuration
rm -f "/etc/openvpn/client/$CLIENT_NAME.ovpn"

echo "Client '$CLIENT_NAME' revoked successfully!"
