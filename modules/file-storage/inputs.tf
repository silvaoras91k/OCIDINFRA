variable "file_system_compartment_ocid" {
  default = ""
}

variable "mount_target_compartment_ocid" {
  default = ""
}

variable "vcn_id" {
  default = ""
}

variable "service_name_prefix" {
  default = ""
}

variable "mount_target_subnet_id" {
  default = ""
}

variable "use_file_storage" {
    default="false"
}

variable "use_existing_mount_target" {
    default="true"
}

variable "use_existing_file_system" {
    default="false"
}

//variable "mount_target_display_name" {
//  default = ""
//}

//variable "file_system_display_name" {
//  default = ""
//}

variable "file_storage_availability_domain" {
  default = ""
}

variable "mount_target_ocid" {
  default = ""
}

variable "file_system_ocid" {
  default = ""
}

variable "use_nsg" {
  default = "false"
}

variable "nsg_compartment_id" {
  default = ""
}

variable "nsg_id" {
  default = ""
}

variable "defined_tags" {
  type    = map(string)
  default = {}
}

variable "freeform_tags" {
  type    = map(string)
  default = {}
}
