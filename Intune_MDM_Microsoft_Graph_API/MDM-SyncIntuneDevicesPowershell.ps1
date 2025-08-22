$scopes = "DeviceManagemenetManagedDevices.ReadWrite.All"
$tenantId = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$clientId = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$ClientSecret = ConvertTo-SecureString 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx'  -AsPlainText -Force
$clientSecretCredential =  New-Object System.Management.Automation.PSCredential($clientId, $clientSecret)

Connect-mgGraph -TenantId $tenantId -ClientSecretCredential $clientSecretCredential #-NoWelcome -Scopes $scopes

$devices = Get-MgDeviceManagementManagedDevice -All
$devices[0]
$devices.Count

Sync-MgDeviceManagementManagedDevice -ManagedDeviceId $devices[0].Id