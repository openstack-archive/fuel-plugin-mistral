=========
BVT tests
=========


Smoke test
----------


ID
##

mistral_smoke

Description
###########

Smoke test for Mistral fuel plugin. Create cluster and install plugin. Deploy
cluster with controller-mistral, compute and cinder nodes

Complexity
##########

core

Steps
#####

    1. Upload plugin to the master node
    2. Create cluster
    3. Install plugin
    4. Add 1 nodes with controller-mistral role
    5. Add 1 node with compute role
    6. Add 1 node with cinder role
    7. Deploy the cluster

Expected results
################

All steps must be completed successfully, without any errors.



BVT test
--------


ID
##


mistral_bvt

Description
###########

BVT test for Mistral fuel plugin. Deploy cluster in HA mode with
3 controllers-mistral and 2 compute nodes and install plugin.

Complexity
##########

core

Steps
#####

    1. Upload plugin to the master node
    2. Create cluster
    3. Install plugin
    4. Add 3 nodes with controller-mistral-ceph-osd role
    5. Add 2 nodes with compute-ceph-osd role
    6. Deploy the cluster
    7. Run network verification
    8. Run OSTF

Expected results
################

All steps must be completed successfully, without any errors.
