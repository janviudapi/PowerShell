#Created by http://vcloud-lab.com

$credential = Get-Credential -UserName vaultviewer@bishopal.com -Message 'Microsoft Azure Login'
Connect-AzAccount -Credential $credential

$keyVaulttoken = Get-AzAccessToken -ResourceUrl https://vault.azure.net
#az account get-access-token --resource https://vault.azure.net | ConvertFrom-Json

$headers = @{"Authorization" = "Bearer $($keyVaulttoken.Token)"}
$response = Invoke-RestMethod -Uri https://vcloud02vault.vault.azure.net/secrets/RootSecret/03d6fd62056a4790a8982b1a75f320f8?api-version=7.1 -Headers $headers

$response.value
