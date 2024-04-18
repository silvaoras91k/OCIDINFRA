
// Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "private_endpoint_id" {
  description = "The ocid of the created private endpoint."
  value       = var.use_private_endpoint && var.private_endpoint_id == "" ? oci_resourcemanager_private_endpoint.private_endpoint[0].id : var.private_endpoint_id
}
