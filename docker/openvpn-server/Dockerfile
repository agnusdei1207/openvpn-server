FROM ubuntu

# Install required packages
RUN apt-get update && \
    apt-get install -y openvpn easy-rsa curl iproute2 iptables procps nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up environment
WORKDIR /opt/openvpn
ENV EASYRSA_DIR=/opt/openvpn/easy-rsa
RUN mkdir -p /etc/openvpn/client /etc/openvpn/ccd ${EASYRSA_DIR} /opt/openvpn/scripts

# Copy Easy-RSA files
RUN cp -r /usr/share/easy-rsa/* ${EASYRSA_DIR}/

# Copy initialization and management scripts
COPY docker/openvpn-server/scripts/init-openvpn.sh /opt/openvpn/scripts/
COPY docker/openvpn-server/scripts/add-client`.sh /opt/openvpn/scripts/
COPY docker/openvpn-server/scripts/revoke-client.sh /opt/openvpn/scripts/
COPY docker/openvpn-server/scripts/list-clients.sh /opt/openvpn/scripts/
COPY docker/openvpn-server/scripts/get-client.sh /opt/openvpn/scripts/
COPY docker/openvpn-server/scripts/entrypoint.sh /opt/openvpn/scripts/

# Copy server configuration template
COPY docker/openvpn-server/config/server.conf.template /opt/openvpn/

# Make scripts executable
RUN chmod +x /opt/openvpn/scripts/*.sh

# Set up volume for persistent data
VOLUME ["/etc/openvpn"]

# Expose OpenVPN port
EXPOSE 1194/udp

# Run entrypoint script
ENTRYPOINT ["/opt/openvpn/scripts/entrypoint.sh"]
