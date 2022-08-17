# 
# Equinix Metal 3rd Generation Hardware
#
# This configuration file will override the defaults in vars.tf
#
# c3.medium - 24 Core AMD EPYC 7402P, 64GB, 960GB, 2x10Gbps
# s3.xlarge - 24 Core Intel 4214, 192GB, 1.9TB, 2x10Gbps
module "sample_arm" {
  source = "../.."

  equinix_metal_controller_type  = "c3.medium.x86"
  equinix_metal_dashboard_type   = "c3.medium.x86"
  equinix_metal_compute-x86_type = "s3.xlarge.x86"
  openstack_compute-arm_count    = 1
  openstack_compute-x86_count    = 1

  equinix_metal_auth_token      = var.metal_auth_token
  equinix_metal_organization_id = var.metal_organization_id

  # Use an existing project:
  # equinix_metal_create_project        = false
  # equinix_metal_project_id           = "..."
  #
  # Or create a new one (default), requiring organization_id :
  # equinix_metal_create_project        = true
  # equinix_metal_organization_id       = "..."
}
