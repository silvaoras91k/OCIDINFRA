# Copyright 2021, Oracle Corporation and/or affiliates.  All rights reserved.

output "mountTarget_id" {
  value = local.mount_target_id[0]
}

output "mount_export_id" {
  value = join("", oci_file_storage_export.mount_export.*.id)
}

output "fss_id" {
  value = join("", oci_file_storage_file_system.file_system.*.id)
}

output "mount_ip" {
  value = join("", data.oci_core_private_ip.mount_target_private_ip.*.ip_address)
}

output "export_path" {
  value = join("", oci_file_storage_export.mount_export.*.path)
}
