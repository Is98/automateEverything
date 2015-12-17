class maven (
 $mvn_download_dir    = "http://192.168.1.6:8080/downloads/",
 $mvn_download_file   = "apache-maven-3.3.3-bin.tar.gz",
 $mvn_extract_folder  = "apache-maven-3.3.3"
) {
 include maven::install
}

