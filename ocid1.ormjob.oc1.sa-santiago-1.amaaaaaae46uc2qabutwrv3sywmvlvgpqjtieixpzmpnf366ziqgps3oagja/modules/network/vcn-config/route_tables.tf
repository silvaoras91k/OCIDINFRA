/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

/*
* Creates a new route table rules for the specified VCN.
* Also see:
*   https://www.terraform.io/docs/providers/oci/r/core_route_table.html,
*   https://www.terraform.io/docs/providers/oci/guides/managing_default_resources.html
*/

/*
* Creates route table for private subnet using internet gateway
*/

/**
* Note:
* Use this routetable if the new internet gateway was created in oci_core_internet_gateway.tf-internet-gateway
* For VCN peering support we need to update the route table rules associated with WLS.
* Terraform only allows us to update the default route table rules so when we create a new VCN we can use the
* default route table in the VCN. This will not impact the behavior if VCN peering is not used.
*/
resource "oci_core_default_route_table" "wls-default-route-table1" {
  count = (var.wls_vcn_name == "" || var.use_existing_subnets)?0:1

  //  compartment_id  = "${var.compartment_id}"
  //  vcn_id          = "${var.vcn_id}"
  //  display_name    = "${var.route_table_name}"
  manage_default_resource_id = data.oci_core_vcns.tf_vcns.virtual_networks[0]["default_route_table_id"]

  route_rules {
    destination       = var.internet_gateway_destination
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.wls-internet-gateway[0].id
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

/**
* Note:
* Use this routetable if the internet gateway exists
* It uses the existing internet gateway id
*/
resource "oci_core_route_table" "wls-route-table2" {
  count          = (var.wls_vcn_name == "" && !var.use_existing_subnets)?1:0
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.service_name_prefix}-${var.route_table_name}"

  route_rules {
    destination       = var.internet_gateway_destination
    destination_type  = "CIDR_BLOCK"
    network_entity_id = data.oci_core_internet_gateways.tf_internet_gateways.gateways[0]["id"]
  }
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

/*
* Creates route table for private subnet using nat gateway
*/
resource "oci_core_route_table" "wls-service-gateway-route-table-newvcn" {
  count          = (!var.assign_backend_public_ip && var.wls_vcn_name != "")?1:0
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.service_name_prefix}-pvt-${var.route_table_name}"

  route_rules {
    destination       = local.all_services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = join("", oci_core_service_gateway.wls-service-gateway-newvcn.*.id)
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource "oci_core_route_table" "wls-service-gateway-route-table-existingvcn" {
  count          = (!var.assign_backend_public_ip && var.existing_vcn_id != "" && !var.use_existing_subnets)?1:0
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.service_name_prefix}-pvt-${var.route_table_name}"

  route_rules {
    destination       = local.all_services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = data.oci_core_service_gateways.tf_service_gateways.service_gateways[0]["id"]
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

