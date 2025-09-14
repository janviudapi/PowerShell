#    .NOTES
#    --------------------------------------------------------------------------------
#     Generated on:            13-Sep-25 8:15 PM
#     Generated for:           Azure Application Gateway Demos
#     PowerShell Version:      V7
#    --------------------------------------------------------------------------------
#    .DESCRIPTION
#        vcloud-lab.com Self Signed Certificate Generator

$assemblies = ('System.Windows.Forms', 'System.Data', 'System.Drawing', 'PresentationFramework')
$assemblies | Foreach-Object {[void][reflection.assembly]::Load($_)}
Add-Type -AssemblyName "System.Drawing", "System.Windows.Forms", "System.Data", "System.Design", "PresentationFramework"

[System.Windows.Forms.Application]::EnableVisualStyles()
$WinForm = New-Object 'System.Windows.Forms.Form'
$buttonCreateZip = New-Object 'System.Windows.Forms.Button'
$statusstrip1 = New-Object 'System.Windows.Forms.StatusStrip'
$groupbox_EndEntity = New-Object 'System.Windows.Forms.GroupBox'
$label_AddEndEntityYearsInfo = New-Object 'System.Windows.Forms.Label'
$label_DNSName = New-Object 'System.Windows.Forms.Label'
$datetimepicker_EndEntityYears = New-Object 'System.Windows.Forms.DateTimePicker'
$label_EndEntityAddYears = New-Object 'System.Windows.Forms.Label'
$textbox_EndEntityDNSName = New-Object 'System.Windows.Forms.TextBox'
$label_EndEntity = New-Object 'System.Windows.Forms.Label'
$combobox_EndKeyLength = New-Object 'System.Windows.Forms.ComboBox'
$textbox_EndEntityCAName = New-Object 'System.Windows.Forms.TextBox'
$labelKeyLength = New-Object 'System.Windows.Forms.Label'
$groupbox_RootCA = New-Object 'System.Windows.Forms.GroupBox'
$label_AddRootCAYearsInfo = New-Object 'System.Windows.Forms.Label'
$datetimepicker_RootCAYears = New-Object 'System.Windows.Forms.DateTimePicker'
$labelAddYears = New-Object 'System.Windows.Forms.Label'
$combobox_RootKeyLength = New-Object 'System.Windows.Forms.ComboBox'
$labelRootCAKeyLength = New-Object 'System.Windows.Forms.Label'
$labelCNName = New-Object 'System.Windows.Forms.Label'
$textbox_CAName = New-Object 'System.Windows.Forms.TextBox'
$buttonGenerateCert = New-Object 'System.Windows.Forms.Button'
$maskedtextbox_PfxPassword = New-Object 'System.Windows.Forms.MaskedTextBox'
$labelCertPassword = New-Object 'System.Windows.Forms.Label'
$buttonSelectFolder = New-Object 'System.Windows.Forms.Button'
$textbox_SelectFolderPath = New-Object 'System.Windows.Forms.TextBox'
$labelPath = New-Object 'System.Windows.Forms.Label'
$folderbrowserdialog_GetFolderPath = New-Object 'System.Windows.Forms.FolderBrowserDialog'
$toolstripstatuslabel1 = New-Object 'System.Windows.Forms.ToolStripStatusLabel'
$toolstripprogressbar_Status = New-Object 'System.Windows.Forms.ToolStripProgressBar'
$toolstripstatuslabel_Status = New-Object 'System.Windows.Forms.ToolStripStatusLabel'
$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'

$WinForm_Load={
    $currentRootCADate = $datetimepicker_RootCAYears.Value
    $10YrsDate = $currentRootCADate.AddYears(10)
    $datetimepicker_RootCAYears.Value = $10YrsDate
    $datetimepicker_RootCAYears.MinDate = (Get-Date).DateTime
    $datetimepicker_RootCAYears.MaxDate = (Get-Date).AddYears(20).DateTime
    
    $currentEndEntityDate = $datetimepicker_EndEntityYears.Value
    $1YrsDate = $currentEndEntityDate.AddYears(1)
    $datetimepicker_EndEntityYears.Value = $1YrsDate
    $datetimepicker_EndEntityYears.MinDate = (Get-Date).DateTime
    $datetimepicker_EndEntityYears.MaxDate = (Get-Date).AddYears(3).DateTime
}

$buttonSelectFolder_Click={
    $folderbrowserdialog_GetFolderPath.ShowDialog()
    $textbox_SelectFolderPath.Text = $folderbrowserdialog_GetFolderPath.SelectedPath
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
}

