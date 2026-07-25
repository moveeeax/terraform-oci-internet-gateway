# terraform-oci-internet-gateway

Terraform module that manages an [Oracle Cloud Infrastructure](https://www.oracle.com/cloud/)
internet gateway inside an existing VCN, giving public subnets bidirectional access to
the internet.

## Usage

```hcl
module "internet_gateway" {
  source = "github.com/moveeeax/terraform-oci-internet-gateway"

  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "prod-igw"

  freeform_tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

A runnable example lives in [`examples/basic`](examples/basic).

## Reaching the internet

Creating this gateway does not by itself make anything reachable. A subnet gets internet
access only once **both** of the following are true, and neither is managed by this module:

1. A route rule in the subnet's route table sends `0.0.0.0/0` to this gateway's OCID
   (available as the `id` output).
2. The subnet's security lists or NSGs permit the traffic.

Consequently `enabled` defaults to `true`. The alternative — shipping a gateway that is
created but blackholes traffic — applies cleanly and then fails silently at runtime, which
is the worse default given that the gateway alone exposes nothing.

Note that `route_table_id` is the **ingress** route table, which routes traffic arriving
from the internet through this gateway (transit routing). It is not the mechanism in
point 1 above.

## Requirements

| Name      | Version  |
|-----------|----------|
| terraform | >= 1.5   |
| oci       | >= 5.0   |

## Inputs

| Name             | Description                                                        | Type          | Default | Required |
|------------------|--------------------------------------------------------------------|---------------|---------|:--------:|
| `compartment_id` | Compartment OCID to create the gateway in; the tenancy OCID is accepted for the root compartment. | `string` | n/a | yes |
| `vcn_id`         | OCID of the VCN the internet gateway belongs to.                   | `string`      | n/a     |   yes    |
| `display_name`   | Human-readable name for the internet gateway, 1–255 characters.    | `string`      | n/a     |   yes    |
| `enabled`        | Whether the gateway passes traffic. See [Reaching the internet](#reaching-the-internet). | `bool` | `true`  |    no    |
| `route_table_id` | Ingress route table OCID for traffic arriving through the gateway. Null uses the VCN default. | `string` | `null` | no |
| `freeform_tags`  | Free-form tags applied to the internet gateway.                    | `map(string)` | `{}`    |    no    |
| `defined_tags`   | Defined tags applied to the gateway, keyed `namespace.key`.        | `map(string)` | `{}`    |    no    |

## Outputs

| Name           | Description                              |
|----------------|------------------------------------------|
| `id`           | OCID of the internet gateway.            |
| `display_name` | Display name of the internet gateway.    |
| `enabled`      | Whether the internet gateway is enabled. |
| `state`        | Lifecycle state of the internet gateway. |

## Tests

`compartment_id`, `vcn_id` and `route_table_id` are checked for the expected OCID prefix, so
transposing two of them fails at plan time instead of surfacing as an OCI API error mid-apply.

The suite in [`tests/`](tests) covers those rules and the module defaults. It uses a mocked
provider, so it needs no OCI credentials and no network:

```sh
terraform init -backend=false
terraform test
```

Provider mocking requires Terraform >= 1.7 (or OpenTofu >= 1.7) to run the tests. Using the
module itself still only requires >= 1.5.

## License

[MIT](LICENSE)
