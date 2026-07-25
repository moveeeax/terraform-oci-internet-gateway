variable "compartment_id" {
  description = "OCID of the compartment in which to create the internet gateway. The tenancy OCID is accepted for the root compartment."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.(compartment|tenancy)\\.", var.compartment_id))
    error_message = "compartment_id must be a compartment or tenancy OCID (starting with \"ocid1.compartment.\" or \"ocid1.tenancy.\")."
  }
}

variable "vcn_id" {
  description = "OCID of the VCN the internet gateway belongs to."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.vcn\\.", var.vcn_id))
    error_message = "vcn_id must be a VCN OCID (starting with \"ocid1.vcn.\")."
  }
}

variable "display_name" {
  description = "Human-readable name for the internet gateway."
  type        = string

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 255
    error_message = "display_name must be between 1 and 255 characters."
  }
}

variable "enabled" {
  description = <<-EOT
    Whether the internet gateway passes traffic. Defaults to true: a gateway created
    with enabled = false applies cleanly but silently blackholes traffic. Enabling the
    gateway does not by itself expose anything, since a subnet only reaches the internet
    once a route rule targets this gateway and security rules permit the traffic.
  EOT
  type        = bool
  default     = true
}

variable "route_table_id" {
  description = <<-EOT
    OCID of the VCN ingress route table that routes traffic arriving through this gateway
    (used for transit routing). This is not the route table that gives subnets outbound
    internet access — that is a subnet route rule targeting this gateway's OCID. Null uses
    the VCN default route table.
  EOT
  type        = string
  default     = null

  validation {
    condition     = var.route_table_id == null || can(regex("^ocid1\\.routetable\\.", var.route_table_id))
    error_message = "route_table_id must be null or a route table OCID (starting with \"ocid1.routetable.\")."
  }
}

variable "freeform_tags" {
  description = "Free-form tags applied to the internet gateway."
  type        = map(string)
  default     = {}
}

variable "defined_tags" {
  description = "Defined tags applied to the internet gateway, keyed as \"namespace.key\"."
  type        = map(string)
  default     = {}
}
