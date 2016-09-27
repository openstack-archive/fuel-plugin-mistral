===================
Destructive testing
===================


Verify master controller fail in HA cluster  will not crash the system
----------------------------------------------------------------------


ID
##

mistral_controller_failover


Description
###########

Verify that after non-graceful shutoff of controller node, cluster stays
operational and after turning it back online, cluster is operational.


Complexity
##########

manual


Steps
#####

    1. Create cluster
    2. Install and configure Mistral plugin
    3. Add 3 controller-mistral nodes
    4. Deploy cluster
    5. Verify Cluster using OSTF
    6. Power off main controller (non-gracefully)
    7. Run OSTF
    8. Power on controller which was powered off in step 6.
    9. Run OSTF


Expected results
################

All steps except step 7 must be completed successfully, without any errors.
Step 7 one OSTF HA test will fail, because one of controllers is offline - this
is expected.


Verify mistral node fail in Non-HA cluster will not crush the system
--------------------------------------------------------------------


ID
##

mistral_node_failover


Description
###########

Verify that after non-graceful shutoff of mistral node cluster stays
operational and after turning it back online, cluster is operational.


Complexity
##########

manual


Steps
#####

    1. Create cluster
    2. Install and configure Mistral plugin
    3. Add 1 controller-mistral, cinder and compute node
    4. Add 1 mistral node
    5. Deploy cluster
    6. Run OSTF
    7. Power off the mistral node (non-gracefully)
    8. Run OSTF
    9. Power on mistral node which was powered off in step 6
    10. Run OSTF


Expected results
################

All steps except step 8 must be completed successfully, without any errors.
Step 8 one OSTF test will fail, because one of nodes is offline - this is
expected.
