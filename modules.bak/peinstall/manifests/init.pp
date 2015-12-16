class peinstall (
	$masterIP 		= 	'192.168.1.150',
	$masterHostName		= 	'hmaster.netbuilder.private', 
	$masterDNS 		= 	'puppet',
	$downloadLoc		= 	'http://192.168.1.6:8080/downloads',
	$extractFolder		= 	'puppet-enterprise-2015.2.0-ubuntu-14.04-amd64',
) {
	include peinstall::install

}