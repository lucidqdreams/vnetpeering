# azurestack-rras

***This template is intended for use in an Azure Stack environment.***

The purpose of this template is to demonstrate the ability to interconnect two Azure Stack VNets to one another within the same Azure Stack environment.  It is currently not possible to inteconnect Azure Stack VNets to one another using the built-in Virtual Network Gateway:  https://docs.microsoft.com/en-us/azure-stack/user/azure-stack-network-differences.  Support for this is coming soon but for now one must use NVA appliances to create a VPN tunnel between two Azure Stack VNets.  In this template, two Windows Server 2016 VMs are deployed with RRAS installed.  The two RRAS servers are configured to implement a S2SVPN IKEv2 tunnel between two VNETs.  The appropriate NSG and UDR rules are created to allow routing between the subents on each VNET designated as 'internal'.  

![alt text](https://github.com/kevinsul/azurestack-rras/blob/master/stack-rras1.JPG)

Requirements:

- ASDK or Azure Stack Integrated System with latest updates applied.
- Required Azure Stack Marketplace items:
    -  Windows Server 2016 Datacenter (latest build recommended)
    -  PowerShell DSC 
	-  Custom Script Extension
    
This template provides default values for VNet naming and IP addressing.  It requires a password for the administrator (rrasadmin) and also offers the ability to use your own storage blob with SAS token.  Be careful to keep these values within legal ranges as deployment may fail.  The powershell DSC script that is executed via the custom script extension on each RRAS VM.  This script installs RRAS and all required dependent services and features, and configures the IKEv2 IPSec tunnel between the two RRAS servers with a shared key.

![alt text](https://github.com/lucidqdreams/vnetpeering/blob/master/Images/S2SVPNTunnelDetailed2.jpg)