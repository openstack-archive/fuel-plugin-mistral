#    Copyright 2016 Mirantis, Inc.

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

"""Base module which classes and methods will be used in test cases."""

import os

from fuelweb_test.tests.base_test_case import TestBasic
from fuelweb_test import logger
from fuelweb_test.helpers import utils


class MistralTestBase(TestBasic):
    """GcsTestBase.

    Base class for GCS verification testing, methods in this class will be used
     by test cases.
    """

    #  TODO(unknown) documentation

    def get_remote(self, node):
        """Method designed to get remote credentials."""
        logger.info('Getting a remote to {0}'.format(node))
        if node == 'master':
            environment = self.env
            remote = environment.d_env.get_admin_remote()
        else:
            remote = self.fuel_web.get_ssh_for_node(node)
        return remote

    def install_plugin(self):
        """Method designed to install plugin on cluster."""
        master_remote = self.get_remote('master')
        utils.upload_tarball(master_remote.host,
                             os.environ['MISTRAL_PLUGIN_PATH'],
                             '/var')
        utils.install_plugin_check_code(
            master_remote.host,
            os.path.basename(os.environ['MISTRAL_PLUGIN_PATH']))
