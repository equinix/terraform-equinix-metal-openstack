# 
# Equinix Metal 3rd Generation Hardware
#
# c3.medium - 24 Core AMD EPYC 7401p, 64GB, 2x480GB SSD, 2x10Gbps
#             https://metal.equinix.com/product/servers/c3-medium/
# s3.xlarge - 24 Core Xeon Silver 4214, 192GB, 2x256GB SSD, 2x960GB, 12x8TB HDD, 2x10Gbps
#             https://metal.equinix.com/product/servers/s3-xlarge/
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
