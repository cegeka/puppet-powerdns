# @summary powerdns recursor

# @param package_ensure
# @param forward_zones
#   Hash containing zone => dns servers pairs
# @param recursor_dir
#   Configuration directory for recursor
#
class powerdns::recursor (
  String $package_ensure = $powerdns::params::default_package_ensure,
  Hash   $forward_zones  = lookup('profile::iac::powerdns::recursor::forward_zones', { 'default_value' => {}, 'merge' => 'deep' }),
  String $recursor_dir   = $powerdns::recursor_dir,
) inherits powerdns {
  package { $powerdns::recursor_package:
    ensure => $package_ensure,
  }

  $powerdns_recursor_config = lookup('profile::iac::powerdns::recursor::config', { 'default_value' => {}, 'merge' => 'deep' })

  file { "${recursor_dir}/recursor.conf":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('powerdns/recursor.conf.erb'),
      notify  => Service['pdns-recursor'],
    }



  if !empty($forward_zones) {
    $zone_config = "${recursor_dir}/forward-zones"
    file { $zone_config:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('powerdns/forward_zones.conf.erb'),
      notify  => Service['pdns-recursor'],
    }
  }

  service { 'pdns-recursor':
    ensure  => running,
    name    => $powerdns::params::recursor_service,
    enable  => true,
    require => Package[$powerdns::params::recursor_package],
  }
}
