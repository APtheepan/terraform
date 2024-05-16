This is a Terraform based demonstration of Azure Virtual WAN. The environment is designed to provide a simple 
foundation that you can add additional services (Gateways, Firewalls, etc.) into, allowing the demonstration of concepts 
and technologies. This lab has two options - with or without Azure Firewall, and is based on a two-region design.

What does this Lab Deploy?
This lab deploys the following Resources:

A Resource Group in two Azure Regions (based on variables)
A Virtual WAN in the Primary Region
A Virtual WAN Hub in two Azure Regions
A vNet in each Azure Region which is connected to the Virtual WAN Hub.
A Subnet and NSG in each of the above vNets.
A Subnet in each Region to be used for Azure Bastion.
Azure Bastion in each Region to allow for access to the VMs for Testing.
A Virtual Machine in each Azure Region (in the Regional vNets), to allow testing of Connectivity.
A Custom Script Extension that runs on both VMs to add a few testing Apps (using Chocolatey) and allows ICMP through Windows Firewall for testing.
