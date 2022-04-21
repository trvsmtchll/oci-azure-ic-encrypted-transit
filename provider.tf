terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "2.21.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.1.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "4.71.0"
    }
  }
}

provider "aviatrix" {
  controller_ip = var.controller_ip
  username      = var.username
  password      = var.password
}

provider "azurerm" {
  features {}
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
