#    Copyright 2016 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

class plugin_tasks {

  $network_scheme   = hiera_hash('network_scheme', {})
  $network_metadata = hiera_hash('network_metadata', {})
  prepare_network_config($network_scheme)

  # General

  $mistral_hash           = hiera_hash('fuel-plugin-mistral', {})

  $public_vip             = hiera('public_vip', undef)
  $management_vip         = hiera('management_vip', undef)
  $database_vip           = hiera('database_vip', undef)
  $service_endpoint       = hiera('service_endpoint')

  $public_ssl_hash        = hiera_hash('public_ssl')
  $ssl_hash               = hiera_hash('use_ssl', {})
  $public_ssl             = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'usage', false)
  $public_ssl_path        = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'path', [''])

  $port = '8989'

  # Database

  $mysql_hash             = hiera_hash('mysql', {})

  $mysql_root_user        = pick($mysql_hash['root_user'], 'root')
  validate_string($mysql_root_user)
  $mysql_db_create        = pick($mysql_hash['db_create'], true)
  $mysql_root_password    = $mysql_hash['root_password']

  $db_create              = $mysql_db_create

  $db_user                = 'mistral'
  $db_password            = pick($mistral_hash['db_password'], $mysql_root_password)
  $db_name                = 'mistral'
  $allowed_hosts          = [ 'localhost', '127.0.0.1', '%' ]

  $db_host                = $database_vip
  $db_root_user           = $mysql_root_user
  $db_root_password       = $mysql_root_password

  $db_type                = 'mysql'

  # LP#1526938 - python-mysqldb supports this, python-pymysql does not
  if $::os_package_type == 'debian' {
    $extra_params = { 'charset' => 'utf8', 'read_timeout' => 60 }
  } else {
    $extra_params = { 'charset' => 'utf8' }
  }
  $db_connection = os_database_connection({
    'dialect'  => $db_type,
    'host'     => $db_host,
    'database' => $db_name,
    'username' => $db_user,
    'password' => $db_password,
    'extra'    => $extra_params
  })

  # RabbitMQ

  $rabbit_hash            = hiera_hash('rabbit', {})

  $rabbit_hosts           = split(hiera('amqp_hosts',''), ',')
  $control_exchange       = 'mistral'
  $rabbit_ha_queues       = true

  $queue_provider = hiera('queue_provider', 'rabbit')
  if $queue_provider == 'rabbitmq'{
    $rpc_backend    = 'rabbit'
  } else {
    $rpc_backend = $queue_provider
  }

  # Keystone

  $public_protocol        = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'protocol', 'http')
  $public_address         = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'hostname', [$public_vip])
  validate_string($public_address)

  $internal_protocol      = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'protocol', 'http')
  $internal_address       = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'hostname', [$management_vip])
  validate_string($internal_address)

  $admin_protocol         = get_ssl_property($ssl_hash, {}, 'mistral', 'admin', 'protocol', 'http')
  $admin_address          = get_ssl_property($ssl_hash, {}, 'mistral', 'admin', 'hostname', [$management_vip])
  validate_string($admin_address)

  $public_base_url        = "${public_protocol}://${public_address}:${port}"
  $internal_base_url      = "${internal_protocol}://${internal_address}:${port}"
  $admin_base_url         = "${admin_protocol}://${admin_address}:${port}"

  $password               = $mistral_hash['keystone_password']
  validate_string($password)
  $auth_name              = 'mistral'
  $configure_endpoint     = true
  $configure_user         = true
  $configure_user_role    = true
  $service_name           = 'mistral'
  $service_type           = 'workflowv2'
  $public_url             = "${public_base_url}/v2"
  $internal_url           = "${internal_base_url}/v2"
  $admin_url              = "${admin_base_url}/v2"
  $region                 = hiera('region', 'RegionOne')
  $tenant                 = 'services'


  $keystone_auth_protocol = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
  $keystone_auth_host     = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [hiera('keystone_endpoint', ''), $service_endpoint, $management_vip])

  $service_port           = '5000'

  $auth_version           = 'v3'
  $auth_uri               = "${keystone_auth_protocol}://${keystone_auth_host}:${service_port}/${$auth_version}"
  $identity_uri           = "${keystone_auth_protocol}://${keystone_auth_host}:${service_port}/"

  # API and VIP

  ## Mistral API runs on Controllers
  $mistral_api_nodes_hash         = get_nodes_hash_by_roles($network_metadata, ['primary-controller','controller'])
  $mistral_api_nodes_ips          = ipsort(values(get_node_to_ipaddr_map_by_network_role($mistral_api_nodes_hash, 'management')))
  $bind_host           = get_network_role_property('management', 'ipaddr')

  # Dashboard

  $horizon_ext_file   = '/usr/share/openstack-dashboard/openstack_dashboard/local/enabled/_50_mistral.py'
  $dashboard_version  = '2.0.0'
  $dashboard_name     = 'mistral-dashboard'
  # Logging

  $use_syslog    = hiera('use_syslog', true)
  $use_stderr    = hiera('use_stderr', false)
  $log_facility  = 'LOG_LOCAL0'
  $verbose       = hiera('verbose', true) 
  $debug         = hiera('debug', true)

}
