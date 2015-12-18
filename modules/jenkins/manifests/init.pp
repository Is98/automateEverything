# == Class: jenkins
#
# Full description of class jenkins here.
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
#  class { jenkins:
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
class jenkins {
 
 Exec {
 path => ["/usr/bin","/bin", "/usr/sbin"]
}  

  exec { 'install_jenkins_package_keys':
    command => '/usr/bin/wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | /usr/bin/apt-key add - ',
    unless => "test -f /etc/apt/sources.list.d/jenkins.list",
  }

  file { "/etc/apt/sources.list.d/jenkins.list":
      mode => 644,
     owner => root,
     group => root,
    content => "deb http://pkg.jenkins-ci.org/debian binary/",
    require => Exec['install_jenkins_package_keys'],
  }

  exec { 'get_update': 
      command => '/usr/bin/apt-get update',
      require => [File['/etc/apt/sources.list.d/jenkins.list'],
                  Exec['install_jenkins_package_keys'],],
  }

  package { 'jenkins':
      ensure => latest,
    require  => [ Exec['install_jenkins_package_keys'],
                  File['/etc/apt/sources.list.d/jenkins.list'],
                  Exec['get_update'], ],
  }

  service { 'jenkins_service':
    ensure => running,
    require => Package['jenkins'],
    name => "jenkins", 
  }

}


