/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

locals {
  compartment_ocid = var.compartment_ocid
  numVMInstances   = var.wls_scaleout_node_count == ""?var.wls_node_count:(var.wls_scaleout_node_count == var.wls_node_count)?var.wls_node_count:var.wls_scaleout_node_count
  is_scaling = var.wls_scaleout_node_count == "" ? false: true
  is_adv_db        = (var.db_strategy_existing_vcn == "Database Connection String (not recommended)") ? true : false
  is_atp_db        = var.is_quickstart ? true : trimspace(var.atp_db_id) == "" ? false : true
  is_exa_db        = (var.db_strategy_existing_vcn == "Exadata Database" || var.db_strategy_new_vcn == "Exadata Database") ? true : false
  exa_dns_name_list = split(".",var.exa_scan_dns_name)
  exa_host_domain_name = local.is_exa_db ? join(".",slice(local.exa_dns_name_list,1,length(local.exa_dns_name_list))) : ""
  atp_db_level = local.is_atp_db ? ( var.atp_db_level == "Custom Service Level" ? var.custom_atp_db_level : var.atp_db_level) : ""
  wls_admin_password = var.use_kms_decryption ? var.wls_kms_admin_password_ocid : var.wls_admin_password
  rcu_schema_password = var.use_kms_decryption ? var.rcu_kms_schema_password_ocid : var.rcu_schema_password
  wls_nm_password = var.use_kms_decryption ? var.wls_kms_nm_password_ocid : var.wls_nm_password
  create_policies = var.use_kms_decryption ? var.create_policies : false
  // Default DB user for ATP DB is admin
  atp_db_password           = var.use_kms_decryption ? var.atp_kms_db_password_ocid : var.atp_db_password
  atp_db_wallet_password    = local.is_atp_db ? (var.use_custom_atp_db_wallet_password ? (var.use_kms_decryption ? var.atp_kms_db_wallet_password_ocid : var.atp_db_wallet_password) : "") : ""
  exa_db_password           = var.use_kms_decryption ? var.exa_kms_db_password_ocid : var.exa_db_password
  adv_db_password           = var.use_kms_decryption ? var.adv_kms_db_password_ocid : var.adv_db_password
  oci_db_password           = var.use_kms_decryption ? var.oci_kms_db_password_ocid : var.oci_db_password
  db_user                   = local.is_atp_db ? "ADMIN" : (local.is_exa_db ? var.exa_db_user : (local.is_adv_db ? var.adv_db_user : var.oci_db_user))
  db_kms_password_ocid      = local.is_atp_db ? (var.is_quickstart ? var.wls_kms_admin_password_ocid : var.atp_kms_db_password_ocid) : (local.is_exa_db ? var.exa_kms_db_password_ocid : (local.is_adv_db ? var.adv_kms_db_password_ocid : var.oci_kms_db_password_ocid))
  db_password               = local.is_atp_db ? (var.is_quickstart ? local.wls_admin_password : local.atp_db_password) : (local.is_exa_db ? local.exa_db_password : (local.is_adv_db ? local.adv_db_password : local.oci_db_password))
  is_oci_db                 = trimspace(var.ocidb_dbsystem_id) == "" ? false : true
  oci_db_version            = local.is_oci_db ? data.oci_database_db_systems.oci_db_systems.0.db_systems.0.version : ""
  assign_weblogic_public_ip = var.assign_weblogic_public_ip && var.subnet_type == "Use Public Subnet" ? true : false
  use_private_endpoint = var.subnet_type == "Use Private Subnet" && var.bastion_strategy == "Use Private Endpoint" ? true : false
  use_existing_private_endpoint = var.bastion_strategy == "Use Private Endpoint" && var.private_endpoint_strategy == "Use Existing Private Endpoint"? true : false
  use_bastion      = var.subnet_type == "Use Private Subnet" && !(var.bastion_strategy == "Use Private Endpoint") ? true : false
  use_existing_bastion      = var.bastion_strategy == "Use Existing Bastion Instance" ? true : false
  bastion_subnet_cidr       = var.bastion_subnet_cidr == "" && var.wls_vcn_name != "" && local.assign_weblogic_public_ip == "false" ? "10.0.6.0/24" : var.bastion_subnet_cidr
  wls_subnet_cidr           = var.wls_subnet_cidr == "" && var.wls_vcn_name != "" ? "10.0.3.0/24" : var.wls_subnet_cidr
  lb_subnet_1_subnet_cidr   = var.lb_subnet_1_cidr == "" && var.wls_vcn_name != "" ? "10.0.4.0/24" : var.lb_subnet_1_cidr
  lb_subnet_2_subnet_cidr   = var.lb_subnet_2_cidr == "" && var.wls_vcn_name != "" ? "10.0.5.0/24" : var.lb_subnet_2_cidr
  tf_version_file           = "version.txt"
  use_file_storage = local.is_atp_db && var.topology == "MFT Cluster" ? "true" : var.use_file_storage
  use_existing_subnets      = var.subnet_strategy_existing_vcn == "Create New Subnet" || var.subnet_strategy_new_vcn == "Create New Subnet" ? false : true
  use_existing_mount_target = local.use_file_storage && var.mount_target_strategy == "Use Existing Mount Target"? true : false
  use_existing_file_system = local.use_file_storage && var.file_system_strategy == "Use Existing File System"? true : false
  #service_name              = "${var.service_name}${substr(uuid(), 0,8)}"
  # Remove all characters from the service_name that dont satisfy the criteria:
  # must start with letter, must only contain letters and numbers and length between 1,8
  # See https://github.com/google/re2/wiki/Syntax
  service_name_prefix      = replace(var.service_name, "/[^a-zA-Z0-9]/", "")
  requires_JRF             = local.is_oci_db || local.is_atp_db || local.is_exa_db || local.is_adv_db? true : false
  prov_type                = local.requires_JRF ? (local.is_atp_db ? "(${var.topology} with ATP DB)" : (local.is_adv_db ? "(${var.topology} with DB Connect String)" : "(${var.topology} with OCI DB)")) : "(Non JRF)"
  use_regional_subnet      = var.use_regional_subnet && var.subnet_span == "Regional Subnet" ? true : false
  network_compartment_id   = var.network_compartment_id == "" ? var.compartment_ocid : var.network_compartment_id
  subnet_compartment_id    = var.subnet_compartment_id == "" ? local.network_compartment_id : var.subnet_compartment_id
  lb_subnet_compartment_id = var.lb_subnet_compartment_id == "" ? local.network_compartment_id : var.lb_subnet_compartment_id
  lb_compartment_id = var.lb_compartment_id == "" ? local.network_compartment_id : var.lb_compartment_id
  bastion_subnet_compartment_id = var.bastion_subnet_compartment_id == "" ? local.network_compartment_id : var.bastion_subnet_compartment_id

  #Availability Domains
  ad_names                    = compact(data.template_file.ad_names.*.rendered)
  private_endpoint_availability_domain = local.use_regional_subnet ? local.ad_names[0] : (var.private_endpoint_subnet_id == "" ? var.wls_availability_domain_name : data.oci_core_subnet.private_endpoint_subnet[0].availability_domain)
  bastion_availability_domain = local.use_regional_subnet ? local.ad_names[0] : (var.bastion_subnet_id == "" ? var.wls_availability_domain_name : data.oci_core_subnet.bastion_subnet[0].availability_domain)
  #for existing wls subnet, get AD from the subnet
  wls_availability_domain      = local.use_regional_subnet ? local.ad_names[0] : (var.wls_subnet_id == "" ? var.wls_availability_domain_name : data.oci_core_subnet.wls_subnet[0].availability_domain)

  # Compute shape
  instance_shape = lookup(tomap(var.instance_shape),"instanceShape","None")
  flex_ocpus = lookup(tomap(var.instance_shape),"ocpus","0")
  flex_memory = lookup(tomap(var.instance_shape),"memory","0")
  enable_measured_boot = var.enable_secure_boot ? var.enable_measured_boot : false


  #map of Tag key and value
  #special chars string denotes empty values for tags for validation purposes
  #otherwise zipmap function below fails first for empty strings before validators executed
  #use_defined_tags = var.defined_tag == "~!@#$%^&*()" && var.defined_tag_value == "~!@#$%^&*()" ? false : true

  #use_freeform_tags = var.free_form_tag == "~!@#$%^&*()" && var.free_form_tag_value == "~!@#$%^&*()" ? false : true

  #ignore defaults of special chars if tags are not provided
  #defined_tag         = false == local.use_defined_tags ? "" : var.defined_tag
  #defined_tag_value   = false == local.use_defined_tags ? "" : var.defined_tag_value
  #free_form_tag       = var.is_quickstart ? "QSTag" : (false == local.use_freeform_tags ? "" : var.free_form_tag)
  #free_form_tag_value = var.is_quickstart ? local.service_name_prefix : (false == local.use_freeform_tags ? "" : var.free_form_tag_value)
  /*lbr_ssl_cert        = file("${path.module}/CombinedDigicertCA.cer")
  lbr_ssl_pvt_key     = file("${path.module}/star_soa_ocp_oraclecloud_com.key")
  lbr_ssl_pub_key     = file("${path.module}/_.soa.ocp.oraclecloud.com.crt") */

  #defined_tags = zipmap(
  #  compact([trimspace(local.defined_tag)]),
  #  compact([trimspace(local.defined_tag_value)]),
  #)
  #freeform_tags = zipmap(
  #  compact([trimspace(local.free_form_tag)]),
  #  compact([trimspace(local.free_form_tag_value)]),
  #)

  freeform_tags  = var.service_tags.freeformTags
  defined_tags   = var.service_tags.definedTags
}

