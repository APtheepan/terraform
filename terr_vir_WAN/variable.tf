variable "regions" {
  description = "List of regions to deploy the resources"
  type        = map(any)
  default = {
    region1 = {
      location               = "centralus"
      virtual_wan_hub_prefix = "10.10.0.0/21"
      address_space          = "10.10.8.0/21"
    }
    region2 = {
      location               = "eastus2"
      virtual_wan_hub_prefix = "10.10.0.0/21"
      address_space          = "10.20.8.0/21"
    }
  }
}
variable "vnet_subnet_region1_vm" {
  description = "Subnet for VM in region1"
  type        = string
  default     = "10.10.11.0/24"

}

variable "vnet_subnet_region1_bastion" {
  description = "Subnet for VM in region1"
  type        = string
  default     = "10.10.12.0/24"

}

variable "vnet_subnet_region2_vm" {
  description = "Subnet for VM in region1"
  type        = string
  default     = "10.20.11.0/24"

}
variable "vnet_subnet_region2_bastion" {
  description = "Subnet for VM in region1"
  type        = string
  default     = "10.20.12.0/24"

}

variable "vm_size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "adminuser"
}

variable "environment_tag" {
  description = "Environment for the resources"
  type        = string
  default     = "Theepan_vWAN_lab"

}
