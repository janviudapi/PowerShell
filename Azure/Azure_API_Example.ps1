#Url:  http://vcloud-lab.com
#Date: 6 may 2019
#Author: Janvi

#Microsoft Azure Rest API authentication
#https://docs.microsoft.com/en-us/rest/api/azure/
$subscriptionId = '9e22xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
$tenantId = '3b80xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
$applicationId = '2e4736e8-8e38-4122-92fe-290933b172f1'
$secret='.9Dyd2U3yM2YD8Wn58XG~bX.z-V.PwN.M0'

$param = @{
    #Uri = "https://login.microsoftonline.com/$tenantId/oauth2/token?api-version=1.0";
    Uri = "https://login.microsoftonline.com/$tenantId/oauth2/token?api-version=2020-06-01";
    Method = 'Post';
    Body = @{ 
        grant_type = 'client_credentials'; 
        resource = 'https://management.core.windows.net/'; 
        client_id = $applicationId; 
        client_secret = $secret
    }
}

$result = Invoke-RestMethod @param
$token = $result.access_token

#Get the list of Resource Groups
#https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups/list
$param_RGList = @{
    Uri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups?api-version=2020-06-01"
    ContentType = 'application/json'
    Method = 'GET'
    headers = @{
        authorization = "Bearer $token"
        host = 'management.azure.com'
    }
}

$rgList = Invoke-RestMethod @param_RGList
$rgList.value | Select-Object name, location, id

#Create or update subscriptionId and resource group name
#https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups/createorupdate
$newResourceGroupName = 'TestResourceGroup'

$param_NewResourceGroup = @{
    Uri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/${newResourceGroupName}?api-version=2020-06-01"
    ContentType = "application/json"
    Method = 'PUT'
    headers=@{
    authorization="Bearer $token"
    host = 'management.azure.com'
    }
    body = '
        {
            "location": "eastus",
            "tags": {
                "owner": "http://vcloud-lab.com"
            }
        }
    '
}

Invoke-RestMethod @param_NewResourceGroup

#Get Resource Group Information
#https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups/get
$param_RGInfo = @{
    Uri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/$($newResourceGroupName)?api-version=2020-06-01"
    ContentType = 'application/json'
    Method = 'GET'
    headers = @{
        authorization = "Bearer $token"
        host = 'management.azure.com'
    }
}

$rgInfo = Invoke-RestMethod @param_RGInfo
$rgInfo | Select-Object name, location, tags, id

#Delete Resource Group Information
#https://docs.microsoft.com/en-us/rest/api/resources/resourcegroups/delete
$param_DeleteResourceGroup = @{
    Uri = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/${newResourceGroupName}?api-version=2020-06-01"
    ContentType = "application/json"
    Method = 'Delete'
    headers=@{
        authorization = "Bearer $token"
        host = 'management.azure.com'
    }
}
Invoke-RestMethod @param_DeleteResourceGroup