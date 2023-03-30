Import-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline

#$groupInfo = Get-DistributionGroup "NoReply DLP"
#Set-DistributionGroup "NoReply DLP" -EmailAddresses @{Add=$groupInfo.PrimarySmtpAddress,'j@test.com'}

$rawCsv = Import-CSV C:\Scripts\test\Test.csv
$csvData = $rawCsv | Group-Object-PropertyPrimarySmtpAddress

foreach ($csv in $csvData)
{
    $name=$csv.Name
    Write-Host "Working on Distribution Group - $name"-BackgroundColorDarkGreen

    #$groupInfo = Get-DistributionGroup $name  
    #$existingSecEmails =   $groupInfo.EmailAddresses.ForEach({$_.replace('smtp:', '')}) | Where-Object {$_ -cnotmatch 'SMTP:'}
    foreach ($secEmail in $csv.Group)
    {
        $secEmailAddress=$secEmail.secemail
        Write-Host"Adding secondary email / Alias - $secEmailAddress"#-BackgroundColor Yellow -ForegroundColor Black
        Set-DistributionGroup $csv.Group[0].PrimarySmtpAddress -EmailAddresses @{Add="smtp:$secEmailAddress"}
    }
}