<#
.SYNOPSIS
    Performs a vCenter Server Appliance (VCSA) backup using PowerCLI.

.DESCRIPTION
    This script connects to a vCenter Server Appliance, configures a backup
    specification for an SMB share, and initiates a backup job. It then monitors
    the backup progress and reports its status.

.PARAMETER VCenterServer
    The hostname or IP address of the vCenter Server Appliance.

.PARAMETER VCenterUser
    The username for connecting to vCenter Server (e.g., administrator@vsphere.local).

.PARAMETER VCenterPassword
    The password for connecting to vCenter Server. It's recommended to use
    `Get-Credential` for secure input in interactive sessions.

.PARAMETER BackupLocationType
    The type of backup location (e.g., 'SMB', 'FTP', 'HTTP', 'HTTPS').

.PARAMETER BackupLocation
    The URL for the backup location (e.g., 'smb://192.168.34.11/vc_backup').
    Must match the BackupLocationType.

.PARAMETER BackupUser
    The username for authenticating to the backup location.

.PARAMETER BackupPassword
    The password for authenticating to the backup location and for encrypting
    the backup data. It's recommended to use `Get-Credential` for secure input.

.PARAMETER BackupComment
    (Optional) A comment to associate with the backup job.

.PARAMETER BackupParts
    (Optional) An array of strings specifying which parts of the VCSA to back up.
    Defaults to @("common", "seat") as per original script. For a standard full
    backup, you often don't need to specify 'parts'.

.NOTES
    - Requires VMware PowerCLI to be installed.
    - Ensure the SMB share (BackupLocation) is accessible from the VCSA and
      the BackupUser has write permissions to it.
    - The BackupPassword is used for encrypting the backup data.
    - The 'parts' specified (@("common", "seat")) might be specific to a
      particular VCSA version or custom configuration. For a standard full backup,
      you often don't need to specify 'parts' or use a more comprehensive list
      like ("common", "core", "database", "vmdir", "vmafd", "vmon") for advanced scenarios.
      Confirm the correct 'parts' for your VCSA version if you encounter issues.
    - This script uses basic authentication for vCenter connection. For production,
      consider more secure methods like OAuth 2.0 where applicable.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$VCenterServer,

    [Parameter(Mandatory=$true)]
    [string]$VCenterUser,

    [Parameter(Mandatory=$true)]
    [string]$VCenterPassword,

    [Parameter(Mandatory=$true)]
    [string]$BackupLocationType,

    [Parameter(Mandatory=$true)]
    [string]$BackupLocation,

    [Parameter(Mandatory=$true)]
    [string]$BackupUser,

    [Parameter(Mandatory=$true)]
    [string]$BackupPassword,

    [string]$BackupComment = "Scheduled vCenter Backup - $(Get-Date -Format 'yyyyMMdd_HHmmss')",

    [string[]]$BackupParts = @("all", "common", "seat") # all, common, seat, stats_events_tasks, core
)

# $backupLocationType = 'SMB'
# $backupLocation = 'smb://192.168.34.11/vc_backup' 
# $backupUser = 'vjanvi@vcloud-lab.com'
# $backupPassword = 'Computer@123'

Connect-CisServer -Server $VCenterServer -User $VCenterUser -Password $VCenterPassword
    
$backupService = Get-CisService com.vmware.appliance.recovery.backup.job
$backupSpec = $backupService.Help.Create.piece.Create()
$backupSpec.location_type = $backupLocationType
$backupSpec.location = $backupLocation
$backupSpec.location_user = $backupUser
[VMware.VimAutomation.Cis.Core.Types.V1.Secret]$backupSpec.location_password = $backupPassword
[VMware.VimAutomation.Cis.Core.Types.V1.Secret]$backupSpec.backup_password = $backupPassword
$backupSpec.comment = "My vCenter Server backup"
$backupSpec.parts = @("common", "seat")

$backupJob = $backupService.create($backupSpec)
Write-Host "- Backup initiated"
while ($backupJob.state -ne 'SUCCEEDED') {
    Start-Sleep -Seconds 30
    $backupJob = $backupService.get($backupJob.id)
    Write-Host "-- Backup job status: $($backupJob.id) - $($backupJob.state)"
}
Write-Host "- Backup completed"