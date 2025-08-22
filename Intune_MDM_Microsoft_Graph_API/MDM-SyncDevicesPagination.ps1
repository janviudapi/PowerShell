$tenantId = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

$loginUri = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$loginMethod = 'POST'
$loginBody = @{ 
    grant_type="client_credentials"
    client_id='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    client_secret='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    scope="https://graph.microsoft.com/.default"
} 

$tokenResponse = Invoke-RestMethod -Uri $loginUri -Method $loginMethod -Body $loginBody -ContentType 'application/x-www-form-urlencoded'

#######################

$bearerTokenHeader = @{
    Authorization = "{0} {1}" -f $tokenResponse.token_type, $tokenResponse.access_token
}

$manageddevicesUri = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices"

$allDevices = @()
while ($null -ne $manageddevicesUri) {
    $devicesResponse = Invoke-RestMethod -Uri $manageddevicesUri -Headers $bearerTokenHeader -Method GET
    #$allDevices.value | Select-Object id, deviceName, operatingSystem, complianceState | Format-Table
    $allDevices += $devicesResponse.value
    $devicesResponse.value | Export-Csv -Path C:\temp\dviceslist.csv -NoTypeInformation -Append 
    $manageddevicesUri = $devicesResponse.'@odata.nextLink'
    # $manageddevicesUri
}

foreach ($device in $allDevices[0..1])
{
    #$deviceUri = "https://graph.microsoft.com/beta/deviceManagement/managedDevices/$($device.id)/syncDevice"
    $deviceUri = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/$($device.id)/syncDevice"
    $deviceSyncInfo = Invoke-Webrequest -Uri $deviceUri -Headers $bearerTokenHeader -Method POST
    $deviceSyncInfo
}