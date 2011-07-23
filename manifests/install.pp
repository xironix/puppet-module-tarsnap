define tarsnap::install($ensure=present) {
  $version = $name

  $tarsnap_root = "/usr/local/src/tarsnap-${version}"
  $tarsnap_deb = "${tarsnap_root}/tarsnap_${version}_${architecture}.deb"
  $tarsnap_src = "${tarsnap_root}/tarsnap-autoconf-${version}"
  $url = "https://www.tarsnap.com/download/tarsnap-autoconf-${version}.tgz"

  if $ensure == 'present' {

    # Deps for building tarsnap:
    package { ["build-essential",
               "debhelper",
               "e2fslibs-dev",
               "libbz2-dev",
               "zlib1g-dev",
               "libssl-dev"]:
      ensure => $ensure,
      before => Exec["install-tarsnap-$version"],
    }

    file { $tarsnap_root:
      ensure => "directory",
    }

    exec { "fetch-tarsnap-$version":
      command => "wget -q -O - $url | tar -xz",
      cwd => $tarsnap_root,
      creates => $tarsnap_src,
      require => File[$tarsnap_root],
    }

    exec { "install-tarsnap-$version":
      command => "ln -s pkg/debian . && dpkg-buildpackage && dpkg -i $tarsnap_deb",
      cwd => $tarsnap_src,
      unless => "test `tarsnap --version | cut -d ' ' -f 2` = '${version}'",
      require => Exec["fetch-tarsnap-$version"],
    }

  } else {
    package { "tarsnap":
      ensure => $ensure,
    }

    file { $tarsnap_root:
      ensure => $ensure,
      recurse => true,
      purge => true,
      force => true,
    }
  }
}
