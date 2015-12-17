# == Class: maven
#
# Full description of class maven here.
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
#  class { maven:
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
class maven::install (
 $mvn_extract_to = "/opt/",
)
{

 Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin"]
 }

 exec { 'check_mvn_folder_exists':
  command => "mkdir ${mvn_extract_to}",
  creates => "${mvn_extract_to}",
  require => Class['java'],
 }

 exec {'download_maven':
  cwd => "${mvn_extract_to}",
  creates => "${mvn_extract_to}${maven::mvn_download_file}",
  command => "wget ${maven::mvn_download_dir}${$maven::mvn_download_file}",
  require => Exec['check_mvn_folder_exists'],
 }

 exec { 'extract_maven':
  creates => "${mvn_extract_to}${maven::mvn_extract_folder}",
  command => "tar zxvf ${maven::mvn_download_file}",
  cwd => "${mvn_extract_to}",
  require => Exec['download_maven'],
 }
 
 exec { 'maven-update-alternatives': 
  command => "update-alternatives --install /usr/bin/mvn mvn ${mvn_extract_to}${maven::mvn_extract_folder}/bin/mvn 2",
  creates => "/usr/bin/mvn",
  require => Exec['extract_maven'],
 }

 file { '/etc/profile.d/mvn.sh':
  ensure => present, 
  content => 'export MVN_HOME=${mvn_extract_to}${mvn_extract_folder}
  export PATH=$PATH:$MVN_HOME/bin',
  require => Exec['maven-update-alternatives'],
 } 
}
