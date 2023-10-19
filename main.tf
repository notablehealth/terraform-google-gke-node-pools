/**
 * # terraform-google-gke-node-pools
 *
 * [![Releases](https://img.shields.io/github/v/release/notablehealth/terraform-google-gke-node-pools)](https://github.com/notablehealth/terraform-google-gke-node-pools/releases)
 *
 * [Terraform Module Registry](https://registry.terraform.io/modules/notablehealth/gke-node-pools/google)
 *
 * Manage independent node pools in a GKE cluster.
 *
 * Work in Progress - May get redesigned before it's finished
 *
 * ## Features
 *
 * - Manage any number of node pools
 *
 */

# Data lookups
#   cluster, version,
#

# Manage
#   Service Account

locals {
  // location
  region = join("-", slice(split("-", var.cluster_location), 0, 2))

  #location       = var.regional ? var.region : var.zones[0]
  #zone_count     = length(var.zones)
  #node_locations = var.regional ? coalescelist(compact(var.zones), try(sort(random_shuffle.available_zones[0].result), [])) : slice(var.zones, 1, length(var.zones))
  // Kubernetes version
  #master_version_regional = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.region.latest_master_version
  #master_version_zonal    = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.zone.latest_master_version
  #master_version          = var.regional ? local.master_version_regional : local.master_version_zonal
  // Build a map of maps of node pools from a list of objects
  #release_channel = var.release_channel != null ? [{ channel : var.release_channel }] : []
  #cluster_output_node_pools_names = concat(
  #  [for np in google_container_node_pool.self : np.name], [""],
  #)

  #cluster_output_node_pools_versions = merge(
  #  { for np in google_container_node_pool.self : np.name => np.version },
  #)
  #cluster_location = google_container_cluster.primary.location
  #cluster_region   = var.regional ? var.region : join("-", slice(split("-", local.cluster_location), 0, 2))
  #cluster_zones = sort(local.cluster_output_zones)
  #cluster_type     = var.regional ? "regional" : "zonal"
  // auto upgrade by defaults only for regional cluster as long it has multiple masters versus zonal clusters have only have a single master so upgrades are more dangerous.
  // When a release channel is used, node auto-upgrade is enabled and cannot be disabled.
  #default_auto_upgrade = var.regional || var.release_channel != "UNSPECIFIED" ? true : false

  #node_pool_names = [for np in toset(var.node_pools) : np.name]
  #node_pools      = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))
  # list(map(any)) -> map(object({}))
}

