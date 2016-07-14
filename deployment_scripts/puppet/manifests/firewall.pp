notice('MODULAR: mistral/firewall')

  $mistral            = hiera_hash('fuel-plugin-mistral', undef)
  $mistral_enabled    = pick($mistral['metadata']['enabled'], false)

  if ($mistral_enabled) {
    $network_scheme   = hiera_hash('network_scheme')
    $mistral_api_port = hiera($mistral['mistral_api_port'], 8989)
    $mistral_networks = get_routable_networks_for_network_role($network_scheme, 'mistral/api')

    openstack::firewall::multi_net {'220 mistral-api':
      port        => $mistral_api_port,
      proto       => 'tcp',
      action      => 'accept',
      source_nets => $mistral_networks,
    }
  }
