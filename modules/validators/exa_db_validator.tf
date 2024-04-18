/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

locals {
  has_exa_scan_dns_name             = var.is_exa_db && var.exa_scan_dns_name != "" ? true : false
  //has_exa_db_unique_name        = var.is_exa_db && var.is_exadata_version_11 && var.exa_db_unique_name == "" ? false : true
  has_exa_pdb_service_name = var.is_exa_db && var.exa_pdb_service_name == "" ? false : true


  missing_exa_scan_dns_name_msg      = "SOAC-ERROR: The value for [exa_scan_dns_name] is required."
  validate_missing_exa_scan_dns_name = local.has_exa_scan_dns_name == "false" ? local.validators_msg_map[local.missing_exa_scan_dns_name_msg] : null

  //missing_exa_db_unique_name_msg      = "SOAC-ERROR: The value for [exa_db_unique_name] is required if the database version is 11.x."
  //validate_missing_exa_db_unique_name = local.has_exa_db_unique_name == "false" ? local.validators_msg_map[local.missing_exa_db_unique_name_msg] : null

  missing_exa_pdb_service_name_msg      = "SOAC-ERROR: The value for [exa_pdb_service_name] is required for databases version of 12.x and above."
  validate_missing_exa_pdb_service_name = local.has_exa_pdb_service_name == "false" ? local.validators_msg_map[local.missing_exa_pdb_service_name_msg] : null

  }
