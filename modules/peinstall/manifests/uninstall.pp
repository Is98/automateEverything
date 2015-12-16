class peinstall::uninstall {

	exec { 'pe_get_update' :
		command 	=>	'/opt/puppetlabs/bin/puppet-enterprise-uninstaller -p -d -y',

	}
}
