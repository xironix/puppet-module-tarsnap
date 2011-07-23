Puppet Tarsnap Module
=====================

Module for configuring Tarsnap.

Tested on Debian GNU/Linux 6.0 Squeeze and Ubuntu 10.4 LTS with
Puppet 2.6. Patches for other operating systems welcome.


Installation
------------

Clone this repo to a postgresql directory under your Puppet
modules directory:

    git clone git://github.com/uggedal/puppet-module-tarsnap.git tarsnap

If you don't have a Puppet Master you can create a manifest file
based on the notes below and run Puppet in stand-alone mode
providing the module directory you cloned this repo to:

    puppet apply --modulepath=modules test_tarsnap.pp


TODO
----

* Definition of backups.
* Ability to prune older backups.


Usage
-----

To install Tarsnap, include the module:

    include tarsnap

Note that you'll need to define a global search path for the `exec`
resource to make the `tarsnap` class function properly. This
should ideally be placed in `manifests/site.pp`:

    Exec {
      path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    }
