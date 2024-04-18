/*
 * Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
 */
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # cloud-config configuration file.
  # /var/lib/cloud/instance/scripts/*

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.key_script.rendered
  }
  part {
    filename     = "init.sh"
    content_type = "text/x-shellscript"
    content      = file(var.bootStrapFile)
  }
  part {
    filename     = "boot.sh"
    content_type = "text/cloud-boothook"
    content      = file(var.rebootFile)
  }
}

