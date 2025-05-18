#!/bin/bash
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <client_name>"
  exit 1
fi

CLIENT_NAME=$1
PUBLIC_IP=${PUBLIC_IP:-$(curl -s ifconfig.me)}
OVPN_PORT=${OVPN_PORT:-1194}
OVPN_PROTO=${OVPN_PROTO:-"udp"}

# Check if client already exists
if [ -f "$EASYRSA_DIR/pki/issued/$CLIENT_NAME.crt" ]; then
  echo "Error: Client certificate for '$CLIENT_NAME' already exists"
  exit 1
fi

# Move to Easy-RSA directory
cd $EASYRSA_DIR

# Generate client certificate and key
./easyrsa --batch gen-req "$CLIENT_NAME" nopass
./easyrsa --batch sign-req client "$CLIENT_NAME"

# Generate client config
cat > "/etc/openvpn/client/$CLIENT_NAME.ovpn" << EOF
client
dev tun
proto $OVPN_PROTO
remote $PUBLIC_IP $OVPN_PORT
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-eku "TLS Web Server Authentication"
cipher AES-256-CBC
verb 3
tls-auth ta.key 1
key-direction 1

<ca>
$(cat /etc/openvpn/ca.crt)
</ca>

<cert>
$(cat $EASYRSA_DIR/pki/issued/$CLIENT_NAME.crt)
</cert>

<key>
$(cat $EASYRSA_DIR/pki/private/$CLIENT_NAME.key)
</key>

<tls-auth>
$(cat /etc/openvpn/ta.key)
</tls-auth>
EOF

echo "Client '$CLIENT_NAME' added successfully!"
echo "OVPN file created at: /etc/openvpn/client/$CLIENT_NAME.ovpn"
