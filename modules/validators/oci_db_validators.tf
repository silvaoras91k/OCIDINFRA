/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

locals {
  has_ocidb_compartment_id = trimspace(var.ocidb_compartment_id != "")
  has_ocidb_dbsystem_id    = trimspace(var.ocidb_dbsystem_id) != ""
  has_ocidb_database_id    = var.ocidb_database_id != ""

  has_ocidb_pdb_service_name = var.ocidb_pdb_service_name != ""

  has_oci_db_user     = var.db_user != ""
  has_oci_db_password = var.db_password != ""

  # oci db required params
  missing_oci_db_user          = var.is_oci_db && !local.has_oci_db_user
  missing_oci_db_password      = var.is_oci_db && !local.has_oci_db_password
  missing_ocidb_compartment_id = var.is_oci_db && !local.has_ocidb_compartment_id
  missing_ocidb_database_id    = var.is_oci_db && !local.has_ocidb_database_id

  missing_ocidb_pdb_service_name = var.is_oci_db && !local.has_ocidb_pdb_service_name

  #oci validation for vcn peering (optional params)
  missing_ocidb_vcn_cidr          = local.is_vcn_peering && var.ocidb_vcn_cidr==""
  missing_ocidb_dns_subnet_cidr = local.is_vcn_peering && var.ocidb_dns_subnet_cidr == ""

  #OCI DB version validation
  ocidb_version                 = var.is_oci_db ? tonumber(substr(var.oci_db_version,0,4)) : null
  invalid_ocidb_version         = var.is_oci_db ? local.ocidb_version<18 : false

  missing_oci_db_user_msg      = "SOAC-ERROR: The value for [db_user] is required."
  validate_missing_oci_db_user = local.missing_oci_db_user ? local.validators_msg_map[local.missing_oci_db_user_msg] : null

  invalid_oci_db_password_msg      = "SOAC-ERROR: The value for [db_password] is required."
  validate_invalid_oci_db_password = local.missing_oci_db_password ? local.validators_msg_map[local.invalid_oci_db_password_msg] : null

  missing_ocidb_compartment_id_msg      = "SOAC-ERROR: The value for [ocidb_compartment_id] is required."
  validate_missing_ocidb_compartment_id = local.missing_ocidb_compartment_id ? local.validators_msg_map[local.missing_ocidb_compartment_id_msg] : null

  missing_ocidb_database_id_msg      = "SOAC-ERROR: The value for [ocidb_database_id] is required."
  validate_missing_ocidb_database_id = local.missing_ocidb_database_id ? local.validators_msg_map[local.missing_ocidb_database_id_msg] : null

  missing_ocidb_vcn_cidr_msg      = "SOAC-ERROR: The value for [ocidb_vcn_cidr] is required when using VCN peering [both existing_vcn_id and wls_vcn_name provided]."
  validate_missing_ocidb_vcn_cidr = local.missing_ocidb_vcn_cidr ? local.validators_msg_map[local.missing_ocidb_vcn_cidr_msg] : null

  missing_ocidb_dns_subnet_cidr_msg      = "SOAC-ERROR: The value for [ocidb_dns_subnet_cidr] is required when using VCN peering."
  validate_missing_ocidb_dns_subnet_cidr = local.missing_ocidb_dns_subnet_cidr ? local.validators_msg_map[local.missing_ocidb_dns_subnet_cidr_msg] : null

  invalid_ocidb_version_msg      = "SOAC-ERROR: Selected DB version is not supported. Please choose Database with version 18c or higher"
  validate_invalid_ocidb_version = local.invalid_ocidb_version ? local.validators_msg_map[local.invalid_ocidb_version_msg] : null

}

