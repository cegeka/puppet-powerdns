# [Puppet](https://puppetlabs.com/) powerdns module

[![Build Status](https://travis-ci.org/christiangda/puppet-powerdns.svg?branch=master)](https://travis-ci.org/christiangda/puppet-powerdns)
[![Puppet Forge](http://img.shields.io/puppetforge/v/christiangda/powerdns.svg)](https://forge.puppetlabs.com/christiangda/powerdns)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/christiangda/powerdns.svg)](https://forge.puppetlabs.com/christiangda/powerdns/scores)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with powerdns](#setup)
    * [What powerdns affects](#what-powerdns-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with powerdns](#beginning-with-powerdns)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This is a [Puppet](https://puppetlabs.com/) module to manage [PowerDNS](https://www.powerdns.com/) tool.  With this module you can installs, configures, and manages the [PowerDNS](https://www.powerdns.com/) services.

This module were designed to work with [Puppet](https://puppetlabs.com/) version >= 3.8.0

## Module Description

[PowerDNS](https://www.powerdns.com/) consists of two parts: the Authoritative Server and the Recursor, and you can use this module to configure both.
For both [PowerDNS](https://www.powerdns.com/) operation modes, you could install, configure and manage the services,  is very easy used this to configure your [PowerDNS](https://www.powerdns.com/), in fact, you have predefined configuration values to put and run.

## Setup

### What ::powerdns affects

* Debian Family:
    1. Packages [
      'pdns-backend-geo',
      'pdns-backend-ldap',
      'pdns-backend-lua',
      'pdns-backend-mysql',
      'pdns-backend-pgsql',
      'pdns-backend-pipe',
      'pdns-backend-sqlite3'
    ]
    2. Files [
      '/etc/powerdns/bindbackend.conf',
      '/etc/powerdns/pdns.d/pdns.simplebind.conf',
      '/etc/powerdns/pdns.d/pdns.local.conf',
    ]
    3. Services [
      'pdns'
    ]
* RedHat Family
    1. Packages [
      'pdns-backend-geo',
      'pdns-backend-lua',
      'pdns-backend-ldap',
      'pdns-backend-lmdb',
      'pdns-backend-pipe',
      'pdns-backend-geoip',
      'pdns-backend-mydns',
      'pdns-backend-mysql',
      'pdns-backend-remote',
      'pdns-backend-sqlite',
      'pdns-backend-opendbx',
      'pdns-backend-tinydns',
      'pdns-backend-postgresql'
    ]
    2. Files [
      '/etc/pdns/bindbackend.conf',
      '/etc/pdns/pdns.d/pdns.simplebind.conf',
      '/etc/pdns/pdns.d/pdns.local.conf'
    ]
    3. Services [
      'pdns-recursor'
    ]

* Is very important to know about [PowerDNS](https://www.powerdns.com/) to use this [Puppet](https://puppetlabs.com/) module.

### Beginning with ::powerdns

You can use
```puppet
include ::powerdns
include ::powerdns::backend
```
or
```puppet
class { '::powerdns': }
class { '::powerdns::backend': }
```
to install and configure [PowerDNS](https://www.powerdns.com/) with Default module parameters.

additional you could use
```puppet
include ::powerdns::recursor
```
or
```puppet
class { '::powerdns::recursor': }
```
if you want to configure [PowerDNS](https://www.powerdns.com/) Recursor service.

## Usage

For more specific configuration of powerdns class you can use:
```puppet
class { '::powerdns':
  package_ensure     => 'present',
  service_enable     => true,
  service_ensure     => 'running',
  service_status     => true,
  service_status_cmd => '/usr/bin/pdns_control ping 2>/dev/null 1>/dev/null',
  # All the values in config hash could be extracted from: https://doc.powerdns.com/md/authoritative/settings/
  config => {
    allow-from      => '192.168.1.0/24',
    local-port      => 53,
    query-cache-ttl => 20,
  }
}
```
To configure PostgreSQL as backend, you can do:
```puppet
class { '::powerdns::backend':
  backend_name => 'pgsql',
  ensure       => 'present',
  # All the values in config hash could be extracted from: https://doc.powerdns.com/md/authoritative/
  config       => {
    launch          => 'gpgsql',
    gpgsql-host     => 'localhost',
    gpgsql-port     => '3306',
    gpgsql-dbname   => 'mypdnsdb',
    gpgsql-user     => 'mypdnsuser',
    gpgsql-password => 'mypassword',
  }
}
```

For more specific configuration of PowerDNS Recursor class you can use:
```puppet
class { '::powerdns::recursor':
  package_ensure     => 'present',
  service_enable     => true,
  service_ensure     => 'running',
  service_status     => true,
  service_status_cmd => '/usr/bin/rec_control ping 2>/dev/null 1>/dev/null'
  # All the values in config hash could be extracted from: https://doc.powerdns.com/md/recursor/settings/
  config => {
    allow-from                 => '192.168.1.0/24',
    aaaa-additional-processing => true,
    local-port                 => 5353,
    etc-hosts-file             => '/etc/hosts',
  }
}
```

## Reference

* [Puppet](https://puppetlabs.com/)
* [PowerDNS](https://www.powerdns.com/)
  * [Authoritative Settings](https://doc.powerdns.com/md/authoritative/settings/)
  * [Recursor Settings](https://doc.powerdns.com/md/recursor/settings/)
* [Rubocop](https://github.com/bbatsov/rubocop)
* [rspec-puppet](http://rspec-puppet.com/)
* [puppet-blacksmith](https://github.com/voxpupuli/puppet-blacksmith)
* [RSpec For Ops Part 2: Diving in with rspec-puppet](http://blog.danzil.io/page2/)


## Limitations

This module could not manage DNS records, this only can be used as configuration of [PowerDNS](https://www.powerdns.com/).

## Development / contributing

1. [Fork it](https://github.com/christiangda/puppet-powerdns#fork-destination-box)
2. [Clone it](https://github.com/christiangda/puppet-powerdns.git) (`git clone https://github.com/christiangda/puppet-powerdns.git; cd puppet-powerdns`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. [Create new Pull Request](https://github.com/christiangda/puppet-powerdns/pull/new/master)

Of course, bug reports and suggestions for improvements are always
welcome. GitHub pull requests are even better! :-)

You can also support my work on apache_storm via
[Gratipay](https://gratipay.com/~645e3ac3c159/).

[![Support via Gratipay](https://cdn.rawgit.com/gratipay/gratipay-badge/2.1.3/dist/gratipay.png)](https://gratipay.com/~645e3ac3c159/)

## Authors

Note: This module is a merge of the work from the following authors:
* [christiangda](https://github.com/christiangda)

## License

This module is released under the GNU General Public License Version 3:

* [http://www.gnu.org/licenses/gpl-3.0-standalone.html](http://www.gnu.org/licenses/gpl-3.0-standalone.html)
