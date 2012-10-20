Puppet Tarsnap Module
=====================

Module for configuring Tarsnap.

Tested on Debian GNU/Linux 6.0 Squeeze and Ubuntu 12.04 LTS with
Puppet 2.6. Patches for other operating systems welcome.

TODO
----

* Do not copy files to /tmp before taking a backup, is to IO
  intensive.
* Add tarsnap user and use it to run backups from.


Installation
------------

Clone this repo and all its dependencies to respective directories under
your Puppet modules directory:

    git clone git://github.com/xironix/puppet-module-tarsnap.git
    git clone git://github.com/xironix/puppet-module-tarsnap.git tarsnap

If you don't have a Puppet Master you can create a manifest file
based on the notes below and run Puppet in stand-alone mode
providing the module directory you cloned this repo to:

    puppet apply --modulepath=modules test_tarsnap.pp


Usage
-----

Taking backups of files, directories, and output from commands are handled
by the `tarsnap::backup` resource. Syntax of the hour and minute arguments
follows the behavior of the equivalent arguments to the `cron` resource.
The commands, directories, and files arguments are  Puppet hashes:

    tarsnap::backup { "web-resources":
      commands => {
        'blog.sql' => 'sudo -u postgres pg_dump blog',
        'cms.json' => 'sudo -u www-mgr /var/www/cms/manage.py backup',
      },
      directories => {
        'cms-photos' => '/var/www/cms/static',
      },
      files => {
        'cms-settings' => '/var/www/cms/settings.py',
      },
      hour => '*',
      minute => 15,
    }

To prune old backups use the `tarsnap::prune` resource with the same
name argument as you used for the backup you want to prune:

    tarsnap::prune { "web-resources":
      hour => 1,
      minute => 45,
    }

The tarsnap pruner keeps the following number of backups:

* today: all
* yesterday: up to 12
* 2 days ago: up to 6
* 3-6 days ago: up to 2 per day
* 7-30 days ago: up to 1 per day
* more than 30 days ago: up to 1 per month
