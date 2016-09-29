==================
Functional testing
==================


Check that Controller node can be deleted and added again
---------------------------------------------------------


ID
##

mistral_delete_add_controller


Description
###########

Verify that a controller-mistral node can be deleted and added after deploying


Complexity
##########

manual


Steps
#####

    1. Create cluster
    2. Enable and configure Mistral plugin
    3. Add 3 controller-mistral nodes
    4. Add 1 compute and 1 cinder node
    5. Deploy cluster with plugin
    6. Run OSTF tests
    7. Delete a Controller-Mistral node and deploy changes
    8. Run OSTF tests
    9. Add a node with "Controller-Mistral" role and deploy changes
    10. Run OSTF tests


Expected results
################

Step 6 will have failed cases because only 2 controller nodes are present in
 cloud


Check that Compute node can be deleted and added again
------------------------------------------------------


ID
##

mistral_delete_add_mistral_node


Description
###########

Verify that a mistral node can be deleted and added after deploying


Complexity
##########

manual


Steps
#####

    1. Create cluster
    2. Enable and configure Mistral plugin
    3. Add 1 controller, compute, cinder node
    4. Add 1 mistral node
    5. Deploy cluster with plugin
    6. Run OSTF tests
    7. Delete a mistral node and deploy changes
    8. Run OSTF tests
    9. Add a node with "mistral" role and deploy changes
    10. Run OSTF tests



Expected results
################

All steps must be completed successfully, without any errors.
