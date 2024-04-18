# Copyright 2020, 2021, Oracle Corporation and/or affiliates.  All rights reserved.

variable "tenancy_id" {}

variable "compartment_id" {}

variable "label_prefix" {}

variable "create_policies" {
  type    = bool
  default = true
}

#password ocids
variable "wls_admin_password_ocid" {
  type = string
}

variable "wls_nm_password_ocid" {
  type = string
}

variable "rcu_schema_password_ocid" {
  type = string
}

variable "atp_db_wallet_password_ocid" {
  type = string
}

variable "db_password_ocid" {
  type    = string
  default = ""
}

variable "idcs_client_secret_ocid" {
  type    = string
  default = ""
}

variable "instance_ocids" {
  type = list
}

variable "use_backup_restore" {
  type    = bool
  default = false
}

variable "kms_vault_ocid" {
  type    = string
  default = ""
}

variable "kms_key_ocid" {
  type    = string
  default = ""
}

variable "backup_obj_storage_bucket" {}

variable "defined_tags" {
  type    = map(string)
  default = {}
}

variable "freeform_tags" {
  type    = map(string)
  default = {}
}
