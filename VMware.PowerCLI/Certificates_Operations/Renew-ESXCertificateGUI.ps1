
#    .NOTES
#    --------------------------------------------------------------------------------
#     Generated on:            13-Sep-25 8:15 PM
#     Generated for:           One click Renew/Refresh ESXi certificate
#     PowerShell Version:      V7
#    --------------------------------------------------------------------------------
#    .DESCRIPTION
#        vcloud-lab.com One click Renew/Refresh ESXi certificate

$assemblies = ('System.Windows.Forms', 'System.Data', 'System.Drawing', 'PresentationFramework')
$assemblies | Foreach-Object {[void][reflection.assembly]::Load($_)}
Add-Type -AssemblyName "System.Drawing", "System.Windows.Forms", "System.Data", "System.Design", "PresentationFramework"

[System.Windows.Forms.Application]::EnableVisualStyles()
$formRenewESXiCert = New-Object 'System.Windows.Forms.Form'
$picturebox1 = New-Object 'System.Windows.Forms.PictureBox'
$buttonRenewCertificate = New-Object 'System.Windows.Forms.Button'
$buttonLogOut = New-Object 'System.Windows.Forms.Button'
$richtextbox_Result = New-Object 'System.Windows.Forms.RichTextBox'
$statusStrip = New-Object 'System.Windows.Forms.StatusStrip'
$checkedlistbox_EsxiServers = New-Object 'System.Windows.Forms.CheckedListBox'
$groupBox_Creds = New-Object 'System.Windows.Forms.GroupBox'
$buttonListESXi = New-Object 'System.Windows.Forms.Button'
$buttonLogin = New-Object 'System.Windows.Forms.Button'
$maskedtextbox_Password = New-Object 'System.Windows.Forms.MaskedTextBox'
$labelPassword = New-Object 'System.Windows.Forms.Label'
$textbox_User = New-Object 'System.Windows.Forms.TextBox'
$labelUser = New-Object 'System.Windows.Forms.Label'
$textbox_Server = New-Object 'System.Windows.Forms.TextBox'
$labelServer = New-Object 'System.Windows.Forms.Label'
$toolstripstatus_Label = New-Object 'System.Windows.Forms.ToolStripStatusLabel'
$toolstrip_Progressbar = New-Object 'System.Windows.Forms.ToolStripProgressBar'
$toolstripstatus_LabelInfo = New-Object 'System.Windows.Forms.ToolStripStatusLabel'
$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'

$formRenewESXiCert_Load={
    $checkedlistbox_EsxiServers.Items.Clear()
}

$buttonLogin_Click = {
    $toolstrip_Progressbar.Value = Get-Random -Minimum 0 -Maximum 100
    $richtextbox_Result.Text = $null
    try
    {
        Connect-VIServer -Server $textbox_Server.Text -User $textbox_User.Text -Password $maskedtextbox_Password.Text -ErrorAction Stop | Out-Null
        $richtextbox_Result.AppendText("Login successful on vCenter Servers!`n")
        $buttonListESXi.Enabled = $true
        $buttonLogOut.Enabled = $true
    }
    catch
    {
        $richtextbox_Result.AppendText("$($error[0].exception.message)`n")
    }
    $toolstrip_Progressbar.Value = 100
}

$buttonLogOut_Click = {
    $toolstrip_Progressbar.Value = Get-Random -Minimum 0 -Maximum 100
    try
    {
        Disconnect-VIserver * -Force -Confirm:$false -ErrorAction Stop
        $richtextbox_Result.AppendText("Disconnected from all vCenter Servers!`n")
    }
    catch
    {
        $richtextbox_Result.AppendText("$($error[0].exception.message)`n")
    }
    $buttonListESXi.Enabled = $false
    $buttonRenewCertificate.Enabled = $false
    $buttonLogOut.Enabled = $false
    $global:VMhost = $null
    $toolstrip_Progressbar.Value = 100
}

$buttonListESXi_Click = {
    $toolstrip_Progressbar.Value = Get-Random -Minimum 0 -Maximum 100
    $checkedlistbox_EsxiServers.Items.Clear()
    $global:VMhosts = $null
    $global:VMhosts = Get-VMhost -State Connected
    foreach ($vmhost in $global:VMhosts )
    {
        $checkedlistbox_EsxiServers.Items.Add($vmhost.Name)
        $toolstrip_Progressbar.Value = Get-Random -Minimum 0 -Maximum 100
    }
    $buttonRenewCertificate.Enabled = $true
    $toolstrip_Progressbar.Value = 100
}

