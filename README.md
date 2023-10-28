
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# terraform-google-gke-node-pools

[![Releases](https://img.shields.io/github/v/release/notablehealth/terraform-google-gke-node-pools)](https://github.com/notablehealth/terraform-google-gke-node-pools/releases)

[Terraform Module Registry](https://registry.terraform.io/modules/notablehealth/gke-node-pools/google)

Manage independent node pools in a GKE cluster.

Work in Progress - May get redesigned before it's finished

## Features

- Manage any number of node pools

## Usage

Basic usage of this module is as follows:

```hcl
module "example" {
    source = "notablehealth/<module-name>/google"
    # Recommend pinning every module to a specific version
    # version = "x.x.x"

    # Required variables
    cluster_location =
    cluster_name =
    node_pools =
    project_id =
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_node_pool.self](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [random_shuffle.available_zones](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |
| [google_container_cluster.existing](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_location"></a> [cluster\_location](#input\_cluster\_location) | Location of the existing GKE cluster | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the existing GKE cluster to add node pools too | `string` | n/a | yes |
| <a name="input_default_auto_repair"></a> [default\_auto\_repair](#input\_default\_auto\_repair) | Default value for auto\_repair in node pools | `bool` | `true` | no |
| <a name="input_default_auto_upgrade"></a> [default\_auto\_upgrade](#input\_default\_auto\_upgrade) | Default value for auto\_upgrade in node pools | `bool` | `true` | no |
| <a name="input_disable_legacy_metadata_endpoints"></a> [disable\_legacy\_metadata\_endpoints](#input\_disable\_legacy\_metadata\_endpoints) | Disable the /0.1/ and /v1beta1/ metadata server endpoints on the node. Changing this value will cause all node pools to be recreated. | `bool` | `true` | no |
| <a name="input_node_metadata"></a> [node\_metadata](#input\_node\_metadata) | Specifies how node metadata is exposed to the workload running on the node | `string` | `"GKE_METADATA"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Map of node pool objects | <pre>map(object({ # list(map(any))<br>    #auto_upgrade       = optional(bool)<br>    autoscaling                      = optional(bool, true)<br>    autoscaling_min_node_count       = optional(number)<br>    autoscaling_max_node_count       = optional(number)<br>    autoscaling_location_policy      = optional(string)<br>    autoscaling_total_min_node_count = optional(number)<br>    autoscaling_total_max_node_count = optional(number)<br>    initial_node_count               = optional(number)<br>    max_pods_per_node                = optional(number)<br>    #min_count          = optional(number)<br>    node_locations = optional(string, "")<br>    version        = optional(string)<br>    management = optional(object({<br>      auto_repair  = optional(bool, true)<br>      auto_upgrade = optional(bool, true)<br>    }))<br>    node_config = optional(object({<br>      boot_disk_kms_key = optional(string)<br>      disk_size_gb      = optional(number)<br>      disk_type         = optional(string)<br>      enable_gcfs       = optional(bool, false)<br>      enable_gvnic      = optional(bool, false)<br>      image_type        = optional(string)<br>      labels            = optional(map(string))<br>      local_ssd_count   = optional(number)<br>      logging_variant   = optional(string)<br>      machine_type      = optional(string)<br>      metadata          = optional(map(string))<br>      min_cpu_platform  = optional(string)<br>      oauth_scopes      = optional(list(string))<br>      preemptible       = optional(bool)<br>      resource_labels   = optional(map(string))<br>      service_account   = optional(string)<br>      spot              = optional(bool)<br>      tags              = optional(list(string))<br>      workload_metadata = optional(string)<br>      guest_accelerator = optional(object({<br>        type               = optional(string)<br>        count              = optional(number)<br>        gpu_partition_size = optional(number)<br>      }))<br>      linux_node_config = optional(object({<br>        sysctls = optional(map(string))<br>      }))<br>      shielded_instance_config = optional(object({<br>        enable_secure_boot          = optional(bool)<br>        enable_integrity_monitoring = optional(bool)<br>      }))<br>      taints = optional(list(object({<br>        key    = string<br>        value  = string<br>        effect = string<br>      })), [])<br>    }))<br>    #upgrade_strategy = optional(string)<br>    #upgrade_max_surge = optional(number)<br>    #upgrade_max_unavailable =  optional(number)<br>    #upgrade_bg_node_pool_soak_duration = optional(string)<br>    #upgrade_bg_standard_rollout_policy_batch_soak_duration = optional(string)<br>    #upgrade_bg_standard_rollout_policy_batch_percentage = optional(number)<br>    #upgrade_bg_standard_rollout_policy_batch_node_count = optional(number)<br>    upgrade_settings = optional(object({<br>      strategy        = optional(string)<br>      max_surge       = optional(number)<br>      max_unavailable = optional(number)<br>      blue_green_settings = optional(object({<br>        node_pool_soak_duration = optional(string)<br>        standard_rollout_policy = optional(object({<br>          batch_soak_duration = optional(string)<br>          batch_percentage    = optional(number)<br>          batch_node_count    = optional(number)<br>        }))<br>      }))<br>    }))<br><br>  }))</pre> | n/a | yes |
| <a name="input_node_pools_labels"></a> [node\_pools\_labels](#input\_node\_pools\_labels) | Map of maps containing node labels by node-pool name | `map(map(any))` | <pre>{<br>  "all": {<br>    "terraform": true<br>  }<br>}</pre> | no |
| <a name="input_node_pools_linux_node_configs_sysctls"></a> [node\_pools\_linux\_node\_configs\_sysctls](#input\_node\_pools\_linux\_node\_configs\_sysctls) | Map of maps containing linux node config sysctls by node-pool name | `map(map(string))` | <pre>{<br>  "all": {}<br>}</pre> | no |
| <a name="input_node_pools_metadata"></a> [node\_pools\_metadata](#input\_node\_pools\_metadata) | Map of maps containing node metadata by node-pool name | `map(map(string))` | <pre>{<br>  "all": {}<br>}</pre> | no |
| <a name="input_node_pools_oauth_scopes"></a> [node\_pools\_oauth\_scopes](#input\_node\_pools\_oauth\_scopes) | Map of lists containing node oauth scopes by node-pool name | `map(list(string))` | <pre>{<br>  "all": [<br>    "https://www.googleapis.com/auth/cloud-platform"<br>  ]<br>}</pre> | no |
| <a name="input_node_pools_resource_labels"></a> [node\_pools\_resource\_labels](#input\_node\_pools\_resource\_labels) | Map of maps containing resource labels by node-pool name | `map(map(string))` | <pre>{<br>  "all": {}<br>}</pre> | no |
| <a name="input_node_pools_tags"></a> [node\_pools\_tags](#input\_node\_pools\_tags) | Map of lists containing node network tags by node-pool name | `map(list(string))` | <pre>{<br>  "all": []<br>}</pre> | no |
| <a name="input_node_pools_taints"></a> [node\_pools\_taints](#input\_node\_pools\_taints) | Map of lists containing node taints by node-pool name | `map(list(object({ key = string, value = string, effect = string })))` | <pre>{<br>  "all": []<br>}</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`. | `string` | `"REGULAR"` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeout for cluster operations. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_default_node_zones"></a> [cluster\_default\_node\_zones](#output\_cluster\_default\_node\_zones) | The default zones for node pools in the cluster |
| <a name="output_instance_group_urls"></a> [instance\_group\_urls](#output\_instance\_group\_urls) | List of GKE generated instance groups |
| <a name="output_zones"></a> [zones](#output\_zones) | Available zones |
| <a name="output_zones_random"></a> [zones\_random](#output\_zones\_random) | Available zones - randomized |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
