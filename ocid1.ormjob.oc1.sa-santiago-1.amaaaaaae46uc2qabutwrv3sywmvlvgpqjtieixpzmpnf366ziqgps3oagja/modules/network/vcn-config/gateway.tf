/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

/*
* Creates a new internet gateway and natgateway(private subnet) for the specified VCN.
* Note:If existing vcn has to be used, then it has to have precreated internet gateway
* Also see:
*   https://www.terraform.io/docs/providers/oci/r/core_internet_gateway.html
*   https://www.terraform.io/docs/providers/oci/r/core_nat_gateway.html
*/

resource "oci_core_internet_gateway" "wls-internet-gateway" {
  count          = (var.wls_vcn_name == "" || var.use_existing_subnets)?0:1
  compartment_id = var.compartment_id
  display_name   = "${var.service_name_prefix}-internet-gateway"
  vcn_id         = var.vcn_id

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource "oci_core_service_gateway" "wls-service-gateway-newvcn" {
  count = (!var.assign_backend_public_ip && var.wls_vcn_name != "")?1:0

  #Required
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  services {
    #Required
    service_id = local.all_services[0].id
  }
  display_name  = "${var.service_name_prefix}-service-gateway"
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

