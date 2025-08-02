# vCenter Update Check Script
# created by vCloud-Lab.lab
# This script checks for pending updates on a vCenter Server using the REST API.
# Requires PowerShell 7 or newer

# vCenter Server Details
$vcServer = "marvel.vcloud-lab.com"
$vcUser = "administrator@vsphere.local"
$vcPass = "Computer@123"

# API Parameters
$sourceType = "MANUAL"  # Valid values: LAST_CHECK, LOCAL, MANUAL
$url = "https://192.168.34.99/vc_patches/"  # Optional URL
$enableMajorUpgrades = $true  # Set to $false to disable major version checks

# Ignore SSL certificate warnings (remove in production)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# Function to get vCenter API session
function Get-VCenterSession {
    param(
        [string]$server,
        [string]$user,
        [string]$pass
    )
    
    $authUri = "https://$server/rest/com/vmware/cis/session"
    $authBytes = [System.Text.Encoding]::UTF8.GetBytes("${user}:${pass}")
    $authHeader = "Basic " + [System.Convert]::ToBase64String($authBytes)
    
    $headers = @{
        "Authorization" = $authHeader
        "Content-Type" = "application/json"
    }
    
    try {
        $response = Invoke-RestMethod -Uri $authUri -Method Post -Headers $headers -SkipCertificateCheck
        return $response.value
    }
    catch {
        Write-Error "Authentication failed: $($_.Exception.Message)"
        exit 1
    }
}

# Function to check pending updates
function Get-PendingUpdates {
    param(
        [string]$server,
        [string]$sessionId,
        [string]$source,
        [string]$url,
        [bool]$enableMajor
    )
    
    $apiEndpoint = "https://$server/api/appliance/update/pending"
    
    # Build query parameters
    $queryParams = @{
        source_type = $source
        enable_list_major_upgrade_versions = $enableMajor.ToString().ToLower()
    }
    
    if (-not [string]::IsNullOrEmpty($url)) {
        $queryParams.url = $url
    }
    
    # Create headers with session token
    $headers = @{
        "vmware-api-session-id" = $sessionId
        "Accept" = "application/json"
    }
    
    # Build full URI with query parameters
    $uriBuilder = [System.UriBuilder]::new($apiEndpoint)
    $uriBuilder.Query = ($queryParams.GetEnumerator() | 
        ForEach-Object { 
            [System.Web.HttpUtility]::UrlEncode($_.Key) + "=" + 
            [System.Web.HttpUtility]::UrlEncode($_.Value) 
        }) -join '&'
    
    try {
        $response = Invoke-RestMethod -Uri $uriBuilder.Uri -Method Get -Headers $headers -SkipCertificateCheck
        return $response
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorMsg = switch ($statusCode) {
            401 { "Session not authenticated" }
            403 { "Session not authorized" }
            404 { "Update source not found" }
            500 { "Internal server error" }
            default { "HTTP error $statusCode" }
        }
        Write-Error "API request failed: $errorMsg"
        return $null
    }
}

# Main execution
try {
    # Get authentication token
    $session = Get-VCenterSession -server $vcServer -user $vcUser -pass $vcPass
    Write-Host "Authenticated successfully. Session ID: $session`n" -ForegroundColor Green

    # Check for pending updates
    Write-Host "Checking for pending updates (source: $sourceType)..."
    $updates = Get-PendingUpdates -server $vcServer -sessionId $session `
        -source $sourceType -url $url -enableMajor $enableMajorUpgrades

    if ($updates) {
        Write-Host "`nPENDING UPDATES FOUND:`n" -ForegroundColor Yellow
        $updates | Format-List | Out-String | Write-Host
        
        # Show summary
        $updateCount = $updates.Count
        $lastUpdate = $updates | Sort-Object -Property version -Descending | Select-Object -First 1
        Write-Host "`nUpdate Summary:" -ForegroundColor Cyan
        Write-Host "Total pending updates: $updateCount"
        Write-Host "Latest version available: $($lastUpdate.version)"
        Write-Host "Release date: $($lastUpdate.release_date)"
        Write-Host "Severity: $($lastUpdate.severity)"
    }
    else {
        Write-Host "`nNo pending updates found." -ForegroundColor Green
    }
}
catch {
    Write-Error "Script execution failed: $($_.Exception.Message)"
}
finally {
    # Clean up session if exists
    if ($session) {
        Write-Host "`nCleaning up session..." -ForegroundColor DarkGray
        $logoutUri = "https://$vcServer/rest/com/vmware/cis/session"
        $headers = @{"vmware-api-session-id" = $session}
        Invoke-RestMethod -Uri $logoutUri -Method Delete -Headers $headers -SkipCertificateCheck | Out-Null
    }
}