module "validators" {
  source = "./modules/validators"

  original_service_name = var.service_name
  service_name_prefix   = local.service_name_prefix
  numVMInstances        = local.numVMInstances
  existing_vcn_id       = var.existing_vcn_id
  wls_subnet_cidr       = var.wls_subnet_cidr
  lb_subnet_1_cidr      = var.lb_subnet_1_cidr
  lb_subnet_2_cidr      = var.lb_subnet_2_cidr
  bastion_subnet_cidr   = var.bastion_subnet_cidr
  assign_public_ip      = local.assign_weblogic_public_ip
  load_balancer_strategy = var.load_balancer_strategy
  add_load_balancer     = var.add_load_balancer
  is_idcs_selected      = var.is_idcs_selected
  idcs_host             = var.idcs_host
  idcs_tenant           = var.idcs_tenant
  idcs_client_id        = var.idcs_client_id
  idcs_client_secret    = var.idcs_client_secret
  idcs_cloudgate_port   = var.idcs_cloudgate_port

  is_quickstart               = var.is_quickstart

  instance_shape = local.instance_shape
  flex_ocpus     = local.flex_ocpus
  flex_memory    = local.flex_memory

  wls_admin_user     = var.wls_admin_user
  wls_admin_password = local.wls_admin_password

  wls_nm_port               = var.wls_nm_port
  wls_console_port          = var.wls_console_port
  wls_console_ssl_port      = var.wls_console_ssl_port
  wls_ms_port               = var.wls_ms_port
  wls_ms_ssl_port           = var.wls_ms_ssl_port
  wls_cluster_mc_port       = var.wls_cluster_mc_port
  wls_extern_admin_port     = var.wls_extern_admin_port
  wls_extern_ssl_admin_port = var.wls_extern_ssl_admin_port
  wls_coherence_cluster_port       = var.wls_coherence_cluster_port

