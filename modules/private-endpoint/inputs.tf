
// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "compartment_ocid" {}
variable "vcn_id" {}
variable "private_endpoint_subnet_id" {}

variable "use_private_endpoint" {
  default = "false"
}

variable "service_name_prefix" {
  default = ""
}

variable "use_existing_private_endpoint" {
  default = "true"
}

//variable "private_endpoint_display_name" {
//  default = "SOAPrivateEndpoint"
//}

variable "private_endpoint_id" {
 default = ""
}

variable "use_nsg" {
  default = "false"
}

variable "nsg_compartment_id" {
  default = ""
}

variable "nsg_id" {
  default = ""
}

variable "defined_tags" {
  type    = map(string)
  default = {}
}

variable "freeform_tags" {
  type    = map(string)
  default = {}
}
