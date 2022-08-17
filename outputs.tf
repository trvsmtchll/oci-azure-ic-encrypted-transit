output "azure_transit_gateway" {
  value     = module.azure_transit_1
  sensitive = true
}

output "oci_transit_gateway" {
  value     = module.oci_transit_1
  sensitive = true
}

output "interconnect" {
  value = module.interconnect
}

output "test_vm" {
  value = module.azure_test_vm
}