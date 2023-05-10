output "Cloud_ID_Tag" {
  description = "Project Tag for this OpenStack Cloud"
  value       = random_id.cloud.hex
}

output "Controller_Type" {
  description = "Controller Node Plan"
  value       = equinix_metal_device.controller.plan
}

output "Compute_x86_Type" {
  description = "x86 Compute Node Plan"
  value       = equinix_metal_device.compute-x86.*.plan
}

output "Compute_ARM_Type" {
  description = "ARM Compute Node Plan"
  value       = equinix_metal_device.compute-arm.*.plan
}

output "Compute_x86_IPs" {
  description = "x86 Compute Node Addresses"
  value       = equinix_metal_device.compute-x86.*.access_public_ipv4
}

output "Compute_ARM_IPs" {
  description = "ARM Compute Node Addresses"
  value       = equinix_metal_device.compute-arm.*.access_public_ipv4
}

output "OpenStack_API_Endpoint" {
  description = "OpenStack IPv4 API Endpoint"
  value       = "http://${equinix_metal_device.controller.access_public_ipv4}:5000/v3"
}

output "OpenStack_API_Endpoint_ipv6" {
  description = "OpenStack IPv6 API Endpoint"
  value       = "http://[${equinix_metal_device.controller.access_public_ipv6}]:5000/v3"
}

output "OpenStack_admin_pass" {
  description = "OpenStack Admin User Password"
  value       = random_password.os_admin_password.result
  sensitive   = true
}

output "Horizon_dashboard_via_IP" {
  description = "Access OpenStack Dashboard over IPv4"
  value       = "http://${equinix_metal_device.dashboard.access_public_ipv4}/horizon/ default/admin/${random_password.os_admin_password.result}"
}

output "Horizon_dashboard_via_IP6" {
  description = "Access OpenStack Dashboard over IPv6"
  value       = "http://[${equinix_metal_device.dashboard.access_public_ipv6}]/horizon/ default/admin/${random_password.os_admin_password.result}"
}

output "Controller_SSH" {
  description = "SSH command to access OpenStack controller instance over IPv4"
  value       = "ssh root@${equinix_metal_device.controller.access_public_ipv4} -i ${local_file.cluster_private_key_pem.filename}"
}

output "Controller_SSH6" {
  description = "SSH command to access OpenStack controller instance over IPv6"
  value       = "ssh root@${equinix_metal_device.controller.access_public_ipv6} -i ${local_file.cluster_private_key_pem.filename}"
}

output "Controller_Provider_Private_IPv4" {
  description = "OpenStack Contoller IPv4 Address"
  value       = equinix_metal_ip_attachment.controller_private_ipv4.cidr_notation
}

output "Controller_Provider_Public_IPv6" {
  description = "OpenStack Contoller IPv6 Address"
  value       = equinix_metal_ip_attachment.controller_public_ipv6.cidr_notation
}

#output "Horizon dashboard via DNS" {
#  value = "http://${dnsimple_record.dashboard-dns.hostname}/horizon/ admin/ADMIN_PASS"
#}
#
#output "Controller SSH via DNS" {
#  value = "ssh root@${dnsimple_record.controller-dns.hostname} -i ${var.cloud_ssh_key_path}"
#}
