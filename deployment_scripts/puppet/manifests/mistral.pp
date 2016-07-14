notice('MODULAR: mistral/mistral.pp')

prepare_network_config(hiera('network_scheme', {}))

$mistral_hash               = hiera_hash('fuel-plugin-mistral', {})
$public_ip                  = hiera('public_vip')
$database_ip                = hiera('database_vip')
$management_ip              = hiera('management_vip')
$service_endpoint           = hiera('service_endpoint')
$debug                      = 'True'
$verbose                    = hiera('verbose', true)
$use_syslog                 = hiera('use_syslog', true)
$use_stderr                 = hiera('use_stderr', false)
$amqp_port                  = hiera('amqp_port')
$amqp_hosts                 = hiera('amqp_hosts')
$public_ssl_hash            = hiera_hash('public_ssl', {})
$ssl_hash                   = hiera_hash('use_ssl', {})
$external_dns               = hiera_hash('external_dns', {})
$primary_mistral            = roles_include(['primary-aic-mistral'])
$external_lb                = hiera('external_lb', false)
$api_bind_port              = '8989'
$rabbit_hosts               = split($amqp_hosts, ',')
$rabbit_userid              = 'mistral'
$rabbit_password            = $mistral_hash['rabbit_password']

$internal_auth_protocol     = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
$internal_auth_address      = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [hiera('keystone_endpoint', ''), $service_endpoint, $management_ip])
$admin_auth_protocol        = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'protocol', 'http')
$admin_auth_address         = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'hostname', [hiera('keystone_endpoint', ''), $service_endpoint, $management_ip])
$keystone_endpoint          = hiera('service_endpoint', $management_vip)
$keystone_port              = '35357'
$auth_uri                   = "${internal_auth_protocol}://${internal_auth_address}:5000/"
$identity_uri               = "${internal_auth_protocol}://${internal_auth_address}:35357/"

$keystone_tenant            = pick($mistral_hash['metadata']['tenant'],'services')
$keystone_user              = $mistral_hash['mistral_username']
$keystone_user_password     = $mistral_hash['user_password']

$api_bind_host              = get_network_role_property('mistral/api', 'ipaddr')
$tenant                     = pick($mistral_hash['tenant'], 'services')
$db_user                    = pick($mistral_hash['db_user'], 'mistral')
$db_name                    = pick($mistral_hash['db_name'], 'mistral')
$db_password                = pick($mistral_hash['db_password'], 's3cr3t')
$read_timeout               = '60'
$sql_connection             = "mysql://${db_user}:${db_password}@${database_ip}/${db_name}?read_timeout=${read_timeout}"

class { '::mistral::client': }

class { '::mistral':
  database_connection       => $sql_connection,
  rabbit_port               => $amqp_port,
  rabbit_hosts              => $rabbit_hosts,
  rabbit_password           => $rabbit_password,
  rabbit_userid             => $rabbit_userid,
  keystone_password         => $keystone_user_password,
  keystone_user             => $keystone_user,
  keystone_tenant           => $keystone_tenant,
  auth_uri                  => $auth_uri,
  identity_uri              => $identity_uri,
  verbose                   => $verbose,
  debug                     => $debug,
}

class { '::mistral::api': }

class { '::mistral::engine': }

class { '::mistral::executor': }
