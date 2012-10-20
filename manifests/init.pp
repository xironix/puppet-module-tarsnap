class tarsnap($ensure = present, $key_file = '/etc/tarsnap.key') {
  include apt

  apt::ppa { "ppa:ironix/tarsnap": }

  package { "tarsnap":
    ensure  => $ensure,
    require => Apt::Ppa["ppa:ironix/tarsnap"],
  }

  file { "/etc/tarsnap.conf":
    content => template("tarsnap/tarsnap.conf.erb"),
    require => Package["tarsnap"],
  }
}
