class tomcat::config {
 
 service {'tomcat_service':
   ensure => 'running',
   require => File_line ['tomcat_configure'],
   }
 
 file_line {'tomcat_configure':
   path => '/etc/default/tomcat7',
   line => 'JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512m -XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC"',
   match => '^JAVA_OPTS=',
 
 }
 
}