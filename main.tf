# Azure Transit Module
module "azure_transit_1" {
  source        = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version       = "2.2.0"
  cloud         = "azure"
  region        = var.azure_region1
  cidr          = var.azure_transit_cidr1
  account       = var.azure_account_name
  insane_mode   = true
  instance_size = var.azure_gw_size
}

# Azure Spoke Module
module "spoke_azure_1" {
  source        = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version       = "1.3.0"
  cloud         = "Azure"
  name          = "App1"
  cidr          = "10.3.0.0/20"
  region        = var.azure_region1
  account       = var.azure_account_name
  insane_mode   = true
  instance_size = var.azure_gw_size
  transit_gw    = module.azure_transit_1.transit_gateway.gw_name
}
# Oracle Transit Module
module "oci_transit_1" {
  source        = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version       = "2.2.0"
  cloud         = "oci"
  region        = var.oci_region1
  cidr          = var.oci_transit_cidr1
  account       = var.oci_account_name
  insane_mode   = true
  instance_size = var.oci_gw_size
}

# Oracle Spoke Module
module "spoke_oci_1" {
  source        = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version       = "1.3.0"
  cloud         = "oci"
  name          = "DB1"
  cidr          = "10.4.0.0/20"
  region        = var.oci_region1
  account       = var.oci_account_name
  insane_mode   = true
  instance_size = var.oci_gw_size
  transit_gw    = module.oci_transit_1.transit_gateway.gw_name
}

# OCI HPE Network Security Group
module "oci_network_sec_group_hpe" {
  source           = "./oci-vm-modules/network-security-groups"
  compartment_ocid = var.compartment_ocid
  nsg_display_name = "test-hpe-nsg"
  nsg_whitelist_ip = module.spoke_oci_1.vpc.cidr
  vcn_id           = module.spoke_oci_1.vpc.vpc_id
  vcn_cidr_block   = module.spoke_oci_1.vpc.cidr
}

# OCI HPE Test VM
module "hpe_flex_vm" {
  source                 = "./oci-vm-modules/flex-compute"
  vcn_id                 = module.spoke_oci_1.vpc.vpc_id
  subnet_id              = module.spoke_oci_1.vpc.public_subnets[1].subnet_id
  nsg_ids                = [module.oci_network_sec_group_hpe.nsg_id]
  compartment_ocid       = var.compartment_ocid
  ssh_public_key         = var.ssh_public_key
  display_name           = "test-avx-hpe-vm"
  instance_ocpus         = 4
  instance_memory_in_gbs = 16
  region                 = var.oci_region1
}

# Azure Test VM
module "azure_test_vm" {
  source                        = "Azure/compute/azurerm"
  resource_group_name           = module.spoke_azure_1.vpc.resource_group
  vm_hostname                   = "azure-avx-test-vm"
  nb_public_ip                  = 1
  remote_port                   = "22"
  vm_os_simple                  = "UbuntuServer"
  vnet_subnet_id                = module.spoke_azure_1.vpc.public_subnets[1].subnet_id
  delete_os_disk_on_termination = true
  custom_data                   = data.template_file.azure-init.rendered
  enable_ssh_key                = true
  ssh_key                       = "~/.ssh/id_rsa.pub"
  vm_size                       = "Standard_D4s_v3"
  tags = {
    environment = "avx-encrypted"
    name        = "azure-avx-test-vm"
  }
  depends_on = [module.spoke_azure_1]
}

data "template_file" "azure-init" {
  template = file("${path.module}/azure-vm-config/azure_bootstrap.sh")
}

# OCI <> Azure Interconnect Module
module "interconnect" {
  source                           = "maxjahn/azure-interconnect/oci"
  version                          = "1.0.0"
  oci_compartment_ocid             = var.oci_compartment_ocid
  oci_vcn_id                       = module.oci_transit_1.vpc.vpc_id
  az_resource_group_name           = module.azure_transit_1.vpc.resource_group
  az_vnet_name                     = module.azure_transit_1.vpc.name
  az_gw_subnet_cidr                = var.az_gw_subnet_cidr
  az_expressroute_peering_location = var.az_expressroute_peering_location
  interconnect_peering_net         = var.interconnect_peering_net
  enable_service_transit_routing   = var.enable_service_transit_routing
  az_expressroute_sku              = var.az_expressroute_sku
  az_expressroute_bandwidth        = var.az_expressroute_bandwidth
  oci_fastconnect_bandwidth        = var.oci_fastconnect_bandwidth
  depends_on = [
    module.azure_transit_1
  ]
}