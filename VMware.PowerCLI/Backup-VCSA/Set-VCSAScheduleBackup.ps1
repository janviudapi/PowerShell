<#
.SYNOPSIS
    Configures a weekly scheduled backup for vCenter Server Appliance to an SMB location.

.DESCRIPTION
    This script connects to a vCenter Server instance and creates a scheduled backup job
    that runs weekly on Sundays at 23:59 (vCenter local time). The backup will be stored
    at the specified SMB location with retention for 5 backups. The script backs up
    specified VCSA components ('common' and 'seat' by default).

.PARAMETER backupLocationType
    The type of backup location (default: 'SMB'). Currently only SMB is implemented.

.PARAMETER backupLocation
    The full SMB path for backup storage (e.g., 'smb://192.168.34.11/vc_backup').

.PARAMETER backupUser
    Username for authenticating to the SMB share.

.PARAMETER backupPassword
    Password for the SMB share user and backup encryption.

.PARAMETER vCenterServer
    Hostname or IP address of the vCenter Server (e.g., 'marvel.vcloud-lab.com').

.PARAMETER VCenterUser
    vCenter administrator account (e.g., 'administrator@vsphere.local').

.PARAMETER vCenterPassword
    Password for the vCenter administrator account.

.PARAMETER parts
    Array of VCSA components to back up (default: @("common","seat")).
    Valid components include: "common", "seat", "core", "database", "vmdir", "vmafd", "vmon", "stats_events_tasks".

.EXAMPLE
    .\Set-VCSAWeeklyBackup.ps1
    
    Uses all default parameters to configure backup:
    - vCenter: marvel.vcloud-lab.com
    - SMB: smb://192.168.34.11/vc_backup
    - Runs Sunday at 23:59
    - Retains 5 backups
    - Backs up common and seat components

.EXAMPLE
    .\Set-VCSAWeeklyBackup.ps1 `
        -vCenterServer "vcsa01.example.com" `
        -VCenterUser "admin@example.com" `
        -vCenterPassword "NewPass123!" `
        -backupLocation "smb://10.0.1.50/backups" `
        -backupUser "backupadmin" `
        -backupPassword "BackupPass456!" `
        -parts @("common", "core", "database")

    Configures a custom weekly backup to a different SMB location, backing up
    additional components (common, core, and database).

.NOTES
    Requirements:
    - VMware PowerCLI module (Install-Module VMware.PowerCLI)
    - Network connectivity between VCSA and SMB server
    - SMB share must be pre-configured with write access for backupUser

    Schedule Details:
    - Fixed to run weekly on Sunday at 23:59 (vCenter local time)
    - Retention fixed at 5 backups (oldest automatically purged)
    - Backup type: Full (based on specified components)

    Security Note:
    - Passwords are passed as plain text. For production use:
      1) Consider using Get-Credential for interactive input
      2) Use encrypted password files
      3) Utilize VMware's credential store

    Component Reference:
    - common:    Common services and configurations
    - seat:      Serviceability, Availability, and Telemetry
    - core:      vCenter core services
    - database:  vCenter database
    - vmdir:     VMware Directory Service
    - vmafd:     VMware Authentication Framework
    - vmon:      Service lifecycle manager
    - stats_events_tasks: Performance metrics, events, and tasks history

    Version: 1.0
    Last Updated: 2023-10-15
    Author: VMware Automation Team
#>
param(
    [string]$backupLocationType = 'SMB',
    [string]$backupLocation = 'smb://192.168.34.11/vc_backup',
    [string]$backupUser = 'vjanvi@vcloud-lab.com',
    [string]$backupPassword = 'Computer@123',
    [string]$vCenterServer = 'marvel.vcloud-lab.com',
    [string]$VCenterUser = 'administrator@vsphere.local',
    [string]$vCenterPassword = 'Computer@123',
    [string[]]$parts = @("common","seat")
)

Connect-CisServer -Server $vCenterServer -User $VCenterUser -Password $vCenterPassword
#Get-CisService -Name *backup*

$backupSchedSvc = Get-CisService -Name com.vmware.appliance.recovery.backup.schedules
#$backupJobSvc | Get-Member

$schedSpec = $backupSchedSvc.Help.create.schedule.Create()
$schedSpec = 'weekly'

#backup info
$backupSchedSpec = $backupSchedSvc.Help.create.spec.Create()
$backupSchedSpec.parts = $parts
$backupSchedSpec.location = $backupLocation
$backupSchedSpec.location_user = $backupUser
[VMware.VimAutomation.Cis.Core.Types.V1.Secret]$backupSchedSpec.location_password = $backupPassword
$backupSchedSpec.enable = $true

#schedule time (This is vCenter server time)
$recurSpec = $backupSchedSvc.Help.create.spec.recurrence_info.Create()
$recurSpec.days = @("Sunday")
$recurSpec.minute = '59'
$recurSpec.hour = '23'
$backupSchedSpec.recurrence_info = $recurSpec

#number of backups
$retentSpec = $backupschedsvc.help.create.spec.retention_info.Create()
$retentSpec.max_count = '5'
$backupSchedSpec.retention_info = $retentSpec
 
#create the backup schedule
try {
    $backupSchedSvc.create($schedSpec, $backupSchedSpec)
    Write-Host 'Backup schedule created Successfully'
}
catch {
    #{<#Do this if a terminating exception happens#>}
    Write-Host 'Backup schedule creation failed!'
}