# 
# Equinix Metal 2nd Generation ARM Hardware
#
# This configuration file will override the defaults in vars.tf
#
# c3.large.arm64 - 32 Core Ampere eMAG, 128GB, 480GB, 2x10Gbps
#

module "sample_arm" {
  source = "../.."

  equinix_metal_controller_type  = "c3.large.arm64"
  equinix_metal_dashboard_type   = "c3.large.arm64"
  equinix_metal_compute-arm_type = "c3.large.arm64"
  openstack_compute-arm_count    = 1
  openstack_compute-x86_count    = 0

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