$buttonGenerateCert_Click={
    if (!(Test-Path $textbox_SelectFolderPath.Text))
    {
        #New-Item -Path $textbox_SelectFolderPath.Text -ItemType Directory -Force | Out-Null
        New-Item -Path "$($textbox_SelectFolderPath.Text)\Old" -ItemType Directory -Force | Out-Null
        $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    }
    else {
        Get-ChildItem $textbox_SelectFolderPath.Text -Exclude Old | Foreach-Object {Move-Item -Path $_.FullName -Destination "$($textbox_SelectFolderPath.Text)\Old" -Force }
    }

    $OutDir = $textbox_SelectFolderPath.Text
    $pfxPassword = $maskedtextbox_PfxPassword.Text
    $maskedtextbox_PfxPassword.Text | Out-File -FilePath $OutDir\_Password.txt
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100

    # -------------------------
    # 1) Create Root key + certifica te (self-signed)
    # -------------------------
    $rootKey = [System.Security.Cryptography.RSA]::Create([int]$combobox_RootKeyLength.SelectedItem)
    $rootPrivateKey = $rootKey.ExportRSAPrivateKeyPem()
    Set-Content -Path "$OutDir\RootCA_Private.key" -Value $rootPrivateKey | Out-Null
    $rootPublicKey = $rootKey.ExportRSAPublicKeyPem()
    Set-Content -Path "$OutDir\RootCA_Public.key" -Value $rootPublicKey | Out-Null
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    
    $rootSubject = [System.Security.Cryptography.X509Certificates.X500DistinguishedName]::new("CN=$($textbox_CAName.Text)")
    $rootReq = [System.Security.Cryptography.X509Certificates.CertificateRequest]::new(
        $rootSubject, $rootKey,
        [System.Security.Cryptography.HashAlgorithmName]::SHA256,
        [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
    )

    $rootReq.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509BasicConstraintsExtension]::new($true, $true, 3, $true)
    )
    $rootReq.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierExtension]::new($rootReq.PublicKey, $false)
    )
    $rootKeyUsage = `
    [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::KeyCertSign -bor `
    [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::CrlSign -bor `
    [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::DigitalSignature -bor `
    [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::KeyEncipherment
    
    $rootReq.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509KeyUsageExtension]::new($rootKeyUsage, $true)
    )
    
    $rootCAYears = $datetimepicker_RootCAYears.Value.Year - (Get-Date).Year
    
    $rootNotBefore = [System.DateTimeOffset]::Now
    $rootNotAfter = $rootNotBefore.AddYears([System.Math]::Abs($rootCAYears))
    $rootCert = $rootReq.CreateSelfSigned($rootNotBefore, $rootNotAfter)
    
    [System.IO.File]::WriteAllBytes("$OutDir\RootCA.cer", $rootCert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
    $rootPfxBytes = $rootCert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pfx, $pfxPassword)
    [System.IO.File]::WriteAllBytes("$OutDir\RootCA.pfx", $rootPfxBytes)
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    
    # -------------------------
    # 2) Create Child key + CSR-like request and sign it with Root CA
    # -------------------------
    $childKey = [System.Security.Cryptography.RSA]::Create([int]$combobox_EndKeyLength.SelectedItem)
    $childPrivateKey = $childKey.ExportRSAPrivateKeyPem()
    Set-Content -Path "$OutDir\$($textbox_EndEntityCAName.Text)_Private.key" -Value $childPrivateKey | Out-Null
    $ChildPublicKey = $childKey.ExportRSAPublicKeyPem()
    Set-Content -Path "$OutDir\$($textbox_EndEntityCAName.Text)_Public.key" -Value $ChildPublicKey | Out-Null
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    
    $childSubject = [System.Security.Cryptography.X509Certificates.X500DistinguishedName]::new("CN=$($textbox_EndEntityCAName.Text)")
    $childReq = [System.Security.Cryptography.X509Certificates.CertificateRequest]::new(
        $childSubject, $childKey,
        [System.Security.Cryptography.HashAlgorithmName]::SHA256,
        [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
    )

    $childReq.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509BasicConstraintsExtension]::new($false, $false, 0, $false)
    )
    $childReq.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509KeyUsageExtension]::new(
            [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::DigitalSignature -bor `
            [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::KeyEncipherment, $true
        )
    )
    $childReq.CertificateExtensions.Add(
        [System.Security.Cryptography.X509Certificates.X509SubjectKeyIdentifierExtension]::new($childReq.PublicKey, $false)
    )
    $san = [System.Security.Cryptography.X509Certificates.SubjectAlternativeNameBuilder]::new()
    $san.AddDnsName("$($textbox_EndEntityDNSName.Text)")
    $childReq.CertificateExtensions.Add($san.Build())
    
    $endEntityYears = $datetimepicker_EndEntityYears.Value.Year - (Get-Date).Year
    $childNotBefore = [System.DateTimeOffset]::Now
    $childNotAfter = $childNotBefore.AddYears($endEntityYears)
    $serial = New-Object byte[] 20
    [System.Security.Cryptography.RandomNumberGenerator]::Fill($serial)

    $childCertPublic = $childReq.Create($rootCert, $childNotBefore, $childNotAfter, $serial)
    $childCert = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::CopyWithPrivateKey($childCertPublic, $childKey)
    
    $childPfxBytes = $childCert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pfx, $pfxPassword)
    [System.IO.File]::WriteAllBytes("$OutDir\$($textbox_EndEntityDNSName.Text).pfx", $childPfxBytes)

    [System.IO.File]::WriteAllBytes("$OutDir\$($textbox_EndEntityDNSName.Text).cer", $childCert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    
    # -------------------------
    # 3) Export Private / Public Keys to PEM files
    #    - Try modern API ExportRSAPrivateKeyPem()/ExportRSAPublicKeyPem()
    #    - Fallback to ExportRSAPrivateKey()/ExportRSAPublicKey() (DER bytes) and wrap base64
    # -------------------------
    function Write-DerAsPem
    {
        param (
            [byte[]]$Der,
            [string]$Header,
            [string]$OutPath
        )
        $b64 = [System.Convert]::ToBase64String($Der)
        $lines = ($b64 -split "(.{1,64})" -ne "")
        $pem = "-----BEGIN $Header-----`n" + ($lines -join "`n") + "`n-----END $Header-----`n"
        Set-Content -Path $OutPath -Value $pem -NoNewline
    }
    function Save-RsaPrivateKeyPem
    {
        param ([System.Security.Cryptography.RSA]$rsa,
            [string]$pathPkcs1,
            [string]$pathPkcs8)
        if ($rsa -and $rsa.GetType().GetMethod("ExportRSAPrivateKeyPem"))
        {
            $pkcs1Pem = $rsa.ExportRSAPrivateKeyPem()
            Set-Content -Path $pathPkcs1 -Value $pkcs1Pem -NoNewline
            if ($rsa.GetType().GetMethod("ExportPkcs8PrivateKeyPem"))
            {
                $pkcs8Pem = $rsa.ExportPkcs8PrivateKeyPem()
                Set-Content -Path $pathPkcs8 -Value $pkcs8Pem -NoNewline
            }
        }
        else
        {
            $der = $rsa.ExportRSAPrivateKey()
            Write-DerAsPem -Der $der -Header "RSA PRIVATE KEY" -OutPath $pathPkcs1
            $derPk8 = $rsa.ExportPkcs8PrivateKey()
            Write-DerAsPem -Der $derPk8 -Header "PRIVATE KEY" -OutPath $pathPkcs8
        }
    }
    
    function Save-RsaPublicKeyPem
    {
        param ([System.Security.Cryptography.RSA]$rsa,
            [string]$path)
        if ($rsa.GetType().GetMethod("ExportRSAPublicKeyPem"))
        {
            $pem = $rsa.ExportRSAPublicKeyPem()
            Set-Content -Path $path -Value $pem -NoNewline
        }
        else
        {
            $der = $rsa.ExportRSAPublicKey()
            Write-DerAsPem -Der $der -Header "RSA PUBLIC KEY" -OutPath $path
        }
    }
    
    Save-RsaPrivateKeyPem -rsa $rootKey -pathPkcs1 "$OutDir\RootCA_private_pkcs1.pem" -pathPkcs8 "$OutDir\RootCA_private_pkcs8.pem"
    Save-RsaPublicKeyPem -rsa $rootKey -path "$OutDir\RootCA_public_rsa.pem"
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    Save-RsaPrivateKeyPem -rsa $childKey -pathPkcs1 "$OutDir\$($textbox_EndEntityDNSName.Text)_rsa_private_pkcs1.pem" -pathPkcs8 "$OutDir\$($textbox_EndEntityDNSName.Text)_private_pkcs8.pem"
    Save-RsaPublicKeyPem -rsa $childKey -path "$OutDir\$($textbox_EndEntityDNSName.Text)_public_rsa.pem"
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    
    # -------------------------
    # 4) Export Certificate (PEM) and create combined PEM files
    # -------------------------
    function Write-CertAsPem
    {
        param ([System.Security.Cryptography.X509Certificates.X509Certificate2]$cert,
            [string]$outPath)
        $der = $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)
        Write-DerAsPem -Der $der -Header "CERTIFICATE" -OutPath $outPath
    }
    
    Write-CertAsPem -cert $rootCert -outPath "$OutDir\RootCA.pem"
    Write-CertAsPem -cert $childCert -outPath "$OutDir\$($textbox_EndEntityDNSName.Text).pem"
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    $childPrivPem = Get-Content -Raw "$OutDir\$($textbox_EndEntityDNSName.Text)_private_pkcs8.pem"
    $childCertPem = Get-Content -Raw "$OutDir\$($textbox_EndEntityDNSName.Text).pem"
    Set-Content -Path "$OutDir\$($textbox_EndEntityDNSName.Text)_combined.pem" -Value ($childPrivPem + "`n" + $childCertPem) -NoNewline
    $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    $childCertContent = Get-Content -Raw "$OutDir\$($textbox_EndEntityDNSName.Text).pem"
    $rootCertContent = Get-Content -Raw "$OutDir\RootCA.pem"
    Set-Content -Path "$OutDir\$($textbox_EndEntityDNSName.Text)_chain.pem" -Value ($childCertContent + "`n" + $rootCertContent) -NoNewline
    $toolstripprogressbar_Status.Value = 100
    $toolstripstatuslabel_Status.Text = "Certificates Generated."
}

$datetimepicker_RootCAYears_ValueChanged={
    $rootCAYears = $datetimepicker_RootCAYears.Value.Year - (Get-Date).Year
    $label_AddRootCAYearsInfo.Text = $rootCAYears
}

$datetimepicker_EndEntityYears_ValueChanged={
    $endEntityYears = $datetimepicker_EndEntityYears.Value.Year - (Get-Date).Year
    $label_AddEndEntityYearsInfo.Text = $endEntityYears
}

$buttonCreateZip_Click={
    # -------------------------
    # 4) Create a Zip file
    # -------------------------
    $OutDir = $textbox_SelectFolderPath.Text
    $zipPath = Join-Path $OutDir "$($textbox_EndEntityDNSName.Text).zip"
    if (Test-Path $zipPath)
    {
        Remove-Item -Path $zipPath -Force
        $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
    }
    $filesToZip = Get-ChildItem -Path $OutDir -File | Where-Object { $_.Extension -ne ".zip" }
    if ($filesToZip.Count -gt 1)
    { 
        $toolstripprogressbar_Status.Value = Get-Random -Minimum 0 -Maximum 100
        Compress-Archive -Path $filesToZip.FullName -DestinationPath $zipPath -Force -CompressionLevel Optimal
        $toolstripstatuslabel_Status.Text = "File: $($textbox_EndEntityDNSName.Text).zip"
        $toolstripprogressbar_Status.Value = 100
    }
    else
    {
        $toolstripstatuslabel_Status.Text = "No files to zip."
    }
}

$Form_StateCorrection_Load=
{
    $WinForm.WindowState = $InitialFormWindowState
}

$Form_StoreValues_Closing=
{
    $script:MainForm_datetimepicker_EndEntityYears = $datetimepicker_EndEntityYears.Value
    $script:MainForm_textbox_EndEntityDNSName = $textbox_EndEntityDNSName.Text
    $script:MainForm_combobox_EndKeyLength = $combobox_EndKeyLength.Text
    $script:MainForm_combobox_EndKeyLength_SelectedItem = $combobox_EndKeyLength.SelectedItem
    $script:MainForm_textbox_EndEntityCAName = $textbox_EndEntityCAName.Text
    $script:MainForm_datetimepicker_RootCAYears = $datetimepicker_RootCAYears.Value
    $script:MainForm_combobox_RootKeyLength = $combobox_RootKeyLength.Text
    $script:MainForm_combobox_RootKeyLength_SelectedItem = $combobox_RootKeyLength.SelectedItem
    $script:MainForm_textbox_CAName = $textbox_CAName.Text
    $script:MainForm_textbox_SelectFolderPath = $textbox_SelectFolderPath.Text
}

$Form_Cleanup_FormClosed=
{
    try
    {
        $buttonCreateZip.remove_Click($buttonCreateZip_Click)
        $datetimepicker_EndEntityYears.remove_ValueChanged($datetimepicker_EndEntityYears_ValueChanged)
        $datetimepicker_RootCAYears.remove_ValueChanged($datetimepicker_RootCAYears_ValueChanged)
        $buttonGenerateCert.remove_Click($buttonGenerateCert_Click)
        $buttonSelectFolder.remove_Click($buttonSelectFolder_Click)
        $WinForm.remove_Load($WinForm_Load)
        $WinForm.remove_Load($Form_StateCorrection_Load)
        $WinForm.remove_Closing($Form_StoreValues_Closing)
        $WinForm.remove_FormClosed($Form_Cleanup_FormClosed)
    }
    catch { Out-Null }
    $WinForm.Dispose()
    $labelPath.Dispose()
    $textbox_SelectFolderPath.Dispose()
    $folderbrowserdialog_GetFolderPath.Dispose()
    $buttonSelectFolder.Dispose()
    $labelCertPassword.Dispose()
    $maskedtextbox_PfxPassword.Dispose()
    $buttonGenerateCert.Dispose()
    $groupbox_RootCA.Dispose()
    $textbox_CAName.Dispose()
    $labelCNName.Dispose()
    $labelRootCAKeyLength.Dispose()
    $combobox_RootKeyLength.Dispose()
    $labelAddYears.Dispose()
    $datetimepicker_RootCAYears.Dispose()
    $label_AddRootCAYearsInfo.Dispose()
    $groupbox_EndEntity.Dispose()
    $labelKeyLength.Dispose()
    $combobox_EndKeyLength.Dispose()
    $label_EndEntity.Dispose()
    $textbox_EndEntityCAName.Dispose()
    $label_DNSName.Dispose()
    $textbox_EndEntityDNSName.Dispose()
    $label_AddEndEntityYearsInfo.Dispose()
    $datetimepicker_EndEntityYears.Dispose()
    $label_EndEntityAddYears.Dispose()
    $statusstrip1.Dispose()
    $toolstripstatuslabel1.Dispose()
    $toolstripprogressbar_Status.Dispose()
    $buttonCreateZip.Dispose()
    $toolstripstatuslabel_Status.Dispose()
}

$WinForm.SuspendLayout()
$groupbox_RootCA.SuspendLayout()
$groupbox_EndEntity.SuspendLayout()
$statusstrip1.SuspendLayout()

$WinForm.Controls.Add($buttonCreateZip)
$WinForm.Controls.Add($statusstrip1)
$WinForm.Controls.Add($groupbox_EndEntity)
$WinForm.Controls.Add($groupbox_RootCA)
$WinForm.Controls.Add($buttonGenerateCert)
$WinForm.Controls.Add($maskedtextbox_PfxPassword)
$WinForm.Controls.Add($labelCertPassword)
$WinForm.Controls.Add($buttonSelectFolder)
$WinForm.Controls.Add($textbox_SelectFolderPath)
$WinForm.Controls.Add($labelPath)
$WinForm.AutoScaleDimensions = New-Object System.Drawing.SizeF(8, 17)
$WinForm.AutoScaleMode = 'Font'
$WinForm.ClientSize = New-Object System.Drawing.Size(482, 453)
$WinForm.FormBorderStyle = 'FixedDialog'
$WinForm.Name = 'WinForm'
$WinForm.Text = 'One Click Key & Self Signed Certificate'
$WinForm.add_Load($WinForm_Load)

$buttonCreateZip.Location = New-Object System.Drawing.Point(369, 394)
$buttonCreateZip.Margin = '4, 4, 4, 4'
$buttonCreateZip.Name = 'buttonCreateZip'
$buttonCreateZip.Size = New-Object System.Drawing.Size(100, 30)
$buttonCreateZip.TabIndex = 11
$buttonCreateZip.Text = 'Create Zip'
$buttonCreateZip.UseVisualStyleBackColor = $True
$buttonCreateZip.add_Click($buttonCreateZip_Click)

[void]$statusstrip1.Items.Add($toolstripstatuslabel1)
[void]$statusstrip1.Items.Add($toolstripprogressbar_Status)
[void]$statusstrip1.Items.Add($toolstripstatuslabel_Status)
$statusstrip1.Location = New-Object System.Drawing.Point(0, 428)
$statusstrip1.Name = 'statusstrip1'
$statusstrip1.Padding = '1, 0, 19, 0'
$statusstrip1.Size = New-Object System.Drawing.Size(482, 25)
$statusstrip1.TabIndex = 10
$statusstrip1.Text = 'statusstrip1'

$groupbox_EndEntity.Controls.Add($label_AddEndEntityYearsInfo)
$groupbox_EndEntity.Controls.Add($label_DNSName)
$groupbox_EndEntity.Controls.Add($datetimepicker_EndEntityYears)
$groupbox_EndEntity.Controls.Add($label_EndEntityAddYears)
$groupbox_EndEntity.Controls.Add($textbox_EndEntityDNSName)
$groupbox_EndEntity.Controls.Add($label_EndEntity)
$groupbox_EndEntity.Controls.Add($combobox_EndKeyLength)
$groupbox_EndEntity.Controls.Add($textbox_EndEntityCAName)
$groupbox_EndEntity.Controls.Add($labelKeyLength)
$groupbox_EndEntity.Location = New-Object System.Drawing.Point(13, 225)
$groupbox_EndEntity.Margin = '4, 4, 4, 4'
$groupbox_EndEntity.Name = 'groupbox_EndEntity'
$groupbox_EndEntity.Padding = '4, 4, 4, 4'
$groupbox_EndEntity.Size = New-Object System.Drawing.Size(454, 161)
$groupbox_EndEntity.TabIndex = 9
$groupbox_EndEntity.TabStop = $False
$groupbox_EndEntity.Text = 'Self Signed Certificate Information for End Entity'

$label_AddEndEntityYearsInfo.AutoSize = $True
$label_AddEndEntityYearsInfo.Location = New-Object System.Drawing.Point(395, 129)
$label_AddEndEntityYearsInfo.Margin = '4, 0, 4, 0'
$label_AddEndEntityYearsInfo.Name = 'label_AddEndEntityYearsInfo'
$label_AddEndEntityYearsInfo.Size = New-Object System.Drawing.Size(16, 17)
$label_AddEndEntityYearsInfo.TabIndex = 9
$label_AddEndEntityYearsInfo.Text = '1'

$label_DNSName.AutoSize = $True
$label_DNSName.Location = New-Object System.Drawing.Point(8, 96)
$label_DNSName.Margin = '4, 0, 4, 0'
$label_DNSName.Name = 'label_DNSName'
$label_DNSName.Size = New-Object System.Drawing.Size(82, 17)
$label_DNSName.TabIndex = 10
$label_DNSName.Text = 'DNS Name:'

$datetimepicker_EndEntityYears.Location = New-Object System.Drawing.Point(122, 124)
$datetimepicker_EndEntityYears.Margin = '4, 4, 4, 4'
$datetimepicker_EndEntityYears.Name = 'datetimepicker_EndEntityYears'
$datetimepicker_EndEntityYears.Size = New-Object System.Drawing.Size(265, 23)
$datetimepicker_EndEntityYears.TabIndex = 8
$datetimepicker_EndEntityYears.add_ValueChanged($datetimepicker_EndEntityYears_ValueChanged)

$label_EndEntityAddYears.AutoSize = $True
$label_EndEntityAddYears.Location = New-Object System.Drawing.Point(8, 129)
$label_EndEntityAddYears.Margin = '4, 0, 4, 0'
$label_EndEntityAddYears.Name = 'label_EndEntityAddYears'
$label_EndEntityAddYears.Size = New-Object System.Drawing.Size(78, 17)
$label_EndEntityAddYears.TabIndex = 7
$label_EndEntityAddYears.Text = 'Add Years:'

$textbox_EndEntityDNSName.Location = New-Object System.Drawing.Point(122, 93)
$textbox_EndEntityDNSName.Margin = '4, 4, 4, 4'
$textbox_EndEntityDNSName.Name = 'textbox_EndEntityDNSName'
$textbox_EndEntityDNSName.Size = New-Object System.Drawing.Size(192, 23)
$textbox_EndEntityDNSName.TabIndex = 9
$textbox_EndEntityDNSName.Text = 'Azure Application Gateway'

$label_EndEntity.AutoSize = $True
$label_EndEntity.Location = New-Object System.Drawing.Point(8, 65)
$label_EndEntity.Margin = '4, 0, 4, 0'
$label_EndEntity.Name = 'label_EndEntity'
$label_EndEntity.Size = New-Object System.Drawing.Size(72, 17)
$label_EndEntity.TabIndex = 8
$label_EndEntity.Text = 'CN Name:'

$combobox_EndKeyLength.FormattingEnabled = $True
[void]$combobox_EndKeyLength.Items.Add('1024')
[void]$combobox_EndKeyLength.Items.Add('2048')
[void]$combobox_EndKeyLength.Items.Add('3072')
[void]$combobox_EndKeyLength.Items.Add('4096')
$combobox_EndKeyLength.Location = New-Object System.Drawing.Point(122, 29)
$combobox_EndKeyLength.Margin = '4, 4, 4, 4'
$combobox_EndKeyLength.Name = 'combobox_EndKeyLength'
$combobox_EndKeyLength.Size = New-Object System.Drawing.Size(192, 25)
$combobox_EndKeyLength.TabIndex = 7
$combobox_EndKeyLength.Text = '2048'

$textbox_EndEntityCAName.Location = New-Object System.Drawing.Point(122, 62)
$textbox_EndEntityCAName.Margin = '4, 4, 4, 4'
$textbox_EndEntityCAName.Name = 'textbox_EndEntityCAName'
$textbox_EndEntityCAName.Size = New-Object System.Drawing.Size(192, 23)
$textbox_EndEntityCAName.TabIndex = 7
$textbox_EndEntityCAName.Text = 'Azure Application Gateway'

$labelKeyLength.AutoSize = $True
$labelKeyLength.Location = New-Object System.Drawing.Point(8, 32)
$labelKeyLength.Margin = '4, 0, 4, 0'
$labelKeyLength.Name = 'labelKeyLength'
$labelKeyLength.Size = New-Object System.Drawing.Size(84, 17)
$labelKeyLength.TabIndex = 0
$labelKeyLength.Text = 'Key Length:'

$groupbox_RootCA.Controls.Add($label_AddRootCAYearsInfo)
$groupbox_RootCA.Controls.Add($datetimepicker_RootCAYears)
$groupbox_RootCA.Controls.Add($labelAddYears)
$groupbox_RootCA.Controls.Add($combobox_RootKeyLength)
$groupbox_RootCA.Controls.Add($labelRootCAKeyLength)
$groupbox_RootCA.Controls.Add($labelCNName)
$groupbox_RootCA.Controls.Add($textbox_CAName)
$groupbox_RootCA.Location = New-Object System.Drawing.Point(13, 89)
$groupbox_RootCA.Margin = '4, 4, 4, 4'
$groupbox_RootCA.Name = 'groupbox_RootCA'
$groupbox_RootCA.Padding = '4, 4, 4, 4'
$groupbox_RootCA.Size = New-Object System.Drawing.Size(454, 128)
$groupbox_RootCA.TabIndex = 8
$groupbox_RootCA.TabStop = $False
$groupbox_RootCA.Text = 'Self Signed Root CA Information'

$label_AddRootCAYearsInfo.AutoSize = $True
$label_AddRootCAYearsInfo.Location = New-Object System.Drawing.Point(395, 93)
$label_AddRootCAYearsInfo.Margin = '4, 0, 4, 0'
$label_AddRootCAYearsInfo.Name = 'label_AddRootCAYearsInfo'
$label_AddRootCAYearsInfo.Size = New-Object System.Drawing.Size(24, 17)
$label_AddRootCAYearsInfo.TabIndex = 6
$label_AddRootCAYearsInfo.Text = '10'

$datetimepicker_RootCAYears.Location = New-Object System.Drawing.Point(122, 88)
$datetimepicker_RootCAYears.Margin = '4, 4, 4, 4'
$datetimepicker_RootCAYears.Name = 'datetimepicker_RootCAYears'
$datetimepicker_RootCAYears.Size = New-Object System.Drawing.Size(265, 23)
$datetimepicker_RootCAYears.TabIndex = 5
$datetimepicker_RootCAYears.add_ValueChanged($datetimepicker_RootCAYears_ValueChanged)

$labelAddYears.AutoSize = $True
$labelAddYears.Location = New-Object System.Drawing.Point(8, 93)
$labelAddYears.Margin = '4, 0, 4, 0'
$labelAddYears.Name = 'labelAddYears'
$labelAddYears.Size = New-Object System.Drawing.Size(78, 17)
$labelAddYears.TabIndex = 4
$labelAddYears.Text = 'Add Years:'

$combobox_RootKeyLength.FormattingEnabled = $True
[void]$combobox_RootKeyLength.Items.Add('1024')
[void]$combobox_RootKeyLength.Items.Add('2048')
[void]$combobox_RootKeyLength.Items.Add('3072')
[void]$combobox_RootKeyLength.Items.Add('4096')
$combobox_RootKeyLength.Location = New-Object System.Drawing.Point(122, 24)
$combobox_RootKeyLength.Margin = '4, 4, 4, 4'
$combobox_RootKeyLength.Name = 'combobox_RootKeyLength'
$combobox_RootKeyLength.Size = New-Object System.Drawing.Size(192, 25)
$combobox_RootKeyLength.TabIndex = 3
$combobox_RootKeyLength.Text = '4096'

$labelRootCAKeyLength.AutoSize = $True
$labelRootCAKeyLength.Location = New-Object System.Drawing.Point(8, 27)
$labelRootCAKeyLength.Margin = '4, 0, 4, 0'
$labelRootCAKeyLength.Name = 'labelRootCAKeyLength'
$labelRootCAKeyLength.Size = New-Object System.Drawing.Size(79, 17)
$labelRootCAKeyLength.TabIndex = 2
$labelRootCAKeyLength.Text = 'Key length:'

$labelCNName.AutoSize = $True
$labelCNName.Location = New-Object System.Drawing.Point(8, 60)
$labelCNName.Margin = '4, 0, 4, 0'
$labelCNName.Name = 'labelCNName'
$labelCNName.Size = New-Object System.Drawing.Size(72, 17)
$labelCNName.TabIndex = 1
$labelCNName.Text = 'CN Name:'

$textbox_CAName.Location = New-Object System.Drawing.Point(122, 57)
$textbox_CAName.Margin = '4, 4, 4, 4'
$textbox_CAName.Name = 'textbox_CAName'
$textbox_CAName.Size = New-Object System.Drawing.Size(192, 23)
$textbox_CAName.TabIndex = 0
$textbox_CAName.Text = 'RootCA'

$buttonGenerateCert.Location = New-Object System.Drawing.Point(335, 51)
$buttonGenerateCert.Margin = '4, 4, 4, 4'
$buttonGenerateCert.Name = 'buttonGenerateCert'
$buttonGenerateCert.Size = New-Object System.Drawing.Size(132, 30)
$buttonGenerateCert.TabIndex = 7
$buttonGenerateCert.Text = 'Generate Cert'
$buttonGenerateCert.UseVisualStyleBackColor = $True
$buttonGenerateCert.add_Click($buttonGenerateCert_Click)

$maskedtextbox_PfxPassword.Location = New-Object System.Drawing.Point(124, 55)
$maskedtextbox_PfxPassword.Margin = '4, 4, 4, 4'
$maskedtextbox_PfxPassword.Name = 'maskedtextbox_PfxPassword'
$maskedtextbox_PfxPassword.PasswordChar = '*'
$maskedtextbox_PfxPassword.Size = New-Object System.Drawing.Size(203, 23)
$maskedtextbox_PfxPassword.TabIndex = 6
$maskedtextbox_PfxPassword.Text = 'Computer@123'

$labelCertPassword.AutoSize = $True
$labelCertPassword.Location = New-Object System.Drawing.Point(13, 58)
$labelCertPassword.Margin = '4, 0, 4, 0'
$labelCertPassword.Name = 'labelCertPassword'
$labelCertPassword.Size = New-Object System.Drawing.Size(103, 17)
$labelCertPassword.TabIndex = 4
$labelCertPassword.Text = 'Cert Password:'

$buttonSelectFolder.Location = New-Object System.Drawing.Point(335, 13)
$buttonSelectFolder.Margin = '4, 4, 4, 4'
$buttonSelectFolder.Name = 'buttonSelectFolder'
$buttonSelectFolder.Size = New-Object System.Drawing.Size(134, 30)
$buttonSelectFolder.TabIndex = 2
$buttonSelectFolder.Text = 'Select Folder'
$buttonSelectFolder.UseVisualStyleBackColor = $True
$buttonSelectFolder.add_Click($buttonSelectFolder_Click)

$textbox_SelectFolderPath.Location = New-Object System.Drawing.Point(124, 17)
$textbox_SelectFolderPath.Margin = '4, 4, 4, 4'
$textbox_SelectFolderPath.Name = 'textbox_SelectFolderPath'
$textbox_SelectFolderPath.Size = New-Object System.Drawing.Size(203, 23)
$textbox_SelectFolderPath.TabIndex = 1
$textbox_SelectFolderPath.Text = 'C:\Temp\Certs'

$labelPath.AutoSize = $True
$labelPath.Location = New-Object System.Drawing.Point(13, 20)
$labelPath.Margin = '4, 0, 4, 0'
$labelPath.Name = 'labelPath'
$labelPath.Size = New-Object System.Drawing.Size(41, 17)
$labelPath.TabIndex = 0
$labelPath.Text = 'Path:'

$folderbrowserdialog_GetFolderPath.Description = 'Launch Get Folder Path'
$folderbrowserdialog_GetFolderPath.SelectedPath = 'C:\Temp\Certs'

$toolstripstatuslabel1.Name = 'toolstripstatuslabel1'
$toolstripstatuslabel1.Size = New-Object System.Drawing.Size(160, 20)
$toolstripstatuslabel1.Text = '     Microsoft Azure Cloud     '

$toolstripprogressbar_Status.Name = 'toolstripprogressbar_Status'
$toolstripprogressbar_Status.Size = New-Object System.Drawing.Size(100, 19)

$toolstripstatuslabel_Status.Name = 'toolstripstatuslabel_Status'
$toolstripstatuslabel_Status.Size = New-Object System.Drawing.Size(49, 20)
$toolstripstatuslabel_Status.Text = 'Status: vCloud-lab.com'
$toolstripstatuslabel_Status.AutoSize = $false
$toolstripstatuslabel_Status.Spring = $true
$toolstripstatuslabel_Status.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$toolstripstatuslabel_Status.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$statusstrip1.ResumeLayout()
$groupbox_EndEntity.ResumeLayout()
$groupbox_RootCA.ResumeLayout()
$WinForm.ResumeLayout()

$InitialFormWindowState = $WinForm.WindowState
$WinForm.add_Load($Form_StateCorrection_Load)
$WinForm.add_FormClosed($Form_Cleanup_FormClosed)
$WinForm.add_Closing($Form_StoreValues_Closing)
$WinForm.ShowDialog() | Out-Null