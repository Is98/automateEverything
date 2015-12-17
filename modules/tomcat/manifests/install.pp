class tomcat::install {

  Exec {path => ['/usr/bin', '/bin', '/usr/sbin']}

 exec {'update_apt':
  command => 'apt-get update', 
  before => Package['tomcat7'],
 }

 package {"tomcat7":
 
  ensure => 'present',
 
 }

}
