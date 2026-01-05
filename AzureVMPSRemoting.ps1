Invoke-AzVMRunCommand -Name devvm -ResourceGroupName vdev.vcloud-lab.com -ScriptString 'Get-CimInstance Win32_ComputerSystem | Select-Object -Property Name' -CommandId 'RunPowerShellScript'

Enable-AzVMPSRemoting -Name devvm -ResourceGroup vdev.vcloud-lab.com -Protocol http -OsType windows

$username = 'azureadmin'
$password = 'Computer@123'
$secureString = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username,$secureString

Invoke-AzVMCommand -Name devvm -ResourceGroupName vdev.vcloud-lab.com -ScriptBlock {ipconfig} -Credential $credential -Verbose