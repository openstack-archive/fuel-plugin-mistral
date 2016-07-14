notice('MODULAR: mistral/keystone.pp')

$mistral_hash        = hiera_hash('fuel-plugin-mistral', {})
$public_ssl_hash     = hiera('public_ssl')
$public_vip          = hiera('public_vip')
$public_address      = $public_ssl_hash['services'] ? {
  true    => $public_ssl_hash['hostname'],
  default => $public_vip,
}
$public_protocol     = $public_ssl_hash['services'] ? {
  true    => 'https',
  default => 'http',
}
$admin_protocol      = 'http'
$admin_address       = hiera('management_vip')
$region              = pick($mistral_hash['metadata']['region'], hiera('region', 'RegionOne'))

$password            = pick($mistral_hash['user_password'], 'password')
$auth_name           = pick($mistral_hash['metadata']['auth_name'], 'mistral')
$configure_endpoint  = pick($mistral_hash['metadata']['configure_endpoint'], true)
$configure_user      = pick($mistral_hash['metadata']['configure_user'], true)
$configure_user_role = pick($mistral_hash['metadata']['configure_user_role'], true)
$service_name        = pick($mistral_hash['metadata']['service_name'], 'mistral')
$tenant              = pick($mistral_hash['metadata']['tenant'], 'services')

$port = '8989'

$public_url          = "${public_protocol}://${public_address}:${port}/v2"
$admin_url           = "${admin_protocol}://${admin_address}:${port}/v2"

validate_string($public_address)
validate_string($password)

class { 'mistral::keystone::auth':
  password           => $password,
  auth_name          => $auth_name,
  configure_endpoint => $configure_endpoint,
  service_name       => $service_name,
  public_url         => $public_url,
  internal_url       => $admin_url,
  admin_url          => $admin_url,
  region             => $region,
  tenant             => $tenant,
}
