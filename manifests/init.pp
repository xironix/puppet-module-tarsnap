class tarsnap($ensure=present, $key_file) {
  
  apt::source { "uggedal":
    uri => "http://packages.uggedal.com",
    release => "stable",
    components => "main",
    require => Apt::Key["437C0580"],
  }

  apt::key { "437C0580":
    ensure => present,
  }

  package { "tarsnap":
    ensure => $ensure,
    require => Apt::Source["tarsnap"],
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
