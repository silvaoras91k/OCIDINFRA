variable "marketplace_source_images" {
  type = map(object({
    ocid = string
    is_pricing_associated = bool
    compatible_shapes = set(string)
  }))
  default = {
    main_mktpl_image = {
      ocid = "ocid1.image.oc1..aaaaaaaapjjfhd3eemdvfefwz5ipr56jsic4e3mdrcekf25jhbafjrgd5h3a"
      is_pricing_associated = false
      compatible_shapes = []
    }
  }
}
