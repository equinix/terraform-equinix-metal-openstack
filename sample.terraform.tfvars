# 
# Packet 2nd Generation ARM and x86 Hardware
#
# This configuration file will override the defaults in vars.tf
#
# c2.medium - 24 Core AMD EPYC 7401p, 64GB, 960GB, 2x10Gbps
# n2.xlarge - 28 Core Xeon Gold 5120, 384GB, 3.8TB, 4x10Gbps
# c2.large.arm - 32 Core Ampere eMAG, 128GB, 480GB, 2x10Gbps
#
packet_controller_type      = "c2.medium.x86"
packet_dashboard_type       = "c2.medium.x86"
packet_compute-arm_type     = "c2.large.arm"
packet_compute-x86_type     = "n2.xlarge.x86"
openstack_compute-arm_count = 1
openstack_compute-x86_count = 1

packet_facilities = ["sjc1"]
