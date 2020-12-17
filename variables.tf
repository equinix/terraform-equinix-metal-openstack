variable "metal_auth_token" {
  description = "Your metal API key"
}

# for best results deploy all hosts in the same facility - list a single facility
variable "metal_facilities" {
  description = "Metal facilities: US East(ewr1), US West(sjc1), Tokyo (nrt1) or EU(ams1). Default: ewr1"
  default     = ["sjc1"]
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

variable "cloud_ssh_public_key_path" {
  description = "Path to your public SSH key path"
  default     = "./metal-key.pub"
}

variable "cloud_ssh_key_path" {
  description = "Path to your private SSH key for the project"
  default     = "./metal-key"
}

variable "create_dns" {
  description = "If set to true, DNSSimple will be setup"
  default     = false
}

