##############################
#.SYNOPSIS
#Send email to Users whose password will expired in given days.
#
#.DESCRIPTION
#This script connect and fetches users list whose password is going to expired in the after mentioned days. 
#
#.PARAMETER DaysAfterAlert
#This is a parameter to set days alerts before user password should get email notification, Provide a number alue.
#
#.PARAMETER SearchBase
#Provide distingushed name for domain/out to search users.
#
#.PARAMETER SMTPServer
#Email server FQDN or IP.
#
#.PARAMETER SMTPPort
#Email server SMTP port for submission dfault value is 587.
#
#.EXAMPLE
#Send-PasswordExpiryNotification -DaysAfterAlert 30 -SearchBase 'DC=vcloud-lab,DC=com' -From 'no-reply@vcloud-lab.com' -SMTPServer 'emailexchange.vcloud-lab.com' -SMTPPort 587
#
#Finds users with expiring password in Active Directory and send notification email.
#
#.NOTES
#http://vcloud-lab.com
#Written using powershell version 5
#Script code version 1.0
###############################

[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [Int]$DaysAfterAlert = 30,
    [Parameter(Position=1)]
    [System.String]$SearchBase = 'DC=vcloud-lab,DC=com',
    [Parameter(Position=2)]
    [System.String]$From = 'no-reply@vcloud-lab.com',
    [Parameter(Position=3)]
    [System.String]$SMTPServer = 'emailexchange.vcloud-lab.com',
    [Parameter(Position=4)]
    [Int]$SMTPPort = 587
)
Begin {
    if (-not(Get-Module ActiveDirectory)) {
        Import-Module -Name ActiveDirectory
    }
}
Process {
    #$DaysAfterAlert = 1
    #$searchBase = "DC=vcloud-lab,DC=com"
    #$from = "noreply@vcloud-lab.com"
    #$smtpServer = "192.168.34.42"
    #$smtpPort = "587"
    #$backDate = (Get-Date).AddDays($days)

    $dateNow = [datetime]::Now
    $expiryDate = $dateNow.AddDays(-$DaysAfterAlert) #.ToFileTime()

    $filter = {(Enabled -eq $True) -and (PasswordNeverExpires -eq $False) -and (PasswordLastSet -gt $expiryDate)} #-and (PasswordLastSet -gt $rawBackDate)} #-and (PasswordLastSet -gt $backDate) #name -eq 'user1' -and -and (msDS-UserPasswordExpiryTimeComputed -lt $expirtyAlertDate)
    $adProperties = @('PasswordLastSet', 'pwdLastSet', 'msDS-UserPasswordExpiryTimeComputed', 'EmailAddress')

    $users = Get-ADUser -SearchBase $SearchBase -Filter $filter -properties $adProperties 
    $nearExpiryUsers = $users | Select-Object -Property Name, UserPrincipalName, SamAccountName, EmailAddress, 
            GivenName, Surname, PasswordLastSet, pwdLastSet, 'msDS-UserPasswordExpiryTimeComputed', 
            @{Name="PasswordExpirtyTimeComputed"; Expression={[datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed')}},
            DistinguishedName
   
    foreach ($user in $nearExpiryUsers)
    {
        $remainingDays = New-TimeSpan -Start $dateNow -End $user.PasswordExpirtyTimeComputed
        $to = $user.EmailAddress
        if ([string]::IsNullOrEmpty($to))
        {
            $to = $user.UserPrincipalName
        }

        $subject = "Notification: Your password will expire in $($remainingDays.Days) Days"

        $body = @"
            <style>
                p {
                    margin: auto;
                    width: 75%;
                    border: 1px solid coral;
                    padding: 10px;        
                    border-width: thin;
                    font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }
            </style>
            <p style='background-color: coral; text-align: center; color: white; font-size: large;'>
                <strong>Active Directory Auditor Report</strong>
            </p>
            <p>
                <br>
                <strong>Automated message system
                <br>
                Your User Account Password Expiration Notification!</strong> 
                <br><br>
                Hi $($user.GivenName),
                <br><br>
                You are receiving this email because your password for user account '<b>$($user.SamAccountName)</b>''
                will expire in <b>$($remainingDays.Days)</b> days(s) on date <b>$($user.PasswordExpirtyTimeComputed.ToLongDateString())</b>. 
                Consider changing your password as earliy as possible to avoid logon problems.
                <br><br>
                To reset user account password press Ctrl+Alt+Delete keys in combination on the keyboard 
                and choose option 'Change a password'.
                <br><br>
                For any issue related to user account passwords, Please raise a request on <a href='http://vcloud-lab.com'>helpdesk portal</a>.
                <br><br>
                Thank you
                <br>
                Helpdesk Team
                <br>
                <i><strong>Phone No:</strong> 111-111-1111</i>
                <br>
                <i><strong>Email us:</strong> admin@vcloud-lab.com</i>
                <br><br>
                <span style='display: block; text-align: right; font-size: 12px;'>Please do not reply to no-reply@vcloud-lab.com email, it is not monitored!</span>
            </p>
            <hr style='width: 75%; height:1px;border:none;color:gray;background-color:gray;' />
            <p style='font-size: 12px; color: gray; text-align: right;'>
                This notification message was sent by ADReport Tool from http://vcloud-lab.com
            </p>
"@
        try
        {
            Send-MailMessage -From $From -to $to -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -ErrorAction Stop #-UseSsl -Credential (Get-Credential) #-Attachments $Attachment <#-Cc $Cc#>
            Write-Host "$($user.Name): Email notification sent" -BackgroundColor DarkGreen
        }
        catch
        {
            Write-Host "$($user.Name): $Error[0].Exception.Message" -BackgroundColor DarkRed
        }
    }
}
end{}