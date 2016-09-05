#    Copyright 2015 Mirantis, Inc.
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

$plugin_hash = $hiera_hash('fuel-plugin-mistral', {})

$horizon_ext_file  = '/usr/share/openstack-dashboard/openstack_dashboard/local/enabled/_50_mistral.py'
$dashboard_version = '2.0.0'
$dashboard_name    = 'mistral-dashboard'
