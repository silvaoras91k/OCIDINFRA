/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */
locals {
  empty_list = [[""]]
}

output "lb_public_ip" {
  value = coalescelist(
    oci_load_balancer_load_balancer.wls-loadbalancer.*.ip_addresses,
    local.existing_loadbalancer_ips,
	local.empty_list,
  )
}

output "lb_ocid" {
  value = var.add_load_balancer == "true" ? (local.use_existing_lb ? local.existing_loadbalancer_id : oci_load_balancer_load_balancer.wls-loadbalancer[0].id) : ""
}