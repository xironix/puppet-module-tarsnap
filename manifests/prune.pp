class tarsnap::prune($ensure=present,
                     $hour=1,
                     $minute=0)  {

  $prune_script = "/usr/local/bin/tarsnap-prune"

  file { $prune_script:
    ensure => $ensure,
    source => "puppet:///modules/tarsnap/tarsnap-prune.py",
    mode => 744,
  }

  cron { "tarsnap-prune":
    ensure => $ensure,
    command => "tarsnap --list-archives -v | sort -k2r | $prune_script | sed -e 's/^\(.\+\)/-f \1/' | xargs -r tarsnap -d",
    user => "root",
    hour => $hour,
    minute => $minutes_after_backup,
    require => [File["/root/tarsnap.key"],
                File["/usr/bin/tarsnap-prune"]],
  }
}
