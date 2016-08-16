===================
Mistral Fuel plugin
===================

Mistral Fuel plugin allows Fuel to deploy OpenStack with Mistral installed and configured.

Problem description
===================

It’s often required to execute some set of closely related OpenStack API calls. For example creating a volume backup requires actions like creating a snapshot, creating a backup, removing a snapshot. This is a place where Mistral, the OpenStack workflow service, becomes very handy as it allows to compose such set of API calls in workflows and invoke the API calls as a single entity.

Fuel is a widely used automation tool for deploying OpenStack clouds but currently does not support installing and configuring Mistral during OpenStack deployment.

Proposed changes
================

Develop Fuel plugin to automate Mistral installation and configuration.

The plugin should provide ``mistral`` role.
The role should be compatible with Controller role or placed  to a standalone node.

The tasks to be performed by the plugin:

* On primary controller.

  * Create ``mistral`` MySQL database.
  * Create ``mistral`` MySQL database user.
  * Grant the appropriate rights.
  * Create ``mistral`` Keystone service user.
  * Create Mistral Keystone endpoint
    * Keystone Service Name : mistral
    * Keystone Service Type : workflow

* On Mistral node.

  * Install mistral-engine, mistral-executor packages.
  * Create mistral.conf.
  * Initialize and populate the database.
  * Enable ``mistral-engine`` and ``mistral-executor`` services autostart and start them.
   
* On all controllers and Mistral node.

  * Install mistral-client package.
  * Create ``mistral`` user.
  * Create Mistral specific ``openrc`` file in ``mistral`` user home directory.
  * Configure Mistral logging.

* On all controllers.

  * Install mistral-api package
  * Create mistral.conf.
  * Disable ``mistral-api`` service autostart and stop it.
  * Configure mistral-api site in Apache
  * Configure HAProxy to balance calls to mistral-api
  * Install ``mistral-dashboard`` package to add Mistral section to Horizon.

Web UI
------

Fuel Web UI is extended with plugin-specific settings.

The settings are:

* A checkbox to enable Mistral Fuel Plugin.

* MySQL password

  * name: db_password
  * label: MySQL password
  * description: Password of MySQL user for Mistral.
  * type: hidden
  * default value: generated automatically

* Keystone password

  * name: keystone_password
  * label: Keystone password
  * description: Password of Keystone service user for Mistral.
  * type: hidden
  * default value: generated automatically


Nailgun
-------
None

Data model
----------
None

REST API
--------
Mistral Keystone endpoint will be registered.

Orchestration
-------------
None

Fuel Client
-----------
None

Fuel Library
------------
None

Limitations
-----------
Mistral service is deployed without HA support.

Alternatives
============
The plugin can also be implemented as a part of Fuel core but it was decided
to create a plugin as any new additional functionality makes a project and
testing more difficult which is an additional risk for the Fuel release.
Also Mistral can be installed manually.

Upgrade impact
==============
Compatibility of new Fuel components and the Plugin should be checked before
upgrading Fuel Master.

Security impact
===============
None

Notifications impact
====================
None

End user impact
===============
None

Performance impact
==================
Working Mistral server causes additional load on DB and query services.

Deployment impact
=================
The plugin is hotpluggable and can be installed and enabled either during Fuel Master installation or after an environment has been deployed.



Developer impact
================
None

Infrastructure impact
=====================
A new role with name *mistral* is provided.
Mistral can be deployed to primary Controller node.

Documentation impact
====================
* Deployment Guide
* User Guide
* Test Plan
* Test Report

Implementation
==============

Assignee(s)
-----------

Primary assignee:

- Taras Kostyuk <tkostyuk@mirantis.com> - developer

Other contributors:

- Oleksandr Martsyniuk <omartsyniuk@mirantis.com> - feature lead, developer
- Kostiantyn Kalynovskyi <kkalynovskyi@mirantis.com> - developer

Project manager:

- Andrian Noga <anoga@mirantis.com>

Quality assurance:


- Vitaliy Yerys <vyerys@mirantis.com> - qa


Work Items
----------

* Prepare development environment
* Implement Puppet manifests to install and configure Mistral
* Test Mistral Fuel plugin
* Prepare Documentation

Dependencies
============

* Fuel 9.0
* OpenStack Mitaka

Testing
=======


* Test Mistral deployed on a Controller in HA cloud.
* Test Mistral deployed on standalone node.

Acceptance criteria
-------------------


* Mistral server is up and running
* Mistral client can retrieve a list of actions
  (verifies that DB is populated)
* Mistral client can create and execute a very basic workflow
* Mistral UI is working

References
==========

* Welcome to Mistral’s documentation!
  http://docs.openstack.org/developer/mistral/
* Welcome to yaql’s documentation!
  https://yaql.readthedocs.io/en/latest/