  wls_availability_domain_name = local.wls_availability_domain
  lb_availability_domain_name1 = var.lb_subnet_1_availability_domain_name
  lb_availability_domain_name2 = var.lb_subnet_2_availability_domain_name
  wls_subnet_id                = var.wls_subnet_id
  lb_subnet_1_id               = var.lb_subnet_1_id
  lb_subnet_2_id               = var.lb_subnet_2_id
  is_single_ad_region         = local.is_single_ad_region
  bastion_subnet_id            = var.bastion_subnet_id
  lb_shape                     = var.lb_shape
  lb_flex_min_shape            = var.lb_flex_min_shape
  lb_flex_max_shape            = var.lb_flex_max_shape
  // WLS version and edition
  wls_version = var.wls_version
  wls_edition = var.wls_edition
  log_level   = var.log_level
  vcn_name    = var.wls_vcn_name

  //soacs Topologies
  topology = var.topology

  // OCI DB Params
  ocidb_compartment_id   = var.ocidb_compartment_id
  ocidb_dbsystem_id      = var.ocidb_dbsystem_id
  ocidb_database_id      = var.ocidb_database_id
  ocidb_pdb_service_name = var.ocidb_pdb_service_name
  is_oci_db              = local.is_oci_db
  oci_db_version         = local.oci_db_version

  // ATP DB Params
  is_atp_db             = local.is_atp_db ? "true" : "false"
  atp_db_level          = local.atp_db_level
  atp_db_id             = var.atp_db_id
  atp_db_compartment_id = var.atp_db_compartment_id

  // Exadata DB Params
  is_exa_db             = local.is_exa_db
  exa_scan_dns_name     = var.exa_scan_dns_name
#  is_exadata_version_11 = var.is_exadata_version_11
#  exa_db_unique_name    = var.exa_db_unique_name
  exa_pdb_service_name  = var.exa_pdb_service_name

  // Advanced DB params
  is_adv_db = local.is_adv_db
  adv_db_connectstring = var.adv_db_connectstring

  // Common params
  db_user     = local.db_user
  db_password = local.db_password

  // VCN peering variables for OCI DB
  ocidb_dns_subnet_cidr = var.ocidb_dns_subnet_cidr
  ocidb_vcn_cidr        = var.ocidb_vcn_cidr

  wls_dns_subnet_cidr = var.wls_dns_subnet_cidr

  use_regional_subnet = local.use_regional_subnet

  // KMS
  use_kms_decryption     = var.use_kms_decryption
  atp_db_wallet_password = local.atp_db_wallet_password
#  defined_tag            = var.defined_tag
#  defined_tag_value      = var.defined_tag_value
#  freeform_tag           = var.free_form_tag
#  freeform_tag_value     = var.free_form_tag_value
}

module "compute-keygen" {
  source = "./modules/compute/keygen"
}

module "notification" {
  source = "./modules/notification"
  compartment_id    = local.compartment_ocid
  service_name_prefix  = substr(local.service_name_prefix,0,8)
  use_email_notification      = var.use_email_notification
  ons_topic_strategy          = var.ons_topic_strategy
  ons_topic_ocid              = var.ons_topic_ocid
#  ons_subscription_strategy   = var.ons_subscription_strategy
#  ons_subscription_ocid       = var.ons_subscription_ocid
  ons_subscription_emailid    = var.ons_subscription_emailid
  defined_tags         = local.defined_tags
  freeform_tags        = local.freeform_tags
}

module "network-vcn" {
  source = "./modules/network/vcn"

  compartment_ocid = local.network_compartment_id

  // New VCN is created if vcn_name is not empty
  // Existing vcn_id is returned back without creating a new VCN if vcn_name is empty but vcn_id is provided.
  vcn_name = var.wls_vcn_name

  vcn_id               = var.existing_vcn_id
  wls_vcn_cidr         = var.wls_vcn_cidr
  use_existing_subnets = local.use_existing_subnets
  service_name_prefix  = substr(local.service_name_prefix,0,11)
  defined_tags         = local.defined_tags
  freeform_tags        = local.freeform_tags
}

/* Adds new dhcp options, security list, route table */
module "network-vcn-config" {
  source = "./modules/network/vcn-config"

  compartment_id        = local.network_compartment_id

  //vcn id if new is created
  vcn_id          = module.network-vcn.VcnID
  existing_vcn_id = var.existing_vcn_id

