output "Cloud_ID_Tag" {
  value = random_id.cloud.hex
}

output "Controller_Type" {
  value = packet_device.controller.plan
}

output "Compute_x86_Type" {
  value = packet_device.compute-x86.*.plan
}

output "Compute_ARM_Type" {
  value = packet_device.compute-arm.*.plan
}

output "Compute_x86_IPs" {
  value = packet_device.compute-x86.*.access_public_ipv4
}

output "Compute_ARM_IPs" {
  value = packet_device.compute-arm.*.access_public_ipv4
}

output "Horizon_dashboard_via_IP" {
  value = "http://${packet_device.dashboard.access_public_ipv4}/horizon/ admin/ADMIN_PASS"
}

output "Horizon_dashboard_via_IP6" {
  value = "http://[${packet_device.dashboard.access_public_ipv6}]/horizon/ admin/ADMIN_PASS"
}

output "Controller_SSH" {
  value = "ssh root@${packet_device.controller.access_public_ipv4} -i ${var.cloud_ssh_key_path}"
}

output "Controller_SSH6" {
  value = "ssh root@${packet_device.controller.access_public_ipv6} -i ${var.cloud_ssh_key_path}"
}

output "Controller_Provider_Private_IPv4" {
  value = packet_ip_attachment.controller_private_ipv4.cidr_notation
}

output "Controller_Provider_Public_IPv6" {
  value = packet_ip_attachment.controller_public_ipv6.cidr_notation
}

#output "Horizon dashboard via DNS" {
#  value = "http://${dnsimple_record.dashboard-dns.hostname}/horizon/ admin/ADMIN_PASS"
#}
#
#output "Controller SSH via DNS" {
#  value = "ssh root@${dnsimple_record.controller-dns.hostname} -i ${var.cloud_ssh_key_path}"
#}