resource "google_container_node_pool" "self" {
  for_each = var.node_pools
  #checkov:skip=CKV_GCP_68:
  #checkov:skip=CKV_GCP_69:
  #checkov:skip=CKV_GCP_72:
  #tomap()
  name     = each.key
  project  = var.project_id
  location = var.cluster_location
  # Validate node locations with available zones
  // use node_locations if provided, defaults to cluster level node_locations if not specified
  node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", each.value["node_locations"]) : null

  cluster = var.cluster_name # or selflink

  #version = lookup(each.value, "auto_upgrade", local.default_auto_upgrade) ? "" : lookup(
  #  each.value,
  #  "version",
  #  data.google_container_cluster.existing.master_version,
  #)

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_node_count", 1)
  ) : null

  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)

  #node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  autoscaling {
    #for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    #content {
    min_node_count       = lookup(each.value, "autoscaling_min_node_count", null) == null ? 1 : lookup(each.value, "autoscaling_min_node_count", 1)
    max_node_count       = lookup(each.value, "autoscaling_max_node_count", null) == null ? 100 : lookup(each.value, "autoscaling_max_node_count", 100)
    location_policy      = lookup(each.value, "autoscaling_location_policy", null)
    total_min_node_count = lookup(each.value, "autoscaling_total_min_node_count", null)
    total_max_node_count = lookup(each.value, "autoscaling_total_max_node_count", null)
    #}
  }

  management {
    auto_repair  = lookup(lookup(each.value, "management", {}) == null ? {} : lookup(each.value, "management", {}), "auto_repair", var.default_auto_repair)
    auto_upgrade = lookup(lookup(each.value, "management", {}) == null ? {} : lookup(each.value, "management", {}), "auto_upgrade", var.default_auto_upgrade)
  }

  upgrade_settings {
    strategy        = lookup(each.value, "strategy", "SURGE")
    max_surge       = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_surge", 1) : null
    max_unavailable = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_unavailable", 0) : null

    dynamic "blue_green_settings" {
      for_each = lookup(each.value, "strategy", "SURGE") == "BLUE_GREEN" ? [1] : []
      content {
        node_pool_soak_duration = lookup(each.value, "node_pool_soak_duration", null)

        standard_rollout_policy {
          batch_soak_duration = lookup(each.value, "batch_soak_duration", null)
          batch_percentage    = lookup(each.value, "batch_percentage", null)
          batch_node_count    = lookup(each.value, "batch_node_count", null)
        }
      }
    }
  }

  node_config {
    image_type       = lookup(each.value.node_config, "image_type", "COS_CONTAINERD")
    machine_type     = lookup(each.value.node_config, "machine_type", "e2-medium")
    min_cpu_platform = lookup(each.value.node_config, "min_cpu_platform", "")
    dynamic "gcfs_config" {
      for_each = lookup(each.value.node_config, "enable_gcfs", false) ? [true] : []
      content {
        enabled = gcfs_config.value
      }
    }
    dynamic "gvnic" {
      for_each = lookup(each.value.node_config, "enable_gvnic", false) ? [true] : []
      content {
        enabled = gvnic.value
      }
    }
    labels = merge(
      lookup(lookup(local.node_pools_labels, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.cluster_name } : {},
      lookup(lookup(local.node_pools_labels, "default_values", {}), "node_pool", true) ? { "node_pool" = each.key } : {},
      local.node_pools_labels["all"],
      local.node_pools_labels[each.key],
      lookup(each.value.node_config, "labels", {})
    )
    resource_labels = merge(
      local.node_pools_resource_labels["all"],
      local.node_pools_resource_labels[each.key],
    )
    metadata = merge(
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.cluster_name } : {},
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "node_pool", true) ? { "node_pool" = each.key } : {},
      local.node_pools_metadata["all"],
      local.node_pools_metadata[each.key],
      {
        "disable-legacy-endpoints" = var.disable_legacy_metadata_endpoints
      },
    )
    dynamic "taint" {
      for_each = concat(
        local.node_pools_taints["all"],
        local.node_pools_taints[each.key],
        lookup(each.value.node_config, "taints", [])
      )
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
    tags = concat(
      #lookup(local.node_pools_tags, "default_values", [true, true])[0] ? [local.cluster_network_tag] : [],
      #lookup(local.node_pools_tags, "default_values", [true, true])[1] ? ["${local.cluster_network_tag}-${each.value["name"]}"] : [],
      local.node_pools_tags["all"],
      local.node_pools_tags[each.key],
    )

    logging_variant = lookup(each.value.node_config, "logging_variant", "DEFAULT")

    local_ssd_count = lookup(each.value.node_config, "local_ssd_count", 0)
    disk_size_gb    = lookup(each.value.node_config, "disk_size_gb", 100)
    disk_type       = lookup(each.value.node_config, "disk_type", "pd-standard")

    #service_account = lookup(
    #  each.value,
    #  "service_account",
    #  local.service_account,
    #)
    preemptible = lookup(each.value.node_config, "preemptible", false)
    spot        = lookup(each.value.node_config, "spot", false)

    oauth_scopes = concat(
      local.node_pools_oauth_scopes["all"],
      local.node_pools_oauth_scopes[each.key],
    )

    dynamic "guest_accelerator" {
      for_each = lookup(each.value.node_config, "accelerator_count", 0) > 0 ? [1] : []
      content {
        type               = lookup(each.value, "accelerator_type", "")
        count              = lookup(each.value, "accelerator_count", 0)
        gpu_partition_size = lookup(each.value, "gpu_partition_size", null)
      }
    }

    #dynamic "workload_metadata_config" {
    #  for_each = local.cluster_node_metadata_config
    #
    #  content {
    #    mode = lookup(each.value, "node_metadata", workload_metadata_config.value.mode)
    #  }
    #}

    dynamic "linux_node_config" {
      for_each = length(merge(
        local.node_pools_linux_node_configs_sysctls["all"],
        local.node_pools_linux_node_configs_sysctls[each.key]
      )) != 0 ? [1] : []

      content {
        sysctls = merge(
          local.node_pools_linux_node_configs_sysctls["all"],
          local.node_pools_linux_node_configs_sysctls[each.key]
        )
      }
    }

    boot_disk_kms_key = lookup(each.value.node_config, "boot_disk_kms_key", "")

    shielded_instance_config {
      enable_secure_boot          = lookup(each.value.node_config, "enable_secure_boot", true)
      enable_integrity_monitoring = lookup(each.value.node_config, "enable_integrity_monitoring", true)
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]

  }

  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }
}
