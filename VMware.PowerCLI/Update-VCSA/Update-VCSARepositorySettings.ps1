# vCenter Server Details
$vcServer = "marvel.vcloud-lab.com"
$vcUser = "administrator@vsphere.local"
$vcPass = "Computer@123"

# Repository Configuration
$repositoryUrl = "https://192.168.34.99/vc_patches/"
$repositoryUser = ""  # Optional username
$repositoryPass = ""  # Optional password

# Schedule Configuration (Monday at 3:00 AM)
$updateSchedule = @(
    @{
        day = "MONDAY"
        hour = 3
        minute = 0
    }
)

# Disable SSL certificate validation (use only for testing)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# Get vCenter Session Token
$authUri = "https://$vcServer/rest/com/vmware/cis/session"
$authHeader = @{
    "Authorization" = "Basic " + [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes("${vcUser}:${vcPass}")
    )
}

try {
    $session = Invoke-RestMethod -Uri $authUri -Method Post -Headers $authHeader -SkipCertificateCheck
    $sessionToken = $session.value
}
catch {
    Write-Error "Authentication failed: $_"
    exit
}

# Configure API Headers
$headers = @{
    "vmware-api-session-id" = $sessionToken
    "Content-Type" = "application/json"
}

# Prepare Policy Configuration
$policyConfig = @{
    auto_stage = $true
    certificate_check = $false
    check_schedule = $updateSchedule
    custom_URL = $repositoryUrl
    username = $repositoryUser
    password = $repositoryPass
}

# Convert to JSON
$jsonBody = $policyConfig | ConvertTo-Json

# Configure Update Policy
$policyUri = "https://$vcServer/api/appliance/update/policy"

try {
    $response = Invoke-RestMethod -Uri $policyUri -Method Put -Headers $headers -Body $jsonBody -SkipCertificateCheck
    Write-Host "Update policy configured successfully!" -ForegroundColor Green
}
catch {
    Write-Error "Policy configuration failed: $_"
    Write-Host "Status Code: $($_.Exception.Response.StatusCode)"
    Write-Host "Status Description: $($_.Exception.Response.StatusDescription)"
    if ($_.ErrorDetails.Message) {
        Write-Host "Error Details: $($_.ErrorDetails.Message)"
    }
}

# Verify Configuration (Optional)
try {
    $getPolicyUri = "https://$vcServer/api/appliance/update/policy"
    $currentPolicy = Invoke-RestMethod -Uri $getPolicyUri -Method Get -Headers $headers -SkipCertificateCheck
    Write-Host "Current Policy Configuration:"
    $currentPolicy | Format-List | Out-String
}
catch {
    Write-Warning "Failed to verify policy: $_"
}