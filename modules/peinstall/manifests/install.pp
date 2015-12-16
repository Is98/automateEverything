class peinstall::install {

	Exec {
		path	=> [ "/bin", "/usr/bin", "/usr/sbin" ],
	}

	exec { 'pe_get_update'
		command 	=>	'apt-get update',
	}

	file_line { 'enterprise_host_local':
		ensure 		=> 	present,
		line 		=> 	'127.0.0.1 ${peadmin::masterHostName} ${peadmin::masterDNS}',
		path 		=> 	'/etc/hosts',
		require		=>	Exec['pe_get_update'],
	}

	file_line { 'enterprise_host_public':
		ensure 		=> 	present,
		line 		=> 	'${peadmin::masterIP} ${peadmin::masterHostName} ${peadmin::masterDNS}',
		path 		=> 	'/etc/hosts',
		require		=>	Exec['pe_get_update'],
	}

	exec { 'disable_firewall':
		command		=> 	'ufw disable',
		unless		=> 	'test ! -f /vagrant/${peadmin::extractFolder}.tar.gz',
		require		=> 	[ 	File_line['enterprise_host_local'], 
						File_line['enterprise_host_public'] 	],
	}
	
	exec { 'enterprise_get':
		cwd		=> 	'/vagrant',
		command		=> 	'wget ${peadmin::downloadLoc}/${peadmin::extractFolder}.tar.gz',
		require		=> 	Exec['disable_firewall'],
		creates		=> 	'/vagrant/${peadmin::extractFolder}.tar.gz'
	}

	exec { 'enterprise_extract':
		cwd		=> 	'/vagrant',
		command		=> 	'tar zxf ${peadmin::downloadLoc}/${peadmin::extractFolder}.tar.gz',
		require		=> 	Exec['enterprise_get'],
		creates		=> 	'/vagrant/${peadmin::extractFolder}'
	}

	file { '/vagrant/enterpriseAnswers.txt':
		content		=>	"q_install=y
q_vendor_packages_install=y
q_puppetmaster_install=y
q_all_in_one_install=y
q_puppetagent_install=y
q_puppetagent_certname=${peadmin::masterHostName}
q_puppetmaster_certname=${peadmin::masterHostName}
q_puppetmaster_dnsaltnames=hmaster,${peadmin::masterHostName},${peadmin::masterDNS}
q_pe_check_for_updates=y
q_puppet_enterpriseconsole_httpd_port=443
q_puppet_enterpriseconsole_auth_password=netbuilder
q_database_install=y
q_puppetdb_database_name=puppetdb
q_puppetdb_database_password=netbuilder
q_puppetdb_database_user=puppetdb
",
		ensure		=>	present,
	}

	exec { 'enterprise_install':
		cwd		=> 	'/vagrant/${peadmin::extractFolder}/',
		command 	=> 	'./puppet-enterprise-installer -a /vagrant/enterpriseAnswers.txt',
		creates 	=> 	'/etc/puppetlabs/code/environments/production',
		requires	=> 	File['/vagrant/enterpriseAnswers.txt'],
	}
}

