Troubleshooting
---------------

This section contains a guidance on verifying and troubleshooting Mistral Fuel
Plugin and Mistral deployed by the plugin.

*Mistral* role is not available
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If *Mistral* role is not available in Fuel UI when adding new node verify the
plugin is installed and enabled. To verify in Fuel UI navigate to
`Settings` tab -> `Other` section

    .. image:: images/enable.png

The plugin must be present and enabled.
If not present check :ref:`install`.

Mistral configuration files and logs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Mistral API service runs on Controller nodes.
Mistral Executor and Engine services run on Mistral nodes.

Mistral configuration files are located in `/etc/mistral` on Controller and
Mistral nodes. `/etc/mistral/mistral.conf` is the main configuration file.

Logs can be found in `/var/log/mistral` directory.

Verifying Mistral operation
^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Login to primary Contraller node

#. Source openrc

   .. code-block:: console

     # source openrc

#. Verify Mistral

   .. code-block:: console

     # openstack workflow list
     +----...---+------...-+-----...+--------+------...--+----...+----...+
     | ID ...   | Name ... | Proj...| Tags   | Input...  | Cre...| Upd...|
     +----...---+------...-+-----...+--------+------...--+----...+----...+
     | 9e2...bc | std.d... | <def...| <none> | insta...n | 201...| Non...|
     | a80...63 | std.c... | <def...| <none> | name,...  | 201...| Non...|
     +----...---+------...-+-----...+--------+------...--+----...+----...+
