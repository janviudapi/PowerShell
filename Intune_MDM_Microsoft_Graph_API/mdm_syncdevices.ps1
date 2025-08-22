$loginUri = "https://login.microsoftonline.com/xxxxxxxxxxxxxxxxxxxxxxx/oauth2/v2.0/token"
$loginMethod = 'POST'
$loginBody = @{ 
    grant_type="client_credentials"
    client_id='xxxxxxxxxxxxxxxxxxxxxxx'
    client_secret='xxxxxxxxxxxxxxxxxxxxxxx'
    scope="https://graph.microsoft.com/.default"
} 

$tokenResponse = Invoke-RestMethod -Uri $loginUri -Method $loginMethod -Body $loginBody -ContentType 'application/x-www-form-urlencoded'
$bearerTokenHeader = @{
    Authorization = "{0} {1}" -f $tokenResponse.token_type, $tokenResponse.access_token
}
$manageddevicesUri = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices"
$allDevices = Invoke-RestMethod -Uri $manageddevicesUri -Headers $bearerTokenHeader -Method GET
#$allDevices.value | Select-Object id, deviceName, operatingSystem, complianceState | Format-Table

foreach ($device in $allDevices.value[0..1])
{
    $deviceUri = "https://graph.microsoft.com/beta/deviceManagement/managedDevices/$($device.id)/syncDevice" 
    $deviceSyncInfo = Invoke-RestMethod -Uri $deviceUri -Headers $bearerTokenHeader -Method POST
    $deviceSyncInfo
}