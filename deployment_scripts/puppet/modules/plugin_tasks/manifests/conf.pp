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

class plugin_tasks::conf {

  notice('MODULAR: fuel-plugin-mistral/conf.pp')
  $roles = hiera(roles)
  include plugin_tasks
  
  Package <| title == 'mistral-common' |> {
    name => 'mistral-common',
  }
  class { '::mistral':
    keystone_password                  => $plugin_tasks::password,
    keystone_user                      => $plugin_tasks::auth_name,
    keystone_tenant                    => $plugin_tasks::tenant,
    auth_uri                           => $plugin_tasks::auth_uri,
    identity_uri                       => $plugin_tasks::identity_uri,
    database_connection                => $plugin_tasks::db_connection,
    rpc_backend                        => $plugin_tasks::rpc_backend,
    rabbit_hosts                       => $plugin_tasks::rabbit_hosts,
    rabbit_userid                      => $plugin_tasks::rabbit_hash['user'],
    rabbit_password                    => $plugin_tasks::rabbit_hash['password'],
    control_exchange                   => $plugin_tasks::control_exchange,
    rabbit_ha_queues                   => $plugin_tasks::rabbit_ha_queues,
    use_syslog                         => $plugin_tasks::use_syslog,
    use_stderr                         => $plugin_tasks::use_stderr,
    log_facility                       => $plugin_tasks::log_facility,
    verbose                            => $plugin_tasks::verbose,
    debug                              => $plugin_tasks::debug,
  }

  mistral_config {
    'keystone_authtoken/auth_version': value => $plugin_tasks::auth_version;
  }

}
