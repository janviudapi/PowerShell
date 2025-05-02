#iDRAC9 IP and credentials
$iDRAC9 = '192.168.34.110' #supermanidrac
$esxiServer = 'superman.vcloud-lab.com' #192.168.34.101
#$credentials =  Get-Credential -Message "Type iDRAC9 credentials" -UserName root
$userName =  'root'
$password = 'Apple@123' #'calvin'
$secureStringPassword = $password | ConvertTo-SecureString -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PsCredential -ArgumentList $userName, $secureStringPassword

#curl example
#curl "https://<iDRAC IP>/redfish/v1/Chassis" -k -u root:calvin

#Example API URI to get iDRAC9 Information
#$basicAPIUrl = "https://$iDRAC9/redfish/v1"
$chassisAPIUrl =  "https://$iDRAC9/redfish/v1/Chassis/System.Embedded.1"
$powerAPIUrl = "https://$iDRAC9/redfish/v1/Systems/System.Embedded.1/Actions/ComputerSystem.Reset"

#Common Header Example
$headers = @{Accept = 'application/json'}

#Information about Server PowerState
Write-Host 'Checking server Power state' -BackgroundColor DarkYellow -ForegroundColor Black
Write-Host ""
$chassisInfo = Invoke-RestMethod -Uri $chassisAPIUrl -Credential $credentials -Method Get -ContentType 'application/json' -Headers $headers -SkipCertificateCheck #-UseBasicParsing
$powerState = $chassisInfo.PowerState 
Write-Host "Server is $powerState" -BackgroundColor DarkRed