/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */

output "autonomous_database_id" {
    value = length(oci_database_autonomous_database.autonomous_database) == 0 ? "null" : oci_database_autonomous_database.autonomous_database[0].id
}
