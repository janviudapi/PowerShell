# vCenter Update Script
# created by vCloud-Lab.lab
# This script stages latest update version on a vCenter Server using the REST API.
# Requires PowerShell 7 or newer

param (
    [string]$vcServer = "marvel.vcloud-lab.com",
    [string]$vcUser = "administrator@vsphere.local",
    [string]$vcPass = "Computer@123",
    [string]$Version = "",  # Leave blank to auto-select latest
    [string]$SourceType = "MANUAL",
    [string]$Url = "https://192.168.34.99/vc_patches/"  # Optional: URL where patch metadata is hosted
)

# Ignore SSL certificate warnings (dev/test only)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# --- Get vCenter Session ---
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

# --- Get Pending Updates (New Function) ---
function Get-PendingUpdates {
    param (
        [string]$vcServer,
        [string]$sessionId,
        [string]$sourceType = "MANUAL",
        [string]$url = "",
        [bool]$includeMajor = $true
    )

    $headers = @{ "vmware-api-session-id" = $sessionId }

    $params = @{
        source_type = $sourceType
        enable_list_major_upgrade_versions = $includeMajor.ToString().ToLower()
    }
    if ($url) { $params.url = $url }

    $query = ($params.GetEnumerator() | ForEach-Object {
        [System.Web.HttpUtility]::UrlEncode($_.Key) + "=" + [System.Web.HttpUtility]::UrlEncode($_.Value)
    }) -join '&'

    $uri = "https://$vcServer/api/appliance/update/pending?$query"

    return Invoke-RestMethod -Method Get -Uri $uri -Headers $headers -SkipCertificateCheck
}

# --- Main Script ---
try {
    $session = Get-VCenterSession
    $headers = @{ 
        "vmware-api-session-id" = $session
        "Content-Type" = "application/json"
    }

    # Get list of pending updates using new function
    $updates = Get-PendingUpdates -vcServer $vcServer -sessionId $session -sourceType $SourceType -url $Url

    if (-not $updates) {
        Write-Host "❌ No pending updates found." -ForegroundColor Red
        return
    }

    Write-Host "✅ Available versions:" -ForegroundColor Cyan
    $updates | ForEach-Object {
        Write-Host "• Version: $($_.version) - Severity: $($_.severity) - Date: $($_.release_date)"
    }

    # Use provided version or pick the latest
    if ([string]::IsNullOrWhiteSpace($Version)) {
        $Version = ($updates | Sort-Object -Property version -Descending | Select-Object -First 1).version
        Write-Host "`nℹ️ Auto-selected latest version: $Version" -ForegroundColor Yellow
    } elseif (-not ($updates.version -contains $Version)) {
        Write-Host "`n❌ ERROR: Provided version '$Version' not found in pending updates!" -ForegroundColor Red
        return
    }

    # Stage the update
    $stageUri = "https://$vcServer/api/appliance/update/pending/$($Version)?action=stage"
    Write-Host "`n🚀 Staging update version: $Version..."
    $stageResponse = Invoke-RestMethod -Method Post -Uri $stageUri -Headers $headers -SkipCertificateCheck #-Body '{}'

    Write-Host "✅ Staging triggered successfully." -ForegroundColor Green
}
catch {
    Write-Error "❌ ERROR: $($_.Exception.Message)"
}
finally {
    if ($session) {
        $logoutUri = "https://$vcServer/rest/com/vmware/cis/session"
        Invoke-RestMethod -Method Delete -Uri $logoutUri -Headers @{ "vmware-api-session-id" = $session } -SkipCertificateCheck
        Write-Host "`n🔒 Session closed." -ForegroundColor DarkGray
    }
}