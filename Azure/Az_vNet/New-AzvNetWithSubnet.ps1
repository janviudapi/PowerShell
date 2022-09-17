#Connect Azure with PowerShell
Connect-AzAccount

$vNetName = 'global_vnet_eastus'
$resourceGroupName = 'vcloud-lab.com'
$location = 'eastus'
$AddressPrefix = @('10.10.0.0/16')
$subnet01Name = 'prod02-10.10.1.x'
$subnet01AddressPrefix = '10.10.1.0/24'

#Create new Azure Virtual Network Subnet configuration
$subnet01 = New-AzVirtualNetworkSubnetConfig -Name $subnet01Name -AddressPrefix $subnet01AddressPrefix

#Create new Azure Virtual Network with above subnet configuration
New-AzVirtualNetwork -Name $vNetName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix $AddressPrefix -Subnet $subnet01

#######################################
#Remove Azure Virtual Network
Remove-AzVirtualNetwork -Name $vNetName -ResourceGroupName $resourceGroupName
