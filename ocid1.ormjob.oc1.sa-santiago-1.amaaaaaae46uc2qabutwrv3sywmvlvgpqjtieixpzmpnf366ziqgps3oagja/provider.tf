/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */


provider "oci" {
  version          = "~> 4.86"
  region           = var.region
}

provider "oci" {
  version = "~> 4.86"
  alias   = "home"
  region  = local.home_region
}

#provider "tls" {
#  version = "~>2.0"
#}

#provider "null" {
#  version = "~>2.1"
#}

#provider "template" {
#  version = "~>2.1"
#}
