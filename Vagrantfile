Vagrant.configure(2) do |config|
	
	masterIP = "192.168.1.150"
	masterHostname = "hmaster"
	masterFQDN = masterHostname + ".netbuilder.private"
	agentHostnameStub = "hagent"
	agentCount = 3
	
	config.vm.provider :virtualbox do |masterVB|
		masterVB.memory = 2048
		masterVB.cpus = 2
	end
	
	
	config.vm.box = "ubuntu/trusty64"

	#config.vm.provision "all",
	#	type: "shell",
	#	path: "all.sh",
	#	run: "always"
	
	config.vm.define "master" do |master|
		master.vm.hostname = masterFQDN
		master.vm.network "public_network", ip: masterIP
	
		master.vm.provision "puppetinstall",
			type: "shell",
			path: "enterprise_install.sh"
		master.vm.synced_folder "modules/", "/etc/puppetlabs/code/environments/production/modules"
	#	master.vm.synced_folder "modules/", "/etc/puppet/modules"
	#	master.vm.synced_folder "site_standalone/", "/etc/puppetlabs/manifests"

	#	master.vm.provision "puppet" do |puppet|
	#		puppet.manifests_path = "site_standalone"
   	#		puppet.manifest_file = "site.pp"
	#		puppet.module_path = "modules"
	#	end
		config.vm.provider :virtualbox do |masterVB|
			masterVB.memory = 4568
			masterVB.cpus = 2
		end
	end
	
	for i in 1..agentCount 
		config.vm.define "agent" + i.to_s do |agent|
			agent.vm.hostname = agentHostnameStub + i.to_s
			agent.vm.network "public_network"
			
			agent.vm.provision "agent",
				type: "shell",
				path: "agent.sh"
		end
	end
end
