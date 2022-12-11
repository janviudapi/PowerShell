Function Send-Email {
    [CmdletBinding()]
    param (
        [String]$From,
        [String[]]$To,
        [String]$Subject,
        [String]$SMTPServer,
        [String]$Body,
        [String[]]$Attachments
    )
    $email = New-Object System.Net.Mail.MailMessage $From, $To, $Subject, $Body
    #$email.To.Add($To)
    $email.isBodyhtml = $true
    $smtp = new-object Net.Mail.SmtpClient($SMTPServer)
    #$smtp.Port = 587
    $emailAttachment = new-object Net.Mail.Attachment($Attachments)
    $email.Attachments.Add($emailAttachment)
    $smtp.Send($email)
}

Send-Email `
    -From 'no-replay@vcloud-lab.com' `
    -To 'Patrick.Henighem@vcloud-lab.com' `
    -Subject 'Test Email' `
    -SMTPServer 'emailexchange.vcloud-lab.com' `
    -Body 'This is test email' `
    -Attachments 'c:\Temp\testfile.txt'