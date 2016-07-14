notice('MODULAR: mistral/dashboard.pp')

$mistral_hash      = hiera_hash('fuel-plugin-mistral', {})

class { '::mistral::dashboard': }
