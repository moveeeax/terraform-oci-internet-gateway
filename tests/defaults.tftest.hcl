# Requires Terraform >= 1.7 for mock_provider (test-only; the module itself still
# supports >= 1.5). Runs with no OCI credentials and no network access.

mock_provider "oci" {}

variables {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaexamplecompartment"
  vcn_id         = "ocid1.vcn.oc1.phx.aaaaaaaaexamplevcn"
  display_name   = "test-igw"
}

run "gateway_is_enabled_by_default" {
  assert {
    condition     = oci_core_internet_gateway.this.enabled == true
    error_message = "Internet gateway must default to enabled; a disabled gateway applies cleanly but blackholes all traffic."
  }
}

# Asserted on the input rather than the resource attribute: route_table_id is
# Optional+Computed, so both a real apply and the mock provider return a
# server-assigned value once the gateway exists.
run "route_table_defaults_to_vcn_default" {
  command = plan

  assert {
    condition     = var.route_table_id == null
    error_message = "route_table_id must default to null so the VCN default ingress route table is used."
  }
}

run "required_inputs_are_passed_through" {
  assert {
    condition     = oci_core_internet_gateway.this.compartment_id == var.compartment_id
    error_message = "compartment_id must be passed through to the gateway unchanged."
  }

  assert {
    condition     = oci_core_internet_gateway.this.vcn_id == var.vcn_id
    error_message = "vcn_id must be passed through to the gateway unchanged."
  }

  assert {
    condition     = oci_core_internet_gateway.this.display_name == var.display_name
    error_message = "display_name must be passed through to the gateway unchanged."
  }
}

run "explicit_route_table_is_honoured" {
  variables {
    route_table_id = "ocid1.routetable.oc1.phx.aaaaaaaaexampleroutetable"
  }

  assert {
    condition     = oci_core_internet_gateway.this.route_table_id == "ocid1.routetable.oc1.phx.aaaaaaaaexampleroutetable"
    error_message = "An explicit route_table_id must be set on the gateway."
  }
}

run "gateway_can_be_created_disabled_when_asked" {
  variables {
    enabled = false
  }

  assert {
    condition     = oci_core_internet_gateway.this.enabled == false
    error_message = "enabled = false must be honoured for staged cutovers."
  }
}

run "tenancy_ocid_is_accepted_as_root_compartment" {
  variables {
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaaexampletenancy"
  }

  assert {
    condition     = oci_core_internet_gateway.this.compartment_id == "ocid1.tenancy.oc1..aaaaaaaaexampletenancy"
    error_message = "The tenancy OCID must be accepted as the root compartment."
  }
}

run "rejects_non_compartment_ocid" {
  command = plan

  variables {
    compartment_id = "ocid1.vcn.oc1.phx.aaaaaaaaexamplevcn"
  }

  expect_failures = [var.compartment_id]
}

run "rejects_non_vcn_ocid" {
  command = plan

  variables {
    vcn_id = "ocid1.compartment.oc1..aaaaaaaaexamplecompartment"
  }

  expect_failures = [var.vcn_id]
}

run "rejects_free_text_compartment_id" {
  command = plan

  variables {
    compartment_id = "my-compartment"
  }

  expect_failures = [var.compartment_id]
}

run "rejects_non_route_table_ocid" {
  command = plan

  variables {
    route_table_id = "ocid1.vcn.oc1.phx.aaaaaaaaexamplevcn"
  }

  expect_failures = [var.route_table_id]
}

run "rejects_empty_display_name" {
  command = plan

  variables {
    display_name = ""
  }

  expect_failures = [var.display_name]
}
