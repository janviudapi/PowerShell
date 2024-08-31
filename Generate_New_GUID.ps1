#created by https://vcloud-lab.com
#PowerShell tool

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'GUID Generation Form - vcloud-lab.com'
$form.Size = New-Object System.Drawing.Size(500,200)
$form.StartPosition = 'CenterScreen'

$generateButton = New-Object System.Windows.Forms.Button
$generateButton.location = New-Object System.Drawing.Point(150,120)
$generateButton.Size = New-Object System.Drawing.Size(75,23)
$generateButton.Text = 'Generate'
#$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Ok
$form.AcceptButton = $generateButton
$form.Controls.Add($generateButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.location = New-Object System.Drawing.Point(250,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.AcceptButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Copy new GUID from below'
$form.Controls.Add($label)

$guidBox = New-Object System.Windows.Forms.TextBox
$guidBox.location = New-Object System.Drawing.Point(10,40)
$guidBox.Size = New-Object System.Drawing.Size(460,20)
$guidBox.Text = [guid]::NewGuid() | Select-Object -ExpandProperty Guid
$guidBox.ReadOnly = $true
$guidBox.TextAlign = 'Center'
$guidBox.Font = New-Object System.Drawing.Font('Lucida Console', 14,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($guidBox)

$form.Topmost = $true

$generateButton.Add_Click({
    $guidBox.Text = [guid]::NewGuid() | Select-Object -ExpandProperty Guid
    # Prevent form from closing
    $form.DialogResult = [System.Windows.Forms.DialogResult]::None
})

$form.Add_shown({$guidBox.Select()})
$result = $form.ShowDialog()