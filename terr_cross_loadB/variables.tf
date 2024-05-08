variable "regions" {
  description = "List of regions and its cidr"
  type        = map(any)
  default = {
    region1 = {
      location = "centralus"
      cidr     = "10.10.0.0/21"
    }
    region2 = {
      location = "eastus2"
      cidr     = "10.20.0.0/21"
    }
    region3 = {
      location = "canadacentral"
      cidr     = "10.30.0.0/21"
    }
  }
}

variable "adminuser" {
  description = "adminuser"
  type        = string
  default     = "azureadmin"
}