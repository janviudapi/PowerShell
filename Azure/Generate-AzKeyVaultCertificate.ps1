[CmdletBinding(
    SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    HelpURI='http://vcloud-lab.com'
)]

<#
    .SYNOPSIS
    Generate new Self Singed certificate in Azure Key Vault

    .DESCRIPTION
    This Script generates new Self Singed SSL certificate in Azure Key Vault, it can create new certificate or update create new version in existing key vault certificate.

    .PARAMETER CertificateName
    Specify Certificate Name for either new or existing Key vault certificate.

    .PARAMETER KeyVaultName
    Specify under which key vault you want to generate or update certificate.

    .INPUTS
    None. Generate or update version of certificate on Key Vault.

    .OUTPUTS
    Shows information Key Vault Certificate status. You can pipe information to Export-CSV.

    .EXAMPLE
    PS> .\Generate AzKeyVaultCertificate.ps1 -CertificateName vcloud-lab-Automation-Account-Ps2 -KeyVaultName vcloudvault
    
    Found Key Vault Name:- vcloudvault
    Processing creation of Azure Key Vault Certificate
    100% Completed. Checking status
    Generated Key Vault Certificate successfully


    Id                        : https://vcloudvault.vault.azure.net/certificates/vcloud-lab-Automation-Account-Ps2/pending
    Status                    : completed
    StatusDetails             :
    RequestId                 : 614c70bba71949c88673253402b8cb80
    Target                    : https://vcloudvault.vault.azure.net/certificates/vcloud-lab-Automation-Account-Ps2
    Issuer                    : Self
    CancellationRequested     : False
    CertificateSigningRequest : MIIC6jCCAdICAQAwLDEqMCgGA1UEAxMhdmNsb3VkLWxhYi1BdXRvbWF0aW9uLUFjY291bnQtUHMyMIIfUjANBgkqhkiG9w0BAQEFAAO 
                                CAQ8AMIIBCgKCAQEArXrw896z/7nwBjNsg2+qEk01S2BcV0ju4Fc1usKBgXAk6jO6pzQru5NNT0Lpdvvx6/y+14Tg01ElHwRHYDbKLD 
                                br+ZjglukebAhSt0zn12bf6UrSGmd2e1BC0F0mo7ZNdwLkNaqAY3/y48YIqAltu6sBQV+lZthAS5vrB0cwNpukG/Y3+MkRuEc909RfF 
                                R6IF88Cd5aHvS8i126BbQSYRhFQTr5z+btQx3BtJKivVRzw+M4CxbmHWkpOstUK4JRUfYhAOylwL2e6JFJiHCQNg0dVsb3Mlkp0cgY3 
                                bHoPBa56754agQzWOV3q238CbmbkAw1HmHcjCT+jraHbEdj1pQIDAQABoHkwdwYJKoZIhvcNAQkOMWowaDAOBgNVHQ8BAf8EBAMCBaA 
                                wHQYDVR0lBBYwFAYIKwYBBQUfgwEGCCsGAQUFBwMCMCwGA1UdEQQlMCOCIXZjbG91ZC1sYWItQXV0b21hdGlvbi1BY2NvdW50LVBzMj 
                                AJBgNVHRMEAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQA2Doge8GLk26h2C8QyaBGBfrEsmf3f4BdX8MTfAAWlprnZYNTfjp4S2JFlthyAZ 
                                afjUKyugaz5zX04mwxRS2XhizXafJGLXploGlYSC/s7YCbGlNirM/5k8AfASP4uLfN23/%^DcqHBt34QOcf7IIIyo1TLfCExhy4c9j0 
                                DLS5oVd0wjKZhFasneW0gf/D-|!an8gZ2KlTHiT75LydDSbkKK+Aufzy8Kn2KBVrJ4PQ2UaUBekMe4MLbxkBzL0W7WUNupwZDlOGYQs 
    ErrorMessage              :
    Name                      : vcloud-lab-Automation-Account-Ps2
    VaultName                 : vcloudvault

    .EXAMPLE
    PS> .\Generate AzKeyVaultCertificate.ps1 vcloud-lab-Automation-Account-Ps2 vcloudvault
    This is another way to execute command .\Generate AzKeyVaultCertificate.ps1 -CertificateName vcloud-lab-Automation-Account-Ps2 -KeyVaultName vcloudvault

    .LINK
    Online version: http://vcloud-lab.com

    .LINK
    Get-AzVMBackupInformation.ps1
    http://vcloud-lab.com/entries/microsoft-azure/get-azure-virtual-machine-backup-reports-using-powershell
#>

Param
( 
    [parameter(Position=0)]
    [String]$CertificateName = 'vcloud-lab-Automation-Account-Ps',
    [parameter(Position=1, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
    [alias('KeyVault')]
    [String]$KeyVaultName = 'vcloudvault'
) #Param

Begin {
    #Get existing Azure Key Vault information
    $azKeyVault = Get-AzKeyVault -Name $keyVaultName -ErrorAction SilentlyContinue
    if ($null -eq $azKeyVault)
    {
        Write-Host "Didn't find Key Vault with name Azure:- $keyVaultName" -BackgroundColor DarkRed
        break
    }
    else 
    {
        Write-Host "Found Key Vault Name:- $keyVaultName" -BackgroundColor DarkGreen
    }
} #Begin
Process {
    #Generate new Azure Key Vault Certificate
    Write-Host "Processing creation of Azure Key Vault Certificate" -ForegroundColor Yellow
    $certSubjectName = 'cn=' + $CertificateName
    $azKeyVaultCertPolicy = New-AzKeyVaultCertificatePolicy -SecretContentType "application/x-pkcs12" -SubjectName $certSubjectName -IssuerName Self -ValidityInMonths 24 -ReuseKeyOnRenewal -DnsName $certificateName
    $azKeyVaultCertStatus = Add-AzKeyVaultCertificate -VaultName $keyVaultName -Name $CertificateName -CertificatePolicy $azKeyVaultCertPolicy

    #Wait for certificate to generate
    $counter = 1
    While ($azKeyVaultCertStatus.Status -eq 'inProgress') {
        Start-Sleep -Milliseconds 50
        Write-Host "`r$counter% creation in progress" -NoNewline -ForegroundColor Yellow
        $azKeyVaultCertStatus = Get-AzKeyVaultCertificateOperation -VaultName $keyVaultName -Name $CertificateName
        $counter++
    }
    Write-Host "`r100% Completed. Checking status... " -ForegroundColor Yellow
    if ($azKeyVaultCertStatus.Status -ne 'completed') { 
        Write-Host $($azKeyVaultCertStatus.StatusDetails) -ForegroundColor Magenta
    }
    else {
        Write-Host "Generated Key Vault Certificate successfully" -BackgroundColor DarkGreen
        Write-Output $azKeyVaultCertStatus
    }
} #Process
End {} #end