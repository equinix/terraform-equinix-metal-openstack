variable "metal_auth_token" {}

module "openstack" {
  source                   = "../.."
  equinix_metal_auth_token = var.metal_auth_token
}

output "OpenStack" {
  value = "Dashboard: ${module.openstack.Horizon_dashboard_via_IP}\n\t${module.openstack.Horizon_dashboard_via_IP6}"
}

provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = module.openstack.OpenStack_admin_pass
  auth_url    = module.openstack.OpenStack_API_Endpoint
  region      = "RegionOne"
}

resource "openstack_identity_project_v3" "terraform_project" {
  name        = "terraform_project"
  description = "An OpenStack on Equinix Metal project managed by Terraform."
}

output "test_project" {
  value = "Project ${openstack_identity_project_v3.terraform_project.name} created."
}
