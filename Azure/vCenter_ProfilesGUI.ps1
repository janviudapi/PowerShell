#requires -Version 3
#Code Written by:  vJANVI - vCloud-lab.com

[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][reflection.assembly]::Load('System.Design, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

[System.Windows.Forms.Application]::EnableVisualStyles()
$formVMwareVCenterProfile = New-Object 'System.Windows.Forms.Form'
$buttonTargetLogin = New-Object 'System.Windows.Forms.Button'
$maskedtextboxTargetPassword = New-Object 'System.Windows.Forms.MaskedTextBox'
$label2 = New-Object 'System.Windows.Forms.Label'
$label3 = New-Object 'System.Windows.Forms.Label'
$textboxTargetUserName = New-Object 'System.Windows.Forms.TextBox'
$textboxTargetvCenter = New-Object 'System.Windows.Forms.TextBox'
$label1 = New-Object 'System.Windows.Forms.Label'
$maskedtextboxSourcePassword = New-Object 'System.Windows.Forms.MaskedTextBox'
$labelPassword = New-Object 'System.Windows.Forms.Label'
$labelUserName = New-Object 'System.Windows.Forms.Label'
$textboxSourceUserName = New-Object 'System.Windows.Forms.TextBox'
$groupbox4 = New-Object 'System.Windows.Forms.GroupBox'
$textboxImportValidate = New-Object 'System.Windows.Forms.TextBox'
$buttonValidateJSONConfigra = New-Object 'System.Windows.Forms.Button'
$buttonImportJSONConfigurat = New-Object 'System.Windows.Forms.Button'
$buttonLoadJSON = New-Object 'System.Windows.Forms.Button'
$labelJsonProfilePath = New-Object 'System.Windows.Forms.Label'
$textboxLoadJSONPath = New-Object 'System.Windows.Forms.TextBox'
$groupbox2 = New-Object 'System.Windows.Forms.GroupBox'
$buttonExport = New-Object 'System.Windows.Forms.Button'
$labelExportJSONPath = New-Object 'System.Windows.Forms.Label'
$textboxExportJsonPath = New-Object 'System.Windows.Forms.TextBox'
$groupbox1vCenterProfileConfiguration = New-Object 'System.Windows.Forms.GroupBox'
$buttonListProfiles = New-Object 'System.Windows.Forms.Button'
$textboxListProfile = New-Object 'System.Windows.Forms.TextBox'
$statusstrip1 = New-Object 'System.Windows.Forms.StatusStrip'
$buttonSourceLogin = New-Object 'System.Windows.Forms.Button'
$labelSourceVCenter = New-Object 'System.Windows.Forms.Label'
$textboxSourcevCenter = New-Object 'System.Windows.Forms.TextBox'
$toolstripstatuslabel1Status = New-Object 'System.Windows.Forms.ToolStripStatusLabel'
$savefiledialogExportJSON = New-Object 'System.Windows.Forms.SaveFileDialog'
$openfiledialogLoadJSON = New-Object 'System.Windows.Forms.OpenFileDialog'
$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'

function Get-vCenterAPISessionID
{
	#https://developer.vmware.com/docs/vsphere-automation/latest/appliance/infraprofile/configs/
			
	[CmdletBinding()]
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[System.String]$vCenter,
		[Parameter(Position = 1, Mandatory = $true)]
		[System.String]$username,
		[Parameter(Position = 2, Mandatory = $true)]
		[System.String]$password
	)
	$secureStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
	$encryptedPassword = ConvertFrom-SecureString -SecureString $secureStringPassword
	$credential = New-Object System.Management.Automation.PsCredential($username, ($encryptedPassword | ConvertTo-SecureString))
	#$credential.GetNetworkCredential().Password
			
	if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
	{
		$certCallback = @'  
    using System;  
    using System.Net;  
    using System.Net.Security;  
    using System.Security.Cryptography.X509Certificates;  
    public class ServerCertificateValidationCallback  
    {  
        public static void Ignore()  
        {  
            if (ServicePointManager.ServerCertificateValidationCallback == null)  
            {  
                ServicePointManager.ServerCertificateValidationCallback +=  
                delegate   
                (  
                    Object Obj,  
                    X509Certificate certificate,  
                    X509Chain chain,  
                    SslPolicyErrors errors  
                )  
                {  
                    return true;  
                };  
            }  
        }  
    }  
'@
		Add-Type $certCallback
	} #if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
			
	#execute c# code and ignore invalid certificate error  
	[ServerCertificateValidationCallback]::Ignore();
			
	#Type credential and process to base 64  
	#$credential = Get-Credential -Message 'Type vCenter Password' -UserName 'administrator@vsphere.local'  
	$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($credential.UserName + ':' + $credential.GetNetworkCredential().Password))
	$head = @{
		Authorization = "Basic $auth"
	}
			
	#Authenticate against vCenter  #old Url - https://$vCenter/rest/com/vmware/cis/session
	#https://developer.vmware.com/docs/vsphere-automation/latest/cis/api/session/post/
			
	$loginUrl = Invoke-WebRequest -Uri "https://$vCenter/rest/com/vmware/cis/session" -Method Post -Headers $head
			
	$token = ConvertFrom-Json $loginUrl.Content | Select-Object -ExpandProperty Value
	$session = @{ 'vmware-api-session-id' = $token }
	$session
}
	
