/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

/**
* Variables file with defaults. These can be overridden from environment variables TF_VAR_<variable name>
*/

// Following are generally configured in environment variables - please use env_vars_template to create env_vars and source it as:
// source ./env_vars
// before running terraform init
variable "tenancy_ocid" {
}

variable "region" {
}

/*
********************
* WLS Instance Config
********************
*/
variable "compartment_ocid" {
}

// Note: This is the opc user's SSH public key text and not the key file path.
variable "ssh_public_key" {
}

variable "service_name" {
}

# Provide WLS custom image OCID
variable "instance_image_id" {

  default = "ocid1.image.oc1..aaaaaaaapjjfhd3eemdvfefwz5ipr56jsic4e3mdrcekf25jhbafjrgd5h3a"

}

variable "wls_availability_domain_name" {
  default = ""
}

// Specify an LB AD 1 if lb is requested
variable "lb_subnet_1_availability_domain_name" {
  default = ""
}

// Specify an LB AD 2 if lb is requested
variable "lb_subnet_2_availability_domain_name" {
  default = ""
}

variable "network_compartment_id" {
  default = ""
}

# Defines the number of instances to deploy
variable "wls_node_count" {
  default = "1"
}

# Defines the number of instances during Scale-out/in
variable "wls_scaleout_node_count" {
  default = ""
}

variable "scaleout_copy_binaries" {
  default = "false"
}
#variable "instance_shape" {
#  type    = map(string)
#}

variable "enable_secure_boot" {
  default = "false"
}

variable "enable_measured_boot" {
  default = "false"
}

variable "volume_size" {
  default = "50"
}

variable "bastion_instance_shape" {
  default = "VM.Standard1.1"
}

# WLS related input variables
variable "wls_admin_user" {
  default = "weblogic"
}

variable "wls_admin_password" {
  default = ""
}

variable "wls_kms_admin_secret_compartment_id" {
  default = ""
}

variable "wls_kms_admin_password_ocid" {
  default = ""
}

variable "use_custom_nm_password" {
  default = "false"
}

variable "wls_nm_password" {
  default = ""
}

variable "wls_kms_nm_secret_compartment_id" {
  default = ""
}

variable "wls_kms_nm_password_ocid" {
  default = ""
}

variable "wls_nm_port" {
  default = "5556"
}

variable "wls_console_port" {
  default = "9071"
}

variable "wls_console_ssl_port" {
  default = "9072"
}

variable "wls_cluster_mc_port" {
  default = "5555"
}

variable "wls_extern_admin_port" {
  default = "7001"
}

variable "wls_extern_ssl_admin_port" {
  default = "7002"
}

variable "wls_ms_port" {
  default = "9073"
}

variable "wls_ms_ssl_port" {
  default = "9074"
}

variable "wls_coherence_cluster_port" {
  default = "7574"
}

variable "custom_cluster_name" {
  default = ""
}

variable "custom_domain_name" {
  default = ""
}

variable "custom_adminserver_name" {
  default = ""
}

variable "custom_managedserver_prefix" {
  default = ""
}

variable "custom_machinename_prefix" {
  default = ""
}
/*
********************
* Network Config
********************
*/

// This is WLS VCN Name if provided.
#variable "wls_vcn_name" {
#  default = ""
#}

/*
 This is existing VCN OCID.
 If both vcn_name and existing_vcn_id are provided, vcn_name is for creating new WLS VCN and existing_vcn_id is OCIDB VCN.
 In non-JRF or ATP DB case, only one of vcn_name or existing_vcn_id should be provided. If both are provided, vcn_name will
 have precedence.
*/
variable "existing_vcn_id" {
  default = ""
}

variable "wls_vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "add_load_balancer" {
  default = "false"
}

variable "load_balancer_strategy" {
  default = "Create New Load Balancer"
}

variable "existing_load_balancer" {
  default = ""
}

#variable "wls_subnet_name" {
#  default = "wls-subnet"
#}

variable "wls_subnet_cidr" {
  default = "10.0.0.0/28"
}

variable "subnet_compartment_id" {
  default = ""
}

variable "lb_compartment_id" {
  default = ""
}

variable "lb_subnet_compartment_id" {
  default = ""
}

variable "bastion_subnet_compartment_id" {
  default = ""
}

variable "lb_subnet_type" {
  default = "Use Public Subnet"
}

variable "lb_subnet_1_name" {
  default = "lb-subnet-1"
}

variable "lb_subnet_1_cidr" {
  default = ""
}

variable "lb_subnet_2_name" {
  default = "lb-subnet-2"
}

variable "lb_subnet_2_cidr" {
  default = ""
}

variable "lb_use_https" {
  default = "true"
}

variable "use_regional_subnet" {
  default = "true"
}

variable "use_soa_nsg" {
  default = "false"
}

variable "soa_nsg_compartment_id" {
  default = ""
}

variable "soa_nsg_id" {
  default = ""
}

variable "use_bastion_nsg" {
  default = "false"
}

variable "bastion_nsg_compartment_id" {
  default = ""
}

