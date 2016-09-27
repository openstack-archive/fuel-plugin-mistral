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

"""Module with set of basic test cases."""

from proboscis import test

from fuelweb_test.helpers.decorators import log_snapshot_after_test
from fuelweb_test.tests.base_test_case import SetupEnvironment
from helpers.mistral_base import MistralTestBase
from helpers import mistral_settings
from fuelweb_test.settings import DEPLOYMENT_MODE
from fuelweb_test import logger


@test(groups=["mistral_smoke_bvt_tests"])
class MistralTestClass(MistralTestBase):
    """MistralTestBase."""  # TODO(unknown) documentation

    @test(depends_on=[SetupEnvironment.prepare_slaves_3],
          groups=["mistral_smoke"])
    @log_snapshot_after_test
    def mistral_smoke(self):
        """Deploy non HA cluster with mistral plugin installed and enabled.

        Scenario:
            1. Create cluster
            2. Install Mistral plugin
            3. Add 1 node with controller-mistral role
            4. Add 1 node with compute role
            5. Add 1 node with cinder role
            6. Deploy the cluster
        """
        self.env.revert_snapshot("ready_with_3_slaves")

        logger.info('Creating Mistral HA cluster...')
        segment_type = 'vlan'
        cluster_id = self.fuel_web.create_cluster(
            name=self.__class__.__name__,
            mode=DEPLOYMENT_MODE,
            settings={
                "net_provider": 'neutron',
                "net_segment_type": segment_type,
                'tenant': mistral_settings.default_tenant,
                'user': mistral_settings.default_user,
                'password': mistral_settings.default_user_pass,
                'assign_to_all_nodes': True
            }
        )

        self.install_plugin()
        self.fuel_web.update_plugin_settings(cluster_id,
                                             mistral_settings.plugin_name,
                                             mistral_settings.plugin_version,
                                             mistral_settings.options)

        self.fuel_web.update_nodes(
            cluster_id,
            {
                'slave-01': ['controller', 'mistral'],
                'slave-02': ['compute'],
                'slave-03': ['cinder']
            }
        )

        self.fuel_web.deploy_cluster_wait(
            cluster_id,
            check_services=False
        )

        self.env.make_snapshot("mistral_smoke")

    @test(depends_on=[SetupEnvironment.prepare_slaves_5],
          groups=["mistral_bvt"])
    @log_snapshot_after_test
    def mistral_bvt(self):
        """Deploy HA cluster with Mistral plugin installed and enabled.

        Scenario:
            1. Create an environment
            2. Install Mistral plugin
            3. Enable Mistral plugin
            4. Add 3 nodes with controller+ceph-osd roles
            5. Add 2 nodes with compute+ceph-osd role
            6. Deploy the cluster
            7. Run OSTF
        """

        self.env.revert_snapshot("ready_with_5_slaves")

        self.show_step(1)
        cluster_id = self.fuel_web.create_cluster(
            name=self.__class__.__name__,
            settings={
                'images_ceph': True,
                'volumes_ceph': True,
                'ephemeral_ceph': True,
                'objects_ceph': True,
                'volumes_lvm': False
            }
        )

        self.show_step(2)
        self.install_plugin()

        self.show_step(3)
        self.fuel_web.update_plugin_settings(cluster_id,
                                             mistral_settings.plugin_name,
                                             mistral_settings.plugin_version,
                                             mistral_settings.options)

        self.show_step(4)
        self.show_step(5)
        self.fuel_web.update_nodes(
            cluster_id,
            {
                'slave-01': ['controller', 'ceph-osd', 'mistral'],
                'slave-02': ['controller', 'ceph-osd', 'mistral'],
                'slave-03': ['controller', 'ceph-osd', 'mistral'],
                'slave-04': ['compute', 'ceph-osd'],
                'slave-05': ['compute', 'ceph-osd'],
            }
        )

        self.show_step(6)
        self.fuel_web.deploy_cluster_wait(
            cluster_id,
            check_services=False
        )

        self.show_step(7)
        self.fuel_web.run_ostf(
            cluster_id=cluster_id,
            test_sets=['smoke', 'sanity', 'ha'])
