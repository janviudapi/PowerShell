
##---##---##
#Export-CliXML
Get-Service | Select-Object Name, DisplayName, Status, StartType -First 2 | Export-Clixml -NoTypeInformation -Path C:\Temp\XML\file.xml
notepad C:\Temp\XML\file.xml

##---##---##
#ConvertTo-XML
$filePath = 'C:\Temp\XML\file.xml'
$xmlData = Get-Service | Select-Object Name, DisplayName, Status, StartType -First 2 | Convertto-XML -NoTypeInformation
$xmlData.Save($filePath)
Get-Content $filePath


##---##---##
#Manually create XML using foreach loop
$data = Get-Service | Select-Object Name, DisplayName, Status, StartType -First 2
$properties = $data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty  Name

$xmlData = @()
$xmlData += '<?xml version="1.0" encoding="UTF-8"?> '
$xmlData += '<services>'
foreach ($obj in $data) 
{
    $xmlData += '   <service>'
    foreach ($property in $properties) 
    {
        $xmlData += "       <$property>$($obj.$property)</$property>"
    }
    $xmlData += '   </service>'
}
$xmlData += '</services>'
$xmlData | Out-File -FilePath C:\Temp\XML\file.xml