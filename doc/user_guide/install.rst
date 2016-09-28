.. _install:

Install Mistral Fuel plugin
---------------------------

Before you proceed with Mistral Fuel plugin installation, please verify next:

#. You have completed steps from :ref:`prerequisites` section.

#. All the nodes of your future environment are *DISCOVERED*
   by the Fuel Master node if :ref:`new_env`. 
   At least one node is *DISCOVERED* if :ref:`hotplug`.

**To install the Mistral plugin:**

#. Download Mistral Fuel plugin from the
 `Fuel Plugin Catalog <https://www.mirantis.com/products/openstack-drivers-and-plugins/fuel-plugins/>`__.

#. Copy the plugin ``.rpm`` package to the Fuel Master node:

   .. code-block:: console

     $ scp fuel-plugin-mistral-1.0-1.0.0-1.noarch.rpm <Fuel Master nodeip>:/tmp

#. Log in to the Fuel Master node CLI as root.

#. Install the plugin:

   .. code-block:: console

     # fuel plugins --install /tmp/fuel-plugin-mistral-1.0-1.0.0-1.noarch.rpm

#. Verify that the plugin was installed successfully:

   .. code-block:: console

     # fuel plugins

     id | name                | version | package_version | releases
     ---+---------------------+---------+-----------------+--------------------
     5  | fuel-plugin-mistral | 1.0.0   | 4.0.0           | ubuntu (mitaka-9.0)

#. Proceed to :ref:`new_env` or :ref:`hotplug` section.
