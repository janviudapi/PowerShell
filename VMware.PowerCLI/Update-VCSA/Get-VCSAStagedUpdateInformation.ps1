# vCenter Update Script
# created by vCloud-Lab.com
# This script retrieves information about the currently staged update on a vCenter Server Appliance (VCSA) using the vSphere REST API.
# This script requires PowerShell 7 or newer

param (
    [string]$vcServer = "marvel.vcloud-lab.com",
    [string]$vcUser = "administrator@vsphere.local",
    [string]$vcPass = "Computer@123"
)

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# Authenticate and get session ID
function Get-VCenterSession {
    $authUri = "https://$vcServer/rest/com/vmware/cis/session"
    $authBytes = [System.Text.Encoding]::UTF8.GetBytes("${vcUser}:${vcPass}")
    $authHeader = "Basic " + [System.Convert]::ToBase64String($authBytes)

    $headers = @{
        "Authorization" = $authHeader
        "Content-Type"  = "application/json"
    }

    $response = Invoke-RestMethod -Uri $authUri -Method Post -Headers $headers -SkipCertificateCheck
    return $response.value
}

# Get staged update info
function Get-StagedUpdate {
    param (
        [string]$vcServer,
        [string]$sessionId
    )

    $uri = "https://$vcServer/api/appliance/update/staged"
    $headers = @{ "vmware-api-session-id" = $sessionId }

    try {
        $result = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -SkipCertificateCheck
        Write-Host "🛠 Staged Update Info:"
        Write-Host "Version:             $($result.version)"
        Write-Host "Name:                $($result.name)"
        Write-Host "Priority:            $($result.priority)"
        Write-Host "Severity:            $($result.severity)"
        Write-Host "Type:                $($result.update_type)" 
        Write-Host "Reboot Needed:       $($result.reboot_required)"
        Write-Host "Release Date:        $($result.release_date)"
        Write-Host "Size (bytes):        $($result.size)"
        Write-Host "Staging Completed:   $($result.staging_complete)"
    }
    catch {
        Write-Warning "⚠️ No update currently staged or an error occurred: $($_.Exception.Message)"
    }
}

# --- MAIN ---
try {
    $session = Get-VCenterSession
    if (-not $session) { throw "❌ Could not authenticate with vCenter." }

    Get-StagedUpdate -vcServer $vcServer -sessionId $session
}
catch {
    Write-Error "❌ ERROR: $($_.Exception.Message)"
}
finally {
    if ($session) {
        $logoutUri = "https://$vcServer/rest/com/vmware/cis/session"
        Invoke-RestMethod -Method Delete -Uri $logoutUri -Headers @{ "vmware-api-session-id" = $session } -SkipCertificateCheck
        Write-Host "🔒 Session logged out."
    }
}
