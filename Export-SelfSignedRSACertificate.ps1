# Create a self-signed RSA certificate
$certInfo = @{
    Subject = "CN=vcloud-lab.com"
    FriendlyName = "vCloud Lab Self-Signed Certificate"
    KeyAlgorithm = "RSA"
    KeyLength = 2048
    NotAfter = (Get-Date).AddYears(1)
    CertStoreLocation = "Cert:\CurrentUser\My"
    DnsName = "vcloud-lab.com"
    KeyExportPolicy = 'Exportable'
    KeyUsage = @('DigitalSignature', 'KeyEncipherment')
}

$cert = New-SelfSignedCertificate @certInfo

Get-ChildItem -Path $certInfo.CertStoreLocation | Where-Object { $_.Thumbprint -eq $cert.Thumbprint } | Format-List

#Get-ChildItem -Path $certInfo.CertStoreLocation | Where-Object { $_.Thumbprint -eq $cert.Thumbprint } | Remove-Item -Force

################################################################################

# Export to PFX (with private key)
$password = ConvertTo-SecureString -String "YourPassword" -Force -AsPlainText
Export-PfxCertificate `
    -Cert $cert `
    -FilePath "C:\Temp\certificate.pfx" `
    -Password $password

################################################################################

# Export public key (CER)
Export-Certificate `
    -Cert $cert `
    -FilePath "C:\Temp\certificate.cer"

################################################################################
################################################################################
################################################################################

# Generate RSA key pair (2048-bit)
$rsa = [System.Security.Cryptography.RSA]::Create(2048)

# Export the private key to a PEM string
$privateKeyPem = $rsa.ExportRSAPrivateKeyPem()

# Export the public key to a PEM string
$publicKeyPem = $rsa.ExportRSAPublicKeyPem()

# Define file paths for the keys
$privateKeyFilePath = "C:\Temp\private_key.pem"
$publicKeyFilePath = "C:\Temp\public_key.pem"

# Save the private key to a file
Set-Content -Path $privateKeyFilePath -Value $privateKeyPem

# Save the public key to a file
Set-Content -Path $publicKeyFilePath -Value $publicKeyPem

##################################################################################

# Create certificate properties
$subject = [System.Security.Cryptography.X509Certificates.X500DistinguishedName]::new("CN=vcloud-lab.com")
$request = [System.Security.Cryptography.X509Certificates.CertificateRequest]::new(
    $subject,
    $rsa,
    [System.Security.Cryptography.HashAlgorithmName]::SHA256,
    [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
)

# Configure certificate validity (1 year)
$notBefore = [System.DateTimeOffset]::Now
$notAfter = $notBefore.AddYears(1)

# Generate self-signed certificate
$certificate = $request.CreateSelfSigned($notBefore, $notAfter)

###################################################################################

# Export to PFX (with private key)
$pfxPassword = "YourPassword"
$pfxBytes = $certificate.Export(
    [System.Security.Cryptography.X509Certificates.X509ContentType]::Pfx,
    $pfxPassword
)
[System.IO.File]::WriteAllBytes("C:Temp\certificate.pfx", $pfxBytes)

###################################################################################

# Export public key (CER)
$cerBytes = $certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)
[System.IO.File]::WriteAllBytes("C:\Temp\certificate.cer", $cerBytes)