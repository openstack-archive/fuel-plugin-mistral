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

class plugin_tasks::keystone {

  Class['::osnailyfacter::wait_for_keystone_backends'] -> Class['::mistral::keystone::auth']

  class { '::osnailyfacter::wait_for_keystone_backends':}
  class { '::mistral::keystone::auth':
    password            => $plugin_tasks::password,
    auth_name           => $plugin_tasks::auth_name,
    configure_endpoint  => $plugin_tasks::configure_endpoint,
    configure_user      => $plugin_tasks::configure_user,
    configure_user_role => $plugin_tasks::configure_user_role,
    service_name        => $plugin_tasks::service_name,
    service_type        => $plugin_tasks::service_type,
    public_url          => $plugin_tasks::public_url,
    internal_url        => $plugin_tasks::internal_url,
    admin_url           => $plugin_tasks::admin_url,
    region              => $plugin_tasks::region,
    tenant              => $plugin_tasks::tenant,
  }

}
