
###----------------------------------------
### Get available zones in region
###----------------------------------------
data "google_compute_zones" "available" {
  #count = local.zone_count == 0 ? 1 : 0

  project = var.project_id
  region  = local.region
}
resource "random_shuffle" "available_zones" {
  #count = local.zone_count == 0 ? 1 : 0

  #input        = data.google_compute_zones.available[0].names
  input        = data.google_compute_zones.available.names
  result_count = 3
}

###----------------------------------------
### Get available container engine versions
###----------------------------------------
#data "google_container_engine_versions" "region" {
#  location = var.cluster_location
#  project  = var.project_id
#}
# valid_master_versions - A list of versions available in the given zone for use with master instances.
# valid_node_versions - A list of versions available in the given zone for use with node instances.
# latest_master_version - The latest version available in the given zone for use with master instances.
# latest_node_version - The latest version available in the given zone for use with node instances.
# default_cluster_version - Version of Kubernetes the service deploys by default.
# release_channel_default_version - A map from a release channel name to the channel's default version.
# release_channel_latest_version - A map from a release channel name to the channel's latest version.

#data "google_container_engine_versions" "zone" {
#  // Work around to prevent a lack of zone declaration from causing regional cluster creation from erroring out due to error
#  //
#  //   data.google_container_engine_versions.zone: Cannot determine zone: set in this resource, or set provider-level zone.
#  //
#  #location = local.zone_count == 0 ? data.google_compute_zones.available[0].names[0] : var.zones[0]
#  location = data.google_compute_zones.available.names[0]
#  project  = var.project_id
#}

###----------------------------------------
### Existing cluster to add node pools too
###----------------------------------------
data "google_container_cluster" "existing" {
  name     = var.cluster_name
  location = var.cluster_location
  project  = var.project_id
}
# workload_identity_config, service_account,
# node_version,

#default_max_pods_per_node
#id                    = "projects/notable-devops-prod/locations/us-west1/clusters/devops"
#location
#master_version                    = "1.25.10-gke.2700"
#min_master_version                = null
#network                           = "projects/notable-devops-prod/global/networks/network-1"
#networking_mode                   = "VPC_NATIVE"
#node_config                       = [
#  {
#      boot_disk_kms_key        = ""
#      disk_size_gb             = 100
#      disk_type                = "pd-standard"
#      gcfs_config              = []
#      guest_accelerator        = []
#      gvnic                    = []
#      image_type               = "COS_CONTAINERD"
#      labels                   = {
#          nodepool = "autoscaling-pool"
#        }
#      local_ssd_count          = 1
#      logging_variant          = "DEFAULT"
#      machine_type             = "n1-standard-4"
#      metadata                 = {
#          disable-legacy-endpoints = "true"
#        }
#      min_cpu_platform         = ""
#      node_group               = ""
#      oauth_scopes             = [
#          "https://www.googleapis.com/auth/devstorage.read_only",
#          "https://www.googleapis.com/auth/logging.write",
#          "https://www.googleapis.com/auth/monitoring",
#          "https://www.googleapis.com/auth/service.management.readonly",
#          "https://www.googleapis.com/auth/servicecontrol",
#          "https://www.googleapis.com/auth/trace.append",
#        ]
#      preemptible              = false
#      reservation_affinity     = []
#      resource_labels          = {}
#      service_account          = "default"
#      shielded_instance_config = [
#          {
#              enable_integrity_monitoring = true
#              enable_secure_boot          = false
#            },
#        ]
#      spot                     = false
#      tags                     = []
#      taint                    = []
#      workload_metadata_config = []
#    },
#]
#node_locations                    = [
#  "us-west1-a",
#  "us-west1-b",
#  "us-west1-c",
#]
#upgrade_settings            = [
#  {
#      blue_green_settings = []
#      max_surge           = 1
#      max_unavailable     = 0
#      strategy            = "SURGE"
#    },
#]
#version                     = "1.25.10-gke.2700"
#release_channel                   = [
#  {
#      channel = "STABLE"
#    },
#]
#resource_labels                   = {}
#self_link                         = "https://container.googleapis.com/v1/projects/notable-devops-prod/locations/us-west1/clusters/devops"
#subnetwork                        = "projects/notable-devops-prod/regions/us-west1/subnetworks/subnetwork-1"
#
