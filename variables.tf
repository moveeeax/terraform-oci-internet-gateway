variable "compartment_id" {
  description = "OCID of the compartment in which to create the internet gateway."
  type        = string
}

variable "vcn_id" {
  description = "OCID of the VCN the internet gateway belongs to."
  type        = string
}

variable "display_name" {
  description = "Human-readable name for the internet gateway."
  type        = string
}

variable "enabled" {
  description = "Whether the internet gateway is enabled and passing traffic."
  type        = bool
  default     = true
}

variable "route_table_id" {
  description = "OCID of the route table the gateway uses. Null uses the VCN default."
  type        = string
  default     = null
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
