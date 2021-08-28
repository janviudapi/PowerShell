
Import-Module -Name ActiveDirectory
$servers = Get-AdComputer -Filter *

#$servers = 'localhost', $env:COMPUTERNAME,  '127.0.0.1', 'nullserver', '192.168.34.107'
$result = @()
$credential = Get-Credential
$cimSessionOption = New-CimSessionOption -Protocol Default
foreach ($computerName in $servers) {
    $hostName = $computerName.Name
    if (Test-Connection $computerName.DNSHostName -Quiet -Count 2) 
    {
        try
        {
            $cimsession = New-CimSession -ComputerName $hostName -SessionOption $cimSessionOption -Credential $credential -ErrorAction Stop
            Write-Host "Working on Server $hostName" -BackgroundColor DarkGreen
            #Machine 
            $computerSystem = Get-CimInstance -Class CIM_ComputerSystem -ComputerName $hostName -Cimsession $cimsession | Select-Object Manufacturer, Model -ErrorAction Stop #Win32_ComputerSystem 
            #serial Number
            $bios = Get-CimInstance -Class Win32_BIOS  -ComputerName $hostName | Select-Object SerialNumber, SMBIOSBIOSVersion -ErrorAction Stop
            #Motherboad
            $baseBoard = Get-CimInstance -Class win32_baseboard -ComputerName $hostName | Select-Object Manufacturer, Product, SerialNumber, Version -ErrorAction Stop
            #Operating System:
            $operatingSystem = Get-CimInstance -Class CIM_OperatingSystem -ComputerName $hostName | select-Object Caption, OSArchitecture -ErrorAction Stop #win32_OperatingSystem
            #Processor:
            $processor = Get-CimInstance -Class CIM_Processor -ComputerName $hostName | select-Object Name, OSArchitecture, NumberOfCores, NumberOfEnabledCore, NumberOfLogicalProcessors, ProcessorId, PartNumber -ErrorAction Stop #Win32_Processor
            #Memory
            $physicalMemory = Get-CimInstance -Class CIM_PhysicalMemory -ComputerName $hostName | Select-Object DeviceLocator, SerialNumber, Capacity, @{N= "Speed";Expression = {if (($_.speed -ge '1000000000')) {"$($_.Speed / 1000000000) Gb/s"} Elseif ($_.Speed -gt 0) {"$($_.Speed / 1000000) Mb/s"}}}, 
                    PartNumber, Manufacturer -ErrorAction Stop
            #Video Card
            $videoController = Get-CimInstance -Class win32_VideoController -ComputerName $hostName | Select-Object Name, VideoProcessor -ErrorAction Stop
            #Monitor
            $monitor = Get-CimInstance -Class WmiMonitorID -Namespace root\wmi -ComputerName $hostName | Select-Object @{Label='ManufacturerName'; Expression={($_.ManufacturerName | Foreach-Object {[char]$_}) -join ""}}, 
                    @{Label='ProductCodeID'; Expression={($_.ProductCodeID | Foreach-Object {[char]$_}) -join ""}}, 
                    @{Label='UserFriendlyName'; Expression={($_.UserFriendlyName | Foreach-Object {[char]$_}) -join ""}}, 
                    @{Label='SerialNumberID'; Expression={($_.SerialNumberID | Foreach-Object {[char]$_}) -join ""}}, 
                    YearOfManufacture, WeekOfManufacture -ErrorAction Stop
            #https://www.lansweeper.com/knowledgebase/list-of-3-letter-monitor-manufacturer-codes/
            #Disk
            $diskDrive = Get-CimInstance -ClassName Win32_DiskDrive -ComputerName $hostName | Select-Object Model, SerialNumber, Size, FirmwareRevision, InterfaceType, Index -ErrorAction Stop
            #Network Adapter
            $networkAdapter = Get-CimInstance -ClassName Win32_NetworkAdapter -ComputerName $hostName | Where-Object {$_.PhysicalAdapter -eq $true} | Select-Object Name, ProductName, DeviceID, Speed, AdapterType, InterfaceIndex, MACAddress -ErrorAction Stop
            $objInv = New-Object psobject
            $objInv | Add-Member -Name ComputerName -MemberType NoteProperty -Value $hostName
            $objInv | Add-Member -Name computerSystem -MemberType NoteProperty -Value $computerSystem
            $objInv | Add-Member -Name bios -MemberType NoteProperty -Value $bios
            $objInv | Add-Member -Name baseBoard -MemberType NoteProperty -Value $baseBoard
            $objInv | Add-Member -Name operatingSystem -MemberType NoteProperty -Value $operatingSystem
            $objInv | Add-Member -Name processor -MemberType NoteProperty -Value $processor
            $objInv | Add-Member -Name physicalMemory -MemberType NoteProperty -Value $physicalMemory
            $objInv | Add-Member -Name videoController -MemberType NoteProperty -Value $videoController
            $objInv | Add-Member -Name monitor -MemberType NoteProperty -Value $monitor
            $objInv | Add-Member -Name diskDrive -MemberType NoteProperty -Value $diskDrive
            $objInv | Add-Member -Name networkAdapter -MemberType NoteProperty -Value $networkAdapter
            $result += $objInv
        } #try
        catch
        {
            Write-Host "Connection to server $hostName failed" -BackgroundColor DarkRed
        } #catch
    } #if (Test-Connection $computerName -Quiet -Count 2)
    else
    {
        Write-Host "server $computerName notreachable" -BackgroundColor DarkRed
    }
} #foreach ($computerName in $servers) {
$rawJson = (($result | ConvertTo-Json -Depth 3).replace('\u0000', '')) -split "`r`n"

$formatedJson = .{
    'var data = ['
    $rawJson | Select-Object -Skip 1
} #replace first Line
$formatedJson[-1] = '];' #replace last Line
$formatedJson | Out-File $PSScriptRoot\data.js
