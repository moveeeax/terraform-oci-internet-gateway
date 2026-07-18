provider "oci" {}

module "internet_gateway" {
  source = "../.."

  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "example-igw"

  freeform_tags = {
    Environment = "sandbox"
    ManagedBy   = "terraform"
  }
}

variable "compartment_id" {
  description = "Compartment OCID to deploy the example internet gateway into."
  type        = string
}

variable "vcn_id" {
  description = "OCID of the VCN to attach the example internet gateway to."
  type        = string
}

output "internet_gateway_id" {
  value = module.internet_gateway.id
}
