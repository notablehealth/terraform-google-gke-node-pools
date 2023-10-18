# Setup dynamic default values for variables which can't be setup using
# the standard terraform "variable default" functionality

locals {
  node_pools_labels = merge(
    { all = {} },
    zipmap(
      [for node_pool, data in var.node_pools : node_pool],
      [for node_pool in var.node_pools : {}]
    ),
    var.node_pools_labels
  )

  node_pools_resource_labels = merge(
    { all = {} },
    zipmap(
      [for node_pool, data in var.node_pools : node_pool],
      [for node_pool in var.node_pools : {}]
    ),
    var.node_pools_resource_labels
  )

  node_pools_metadata = merge(
    { all = {} },
    zipmap(
      [for node_pool, data in var.node_pools : node_pool],
      [for node_pool in var.node_pools : {}]
    ),
    var.node_pools_metadata
  )

  node_pools_taints = merge(
    { all = [] },
    zipmap(
      [for node_pool, data in var.node_pools : node_pool],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_taints
  )

  node_pools_tags = merge(
    { all = [] },
    zipmap(
      [for node_pool, data in var.node_pools : node_pool],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_tags
  )

  node_pools_oauth_scopes = merge(
    { all = ["https://www.googleapis.com/auth/cloud-platform"] },
    zipmap(
      [for node_pool, data in var.node_pools : node_pool],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_oauth_scopes
  )

  node_pools_linux_node_configs_sysctls = merge(
    { all = {} },
    zipmap(
      [for node_pool, data in var.node_pools : node_pool],
      [for node_pool in var.node_pools : {}]
    ),
    var.node_pools_linux_node_configs_sysctls
  )
}
