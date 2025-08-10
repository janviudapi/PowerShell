# vCenter Update Script
# created by vCloud-Lab.com
# This script Installs staged patch update on a vCenter Server Appliance (VCSA) using the vSphere REST API.
# This script requires PowerShell 7 or newer

param (
    [string]$vcServer = "marvel.vcloud-lab.com",
    [string]$vcUser = "administrator@vsphere.local",
    [string]$vcPass = "Computer@123",
    [string]$Version = "",
    [string]$sourceType = "MANUAL",
    [string]$url = "https://192.168.34.99/vc_patches/",
    [bool]$enableMajorUpgrades = $true
)

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

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

function Get-PendingUpdates {
    param (
        [string]$server,
        [string]$sessionId,
        [string]$source,
        [string]$url,
        [bool]$enableMajor
    )

    $apiEndpoint = "https://$server/api/appliance/update/pending"
    $queryParams = @{
        source_type                        = $source
        enable_list_major_upgrade_versions = $enableMajor.ToString().ToLower()
    }
    if (-not [string]::IsNullOrEmpty($url)) {
        $queryParams.url = $url
    }

    $headers = @{ "vmware-api-session-id" = $sessionId }
    $uriBuilder = [System.UriBuilder]::new($apiEndpoint)
    $uriBuilder.Query = ($queryParams.GetEnumerator() | ForEach-Object {
            [System.Web.HttpUtility]::UrlEncode($_.Key) + "=" + [System.Web.HttpUtility]::UrlEncode($_.Value)
        }) -join '&'

    try {
        return Invoke-RestMethod -Uri $uriBuilder.Uri -Method Get -Headers $headers -SkipCertificateCheck
    }
    catch {
        return $null
    }
}

# --- MAIN ---
try {
    $session = Get-VCenterSession

    if (-not $Version) {
        $updates = Get-PendingUpdates -server $vcServer -sessionId $session -source $sourceType -url $url -enableMajor $enableMajorUpgrades

        if (-not $updates) {
            throw "No pending updates found or source invalid."
        }

        $Version = ($updates | Sort-Object -Property version -Descending | Select-Object -First 1).version
        Write-Host "ℹ️ Using latest available staged version: $Version"
    }

    $headers = @{ 
        "vmware-api-session-id" = $session
        "Content-Type"          = "application/json"
    }

    $installUri = "https://$vcServer/api/appliance/update/pending/$($Version)?action=install"
    Write-Host "🚀 Installing staged update: $Version"
    $installBody = @{
        component = ""
        user_data = @{}  # or use an empty object @{} if needed
    } | ConvertTo-Json -Depth 5

    Invoke-RestMethod -Method Post -Uri $installUri -Headers $headers -Body $installBody -ContentType "application/json" -SkipCertificateCheck
    Write-Host "🚀 Update process started: $Version"

}
catch {
    Write-Error "❌ ERROR: $($_.Exception.Message)"
}
finally {
    if ($session) {
        $logoutUri = "https://$vcServer/rest/com/vmware/cis/session"
        Invoke-RestMethod -Method Delete -Uri $logoutUri -Headers @{ "vmware-api-session-id" = $session } -SkipCertificateCheck
    }
}
