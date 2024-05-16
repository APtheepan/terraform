The Cross Region Load Balancer gives a number of key features that extend the functionality of Azure’s Load Balancers 
across multiple Regions, with a focus on Global Availability. Further this design includes Ultra low latancy, IP controls, High avalability and etc.
![Cross-Region1-e1689233079780-1024x952](https://github.com/APtheepan/terraform/assets/77774872/3b6004b9-6fc9-4dea-81cd-896099ff6870)

This design features
1) Resource group created in 3 region2
2) VM paswords has been secured with the key vault.
3) Nics for VMs
4) VNets, Subnets, and NSGs – note that Standard SKU Load Balancers are secure by default, so require an NSG to allow inbound access
5) A Cross-Region (Global Load Balancer) that balances traffic across the 3 Regional Load Balancers.

