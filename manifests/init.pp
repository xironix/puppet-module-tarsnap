class tarsnap($ensure=present, $key_file, $version="1.0.29") {
  
  tarsnap::install { $version:
    ensure => $ensure,
  }

  file { $key_file:
    ensure => present, # Always present, we don't want to delete it.
    mode => 600,
  }

  file { "/etc/tarsnap.conf":
    content => template("tarsnap/tarsnap.conf.erb"),
    require => Tarsnap::Install[$version],
  }
}
