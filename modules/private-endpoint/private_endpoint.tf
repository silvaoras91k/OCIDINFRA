
// The RMS private endpoint resource. Requires a VCN with a private subnet
resource "oci_resourcemanager_private_endpoint" "private_endpoint" {
  count = (var.use_private_endpoint && !var.use_existing_private_endpoint)?1:0
  compartment_id = var.compartment_ocid
  display_name   = "${var.service_name_prefix}-pvtEndpoint"
  description    = "Private Endpoint to remote-exec in Private Instance"
  vcn_id         = var.vcn_id
  subnet_id      = var.private_endpoint_subnet_id
  nsg_id_list = var.use_nsg ? tolist([var.nsg_id]) : []
  defined_tags = var.defined_tags
  freeform_tags = var.freeform_tags
}
