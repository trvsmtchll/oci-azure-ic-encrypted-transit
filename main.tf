# Azure Transit Module
module "azure_transit_1" {
  source        = "terraform-aviatrix-modules/azure-transit/aviatrix"
  version       = "99.9.0"
  region        = var.azure_region1
  cidr          = var.azure_transit_cidr1
  account       = var.azure_account_name
  insane_mode   = true
  instance_size = var.azure_gw_size
  depends_on = [
    module.oci_transit_1
  ]
}

# Oracle Transit Module
module "oci_transit_1" {
  source        = "terraform-aviatrix-modules/oci-transit/aviatrix"
  version       = "99.9.0"
  region        = var.oci_region1
  cidr          = var.oci_transit_cidr1
  account       = var.oci_account_name
  insane_mode   = true
  instance_size = var.oci_gw_size
}

# OCI <> Azure Interconnect Module
module "interconnect" {
  source                           = "maxjahn/azure-interconnect/oci"
  version                          = "1.0.0"
  oci_compartment_ocid             = var.oci_compartment_ocid
  oci_vcn_id                       = module.oci_transit_1.vcn.vpc_id
  az_resource_group_name           = module.azure_transit_1.azure_rg
  az_vnet_name                     = module.azure_transit_1.vnet.name
  az_gw_subnet_cidr                = var.az_gw_subnet_cidr
  az_expressroute_peering_location = var.az_expressroute_peering_location
  interconnect_peering_net         = var.interconnect_peering_net
  enable_service_transit_routing   = var.enable_service_transit_routing
  az_expressroute_sku              = var.az_expressroute_sku
  az_expressroute_bandwidth        = var.az_expressroute_bandwidth
  oci_fastconnect_bandwidth        = var.oci_fastconnect_bandwidth
}
