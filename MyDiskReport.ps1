$computers = $env:COMPUTERNAME, 'testmachine2', 'ad001' , '192.168.34.44'

function Get-DiskDetails
{
    [CmdletBinding()]
    param (
        [string]$Computer = $env:COMPUTERNAME
    )
    $cimSessionOptions = New-CimSessionOption -Protocol Default
    $query = "SELECT DeviceID, VolumeName, Size, FreeSpace FROM Win32_LogicalDisk WHERE DriveType = 3"
    $cimsession = New-CimSession -Name $Computer -ComputerName $Computer -SessionOption $cimSessionOptions
    Get-CimInstance -Query $query -CimSession $cimsession 
}

$newHtmlFragment = [System.Collections.ArrayList]::new()
foreach ($computer in $computers)
{
    $disks = Get-DiskDetails -Computer $computer 
    $diskinfo = @()
    foreach ($disk in $disks) {
        [int]$percentUsage = ((($disk.Size - $disk.FreeSpace)/1gb -as [int]) / ($disk.Size/1gb -as [int])) * 100  #(50/100).tostring("P")
        $bars = "<div style='background-color: DodgerBlue; height: 18px; width: $percentUsage%'><span>$percentUsage%</span></div>" 
        $diskInfo += [PSCustomObject]@{
            Volume = $disk.DeviceID
            VolumeName = $disk.VolumeName
            TotalSize_GB = $disk.Size / 1gb -as [int]
            UsedSpace_GB = ($disk.Size - $disk.FreeSpace)/1gb -as [int]
            FreeSpace_GB = [System.Math]::Round($disk.FreeSpace/1gb)
            Usage = "usage {0}"  -f $bars #, $percentUsage
        }
    }
    $htmlFragment = $diskInfo | ConvertTo-Html -Fragment
    $newHtmlFragment += $htmlFragment[0]
    $newHtmlFragment += "<tr><th class='ServerName' colspan='4'>$($computer.ToUpper())</th></tr>"
    $newHtmlFragment += $htmlFragment[2].Replace('<th>',"<th class='tableheader'>")

    $diskData =  $htmlFragment[3..($htmlFragment.count -2)]
    for ($i = 0; $i -lt $diskData.Count; $i++) {
        if ($($i % 2) -eq 0)
        {
            $newHtmlFragment += $diskData[$i].Replace('<td>',"<td class='td0'>")
        }
        else 
        {
            $newHtmlFragment += $diskData[$i].Replace('<td>',"<td class='td1'>")
        }
    }
    $newHtmlFragment += $htmlFragment[-1]
}
$newHtmlFragment = $newHtmlFragment.Replace("<td class='td0'>usage ", "<td class='usage'>")
$newHtmlFragment = $newHtmlFragment.Replace("<td class='td1'>usage ", "<td class='usage'>")
$newHtmlFragment = $newHtmlFragment.Replace('&lt;', '<')
$newHtmlFragment = $newHtmlFragment.Replace('&gt;', '>')
$newHtmlFragment = $newHtmlFragment.Replace('&#39', "'")

