#!/bin/bash
set -e

# Initialize OpenVPN if not already initialized
if [[ ! -f /etc/openvpn/server.conf ]]; then
  echo "Initializing OpenVPN server..."
  /opt/openvpn/scripts/init-openvpn.sh
fi

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Set up NAT rules
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

# Start OpenVPN server
echo "Starting OpenVPN server..."
exec openvpn --config /etc/openvpn/server.conf
