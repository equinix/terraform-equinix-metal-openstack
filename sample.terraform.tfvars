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
metal_controller_type       = "c3.medium.x86"
metal_dashboard_type        = "c3.medium.x86"
metal_compute-arm_type      = "c3.large.arm64"
metal_compute-x86_type      = "n3.xlarge.x86"
openstack_compute-arm_count = 1
openstack_compute-x86_count = 1
metal_metro                 = "da"

# Use an existing project:
# metal_create_project        = false
# metal_project_id           = "..."
#
# Or create a new one (default), requiring organization_id :
# metal_create_project        = true
# metal_organization_id       = "..."
