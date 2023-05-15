# 
# Equinix Metal 2nd Generation ARM and x86 Hardware
#
# This configuration file will override the defaults in vars.tf
#
# c3.medium - 24 Core AMD EPYC 7401p, 64GB, 2x480GB SSD, 2x10Gbps
#             https://metal.equinix.com/product/servers/c3-medium/
# n3.xlarge - 32 Core Xeon Gold 6314, 512GB, 2x240GB SSD, 2x3.8TB NVMe, 4x25Gbps
#             https://metal.equinix.com/product/servers/n3-xlarge/
# c3.large.arm64 - 80 Core Ampere Altra Q80-30, 256GB, 2x960GB NVMe, 2x25Gbps
#             https://metal.equinix.com/product/servers/c3-large-arm64/
#

module "sample_arm" {
  source = "../.."

  equinix_metal_controller_type  = "c3.medium.x86"
  equinix_metal_dashboard_type   = "c3.medium.x86"
  equinix_metal_compute-arm_type = "c3.large.arm64"
  equinix_metal_compute-x86_type = "n3.xlarge.x86"
  openstack_compute-arm_count    = 1
  openstack_compute-x86_count    = 1

  metal_auth_token      = var.metal_auth_token
  metal_organization_id = var.metal_organization_id

  # Use an existing project:
  # equinix_metal_create_project        = false
  # metal_project_id           = "..."
  #
  # Or create a new one (default), requiring organization_id :
  # equinix_metal_create_project        = true
  # metal_organization_id       = "..."
}