$formVMwareVCenterProfile_Load={
	function Show-MessageBox
	{
		param (
			[string]$Message = "Show user friendly Text Message",
			[string]$Title = 'Title here',
			[ValidateRange(0, 5)]
			[Int]$Button = 0,
			[ValidateSet('None', 'Hand', 'Error', 'Stop', 'Question', 'Exclamation', 'Warning', 'Asterisk', 'Information')]
			[string]$Icon = 'Error'
		)
		#Note: $Button is equl to [System.Enum]::GetNames([System.Windows.Forms.MessageBoxButtons])   
		#Note: $Icon is equl to [System.Enum]::GetNames([System.Windows.Forms.MessageBoxIcon])   
		$MessageIcon = [System.Windows.Forms.MessageBoxIcon]::$Icon
		[System.Windows.Forms.MessageBox]::Show($Message, $Title, $Button, $MessageIcon)
	}
}
	
$buttonSourceLogin_Click={
	try
	{
		$global:sourceSession = Get-vCenterAPISessionID -vCenter $textboxSourcevCenter.Text -username $textboxSourceUserName.Text -password $maskedtextboxSourcePassword.Text
		$toolstripstatuslabel1Status.Text = 'Status: Connected to Source vCenter, Export Profile config'
		$buttonListProfiles.Enabled = $true
		$buttonExport.Enabled = $true
	}
	catch
	{
		$toolstripstatuslabel1Status.Text = 'Status: Source vCenter connection failed, Retry!'
	}
	
}
	
$buttonListProfiles_Click={
	function List-vCenterAPIProfile
	{
		[CmdletBinding()]
		param (
			[Parameter(Position = 0, Mandatory = $true)]
			[System.String]$vCenter,
			[Parameter(Position = 1, Mandatory = $true)]
			[System.Collections.Hashtable]$session
		)
			
		#curl -X GET 'https://marvel.vcloud-lab.com/api/appliance/infraprofile/configs' -H 'vmware-api-session-id: 2181a0349363fb44415a9f0110e9162e'
		#Main list vCenter API url  
		$listProfileAPIUrl = "https://$vCenter/api/appliance/infraprofile/configs"
		#List vCenter profiles from vcenter  
		$listProfileAPI = Invoke-WebRequest -Uri $listProfileAPIUrl -Method Get -Headers $session
		$listProfileJson = $listProfileAPI.Content
		#ConvertFrom-Json $listProfileJson
		$listProfileJson
	}
	$textboxListProfile.Text = List-vCenterAPIProfile -vCenter $textboxSourcevCenter.Text -session $sourceSession
}
	
