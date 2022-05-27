[CmdletBinding(SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    HelpURI='http://vcloud-lab.com',
    DefaultParameterSetName = 'pfx'
)]

<#
    .SYNOPSIS
    Export Azure key vault certificates to file.

    .DESCRIPTION
    Download/Export certificate files from Azure Key vault, it downloads certificate in cer or pfx extension format

    .PARAMETER Path
    Speciry Directory path to donwload/export Azure Key Vault certificate files.

    .PARAMETER CertificateName
    Specify Name of the Azure KeyVault Certificate.

    .PARAMETER KeyVaultName
    Specify Name of the Azure Key Vault Where certificate is stored.

    .PARAMETER Pfx
    This parameter exports certificate file in PFX extension format.

    .PARAMETER Cer
    This parameter exports certificate file in CER extenstion format.

    .PARAMETER PfxCertPassword
    If you are using PFX to export certificate, mention Password with this parameter.

    .INPUTS
    None. Export Azure key vault certificates to file.

    .OUTPUTS
    Export Azure key vault certificates to file in given path.

    .EXAMPLE
    PS> .\Export-AzKeyVaultCertificate.ps1 -Path C:\temp\certs -CertificateName vcloud-lab-Automation-Account-Ps -KeyVaultName vcloudvault -PfxCertPassword 123456 -Pfx
    This example to Export certificate in Pfx file format

    .EXAMPLE
    PS> .\Export-AzKeyVaultCertificate.ps1 -Path C:\temp\certs -CertificateName vcloud-lab-Automation-Account-Ps -KeyVaultName vcloudvault -Cer
    This example to Export certificate in Cer file format

    .LINK
    Online version: http://vcloud-lab.com
    http://vcloud-lab.com/entries/microsoft-azure/-create-azure-key-vault-certificates-on-azure-portal-and-powershell

    .LINK
    Export-AzKeyVaultCertificate.ps1
#>
Param
( 
    [parameter(Position=0, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName = 'cer' )]
    [parameter(Position=0, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName = 'pfx' )]
    [alias('Directory')]
    [string]$Path = 'C:\Temp\certs',
    [parameter(Position=1, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName = 'cer' )]
    [parameter(Position=1, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName = 'pfx' )]
    [alias('Certificate')]
    [string]$CertificateName = 'vcloud-lab-Automation-Account-Ps',
    [parameter(Position=1, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName = 'cer' )]
    [parameter(Position=1, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName = 'pfx' )]
    [string]$KeyVaultName = 'vcloudvault',
    [parameter(Position=2, ParameterSetName = 'pfx', Mandatory=$true)]
    [switch]$Pfx,
    [parameter(Position=3, ParameterSetName = 'pfx')]
    [string]$PfxCertPassword = '123456',
    [parameter(Position=2, ParameterSetName = 'cer', Mandatory=$true)]
    [switch]$Cer
) #Param
begin
{
    $testFolderPath = Test-Path $Path
    if ($testFolderPath -eq $false)
    {
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
    }
    $certFolderPath = $Path
    
    #Verify Azure Key Vault and Certificate
    $azKeyVault = Get-AzKeyVault -VaultName $KeyVaultName
    try {
        $azKeyVaultSecret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $CertificateName -ErrorAction Stop
    }
    catch {
        Write-Host "Error - Check KeyVault '$KeyVaultName' or Certificate '$CertificateName' doesnt Exist" -BackgroundColor DarkRed
        Break
    }
    
} #begin
process 
{
    #Prepare to export Azure Key Vault certificate to local file
    if (($null -eq $azKeyVault) -or ($null -eq $azKeyVaultSecret))
    {
        Write-Host "Error - Check KeyVault '$KeyVaultName' or Certificate '$CertificateName' doesnt Exist" -BackgroundColor DarkRed
        Break
    } #if (($null -eq $azKeyVault) -or ($null -eq $azKeyVaultSecret))
    else {
        Write-Host "Verified - Key Vault and Certificate exists - '$KeyVaultName' and '$CertificateName'" -BackgroundColor DarkGreen
        #Put KeyVault Certificate information in memory to export
        [PSCredential]$password = New-Object System.Management.Automation.PSCredential('vcloud-lab.com',$azKeyVaultSecret.SecretValue)
        $cert64TextString = [System.Convert]::FromBase64String($password.GetNetworkCredential().password)
        $x509CertCollection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
        $x509CertCollection.Import($cert64TextString, $null, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)        
        if ($PSCmdlet.ParameterSetName -eq 'cer')
        {
            #Export Azure Key Vault certificate to .cer file
            $azKeyVaultCert = Get-AzKeyVaultCertificate -VaultName $keyVaultName -Name $CertificateName
            $azKeyVaultCertBytes = $azKeyVaultCert.Certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)
            $cerCertFile = "$certFolderPath\$CertificateName.cer"
            [System.IO.File]::WriteAllBytes($cerCertFile, $azKeyVaultCertBytes)
            Write-Host "Exported certificate to file - $certFolderPath\$CertificateName.cer"
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'pfx')
        {
            #Export Azure Key Vault certificate to .pfx file 
            $x509CertCollectionBytes = $x509CertCollection.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $PfxCertPassword)
            $pfxCertFile = "$certFolderPath\$CertificateName.pfx"
            [System.IO.File]::WriteAllBytes($pfxCertFile, $x509CertCollectionBytes)
            Write-Host "Exported certificate to file - $certFolderPath\$CertificateName.cer"
        }
    } #else if (($null -eq $azKeyVault) -or ($null -eq $azKeyVaultSecret))
} #process
end {} #end
