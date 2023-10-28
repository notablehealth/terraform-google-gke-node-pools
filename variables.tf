
#variable "validated" {
#  description = "String variable with validation"
#  type        = string
#  validation {
#    condition = contains(
#      ["one", "two", "three", "four"],
#      var.validated
#    )
#    error_message = "Must be one of: one, two, three, four."
#  }
#}
#variable "default_autoscaling                      type = bool   default = true
#variable "default_autoscaling_location_policy      type = string default = null
#variable "default_autoscaling_max_node_count       type = number default = 100
#variable "default_autoscaling_min_node_count       type = number default = 1
#variable "default_autoscaling_total_max_node_count type = number default = null
#variable "default_autoscaling_total_min_node_count type = number default = null
#variable "default_disk_size_gb                     type = number default = 100
#variable "default_disk_type                        type = string default = "pd-standard"
#variable "default_enable_confidential_nodes        type = bool   default = false
#variable "default_enable_fast_socket               type = bool   default = false
#variable "default_enable_gcfc                      type = bool   default = false
#variable "default_enable_gvnic                     type = bool   default = false
#variable "default_enable_integrity_monitoring      type = bool   default = true
#variable "default_enable_secure_boot               type = bool   default = false
#variable "default_gpu_driver_version               type =
#variable "default_gpu_max_shared_clients_per_gpu   type =
#variable "default_gpu_partition_size               type = number default = null
#variable "default_gpu_sharing_strategy             type =
#variable "default_guest_accelerator_count          type = number default = 0
#variable "default_guest_accelerator_type           type = string default = ""
#variable "default_image_type                       type = string default = "COS_CONTAINERD"
#variable "default_initial_node_count               type = number default = 1
#variable "default_local_ssd_count                  type = number default = 0   # also 3 other variants
#variable "default_logging_variant                  type = string default = "DEFAULT"
#variable "default_machine_type                     type = string default = "e2-medium"
#variable "default_max_pods_per_node                type =
#variable "default_min_cpu_platform                 type = string default = ""
#variable "default_placement_policy_name            type =
#variable "default_placement_policy_tpu_topology    type =
#variable "default_placement_policy_type            type = string default = "COMPACT"
#variable "default_preemptible                      type = bool   default = false
#variable "default_spot                             type = bool   default = false
#variable "default_upgrade_bg_node_pool_soak_duration                     type = string
#variable "default_upgrade_bg_standard_rollout_policy_batch_node_count    type = number
#variable "default_upgrade_bg_standard_rollout_policy_batch_percentage    type = number
#variable "default_upgrade_bg_standard_rollout_policy_batch_soak_duration type = string
#variable "default_upgrade_max_surge       type = number default = 1
#variable "default_upgrade_max_unavailable type = number default = 0
#variable "default_upgrade_strategy        type = string default = "SURGE"

variable "cluster_name" {
  description = "Name of the existing GKE cluster to add node pools too"
  type        = string
}
variable "cluster_location" {
  description = "Location of the existing GKE cluster"
  type        = string
}
#variable "create_service_account" {
#  description = "Defines if service account specified to run nodes should be created."
#  type        = bool
#  default     = true
#}
variable "default_auto_repair" {
  description = "Default value for auto_repair in node pools"
  type        = bool
  default     = true
}
variable "default_auto_upgrade" {
  description = "Default value for auto_upgrade in node pools"
  type        = bool
  default     = true
}
variable "disable_legacy_metadata_endpoints" {
  type        = bool
  description = "Disable the /0.1/ and /v1beta1/ metadata server endpoints on the node. Changing this value will cause all node pools to be recreated."
  default     = true
}
#variable "kubernetes_version" {
#  description = "The Kubernetes version for the nodes in this pool. Defaults to the cluster's version."
#  type        = string
#  default     = "latest"
#}

#variable "service_account" {
#  description = "The service account to run nodes as if not overridden in `node_pools`. The create_service_account variable default value (true) will cause a cluster-specific service account to be created. This service account should already exists and it will be used by the node pools. If you wish to only override the service account name, you can use service_account_name variable."
#  type        = string
#  default     = ""
#}
#variable "service_account_name" {
#  description = "The name of the service account that will be created if create_service_account is true. If you wish to use an existing service account, use service_account variable."
#  type        = string
#  default     = ""
#}

variable "node_metadata" {
  description = "Specifies how node metadata is exposed to the workload running on the node"
  default     = "GKE_METADATA"
  type        = string

  validation {
    condition     = contains(["GKE_METADATA", "GCE_METADATA", "UNSPECIFIED", "GKE_METADATA_SERVER", "EXPOSE"], var.node_metadata)
    error_message = "The node_metadata value must be one of GKE_METADATA, GCE_METADATA, UNSPECIFIED, GKE_METADATA_SERVER or EXPOSE."
  }
}

