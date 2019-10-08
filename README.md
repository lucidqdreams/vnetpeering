# AzureStack-S2SVPN

***This template is intended for use in an Azure Stack environment.***

The purpose of this template is to demonstrate the ability to interconnect two Azure Stack VNets to one another within the same Azure Stack environment.  It is currently not possible to inteconnect Azure Stack VNets to one another using the built-in Virtual Network Gateway:  https://docs.microsoft.com/en-us/azure-stack/user/azure-stack-network-differences.  Support for this is coming soon but for now one must use NVA appliances to create a VPN tunnel between two Azure Stack VNets.  In this template, two Windows Server 2016 VMs are deployed with RRAS installed.  The two RRAS servers are configured to implement a S2SVPN IKEv2 tunnel between two VNETs.  The appropriate NSG and UDR rules are created to allow routing between the subents on each VNET designated as 'internal'.  

![alt text](https://github.com/lucidqdreams/vnetpeering/blob/master/Images/Overview.jpg)

Requirements:

- ASDK or Azure Stack Integrated System with latest updates applied. 
- Required Azure Stack Marketplace items:
    -  Windows Server 2016 Datacenter (latest build recommended)
	-  Custom Script Extension
- A Network Security Group is applied to the template Tunnel Subnet.  It is recommended to secure the internal subnet in each VNet with an additional NSG.
- An RDP Deny rule is applied to the Tunnel NSG and will need to be set to allow if you intend to access the VMs via the Public IP address
- This solution does not take into account DNS resolution
- The combination of VNet name and vmName must be less than 15 characters
	
This template provides default values for VNet naming and IP addressing.  It requires a password for the administrator (rrasadmin) and also offers the ability to use your own storage blob with SAS token.  Be careful to keep these values within legal ranges as deployment may fail.  The powershell DSC package is executed on each RRAS VM and installing routing and all required dependent services and features.  This DSC can be customized further if needed.  The custom script extension run the following script and Add-Site2Site.ps1 configures the VPNS2S tunnel between the two RRAS servers with a shared key.  You can view the detailed output from the custom script extension to see the results of the VPN tunnel configuration

![alt text](https://github.com/lucidqdreams/vnetpeering/blob/master/Images/S2SVPNTunnelDetailed.jpg)

There are two outputs on this template INTERNALSUBNETREFVNET1 and INTERNALSUBNETREFVNET2 which are the Resource IDs for the internel subnets, if you want to use this in a pipeline style deployment pattern.

NOTE, When deleting the resource group, currently on (1907) you have to manually detach the NSG's from the tunnel subnet to ensure the delete resource group completes
