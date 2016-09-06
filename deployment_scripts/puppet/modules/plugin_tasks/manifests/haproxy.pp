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

class plugin_tasks::haproxy { 
  
  $api_nodes_hash = get_nodes_hash_by_roles($plugin_tasks::network_metadata, ['primary-controller','controller'])
  $api_nodes_ips  = ipsort(values(get_node_to_ipaddr_map_by_network_role($api_nodes_hash, 'management')))

  $public_ssl      = get_ssl_property($plugin_tasks::ssl_hash, $plugin_tasks::public_ssl_hash, 'mistral', 'public', 'usage', false)
  $public_ssl_path = get_ssl_property($plugin_tasks::ssl_hash, $plugin_tasks::public_ssl_hash, 'mistral', 'public', 'path', [''])
  
  firewall { '300 mistral':
    chain  => 'INPUT',
    dport  => $plugin_tasks::api_port,
    proto  => 'tcp',
    action => 'accept',
  } 

  openstack::ha::haproxy_service { 'mistral-api':
    internal_virtual_ip    => pick($plugin_tasks::internal_virtual_ip, hiera('management_vip')),
    listen_port            => $plugin_tasks::api_port,
    order                  => '300',
    public_virtual_ip      => pick($plugin_tasks::public_virtual_ip, hiera('public_vip')),
    internal               => true,
    public                 => true,
    ipaddresses            => pick($plugin_tasks::mistral_api_nodes_ips, $api_nodes_ips),
    server_names           => pick($plugin_tasks::mistral_api_nodes_ips, $api_nodes_ips),
    public_ssl             => pick($plugin_tasks::public_ssl, $public_ssl),
    public_ssl_path        => pick($plugin_tasks::public_ssl_path, $public_ssl_path),
    haproxy_config_options => {
	option         => ['httpchk', 'httplog', 'httpclose'],
	'http-request' => 'set-header X-Forwarded-Proto https if { ssl_fc }',
    },
    balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
  }

}