variable "node_pools" {
  description = "Map of node pool objects"
  # key = node pool name
  type = map(object({ # list(map(any))
    #auto_upgrade       = optional(bool)
    autoscaling                      = optional(bool, true)
    autoscaling_min_node_count       = optional(number)
    autoscaling_max_node_count       = optional(number)
    autoscaling_location_policy      = optional(string)
    autoscaling_total_min_node_count = optional(number)
    autoscaling_total_max_node_count = optional(number)
    initial_node_count               = optional(number)
    max_pods_per_node                = optional(number)
    #min_count          = optional(number)
    node_locations = optional(string, "")
    version        = optional(string)
    management = optional(object({
      auto_repair  = optional(bool, true)
      auto_upgrade = optional(bool, true)
    }))
    node_config = optional(object({
      boot_disk_kms_key = optional(string)
      disk_size_gb      = optional(number)
      disk_type         = optional(string)
      enable_gcfs       = optional(bool, false)
      enable_gvnic      = optional(bool, false)
      image_type        = optional(string)
      labels            = optional(map(string))
      local_ssd_count   = optional(number)
      logging_variant   = optional(string)
      machine_type      = optional(string)
      metadata          = optional(map(string))
      min_cpu_platform  = optional(string)
      oauth_scopes      = optional(list(string))
      preemptible       = optional(bool)
      resource_labels   = optional(map(string))
      service_account   = optional(string)
      spot              = optional(bool)
      tags              = optional(list(string))
      workload_metadata = optional(string)
      guest_accelerator = optional(object({
        type               = optional(string)
        count              = optional(number)
        gpu_partition_size = optional(number)
      }))
      linux_node_config = optional(object({
        sysctls = optional(map(string))
      }))
      shielded_instance_config = optional(object({
        enable_secure_boot          = optional(bool)
        enable_integrity_monitoring = optional(bool)
      }))
      taints = optional(list(object({
        key    = string
        value  = string
        effect = string
      })), [])
    }))
    #upgrade_strategy = optional(string)
    #upgrade_max_surge = optional(number)
    #upgrade_max_unavailable =  optional(number)
    #upgrade_bg_node_pool_soak_duration = optional(string)
    #upgrade_bg_standard_rollout_policy_batch_soak_duration = optional(string)
    #upgrade_bg_standard_rollout_policy_batch_percentage = optional(number)
    #upgrade_bg_standard_rollout_policy_batch_node_count = optional(number)
    upgrade_settings = optional(object({
      strategy        = optional(string)
      max_surge       = optional(number)
      max_unavailable = optional(number)
      blue_green_settings = optional(object({
        node_pool_soak_duration = optional(string)
        standard_rollout_policy = optional(object({
          batch_soak_duration = optional(string)
          batch_percentage    = optional(number)
          batch_node_count    = optional(number)
        }))
      }))
    }))

  }))

  #default = {}
}

variable "node_pools_labels" {
  description = "Map of maps containing node labels by node-pool name"
  type        = map(map(any))
  # Default is being set in variables_defaults.tf
  default = {
    all = {
      terraform = true
    }
  }
}

variable "node_pools_resource_labels" {
  description = "Map of maps containing resource labels by node-pool name"
  type        = map(map(string))
  default = {
    all = {}
  }
}

variable "node_pools_metadata" {
  description = "Map of maps containing node metadata by node-pool name"
  type        = map(map(string))
  # Default is being set in variables_defaults.tf
  default = {
    all = {}
  }
}

variable "node_pools_linux_node_configs_sysctls" {
  description = "Map of maps containing linux node config sysctls by node-pool name"
  type        = map(map(string))
  # Default is being set in variables_defaults.tf
  default = {
    all = {}
  }
}
variable "node_pools_taints" {
  description = "Map of lists containing node taints by node-pool name"
  type        = map(list(object({ key = string, value = string, effect = string })))
  # Default is being set in variables_defaults.tf
  default = {
    all = []
  }
}

variable "node_pools_tags" {
  description = "Map of lists containing node network tags by node-pool name"
  type        = map(list(string))
  # Default is being set in variables_defaults.tf
  default = {
    all = []
  }
}
variable "node_pools_oauth_scopes" {
  description = "Map of lists containing node oauth scopes by node-pool name"
  type        = map(list(string))
  # Default is being set in variables_defaults.tf
  default = {
    all = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}
variable "release_channel" {
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."
  type        = string
  default     = "REGULAR"
  validation {
    condition     = contains(["UNSPECIFIED", "RAPID", "REGULAR", "STABLE"], var.release_channel)
    error_message = "The release_channel value must be one of UNSPECIFIED, RAPID, REGULAR or STABLE."
  }
}
variable "timeouts" {
  description = "Timeout for cluster operations."
  type        = map(string)
  default     = {}
  validation {
    condition     = !contains([for t in keys(var.timeouts) : contains(["create", "update", "delete"], t)], false)
    error_message = "Only create, update, delete timeouts can be specified."
  }
}
