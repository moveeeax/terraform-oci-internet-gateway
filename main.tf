resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = var.display_name
  enabled        = var.enabled
  route_table_id = var.route_table_id

  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags
}
