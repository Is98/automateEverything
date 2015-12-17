# == Class: java
#
# Full description of class java here.
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
#  class { java:
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
class java (
  $java_download_server = "http://192.168.1.6:8080/downloads/",
  $java_download_file = "jdk-7u79-linux-x64.tar.gz",
 ) {


Exec {
 path => ["/usr/bin","/bin", "/usr/sbin"]
}

package { 'wget':
 ensure => 'installed',
}

exec { 'download_java':
 cwd => "/opt/",
 creates => "/opt/jdk-7u79-linux-x64.tar.gz",
 command => "wget ${java_download_server}${$java_download_file}",
 require => Package['wget'],
}

exec { 'extract_java':
 creates => "/opt/jdk1.7.0_79",
 command => "tar zxvf ${java_download_file}",
 cwd => "/opt",
 require => Exec['download_java'],
}

exec { 'update-alternatives':
 command => "update-alternatives --install /usr/bin/java java /opt/jdk1.7.0_79/bin/java 2",
 creates => "/usr/bin/java",
 require => Exec['extract_java'],
} 

#exec { 'add_java_variables':
 #command => echo "export JAVA_HOME=/opt/jdk..." >> ~/.bashrc && echo "export JRE_HOME=/opt/jdk..." >> ~/.bashrc && echo "PATH=$PATH:%JAVA_HOME%/bin:%JRE_HOME" >> ~/.bashrc && echo "export PATH" >> ~/.bashrc
#}

file { '/etc/profile.d/java.sh':
 ensure	=> present,
 content => 'export JAVA_HOME=/opt/jdk1.7.0_79
export JRE_HOME=/opt/jdk1.7.0_79/jre
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin',
 require => Exec['update-alternatives']
}

}