$buttonRenewCertificate_Click = {
    $toolstrip_Progressbar.Value = Get-Random -Minimum 0 -Maximum 100
    if ($checkedlistbox_EsxiServers.CheckedItems.Count -eq 0)
    {
        $richtextbox_Result.AppendText("No ESXi host selected!`n")
    }
    else
    {
        foreach ($esxi in $checkedlistbox_EsxiServers.CheckedItems)
        {
            $richtextbox_Result.AppendText("------------------------------ `n")
            $richtextbox_Result.AppendText("Renewing Certificate on $esxi `n")
            $vmHost = $global:VMhosts | Where-Object {$_.Name -eq $esxi}
            $dateBeforeRenew = (Get-View -Id $vmHost.ExtensionData.ConfigManager.CertificateManager).CertificateInfo
            $hostRef = $vmhost.ExtensionData.MoRef
            $certManager = Get-View -Id 'CertificateManager-certificateManager'
            $taskID = $certManager.CertMgrRefreshCertificates_Task(@($hostRef))
            $taskInfo = Get-Task -Id $taskID.ToString()
            while ($taskInfo.State -eq 'Running')
            {
                $taskInfo = Get-Task -Id $taskID.ToString()
                $toolstrip_Progressbar.Value = Get-Random -Minimum 0 -Maximum 100
            }
            $dateAfterRenew = (Get-View -Id $vmHost.ExtensionData.ConfigManager.CertificateManager).CertificateInfo
            $postInfo = $taskInfo | Select-Object @{ Name = 'ESXi'; Expression = { $vmHost.Name } }, State, StartTime, FinishTime, PercentComplete, @{ Name = 'Before_Renew'; Expression = { $dateBeforeRenew.NotBefore } }, @{ Name = 'After_Renew'; Expression = { $dateAfterRenew.NotBefore } }
            $richtextbox_Result.AppendText("$($postInfo | Out-String) `n")
        }
        $richtextbox_Result.AppendText("------------------------------ `n")
    }
    $toolstrip_Progressbar.Value = 100
}

$Form_StateCorrection_Load=
{
    $formRenewESXiCert.WindowState = $InitialFormWindowState
}

$Form_Cleanup_FormClosed=
{
    try
    {
        $buttonRenewCertificate.remove_Click($buttonRenewCertificate_Click)
        $buttonLogOut.remove_Click($buttonLogOut_Click)
        $buttonListESXi.remove_Click($buttonListESXi_Click)
        $buttonLogin.remove_Click($buttonLogin_Click)
        $formRenewESXiCert.remove_Load($formRenewESXiCert_Load)
        $formRenewESXiCert.remove_Load($Form_StateCorrection_Load)
        $formRenewESXiCert.remove_FormClosed($Form_Cleanup_FormClosed)
    }
    catch { Out-Null }
    $formRenewESXiCert.Dispose()
    $groupBox_Creds.Dispose()
    $labelServer.Dispose()
    $textbox_Server.Dispose()
    $textbox_User.Dispose()
    $labelUser.Dispose()
    $labelPassword.Dispose()
    $maskedtextbox_Password.Dispose()
    $buttonLogin.Dispose()
    $buttonLogOut.Dispose()
    $checkedlistbox_EsxiServers.Dispose()
    $statusStrip.Dispose()
    $toolstripstatus_Label.Dispose()
    $toolstrip_Progressbar.Dispose()
    $toolstripstatus_LabelInfo.Dispose()
    $richtextbox_Result.Dispose()
    $buttonListESXi.Dispose()
    $buttonRenewCertificate.Dispose()
    $picturebox1.Dispose()
}

$formRenewESXiCert.SuspendLayout()
$groupBox_Creds.SuspendLayout()
$statusStrip.SuspendLayout()
$picturebox1.BeginInit()

