#Written By - vcloud-lab.com #vJanvi
#Create new Azure Automation Account Run As

$automationAccount = 'AutomationAC01' 
$certExpiryMonths = 24
$certPfxPassword = '123456'
$certExportPath = 'C:\Temp\Certs'
$resourceGroup = 'vCloud-lab.com'
$location = "East Us"

$certPassword = ConvertTo-SecureString $certPfxPassword -AsPlainText -Force

#Region
#Generate SSL certificate
Write-Host "Generate self signed certificate for - $automationAccount"
$selfSignedCertSplat = @{
    DnsName = $automationAccount
    Subject = $automationAccount
    CertStoreLocation = 'cert:\CurrentUser\My' 
    KeyExportPolicy = 'Exportable'
    Provider = 'Microsoft Enhanced RSA and AES Cryptographic Provider'
    NotAfter = (Get-Date).AddMonths($certExpiryMonths) 
    HashAlgorithm = 'SHA256'
}
$selfSignedCert = New-SelfSignedCertificate @selfSignedCertSplat

#Export SSL certificate to files
Write-Host "Export self signed certificate to folder - $certExportPath"
$certThumbPrint = 'cert:\CurrentUser\My\' + $selfSignedCert.Thumbprint
Export-PfxCertificate -Cert $certThumbPrint -FilePath "$certExportPath\$automationAccount.pfx" -Password $certPassword -Force | Write-Verbose
Export-Certificate -Cert $certThumbPrint -FilePath "$certExportPath\$automationAccount.cer" -Type CERT | Write-Verbose
#EndRegion - Generate self signed certificate

#Region
#Read PFX Certificate
Write-Host "Read PFX file"
$pfxCertSplat = @{
    TypeName = 'System.Security.Cryptography.X509Certificates.X509Certificate2'
    ArgumentList = @("$certExportPath\$automationAccount.pfx",  $certPfxPassword)
}
$pfxCert = New-Object @pfxCertSplat

#Create an Azure AD application (App Registrations)
Write-Host "Create Azure AD application - $automationAccount"
$azADAppRegistrationsSplat = @{
    DisplayName = $automationAccount
    HomePage = "http://$automationAccount"
    IdentifierUris = "http://$automationAccount"
}
$azADAppRegistrations = New-AzADApplication @azADAppRegistrationsSplat

#Create Azure active directory Application Credential (App Registrations)
Write-Host "Create credential for Azure AD application - $automationAccount"
$azADAppRegistrationsCredSplat = @{
    ApplicationId = $azADAppRegistrations.ApplicationId
    CertValue = [System.Convert]::ToBase64String($pfxCert.GetRawCertData())
    StartDate = $pfxCert.NotBefore 
    EndDate = $pfxCert.NotAfter
}
[void](New-AzADAppCredential @azADAppRegistrationsCredSplat)

#Azure AD Service Principal
Write-Host "Create Azure AD Service Principal - $automationAccount"
[void](New-AzADServicePrincipal -ApplicationId $azADAppRegistrations.ApplicationId)
Start-Sleep -Seconds 15

#Provide contributer access on Serivce Principal
Write-Host "Assign contributer azure role on Azure AD application / SP - $automationAccount"
$AzRoleAssignment = New-AzRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $azADAppRegistrations.ApplicationId -ErrorAction SilentlyContinue
$i = 0;
While (($null -eq $AzRoleAssignment) -and ($i -le 6)) 
{
    Start-Sleep -Seconds 10
    New-AzRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $azADAppRegistrations.ApplicationId -ErrorAction SilentlyContinue
    $AzRoleAssignment = Get-AzRoleAssignment -ServicePrincipalName $azADAppRegistrations.ApplicationId -ErrorAction SilentlyContinue
    $i++
}
#EndRegion - Azure AD application 

#Region
Write-Host "Create Azure Automation Account - $automationAccount"
[void](New-AzAutomationAccount -Name $automationAccount -Location $location -ResourceGroupName $resourceGroup)

Write-Host "Create Azure Automation Account Run as certificate - $automationAccount"
Start-Sleep -Seconds 15
$azAutomationCertSplat = @{
    ResourceGroupName =  $resourceGroup 
    AutomationAccountName = $automationAccount
    Path = "$certExportPath\$automationAccount.pfx"
    Name = 'AzureRunAsCertificate' #$automationAccount
    Password = $certPassword
    Description = "This certificate is used to authenticate with the service principal that was automatically created for this account. For details on this service principal and certificate, or to recreate them, go to this account’s Settings. For example usage, see the tutorial runbook in this account."
}
[void](New-AzAutomationCertificate @azAutomationCertSplat -Exportable:$true) 

Write-Host "Create Azure Automation Account connection - $automationAccount"
Start-Sleep -Seconds 15
$azSubscriptionContext = Get-AzContext
$azAutomationConnectionSplat = @{
    ResourceGroupName = $resourceGroup
    AutomationAccountName = $automationAccount
    Name = 'AzureRunAsConnection' #$automationAccount
    ConnectionTypeName = 'AzureServicePrincipal'
    Description = "This connection contains information about the service principal that was automatically created for this automation account. For details on this service principal and its certificate, or to recreate them, go to this account’s Settings. For example usage, see the tutorial runbook in this account."
    ConnectionFieldValues = @{
        ApplicationId = $azADAppRegistrations.ApplicationId.Guid
        TenantId = $azSubscriptionContext.Tenant.Id
        CertificateThumbprint = $pfxCert.Thumbprint
        SubscriptionId = $azSubscriptionContext.Subscription
    }
}
[void](New-AzAutomationConnection @azAutomationConnectionSplat)
#EndRegion