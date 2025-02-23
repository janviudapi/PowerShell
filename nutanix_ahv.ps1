#Install-Module -Name Nutanix.Cli -Scope CurrentUser -Confirm:$false -Force

Import-Module Nutanix.Cli -Prefix NX
Import-Module Nutanix.Prism.PS.Cmds -Prefix NX
Import-Module Nutanix.Prism.Common -Prefix NX

$prismIP = "1xx.xx.xxx.xxx"
$username = "admin"
$password = 'xxxx@xxxxxxxx'

$secureString = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $secureString)

Connect-NXPrismCentral -Server $prismIP -UserName $username -AcceptInvalidSSLCerts -ForcedConnection -Password $secureString # $credentials $credentials

#-Name ind-mhp1v96w202
Get-NXVM | Select-Object vmName,hostName,uuid,@{N='memoryCapacityGB'; E={[system.math]::Round(($_.memoryCapacityInBytes /1024 /1024 /1024),2)}},`
@{N='ipAddresses'; E={$_.ipAddresses -join ','}},`
powerState,description,`
@{N='VMNIC_Count'; E={$_.virtualNicUuids.Count}},pcHostName, `
@{N='diskCapacityGB'; E={[system.math]::Round(($_.diskCapacityInBytes /1024 /1024 /1024),2)}}, `
@{N='memoryReservedCapacityGB'; E={[system.math]::Round(($_.memoryReservedCapacityInBytes /1024 /1024 /1024),2)}} ,`
@{N='VirtualDiskCount'; E={$_.nutanixVirtualDiskUuids.Count}}, `
acropolisVm,vmType,hypervisorType,clusterUuid,runningOnNdfs, @{N='vdiskFilePaths'; E={$_.vdiskFilePaths -join ','}} | Export-Csv -NoTypeInformation c:\temp\nutanixinv-19-01.csv

# Install-Module -Name TSR.Nutanix.V3.PowerShell

# Connect-NutanixV3PrismServer -Server $prismIP -Credential $credential

# Get-NutanixV3Vm | select -expandproperty status | select -ExpandProperty resources 

