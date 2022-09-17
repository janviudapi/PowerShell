$vNetName = 'global_vnet_eastus'
$resourceGroupName = 'vcloud-lab.com'
$location = 'eastus'
$AddressPrefix = @('10.10.0.0/16')
$subnet01Name = 'prod01-10.10.1.x'
$subnet01AddressPrefix = '10.10.1.0/24'

#Create new Azure Virtual Network without subnet
New-AzVirtualNetwork -Name $vNetName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix $AddressPrefix

#Get existing Azure Virtual Network information
$azvNet = Get-AzVirtualNetwork -Name $vNetName -ResourceGroupName $resourceGroupName
Add-AzVirtualNetworkSubnetConfig -Name $subnet01Name -AddressPrefix $subnet01AddressPrefix -VirtualNetwork $azvNet 

#Make changes to vNet
$azvNet | Set-AzVirtualNetwork