$buttonExport_Click={
	$savefiledialogExportJSON.initialDirectory = 'C:\'
	$savefiledialogExportJSON.filter = "JSON File (*.JSON)| *.JSON"
	$savefiledialogExportJSON.ShowDialog() | Out-Null
	$savefiledialogExportJSON.AddExtension = $true
	$textboxExportJsonPath.text = $savefiledialogExportJSON.FileName
		
	function Export-vCenterAPIProfile
	{
		[CmdletBinding()]
		param (
			[Parameter(Position = 0, Mandatory = $true)]
			[System.String]$vCenter,
			[Parameter(Position = 1, Mandatory = $true)]
			[System.Collections.Hashtable]$session
		)
		#curl -X POST 'https://marvel.vcloud-lab.com/api/appliance/infraprofile/configs?action=export' -H 'vmware-api-session-id: 2181a0349363fb44415a9f0110e9162e' -H 'Content-type: application/json'
		#https://developer.vmware.com/docs/vsphere-automation/latest/appliance/data-structures/Infraprofile/Configs/ProfilesSpec/
		#https://developer.vmware.com/docs/vsphere-automation/latest/appliance/api/appliance/infraprofile/configsactionvalidatevmw-tasktrue/post/
		#Main export vCenter API url 
		$exportProfileAPIUrl = "https://$vCenter/api/appliance/infraprofile/configs?action=export"
		#export vCenter profiles from vcenter
	<#
	$headers = @{
	    'vmware-api-session-id' = $token  
	    'Content-type' = 'application/json'
	}
	#>
		$exportProfileAPI = Invoke-WebRequest -Uri $exportProfileAPIUrl -Method Post -Headers $session -ContentType 'application/json'
		#(ConvertFrom-Json (ConvertFrom-Json $exportProfileAPI.Content)).profiles | Format-List
		$exportProfileJson = $exportProfileAPI.Content
		$exportProfileJson
	}
		
	$jsonProfile = Export-vCenterAPIProfile -vCenter $textboxSourcevCenter.Text -session $sourceSession
	$jsonProfile | Out-File $textboxExportJsonPath.Text
		
	$toolstripstatuslabel1Status.Text = 'Status: Export Profile config, Connect to Target vCenter'
	$textboxLoadJSONPath.Text = $textboxExportJsonPath.Text
}
	
$buttonTargetLogin_Click={
	try
	{
		$global:TargetSession = Get-vCenterAPISessionID -vCenter $textboxTargetvCenter.Text -username $textboxTargetUserName.Text -password $maskedtextboxTargetPassword.Text
		$toolstripstatuslabel1Status.Text = 'Status: Connected to Target vCenter, Either Import or Validate Profile config'
		$buttonImportJSONConfigurat.Enabled = $true
		$buttonValidateJSONConfigra.Enabled = $true
	}
	catch
	{
		$toolstripstatuslabel1Status.Text = 'Status: Target vCenter connection failed, Retry!'
	}
	$textboxLoadJSONPath.Text = $textboxExportJsonPath.Text
}
	
$buttonLoadJSON_Click={
	$textboxLoadJSONPath.Text = $textboxExportJsonPath.Text
	$basePath = Split-Path $textboxLoadJSONPath.Text -Parent
	$openfiledialogLoadJSON.initialDirectory = $basePath
	$openfiledialogLoadJSON.filter = "JSON File (*.JSON)|*.JSON|All Files (*.*)|*.*"
	$openfiledialogLoadJSON.ShowDialog() | Out-Null
	$textboxLoadJSONPath.text = $openfiledialogLoadJSON.FileName
	$global:jsonFile = Get-Content $textboxLoadJSONPath.text
}
	
