# powerdns
#
# @param autoprimaries
#   Hash of autoprimaries the ensurce (with resource powerdns_autoprimary)
# @param purge_autoprimaries
#   Set this to true if you like to purge all autoprimaries not managed with puppet
# @param lmdb_filename
#   Filename for the lmdb database
# @param lmdb_schema_version
#   Maximum allowed schema version to run on this DB. If a lower version is found, auto update is performed
# @param lmdb_shards
#   Records database will be split into this number of shards
# @param lmdb_sync_mode
#   Sync mode for LMDB. One of 'nosync', 'sync', 'nometasync', 'mapasync'
#
class powerdns (
  Boolean                    $authoritative                      = true,
  Boolean                    $recursor                           = false,
  String[1]                  $authoritative_group                = $powerdns::params::authoritative_group,
  Enum[
    'ldap',
    'mysql',
    'bind',
    'postgresql',
    'sqlite',
    'lmdb'
  ]                          $backend                            = 'mysql',
  Boolean                    $backend_install                    = true,
  Boolean                    $backend_create_tables              = true,
  Powerdns::Secret           $db_root_password                   = undef,
  String[1]                  $db_username                        = 'powerdns',
  Powerdns::Secret           $db_password                        = undef,
  String[1]                  $db_name                            = 'powerdns',
  String[1]                  $db_host                            = 'localhost',
  Integer[1]                 $db_port                            = 3306,
  String[1]                  $db_dir                             = $powerdns::params::db_dir,
  String[1]                  $db_file                            = $powerdns::params::db_file,
  Boolean                    $require_db_password                = true,
  String[1]                  $ldap_host                          = 'ldap://localhost/',
  Optional[String[1]]        $ldap_basedn                        = undef,
  String[1]                  $ldap_method                        = 'strict',
  Optional[String[1]]        $ldap_binddn                        = undef,
  Powerdns::Secret           $ldap_secret                        = undef,
  Stdlib::Absolutepath       $lmdb_filename                      = '/var/lib/powerdns/pdns.lmdb',
  Optional[Integer]          $lmdb_schema_version                = undef,
  Optional[Integer]          $lmdb_shards                        = undef,
  Optional[
    Enum[
      'nosync',
      'sync',
      'nometasync',
      'mapasync'
    ]
  ]                          $lmdb_sync_mode                     = undef,
  Boolean                    $custom_epel                        = true,
  Pattern[/4\.[0-9]+/]       $authoritative_version              = $powerdns::params::authoritative_version,
  Pattern[/[4,5]\.[0-9]+/]   $recursor_version                   = $powerdns::params::recursor_version,
  String[1]                  $mysql_schema_file                  = $powerdns::params::mysql_schema_file,
  String[1]                  $pgsql_schema_file                  = $powerdns::params::pgsql_schema_file,
  Hash                       $forward_zones                      = {},
  Powerdns::Autoprimaries    $autoprimaries                      = {},
  Boolean                    $purge_autoprimaries                = false,
) inherits powerdns::params {
  # Do some additional checks. In certain cases, some parameters are no longer optional.
  if $authoritative {
    if $require_db_password and !($powerdns::backend in ['bind', 'ldap', 'sqlite', 'lmdb']) {
      assert_type(Variant[String[1], Sensitive[String[1]]], $db_password) |$expected, $actual| {
        fail("'db_password' must be a non-empty string when 'authoritative' == true")
      }
      if $backend_install {
        assert_type(Variant[String[1], Sensitive[String[1]]], $db_root_password) |$expected, $actual| {
          fail("'db_root_password' must be a non-empty string when 'backend_install' == true")
        }
      }
    }
    if $backend_create_tables and $backend == 'mysql' {
      assert_type(Variant[String[1], Sensitive[String[1]]], $db_root_password) |$expected, $actual| {
        fail("On MySQL 'db_root_password' must be a non-empty string when 'backend_create_tables' == true")
      }
    }
  }

  if $authoritative {
    contain powerdns::authoritative

    # Set up Hiera. Even though it's not necessary to explicitly set $type for the authoritative
    # config, it is added for clarity.
    $powerdns_auth_config = lookup('powerdns::auth::config', Hash, 'deep', {})
    $powerdns_auth_defaults = { 'type' => 'authoritative' }
    create_resources(powerdns::config, $powerdns_auth_config, $powerdns_auth_defaults)
  }

  if $recursor {
    contain powerdns::recursor

  }

  # Recursor configuration is handled in recursor.pp

  if $purge_autoprimaries {
    resources { 'powerdns_autoprimary':
      purge => true,
    }
  }
  create_resources('powerdns_autoprimary', $autoprimaries)
}
