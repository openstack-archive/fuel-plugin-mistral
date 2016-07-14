notice('MODULAR: mistral/update_openrc.pp')

$mistral_hash = hiera_hash('fuel-plugin-mistral', {})

$ssl_hash            = hiera_hash('use_ssl', {})
$management_vip      = hiera('management_vip')
$internal_protocol   = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'protocol', 'http')
$internal_address    = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'hostname', [$management_vip])
$port                = '8989'
$mistral_url         = "${internal_protocol}://${internal_address}:${port}/v2"

file_line { 'mistral_url root':
      line  => "export OS_MISTRAL_URL=\'${mistral_url}\'",
      match => '^export\ OS_MISTRAL_URL\=',
      path  => '/root/openrc',
}
