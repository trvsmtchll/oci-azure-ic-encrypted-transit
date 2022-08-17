### Aviatrix

variable "username" {
  type    = string
  default = ""
}

variable "password" {
  type    = string
  default = ""
}

variable "controller_ip" {
  type    = string
  default = ""
}

### Interconnect
// Module inputs can be found here https://github.com/maxjahn/terraform-oci-azure-interconnect
variable "az_gw_subnet_cidr" {
  description = "VNG gateway cidr"
  default     = "10.1.80.0/24"
}

variable "az_expressroute_peering_location" {
  description = "Peering location for Azure"
  default     = "Phoenix" # "Washington DC"
}

variable "interconnect_peering_net" {
  description = "Peering network for interconnect"
  default     = "10.99.0.0/24"
}

variable "enable_service_transit_routing" {
  default = 0
}

variable "az_expressroute_sku" {
  default = "Standard"
}

variable "az_expressroute_bandwidth" {
  default = 1000
}

variable "oci_fastconnect_bandwidth" {
  default = "1 Gbps"
}

### Azure

variable "azure_account_name" {
  description = "Name of the Azure Access Account on Aviatrix Controller"
  default     = "TM-Azure"
}

variable "azure_transit_cidr1" {
  default = "10.1.0.0/16"
}

variable "azure_region1" {
  default = "West US 3" #"East US"
}

variable "azure_gw_size" {
  description = "Gateway size in Aviatrix"
  default     = "Standard_D3_v2"
}

### OCI

variable "oci_compartment_ocid" {
  description = "Needed by the interconnect module - same ocid as Aviatrix Oracle Access Account and OCI TF provider"
  default     = ""
}

variable "oci_transit_cidr1" {
  default = "10.2.0.0/16"
}

variable "oci_region1" {
  default = "us-phoenix-1" #"us-ashburn-1"
}

variable "oci_gw_size" {
  description = "Gateway size in Aviatrix"
  default     = "VM.E4.Flex.4.16"
}

variable "oci_account_name" {
  description = "Name of the OCI Access Account on Aviatrix Controller"
  default     = "TM-OCI"
}

variable "ssh_public_key" {
  description = "For OCI VM"
  default = ""
}

### Variables required by the OCI Provider
variable "tenancy_ocid" {}

variable "user_ocid" {}

variable "fingerprint" {}

variable "region" {}

variable "private_key_path" {}

variable "compartment_ocid" {}