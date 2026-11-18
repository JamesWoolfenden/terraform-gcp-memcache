# terraform-gcp-memcache

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-memcache/workflows/Verify/badge.svg?branch=main)](https://github.com/JamesWoolfenden/terraform-gcp-memcache/actions)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-memcache.svg)](https://github.com/JamesWoolfenden/terraform-gcp-memcache/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-memcache.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-memcache/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.5.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

Terraform module for Memorystore for Memcached. Creates a Memcached instance attached to your VPC through private service access (no default network, no public endpoint), with a pinned Memcached version, a weekly maintenance window, deletion protection on by default, and labels. Memorystore for Memcached does not support customer-managed encryption keys (CMEK), so data is encrypted at rest with Google-managed keys only; use Memorystore for Redis or Valkey if CMEK is a requirement.

## Usage

Add **module.memcache.tf** to your code:-

```terraform
module "memcache" {
  source               = "jameswoolfenden/memcache/gcp"
  name                 = "example-memcache"
  region               = "europe-west2"
  authorized_network   = google_service_networking_connection.private_service_access.network
  reserved_ip_range_id = [google_compute_global_address.private_service_access.name]
}
```

See [example/examplea](example/examplea) for a complete working example.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_memcache_instance.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/memcache_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_authorized_network"></a> [authorized\_network](#input\_authorized\_network) | Full name of the VPC network (projects/P/global/networks/N) the instance is attached to via private service access. The network must already have a private service connection to servicenetworking.googleapis.com | `string` | n/a | yes |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | vCPUs per node | `number` | `1` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Prevent Terraform from destroying the instance | `bool` | `true` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Human-readable display name. Null to use the name | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels applied to the instance for cost allocation and ownership tracking | `map(string)` | `{}` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly maintenance window (UTC) so Google-initiated updates happen at a predictable, low-traffic time | <pre>object({<br/>    day        = optional(string, "SUNDAY")<br/>    start\_hour = optional(number, 2)<br/>    duration   = optional(string, "10800s")<br/>  })</pre> | `{}` | no |
| <a name="input_memcache_parameters"></a> [memcache\_parameters](#input\_memcache\_parameters) | Memcached configuration parameters (e.g. listen-backlog, max-item-size) | `map(string)` | `{}` | no |
| <a name="input_memcache_version"></a> [memcache\_version](#input\_memcache\_version) | Memcached major version to pin to, so upgrades happen deliberately | `string` | `"MEMCACHE_1_6_15"` | no |
| <a name="input_memory_size_mb"></a> [memory\_size\_mb](#input\_memory\_size\_mb) | Memory per node in MiB (1024-307200) | `number` | `1024` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Memorystore for Memcached instance | `string` | n/a | yes |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Number of nodes in the instance | `number` | `2` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for the instance | `string` | n/a | yes |
| <a name="input_reserved_ip_range_id"></a> [reserved\_ip\_range\_id](#input\_reserved\_ip\_range\_id) | Names of allocated private service access ranges to place the instance in. Empty to let Google pick from the network's allocated ranges | `list(string)` | `[]` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Zones to spread nodes across. Empty to let Google spread them across all zones in the region | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_discovery_endpoint"></a> [discovery\_endpoint](#output\_discovery\_endpoint) | Discovery endpoint clients use to find the Memcached nodes |
| <a name="output_id"></a> [id](#output\_id) | ID of the Memcached instance |
| <a name="output_nodes"></a> [nodes](#output\_nodes) | Memcached nodes (host, port, zone and state) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Role and Permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "memcache.instances.create",
    "memcache.instances.delete",
    "memcache.instances.get",
    "memcache.instances.update"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "memcache.instances.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/jameswoolfenden/terraform-gcp-memcache/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/jameswoolfenden/terraform-gcp-memcache/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
