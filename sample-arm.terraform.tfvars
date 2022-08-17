# 
# Equinix Metal 2nd Generation ARM Hardware
#
# This configuration file will override the defaults in vars.tf
#
# c2.large.arm - 32 Core Ampere eMAG, 128GB, 480GB, 2x10Gbps
#
metal_controller_type       = "c2.large.arm"
metal_dashboard_type        = "c2.large.arm"
metal_compute-arm_type      = "c2.large.arm"
openstack_compute-arm_count = 1
openstack_compute-x86_count = 0

metal_facilities = ["ewr1"]

# Use an existing project:
# metal_create_project        = false
# metal_project_id           = "..."
#
# Or create a new one (default), requiring organization_id :
# metal_create_project        = true
# metal_organization_id       = "..."
