# Install the Az PowerShell module if not already installed
#Install-Module -Name Az

# Import the Az PowerShell module
Import-Module -Name Az

# Set your Azure credentials
# $username = 'janvi@onmicrsoft.com'
# $password = ' '| ConvertTo-SecureString -AsPlainText -Force
# $cred = New-Object System.Management.Automation.PSCredential ($username, $password)

# Login to Azure
Connect-AzAccount #-Credential $cred

# Get the access token
$token = Get-AzAccessToken

# Use the access token to authenticate your Azure REST API requests
$headers = @{
  "Authorization" = "Bearer $($token.Token)"
  "Content-Type" = "application/json"
}

# List subscriptions using Azure REST API request
$url = "https://management.azure.com/subscriptions?api-version=2021-04-01"
$response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
$response.value

# List Resource Groups using Azure REST API request
$subscription = Get-AzSubscription -SubscriptionName 'Sponsership-by-Microsoft'

$url = "https://management.azure.com/subscriptions/$($subscription.Id)/resourcegroups?api-version=2021-04-01"
$response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
$response.value