variable "use_email_notification" {
  default = "false"
}
variable "compartment_id" {
  default = ""
}

variable "ons_topic_strategy" {
  default = "Use Existing ONS Topic"
}

variable "ons_topic_ocid" {
  default = ""
}

#variable "ons_subscription_strategy" {
#  default = "Use Existing ONS Subscription"
#}

#variable "ons_subscription_ocid" {
#  default = ""
#}

variable "ons_subscription_emailid" {
  default = ""
}

variable "service_name_prefix" {
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