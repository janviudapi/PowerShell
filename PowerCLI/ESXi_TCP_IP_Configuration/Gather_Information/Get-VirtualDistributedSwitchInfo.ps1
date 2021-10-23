#Created By: vJanvi
#WebSite: http://vcloud-lab.com
#Purpose: Gather information of Virtual Distributed Switch (VDS) from vCenter using VMware PowerCLI

$vdSwitch = Get-VDSwitch
foreach ($vds in $vdSwitch)
{
    $esxiList = @()
    $esxiServers = $vds.ExtensionData.Summary.HostMember
    if ($null -ne $esxiServers)
    {
        foreach ($esxi in $esxiServers)
        {
            $esxiList += Get-VMHost -Id $esxi | Select-Object -ExpandProperty Name
        }
    }

    <#
    $vdPortGroupList = @()
    $vdPortGroups = $vds.ExtensionData.Portgroup
    foreach ($vdportgroup in $vdPortGroups)
    {
        $vdPortGroupList += Get-VDPortgroup -Id $vdportgroup | Select-Object -ExpandProperty Name
    }
    #>
    
    $healthCheckConf1 = $vdSwitch.ExtensionData.Config.HealthCheckConfig[0] | ForEach-Object {"{0}: Enabled={1}, Interval={2}" -f $_.gettype().Name, $_.Enable, $_.Interval}
    $healthCheckConf2 = $vdSwitch.ExtensionData.Config.HealthCheckConfig[1] | ForEach-Object {"{0}: Enabled={1}, Interval={2}" -f $_.gettype().Name, $_.Enable, $_.Interval}
    
    [PSCustomObject]@{
        Name = $vds.Name
        Datacenter = $vds.Datacenter
        Version = $vds.Version
        NumHosts = $vds.ExtensionData.Summary.NumHosts
        HostMembers = $esxiList -join ', '
        PortGroupName = $vds.ExtensionData.Summary.PortgroupName -join ', '
        NumUplinkPorts = $vds.NumUplinkPorts
        UplinkPortGroup = (Get-VDPortgroup -Id $vds.ExtensionData.Config.UplinkPortgroup).Name
        UplinkPortName = $vds.ExtensionData.Config.UplinkPortPolicy.UplinkPortName -join ', '
        #VDPortGroups = $vdPortGroupList -join ', '
        NumPorts = $vds.NumPorts
        Mtu = $vds.Mtu
        Vendor = $vds.Vendor
        ContactName = $vds.Contactname
        ContactDetails = $vds.ContactDetails
        LinkDiscoveryProtocol = $vds.LinkDiscoveryProtocol
        LinkDiscoveryProtocolOperation = $vds.LinkDiscoveryProtocolOperation
        VlanConfiguration = $vds.VlanConfiguration
        Notes = $vds.Notes
        Id = $vds.Id
        Folder = $vds.Folder
        CreateTime = $vds.ExtensionData.Config.CreateTime
        healthCheckConf1 = $healthCheckConf1
        healthCheckConf2 = $healthCheckConf2
        OverallStatus = $vds.ExtensionData.OverallStatus
        MulticastFilteringMode = $vds.ExtensionData.Config.MulticastFilteringMode
        LacpApiVersion = $vds.ExtensionData.Config.LacpApiVersion
        NetworkResourceControlVersion = $vds.ExtensionData.Config.NetworkResourceControlVersion
        vCenterServer = ([System.Uri]$vds.ExtensionData.Client.ServiceUrl).Host #$vds.Uid.Split('@')[1].Split(':')[0]
    }
}