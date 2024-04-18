/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

locals {
  //  has_atp_db_user            = "${var.db_user==""?false:true}"
  has_atp_db_id              = var.is_atp_db && var.atp_db_id != "" ? true : false
  has_atp_db_password        = var.is_atp_db && var.db_password == "" ? false : true
  is_encryption_used         = var.use_kms_decryption == "true" ? true : false
  has_atp_db_wallet_password = var.atp_db_wallet_password == "" ? local.is_encryption_used : true
  has_atp_db_compartment_id  = var.is_quickstart ? true : var.is_atp_db ? var.atp_db_compartment_id != "" : true

  //  missing_atp_db_user            = "${(local.has_atp_db_id && !local.has_atp_db_user)}"
  #  missing_atp_db_password        = "${(local.has_atp_db_id && !local.has_atp_db_password)}"
  missing_atp_password_msg      = "SOAC-ERROR: The value for [db_password] is required."
  validate_missing_atp_password = local.has_atp_db_password == "false" ? local.validators_msg_map[local.missing_atp_password_msg] : null

  atp_db_level             = lower(var.atp_db_level)
  invalid_atp_db_level     = var.is_atp_db && local.atp_db_level != "low" && local.atp_db_level != "tp" && local.atp_db_level != "tpurgent"
  invalid_atp_db_level_msg = "SOAC-ERROR: The value for [atp_db_level] is invalid. The valid values are [low, tp, tpurgent]"

  validate_invalid_atp_db_level = local.invalid_atp_db_level ? local.validators_msg_map[local.invalid_atp_db_level_msg] : null

  missing_atpdb_compartment_id_msg      = "WLSC-ERROR: The value for atp_db_compartment_id is required."
  validate_missing_atpdb_compartment_id = local.has_atp_db_compartment_id ? null : local.validators_msg_map[local.missing_atpdb_compartment_id_msg]
}
