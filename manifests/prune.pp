define tarsnap::prune($ensure=present,
                      $hour=1,
                      $minute=0)  {

  $prune_script = "/usr/local/bin/tarsnap-prune-${name}"

  file { $prune_script:
    ensure => $ensure,
    source => "puppet:///modules/tarsnap/tarsnap-prune.py",
    mode => 744,
  }

  cron { "tarsnap-prune-${name}":
    ensure => $ensure,
    command => "tarsnap --list-archives -v | grep -E '^${name}_' | sort -k2r | $prune_script | sed -e 's/^\(.\+\)/-f \1/' | xargs -r tarsnap -d",
    user => "root",
    hour => $hour,
    minute => $minutes_after_backup,
    require => [File[$prune_script], File[$tarsnap::key_file]],
  }
}