$buttonImportJSONConfigurat_Click={
	$global:jsonFile = Get-Content $textboxLoadJSONPath.text
	function Import-vCenterAPIProfile
	{
		[CmdletBinding()]
		param (
			[Parameter(Position = 0, Mandatory = $true)]
			[System.String]$vCenter,
			[Parameter(Position = 1, Mandatory = $true)]
			[System.Collections.Hashtable]$Session,
			[Parameter(Position = 2, Mandatory = $true)]
			[System.String]$JsonProfile
		)
		#curl -X POST 'https://marvel.vcloud-lab.com/api/appliance/infraprofile/configs?action=import&vmw-task=true' -H 'vmware-api-session-id: 2181a0349363fb44415a9f0110e9162e' -H 'Content-type: application/json'
		#Main validate vCenter API url 
		$importProfileAPIUrl = "https://$vCenter/api/appliance/infraprofile/configs?action=import&vmw-task=true"
		#export vCenter profiles from vcenter
			
		$headers = @{
			'vmware-api-session-id' = $Session['vmware-api-session-id']
			'Content-type'		    = 'application/json'
		}
			
		$body = @{
			'config_spec' = $JsonProfile
		}
			
		$importProfileAPI = Invoke-WebRequest -Uri $importProfileAPIUrl -Method Post -Headers $headers -Body (Convertto-json $body)
		$importProfileJson = $importProfileAPI.Content
		$importProfileJson
	}
	$textboxImportValidate.Text = Import-vCenterAPIProfile -vCenter $textboxTargetvCenter.Text -session $targetsession -JsonProfile $jsonFile
	$toolstripstatuslabel1Status.Text = 'Status: Imported profile on Target vCenter Server'
}
	
$buttonValidateJSONConfigra_Click={
	$global:jsonFile = Get-Content $textboxLoadJSONPath.text
	function Validate-vCenterAPIProfile
	{
		[CmdletBinding()]
		param (
			[Parameter(Position = 0, Mandatory = $true)]
			[System.String]$vCenter,
			[Parameter(Position = 1, Mandatory = $true)]
			[System.Collections.Hashtable]$session,
			[Parameter(Position = 2, Mandatory = $true)]
			[System.String]$JsonProfile
		)
		#curl -X POST 'https://marvel.vcloud-lab.com/api/appliance/infraprofile/configs?action=import&vmw-task=true' -H 'vmware-api-session-id: 2181a0349363fb44415a9f0110e9162e' -H 'Content-type: application/json'
		#Main validate vCenter API url
		$validateProfileAPIUrl = "https://$vCenter/api/appliance/infraprofile/configs?action=validate&vmw-task=true"
		#export vCenter profiles from vcenter
		$headers = @{
			'vmware-api-session-id' = $session['vmware-api-session-id']
			'Content-type'		    = 'application/json'
		}
		$body = Convertto-json @{
			'config_spec' = $JsonProfile
		}
			
		$validateProfileAPI = Invoke-WebRequest -Uri $validateProfileAPIUrl -Method Post -Headers $headers -Body $body
		$validateProfileJson = $validateProfileAPI.Content
		$validateProfileJson
	}
	$textboxImportValidate.Text = Validate-vCenterAPIProfile -vCenter $textboxTargetvCenter.Text -session $targetsession -JsonProfile $jsonFile
	$toolstripstatuslabel1Status.Text = 'Status: Validated profile on Target vCenter Server'
}
	
$Form_StateCorrection_Load=
{
	$formVMwareVCenterProfile.WindowState = $InitialFormWindowState
}
	
$Form_Cleanup_FormClosed=
{
	try
	{
		$buttonTargetLogin.remove_Click($buttonTargetLogin_Click)
		$buttonValidateJSONConfigra.remove_Click($buttonValidateJSONConfigra_Click)
		$buttonImportJSONConfigurat.remove_Click($buttonImportJSONConfigurat_Click)
		$buttonLoadJSON.remove_Click($buttonLoadJSON_Click)
		$buttonExport.remove_Click($buttonExport_Click)
		$buttonListProfiles.remove_Click($buttonListProfiles_Click)
		$buttonSourceLogin.remove_Click($buttonSourceLogin_Click)
		$formVMwareVCenterProfile.remove_Load($formVMwareVCenterProfile_Load)
		$formVMwareVCenterProfile.remove_Load($Form_StateCorrection_Load)
		$formVMwareVCenterProfile.remove_FormClosed($Form_Cleanup_FormClosed)
	}
	catch { Out-Null}
}
$formVMwareVCenterProfile.SuspendLayout()
$groupbox4.SuspendLayout()
$groupbox2.SuspendLayout()
$groupbox1vCenterProfileConfiguration.SuspendLayout()
$statusstrip1.SuspendLayout()

