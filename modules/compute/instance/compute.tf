locals {

  host_label = "${var.compute_name_prefix}-${var.vnic_prefix}"
  db_nameList = coalescelist(
    data.oci_database_autonomous_database.atp_db.*.db_name,
    data.oci_database_database.ocidb_database.*.db_name,
    ["None"],
  )
  dbVersionList = coalescelist(
    data.oci_database_db_home.ocidb_db_home.*.db_version,
    data.oci_database_autonomous_database.atp_db.*.db_name,
    ["None"],
  )
  dbUniqueNameList = coalescelist(
    data.oci_database_database.ocidb_database.*.db_unique_name,
    data.oci_database_autonomous_database.atp_db.*.db_name,
    ["None"],
  )
  dbStorageManagementList = coalescelist(
    data.oci_database_db_systems.ocidb_db_systems.*.db_systems.0.db_system_options,
	[[{storage_management = "null"}]],
  )
  dbHostNameList = coalescelist(
    data.oci_database_db_systems.ocidb_db_systems.*.db_systems.0.hostname,
    data.oci_database_autonomous_database.atp_db.*.db_name,
    ["None"],
  )
  dbDomainList = coalescelist(
    data.oci_database_db_systems.ocidb_db_systems.*.db_systems.0.domain,
    data.oci_database_autonomous_database.atp_db.*.db_name,
    ["None"],
  )
  dbShapeList = coalescelist(
    data.oci_database_db_systems.ocidb_db_systems.*.db_systems.0.shape,
    data.oci_database_autonomous_database.atp_db.*.db_name,
    ["None"],
  )
  dbNodeCountList = coalescelist(
    data.oci_database_db_systems.ocidb_db_systems.*.db_systems.0.node_count,
    data.oci_database_autonomous_database.atp_db.*.db_name,
    ["None"],
  )
  is_atp_dedicated = coalescelist(
    data.oci_database_autonomous_database.atp_db.*.is_dedicated,
    data.oci_database_database.ocidb_database.*.db_name,
    ["None"],
  )
}

