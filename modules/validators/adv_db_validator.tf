/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

locals {

  has_adv_db_user     = var.db_user != ""
  has_adv_db_password = var.db_password != ""


  missing_adv_db_user          = var.is_adv_db && !local.has_adv_db_user
  missing_adv_db_password      = var.is_adv_db && !local.has_adv_db_password

  missing_adv_db_connectstring      = var.is_adv_db && var.adv_db_connectstring == "" ? true:false


  missing_adv_db_user_msg      = "SOAC-ERROR: The value for [db_user] is required."
  validate_missing_adv_db_user = local.missing_adv_db_user ? local.validators_msg_map[local.missing_adv_db_user_msg] : null


  missing_adv_db_password_msg      = "SOAC-ERROR: The value for [db_password] is required."
  validate_missing_adv_db_password = local.missing_adv_db_password ? local.validators_msg_map[local.missing_adv_db_password_msg] : null


  missing_adv_db_connectstring_msg      = "SOAC-ERROR: The value for [adv_db_connectstring] is required."
  validate_missing_adv_db_connectstring = local.missing_adv_db_connectstring ? local.validators_msg_map[local.missing_adv_db_connectstring_msg] : null

}
