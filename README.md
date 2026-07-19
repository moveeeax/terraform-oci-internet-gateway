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

## Requirements

| Name      | Version  |
|-----------|----------|
| terraform | >= 1.5   |
| oci       | >= 5.0   |

## Inputs

| Name             | Description                                                        | Type          | Default | Required |
|------------------|--------------------------------------------------------------------|---------------|---------|:--------:|
| `compartment_id` | OCID of the compartment in which to create the internet gateway.   | `string`      | n/a     |   yes    |
| `vcn_id`         | OCID of the VCN the internet gateway belongs to.                   | `string`      | n/a     |   yes    |
| `display_name`   | Human-readable name for the internet gateway.                      | `string`      | n/a     |   yes    |
| `enabled`        | Whether the gateway is enabled and passing traffic.                | `bool`        | `true`  |    no    |
| `route_table_id` | Route table OCID the gateway uses. Null uses the VCN default.      | `string`      | `null`  |    no    |
| `freeform_tags`  | Free-form tags applied to the internet gateway.                    | `map(string)` | `{}`    |    no    |
| `defined_tags`   | Defined tags applied to the gateway, keyed `namespace.key`.        | `map(string)` | `{}`    |    no    |

## Outputs

| Name           | Description                              |
|----------------|------------------------------------------|
| `id`           | OCID of the internet gateway.            |
| `display_name` | Display name of the internet gateway.    |
| `enabled`      | Whether the internet gateway is enabled. |
| `state`        | Lifecycle state of the internet gateway. |

## License

[MIT](LICENSE)
