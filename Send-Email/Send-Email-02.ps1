$from = 'no-reply@vcloud-lab.com'
$to = 'Patrick.Henighem@vcloud-lab.com' 
$subject = 'Test email message'
$body = 'This is test email message'
$smtpServer = 'emailexchange.vcloud-lab.com'

$SMTPClient = New-Object Net.Mail.SmtpClient($smtpServer, 587)
$SMTPClient.EnableSsl = $false
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential('Patrick.Henighem@vcloud-lab.com', 'Computer@1')
$SMTPClient.Send($from, $to, $subject, $body)