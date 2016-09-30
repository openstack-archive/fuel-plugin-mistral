Considering HA
--------------

Mistral API service runs on every `Controller` node. Mistral API service HA
is reached if multiple `Controller` nodes are deployed in the environment.
Calls to Mistral API service instances are balanced via HAProxy.

Mistral Engine and Executor services run on `Mistral` nodes. Every Mistral node
runs one Mistral Engine instance and one Mistral Executor instance.
The services HA is reached by deploying multiple `Mistral` nodes.

.. _new_env:

Creating new environment with Mistral Fuel plugin
-------------------------------------------------

To create and configure a new environment with Mistral Fuel plugin
follow the steps below:

#. `Create a new OpenStack environment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide.html>`__
   in Fuel web UI.

#. Enable the Mistral Fuel plugin in `Additional services`  tab:

    .. image:: images/plugin.png

#. `Add nodes and assign them roles: <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/add-nodes.html>`__

   * At least 1 Controller
   * At least 1 Mistral node. The Mistral role can also be added to any other
     node except Compute

#. Make additional `configuration adjustments <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment.html>`__.

#. Proceed to the `environment deployment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/deploy-environment.html>`__.

.. _hotplug:

Enabling Mistral Fuel plugin for a deployed environment
-------------------------------------------------------

Mistral Fuel plugin is hotpluggable and can be enabled for an already deployed
environment. The enable the plugin follow the steps below:

#. Navigate to the `Settings` tab -> `Other` section and  enable the plugin

    .. image:: images/enable.png

#. Press `Save Settings` button.

#. `Add Mistral node: <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/add-nodes.html>`__

   * At least 1 Mistral node. The Mistral role can also be added to any other
     node except Compute

#. Proceed to the `environment deployment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/deploy-environment.html>`__.

Getting `Mistral` service credentials
-------------------------------------

To call Mistral API `admin` Keystone user credentials can be used.
Mistral service also has it's own Keystone user.
The user name is `mistral`.

To get Keystone endpoint and `mistral` Keystone user password login
to the primary `Controller` node after the environment has been deployed
and run:

   .. code-block:: console

     # source openrc

     # openstack endpoint show mistral
     +--------------+-----------------------------------+
     | Field        | Value                             |
     +--------------+-----------------------------------+
     | adminurl     | http://10.109.1.8:8989/v2         |
     | enabled      | True                              |
     | id           | 3023eac53843471fa70c96c081008daf  |
     | internalurl  | http://10.109.1.8:8989/v2         |
     | publicurl    | https://public.fuel.local:8989/v2 |
     | region       | RegionOne                         |
     | service_id   | e136f06aab484b6e8a513604f72eb284  |
     | service_name | mistral                           |
     | service_type | workflowv2                        |
     +--------------+-----------------------------------+

     # hiera -h fuel-plugin-mistral
     {"db_password"=>"db_password",
      "keystone_password"=>"mistral_user_keystone_password",    <-- the password
      "metadata"=>
       {"class"=>"plugin",
        "enabled"=>true,
        "group"=>"other",
        "hot_pluggable"=>true,
        "label"=>"Fuel Mistral plugin",
        "plugin_id"=>5,
        "plugin_version"=>"1.0.0",
        "toggleable"=>true,
        "weight"=>70}}
