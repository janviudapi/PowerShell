#Documentation
#https://learn.microsoft.com/en-us/rest/api/azure/
#https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-client-creds-grant-flow#get-a-token

# Define the resources - resource group and storage account details
$resourceGroupName = "prod.vcloud-lab.com"
$resourceGroupLocation = "West US"
$storageAccountName = "vcloudlabsaprod"

# Define your Azure subscription ID and an access token
$subscriptionId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
$tenantId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
$clientId = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
$clientSecret = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

# Body information for http authentication
$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    resource      = "https://management.azure.com/"
}

# Create 
$response = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/token" -Method Post -ContentType "application/x-www-form-urlencoded" -Body $body 
$accessToken = $response.access_token

# Headers for the API requests
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type"  = "application/json"
}

Write-Host 'Creating Resource Group in Azure'
#https://learn.microsoft.com/en-us/rest/api/resources/resource-groups?view=rest-resources-2021-04-01
#https://learn.microsoft.com/en-us/rest/api/resources/resource-groups/create-or-update?view=rest-resources-2021-04-01&tabs=HTTP
# Create the resource group
$resourceGroupUri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/$($resourceGroupName)?api-version=2021-04-01"
$resourceGroupBody = @{
    location = $resourceGroupLocation
} | ConvertTo-Json

$rgResponse = Invoke-RestMethod -Method Put -Uri $resourceGroupUri -Headers $headers -Body $resourceGroupBody

Start-Sleep -Seconds 10

while ($rgResponse.properties.provisioningState -ne 'Succeeded') {
    Start-Sleep -Seconds 2
}

Write-Host 'Creating Storage Account in Azure'
#https://learn.microsoft.com/en-us/rest/api/storagerp/storage-sample-create-account
# Create the storage account
$storageAccountUri = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$($storageAccountName)?api-version=2021-04-01"
$storageAccountBody = @{
    location = $resourceGroupLocation
    kind     = "StorageV2"
    sku      = @{
        name = "Standard_LRS"
    }
} | ConvertTo-Json

Invoke-RestMethod -Method Put -Uri $storageAccountUri -Headers $headers -Body $storageAccountBody

Start-Sleep -Seconds 10

Write-Host "Resource group and storage account created successfully."

<#

###################################
# Delete method with different token scope example
###################################

#https://learn.microsoft.com/en-us/rest/api/resources/resource-groups/delete?view=rest-resources-2021-04-01&tabs=HTTP
#https://learn.microsoft.com/en-us/rest/api/resources/resources/list-by-resource-group?view=rest-resources-2021-04-01

#Get resources information inside resource group
$resourceGroupResourcesUri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName/resources?api-version=2021-04-01"
$resourcesResponse = Invoke-RestMethod -Method Get -Uri $resourceGroupResourcesUri -Headers $headers 


# Delete resource group
$resourceGroupUri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/$($resourceGroupName)?api-version=2021-04-01" ##?forceDeletionTypes=Microsoft.Compute/virtualMachines,Microsoft.Compute/virtualMachineScaleSets&api-version=2021-04-01
Invoke-RestMethod -Method Delete -Uri $resourceGroupUri -Headers $headers 

# Only works for virtual machines and vmss
#$allResourcesType = $resourcesResponse.value.type -join ','
#$resourceGroupUri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/$($resourceGroupName)?forceDeletionTypes=$allResourcesType&api-version=2021-04-01" 

#>

<# Another Way to get access token
    #https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-client-creds-grant-flow#get-a-token
    #curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d 'client_id=00001111-aaaa-2222-bbbb-3333cccc4444&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default&client_secret=A1bC2dE3f...&grant_type=client_credentials' 'https://login.microsoftonline.com/{tenant}/oauth2/v2.0/token
    
    $body = @{
        client_id     = $clientId
        client_secret = $clientSecret
        scope      = "https://graph.microsoft.com/.default"
        grant_type    = "client_credentials"
    } #| ConvertTo-Json -Compress
    
    $bodyEncoded = ($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"

    $response = Invoke-WebRequest -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Method Post -Body $bodyEncoded -ContentType 'application/x-www-form-urlencoded'
    $token = $response.Content | ConvertFrom-Json
    $token.access_token
#>