/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */
# Output the private and public IPs of the instance
locals {
  admin_ip_address = local.assign_weblogic_public_ip?module.compute.InstancePublicIPs[0]:module.compute.InstancePrivateIPs[0]
  admin_console_app_url = format("https://%s:%s/console",local.admin_ip_address,var.wls_extern_ssl_admin_port)
  fmw_console_app_url = local.requires_JRF?format("https://%s:%s/em",local.admin_ip_address,var.wls_extern_ssl_admin_port,):""

  osb_console_app_url = var.topology == "SOA with SB & B2B Cluster" ? format("https://%s:%s/servicebus",local.admin_ip_address,var.wls_extern_ssl_admin_port) : "N/A"

  sample_app_protocol = (var.add_load_balancer && var.lb_use_https)?"https":(!var.add_load_balancer)?"https":"http"
  
  sample_app_host_port = var.add_load_balancer ? element(module.lb.lb_public_ip[0], 0) : format("%s:%s",local.admin_ip_address,var.wls_ms_ssl_port)

  soa_composer_app_url = var.topology == "SOA with SB & B2B Cluster" ? format("%s://%s/soa/composer",local.sample_app_protocol,local.sample_app_host_port) : "N/A"

  b2b_console_app_url = var.topology == "SOA with SB & B2B Cluster" ? format("%s://%s/b2bconsole",local.sample_app_protocol,local.sample_app_host_port) : "N/A"

  worklist_app_url = var.topology == "SOA with SB & B2B Cluster" ? format("%s://%s/integration/worklistapp",local.sample_app_protocol,local.sample_app_host_port) : "N/A"

  mft_console_app_url = var.topology == "MFT Cluster" ? format("%s://%s/mftconsole",local.sample_app_protocol,local.sample_app_host_port) : "N/A"

  service_type = var.topology == "SOA with SB & B2B Cluster" ? "SOA with SB & B2B Cluster" : (var.topology == "MFT Cluster" ? "MFT Cluster" : "BAM Cluster")

  stack_version = file("${path.root}/version.txt")

  database_ocid = local.is_oci_db ? var.ocidb_dbsystem_id : (local.is_atp_db ? var.atp_db_id : (local.is_exa_db ? format("//%s:%s/%s",var.exa_scan_dns_name, var.exa_db_port, var.exa_pdb_service_name ) : (local.is_adv_db ? var.adv_db_connectstring : "")))

  loadbalancer_ocid = var.add_load_balancer ? module.lb.lb_ocid : "N/A"

}


output "Loadbalancer_Ocid" {
  value = local.loadbalancer_ocid
}

output "Service_Instances" {
  value = join(" ", formatlist(
    "{\n       Instance Id   :%s,   \n       Instance name :%s,   \n       Private IP    :%s,   \n       Public IP     :%s\n}",
    module.compute.InstanceOcids,
    module.compute.display_names,
    module.compute.InstancePrivateIPs,
    module.compute.InstancePublicIPs,
  ))
}

output "Service_Type" {
  value = local.service_type
}
output "SOAMP_Stack_Version" {
  value = local.stack_version
}

output "Weblogic_Administration_Console" {
  value = local.admin_console_app_url
}

output "Enterprise_Manager_Console" {
  value = local.fmw_console_app_url
}

output "SOA_Composer_Console" {
  value = local.soa_composer_app_url
}

output "B2B_Console" {
  value = local.b2b_console_app_url
}

output "OSB_Console" {
  value = local.osb_console_app_url
}

output "Worklist_Application_Console" {
  value = local.worklist_app_url
}

output "MFT_Console" {
  value = local.mft_console_app_url
}

output "DB_Connection" {
  value = local.database_ocid
}

output "SOAMP_Cluster_Size" {
  value = local.numVMInstances
}