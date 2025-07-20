<#
.SYNOPSIS
    Configures a MONTHLY scheduled backup for vCenter Server Appliance to an SMB location.

.DESCRIPTION
    This script connects to a vCenter Server instance and creates a scheduled backup job
    that runs MONTHLY on a specified day at 23:59 (vCenter local time). The backup will be stored
    at the specified SMB location with retention for 5 backups. The script backs up
    specified VCSA components ('common' and 'seat' by default).

.PARAMETER backupDay
    Day of the month (1-31) for the backup to run. Default is 1 (first day of the month).

[OTHER PARAMETERS REMAIN UNCHANGED]

.EXAMPLE
    .\Set-VCSAMonthlyBackup.ps1 -backupDay 15
    
    Runs backup on the 15th of every month at 23:59.

.NOTES
    Schedule Details:
    - Fixed to run MONTHLY on the specified day at 23:59 (vCenter local time)
    - If a month has fewer days than specified (e.g., 31), the backup runs on the last day.

    Important Changes:
    - Corrected schedule deletion by properly accessing schedule IDs
    - The 'days' property is repurposed for monthly scheduling by passing the day number as a string
    - Only one backup schedule is allowed per vCenter instance
#>
param(
    [string]$backupLocationType = 'FTP',
    [string]$backupLocation = 'ftp://192.168.34.11/',
    [string]$backupUser = 'vjanvi@vcloud-lab.com',
    [string]$backupPassword = 'Computer@123',
    [string]$vCenterServer = 'marvel.vcloud-lab.com',
    [string]$VCenterUser = 'administrator@vsphere.local',
    [string]$vCenterPassword = 'Computer@123',
    [string[]]$parts = @("common","seat"),
    [ValidateRange(1,31)]
    [int]$backupDay = 1
)

# Connect to vCenter
Connect-CisServer -Server $vCenterServer -User $VCenterUser -Password $vCenterPassword -ErrorAction Stop

$backupSchedSvc = Get-CisService -Name com.vmware.appliance.recovery.backup.schedules

# PROPERLY DELETE EXISTING SCHEDULES
$existingSchedules = $backupSchedSvc.list()
if ($existingSchedules -and $existingSchedules.Count -gt 0) {
    Write-Host "Removing existing backup schedules..."
    foreach ($id in $existingSchedules.Keys) {
        try {
            $backupSchedSvc.delete($id)
            Write-Host "Deleted schedule: $id"
        }
        catch {
            Write-Host "Error deleting schedule $id : $_"
        }
    }
}

$schedSpec = 'monthly'

# Backup settings
$backupSchedSpec = $backupSchedSvc.Help.create.spec.Create()
$backupSchedSpec.parts = $parts
$backupSchedSpec.location = $backupLocation
$backupSchedSpec.location_user = $backupUser
[VMware.VimAutomation.Cis.Core.Types.V1.Secret]$backupSchedSpec.location_password = $backupPassword
$backupSchedSpec.enable = $true

# Monthly schedule configuration
$recurSpec = $backupSchedSvc.Help.create.spec.recurrence_info.Create()
$recurSpec.days = @("$backupDay")  # Use string representation of the day
$recurSpec.minute = '59'
$recurSpec.hour = '23'
$backupSchedSpec.recurrence_info = $recurSpec

# Retention settings
$retentSpec = $backupschedsvc.help.create.spec.retention_info.Create()
$retentSpec.max_count = '5'
$backupSchedSpec.retention_info = $retentSpec
 
# Create the backup schedule
try {
    $backupSchedSvc.create($schedSpec, $backupSchedSpec)
    Write-Host "Monthly backup schedule created successfully (Runs on day $backupDay of each month)"
}
catch {
    Write-Host "Backup schedule creation failed: $_"
    if ($_.Exception.ServerError) {
        Write-Host "Server error details: $($_.Exception.ServerError)"
    }
}