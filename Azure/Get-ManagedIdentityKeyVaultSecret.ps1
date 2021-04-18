CreatedBy: http://vcloud-lab.com

$env:COMPUTERNAME; $env:USERNAME

$response = Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -Method GET -Headers @{Metadata="true"}

$response.access_token

$result = Invoke-RestMethod -Uri https://vcloud02vault.vault.azure.net/secrets/RootSecret/03d6fd62056a4790a8982b1a75f320f8?api-version=7.1 -Headers @{"Authorization" = "Bearer $($response.access_token)"} 

$result | select id, value, contentType
