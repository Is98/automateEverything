# == Class: nexus
#
# Full description of class nexus here.
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
#  class { nexus:
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
class nexus {

Exec {
 path => ["/usr/bin","/bin", "/usr/sbin"]
}

exec {'download_nexus':
 cwd => "/opt/",
 creates =>  "/opt/nexus-latest-bundle.tar.gz",
 command => "wget http://192.168.1.6:8080/downloads/nexus-latest-bundle.tar.gz",
 require => Package['wget'],
 }

exec { 'extract_nexus': 
 creates => "/usr/local/sonatype-work",
 command => "tar zxvf /opt/nexus-latest-bundle.tar.gz -C /usr/local/",
 cwd => "/opt/",
 require => Exec['download_nexus']
 }

exec { 'link_nexus': 
 command => "ln -s /usr/local/nexus-2.11.4-01 /usr/local/nexus",
 creates => "/usr/local/nexus",
 require => Exec['extract_nexus'],
 }

user { 'nexus_user':
 name => "nexus",
 password => "",
 }

file { '/usr/local/nexus-2.11.4-01':
 owner => "nexus",
 require => [Exec['link_nexus'],
            User['nexus_user']], 
 }

file { '/usr/local/sonatype-work': 
 owner => "nexus", 
 require => [Exec['link_nexus'],
            User['nexus_user']],
 }

#exec { 'run_nexus':
# cwd => "/usr/local/nexus",
# command => "su nexus -c './bin/nexus start'",
# require => [Exec['change_nexus_owner'],
#             Exec['change_sona_owner']],
# }

exec { 'copy_nexus_to_service':
 command => "cp /usr/local/nexus/bin/nexus /etc/init.d/nexus",
 unless => "test -f /etc/init.d/nexus",
 require => [File['/usr/local/nexus-2.11.4-01'],
            File['/usr/local/sonatype-work']],
}

file {'/etc/init.d/nexus':
# source => "/usr/local/nexus/bin/nexus",
 ensure => present,  
 owner => "root",
 mode => "0755",
 require => Exec['copy_nexus_to_service'],
 }

file_line { 'nexus_home' :
 path => "/etc/init.d/nexus",
 line => "NEXUS_HOME=\"/usr/local/nexus\"",
 match => "NEXUS_HOME=\"..\"", 
 require => File['/etc/init.d/nexus'], 
 ensure => present,
}

file_line { 'nexus_RUN_AS_USER' :
 path => "/etc/init.d/nexus",
 line => "RUN_AS_USER=\"nexus\"",
 match => "#RUN_AS_USER=",
 require => File['/etc/init.d/nexus'],
 ensure => present,
}


file_line { 'nexus_PIDDIR' :
 path => "/etc/init.d/nexus",
 line => "PIDDIR=\"/home/nexus\"",
 match => "#PIDDIR=\".\"",
 require => File['/etc/init.d/nexus'],
 ensure => present,
}

file {'/home/nexus':
 ensure=> "directory",
 owner => "nexus",
 mode => "0755",
 }

service {'running_nexus':
 ensure => running, 
 name => "nexus",
 require => [File_line['nexus_home'],
             File_line['nexus_RUN_AS_USER'],
             File_line['nexus_PIDDIR'],
             File['/home/nexus']],
 }
}
