#generate a self singed SSL certififate
New-SelfSignedCertificate -CertStoreLocation cert:\CurrentUser\my -Subject CN=CertLogin -KeySpec KeyExchange -FriendlyName CertLogin

#Get certifiate thumbprint 
$certificate = Get-ChildItem Cert:\CurrentUser\my | Where-Object {$_.Subject -eq 'CN=CertLogin'}
$thumbprint =  $certificate.Thumbprint
$thumbprint

#Download/Export certififate
$certificate = Get-ChildItem -Path "cert:\CurrentUser\My\$thumbprint"
Export-Certificate -Cert $certificate -FilePath c:\temp\loggingcert.cer

#App registeration information
$applicationId = '61e492e8-cbc2-48e4-880a-ec39187567a5'
$subscriptionId = '9e22fba3-00a9-447c-b954-a26fec38e029'
$tenantId = '3b80e97b-2973-44fb-8192-c18e52ddcf98'


#Login with Certificate
Connect-AzAccount -ServicePrincipal -CertificateThumbprint $thumbprint -Tenant $tenantId -ApplicationId $applicationId -SubscriptionId $subscriptionId

Get-AzResourcegroup

Get-AzKeyVaultSecret -VaultName vcloudkeyvault  -Name test -AsPlainText
#$secret = Get-AzKeyVaultSecret -VaultName vcloudkeyvault  -Name test
#$key = ConvertFrom-SecureString $secret.SecretValue -AsPlainText
#$key