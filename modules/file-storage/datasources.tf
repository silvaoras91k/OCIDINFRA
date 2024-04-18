# Copyright  2021, Oracle Corporation and/or affiliates.  All rights reserved.

data "oci_core_vcn" "wls_vcn" {
  #Required
  vcn_id = var.vcn_id
}

data "oci_file_storage_mount_targets" "mount_target" {
  count = var.use_file_storage ? 1 : 0

  #Required
  availability_domain = var.file_storage_availability_domain
  compartment_id      = var.mount_target_compartment_ocid

  #Optional
  id = var.mount_target_ocid != "" ? var.mount_target_ocid : join("", oci_file_storage_mount_target.mount_target.*.id)
}

data "oci_core_private_ip" "mount_target_private_ip" {
  count = var.use_file_storage ? 1 : 0
  #Required
  private_ip_id = data.oci_file_storage_mount_targets.mount_target[0].mount_targets[0].private_ip_ids[0]
}
