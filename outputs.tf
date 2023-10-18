
output "instance_group_urls" {
  description = "List of GKE generated instance groups"
  value       = distinct(flatten([for np in google_container_node_pool.self : np.managed_instance_group_urls]))
}

# node_pools_ids

#output "node_pools_names" {
#  description = "List of node pools names"
#  value       = local.cluster_node_pools_names
#}
#
#output "node_pools_versions" {
#  description = "Node pool versions by node pool name"
#  value       = local.cluster_node_pools_versions
#}
#
#output "service_account" {
#  description = "The service account to default running nodes as if not overridden in `node_pools`."
#  value       = local.service_account
#}
output "cluster_default_node_zones" {
  description = "The default zones for node pools in the cluster"
  value       = data.google_container_cluster.existing.node_locations
}
output "zones" {
  description = "Available zones"
  value       = data.google_compute_zones.available.names
}
output "zones_random" {
  description = "Available zones - randomized"
  value       = random_shuffle.available_zones.result
}
#output "gke_versions_region" {
#  value = data.google_container_engine_versions.region
#}
#output "gke_versions_zone" {
#  value = data.google_container_engine_versions.zone
#}
#output "gke_cluster" {
#  value = data.google_container_cluster.existing
#}
