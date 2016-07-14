notice('MODULAR: mistral/rabbitmq.pp')

$mistral_hash           = hiera_hash('fuel-plugin-mistral', {})
$rabbit_userid          = $mistral_hash['metadata']['rabbit_user']
$rabbit_password        = $mistral_hash['rabbit_password']
$mistral_enabled        = pick($mistral_hash['metadata']['enabled'], false)

if ($mistral_enabled) {
  validate_string($rabbit_password)
  $virtual_host         = '/'
  #$user_permissions     = "$rabbit_userid@$virtual_host"

  rabbitmq_user { $rabbit_userid:
     admin                => true,
     password             => $rabbit_password,
     provider             => 'rabbitmqctl',
  }
  rabbitmq_user_permissions { "$rabbit_userid@$virtual_host":
     configure_permission => '.*',
     write_permission     => '.*',
     read_permission      => '.*',
     provider             => 'rabbitmqctl',
  }
  rabbitmq_vhost { $virtual_host:
        provider => 'rabbitmqctl',
  }
}
