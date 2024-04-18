
/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

data "oci_load_balancer_load_balancers" "existing-loadbalancers" {
    count          = local.use_existing_lb ? local.lbCount : 0
    compartment_id = var.compartment_ocid
    display_name   = local.existing_load_balancer
}
