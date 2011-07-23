class tarsnap($ensure=present, $version="1.0.29") {
  
  tarsnap::install { $version:
    ensure => $ensure,
  }
}
