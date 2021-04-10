#Micorosft azure create new key vault Powershell
#created by:  http://vcloud-lab.com

Connect-AzAccount

$vaultName = 'vCloud01Vault'
$resourceGroupName = 'vcloud-lab.com'
$secretName = 'RootSecret'
$userPrincipalName = 'vaultviewer@vcloud-lab.com'

New-AzKeyVault -Name $vaultName -ResourceGroupName $resourceGroupName -Location 'East US' -Sku Standard

Get-AzkeyVault -VaultName $vaultName

$secretValue = ConvertTo-SecureString -String 'T0p$ecret' -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $vaultName -Name $secretName -SecretValue $secretValue -ContentType 'ESXi root password'

Set-AzKeyVaultAccessPolicy -VaultName $vaultName -UserPrincipalName $userPrincipalName -PermissionsToSecrets Get,List

$keyVault = Get-AzkeyVault -VaultName $vaultName
$keyVault.ResourceID

New-AzRoleAssignment -SignInName $userPrincipalName -RoleDefinitionName 'Key Vault Reader' -Scope $keyVault.ResourceID

Connect-AzAccount
$keyVaultSecret = Get-AzKeyVaultSecret -VaultName $vaultName -Name $secretName
$password = ConvertFrom-SecureString $keyVaultSecret.SecretValue -AsPlainText
$password
