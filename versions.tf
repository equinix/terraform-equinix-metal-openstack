
terraform {
  required_version = ">= 1.0"
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    equinix = {
      source  = "equinix/equinix"
      version = "~> 1.14"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  provider_meta "equinix" {
    module_name = "equinix-metal-openstack"
  }
}
