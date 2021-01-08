
terraform {
  required_version = ">= 0.13"
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    metal = {
      source  = "equinix/metal"
      version = "1.0.0"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
