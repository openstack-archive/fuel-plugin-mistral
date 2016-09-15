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

class plugin_tasks::repo {

  include apt

  apt::key {'fuel-infra':
    id     => '3E5CBCC6DF05CD6558A75DB1BCE5CC461FA22B08',
    source => 'http://perestroika-repo-tst.infra.mirantis.net/mos-repos/ubuntu/9.0/archive-mos9.0.key',

  }

  # Temp repo
  apt::source {'mos-proposed':
    location => 'http://perestroika-repo-tst.infra.mirantis.net/mos-repos/ubuntu/9.0',
    release  => 'mos9.0-proposed',
    repos    => 'main',
  }

  apt::pin { 'mos-proposed':
    priority        => 1200,
    release         => 'mos9.0-proposed',
    codename        => 'mos9.0',
    originator      => 'Mirantis',
    label           => 'mos9.0',
  }

}
