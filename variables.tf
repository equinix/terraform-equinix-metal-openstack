variable "metal_auth_token" {
  description = "Your metal API key"
}

# for best results deploy all hosts in the same facility - list a single facility
variable "metal_facilities" {
  description = "Metal facilities: US East(ewr1), US West(sjc1), Tokyo (nrt1) or EU(ams1). Default: ewr1"
  default     = ["sjc1"]
}

variable "metal_project_id" {
  type        = string
  default     = "null"
  description = "Equinix Metal Project ID"
}

variable "metal_organization_id" {
  type        = string
  default     = "null"
  description = "Equinix Metal Organization ID"
}

variable "metal_create_project" {
  type        = bool
  default     = true
  description = "Create a Metal Project if this is 'true'. Else use provided 'metal_project_id'"
}

variable "metal_project_name" {
  type        = string
  default     = "terraform-metal-openstack"
  description = "The name of the Metal project if 'create_project' is 'true'."
}

variable "metal_controller_type" {
  description = "Instance type of OpenStack controller"
  default     = "c3.medium.x86"
}

variable "metal_dashboard_type" {
  description = "Instance type of OpenStack dashboard"
  default     = "c3.medium.x86"
}

variable "metal_compute-x86_type" {
  description = "Instance type of OpenStack x86 compute nodes"
  default     = "c3.medium.x86"
}

variable "openstack_compute-x86_count" {
  description = "Number of OpenStack x86 compute nodes to deploy"
  default     = 1
}

variable "metal_compute-arm_type" {
  description = "Instance type of OpenStack ARM compute nodes"
  default     = "c2.large.arm"
}

variable "openstack_compute-arm_count" {
  description = "Number of OpenStack ARM compute nodes to deploy"
  default     = 0
}

variable "create_dns" {
  description = "If set to true, DNSSimple will be setup"
  default     = false
}

