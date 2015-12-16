echo "192.168.1.150 hmaster.netbuilder.private puppet" >> /etc/hosts
curl -k https://hmaster.netbuilder.private:8140/packages/current/install.bash | sudo bash