  wls_ssl_admin_port          = var.wls_extern_ssl_admin_port
  wls_ms_port                 = var.wls_ms_port
  wls_ms_ssl_port             = var.wls_ms_ssl_port
  wls_admin_port              = var.wls_extern_admin_port
  enable_admin_console_access = var.enable_admin_console_access
  dhcp_options_name           = local.assign_weblogic_public_ip == "false" ? "bastion-dhcpOptions" : "dhcpOptions"
  wls_security_list_name      = local.assign_weblogic_public_ip == "false" ? "bastion-security-list" : "wls-security-list"
  wls_subnet_cidr             = local.wls_subnet_cidr
  lb_subnet_2_cidr            = local.lb_subnet_2_subnet_cidr
  lb_subnet_1_cidr            = local.lb_subnet_1_subnet_cidr
  add_load_balancer           = var.add_load_balancer
  lb_use_https                = var.lb_use_https
  wls_vcn_name                = var.wls_vcn_name
  use_existing_subnets        = local.use_existing_subnets
  service_name_prefix         = local.service_name_prefix
  assign_backend_public_ip    = local.assign_weblogic_public_ip
  use_regional_subnets        = local.use_regional_subnet
  use_bastion                 = local.use_bastion
  use_existing_bastion        = local.use_existing_bastion
  bastion_subnet_cidr         = local.bastion_subnet_cidr
  use_private_endpoint        = local.use_private_endpoint
  private_endpoint_subnet_cidr         = var.private_endpoint_subnet_cidr
  is_single_ad_region         = local.is_single_ad_region
  is_idcs_selected            = var.is_idcs_selected
  idcs_cloudgate_port         = var.idcs_cloudgate_port
  defined_tags                = local.defined_tags
  freeform_tags               = local.freeform_tags
}

/* Create primary subnet for Load balancer only */
module "network-lb-subnet-1" {
  source              = "./modules/network/subnet"
  service_name_prefix = local.service_name_prefix
  compartment_ocid    = local.network_compartment_id
  subnet_compartment_id = local.lb_subnet_compartment_id
  tenancy_ocid        = var.tenancy_ocid
  vcn_id              = module.network-vcn.VcnID
  security_list_id    = module.network-vcn-config.lb_security_list_id
  dhcp_options_id     = module.network-vcn-config.dhcp_options_id
  route_table_id      = module.network-vcn-config.route_table_id[0]

  subnet_name         = "${local.service_name_prefix}-${var.lb_subnet_1_name}"
  dns_label           = substr("sublb1${local.service_name_prefix}",0,14)
  cidr_block          = local.lb_subnet_1_subnet_cidr
  availability_domain = var.lb_subnet_1_availability_domain_name
  subnetCount         = (var.add_load_balancer && var.load_balancer_strategy == "Create New Load Balancer" && var.lb_subnet_1_id == "")?1:0
  subnet_id           = var.lb_subnet_1_id
  use_regional_subnet = local.use_regional_subnet
  prohibit_public_ip  = var.lb_subnet_type == "Use Public Subnet" ? false : true
  defined_tags        = local.defined_tags
  freeform_tags       = local.freeform_tags
}

/* Create secondary subnet for wls and lb backend */
module "network-lb-subnet-2" {
  source              = "./modules/network/subnet"
  service_name_prefix = local.service_name_prefix
  compartment_ocid    = local.network_compartment_id
  subnet_compartment_id    = local.lb_subnet_compartment_id
  tenancy_ocid        = var.tenancy_ocid
  vcn_id              = module.network-vcn.VcnID
  security_list_id    = module.network-vcn-config.lb_security_list_id
  dhcp_options_id     = module.network-vcn-config.dhcp_options_id
  route_table_id      = module.network-vcn-config.route_table_id[0]
  subnet_name         = "${local.service_name_prefix}-${var.lb_subnet_2_name}"
  dns_label           = substr("sublb2${local.service_name_prefix}",0,14)
  cidr_block          = local.lb_subnet_2_subnet_cidr
  availability_domain = var.lb_subnet_2_availability_domain_name
  subnetCount         = (var.add_load_balancer && var.load_balancer_strategy == "Create New Load Balancer" && var.lb_subnet_2_id == "" && !local.use_regional_subnet && !local.is_single_ad_region)?1:0
  subnet_id           = (var.add_load_balancer && !local.use_regional_subnet && !local.is_single_ad_region)?var.lb_subnet_2_id : ""
  use_regional_subnet = local.use_regional_subnet
  prohibit_public_ip  = var.lb_subnet_type == "Use Public Subnet" ? false : true
  defined_tags        = local.defined_tags
  freeform_tags       = local.freeform_tags
}

/* Create back end subnet for private endpoint */
module "network-private-endpoint-subnet" {
  source              = "./modules/network/subnet"
  service_name_prefix = local.service_name_prefix
  subnet_compartment_id = var.private_endpoint_subnet_compartment_id
  compartment_ocid    = local.network_compartment_id
  tenancy_ocid        = var.tenancy_ocid
  vcn_id              = module.network-vcn.VcnID
  security_list_id = compact(
      module.network-vcn-config.wls_security_list_id
  )
  dhcp_options_id     = module.network-vcn-config.dhcp_options_id
  route_table_id      = module.network-vcn-config.route_table_id[0]
  subnet_name         = "${local.service_name_prefix}-${var.private_endpoint_subnet_name}"
  dns_label           = substr("subpvtendpt${local.service_name_prefix}",0,14)
  cidr_block          = var.private_endpoint_subnet_cidr
  availability_domain = local.private_endpoint_availability_domain
  subnetCount         = !local.assign_weblogic_public_ip && local.use_private_endpoint && !local.use_existing_subnets ? 1 : 0
  subnet_id           = var.private_endpoint_subnet_id
  use_regional_subnet = local.use_regional_subnet
  prohibit_public_ip  = "true"
  defined_tags        = local.defined_tags
  freeform_tags       = local.freeform_tags
}

