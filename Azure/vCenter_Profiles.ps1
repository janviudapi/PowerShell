#Written by http://vcloud-lab.com

function Get-vCenterAPISessionID {
    #https://developer.vmware.com/docs/vsphere-automation/latest/appliance/infraprofile/configs/

    [CmdletBinding()]
	param(
	    [Parameter(Position=0, Mandatory=$true)]
        [System.String]$vCenter,
		[Parameter(Position=1, Mandatory=$true)]
		[System.String]$username,
        [Parameter(Position=2, Mandatory=$true)]
		[System.String]$password
    )

    #$vCenter = 'marvel.vcloud-lab.com'  
    #$username = 'administrator@vsphere.local'   
    #$password = 'Computer@1'  
    
    $secureStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
    $encryptedPassword = ConvertFrom-SecureString -SecureString $secureStringPassword
    $credential = New-Object System.Management.Automation.PsCredential($username,($encryptedPassword | ConvertTo-SecureString))
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
    $auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($credential.UserName+':'+$credential.GetNetworkCredential().Password))  
    $head = @{  
    Authorization = "Basic $auth"  
    }  

    #Authenticate against vCenter  #old Url - https://$vCenter/rest/com/vmware/cis/session
    #https://developer.vmware.com/docs/vsphere-automation/latest/cis/api/session/post/
    
    $loginUrl = Invoke-WebRequest -Uri "https://$vCenter/rest/com/vmware/cis/session" -Method Post -Headers $head

    $token = ConvertFrom-Json $loginUrl.Content | Select-Object -ExpandProperty Value  
    $session = @{'vmware-api-session-id' = $token}
    $session
}


#############################

function List-vCenterAPIProfile  {
    [CmdletBinding()]
	param(
	    [Parameter(Position=0, Mandatory=$true)]
        [System.String]$vCenter,
		[Parameter(Position=1, Mandatory=$true)]
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


#############################

function Export-vCenterAPIProfile  {
    [CmdletBinding()]
	param(
	    [Parameter(Position=0, Mandatory=$true)]
        [System.String]$vCenter,
		[Parameter(Position=1, Mandatory=$true)]
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

#############################

function Import-vCenterAPIProfile  {
    [CmdletBinding()]
	param(
	    [Parameter(Position=0, Mandatory=$true)]
        [System.String]$vCenter,
		[Parameter(Position=1, Mandatory=$true)]
		[System.Collections.Hashtable]$Session,
		[Parameter(Position=2, Mandatory=$true)]
		[System.String]$JsonProfile
    )     
    #curl -X POST 'https://marvel.vcloud-lab.com/api/appliance/infraprofile/configs?action=import&vmw-task=true' -H 'vmware-api-session-id: 2181a0349363fb44415a9f0110e9162e' -H 'Content-type: application/json'
    #Main validate vCenter API url 
    $importProfileAPIUrl = "https://$vCenter/api/appliance/infraprofile/configs?action=import&vmw-task=true"
    #export vCenter profiles from vcenter
    
    $headers = @{
        'vmware-api-session-id' = $Session['vmware-api-session-id']
        'Content-type' = 'application/json'
    }

    $body = @{
        'config_spec' = $JsonProfile
    }

    $importProfileAPI = Invoke-WebRequest -Uri $importProfileAPIUrl -Method Post -Headers $headers -Body (Convertto-json $body)
    $importProfileJson = $importProfileAPI.Content
    $importProfileJson
}

#############################

function Validate-vCenterAPIProfile  {
    [CmdletBinding()]
	param(
	    [Parameter(Position=0, Mandatory=$true)]
        [System.String]$vCenter,
		[Parameter(Position=1, Mandatory=$true)]
		[System.Collections.Hashtable]$session,
		[Parameter(Position=2, Mandatory=$true)]
		[System.String]$JsonProfile
    )    
    #curl -X POST 'https://marvel.vcloud-lab.com/api/appliance/infraprofile/configs?action=import&vmw-task=true' -H 'vmware-api-session-id: 2181a0349363fb44415a9f0110e9162e' -H 'Content-type: application/json'
    #Main validate vCenter API url
    $validateProfileAPIUrl = "https://$vCenter/api/appliance/infraprofile/configs?action=validate&vmw-task=true"
    #export vCenter profiles from vcenter
    $headers = @{
        'vmware-api-session-id' = $session['vmware-api-session-id']
        'Content-type' = 'application/json'
    }
    $body = Convertto-json @{
        'config_spec' = $JsonProfile
    }

    $validateProfileAPI = Invoke-WebRequest -Uri $validateProfileAPIUrl -Method Post -Headers $headers -Body $body
    $validateProfileJson = $validateProfileAPI.Content
    $validateProfileJson
}

#############################

#Verify you are running Powershell version 5 desktop.
"Powershell Version: " + $PSVersionTable.PSVersion.Major + "." + $PSVersionTable.PSVersion.Minor + " " + $PSVersionTable.PSEdition

#Log into Source Master vCenter and get session token
$sourcevCenter = 'marvel.vcloud-lab.com'
$username = 'administrator@vsphere.local'
$password = 'Computer@1'

$sourceSession = Get-vCenterAPISessionID -vCenter $sourcevCenter -username $username -password $password
$sourceSession

#List vCenter Profiles
List-vCenterAPIProfile -vCenter $sourcevCenter -session $sourceSession

#Export vCenter profile to JSON file
$jsonProfile = Export-vCenterAPIProfile -vCenter $sourcevCenter -session $sourceSession
$jsonProfile | Out-File C:\Temp\BaseProfile.json

#######

#Log into Target vCenter and get session token
$targetvCenter = '192.168.34.20'
$username = 'administrator@vsphere.local'
$password = 'Computer@1'

$targetsession = Get-vCenterAPISessionID -vCenter $targetvCenter -username $username -password $password
$targetsession

#Read vCenter Profile JSON file
$jsonFile = Get-Content C:\Temp\BaseProfile.json

#Import vCenter Profile on Target Server
Import-vCenterAPIProfile -vCenter $targetvCenter -session $targetsession -JsonProfile $jsonFile

#Validate vCenter Profile on Target Server
Validate-vCenterAPIProfile -vCenter $targetvCenter -session $targetsession -JsonProfile $jsonFile
