echo "192.168.1.150 hmaster puppet" >> /etc/hosts
curl -k https://hmaster:8140/packages/current/install.bash | sudo bash
