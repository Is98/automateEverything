class tomcat::config {
 
 service {'tomcat_service':
   ensure => 'running',
   require => Class['tomcat::install'],
 }
 
}
