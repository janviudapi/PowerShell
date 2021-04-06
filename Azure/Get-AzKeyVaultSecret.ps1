#http://vcloud-lab.com
#created by janvi on 1st april 2020

Connect-AzAccount

Get-AzKeyVault

Get-AzKeyVaultSecret -VaultName "Key Vault Name"

$secret = Get-AzKeyVaultSecret -VaultName "Key Vault Name" -Name "Secret Name"
$key = ConvertFrom-SecureString $secret.SecretValue

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$password
