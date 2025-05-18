#!/bin/bash
set -e

# Variables
OVPN_SERVER_NETWORK=${OVPN_SERVER_NETWORK:-"10.8.0.0"}
OVPN_SERVER_NETMASK=${OVPN_SERVER_NETMASK:-"255.255.255.0"}
OVPN_PORT=${OVPN_PORT:-1194}
OVPN_PROTO=${OVPN_PROTO:-"udp"}
PUBLIC_IP=${PUBLIC_IP:-$(curl -s ifconfig.me)}

# Move to Easy-RSA directory
cd $EASYRSA_DIR

# Initialize PKI
./easyrsa init-pki
./easyrsa --batch build-ca nopass

# Generate server certificate and key
./easyrsa --batch gen-req server nopass
./easyrsa --batch sign-req server server

# Generate Diffie-Hellman parameters
./easyrsa gen-dh

# Generate TLS key
openvpn --genkey secret ta.key

# Copy server certificates and keys to OpenVPN directory
cp pki/ca.crt /etc/openvpn/
cp pki/issued/server.crt /etc/openvpn/
cp pki/private/server.key /etc/openvpn/
cp pki/dh.pem /etc/openvpn/
cp ta.key /etc/openvpn/

# Create empty CRL
./easyrsa gen-crl
cp pki/crl.pem /etc/openvpn/

# Create server.conf from template
sed -e "s|{{PORT}}|$OVPN_PORT|g" \
    -e "s|{{PROTO}}|$OVPN_PROTO|g" \
    -e "s|{{NETWORK}}|$OVPN_SERVER_NETWORK|g" \
    -e "s|{{NETMASK}}|$OVPN_SERVER_NETMASK|g" \
    /opt/openvpn/server.conf.template > /etc/openvpn/server.conf

echo "OpenVPN server initialized successfully!"
