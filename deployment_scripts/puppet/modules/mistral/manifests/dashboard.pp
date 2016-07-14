class mistral::dashboard (
  $package_ensure = present,
){
  include ::mistral::params

  package { 'mistral-dashboard':
    ensure => $package_ensure,
    name   => $::mistral::params::dashboard_package_name,
    tag    => ['openstack', 'mistral-package'],
  }
}
