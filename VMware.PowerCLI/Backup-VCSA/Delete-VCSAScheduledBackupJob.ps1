$vCenterServer = 'marvel.vcloud-lab.com'
$vCenterUser = 'administrator@vsphere.local'
$vCenterPassword = 'Computer@123'

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