$formVMwareVCenterProfile.Controls.Add($buttonTargetLogin)
$formVMwareVCenterProfile.Controls.Add($maskedtextboxTargetPassword)
$formVMwareVCenterProfile.Controls.Add($label2)
$formVMwareVCenterProfile.Controls.Add($label3)
$formVMwareVCenterProfile.Controls.Add($textboxTargetUserName)
$formVMwareVCenterProfile.Controls.Add($textboxTargetvCenter)
$formVMwareVCenterProfile.Controls.Add($label1)
$formVMwareVCenterProfile.Controls.Add($maskedtextboxSourcePassword)
$formVMwareVCenterProfile.Controls.Add($labelPassword)
$formVMwareVCenterProfile.Controls.Add($labelUserName)
$formVMwareVCenterProfile.Controls.Add($textboxSourceUserName)
$formVMwareVCenterProfile.Controls.Add($groupbox4)
$formVMwareVCenterProfile.Controls.Add($groupbox2)
$formVMwareVCenterProfile.Controls.Add($groupbox1vCenterProfileConfiguration)
$formVMwareVCenterProfile.Controls.Add($statusstrip1)
$formVMwareVCenterProfile.Controls.Add($buttonSourceLogin)
$formVMwareVCenterProfile.Controls.Add($labelSourceVCenter)
$formVMwareVCenterProfile.Controls.Add($textboxSourcevCenter)
$formVMwareVCenterProfile.AutoScaleDimensions = '8, 17'
$formVMwareVCenterProfile.AutoScaleMode = 'Font'
$formVMwareVCenterProfile.ClientSize = '645, 708'
$formVMwareVCenterProfile.Name = 'formVMwareVCenterProfile'
$formVMwareVCenterProfile.Text = 'VMware vCenter Profiles             http://vcloud-lab.com'
$formVMwareVCenterProfile.add_Load($formVMwareVCenterProfile_Load)

$buttonTargetLogin.Location = '533, 400'
$buttonTargetLogin.Margin = '4, 4, 4, 4'
$buttonTargetLogin.Name = 'buttonTargetLogin'
$buttonTargetLogin.Size = '97, 26'
$buttonTargetLogin.TabIndex = 19
$buttonTargetLogin.Text = 'Login'
$buttonTargetLogin.UseCompatibleTextRendering = $True
$buttonTargetLogin.UseVisualStyleBackColor = $True
$buttonTargetLogin.add_Click($buttonTargetLogin_Click)

$maskedtextboxTargetPassword.Location = '128, 405'
$maskedtextboxTargetPassword.Margin = '4, 4, 4, 4'
$maskedtextboxTargetPassword.Name = 'maskedtextboxTargetPassword'
$maskedtextboxTargetPassword.Size = '286, 23'
$maskedtextboxTargetPassword.TabIndex = 18
$maskedtextboxTargetPassword.UseSystemPasswordChar = $True

$label2.AutoSize = $True
$label2.Location = '13, 405'
$label2.Margin = '4, 0, 4, 0'
$label2.Name = 'label2'
$label2.Size = '71, 21'
$label2.TabIndex = 17
$label2.Text = 'Password:'
$label2.UseCompatibleTextRendering = $True

$label3.AutoSize = $True
$label3.Location = '13, 376'
$label3.Margin = '4, 0, 4, 0'
$label3.Name = 'label3'
$label3.Size = '77, 21'
$label3.TabIndex = 16
$label3.Text = 'UserName:'
$label3.UseCompatibleTextRendering = $True

$textboxTargetUserName.Location = '128, 374'
$textboxTargetUserName.Margin = '4, 4, 4, 4'
$textboxTargetUserName.Name = 'textboxTargetUserName'
$textboxTargetUserName.Size = '286, 23'
$textboxTargetUserName.TabIndex = 15
$textboxTargetUserName.Text = 'administrator@vsphere.local'

$textboxTargetvCenter.Location = '130, 342'
$textboxTargetvCenter.Margin = '4, 4, 4, 4'
$textboxTargetvCenter.Name = 'textboxTargetvCenter'
$textboxTargetvCenter.Size = '502, 23'
$textboxTargetvCenter.TabIndex = 14
$textboxTargetvCenter.Text = 'Target FQDN or IP'