$formRenewESXiCert.Controls.Add($picturebox1)
$formRenewESXiCert.Controls.Add($buttonRenewCertificate)
$formRenewESXiCert.Controls.Add($buttonLogOut)
$formRenewESXiCert.Controls.Add($richtextbox_Result)
$formRenewESXiCert.Controls.Add($statusStrip)
$formRenewESXiCert.Controls.Add($checkedlistbox_EsxiServers)
$formRenewESXiCert.Controls.Add($groupBox_Creds)
$formRenewESXiCert.AutoScaleDimensions = New-Object System.Drawing.SizeF(8, 17)
$formRenewESXiCert.AutoScaleMode = 'Font'
$formRenewESXiCert.ClientSize = New-Object System.Drawing.Size(832, 453)
$formRenewESXiCert.FormBorderStyle = 'FixedDialog'

	$ImageString = @"
AAABAAEAICAAAAEAIACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAgBAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAELC45W
Dg6UsQ0NleEODpX3Dg6X/Q4Olv4ODpb/Dg6W/w4Olv8ODpb/Dg6W/w4Olv8ODpb/Dg6W/w4Olv8O
Dpb/Dg6W/g4Ol/0ODpb3DQ2V4Q4OlLILC49XAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAIkNDQ2UuQ8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8NDZS6AACJDQAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAQ0NlLkPD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8P
D5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8P
mv8NDZS5AAAAAQAAAAAAAAAAAAAAAAAAAAALC49XDw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/
Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8LC49XAAAAAAAAAAAAAAAAAAAAAA4OlLEPD5r/Dw+a/w8Pmv8P
D5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8P
mv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w4OlLEAAAAAAAAAAAAAAAAAAAAADQ2V
4Q8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8ODpn/HByf/yEhof8hIaH/
ISGh/yEhof8jI6L/IyOi/yMjov8VFZz/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/DQ2V4QAAAAAA
AAAAAAAAAAAAAAAODpb2Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/FRWc/7Ky
3v/+/v7///////////////////////////////////////X1+v9kZL3/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8ODpX3AAAAAAAAAAAAAAAAAAAAAA4Olv0PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/
Dw+a/w8Pmv9ra8D//////////////////////////////////////////////////////+Pj8/8O
Dpn/Dw+a/w8Pmv8PD5r/Dw+a/w4Ol/0AAAAAAAAAAAAAAAAAAAAADg6W/g8Pmv8PD5r/Dw+a/w8P
mv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/4WFy////////////////////////////////////////v7+
/////////////Pz+/xAQmv8PD5r/Dw+a/w8Pmv8PD5r/Dg6W/wAAAAAAAAAAAAAAAAAAAAAODpb/
Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/hobM////////////ra3c/xMTm/8S
Epv/EhKb/xISm/8lJaP////////////9/f7/ERGa/w8Pmv8PD5r/Dw+a/w8Pmv8ODpb/AAAAAAAA
AAAAAAAAAAAAAA4Olv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/xISm/9dXbr/e3vH/3l5xv+8vOP/////
///////Gxuf/cnLE/x4eoP8PD5r/Dw+a/yIiov////////////39/v8REZr/Dw+a/w8Pmv8PD5r/
Dw+a/w4Olv8AAAAAAAAAAAAAAAAAAAAADg6W/w8Pmv8PD5r/Dw+a/w8Pmv8ODpn/paXZ////////
///////////////////////////////+/v7/Tk60/w8Pmv8PD5r/IiKi/////////////f3+/xAQ
mv8PD5r/Dw+a/w8Pmv8PD5r/Dg6W/wAAAAAAAAAAAAAAAAAAAAAODpb/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv/5+fz//////////////////////////////////v7+/39/yf8PD5r/YmK8/ywspv8hIaH/
///////////8/P7/EBCa/w8Pmv8PD5r/Dw+a/w8Pmv8ODpb/AAAAAAAAAAAAAAAAAAAAAA4Olv8P
D5r/Dw+a/w8Pmv8PD5r/ERGb//7+/v///////////7294//T0+z///////7+/v98fMj/Dg6Z/46O
z///////goLK/x8fof////////////z8/v8QEJr/Dw+a/w8Pmv8PD5r/Dw+a/w4Olv8AAAAAAAAA
AAAAAAAAAAAADg6W/w8Pmv8PD5r/Dw+a/w8Pmv8REZr//v7+////////////HR2g/35+yP/+/v7/
fHzI/w8Pmv+Njc/////////////S0uz/v7/k/////////////Pz9/xAQmv8PD5r/Dw+a/w8Pmv8P
D5r/Dg6W/wAAAAAAAAAAAAAAAAAAAAAODpb/Dw+a/w8Pmv8PD5r/Dw+a/xERm//+/v7/////////
//8cHJ//HR2g/0xMs/8ODpn/kZHQ///////////////////////////////////////09Pr/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8ODpb/AAAAAAAAAAAAAAAAAAAAAA4Olv8PD5r/Dw+a/w8Pmv8PD5r/
ERGb//7+/v///////////xwcn/8PD5r/Dw+a/2Njvf//////////////////////////////////
/////////46Oz/8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w4Olv8AAAAAAAAAAAAAAAAAAAAADg6W/w8P
mv8PD5r/Dw+a/w8Pmv8REZv/////////////////HByf/w8Pmv8PD5r/LCym/29vwv/Kyun/////
//////+0tN//bm7C/25uwv9ISLL/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dg6W/wAAAAAAAAAA
AAAAAAAAAAAODpb/Dw+a/w8Pmv8PD5r/Dw+a/xERm/////////////////8oKKT/Ghqe/xkZnv8Z
GZ7/GRme/7i44f///////////4GByv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8P
mv8ODpb/AAAAAAAAAAAAAAAAAAAAAA4Olv4PD5r/Dw+a/w8Pmv8PD5r/EhKb////////////////
////////////////////////////////////////////gIDJ/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/
Dw+a/w8Pmv8PD5r/Dw+a/w4Olv8AAAAAAAAAAAAAAAAAAAAADg6W/Q8Pmv8PD5r/Dw+a/w8Pmv8P
D5r/6+v3//////////////////////////////////////////////////////9nZ7//Dw+a/w8P
mv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dg6X/QAAAAAAAAAAAAAAAAAAAAAODpb2Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv9ZWbn/7Oz3///////////////////////////////////////9/f7/
s7Pf/xQUnP8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8ODpX3AAAAAAAAAAAA
AAAAAAAAAA0NleEPD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8TE5v/ISGh/yEhof8hIaH/Hx+g/x4e
oP8dHaD/HByf/xcXnf8ODpn/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w0NleEAAAAAAAAAAAAAAAAAAAAADg6UsQ8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/
Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8P
D5r/Dw+a/w8Pmv8PD5r/Dg6VsQAAAAAAAAAAAAAAAAAAAAALC45WDw+a/w8Pmv8PD5r/Dw+a/w8P
mv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8LC49XAAAAAAAAAAAAAAAAAAAAAAAAAAENDZS5
Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8P
D5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/DQ2UuQAAAAEAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAiQ0NDZS5Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w0NlLkAAIkN
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAELC45WDg6UsQ0NleEODpb2Dg6W/Q4Olv4O
Dpb/Dg6W/w4Olv8ODpb/Dg6W/w4Olv8ODpb/Dg6W/w4Olv8ODpb/Dg6W/g4Olv0ODpb2DQ2V4Q4O
lLELC45WAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////
///////wAAAP4AAAB8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAAD
wAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA+AAAAfw
AAAP//////////8=
"@
	$System_IO_MemoryStream = [System.IO.MemoryStream][System.Convert]::FromBase64String($ImageString)

