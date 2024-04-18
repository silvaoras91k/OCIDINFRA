/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */
variable "original_service_name" {
}

variable "service_name_prefix" {
}

variable "numVMInstances" {
}

variable "is_quickstart" {
  default = "false"
}

variable "vcn_name" {
}

variable "existing_vcn_id" {
}

variable "wls_subnet_cidr" {
}

variable "lb_subnet_1_cidr" {
}

variable "lb_subnet_2_cidr" {
}

variable "is_single_ad_region" {
}

variable "lb_shape" {
}

variable "lb_flex_min_shape" {
}

variable "lb_flex_max_shape" {
}

variable "bastion_subnet_cidr" {
}

variable "assign_public_ip" {
}

variable "add_load_balancer" {
}

variable "load_balancer_strategy" {

}

variable "instance_shape" {
}

variable "flex_ocpus" {
}

variable "flex_memory" {
}

variable "wls_admin_user" {
}

variable "wls_admin_password" {
}

variable "wls_nm_port" {
}

variable "wls_cluster_mc_port" {
}

variable "wls_ms_port" {
}

variable "wls_ms_ssl_port" {
}

variable "wls_console_port" {
}

variable "wls_console_ssl_port" {
}

variable "wls_extern_admin_port" {
}

variable "wls_extern_ssl_admin_port" {
}

variable "wls_coherence_cluster_port" {
}

variable "wls_edition" {
}

variable "topology" {
}

variable "wls_availability_domain_name" {
}

variable "lb_availability_domain_name1" {
}

variable "lb_availability_domain_name2" {
}

// WLS version and artifacts
variable "wls_version" {
}

//variable oci_db_params {
//  type="map"
//}
//variable atp_db_params {
//  type="map"
//}

variable "log_level" {
}

variable "wls_subnet_id" {
}

variable "lb_subnet_1_id" {
}

variable "lb_subnet_2_id" {
}

variable "bastion_subnet_id" {
}

// OCI DB Params
variable "ocidb_compartment_id" {
}

variable "ocidb_dbsystem_id" {
}

variable "ocidb_database_id" {
}

variable "ocidb_pdb_service_name" {
}

variable "is_oci_db" {
  default = "false"
}

variable "oci_db_version" {
}

//Exadata DB params

variable "is_exa_db" {
  default = "false"
}

variable "exa_scan_dns_name" {
}

/*variable "exa_db_unique_name" {
}
*/
variable "exa_pdb_service_name" {
}

/*variable "is_exadata_version_11" {
  default = "false"
}*/

// Advanced DB params
variable "is_adv_db" {
  default = "false"
}

variable "adv_db_connectstring" {
}


// ATP DB params
variable "is_atp_db" {
  default = "false"
}

variable "atp_db_id" {
}

variable "atp_db_level" {
}

variable "atp_db_compartment_id" {
}

// Common DB params
variable "db_user" {
}

variable "db_password" {
}

// vcn peering for oci db variables
variable "ocidb_vcn_cidr" {
}

variable "ocidb_dns_subnet_cidr" {
}

//variable "ocidb_subnet_id" {}
//variable "ocidb_availability_domain_name" {}
//variable "ocidb_vcn_compartment_id" {}
variable "wls_dns_subnet_cidr" {
}

variable "use_regional_subnet" {
}

variable "use_kms_decryption" {
}

variable "atp_db_wallet_password" {
}

//IDCS
variable "is_idcs_selected" {
}

variable "idcs_host" {
}

variable "idcs_tenant" {
}

variable "idcs_client_id" {
}

variable "idcs_client_secret" {
}

variable "idcs_cloudgate_port" {
}

#variable "defined_tag" {
#}
#
#variable "defined_tag_value" {
#}
#
#variable "freeform_tag" {
#}
#
#variable "freeform_tag_value" {
#}
