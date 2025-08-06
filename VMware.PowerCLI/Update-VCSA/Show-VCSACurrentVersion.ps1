param (
    [string]$vcServer = "marvel.vcloud-lab.com",
    [string]$vcUser = "administrator@vsphere.local",
    [string]$vcPass = "Computer@123"
)

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# Get session ID using username/password
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

# Get appliance update status
function Get-ApplianceUpdateStatus {
    param (
        [string]$vcServer,
        [string]$sessionId
    )

    $uri = "https://$vcServer/api/appliance/update"
    $headers = @{ "vmware-api-session-id" = $sessionId }

    try {
        $result = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -SkipCertificateCheck
        Write-Host "🔍 Appliance Update Status:"
        Write-Host "Latest Query Time : $($result.latest_query_time)"
        Write-Host "Current State      : $($result.state)"
        Write-Host "Installed Version  : $($result.version)"
    }
    catch {
        Write-Warning "⚠️ Failed to retrieve appliance update status: $($_.Exception.Message)"
    }
}

# --- MAIN ---
try {
    $session = Get-VCenterSession
    if (-not $session) { throw "❌ Could not authenticate with vCenter." }

    Get-ApplianceUpdateStatus -vcServer $vcServer -sessionId $session
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