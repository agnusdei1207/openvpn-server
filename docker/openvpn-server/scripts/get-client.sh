#!/bin/bash
set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <client_name>"
  exit 1
fi

CLIENT_NAME=$1

# Check if client config exists
if [ ! -f "/etc/openvpn/client/$CLIENT_NAME.ovpn" ]; then
  echo "Error: Client configuration for '$CLIENT_NAME' not found"
  exit 1
fi

# Output the client configuration
cat "/etc/openvpn/client/$CLIENT_NAME.ovpn"
