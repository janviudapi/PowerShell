#created by: janvi | vcloud-lab.com
#date created: 10 December 2021
#purpose: Gather Azure Virtual Network information in CSV file

$vNets = Get-AzVirtualNetwork

foreach ($vNet in $vNets) {
    $subnetList = @()
    foreach ($subnet in $vNet.Subnets) {
        $subnetList += "[ $($subnet.Name) | $($vNet.Subnets.AddressPrefix -join ', ') ] "
    }

    $vnetPeeringList = @()
    foreach ($vnetPeering in $vNet.VirtualNetworkPeerings) {
        $remoteVNET =  $vNet.VirtualNetworkPeerings.RemoteVirtualNetwork
        $remoteVNETName = ($remoteVNET | foreach-Object {Split-Path $_.Id -leaf}) -join ', '
        $remoteVNETAddressSpace = $vNet.VirtualNetworkPeerings.RemoteVirtualNetworkAddressSpace.AddressPrefixes -join ', '
        $vnetPeeringList += "[ $($vnetPeering.Name) | $($vnetPeering.PeeringState) | $remoteVNETName | $remoteVNETAddressSpace ] "
    }

    [PSCustomObject]@{
        Name = $vNet.Name
        ResourceGroupName = $vNet.ResourceGroupName
        Location = $vNet.Location
        Id = $vNet.Id
        AddressSpace =  $vNet.AddressSpace.AddressPrefixes -join ', '
        Subnets = $subnetList -join ', '
        VnetPeerings = $vnetPeeringList -join ', '
        EnableDdosProtection = $vNet.EnableDdosProtection
    }
}