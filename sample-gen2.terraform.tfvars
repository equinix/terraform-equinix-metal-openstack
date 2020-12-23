# 
# Packet 2nd Generation Hardware
#
# This configuration file will override the defaults in vars.tf
#
# c2.medium - 24 Core AMD EPYC 7401p, 64GB, 960GB, 2x10Gbps
# n2.xlarge - 28 Core Xeon Gold 5120, 384GB, 3.8TB, 4x10Gbps
#
metal_controller_type       = "c2.medium.x86"
metal_dashboard_type        = "c2.medium.x86"
metal_compute-x86_type      = "n2.xlarge.x86"
openstack_compute-arm_count = 1
openstack_compute-x86_count = 1

metal_facilities = ["dfw2"]

