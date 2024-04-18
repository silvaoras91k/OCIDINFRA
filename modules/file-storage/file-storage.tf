# Copyright  2021, Oracle Corporation and/or affiliates.  All rights reserved.

locals {
  vcn_cidr        = data.oci_core_vcn.wls_vcn.cidr_block
  mount_target_id = coalescelist(oci_file_storage_mount_target.mount_target.*.id, list(var.mount_target_ocid))
}


resource "oci_file_storage_mount_target" "mount_target" {
  count = var.use_file_storage && !var.use_existing_mount_target ? 1 : 0

  #Required
  availability_domain = var.file_storage_availability_domain
  compartment_id      = var.mount_target_compartment_ocid
  subnet_id           = var.mount_target_subnet_id

  display_name   = "${var.service_name_prefix}-mntTarget"
  hostname_label = "${var.service_name_prefix}-mntTarget"

  defined_tags = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource "oci_file_storage_file_system" "file_system" {
  count = var.use_file_storage && !var.use_existing_file_system ? 1 : 0

  #Required
  availability_domain = var.file_storage_availability_domain
  compartment_id      = var.file_system_compartment_ocid

  display_name = "${var.service_name_prefix}-fs"
  defined_tags = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource "oci_file_storage_export_set" "mount_export_set" {
  count = var.use_file_storage ? 1 : 0

  #Required
  mount_target_id = local.mount_target_id[0]
  display_name    = "${var.service_name_prefix}-export-set"
}

resource "oci_file_storage_export" "mount_export" {
  count = var.use_file_storage ? 1 : 0

  #Required
  export_set_id  = join("", oci_file_storage_export_set.mount_export_set.*.id)
  file_system_id = join("", oci_file_storage_file_system.file_system.*.id)
  path           = format("/%s", "${var.service_name_prefix}-fs")

  #Optional
  export_options {
    #Required
    source = local.vcn_cidr

    access          = "READ_WRITE"
    identity_squash = "NONE"
  }
}
