#AzureCLI create azure key vault
#created by http://vcloud-lab.com

az login

az keyvault create --name vCloud02Vault --resource-group vcloud-lab.com --location 'East US' --sku Standard

az keyvault secret set-attributes --name RootSecret --vault-name vCloud02Vault --content-type 'Esxi Root Password'

az ad user show --id vaultviewer@vcloud-lab.com 
az keyvault set-policy --name vCloud02Vault --object-id 8ab61685-c967-460d-8152-7d41b54449fe --secret-permissions get list

az role assignment create --assignee vaultviewer@vcloud-lab.com --role 'Key Vault Reader' --scope /subscriptions/9e22xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/vcloud-lab.com/providers/Microsoft.KeyVault/vaults/vCloud02Vault

az login
az keyvault secret show --name RootSecret --vault-name vCloud02Vault
