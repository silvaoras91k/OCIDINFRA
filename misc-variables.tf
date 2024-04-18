
/*
********************
Any updates to this file needs to be replicated in the corresponding file ../terraform_qs/misc-variables.tf
********************
*/

variable "is_quickstart" {
  default = "false"
}

variable "atp_db_name" {
  default = "ATP"
}

variable "atp_db_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "atp_db_workload" {
  default = "OLTP"
}

variable "atp_db_display_name" {
  default = "ATP"
}

variable "atp_db_is_dedicated" {
  default = false
}

variable "vcn_strategy" {
  default = "Use Existing VCN"
}

variable "subnet_strategy_new_vcn" {
  default = ""
}

variable "wls_vcn_name" {
  default = ""
}

variable "wls_subnet_name" {
  default = "wls-subnet"
}

variable "instance_shape" {
  type    = map(string)
}