variable "bastion_nsg_id" {
  default = ""
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


// Params only required when peering VCNs in case of provisioning WLS with OCI Native DB.

variable "wls_dns_subnet_cidr" {
  default = ""
}

/**
 * Supported versions:
 * 11g - 11.1.1.7
 * 12cRelease213 - 12.2.1.3
 */
variable "wls_version" {
  default = "12.2.1.4"
}

variable "topology" {
  default = "SOA with SB & B2B Cluster"
}

variable "is_foh" {
  default = "false"
}

variable "use_schema_partitioning" {
  default = "false"
}

variable "enable_admin_console_access" {
  default = "false"
}

variable "use_custom_schema_prefix" {
  default = "false"
}

variable "rcu_schema_prefix" {
  default = ""
}

variable "use_custom_schema_password" {
  default = "false"
}

variable "rcu_schema_password" {
  default = ""
}

variable "rcu_kms_schema_secret_compartment_id" {
  default = ""
}

variable "rcu_kms_schema_password_ocid" {
  default = ""
}

/*
********************
OCI DB Config
********************
*/
// Provide DB node count - for node count > 1, WLS AGL datasource will be created

variable "ocidb_compartment_id" {
  default = ""
}

variable "ocidb_dbsystem_id" {
  default = ""
}

variable "ocidb_dbhome_id" {
  default = ""
}

variable "ocidb_database_id" {
  default = ""
}

variable "ocidb_pdb_service_name" {
  default = ""
}

// Following OCI DB params are only required when using different VCNs for WLS and OCI DB (VCN peering)
variable "ocidb_vcn_cidr" {
  default = ""
}

variable "ocidb_dns_subnet_cidr" {
  default = ""
}

variable "oci_db_user" {
  default = ""
}

variable "oci_db_password" {
  default = ""
}

variable "oci_kms_db_secret_compartment_id" {
  default = ""
}

variable "oci_kms_db_password_ocid" {
  default = ""
}

variable "oci_db_port" {
  default = "1521"
}

/*
****************************
Exadata Database Parameters
****************************
*/

variable "exa_scan_dns_name" {
  default = ""
}

/*variable "exa_host_domain_name" {
  default = ""
}

variable "is_exadata_version_11" {
  default = "false"
}

variable "exa_db_unique_name" {
  default = ""
}*/

variable "exa_pdb_service_name" {
  default = ""
}
variable "exa_db_user" {
  default = ""
}

variable "exa_db_password" {
  default = ""
}

variable "exa_kms_db_secret_compartment_id" {
  default = ""
}

variable "exa_kms_db_password_ocid" {
  default = ""
}

variable "exa_db_port" {
  default = "1521"
}

/*
********************
ATP Parameters
********************
*/

variable "atp_db_compartment_id" {
  default = ""
}

variable "use_custom_atp_db_wallet_password" {
  default = "false"
}

variable "atp_db_wallet_password" {
  default = ""
}

variable "atp_kms_db_wallet_secret_compartment_id" {
  default = ""
}

variable "atp_kms_db_wallet_password_ocid" {
  default = ""
}

variable "atp_db_id" {
  default = ""
}

variable "atp_db_level" {
  default = "low"
}

variable "custom_atp_db_level" {
  default = ""
}

variable "atp_db_password" {
  default = ""
}

variable "atp_kms_db_secret_compartment_id" {
  default = ""
}

variable "atp_kms_db_password_ocid" {
  default = ""
}

/*
********************
DB Connect String Parameters
********************
*/

variable "adv_db_connectstring" {
  default = ""
}

variable "adv_db_user" {
  default = ""
}

variable "adv_db_password" {
  default = ""
}

variable "adv_kms_db_secret_compartment_id" {
  default = ""
}

variable "adv_kms_db_password_ocid" {
  default = ""
}

/*
********************
General Parameters
********************
*/

// PROD or DEV mode
variable "mode" {
  default = "PROD"
}

variable "log_level" {
  default = "INFO"
}

variable "deploy_sample_app" {
  default = "true"
}

variable "assign_weblogic_public_ip" {
  default = "true"
}

variable "bastion_subnet_cidr" {
  default = ""
}

variable "bastion_subnet_name" {
  default = "bastion-subnet"
}

variable "wls_subnet_id" {
  default = ""
}

variable "lb_subnet_1_id" {
  default = ""
}

variable "lb_subnet_2_id" {
  default = ""
}

variable "bastion_subnet_id" {
  default = ""
}

variable "lb_shape" {
  default = "400Mbps"
}

variable "lb_flex_min_shape" {
  default = "10"
}

variable "lb_flex_max_shape" {
  default = "100"
}

/*
********************
Marketplace UI Parameters
********************
*/
# Controls if we need to subscribe to marketplace PIC image and accept terms & conditions - defaults to true
variable "use_marketplace_image" {
  default = "true"
}

variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaablyq34pmug2lu4omiedwny3jisk3yelly665bvv5c3vy5ckplacq"
}

variable "mp_listing_resource_version" {
  default = "24.1.2_-_SOA_12.2.1.4"
}

