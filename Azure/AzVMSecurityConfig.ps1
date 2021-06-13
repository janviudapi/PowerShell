#Written by vJanvi May 2021
#Azure Automation Accounts DSC (Desired State Configuration)

$password = "Computer@1" | ConvertTo-SecureString -asPlainText -Force
$username = "vJanvi"
[PSCredential]$credential = New-Object System.Management.Automation.PSCredential($username,$password)

$configurationData = @{
    AllNodes = @(
        @{
            NodeName                    = '*'
            PSDscAllowPlainTextPassword = $True
        }
        @{
            NodeName = "localhost"
        }
    )
}

Configuration AzVMSecurityConfig
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$ComputerName = 'localhost'
    )
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
    Node $ComputerName
    {
        File NewDirectory
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\Temp"
            Force = $true
        }

        Environment EnvVarAddPath
        {
            Ensure = "Present"
            Name = "Path"
            Path = $true
            Value = ";C:\temp"
            DependsOn = "[File]NewDirectory"
        }

        User NewUser
        {
            Ensure = "Present"
            UserName = "vJanvi"
            Description = "Second Admin"
            PasswordNeverExpires = $true
            Password = $credential
        }

        Group AddUserToGroup
        {
            Ensure = "Present"
            GroupName = "Remote Desktop Users"
            Members = "vJanvi"
            DependsOn = "[User]NewUser"
        }

        $features = @()
        $features += [pscustomobject]@{ConfigName = "TelnetClient"; Name = "Telnet-Client"; Ensure = "Present"}
        $features += [pscustomobject]@{ConfigName = "FSSMB1"; Name = "FS-SMB1"; Ensure = "Absent"}
        foreach ($feature in $features) 
        {
            WindowsFeature $feature.ConfigName
            {
                Ensure = $feature.Ensure
                Name = $feature.Name
            }
        }
    }
}

AzVMSecurityConfig -ConfigurationData $configurationData

#Start-DscConfiguration -Wait -Path AzVMSecurityConfig -Verbose -Force