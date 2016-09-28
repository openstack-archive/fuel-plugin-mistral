.. _new_env:

Creating new environment with Misral Fuel plugin
------------------------------------------------

To create and configure a new environment with Mistral Fuel plugin
follow the steps below:

#. `Create a new OpenStack environment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide.html>`__
   in Fuel web UI.

#. Enable the Google Cloud Storage Fuel plugin in `Additional services`  tab:

    .. image:: images/plugin.png

#. `Add nodes and assign them roles: <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/add-nodes.html>`__

   * At least 1 Controller
   * Desired number of Compute nodes
   * At least 1 Cinder node. The Cinder role can also be added to Compute or
     Controller node
   * At least 1 Mistral node. The Mistral role can also be added to any other
     node except Compute

#. Make additional `configuration adjustments <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment.html>`__.

#. Proceed to the `environment deployment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/deploy-environment.html>`__.

.. _hotplug:

Enabling Misral Fuel plugin for a deployed environment
------------------------------------------------------

Mistral Fuel plugin is hotpluggable and can be enabled for an already deployed
environment. The enable the plugin follow the steps below:

#. Navigate to the `Settings` tab -> `Other` section and  enable the plugin

    .. image:: images/enable.png

#. Press `Save Settings` button.

#. `Add Mistral node: <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/add-nodes.html>`__

   * At least 1 Mistral node. The Mistral role can also be added to any other
     node except Compute

#. Proceed to the `environment deployment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/deploy-environment.html>`__.