# Used in UI instead of assign_weblogic_public_ip
variable "subnet_type" {
  default = "Use Public Subnet"
}

# Used in UI instead of use_regional_subnet
variable "subnet_span" {
  default = "Regional Subnet"
}

#variable "vcn_strategy" {
#  default = "Use Existing VCN"
#}

variable "subnet_strategy_existing_vcn" {
  default = ""
}

#variable "subnet_strategy_new_vcn" {
#  default = ""
#}

variable "bastion_strategy" {
  default = "Use Private Endpoint"
}

variable "bastion_public_ip" {
  default = "0.0.0.0"
}

variable "bastion_ssh_pvt_key" {
  default = ""
}

variable "db_strategy_existing_vcn" {
  default = "No Database"
}

variable "db_strategy_new_vcn" {
  default = "No Database"
}

variable "use_advanced_wls_instance_config" {
  default = "false"
}

/*
********************
File Storage  Parameters
********************
*/

variable "use_file_storage" {
  default = "false"
}

variable "file_system_strategy" {
  default = "Create New File System"
}

variable "file_system_compartment_id" {
  default = ""
}

variable "file_storage_availability_domain" {
  default = ""
}

variable "file_system_ocid" {
  default = ""
}

variable "file_system_name" {
  default = ""
}

variable "mount_target_strategy" {
  default = "Create New Mount Target"
}

variable "mount_target_compartment_id" {
  default = ""
}

variable "mount_target_subnet_id" {
  default = ""
}

variable "mount_target_ocid" {
  default = ""
}

variable "mount_target_subnet_cidr" {
  default = ""
}

variable "mount_target_name" {
  default = ""
}

variable "mount_path" {
  default = "/u01/soacs/dbfs/share"
}

variable "mount_target_subnet_name" {
  default = "mount-target-subnet"
}

variable "use_mount_target_nsg" {
  default = "false"
}

variable "mount_target_nsg_compartment_id" {
  default = ""
}

variable "mount_target_nsg_id" {
  default = ""
}
/*
********************
Private Endpoint Parameters
********************
*/

variable "private_endpoint_strategy" {
  default = "Create New Private Endpoint"
}

variable "private_endpoint_compartment_id" {
  default = ""
}

variable "private_endpoint_subnet_compartment_id" {
  default = ""
}


variable "private_endpoint_id" {
  default = ""
}


variable "private_endpoint_subnet_cidr" {
  default = ""
}


variable "private_endpoint_subnet_id" {
  default = ""
}

variable "private_endpoint_name" {
  default = ""
}

variable "private_endpoint_subnet_name" {
  default = "private-endpoint-subnet"
}

variable "use_private_endpoint_nsg" {
  default = "false"
}

variable "private_endpoint_nsg_compartment_id" {
  default = ""
}

variable "private_endpoint_nsg_id" {
  default = ""
}

/*
********************
Email Notification Support
********************
*/

variable "use_email_notification" {
  default = "false"
}

variable "ons_topic_strategy" {
  default = "Use Existing ONS Topic"
}

variable "ons_topic_ocid" {
  default = ""
}

#variable "ons_subscription_strategy" {
#  default = "Use Existing ONS Subscription"
#}

#variable "ons_subscription_ocid" {
#  default = ""
#}

variable "ons_subscription_emailid" {
  default = ""
}

/*
********************
KMS Parameters
********************


variable "kms_key_id" {
  default = ""
}

variable "kms_service_endpoint" {
  default = ""
}
*/

variable "use_kms_decryption" {
  default = "false"
}


variable "use_backup_restore" {
  default = "false"
}

variable "kms_vault_compartment_id" {
  default = ""
}

variable "kms_vault_ocid" {
  default = ""
}

variable "kms_key_ocid" {
  default = ""
}

variable "backup_obj_storage_bucket" {
  default = ""
}

variable "create_policies" {
  default = "true"
}

/*
********************
IDCS Support
********************
*/

variable "is_idcs_selected" {
  default = "false"
}

variable "idcs_host" {
  default = "identity.oraclecloud.com"
}

variable "idcs_port" {
  default = "443"
}

variable "idcs_tenant" {
  default = ""
}

variable "idcs_client_id" {
  default = ""
}

variable "idcs_client_secret" {
  default = ""
}

variable "idcs_cloudgate_port" {
  default = "9999"
}

variable "skip_domain_creation" {
  default = "false"
}

#Note: special chars string denotes empty values for tags for validation purposes
#otherwise zipmap function in main.tf fails first for empty strings before validators executed.

variable "service_tags" {
    type = object({
    freeformTags = map(any)
    definedTags  = map(any)
  })

  default     = { freeformTags = {}, definedTags = {} }
}

#variable "defined_tag" {
#  default = "~!@#$%^&*()"
#}
#
#variable "defined_tag_value" {
#  default = "~!@#$%^&*()"
#}
#
#variable "free_form_tag" {
#  default = "~!@#$%^&*()"
#}
#
#variable "free_form_tag_value" {
#  default = "~!@#$%^&*()"
#}
