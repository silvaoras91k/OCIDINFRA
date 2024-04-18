locals {

  create_ons_topic = var.ons_topic_strategy == "Create New ONS Topic" ? true : false
}

resource "oci_ons_notification_topic" "soamp_notification_topic" {
    count = var.use_email_notification && local.create_ons_topic ? 1:0

    compartment_id = var.compartment_id
    name = "${var.service_name_prefix}_topic"

    description = "SOA Marketplace Stack Notification Topic"

    #Optional
    defined_tags  = var.defined_tags
    freeform_tags = var.freeform_tags
}

resource "oci_ons_subscription" "soamp_subscription" {
    count = var.use_email_notification && local.create_ons_topic ? 1:0
    compartment_id = var.compartment_id
    endpoint = var.ons_subscription_emailid
    protocol = "EMAIL"
    topic_id = oci_ons_notification_topic.soamp_notification_topic[0].id

    #Optional
    defined_tags  = var.defined_tags
    freeform_tags = var.freeform_tags

}

resource "oci_events_rule" "soamp_event_rule" {
    count = var.use_email_notification ? 1:0
    actions {
        #Required
        actions {
            #Required
            action_type = "ONS"
            is_enabled = true

            description = "Send email notification on SOA MP Stack job completion"
            topic_id = local.create_ons_topic ? oci_ons_notification_topic.soamp_notification_topic[0].id : var.ons_topic_ocid
        }
    }
    compartment_id = var.compartment_id
    condition = "{\"eventType\": \"com.oraclecloud.oracleresourcemanager.createjob.end\"}"
    display_name = "${var.service_name_prefix}_StackJobRule"
    is_enabled = true
    #Optional
    defined_tags  = var.defined_tags
    freeform_tags = var.freeform_tags
}