/* Create back end subnet for wls and lb backend */
module "network-bastion-subnet" {
  source              = "./modules/network/subnet"
  service_name_prefix = local.service_name_prefix
  subnet_compartment_id = local.bastion_subnet_compartment_id
  compartment_ocid    = local.network_compartment_id
  tenancy_ocid        = var.tenancy_ocid
  vcn_id              = module.network-vcn.VcnID
  security_list_id = compact(
    concat(
      module.network-vcn-config.wls_security_list_id,
      module.network-vcn-config.wls_ms_security_list_id,
    ),
  )
  dhcp_options_id     = module.network-vcn-config.dhcp_options_id
  route_table_id      = module.network-vcn-config.route_table_id[0]
  subnet_name         = "${local.service_name_prefix}-${var.bastion_subnet_name}"
  dns_label           = substr("subbtn${local.service_name_prefix}",0,14)
  cidr_block          = local.bastion_subnet_cidr
  availability_domain = local.bastion_availability_domain
  subnetCount         = (!local.assign_weblogic_public_ip && local.use_bastion && !local.use_existing_bastion && !local.use_existing_subnets)?1:0
  subnet_id           = var.bastion_subnet_id
  use_regional_subnet = local.use_regional_subnet
  prohibit_public_ip  = "false"
  defined_tags        = local.defined_tags
  freeform_tags       = local.freeform_tags
}

/* Create back end subnet for private endpoint */
module "network-mount-target-subnet" {
  source              = "./modules/network/subnet"
  service_name_prefix = local.service_name_prefix
  subnet_compartment_id = var.mount_target_compartment_id
  compartment_ocid    = local.network_compartment_id
  tenancy_ocid        = var.tenancy_ocid
  vcn_id              = module.network-vcn.VcnID
  security_list_id = compact(
      module.network-vcn-config.wls_internal_security_list_id
  )
  dhcp_options_id     = module.network-vcn-config.dhcp_options_id
  route_table_id      = module.network-vcn-config.route_table_id[0]
  subnet_name         = "${local.service_name_prefix}-${var.mount_target_subnet_name}"
  dns_label           = substr("submnt${local.service_name_prefix}",0,14)
  cidr_block          = var.mount_target_subnet_cidr
  availability_domain = var.file_storage_availability_domain
  subnetCount         = local.use_file_storage && var.mount_target_strategy == "Create New Mount Target" && !local.use_existing_subnets ? 1 : 0
  subnet_id           = var.mount_target_subnet_id
  use_regional_subnet = local.use_regional_subnet
  prohibit_public_ip  = var.subnet_type == "Use Private Subnet" ? "true":"false"
  defined_tags        = local.defined_tags
  freeform_tags       = local.freeform_tags
}

module "bastion-compute" {
  source = "./modules/compute/bastion-instance"

  tenancy_ocid        = var.tenancy_ocid
  compartment_ocid    = local.compartment_ocid
  availability_domain = local.bastion_availability_domain
  opc_key             = module.compute-keygen.OPCPrivateKey
  ssh_public_key      = var.ssh_public_key
  use_bastion_nsg              = var.use_bastion_nsg
  bastion_nsg_compartment_id   = var.bastion_nsg_compartment_id
  bastion_nsg_id               = var.bastion_nsg_id
  bastion_subnet_ocid = element(module.network-bastion-subnet.subnet_id,0)
  instance_shape      = var.bastion_instance_shape
  instance_count      = (!local.assign_weblogic_public_ip && local.use_bastion)?1:0
  region              = var.region
  instance_name       = "${local.service_name_prefix}-bastion-instance"
  use_existing_bastion= local.use_existing_bastion
  #  instance_image_id   = "${var.bastion_instance_image_id[var.region]}"
  defined_tags  = local.defined_tags
  freeform_tags = local.freeform_tags
}

module "network-dns-vms" {
  source              = "./modules/network/vcn-peering"
  service_name_prefix = local.service_name_prefix
  tenancy_ocid        = var.tenancy_ocid
  compartment_ocid    = local.network_compartment_id
  instance_shape      = local.instance_shape
  region              = var.region

  wls_availability_domain = local.wls_availability_domain
  ssh_public_key          = var.ssh_public_key

  wls_vcn_id          = module.network-vcn.VcnID
  wls_vcn_cidr        = var.wls_vcn_cidr
  existing_vcn_id     = var.existing_vcn_id
  wls_vcn_name        = var.wls_vcn_name
  wls_dns_subnet_cidr = var.wls_dns_subnet_cidr

  ocidb_database_id    = var.ocidb_database_id
  ocidb_compartment_id = var.ocidb_compartment_id
  ocidb_dbsystem_id    = trimspace(var.ocidb_dbsystem_id)
  ocidb_vcn_cidr       = var.ocidb_vcn_cidr

  ocidb_dns_subnet_cidr = var.ocidb_dns_subnet_cidr

  // Adding dependency on vcn-config module
  wls_internet_gateway_id = module.network-vcn-config.wls_internet_gateway_id

  // Private subnet support
  bastion_host_private_key = module.compute-keygen.OPCPrivateKey["private_key_pem"]
  bastion_host             = join("", module.bastion-compute.publicIp)
  assign_public_ip         = local.assign_weblogic_public_ip
  use_regional_subnet      = local.use_regional_subnet
  service_gateway_id       = module.network-vcn-config.wls_service_gateway_services_id
  defined_tags             = local.defined_tags
  freeform_tags            = local.freeform_tags
}

