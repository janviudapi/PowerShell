$vCenterServer = 'dccomics.vcloud-lab.com'
$vCenterUsername = 'administrator@vsphere.local'
$vCenterPassword = 'Computer@123'

$templateName = '_template_windows_2022'
$newVMName = 'vm01-jumpserver'
$vmHost = 'superman.vcloud-lab.com'
$wanNetworkName = 'VM Network'
$datastore = 'Daily-Planet01-6T'
$folder = 'VCF'
$osCustomizationSpecName = 'windows-os-custom-spec'
$wanIpAddress = '192.168.34.25'
$wanSubnetMask = '255.255.255.0'
$wanDefaultGateway = '192.168.34.1'
$wanDns = @('192.168.34.11')
#LAN network information
$lanNetworkName = 'Green_LAN_trunk_Nesting'
$lanIpAddress = '172.16.0.25'
$lanSubnetMask = '24'
$lanDefaultGateway = '172.16.0.1'
$lanDns = @('172.16.0.11')
$newVMGuestUser = 'administrator'
$newGuestPassword = 'Computer@123'

Import-Module VMware.VimAutomation.Core

Write-Host "- Login vCenter: $vCenterServer"
Connect-VIServer -Server $vCenterServer -User $vCenterUsername -Password $vCenterPassword | Out-Null

Write-Host "- Checks before cloning task" -BackgroundColor DarkCyan
try {
    $vmExist = Get-VM $newVMName -ErrorAction Stop
    if ($vmExist)
    {
        Write-Host "  - VMName exists: $newVMName" -BackgroundColor DarkCyan
        break
    }
    $tempOSCustomSpec = Get-OSCustomizationSpec -Name "Temp_$osCustomizationSpecName" -ErrorAction Stop
    if ($tempOSCustomSpec)
    {
        Get-OSCustomizationSpec -Name "Temp_$osCustomizationSpecName" | Remove-OSCustomizationSpec 
    }
}
catch {
    $_.Exception.GetType().FullName
    Write-Host "  - VMName not exist: $newVMName or OS customization spec not exist" -BackgroundColor DarkCyan
}

Write-Host "- Check existing configuration Template and Os Customiziation Spec"
$template = Get-Template -Name $TemplateName
$baseSpec = Get-OSCustomizationSpec -Name $osCustomizationSpecName

Write-Host "- Create temporary Os Customiziation Spec"
$tempSpec = $baseSpec | New-OSCustomizationSpec -Name "Temp_$osCustomizationSpecName" -Type NonPersistent
Write-Host "- Set IP addres to temporary Os Customiziation Spec"
$tempSpec | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $wanIpAddress -SubnetMask $wanSubnetMask -DefaultGateway $wanDefaultGateway -Dns $wanDns | Out-Null

Write-Host "- Start Cloning new virtual machine: $newVMName"
$newVM = New-VM -Name $newVMName -VMHost $vmHost -Location $folder -Template $template -OSCustomizationSpec $tempSpec -NetworkName $wanNetworkName -Datastore $datastore -DiskStorageFormat Thin
Write-Host "- Poweron virtual machine: $newVMName"
$newVM | Start-VM | Out-Null
Start-Sleep -Seconds 90

Write-Host "- Remove temporary customization spec: Temp_$osCustomizationSpecName"
Get-OSCustomizationSpec -Name "Temp_$osCustomizationSpecName" | Remove-OSCustomizationSpec -Confirm:$false | Out-Null

Write-Host "- Os Customization in Progress | Test Ping $ipAddress"
while (-not(Test-Connection -IPv4 $wanIpAddress -Quiet -Count 1))
{
    '\','|','/','-','*' | ForEach-Object {
        Write-Host "`r- VM configuration in progress: $_ " -NoNewline
        Start-Sleep -Milliseconds 200
    }
}
Write-Host "`r- VM is created | Waiting 2.5 minutes to complete sysprep and reboot"
Start-Sleep -Seconds 150

Write-Host "- Add second network adapter in portgroup: $lanNetworkName"
$newVM | New-NetworkAdapter -NetworkName $lanNetworkName -WakeOnLan -StartConnected -Type Vmxnet3 | Out-Null

$mask = [IPAddress]$lanSubnetMask
$prefix = ([Convert]::ToString([uint32]$mask.Address,2) -replace '0').Length

$ethName = 'Ethernet1'
$scriptText = @"
New-NetIPAddress -InterfaceAlias $ethName  -IPAddress $lanIpAddress -PrefixLength $prefix -DefaultGateway $lanDefaultGateway
Set-DnsClientServerAddress -InterfaceAlias $ethName -ServerAddresses $lanDns
route add 10.10.10.0 mask 255.255.255.0 172.16.0.1
route add 10.10.20.0 mask 255.255.255.0 172.16.0.1
"@

Write-Host '- Configure VM settings'
$newVM | Invoke-VMScript -GuestUser $newVMGuestUser -GuestPassword $newGuestPassword -ScriptText $scriptText -ScriptType Powershell

Write-Host "- Logout vCenter: $vCenterServer"
Disconnect-VIServer -Server * -Confirm:$false
