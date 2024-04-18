# Copyright 2020, 2021, Oracle Corporation and/or affiliates.  All rights reserved.


locals {
  compartment = format("instance.compartment.id='%s'", var.compartment_id)
  soamp_instances = join(", ", formatlist("instance.id='%s'",var.instance_ocids))
  soamp_instances_rule = format("ANY { %s }",local.soamp_instances)
}

resource "oci_identity_dynamic_group" "soamp_instances_principal_group" {
  count = var.create_policies ? 1 : 0
  compartment_id = var.tenancy_id
  description    = "Dynamic group to allow SOAMP instances to access KMS secrets and Object Storage bucket"
  matching_rule  = local.soamp_instances_rule
  name           = "${var.label_prefix}-soamp-instance-principal-group"
#  lifecycle {
#    ignore_changes = [matching_rule]
#  }


  #Optional
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}
