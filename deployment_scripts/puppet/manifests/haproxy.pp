notice('MODULAR: mistral/haproxy.pp')


  $mistral          = hiera_hash('fuel-plugin-mistral', undef)
  $mistral_enabled  = pick($mistral['metadata']['enabled'], false)

  if ($mistral_enabled) {

    $network_metadata   = hiera_hash('network_metadata', {})
    $public_ssl_hash    = hiera_hash('public_ssl', {})
    $ssl_hash           = hiera_hash('use_ssl', {})

    $public_ssl         = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'usage', false)
    $public_ssl_path    = get_ssl_property($ssl_hash, $public_ssl_hash, 'mistral', 'public', 'path', [''])

    $internal_ssl       = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'usage', false)
    $internal_ssl_path  = get_ssl_property($ssl_hash, {}, 'mistral', 'internal', 'path', [''])

    $external_lb        = hiera('external_lb', false)
    $mistral_nodes       = get_nodes_hash_by_roles($network_metadata, ['primary-mistral', 'mistral'])

    $mistral_api_port    = hiera($mistral['mistral_api_port'], 8989)

    if (!$external_lb) {

      $mistral_address_map  = get_node_to_ipaddr_map_by_network_role($mistral_nodes, 'mistral/api')
      $server_names        = keys($mistral_address_map)
      $ipaddresses         = values($mistral_address_map)
      $public_virtual_ip   = hiera('public_vip')
      $internal_virtual_ip = hiera('management_vip')
	    
      Openstack::Ha::Haproxy_service {
        internal_virtual_ip => $internal_virtual_ip,
        ipaddresses         => $ipaddresses,
        public_virtual_ip   => $public_virtual_ip,
        server_names        => $server_names,
        public              => true,
        internal_ssl        => $internal_ssl,
        internal_ssl_path   => $internal_ssl_path,
      }

      openstack::ha::haproxy_service { 'mistral-api':
        order                  => '600',
        listen_port            => $mistral_api_port,
        public_ssl             => $public_ssl,
        public_ssl_path        => $public_ssl_path,
        #require_service        => 'mistral-api',
        haproxy_config_options => {
          option           => ['httpchk', 'httplog', 'httpclose'],
          'timeout server' => '660s',
          'http-request'   => 'set-header X-Forwarded-Proto https if { ssl_fc }',
        },
        balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
      }

    }
  }