/* Create back end  private subnet for wls */
module "network-wls-private-subnet" {
  source              = "./modules/network/subnet"
  service_name_prefix = local.service_name_prefix
  compartment_ocid    = local.network_compartment_id
  subnet_compartment_id    = local.subnet_compartment_id
  tenancy_ocid        = var.tenancy_ocid
  vcn_id              = module.network-vcn.VcnID
  security_list_id = compact(
    concat(
      module.network-vcn-config.wls_bastion_security_list_id,
      module.network-vcn-config.wls_private_endpoint_security_list_id,
      module.network-vcn-config.wls_internal_security_list_id,
      module.network-vcn-config.wls_lb_security-list_1_id,
      module.network-vcn-config.wls_lb_security_list_2_id,
    ),
  )
  dhcp_options_id     = module.network-vcn-config.dhcp_options_id
  route_table_id      = module.network-vcn-config.service_gateway_route_table_id
  subnet_name         = "${local.service_name_prefix}-${var.wls_subnet_name}"
  dns_label           = substr("subpvt${local.service_name_prefix}",0,14)
  cidr_block          = local.wls_subnet_cidr
  availability_domain = local.wls_availability_domain
  is_vcn_peered       = module.network-dns-vms.is_vcn_peered ? "true" : "false"
  subnetCount         = (!local.assign_weblogic_public_ip && var.wls_subnet_id == "")?1:0
  subnet_id           = var.wls_subnet_id
  prohibit_public_ip  = "true"
  use_regional_subnet = local.use_regional_subnet
  defined_tags        = local.defined_tags
  freeform_tags       = local.freeform_tags
}

/* Create back end  public subnet for wls */
module "network-wls-public-subnet" {
  source              = "./modules/network/subnet"
  service_name_prefix = local.service_name_prefix
  compartment_ocid    = local.network_compartment_id
  subnet_compartment_id    = local.subnet_compartment_id
  tenancy_ocid        = var.tenancy_ocid
  vcn_id              = module.network-vcn.VcnID
  security_list_id = compact(
    concat(
      module.network-vcn-config.wls_security_list_id,
      module.network-vcn-config.wls_ms_security_list_id,
      module.network-vcn-config.wls_internal_security_list_id,
      module.network-vcn-config.wls_lb_security-list_1_id,
      module.network-vcn-config.wls_lb_security_list_2_id,
    ),
  )
  dhcp_options_id      = module.network-vcn-config.dhcp_options_id
  route_table_id       = module.network-vcn-config.route_table_id[0]
  subnet_name          = "${local.service_name_prefix}-${var.wls_subnet_name}"
  dns_label            = substr("subpub${local.service_name_prefix}",0,14)
  cidr_block           = local.wls_subnet_cidr
  availability_domain  = local.wls_availability_domain
  is_vcn_peered        = module.network-dns-vms.is_vcn_peered ? "true" : "false"
  subnetCount          = (local.assign_weblogic_public_ip && var.wls_subnet_id == "")?1:0
  subnet_id            = var.wls_subnet_id
  prohibit_public_ip   = "false"
  use_regional_subnet  = local.use_regional_subnet
  defined_tags         = local.defined_tags
  freeform_tags        = local.freeform_tags
}

module "private-endpoint"{
  source = "./modules/private-endpoint"
  compartment_ocid                = var.private_endpoint_compartment_id
  vcn_id                          = module.network-vcn.VcnID
  private_endpoint_subnet_id      = element(module.network-private-endpoint-subnet.subnet_id,0)
  use_private_endpoint            = local.use_private_endpoint
  use_existing_private_endpoint   = local.use_existing_private_endpoint
  service_name_prefix  = substr(local.service_name_prefix,0,8)
//  private_endpoint_display_name   = var.private_endpoint_name
  private_endpoint_id             = var.private_endpoint_id
  use_nsg                         = var.use_private_endpoint_nsg
  nsg_compartment_id              = var.private_endpoint_nsg_compartment_id
  nsg_id                          = var.private_endpoint_nsg_id
  defined_tags       = local.defined_tags
  freeform_tags      = local.freeform_tags
}

module "file-storage"{
  source = "./modules/file-storage"
  mount_target_compartment_ocid                = var.mount_target_compartment_id
  file_system_compartment_ocid                = var.file_system_compartment_id
  service_name_prefix  = substr(local.service_name_prefix,0,8)
  vcn_id                          = module.network-vcn.VcnID
  mount_target_subnet_id      = element(module.network-mount-target-subnet.subnet_id,0)
  use_file_storage            = local.use_file_storage
  use_existing_mount_target   = local.use_existing_mount_target
  use_existing_file_system   = local.use_existing_file_system
//  mount_target_display_name   = var.mount_target_name
//  file_system_display_name   = var.file_system_name
  file_storage_availability_domain  = var.file_storage_availability_domain
  mount_target_ocid             = var.mount_target_ocid
  file_system_ocid             = var.file_system_ocid
  use_nsg                         = var.use_mount_target_nsg
  nsg_compartment_id              = var.mount_target_nsg_compartment_id
  nsg_id                          = var.mount_target_nsg_id
  defined_tags       = local.defined_tags
  freeform_tags      = local.freeform_tags
}

module "atpdb" {
  source = "./modules/db/atp"
  tenancy_ocid                    = var.tenancy_ocid
  compartment_ocid                = local.compartment_ocid
  service_name_prefix   		  = substr(local.service_name_prefix,0,8)
  atp_db_wallet_password          = local.wls_admin_password
  atp_db_password                 = local.wls_admin_password
  atp_db_name                     = var.atp_db_name
  atp_db_license_model            = var.atp_db_license_model
  atp_db_workload                 = var.atp_db_workload
  atp_db_display_name             = var.atp_db_display_name
  atp_db_is_dedicated             = var.atp_db_is_dedicated
  subnet_id            			  = var.wls_subnet_id
  is_quickstart               = var.is_quickstart
  defined_tags       = local.defined_tags
  freeform_tags      = local.freeform_tags
}

