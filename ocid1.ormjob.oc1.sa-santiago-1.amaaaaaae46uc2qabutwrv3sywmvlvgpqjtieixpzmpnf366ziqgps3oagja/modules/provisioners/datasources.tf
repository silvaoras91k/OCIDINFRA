/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

locals {
  atp_db_wallet_password = var.is_atp_db ? (var.use_custom_atp_db_wallet_password ? (var.use_kms_decryption ? base64decode(data.oci_secrets_secretbundle.atp_db_wallet_secretbundle[0].secret_bundle_content.0.content) : var.atp_db_wallet_password ) : md5(format("%s:%s", var.atp_db_id, data.oci_database_autonomous_database.atp_db[0].db_name)) ) : ""
  atp_db_wallet_cred = var.is_atp_db ? (var.use_custom_atp_db_wallet_password ? var.atp_db_wallet_password : md5(format("%s:%s", var.atp_db_id, data.oci_database_autonomous_database.atp_db[0].db_name)) ) : ""
}

data "oci_database_autonomous_database" "atp_db" {
  count = var.is_atp_db ?1:0

  #Required
  autonomous_database_id = var.atp_db_id
}


// Resolves the private IP of the customer's private endpoint to a NAT IP. Used as the host address in the "remote-exec" resource
data "oci_resourcemanager_private_endpoint_reachable_ip" "private_endpoint_ips" {
  count = (var.use_private_endpoint)?var.numVMInstances:0
  private_endpoint_id = var.private_endpoint_id
  private_ip          = var.host_ips[count.index]
}

// Resolves the private IP of the customer's private endpoint to a NAT IP. Used as the host address in the "remote-exec" resource
data "oci_resourcemanager_private_endpoint_reachable_ip" "admin_private_endpoint_ip" {
  count = (var.use_private_endpoint)?1:0
  private_endpoint_id = var.private_endpoint_id
  private_ip          = var.admin_ip
}

data "oci_secrets_secretbundle" "atp_db_wallet_secretbundle" {
    count = (var.is_atp_db && var.use_kms_decryption && var.use_custom_atp_db_wallet_password)?1:0
    secret_id = var.atp_db_wallet_password

}

resource "oci_database_autonomous_database_wallet" "atp_wallet" {
  count = (var.is_atp_db)?1:0

  #Required
  autonomous_database_id = var.atp_db_id
  base64_encode_content  = "true"
  generate_type          = ""
  password = local.atp_db_wallet_password
}

resource "local_file" "autonomous_database_wallet_file" {
  count = (var.is_atp_db)?1:0

  content_base64  = oci_database_autonomous_database_wallet.atp_wallet[0].content
  filename = "${path.module}/atp_wallet.zip"
}
