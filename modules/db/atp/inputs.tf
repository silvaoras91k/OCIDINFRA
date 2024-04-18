/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */
variable "compartment_ocid" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "tenancy_ocid" {
  type = string
}

variable "atp_db_wallet_password" {
  type = string
}

variable "atp_db_password" {
  type = string
}


variable "atp_db_name" {
  type = string
}

variable "atp_db_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "atp_db_display_name" {
  type = string
}


variable "is_quickstart" {
  default = false
}

variable "atp_db_is_dedicated" {
  default = false
}

variable "atp_db_workload" {
  default = "OLTP"
}

variable "is_atp_db" {
  default = false
}


variable "atp_db_storage_size_in_tbs" {
  default = "1"
}


variable "atp_db_core_count" {
  default = "1"
}

variable "service_name_prefix" {}

variable "defined_tags" {
  type    = map(string)
  default = {}
}

variable "freeform_tags" {
  type    = map(string)
  default = {}
}
