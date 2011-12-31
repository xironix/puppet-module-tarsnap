class tarsnap($ensure=present, $key_file) {

  package { "tarsnap":
    ensure => $ensure,
    require => Apt::Source["uggedal"],
  }

  file { $key_file:
    ensure => present, # Always present, we don't want to delete it.
    mode => 600,
  }

  file { "/etc/tarsnap.conf":
    content => template("tarsnap/tarsnap.conf.erb"),
    require => Package["tarsnap"],
  }
}