// WLS instance
resource "oci_core_instance" "wls-compute-instance" {
  count = var.numVMInstances

  availability_domain = var.use_regional_subnet?local.ad_names[count.index % length(local.ad_names)]:var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${local.host_label}-${count.index}"
  shape               = var.instance_shape

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags

  create_vnic_details {
    subnet_id        = var.subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = var.assign_public_ip
    hostname_label   = "${local.host_label}-${count.index}"
    nsg_ids = var.use_soa_nsg ? tolist([var.soa_nsg_id]) : []
  }

  shape_config {
    #Optional
    ocpus = length(regexall("^.*Flex", var.instance_shape)) == 0 ? lookup(data.oci_core_shapes.oci_shapes.shapes[0], "ocpus") : var.flex_ocpus

    memory_in_gbs = length(regexall("^.*Flex", var.instance_shape)) == 0 ? lookup(data.oci_core_shapes.oci_shapes.shapes[0], "memory_in_gbs") : var.flex_memory

    #ocpus = (var.instance_shape == "VM.Standard.E3.Flex" || var.instance_shape == "VM.Standard.E4.Flex" || var.instance_shape == "VM.Optimized3.Flex")  ? var.flex_ocpus : null
    #memory_in_gbs = (var.instance_shape == "VM.Standard.E3.Flex" || var.instance_shape == "VM.Standard.E4.Flex" || var.instance_shape == "VM.Optimized3.Flex")  ? var.flex_memory : null
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid
    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }

  platform_config {
    is_secure_boot_enabled = var.enable_secure_boot
    is_measured_boot_enabled = var.enable_measured_boot
    is_trusted_platform_module_enabled = var.enable_measured_boot
    type = data.oci_core_shapes.oci_shapes.shapes[0].platform_config_options[0].type
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true

  metadata = {
    service_name                       = var.compute_name_prefix
    tf_script_version                  = var.tf_script_version
    ssh_authorized_keys                = var.ssh_public_key
    wls_admin_user                     = var.wls_admin_user
    wls_domain_name                    = var.wls_domain_name
    is_admin_instance                  = count.index == 0 ? "true" : "false"
    wls_ext_admin_port                 = var.wls_extern_admin_port
    wls_secured_ext_admin_port         = var.wls_extern_ssl_admin_port
    wls_admin_port                     = var.wls_console_port
    wls_admin_ssl_port                 = var.wls_console_ssl_port
	use_custom_nm_password             = var.use_custom_nm_password
    wls_nm_port                        = var.wls_nm_port
    host_index                         = count.index
    wls_admin_host                     = "${local.host_label}-0"
    wls_admin_server_wait_timeout_mins = var.wls_admin_server_wait_timeout_mins
    wls_ms_ssl_port                    = var.wls_ms_ssl_port
    wls_ms_port                        = var.wls_ms_port
    wls_coherence_cluster_port                        = var.wls_coherence_cluster_port
    wls_ms_server_name                 = var.wls_ms_server_name
    wls_admin_server_name              = var.wls_admin_server_name
    wls_cluster_name                   = var.wls_cluster_name
    wls_cluster_mc_port                = var.wls_cluster_mc_port
    wls_machine_name                   = var.wls_machine_name
    total_vm_count                     = var.numVMInstances
    is_scaling                         = var.is_scaling
    scaleout_copy_binaries             = var.scaleout_copy_binaries
    wls_edition                        = var.wls_edition
    // OCI DB params
    db_is_oci_db = local.is_oci_db
    db_name      = local.db_nameList[0]
    db_user      = var.db_user
    db_port      = var.is_exa_db ? var.exa_db_port : var.ocidb_db_port
    // Exadata DB Params
    is_exa_db    = var.is_exa_db
    exa_scan_dns_name     = var.is_exa_db ? var.exa_scan_dns_name : ""
    //is_exadata_version_11 = var.is_exa_db ? var.is_exadata_version_11 : "false"
    // RCU params
    rcu_component_list = var.wls_version_to_rcu_component_list_map[var.wls_version]
    is_adv_db = var.is_adv_db
    //ATP DB Related params
    is_atp_db        = local.is_atp_db
    atp_db_level     = var.atp_db_level
    is_atp_dedicated = local.is_atp_db ? local.is_atp_dedicated[0] : ""
    //OCI DB Related Params
    db_hostname_prefix                 = local.is_oci_db ? local.dbHostNameList[0] : ""
	  db_storage_management              = local.is_oci_db ? (length(local.dbStorageManagementList[0])==0 ? "null": local.dbStorageManagementList[0][0].storage_management): ""
    db_host_domain                     = local.is_oci_db ? local.dbDomainList[0] : var.is_exa_db ? var.exa_host_domain_name : ""
    db_shape                           = local.is_oci_db ? local.dbShapeList[0] : ""
    db_version                         = local.is_oci_db ? local.dbVersionList[0] : ""
    db_unique_name                     = local.is_oci_db ? local.dbUniqueNameList[0] : ""
    pdb_name                           = local.is_oci_db ? var.ocidb_pdb_service_name : var.is_exa_db ? var.exa_pdb_service_name : ""
    db_connectstring                   = var.is_adv_db ? var.adv_db_connectstring : ""
    db_node_count                      = local.is_oci_db ? local.dbNodeCountList[0] : ""
    user_data                          = data.template_cloudinit_config.config.rendered
    mode                               = var.mode
    wls_version                        = var.wls_version
    topology                           = var.topology
    is_foh                             = var.is_foh
    use_schema_partitioning            = var.use_schema_partitioning
    use_custom_schema_prefix           = var.use_custom_schema_prefix
    rcu_schema_prefix                  = var.rcu_schema_prefix
    use_custom_schema_password         = var.use_custom_schema_password
    fmiddleware_zip                    = var.wls_version_to_fmw_map[var.wls_version]
    jdk_zip                            = var.wls_version_to_jdk_map[var.wls_version]
    vmscripts_path                     = var.vmscripts_path
    creds_path                         = var.creds_path
    log_level                          = var.log_level
    data_vol_mount_point               = var.data_volume_map["data_volume_mount_point"]
    device                             = var.data_volume_map["device"]
    deploy_sample_app                  = var.deploy_sample_app
    volume_info_file                   = var.volume_info_file
    domain_dir                         = var.domain_dir
    logs_dir                           = var.logs_dir
    apply_JRF                          = "true"
    status_check_timeout_duration_secs = var.status_check_timeout_duration_secs
    // For VCN peering
    is_vcn_peered      = var.is_vcn_peered
    use_kms_decryption = var.use_kms_decryption
    wls_admin_password_ocid = var.wls_admin_password_ocid
    wls_nm_password_ocid = var.wls_nm_password_ocid
    db_password_ocid = var.db_password_ocid
    rcu_schema_password_ocid = var.rcu_schema_password_ocid
    idcs_client_secret_ocid = var.idcs_client_secret_ocid
    use_custom_atp_db_wallet_password = var.use_custom_atp_db_wallet_password
    atp_db_wallet_password_ocid = var.atp_db_wallet_password_ocid
    use_backup_restore = var.use_backup_restore
    kms_vault_ocid = var.kms_vault_ocid
    kms_key_ocid = var.kms_key_ocid
    obj_storage_bucket = var.backup_obj_storage_bucket
    atp_db_id          = var.atp_db_id
    // For File STorage
    use_fss     = var.use_file_storage
    fss_mount_ip         = var.mount_ip
    fss_mount_path       = var.mount_path
    fss_mount_directio_path       = var.mount_directio_path
    fss_export_path      = var.export_path
    // For IDCS
    is_idcs_selected                    = var.is_idcs_selected
    idcs_host                           = var.idcs_host
    idcs_port                           = var.idcs_port
    is_idcs_internal                    = var.is_idcs_internal
    is_idcs_untrusted                   = var.is_idcs_untrusted
    idcs_ip                             = var.idcs_ip
    idcs_tenant                         = var.idcs_tenant
    idcs_client_id                      = var.idcs_client_id
    idcs_app_prefix                     = var.idcs_app_prefix
    idcs_cloudgate_port                 = var.idcs_cloudgate_port
    idcs_conf_app_info_file             = var.idcs_conf_app_info_file
    idcs_ent_app_info_file              = var.idcs_ent_app_info_file
    idcs_cloudgate_info_file            = var.idcs_cloudgate_info_file
    idcs_cloudgate_config_file          = var.idcs_cloudgate_config_file
    lbip_filepath                       = var.lbip_filepath
    idcs_cloudgate_docker_image_tar     = var.idcs_cloudgate_docker_image_tar
    idcs_cloudgate_docker_image_version = var.idcs_cloudgate_docker_image_version
    idcs_cloudgate_docker_image_name    = var.idcs_cloudgate_docker_image_name
    lb_use_https                        = var.lb_use_https
    skip_domain_creation                = var.skip_domain_creation
  }
  fault_domain = data.oci_identity_fault_domains.wls_fault_domains.fault_domains[(count.index + 1) % local.num_fault_domains]["name"]
  timeouts {
    create = "${var.provisioning_timeout_mins}m"
  }
}
