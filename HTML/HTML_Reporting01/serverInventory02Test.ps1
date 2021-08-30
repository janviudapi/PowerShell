Import-Module -Name ActiveDirectory

$servers               = Get-AdComputer -Filter *
$credential            = Get-Credential
$cimSessionOption      = New-CimSessionOption -Protocol Default
$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$result = foreach ($computerName in $servers)
{
    $hostName = $computerName.Name
    try
    {
        $cimsession = New-CimSession -ComputerName $hostName -SessionOption $cimSessionOption -Credential $credential
        Write-Host "Working on Server $hostName" -BackgroundColor DarkGreen

        $computerSystem  = Get-CimInstance -Cimsession $cimsession -ClassName CIM_ComputerSystem    | Select-Object Manufacturer, Model
        $bios            = Get-CimInstance -Cimsession $cimsession -ClassName Win32_BIOS            | Select-Object SerialNumber, SMBIOSBIOSVersion
        $baseBoard       = Get-CimInstance -Cimsession $cimsession -ClassName win32_baseboard       | Select-Object Manufacturer, Product, SerialNumber, Version
        $operatingSystem = Get-CimInstance -Cimsession $cimsession -ClassName CIM_OperatingSystem   | select-Object Caption, OSArchitecture
        $processor       = Get-CimInstance -Cimsession $cimsession -ClassName CIM_Processor         | select-Object Name, OSArchitecture, NumberOfCores, NumberOfEnabledCore, NumberOfLogicalProcessors, ProcessorId, PartNumber
        $videoController = Get-CimInstance -Cimsession $cimsession -ClassName win32_VideoController | Select-Object Name, VideoProcessor
        $diskDrive       = Get-CimInstance -Cimsession $cimsession -ClassName Win32_DiskDrive       | Select-Object Model, SerialNumber, Size, FirmwareRevision, InterfaceType, Index
        $networkAdapter  = Get-CimInstance -Cimsession $cimsession -ClassName Win32_NetworkAdapter -Filter "PhysicalAdapter = 'true'" | Select-Object Name, ProductName, DeviceID, Speed, AdapterType, InterfaceIndex, MACAddress
        $physicalMemory  = Get-CimInstance -Cimsession $cimsession -ClassName CIM_PhysicalMemory | ForEach-Object -Process {
            [pscustomobject]@{
                #DeviceLocator = "" Doesn't actually exist?
                SerialNumber  = $_.SerialNumber
                Capacity      = $_.Capacity
                Speed         = if ($_.speed -ge 1000000000) {"$($_.Speed / 1000000000) Gb/s"} else {"$($_.Speed / 1000000) Mb/s"}
                PartNumber    = $_.PartNumber
                Manufacturer  = $_.Manufacturer
            }
        }
        $monitor         = Get-CimInstance -Cimsession $cimsession -ClassName WmiMonitorID -Namespace root\wmi | ForEach-Object -Process {
            [pscustomobject]@{
                ManufacturerName  = [char[]]$_.ManufacturerName -join ''
                ProductCodeID     = [char[]]$_.ProductCodeID    -join ''
                UserFriendlyName  = [char[]]$_.UserFriendlyName -join ''
                SerialNumberID    = [char[]]$_.SerialNumberID   -join ''
                YearOfManufacture = $_.YearOfManufacture
                WeekOfManufacture = $_.WeekOfManufacture
            }
        }
    
        [pscustomobject]@{
            ComputerName    = $hostName
            computerSystem  = $computerSystem
            Bios            = $bios
            BaseBoard       = $baseBoard
            OperatingSystem = $operatingSystem
            Processor       = $processor
            PhysicalMemory  = $physicalMemory
            VideoController = $videoController
            Monitor         = $monitor
            DiskDrive       = $diskDrive
            NetworkAdapter  = $networkAdapter
        }
    }
    catch
    {
        Write-Error -ErrorRecord $_
    }
}
$rawJson = (($result | ConvertTo-Json -Depth 3).replace('\u0000', '')) -split "`r`n"

$formatedJson = .{
    'var data = ['
    $rawJson | Select-Object -Skip 1
} #replace first Line
$formatedJson[-1] = '];' #replace last Line
$formatedJson | Out-File $PSScriptRoot\data.js
