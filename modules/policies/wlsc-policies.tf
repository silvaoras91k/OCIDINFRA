# Copyright 2020, 2021, Oracle Corporation and/or affiliates.  All rights reserved.

locals {

  ss_policy_statement1 = var.create_policies && var.wls_admin_password_ocid!=""? "Allow dynamic-group ${oci_identity_dynamic_group.soamp_instances_principal_group[0].name} to read secret-bundles in tenancy where target.secret.id = '${var.wls_admin_password_ocid}'" : ""
  ss_policy_statement2 = var.create_policies && var.wls_nm_password_ocid!=""? "Allow dynamic-group ${oci_identity_dynamic_group.soamp_instances_principal_group[0].name} to read secret-bundles in tenancy where target.secret.id = '${var.wls_nm_password_ocid}'" : ""
  ss_policy_statement3 = var.create_policies && var.rcu_schema_password_ocid!=""? "Allow dynamic-group ${oci_identity_dynamic_group.soamp_instances_principal_group[0].name} to read secret-bundles in tenancy where target.secret.id = '${var.rcu_schema_password_ocid}'" : ""
  ss_policy_statement4 = var.create_policies && var.db_password_ocid!=""? "Allow dynamic-group ${oci_identity_dynamic_group.soamp_instances_principal_group[0].name} to read secret-bundles in tenancy where target.secret.id = '${var.db_password_ocid}'" : ""
  ss_policy_statement5 = var.create_policies && var.idcs_client_secret_ocid!=""? "Allow dynamic-group ${oci_identity_dynamic_group.soamp_instances_principal_group[0].name} to read secret-bundles in tenancy where target.secret.id = '${var.idcs_client_secret_ocid}'" : ""
  ss_policy_statement6 = var.create_policies && var.atp_db_wallet_password_ocid!=""? "Allow dynamic-group ${oci_identity_dynamic_group.soamp_instances_principal_group[0].name} to read secret-bundles in tenancy where target.secret.id = '${var.atp_db_wallet_password_ocid}'" : ""

  ss_policy_statement7 = var.create_policies && var.use_backup_restore ? "Allow dynamic-group ${oci_identity_dynamic_group.soamp_instances_principal_group[0].name} to read vaults in tenancy where target.vault.id = '${var.kms_vault_ocid}'" : ""
  ss_policy_statement8 = var.create_policies && var.use_backup_restore ? "Allow dynamic-group ${oci_identity_dynamic_group.soamp_instances_principal_group[0].name} to use keys in tenancy where target.key.id = '${var.kms_key_ocid}'" : ""


  objstorage_policy_statement1 = var.create_policies && var.use_backup_restore ? "Allow dynamic-group ${oci_identity_dynamic_group.soamp_instances_principal_group[0].name} to manage object-family in tenancy where target.bucket.name = '${var.backup_obj_storage_bucket}'" : ""  

}

resource "oci_identity_policy" "soamp_secret-service-policy" {
  count = var.create_policies ? 1 : 0

  compartment_id = var.tenancy_id
  description    = "policy to allow access to object storage, keys and secrets in vault"
  name           = "${var.label_prefix}-secrets-policy"
  statements     = compact([local.ss_policy_statement1, local.ss_policy_statement2, local.ss_policy_statement3, local.ss_policy_statement4, local.ss_policy_statement5, local.ss_policy_statement6, local.ss_policy_statement7, local.ss_policy_statement8, local.objstorage_policy_statement1])

  #Optional
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}
