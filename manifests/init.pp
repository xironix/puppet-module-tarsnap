class tarsnap($ensure = present, $key_file) {
  include apt

  apt::ppa { "ppa:ironix/tarsnap": }

  package { "tarsnap":
    ensure  => $ensure,
    require => Apt::Ppa["ppa:ironix/tarsnap"],
  }

  file { $key_file:
    ensure => present, # Always present, we don't want to delete it.
    mode   => '0600',
  }

  file { "/etc/tarsnap.conf":
    content => template("tarsnap/tarsnap.conf.erb"),
    require => Package["tarsnap"],
  }
}
