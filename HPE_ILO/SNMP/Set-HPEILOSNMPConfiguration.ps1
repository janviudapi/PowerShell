[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
    [string[]]
    $ilo
)

begin {
    #ILO5 Details and credentials
    #$ilo = '192.168.34.100'
    $username = 'Administrator'
    $password = 'Computer!123'
}
process {
    Write-Host $ilo -BackgroundColor DarkGreen
    # Approve self signed SSL certificate

    $code = @"
        using System;
        using System.Net;
        using System.Security.Cryptography.X509Certificates;

        public class TrustAllCertsPolicy {
            public static bool ValidateCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) {
                // Always accept SSL certificates
                return true;
            }
        }
"@
    Add-Type -TypeDefinition $code -Language CSharp

    # Set the callback to trust all certificates
    #[System.Net.ServicePointManager]::ServerCertificateValidationCallback = [TrustAllCertsPolicy]::ValidateCertificate  
    [System.Net.ServicePointManager]::CertificatePolicy =  New-Object TrustAllCertPolicy

    # ILO 5 common API url
    $uri = "https://$ilo/redfish/v1"

    # ILO5 - Login
    $credBody = @{UserName = $username; Password=$password} | ConvertTo-Json
    $loginUri = "$uri/Sessions/"
    $hpeSession = Invoke-WebRequest -Uri $loginUri -Method Post -Body $credBody -ContentType 'application/json' -SessionVariable webSession

    $authHeaders = @{'X-Auth-Token' =  $hpeSession.Headers.'X-Auth-Token'}
    $snmpURI = "$uri/Managers/1/SnmpService"
    $snmpInfo = Invoke-WebRequest -Uri $snmpURI -Method Get -Headers $authHeaders -WebSession $webSession
    $snmpStatus = $snmpInfo.Content | ConvertFrom-Json

    if ($snmpStatus.Status.State -ne 'Enabled') 
    {
        $snmpEnableURI = "$uri/Managers/1/NetworkProtocol"
        $snmpBody = @{
            SNMP = @{
                ProtocolEnabled = $true
            }
        } | ConvertTo-Json -Compress
        $newSNMPinfo = Invoke-WebRequest -Uri $snmpEnableURI -Method Patch -Body $snmpBody -Headers $authHeaders -ContentType 'application/json'
        ($newSNMPinfo.Content | ConvertFrom-Json).error."@Message.ExtendedInfo".MessageId
    }
    else {
        Write-Host "SNMP is already enabled"
    }

    if (($snmpStatus.SNMPv1Enabled -eq $true) -or ($snmpStatus.SNMPv1RequestsEnabled -eq $true) -or ($snmpStatus.SNMPv1TrapEnabled -eq $true))
    {
        $snmpV1DisableURI = "$uri/Managers/1/SnmpService"
        $snmpV1Body = @{}
        foreach ($v1 in $('SNMPv1Enabled', 'SNMPv1RequestEnabled', 'SNMPv1TrapEnabled'))
        {
            $v1Value = $snmpStatus | Select-Object -ExpandProperty $v1
            if ($v1Value -eq $true) {
                $snmpV1Body.Add($v1, $false)
            }
        }
        $snmpV1Info = Invoke-WebRequest -Uri $snmpV1DisableURI -Method Patch -Body $($snmpBody | ConvertTo-Json) -Headers $authHeaders -ContentType 'application/json'
        ($snmpV1Info.Content | ConvertFrom-Json).error."@Message.ExtendedInfo".MessageId
    }
    else {
        Write-Host "SNMPv1 is already Disabled"
    }


    if (($snmpStatus.SNMPv3RequestsEnabled -eq $true) -or ($snmpStatus.SNMPv3TrapEnabled -eq $true))
    {
        $snmpV3EnableURI = "$uri/Managers/1/SnmpService"
        $snmpV3Body = @{
            SNMPv3RequestsEnabled = $true
            SNMPv3TrapEnabled = $true
        } | ConvertTo-Json
        $snmpV3Info = Invoke-WebRequest -Uri $snmpV3EnableURI -Method Patch -Body $($snmpV3Body | ConvertTo-Json) -Headers $authHeaders -ContentType 'application/json'
        ($snmpV3Info.Content | ConvertFrom-Json).error."@Message.ExtendedInfo".MessageId
    }
    else {
        Write-Host "SNMPv3 is already enabled"
    }

    $iloResetURI = "$uri/Managers/1/Actions/Manager.Reset"
    $resetBody = @{
        ResetType = "ForceRestart"
    } | ConvertTo-Json
    $resetInfo = Invoke-WebRequest -Uri $iloResetURI -Method Post -Body $resetBody -Headers $authHeaders -ContentType 'application/json'
    ($resetInfo.Content | ConvertFrom-Json).error."@Message.ExtendedInfo".MessageId
}
end {}