$formRenewESXiCert.Icon = [System.Drawing.Icon]::new($System_IO_MemoryStream)
$System_IO_MemoryStream = $null

$formRenewESXiCert.StartPosition = 'CenterScreen'
$formRenewESXiCert.TopMost = $true
$formRenewESXiCert.Name = 'formRenewESXiCert'
$formRenewESXiCert.Opacity = 0.9
$formRenewESXiCert.Text = 'Renew/Refresh ESXi Server SSL Certificate'

$picturebox1.ImageLocation ="$PSScriptRoot\Phoenix.png"
$picturebox1.Location = New-Object System.Drawing.Point(558, 40)
$picturebox1.Margin = '4, 4, 4, 4'
$picturebox1.Name = 'picturebox1'
$picturebox1.Size = New-Object System.Drawing.Size(114, 97)
$picturebox1.SizeMode = 'Zoom'
$picturebox1.TabIndex = 10
$picturebox1.TabStop = $False

$buttonRenewCertificate.Enabled = $False
$buttonRenewCertificate.Location = New-Object System.Drawing.Point(680, 99)
$buttonRenewCertificate.Margin = '4, 4, 4, 4'
$buttonRenewCertificate.Name = 'buttonRenewCertificate'
$buttonRenewCertificate.Size = New-Object System.Drawing.Size(139, 29)
$buttonRenewCertificate.TabIndex = 9
$buttonRenewCertificate.Text = 'Renew Certificate'
$buttonRenewCertificate.UseVisualStyleBackColor = $True
$buttonRenewCertificate.add_Click($buttonRenewCertificate_Click)

