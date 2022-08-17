# 
# Equinix Metal 2nd Generation ARM and x86 Hardware
#
# This configuration file will override the defaults in vars.tf
#
# c2.medium - 24 Core AMD EPYC 7401p, 64GB, 960GB, 2x10Gbps
# n2.xlarge - 28 Core Xeon Gold 5120, 384GB, 3.8TB, 4x10Gbps
# c3.large.arm64 - 32 Core Ampere eMAG, 128GB, 480GB, 2x10Gbps
#
metal_controller_type       = "c3.medium.x86"
metal_dashboard_type        = "c3.medium.x86"
metal_compute-arm_type      = "c3.large.arm64"
metal_compute-x86_type      = "n3.xlarge.x86"
openstack_compute-arm_count = 1
openstack_compute-x86_count = 1

metal_facilities = ["sjc1"]

# Use an existing project:
# metal_create_project        = false
# metal_project_id           = "..."
#
# Or create a new one (default), requiring organization_id :
# metal_create_project        = true
# metal_organization_id       = "..."