$label1.AutoSize = $True
$label1.Location = '13, 345'
$label1.Margin = '4, 0, 4, 0'
$label1.Name = 'label1'
$label1.Size = '103, 21'
$label1.TabIndex = 13
$label1.Text = 'Target vCenter:'
$label1.UseCompatibleTextRendering = $True

$maskedtextboxSourcePassword.Location = '128, 80'
$maskedtextboxSourcePassword.Margin = '4, 4, 4, 4'
$maskedtextboxSourcePassword.Name = 'maskedtextboxSourcePassword'
$maskedtextboxSourcePassword.Size = '286, 23'
$maskedtextboxSourcePassword.TabIndex = 12
$maskedtextboxSourcePassword.UseSystemPasswordChar = $True

$labelPassword.AutoSize = $True
$labelPassword.Location = '13, 81'
$labelPassword.Margin = '4, 0, 4, 0'
$labelPassword.Name = 'labelPassword'
$labelPassword.Size = '71, 21'
$labelPassword.TabIndex = 10
$labelPassword.Text = 'Password:'
$labelPassword.UseCompatibleTextRendering = $True

$labelUserName.AutoSize = $True
$labelUserName.Location = '13, 49'
$labelUserName.Margin = '4, 0, 4, 0'
$labelUserName.Name = 'labelUserName'
$labelUserName.Size = '77, 21'
$labelUserName.TabIndex = 9
$labelUserName.Text = 'UserName:'
$labelUserName.UseCompatibleTextRendering = $True

$textboxSourceUserName.Location = '128, 47'
$textboxSourceUserName.Margin = '4, 4, 4, 4'
$textboxSourceUserName.Name = 'textboxSourceUserName'
$textboxSourceUserName.Size = '286, 23'
$textboxSourceUserName.TabIndex = 8
$textboxSourceUserName.Text = 'administrator@vsphere.local'

$groupbox4.Controls.Add($textboxImportValidate)
$groupbox4.Controls.Add($buttonValidateJSONConfigra)
$groupbox4.Controls.Add($buttonImportJSONConfigurat)
$groupbox4.Controls.Add($buttonLoadJSON)
$groupbox4.Controls.Add($labelJsonProfilePath)
$groupbox4.Controls.Add($textboxLoadJSONPath)
$groupbox4.Location = '13, 436'
$groupbox4.Margin = '4, 4, 4, 4'
$groupbox4.Name = 'groupbox4'
$groupbox4.Padding = '4, 4, 4, 4'
$groupbox4.Size = '617, 226'
$groupbox4.TabIndex = 7
$groupbox4.TabStop = $False
$groupbox4.Text = 'Import and Validate vCenter profile configuration'
$groupbox4.UseCompatibleTextRendering = $True

$textboxImportValidate.Location = '8, 93'
$textboxImportValidate.Margin = '4, 4, 4, 4'
$textboxImportValidate.Multiline = $True
$textboxImportValidate.Name = 'textboxImportValidate'
$textboxImportValidate.ReadOnly = $True
$textboxImportValidate.Size = '601, 112'
$textboxImportValidate.TabIndex = 8

$buttonValidateJSONConfigra.Enabled = $False
$buttonValidateJSONConfigra.Location = '300, 55'
$buttonValidateJSONConfigra.Margin = '4, 4, 4, 4'
$buttonValidateJSONConfigra.Name = 'buttonValidateJSONConfigra'
$buttonValidateJSONConfigra.Size = '231, 30'
$buttonValidateJSONConfigra.TabIndex = 7
$buttonValidateJSONConfigra.Text = 'Validate JSON Configration'
$buttonValidateJSONConfigra.UseCompatibleTextRendering = $True
$buttonValidateJSONConfigra.UseVisualStyleBackColor = $True
$buttonValidateJSONConfigra.add_Click($buttonValidateJSONConfigra_Click)

$buttonImportJSONConfigurat.Enabled = $False
$buttonImportJSONConfigurat.Location = '65, 55'
$buttonImportJSONConfigurat.Margin = '4, 4, 4, 4'
$buttonImportJSONConfigurat.Name = 'buttonImportJSONConfigurat'
$buttonImportJSONConfigurat.Size = '227, 30'
$buttonImportJSONConfigurat.TabIndex = 6
$buttonImportJSONConfigurat.Text = 'Import JSON configuration'
$buttonImportJSONConfigurat.UseCompatibleTextRendering = $True
$buttonImportJSONConfigurat.UseVisualStyleBackColor = $True
$buttonImportJSONConfigurat.add_Click($buttonImportJSONConfigurat_Click)

