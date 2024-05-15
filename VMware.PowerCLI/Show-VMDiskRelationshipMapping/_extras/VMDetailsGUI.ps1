Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'VM Disk Diagram'
$form.Size = New-Object System.Drawing.Size(300,550)
$form.StartPosition = 'CenterScreen'

#https://www.rapidtables.com/code/text/unicode-characters.html

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,30)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 11, [System.Drawing.FontStyle]::Bold)
$label.Text = "$([char]0x0921) vCenter\ESXi Details"
$form.Controls.Add($label)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,60)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = "`u{0938} Type vCenter/ESXi server IP/Hostname below:"
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,90)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$textBox.Text = "marvel.vcloud-lab.com"
$form.Controls.Add($textBox)

##### VC/ESXi #####

$labelVCUser = New-Object System.Windows.Forms.Label
$labelVCUser.Location = New-Object System.Drawing.Point(10,120)
$labelVCUser.Size = New-Object System.Drawing.Size(280,20)
$labelVCUser.Text = "$([char]0x092F) Type vCenter/ESXi Username below: "
$form.Controls.Add($labelVCUser)

$textBoxVCUser = New-Object System.Windows.Forms.TextBox
$textBoxVCUser.Location = New-Object System.Drawing.Point(10,150)
$textBoxVCUser.Size = New-Object System.Drawing.Size(260,20)
$textBoxVCUser.Text = "Administrator@vsphere.local"
$form.Controls.Add($textBoxVCUser)

#https://www.rapidtables.com/code/text/unicode-characters.html

$labelVCPassword = New-Object System.Windows.Forms.Label
$labelVCPassword.Location = New-Object System.Drawing.Point(10,180)
$labelVCPassword.Size = New-Object System.Drawing.Size(280,20)
$labelVCPassword.Text = "`u{092A}" + ' Please enter the vCenter/ESXi Password below:'
$form.Controls.Add($labelVCPassword)

$textBoxVCPassword = New-Object System.Windows.Forms.MaskedTextBox
$textBoxVCPassword.Location = New-Object System.Drawing.Point(10,210)
$textBoxVCPassword.PasswordChar = '*'
$textBoxVCPassword.Size = New-Object System.Drawing.Size(260,20)
$textBoxVCPassword.Text = "Computer@123"
$form.Controls.Add($textBoxVCPassword)

###### VM Name ######

$labelVMName = New-Object System.Windows.Forms.Label
$labelVMName.Location = New-Object System.Drawing.Point(10,240)
$labelVMName.Size = New-Object System.Drawing.Size(280,20)
$labelVMName.Text = "$([char]0x0935) Type Virtual Machine name below: "
$form.Controls.Add($labelVMName)

$textBoxVMName = New-Object System.Windows.Forms.TextBox
$textBoxVMName.Location = New-Object System.Drawing.Point(10,270)
$textBoxVMName.Size = New-Object System.Drawing.Size(260,20)
$textBoxVMName.Text = "ad001.vcloud-lab.com"
$form.Controls.Add($textBoxVMName)

###### Windows ######

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,300)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Font = [System.Drawing.Font]::new("Microsoft Sans Serif", 11, [System.Drawing.FontStyle]::Bold)
$label.Text = "$([char]0x0921) Windows VM Server Details"
$form.Controls.Add($label)

$labelWinUser = New-Object System.Windows.Forms.Label
$labelWinUser.Location = New-Object System.Drawing.Point(10,330)
$labelWinUser.Size = New-Object System.Drawing.Size(280,20)
$labelWinUser.Text = "$([char]0x092F) Type Virtual Machine Windows Username below: "
$form.Controls.Add($labelWinUser)

$textBoxWinUser = New-Object System.Windows.Forms.TextBox
$textBoxWinUser.Location = New-Object System.Drawing.Point(10,360)
$textBoxWinUser.Size = New-Object System.Drawing.Size(260,20)
$textBoxWinUser.Text = "vcloud-lab\vJanvi"
$form.Controls.Add($textBoxWinUser)

#https://www.rapidtables.com/code/text/unicode-characters.html

$labelWinPassword = New-Object System.Windows.Forms.Label
$labelWinPassword.Location = New-Object System.Drawing.Point(10,390)
$labelWinPassword.Size = New-Object System.Drawing.Size(280,20)
$labelWinPassword.Text = "`u{092A}" + ' Type Virtual Machine Windows Password below:'
$form.Controls.Add($labelWinPassword)

$textBoxWinPassword = New-Object System.Windows.Forms.MaskedTextBox
$textBoxWinPassword.Location = New-Object System.Drawing.Point(10,420)
$textBoxWinPassword.PasswordChar = '*'
$textBoxWinPassword.Size = New-Object System.Drawing.Size(260,20)
$textBoxWinPassword.Text = "Computer@123"
$form.Controls.Add($textBoxWinPassword)

###### Buttons ######

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,450)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
@"
{
    "vc": {
        "vCenter": "$($textBox.Text.Replace('\','\\'))",
        "vCenterUser": "$($textBoxVCUser.Text.Replace('\','\\'))",
        "vCenterPassword": "$($textBoxVCPassword.Text.Replace('\','\\'))"
    },
    "vm": {
        "vmName": "$($textBoxVMName.Text.Replace('\','\\'))"
    },
    "windows": {
        "winUser": "$($textBoxWinUser.Text.Replace('\','\\'))",
        "winPassword": "$($textBoxWinPassword.Text.Replace('\','\\'))"
    }
}    
"@
}