$html = @"
<html lang='en'>
    <head>
        <meta charset='UTF-8'>
        <meta http-equiv='X-UA-Compatible' content='IE=edge'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <title>Disk Usage Report</title>
        <style>
            body {
                font-family: Calibri, sans-serif, 'Gill Sans', 'Gill Sans MT', 'Trebuchet MS';
                background-color: whitesmoke;
            }
            .mainhead {
                margin: auto;
                width: 100%;
                text-align: center;
                font-size: xx-large;
                font-weight: bolder;
            }
            table {
                margin: 10px auto;
                width: 70%;
            }
            .ServerName {
                font-size: x-large;
                margin: 10px;
                text-align: left;
                padding: 10 0;
                color: DodgerBlue;
            }
            .tableheader {
                background-color: black;
                color: white;
                padding: 10px;
                text-align: left;
                /* font-size: large; */
                border-bottom-style: solid;
                border-bottom-color: darkgray;
            }
            td {
                background-color: white;
                border-bottom: 1px;
                border-bottom-style: solid;
                border-bottom-color: #404040;
            }

            .usage {
                background-color: SkyBlue ;
                width: 70%;
                color:  black;
            }

            span {
                color: black;
            }

            .td1 {
                background-color: #F0F0F0;
            }
        </style>
    </head>
    <body>
        <div class='mainhead'>
            <img style='vertical-align: middle;' src='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCAAyADIDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDlP2jtKi/aV/a0+OkHxL1vxVL4G+Fujte2WheE0V52CmFPkSQMikmVmeQr90ZJCrxoeLP2A/2W/h38GdB+JPjH4g/EDwppWtWaXVlpupPaLqErNGH8pYBbbmcAjOOBkEkA5r2D9ledLb/gp5+0xNK22OPT97N6ASWxJrjf2bPhtH/wUQ/aL8a/Gn4iyS618P8AwzqZ0zwzocm/7HJsIdBghflVPLd0Kje0w3cAggHxzcaN+yXHqEiQW/xsutKWUouqK2miJow2PN2mHcBjnHWvpr4P/sCfsq/HrwPrHiXwP8SfHuuLpFu9xe6RC1r/AGlCFDEL9n+zbmL7Dt25DHgHOQP0wbxl8N9I1+2+GLav4as9YuLc+T4SM0CSyQsGYgW3dSAxxtwRmvgT9uL4Jt+xj8QvD/7SnwfgbRI11OO18SaBZ5jtJ0lJJYgfKkchUIyhcB2RgM0AeJfDPRdN/Zp+L37NXjn4Q6x4x07w98TtYfSdT0PxgsayvFHdwW7lhEESRCtyWQ4O1kyCckD9oq/OP/goF4hsPFv7Qn7E+u6XcC50zU/EMd7azhWXzIZLvS3RsMARlWBwQDX6OGgBNvsfzopfwP50UAfnd+zBa/bv+Cmn7Tttu2edprR7sZxl7YZx+NRf8En/ABbZ/DC6+J/wB16eOy8XaJ4huL+3hnDRy3seyOGRlQjHy+RG+Mk4lz0Gau/so/8AKUL9pT/rxH/o22r0f9tH4X/CP4Z69pP7S3iYXek+KPCUqPBHpbiI67dKpFrbzDHzEMBlhg+WpDHaowAfP37c0/wb/Zs/bJ8M/GDV7vX/ABH48uJbXU5vCmmyxRQxLDF5MVzJKykqD5S4iA+YoxLKOvV/8FMf2hdB+JH7MHgPwj4Yjl1DxL8TZNM1PTdGYf6ZHaPtljd0XcoZpDHGF3clm252mvkD41fDvxFq37PF78cPiEsepfEv4veILe30TTp182W30zmfzbVdzMpZkt4lHVYm2jiSvpT9q/xN8P8A9lTxl8MLfwR4Vbxf+0Fp/hjT9D0x9TzNb6bbQxCOK4kh4VrkhWVcYABZjjC5cYuTSSu2TKUYRcpOyR2X7WnwR8U6f8SP2INI0nSr7xBbeEtStbDUNQsrVmii8l9OJkfGdilLaV+T0Q88V+iNfi5rtv8AtF+ILG88TeMP2iPEHh+5jtjLcW+j3c8NvDEibjlYHijDAA5Kqc4zk11H7KP/AAUl+Kvw8Xw/ffGiHUPEfwp1u8fTLTxbcWYSe2ljVFJDqAJkTguDl+XIZipU+jjMtxWXqLxUOXm21V/uvdfM8XLc7y/OHUWAq8/JZOydtfNpJ7dLn694/wBmiobO6g1CzguraRJ7adFlilQ5V1YZDA+hBzRXmnuH54fs0axYeH/+Cl37T+p6pe2+m6bZ6YZ7m8vJVihgjWS2LO7sQFUAEkk4FVf+CrHlzaz8BfGer2s/iT4PWWredrMenETRTq7QupBHykPCsoU7sHJHeuU/aO+DfxM+Dv7TfxT8U2Xweuvjb8O/idp32S7sdN88SQ8xOUYwBpImR4Qwfbg5XBDA46Dw/wDtf/Gvwv4FsfBmnfsVeIE8L2NmthDpc0V7NF5CrtCMHtTuGOu7Oe9AHJ/E342eHv8AgoJ+1b8C/Bnw1sNTufBnha6/tbU7n7ELU26I6M5BOQiKkSKMgAs6qMkivO9FuX8cftu/tB+JNW2TapputT6XasEACQpPJAuBjhhHbRrkdctnrXuvhv8AbI+NPgv7QfD37EGqaEZ8eb/Zmn3Nv5mM43bLMbsZPX1rzb9sz4Y+NfgL8XLb9orTfC1wnhXxhZWzeKdFzG8ukXjxp5kTlBgZZQRLyDIHDH51z7WS4qlg8wpV6/wp6/da/wAtz5fijA4jM8nxGEwj/eSWnnZptfNK3zPP/wBr648U3XgGz0Pw3ot9qkOpzkX0tjA0zJGmGVCqgkbm5zjHyY71H4+/a0n1b9kOX4KN+zdquheHrLTY0h1mS9lJtLiIiQ3hDWQGS4Zm+YEh3G4ZzXc6D+0L8Otf01LyHxbptorfehv5hbyqcAkFXwTjOMjI9Ca838VeK9b/AGtPFNn8IfhDaPrB1NkbU9YaJkt4IFYMzMWAKRqQCzEZY4Vclhn77iTC5fiebMJ4q7taMVZ/JeV9W+h+Q8E4/OcDyZPSwHKuZuc5KUbXerd1a6WiXW3qzyrwr/wUE+MXg3wvo/h/TNW06PTdJs4bC1STTo2ZYokCICT1O1RzRX7SeCf2N/ht4R8F6BoUmhWWoyaXp9vZNeXFlbtJOY41QyMfL5ZtuSfU0V+Tn9DHuQ7fWjutFFACL/D+NRXdnb6haSW11BHc20qlZIZkDo4PUEHgiiigD+fP/goV4U0TwX+0tqumeH9H0/QtNWws3Wz021S3hDNECxCIAMk8k45r9of2O/A/hzwf8E9Bl0Hw/peiSXtnaz3T6dZR25nkNrCS7lFG5ie55oooA9xAGBxRRRQB/9k=' alt='Disk Usage' width='50' height='50'/>
            Disk Utilization Report
        </div>
        <br>
        <div><i><b>Generated on: </b> $((Get-Date).DateTime)</i></div>
        $newHtmlFragment
    </body>
</html>
"@

$html > test.html

$from = 'no-reply@vcloud-lab.com'
$to = 'Patrick.Henighem@vcloud-lab.com'
$subject = 'Weekly disk utilization report'
$body = $html
$smtpServer = 'emailexchange.vcloud-lab.com'
$smtpPort = 587

Send-MailMessage -From $from -to $to -Subject $Subject -Body $body -BodyAsHtml -SmtpServer $smtpServer -Port $smtpPort