$buttonLogOut.Enabled = $False
$buttonLogOut.Location = New-Object System.Drawing.Point(680, 42)
$buttonLogOut.Margin = '4, 4, 4, 4'
$buttonLogOut.Name = 'buttonLogOut'
$buttonLogOut.Size = New-Object System.Drawing.Size(139, 47)
$buttonLogOut.TabIndex = 7
$buttonLogOut.Text = 'Log Out'
$buttonLogOut.UseVisualStyleBackColor = $True
$buttonLogOut.add_Click($buttonLogOut_Click)

$richtextbox_Result.Location = New-Object System.Drawing.Point(384, 145)
$richtextbox_Result.Margin = '4, 4, 4, 4'
$richtextbox_Result.Name = 'richtextbox_Result'
$richtextbox_Result.Size = New-Object System.Drawing.Size(435, 274)
$richtextbox_Result.TabIndex = 3
$richtextbox_Result.Text = ''
$richtextbox_Result.ReadOnly = $True

[void]$statusStrip.Items.Add($toolstripstatus_Label)
[void]$statusStrip.Items.Add($toolstrip_Progressbar)
[void]$statusStrip.Items.Add($toolstripstatus_LabelInfo)
$statusStrip.Location = New-Object System.Drawing.Point(0, 428)
$statusStrip.Name = 'statusStrip'
$statusStrip.Padding = '1, 0, 19, 0'
$statusStrip.Size = New-Object System.Drawing.Size(832, 25)
$statusStrip.TabIndex = 2
$statusStrip.Text = 'statusStrip'

$checkedlistbox_EsxiServers.Font = [System.Drawing.Font]::new('Microsoft Sans Serif', '8.15')
$checkedlistbox_EsxiServers.FormattingEnabled = $True
[void]$checkedlistbox_EsxiServers.Items.Add('Double click to select ESXi server!')
$checkedlistbox_EsxiServers.Location = New-Object System.Drawing.Point(13, 145)
$checkedlistbox_EsxiServers.Margin = '4, 4, 4, 4'
$checkedlistbox_EsxiServers.Name = 'checkedlistbox_EsxiServers'
$checkedlistbox_EsxiServers.Size = New-Object System.Drawing.Size(363, 274)
$checkedlistbox_EsxiServers.TabIndex = 1

$groupBox_Creds.Controls.Add($buttonListESXi)
$groupBox_Creds.Controls.Add($buttonLogin)
$groupBox_Creds.Controls.Add($maskedtextbox_Password)
$groupBox_Creds.Controls.Add($labelPassword)
$groupBox_Creds.Controls.Add($textbox_User)
$groupBox_Creds.Controls.Add($labelUser)
$groupBox_Creds.Controls.Add($textbox_Server)
$groupBox_Creds.Controls.Add($labelServer)
$groupBox_Creds.Location = New-Object System.Drawing.Point(13, 13)
$groupBox_Creds.Margin = '4, 4, 4, 4'
$groupBox_Creds.Name = 'groupbox1'
$groupBox_Creds.Padding = '4, 4, 4, 4'
$groupBox_Creds.Size = New-Object System.Drawing.Size(537, 124)
$groupBox_Creds.TabIndex = 0
$groupBox_Creds.TabStop = $False
$groupBox_Creds.Text = 'vCenter information and Credentials'

