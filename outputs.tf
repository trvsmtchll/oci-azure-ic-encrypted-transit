output "azure_transit_gateway" {
  value = module.azure_transit_1.azure_vnet_name
}

output "oci_transit_gateway" {
  value = module.oci_transit_1.transit_gateway.gw_name
}

output "interconnect" {
  value = module.interconnect
}
