/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */
variable "compartment_ocid" {
}

variable "tenancy_ocid" {
}

variable "subnet_ocids" {
  type = list(string)
}

variable "topology" {
}

variable "use_lb_nsg" {
  default = "false"
}

variable "lb_nsg_compartment_id" {
  default = ""
}

variable "lb_nsg_id" {
  default = ""
}

variable "instance_private_ips" {
  type = list(string)
}

variable "is_private_loadbalancer" {
  default = "false"
}

variable "shape" {
  default = "400Mbps"
}

variable "min_shape" {
  default = "10"
}

variable "max_shape" {
  default = "100"
}

variable "name" {
  default = "wls-loadbalancer"
}

variable "wls_ms_port" {
}

variable "lb-protocol" {
  default = "HTTP"
}

variable "lb-lstr-port" {
  default = "80"
}

variable "lb-https-lstr-port" {
  default = "443"
}

variable "use-https" {
}

variable "numVMInstances" {
}

variable "policy_weight" {
  default = "1"
}

variable "backend_set_health_checker_interval_ms" {
  default = "10000"
}

variable "backend_set_health_checker_timeout_in_millis" {
  default = "3000"
}

variable "add_load_balancer" {
}

variable "load_balancer_strategy" {
  default = "Create New Load Balancer"
}

variable "existing_load_balancer" {
  default = ""
}

variable "lb_backendset_name" {
  default = "wls-lb-backendset"
}

variable "lb_policy" {
  default = "ROUND_ROBIN"
}

variable "is_idcs_selected" {
}

variable "idcs_cloudgate_port" {
}
/*
variable "lbr_ssl_cert" {
}

variable "lbr_ssl_pvt_key" {
}

variable "lbr_ssl_pub_key" {
}
*/
variable "sslCertificateName" {
}

variable "defined_tags" {
  type    = map(string)
  default = {}
}

variable "freeform_tags" {
  type    = map(string)
  default = {}
}
