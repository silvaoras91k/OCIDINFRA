# Copyright 2020, Oracle Corporation and/or affiliates.  All rights reserved.

output "soamp_secret-service-policy_id" {
  value = var.create_policies ? element(concat(oci_identity_policy.soamp_secret-service-policy[0].*.id, list("")),0) : ""
}
