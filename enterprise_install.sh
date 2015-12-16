sudo su
echo "127.0.0.1 hmaster puppet" >> /etc/hosts
echo "192.168.1.150 hmaster puppet" >> /etc/hosts
ufw disable
cd /vagrant
wget http://192.168.1.6:8080/downloads/puppet-enterprise-2015.2.0-ubuntu-14.04-amd64.tar.gz
tar zxf puppet-enterprise-2015.2.0-ubuntu-14.04-amd64.tar.gz
cd puppet-enterprise-2015.2.0-ubuntu-14.04-amd64
./puppet-enterprise-installer -a answers/myanswers.txt

