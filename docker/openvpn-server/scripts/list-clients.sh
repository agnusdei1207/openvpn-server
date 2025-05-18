#!/bin/bash
set -e

# Move to Easy-RSA directory
cd $EASYRSA_DIR

echo "OpenVPN Client List:"
echo "--------------------"

# Extract list of certificates excluding server and ca
for cert in $(find pki/issued -type f -name "*.crt" | grep -v "server.crt" | sort); do
  client=$(basename $cert .crt)
  
  # Check if it's in the CRL (revoked)
  if openssl crl -in pki/crl.pem -noout -text | grep -q "$client"; then
    status="REVOKED"
  else
    status="ACTIVE"
  fi
  
  echo "$client - $status"
done

echo "--------------------"