$buttonLoadJSON.Location = '482, 24'
$buttonLoadJSON.Margin = '4, 4, 4, 4'
$buttonLoadJSON.Name = 'buttonLoadJSON'
$buttonLoadJSON.Size = '127, 26'
$buttonLoadJSON.TabIndex = 2
$buttonLoadJSON.Text = 'Load JSON'
$buttonLoadJSON.UseCompatibleTextRendering = $True
$buttonLoadJSON.UseVisualStyleBackColor = $True
$buttonLoadJSON.add_Click($buttonLoadJSON_Click)

$labelJsonProfilePath.AutoSize = $True
$labelJsonProfilePath.Location = '8, 24'
$labelJsonProfilePath.Margin = '4, 0, 4, 0'
$labelJsonProfilePath.Name = 'labelJsonProfilePath'
$labelJsonProfilePath.Size = '121, 21'
$labelJsonProfilePath.TabIndex = 1
$labelJsonProfilePath.Text = 'JSON profile path:'
$labelJsonProfilePath.UseCompatibleTextRendering = $True

$textboxLoadJSONPath.Location = '140, 24'
$textboxLoadJSONPath.Margin = '4, 4, 4, 4'
$textboxLoadJSONPath.Name = 'textboxLoadJSONPath'
$textboxLoadJSONPath.Size = '334, 23'
$textboxLoadJSONPath.TabIndex = 0
$textboxLoadJSONPath.Text = 'C:\testprofile.json'

$groupbox2.Controls.Add($buttonExport)
$groupbox2.Controls.Add($labelExportJSONPath)
$groupbox2.Controls.Add($textboxExportJsonPath)
$groupbox2.Location = '13, 269'
$groupbox2.Margin = '4, 4, 4, 4'
$groupbox2.Name = 'groupbox2'
$groupbox2.Padding = '4, 4, 4, 4'
$groupbox2.Size = '617, 65'
$groupbox2.TabIndex = 5
$groupbox2.TabStop = $False
$groupbox2.Text = 'Export vCenter profile configuration'
$groupbox2.UseCompatibleTextRendering = $True

$buttonExport.Enabled = $False
$buttonExport.Location = '482, 23'
$buttonExport.Margin = '4, 4, 4, 4'
$buttonExport.Name = 'buttonExport'
$buttonExport.Size = '127, 30'
$buttonExport.TabIndex = 2
$buttonExport.Text = 'Export'
$buttonExport.UseCompatibleTextRendering = $True
$buttonExport.UseVisualStyleBackColor = $True
$buttonExport.add_Click($buttonExport_Click)

$labelExportJSONPath.AutoSize = $True
$labelExportJSONPath.Location = '8, 27'
$labelExportJSONPath.Margin = '4, 0, 4, 0'
$labelExportJSONPath.Name = 'labelExportJSONPath'
$labelExportJSONPath.Size = '124, 21'
$labelExportJSONPath.TabIndex = 1
$labelExportJSONPath.Text = 'Export JSON Path:'
$labelExportJSONPath.UseCompatibleTextRendering = $True

$textboxExportJsonPath.Location = '140, 25'
$textboxExportJsonPath.Margin = '4, 4, 4, 4'
$textboxExportJsonPath.Name = 'textboxExportJsonPath'
$textboxExportJsonPath.Size = '334, 23'
$textboxExportJsonPath.TabIndex = 0
$textboxExportJsonPath.Text = 'C:\testprofile.json'