$buttonListESXi.Enabled = $False
$buttonListESXi.Location = New-Object System.Drawing.Point(390, 86)
$buttonListESXi.Margin = '4, 4, 4, 4'
$buttonListESXi.Name = 'buttonListESXi'
$buttonListESXi.Size = New-Object System.Drawing.Size(139, 29)
$buttonListESXi.TabIndex = 8
$buttonListESXi.Text = 'List ESXi'
$buttonListESXi.UseVisualStyleBackColor = $True
$buttonListESXi.add_Click($buttonListESXi_Click)

$buttonLogin.Location = New-Object System.Drawing.Point(390, 27)
$buttonLogin.Margin = '4, 4, 4, 4'
$buttonLogin.Name = 'buttonLogin'
$buttonLogin.Size = New-Object System.Drawing.Size(139, 51)
$buttonLogin.TabIndex = 6
$buttonLogin.Text = 'Log In'
$buttonLogin.UseVisualStyleBackColor = $True
$buttonLogin.add_Click($buttonLogin_Click)

$maskedtextbox_Password.Location = New-Object System.Drawing.Point(90, 89)
$maskedtextbox_Password.Margin = '4, 4, 4, 4'
$maskedtextbox_Password.Name = 'maskedtextbox_Password'
$maskedtextbox_Password.PasswordChar = '*'
$maskedtextbox_Password.Size = New-Object System.Drawing.Size(291, 23)
$maskedtextbox_Password.TabIndex = 5
$maskedtextbox_Password.Text = 'Computer@123'

$labelPassword.AutoSize = $True
$labelPassword.Location = New-Object System.Drawing.Point(8, 92)
$labelPassword.Margin = '4, 0, 4, 0'
$labelPassword.Name = 'labelPassword'
$labelPassword.Size = New-Object System.Drawing.Size(73, 17)
$labelPassword.TabIndex = 4
$labelPassword.Text = 'Password:'

$textbox_User.Location = New-Object System.Drawing.Point(90, 58)
$textbox_User.Margin = '4, 4, 4, 4'
$textbox_User.Name = 'textbox_User'
$textbox_User.Size = New-Object System.Drawing.Size(291, 23)
$textbox_User.TabIndex = 3
$textbox_User.Text = 'administrator@vsphere.local'

$labelUser.AutoSize = $True
$labelUser.Location = New-Object System.Drawing.Point(8, 61)
$labelUser.Margin = '4, 0, 4, 0'
$labelUser.Name = 'labelUser'
$labelUser.Size = New-Object System.Drawing.Size(42, 17)
$labelUser.TabIndex = 2
$labelUser.Text = 'User:'

$textbox_Server.Location = New-Object System.Drawing.Point(90, 27)
$textbox_Server.Margin = '4, 4, 4, 4'
$textbox_Server.Name = 'textbox_Server'
$textbox_Server.Size = New-Object System.Drawing.Size(291, 23)
$textbox_Server.TabIndex = 1
$textbox_Server.Text = 'marvel.vcloud-lab.com'

$labelServer.AutoSize = $True
$labelServer.Location = New-Object System.Drawing.Point(8, 30)
$labelServer.Margin = '4, 0, 4, 0'
$labelServer.Name = 'labelServer'
$labelServer.Size = New-Object System.Drawing.Size(54, 17)
$labelServer.TabIndex = 0
$labelServer.Text = 'Server:'

$toolstripstatus_Label.Name = 'toolstripstatus_Label'
$toolstripstatus_Label.Size = New-Object System.Drawing.Size(112, 20)
$toolstripstatus_Label.Text = 'vcloud-lab.com'

$toolstrip_Progressbar.Name = 'toolstrip_Progressbar'
$toolstrip_Progressbar.Size = New-Object System.Drawing.Size(100, 19)

$toolstripstatus_LabelInfo.Name = 'toolstripstatus_LabelInfo'
$toolstripstatus_LabelInfo.Size = New-Object System.Drawing.Size(112, 20)
$toolstripstatus_LabelInfo.Text = 'Double click ESXi to Select!'

$picturebox1.EndInit()
$statusStrip.ResumeLayout()
$groupBox_Creds.ResumeLayout()
$formRenewESXiCert.ResumeLayout()

$InitialFormWindowState = $formRenewESXiCert.WindowState
$formRenewESXiCert.add_Load($Form_StateCorrection_Load)
$formRenewESXiCert.add_FormClosed($Form_Cleanup_FormClosed)
$formRenewESXiCert.ShowDialog()