module "compute" {
  source              = "./modules/compute/instance"
  tf_script_version   = file(local.tf_version_file)
  tenancy_ocid        = var.tenancy_ocid
  compartment_ocid    = local.compartment_ocid
  use_soa_nsg              = var.use_soa_nsg
  soa_nsg_compartment_id   = var.soa_nsg_compartment_id
  soa_nsg_id               = var.soa_nsg_id
  instance_image_ocid = var.instance_image_id
  numVMInstances      = local.numVMInstances
  is_scaling          = local.is_scaling
  scaleout_copy_binaries = var.scaleout_copy_binaries
  availability_domain = local.wls_availability_domain
  subnet_ocid = local.assign_weblogic_public_ip?element(module.network-wls-public-subnet.subnet_id,0):element(module.network-wls-private-subnet.subnet_id,0)
  wls_subnet_id            = var.wls_subnet_id
  region                    = var.region
  use_regional_subnet  = local.use_regional_subnet
  ssh_public_key            = var.ssh_public_key
  instance_shape            = local.instance_shape
  flex_ocpus                = local.flex_ocpus
  flex_memory               = local.flex_memory
  enable_secure_boot        = var.enable_secure_boot
  enable_measured_boot      = local.enable_measured_boot
  volume_size               = var.volume_size
  wls_admin_user            = var.wls_admin_user
  wls_domain_name           = var.custom_domain_name == "" ? format("%s_domain", local.service_name_prefix) : var.custom_domain_name
  wls_admin_password        = local.wls_admin_password
  use_custom_nm_password    = var.use_custom_nm_password
  wls_nm_password           = local.wls_nm_password
  compute_name_prefix       = local.service_name_prefix
  wls_nm_port               = var.wls_nm_port
  wls_ms_server_name        = var.custom_managedserver_prefix == "" ? format("%s_server_", local.service_name_prefix) : var.custom_managedserver_prefix
  wls_admin_server_name     = var.custom_adminserver_name == "" ? format("%s_adminserver", local.service_name_prefix) : var.custom_adminserver_name
  wls_coherence_cluster_port               = var.wls_coherence_cluster_port
  wls_ms_port               = var.wls_ms_port
  wls_ms_ssl_port           = var.wls_ms_ssl_port
  wls_cluster_name          = var.custom_cluster_name == "" ? format("%s_cluster", local.service_name_prefix) : var.custom_cluster_name
  wls_machine_name          = var.custom_machinename_prefix == "" ? format("%s_machine_", local.service_name_prefix) : var.custom_machinename_prefix
  wls_extern_admin_port     = var.wls_extern_admin_port
  wls_extern_ssl_admin_port = var.wls_extern_ssl_admin_port
  wls_console_port          = var.wls_console_port
  wls_console_ssl_port      = var.wls_console_ssl_port
  wls_edition               = var.wls_edition
  is_idcs_selected          = var.is_idcs_selected
  idcs_host                 = var.idcs_host
  idcs_port                 = var.idcs_port
  idcs_tenant               = var.idcs_tenant
  idcs_client_id            = var.idcs_client_id
  idcs_cloudgate_port       = var.idcs_cloudgate_port
  idcs_app_prefix           = local.service_name_prefix
  is_quickstart             = var.is_quickstart

  // DB params - to generate a connect string from the params
  db_user     = local.db_user
  db_password = local.db_password

  // OCI DB params
  ocidb_compartment_id   = var.ocidb_compartment_id
  ocidb_database_id      = var.ocidb_database_id
  ocidb_dbsystem_id      = trimspace(var.ocidb_dbsystem_id)
  ocidb_pdb_service_name = var.ocidb_pdb_service_name
  ocidb_db_port          = var.oci_db_port

  // ATP DB params
  atp_db_level = local.atp_db_level
  atp_db_id    = var.is_quickstart ? module.atpdb.autonomous_database_id : trimspace(var.atp_db_id)

  // Exadata DB Params
  is_exa_db             = local.is_exa_db
  exa_scan_dns_name     = var.exa_scan_dns_name
#  is_exadata_version_11 = var.is_exadata_version_11
#  exa_db_unique_name    = var.exa_db_unique_name
  exa_pdb_service_name  = var.exa_pdb_service_name
  exa_host_domain_name  = local.exa_host_domain_name
  exa_db_port           = var.exa_db_port

  // ATP DB params
  is_adv_db             = local.is_adv_db
  adv_db_connectstring = var.adv_db_connectstring

  // Dev or Prod mode
  mode      = var.mode
  log_level = var.log_level

  deploy_sample_app = var.deploy_sample_app

  // WLS version and artifacts
  wls_version = var.wls_version

  //soacs Topologies
  topology                 = var.topology
  is_foh                   = var.is_foh
  use_schema_partitioning  = var.use_schema_partitioning
  use_custom_schema_prefix = var.use_custom_schema_prefix
  rcu_schema_prefix        = var.rcu_schema_prefix
  use_custom_schema_password = var.use_custom_schema_password

  // for VCN peering
  is_vcn_peered = module.network-dns-vms.is_vcn_peered ? "true" : "false"
  wls_dns_vm_ip = module.network-dns-vms.wls_dns_vm_private_ip


//File Storage
  use_file_storage     = local.use_file_storage
  mount_ip    = module.file-storage.mount_ip
  mount_path  = var.mount_path
  export_path = module.file-storage.export_path