$groupbox1vCenterProfileConfiguration.Controls.Add($buttonListProfiles)
$groupbox1vCenterProfileConfiguration.Controls.Add($textboxListProfile)
$groupbox1vCenterProfileConfiguration.Location = '13, 112'
$groupbox1vCenterProfileConfiguration.Margin = '4, 4, 4, 4'
$groupbox1vCenterProfileConfiguration.Name = 'groupbox1vCenterProfileConfiguration'
$groupbox1vCenterProfileConfiguration.Padding = '4, 4, 4, 4'
$groupbox1vCenterProfileConfiguration.Size = '617, 149'
$groupbox1vCenterProfileConfiguration.TabIndex = 4
$groupbox1vCenterProfileConfiguration.TabStop = $False
$groupbox1vCenterProfileConfiguration.Text = 'List vCenter Profile Configuration'
$groupbox1vCenterProfileConfiguration.UseCompatibleTextRendering = $True

$buttonListProfiles.Enabled = $False
$buttonListProfiles.Location = '482, 32'
$buttonListProfiles.Margin = '4, 4, 4, 4'
$buttonListProfiles.Name = 'buttonListProfiles'
$buttonListProfiles.Size = '127, 28'
$buttonListProfiles.TabIndex = 1
$buttonListProfiles.Text = 'List Profiles'
$buttonListProfiles.UseCompatibleTextRendering = $True
$buttonListProfiles.UseVisualStyleBackColor = $True
$buttonListProfiles.add_Click($buttonListProfiles_Click)

$textboxListProfile.Location = '8, 68'
$textboxListProfile.Margin = '4, 4, 4, 4'
$textboxListProfile.Multiline = $True
$textboxListProfile.Name = 'textboxListProfile'
$textboxListProfile.ReadOnly = $True
$textboxListProfile.Size = '601, 73'
$textboxListProfile.TabIndex = 0

$statusstrip1.ImageScalingSize = '20, 20'
[void]$statusstrip1.Items.Add($toolstripstatuslabel1Status)
$statusstrip1.Location = '0, 683'
$statusstrip1.Name = 'statusstrip1'
$statusstrip1.Padding = '1, 0, 19, 0'
$statusstrip1.Size = '645, 25'
$statusstrip1.TabIndex = 3
$statusstrip1.Text = 'statusstrip1'

$buttonSourceLogin.Location = '535, 78'
$buttonSourceLogin.Margin = '4, 4, 4, 4'
$buttonSourceLogin.Name = 'buttonSourceLogin'
$buttonSourceLogin.Size = '97, 26'
$buttonSourceLogin.TabIndex = 2
$buttonSourceLogin.Text = 'Login'
$buttonSourceLogin.UseCompatibleTextRendering = $True
$buttonSourceLogin.UseVisualStyleBackColor = $True
$buttonSourceLogin.add_Click($buttonSourceLogin_Click)

$labelSourceVCenter.AutoSize = $True
$labelSourceVCenter.Location = '13, 16'
$labelSourceVCenter.Margin = '4, 0, 4, 0'
$labelSourceVCenter.Name = 'labelSourceVCenter'
$labelSourceVCenter.Size = '107, 21'
$labelSourceVCenter.TabIndex = 1
$labelSourceVCenter.Text = 'Source vCenter:'
$labelSourceVCenter.UseCompatibleTextRendering = $True

$textboxSourcevCenter.Location = '128, 16'
$textboxSourcevCenter.Margin = '4, 4, 4, 4'
$textboxSourcevCenter.Name = 'textboxSourcevCenter'
$textboxSourcevCenter.Size = '502, 23'
$textboxSourcevCenter.TabIndex = 0
$textboxSourcevCenter.Text = 'Source FQDN or IP'

$toolstripstatuslabel1Status.Name = 'toolstripstatuslabel1Status'
$toolstripstatuslabel1Status.Size = '231, 20'
$toolstripstatuslabel1Status.Text = 'Status: Connect to Source vCenter'

$openfiledialogLoadJSON.FileName = 'openfiledialogLoadJSON'
$statusstrip1.ResumeLayout()
$groupbox1vCenterProfileConfiguration.ResumeLayout()
$groupbox2.ResumeLayout()
$groupbox4.ResumeLayout()
$formVMwareVCenterProfile.ResumeLayout()

$InitialFormWindowState = $formVMwareVCenterProfile.WindowState
$formVMwareVCenterProfile.add_Load($Form_StateCorrection_Load)
$formVMwareVCenterProfile.add_FormClosed($Form_Cleanup_FormClosed)
$formVMwareVCenterProfile.ShowDialog()