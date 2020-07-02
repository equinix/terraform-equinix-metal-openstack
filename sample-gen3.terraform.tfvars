# 
# Packet 3rd Generation Hardware
#
# This configuration file will override the defaults in vars.tf
#
# c3.medium - 24 Core AMD EPYC 7402P, 64GB, 960GB, 2x10Gbps
# s3.xlarge - 24 Core Intel 4214, 192GB, 1.9TB, 2x10Gbps
packet_controller_type      = "c3.medium.x86"
packet_dashboard_type       = "c3.medium.x86"
packet_compute-x86_type     = "s3.xlarge.x86"
openstack_compute-arm_count = 1
openstack_compute-x86_count = 1

packet_facilities = ["dfw2"]