  assign_public_ip   = local.assign_weblogic_public_ip
  opc_key            = module.compute-keygen.OPCPrivateKey
  oracle_key         = module.compute-keygen.OraclePrivateKey
  use_kms_decryption = var.use_kms_decryption
  wls_admin_password_ocid = var.wls_kms_admin_password_ocid
  wls_nm_password_ocid = var.wls_kms_nm_password_ocid
  db_password_ocid = local.db_kms_password_ocid
  rcu_schema_password_ocid = var.rcu_kms_schema_password_ocid
  idcs_client_secret_ocid = var.idcs_client_secret
  use_custom_atp_db_wallet_password = var.use_custom_atp_db_wallet_password
  atp_db_wallet_password_ocid = var.atp_kms_db_wallet_password_ocid
  use_backup_restore = var.use_backup_restore
  kms_vault_ocid = var.kms_vault_ocid
  kms_key_ocid = var.kms_key_ocid
  backup_obj_storage_bucket = var.backup_obj_storage_bucket
  lb_use_https       = var.lb_use_https
  skip_domain_creation = var.skip_domain_creation
  defined_tags       = local.defined_tags
  freeform_tags      = local.freeform_tags
}


module "policies" {
  source = "./modules/policies"

  tenancy_id      = var.tenancy_ocid
  compartment_id  = local.compartment_ocid
  label_prefix    = local.service_name_prefix
  create_policies = local.create_policies
  providers = {
    oci = oci.home
  }
  wls_admin_password_ocid        = var.wls_kms_admin_password_ocid
  wls_nm_password_ocid           = var.wls_kms_nm_password_ocid
  rcu_schema_password_ocid       = var.rcu_kms_schema_password_ocid
  db_password_ocid               = local.db_kms_password_ocid
  idcs_client_secret_ocid        = var.idcs_client_secret
  atp_db_wallet_password_ocid    = var.atp_kms_db_wallet_password_ocid
  instance_ocids                 = compact(module.compute.InstanceOcids)
  use_backup_restore = var.use_backup_restore
  kms_vault_ocid = var.kms_vault_ocid
  kms_key_ocid = var.kms_key_ocid
  backup_obj_storage_bucket = var.backup_obj_storage_bucket
  
  defined_tags       = local.defined_tags
  freeform_tags      = local.freeform_tags
}

module "lb" {
  source = "./modules/lb"

  add_load_balancer = var.add_load_balancer
  compartment_ocid  = local.lb_compartment_id
  tenancy_ocid      = var.tenancy_ocid
  load_balancer_strategy = var.load_balancer_strategy
  existing_load_balancer = var.existing_load_balancer
  topology = var.topology
  subnet_ocids = compact(
    concat(
      compact(module.network-lb-subnet-1.subnet_id),
      compact(module.network-lb-subnet-2.subnet_id),
    ),
  )
  use_lb_nsg              = var.use_lb_nsg
  lb_nsg_compartment_id   = var.lb_nsg_compartment_id
  lb_nsg_id               = var.lb_nsg_id
  instance_private_ips    = module.compute.InstancePrivateIPs
  wls_ms_port             = var.wls_ms_port
  numVMInstances          = local.numVMInstances
  name                    = "${local.service_name_prefix}-lb"
  sslCertificateName      = "${local.service_name_prefix}-lb-democert"
  lb_backendset_name      = "${local.service_name_prefix}-lb-backendset"
  shape                   = var.lb_shape
  min_shape               = var.lb_flex_min_shape
  max_shape               = var.lb_flex_max_shape
  use-https               = var.lb_use_https
  is_idcs_selected        = var.is_idcs_selected
  idcs_cloudgate_port     = var.idcs_cloudgate_port
/*  lbr_ssl_cert            = local.lbr_ssl_cert
  lbr_ssl_pub_key         = local.lbr_ssl_pub_key
  lbr_ssl_pvt_key         = local.lbr_ssl_pvt_key */
  is_private_loadbalancer = var.lb_subnet_type == "Use Public Subnet" ? false : true
  defined_tags            = local.defined_tags
  freeform_tags           = local.freeform_tags
}

module "provisioners" {
  source = "./modules/provisioners"

  ssh_private_key = module.compute-keygen.OPCPrivateKey["private_key_pem"]
  host_ips = coalescelist(
    compact(module.compute.InstancePublicIPs),
    compact(module.compute.InstancePrivateIPs),
  )
  admin_ip                 = coalesce(module.compute.PublicAdminIP, module.compute.PrivateAdminIP)
  numVMInstances           = local.numVMInstances
  volumeAttachmentInfo     = module.compute.VolumeAttachmentInfo
  is_atp_db                = local.is_atp_db ? "true" : "false"
  atp_db_id                = var.is_quickstart ? module.atpdb.autonomous_database_id : var.atp_db_id
  wls_admin_password       = local.wls_admin_password
  wls_nm_password          = local.wls_nm_password
  db_password              = local.db_password
  rcu_schema_password      = local.rcu_schema_password
  mode                     = var.mode
  use_private_endpoint     = local.use_private_endpoint
  private_endpoint_id      = module.private-endpoint.private_endpoint_id
  bastion_host_private_key = local.use_existing_bastion?var.bastion_ssh_pvt_key:module.compute-keygen.OPCPrivateKey["private_key_pem"]
  bastion_host             = local.use_existing_bastion?var.bastion_public_ip:join("", module.bastion-compute.publicIp)
  assign_public_ip         = local.assign_weblogic_public_ip
  oracle_key               = module.compute-keygen.OraclePrivateKey
  use_kms_decryption       = var.use_kms_decryption
  use_custom_atp_db_wallet_password = var.use_custom_atp_db_wallet_password
  atp_db_wallet_password   = var.is_quickstart ? local.wls_admin_password : local.atp_db_wallet_password
  instance_ids             = module.compute.InstanceOcids
  add_load_balancer        = var.add_load_balancer
  lb_public_ip             = flatten(module.lb.lb_public_ip[0])
  idcs_client_secret       = var.idcs_client_secret
  policy_module            = module.policies
  skip_domain_creation     = var.skip_domain_creation
}
