<#
.SYNOPSIS
Renew ESXi certificates.

.DESCRIPTION
This script renews ESXi certificates for the specified vCenter server.

.PARAMETER Server
The server hostname or IP address.

.PARAMETER User
The username for authentication.

.PARAMETER Password
The password for authentication.

.EXAMPLE
.\Renew-ESXiCertificate.ps1 -Server 'marvel.vcloud-lab.com' -User 'Administrator@vsphere.local' -Password 'Computer@123'
#>

param (
    [Parameter(Mandatory = $false, HelpMessage = "Enter server hostname or IP address")]
    [string]$Server = 'marvel.vcloud-lab.com',

    [Parameter(Mandatory = $false, HelpMessage = "Enter username for authentication")]
    [string]$User = 'Administrator@vsphere.local',

    [Parameter(Mandatory = $false, HelpMessage = "Enter password for authentication")]
    [string]$Password = 'Computer@123',

    [Parameter(Mandatory = $false)]
    [switch]$Help,

    [Parameter(Mandatory = $false)]
    [switch]$VerboseOutput
)

if ($Help) {
    Get-Help $PSCommandPath
    return
}

if ($VerboseOutput) {
    $VerbosePreference = "Continue"
    Write-Verbose "Server: $Server"
    Write-Verbose "Username: $User"
}

try {
    Connect-VIServer -Server $Server -User $User -Password $Password -ErrorAction Stop
}
catch {
    Write-Host $error[0].exception.message -ForegroundColor Red
    return
}

$vmHosts = Get-VMHost

foreach ($vmHost in $vmHosts)
{
    if ($vmHost.ConnectionState -ne 'Connected')
    {
        continue
    }
    $dateBeforeRenew = (Get-View -Id $vmHost.ExtensionData.ConfigManager.CertificateManager).CertificateInfo
    $hostRef = $vmhost.ExtensionData.MoRef
    $certManager = Get-View -Id 'CertificateManager-certificateManager'
    $taskID = $certManager.CertMgrRefreshCertificates_Task(@($hostRef))
    $taskInfo = Get-Task -Id $taskID.ToString()
    while ($taskInfo.State -eq 'Running') {
        $taskInfo = Get-Task -Id $taskID.ToString()
    }
    $dateAfterRenew = (Get-View -Id $vmHost.ExtensionData.ConfigManager.CertificateManager).CertificateInfo
    $taskInfo | Select-Object @{Name='ESXi';Expression={$vmHost.Name}}, State, StartTime, FinishTime, PercentComplete, @{Name='Before_Renew';Expression={$dateBeforeRenew.NotBefore}}, @{Name='After_Renew';Expression={$dateAfterRenew.NotBefore}}
}

#foreach ($vmHost in $vmHosts)
#{
#    $hostParameters = New-Object VMware.Vim.ManagedObjectReference[] (1)
#    $hostParameters[0] = New-Object VMware.Vim.ManagedObjectReference
#    $hostParameters[0].Type = $vmHost.ExtensionData.MoRef.Type #'HostSystem'
#    $hostParameters[0].Value = $vmHost.ExtensionData.MoRef.Value #'host-3023'
#    $certificateManager = Get-View -Id 'CertificateManager-certificateManager'
#    $taskID = $certificateManager.CertMgrRefreshCertificates_Task($hostParameters)
#    $taskInfo = Get-Task -Id $taskID.ToString()
#    while ($taskInfo.State -eq 'Running') {
#        $taskInfo = Get-Task -Id $taskID.ToString()
#    }
#}
