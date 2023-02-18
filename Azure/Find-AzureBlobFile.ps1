$searchFile = 'txt|csv|ps1'
$exportCsv = 'c:\temp\files.csv'

$storageAccount = Get-AzStorageAccount
foreach ($sa in $storageAccount)
{
    $saKey = Get-AzStorageAccountKey -ResourceGroupName $sa.ResourceGroupName -Name $sa.StorageAccountName
    $saContext = New-AzStorageContext -StorageAccountName $sa.StorageAccountName -StorageAccountKey $saKey[1].Value
    $saContainer = Get-AzStorageContainer -Context $saContext
    foreach ($saFolder in $saContainer)
    {
        $files = Get-AzStorageBlob -container $saFolder.Name -Context $saContext | Where-Object {$_.Name -match $searchFile}
        $files
        $files | Select-Object Name, @{N='StorageAccountName';E={$_.Context.StorageAccountName}}, @{N='Container';E={$saFolder.Name}} | Export-Csv -NoTypeInformation -Path $exportCsv -Append
    }
}