# == Class: jira
#
# Full description of class jira here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { jira:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class jira {


Exec {
 path => ["/usr/bin", "/bin","/usr/sbin"]
}

#exec { 'download_jira':
# cwd => "/opt/",
# creates => "/opt/atlassian-jira-software-7.0.3-jira-7.0.3-x64.bin",
# command => "wget http://192.168.1.6:8080/downloads/atlassian-jira-software-7.0.3-jira-7.0.3-x64.bin",
# require => Package['wget']
# }

#exec { 'set_jira_exec':
# cwd => "/opt",
# command => "chmod a+x atlassian-jira-software-7.0.3-jira-7.0.3-x64.bin",
# require => Exec['download_jira'], 
#}

file { '/opt/atlassian-jira-software-7.0.3-jira-7.0.3-x64.bin':
 source => "puppet:///modules/jira/atlassian-jira-software-7.0.3-jira-7.0.3-x64.bin",
 mode => 0755,
}


file { '/opt/response.varfile':
 ensure => present,
 content => "#install4j response file for JIRA Software 7.0.3
#Wed Dec 09 09:54:49 UTC 2015
rmiPort$Long=8095
app.jiraHome=/var/atlassian/application-data/jira
app.install.service$Boolean=true
existingInstallationDir=/opt/JIRA Software
sys.confirmedUpdateInstallationString=false
sys.languageId=en
sys.installationDir=/opt/atlassian/jira
executeLauncherAction$Boolean=true
httpPort$Long=8090
portChoice=custom",
	require => File['/opt/atlassian-jira-software-7.0.3-jira-7.0.3-x64.bin'],

 }
 
exec { 'jira_run':
 cwd 	=> 	"/opt",
 command => 	"/opt/atlassian-jira-software-7.0.3-jira-7.0.3-x64.bin -q -varfile /opt/response.varfile",
 require => 	File['/opt/response.varfile'], 
 creates => 	"/opt/atlassian/jira",
} 

#exec { 'start_jira':
# cwd => "/opt/atlassian/jira/bin",
# command => "/opt/atlassian/jira/bin/start-jira.sh",
# require => Exec['jira_run'],
#}
}

