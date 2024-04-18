/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */


data "oci_database_autonomous_db_versions" "atp_db_versions" {
    count = var.is_quickstart?1:0
    #Required
    compartment_id = var.compartment_ocid

	#Optional
    db_workload = var.atp_db_workload
}

resource "oci_database_autonomous_database" "autonomous_database" {
    count = var.is_quickstart?1:0
    #Required
    admin_password           					   = var.atp_db_password
    compartment_id           					   = var.compartment_ocid
    cpu_core_count           					   = "1"
    data_storage_size_in_tbs 					   = "1"
    db_name                 					   = "${var.service_name_prefix}${var.atp_db_name}"

    #Optional
    db_version                                     = data.oci_database_autonomous_db_versions.atp_db_versions[0].autonomous_db_versions.0.version
    db_workload                                    = var.atp_db_workload
    display_name                                   = "${var.service_name_prefix}${var.atp_db_display_name}"
    is_auto_scaling_enabled                        = "true"
    license_model                                  = var.atp_db_license_model
    is_preview_version_with_service_terms_accepted = "false"
    #Optional
    defined_tags  = var.defined_tags
    freeform_tags = var.freeform_tags
}


data "oci_database_autonomous_databases" "autonomous_databases" {
    count = var.is_quickstart?1:0
    #Required
    compartment_id = var.compartment_ocid

    #Optional
    display_name = oci_database_autonomous_database.autonomous_database[0].display_name
    db_workload  = var.atp_db_workload
}

resource "oci_database_autonomous_database_wallet" "autonomous_database_wallet" {
    count = var.is_quickstart?1:0
    autonomous_database_id = oci_database_autonomous_database.autonomous_database[0].id
    password               = var.atp_db_wallet_password
    base64_encode_content  = "true"
}
