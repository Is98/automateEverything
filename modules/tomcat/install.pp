class tomcat::install {

 exec {'update_apt':
  command => 'apt-get update', 
  before => Package ['tomcat7'],
 }

 package {"tomcat7":
 
  ensure => 'present',
 
 }

}