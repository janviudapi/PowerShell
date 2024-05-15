#requires -version 5
<#
.SYNOPSIS
    Show Vmware Virtual Machine Disks mapping view in GUI HTML.
.DESCRIPTION
    Show Vmware Virtual Machine list all Disks mapping view in GUI HTML.
.PARAMETER GroupName
    Prompts you provide VM name, vCenter/Esxi credentials and Windows VM credentials to connect VM.
.INPUTS
    System.Windows.Forms.Form
.OUTPUTS
    HTML Diagram
.NOTES
    Version:        1.0
    Author:         Janvi
    Creation Date:  15 May 2024
    Purpose/Change: Get Vmware Virtual Machine Disks mapping view in HTML
    Useful URLs: http://vcloud-lab.com
    Tested on: Windows 2019 DataCenter Edition, PowerShell 7.4.2, vCenter 8.0, Chrome and Edge Browser
.EXAMPLE
    PS C:\>. /Show-VMDiskRelationshipMapping.ps1

    List all VMware Virtual Machine disk mapping
#>

$details = . $PSScriptRoot\_extras\VMdetailsGUI.ps1 | ConvertFrom-Json
$vmName = $details.vm.vmName

try {
    Import-Module VMware.VimAutomation.core -ErrorAction Stop | Out-Null
    $vCenterLogin = Connect-VIServer -Server $details.vc.vCenter -User $details.vc.vCenterUser -Password $details.vc.vCenterPassword -ErrorAction Stop
    $hdds = Get-VM $vmName -ErrorAction Stop | Get-HardDisk
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Host $error[0].exception.Message
    break
}

$remoteDisksScript = {
  if (-not(Test-Path c:\Temp))
  {
    New-Item -Path C:\ -Name Temp -ItemType Directory -Force
  } #if (-not(Test-Path c:\Temp))

  $allDrives = Get-CimInstance -ClassName Win32_DiskDrive
  $usedDisks = $allDisks= $allDrives | ForEach-Object {
    $disk = $_
    $partitions = "ASSOCIATORS OF " +
                  "{Win32_DiskDrive.DeviceID='$($disk.DeviceID)'} " +
                  "WHERE AssocClass = Win32_DiskDriveToDiskPartition"
    Get-CimInstance -Query $partitions | ForEach-Object {
      $partition = $_
      $drives = "ASSOCIATORS OF " +
                "{Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} " +
                "WHERE AssocClass = Win32_LogicalDiskToPartition"
      Get-CimInstance -Query $drives | ForEach-Object {
          [PSCustomObject]@{
          DriveLetter       = $_.DeviceID.Replace(':','')
          Disk              = $disk.DeviceID.Substring(4)
          PhysicalDiskNo    = $disk.DeviceID.Substring(4).TrimStart('PHYSICALDRIVE')
          DiskSize          = [Math]::Ceiling($disk.Size/1GB)
          DiskModel         = $disk.Model
          Partition         = $partition.Name
          RawSize           = [Math]::Ceiling($partition.Size/1GB)
          VolumeName        = $_.VolumeName
          SizeGB            = [Math]::Ceiling($_.Size/1GB)
          FreeSpaceGB       = [Math]::Ceiling($_.FreeSpace/1GB)
          VolumeSerialNo    = $_.VolumeSerialNumber
          DriveType         = $_.DriveType
          FileSystem        = $_.FileSystem
          SerialNumber      = $disk.SerialNumber
          ScsiBus           = $Disk.SCSIBus
          SCSILogicalUnit   = $disk.SCSILogicalUnit
          SCSIPort          = $disk.SCSIPort
          SCSITargetId      = $disk.SCSITargetId
          Index             = $disk.Index
          DiskIndex         = $partition.DiskIndex
          PartitionIndex    = $Partition.Index
        } #[PSCustomObject]@{
      } #Get-CimInstance -Query $drives | ForEach-Object {
    } #Get-CimInstance -Query $partitions | ForEach-Object {
  } #$usedDisks = $allDisks= $allDrives | ForEach-Object {

  $rawDisks = $allDrives | Where-Object {$_.SerialNumber -notin $usedDisks.SerialNumber}
  $i = 100
  foreach ($rawDisk in $rawDisks) 
  {
    ++$i
    $allDisks += [PSCustomObject]@{
      DriveLetter       = "raw$i"
      Disk              = $rawDisk.DeviceID.Substring(4)
      PhysicalDiskNo    = $i
      DiskSize          = $rawDisk.Size
      DiskModel         = $rawDisk.Caption
      Partition         = 'N/a'
      RawSize           = [Math]::Ceiling($rawDisk.Size/1GB)
      VolumeName        = 'N/a'
      SizeGB            = [Math]::Ceiling($rawDisk.Size/1GB)
      FreeSpaceGB       = 'N/a'
      VolumeSerialNo    = 'N/a'
      DriveType         = 'N/a'
      FileSystem        = 'N/a'
      SerialNumber      = $rawDisk.SerialNumber
      ScsiBus           = $rawDisk.SCSIBus
      SCSILogicalUnit   = $rawDisk.SCSILogicalUnit
      SCSIPort          = $rawDisk.SCSIPort
      SCSITargetId      = $rawDisk.SCSITargetId
      Index             = $rawDisk.Index
      DiskIndex         = $rawDisk.Index
      PartitionIndex    = 'N/a'
    } #$allDisks += [PSCustomObject]@{
  } #foreach ($rawDisk in $rawDisks)
  $allDisks #| Export-Csv -NoTypeInformation $PSScriptRoot\DiskInfo.csv
  #Import-Csv C:\Temp\DiskInfo.csv
}

# Provid clear text string for username and password
[string]$userName = $details.windows.winUser
[string]$userPassword = $details.windows.winPassword
# Convert to SecureString
[securestring]$secStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force
# convert to password object
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($userName, $secStringPassword)

try {
    $session = New-PSSession -ComputerName $vmName -Credential $credObject #(Get-Credential -UserName 'vcloud-lab\vjanvi' -Message 'Remote Server Credentials')
    $allDisks = Invoke-Command -Session $session -ScriptBlock $remoteDisksScript
}
catch {
    <#Do this if a terminating exception happens#>
    Write-Host $error[0].exception.Message
    break
}

#Invoke-VMScript -VM $vmName -ScriptText 'Get-CimInstance -ClassName Win32_BIOS' -ScriptType Powershell -GuestUser 'vcloud-lab.com\vjanvi' -GuestPassword 'Password'
#$allDisks | Import-Csv $PSScriptRoot\DiskInfo.csv

$completeInfo = @()
foreach ($hdd in $hdds)
{ 
  $rawHddUuid = $hdd.extensiondata.backing.uuid
  $rawHddUuid = $rawHddUuid.Replace('-','')
  $matchedHdd = $allDisks | Where-Object {$_.SerialNumber -eq $rawHddUuid}
  $matchedHdd | Add-Member -Name StorageFormat -MemberType NoteProperty -Value $hdd.StorageFormat
  $matchedHdd | Add-Member -Name Filename -MemberType NoteProperty -Value $hdd.Filename
  $matchedHdd | Add-Member -Name CapacityGB -MemberType NoteProperty -Value $hdd.CapacityGB
  $matchedHdd | Add-Member -Name VMName -MemberType NoteProperty -Value $vmName
  $matchedHdd | Add-Member -Name HDDName -MemberType NoteProperty -Value $hdd.Name
  $matchedHdd | Add-Member -Name ControllerKey -MemberType NoteProperty -Value $hdd.ExtensionData.ControllerKey
  $matchedHdd | Add-Member -Name UnitNumber -MemberType NoteProperty -Value $hdd.ExtensionData.UnitNumber
  $matchedHdd | Add-Member -Name DataStoreName -MemberType NoteProperty -Value (Get-Datastore -Id $hdd.ExtensionData.Backing.Datastore[0]).Name
  $completeInfo += $matchedHdd
}
$completeInfo | Export-Csv -NoTypeInformation -Path $PSScriptRoot\DiskInfo.csv

$drives = Import-Csv $PSScriptRoot\DiskInfo.csv

$physicalDisks = $drives | Group-Object -Property PhysicalDiskNo
$groupNumbering = $physicalDisks.Name | ForEach-Object {[int]$_} | Sort-Object
$links = $null
foreach ($number in $groupNumbering) {
#foreach ($physicaldisk in $physicalDisks) {
    $physicaldisk = $physicaldisks | Where-Object {$_.Name -eq $number}
    $physicalDriveNo = $physicaldisk.Group[0].Disk
    $previousGroupDisk = 1
    foreach ($group in $physicaldisk.Group)
    {
        #https://mermaid.js.org/config/schema-docs/config.html#theme
        $links += "      {0}({0}: fa:fa-computer) ===> {1};" -f $group.DriveLetter, $physicalDriveNo
        if ($group.DriveLetter -notmatch 'raw')
        {
            $links += "        style {0} stroke:#FFFFFF,fill:#ff595e,color:white,fontSize:30px;`n" -f $group.DriveLetter
        }
        else 
        {
            $links += "        style {0} stroke:#FFFFFF,fill:#0a2344,color:white,fontSize:30px;`n" -f $group.DriveLetter
        }
       
        if (($physicalDisk.Count -eq 1) -or ($previousGroupDisk -eq 1))
        {
            $links += "      {0} ===> SCSI{1}{2}(SCSI{1}:{2} fa:fa-server);`n" -f $physicalDriveNo, $group.SCSIPort, $group.SCSITargetId
            $links += "        style {0} stroke:#FFFFFF,fill:#ff924c;`n" -f $physicalDriveNo
            $links += "      SCSI{0}{1}(SCSI{0}:{1}) -.-> SCSI{2};`n" -f $group.SCSIPort, $group.SCSITargetId, $group.SCSIPort
            $links += "        style SCSI{0}{1} stroke:#FFFFFF,fill:#ffca3a;`n" -f $group.SCSIPort, $group.SCSITargetId
            $links += "      SCSI{0} -.-> {1}({2});`n" -f $group.SCSIPort, ($group.HDDName -replace '\s',''), $group.HDDName
            $links += "        style SCSI{0} stroke:#FFFFFF,fill:#8ac926;`n" -f $group.SCSIPort
            $links += "        style {0} stroke:#FFFFFF,fill:#1982c4,color:white;" -f ($group.HDDName -replace '\s','')
            $links += "      {0}({1}) ---> {2}({3} fa:fa-database);" -f ($group.HDDName -replace '\s',''), $group.HDDName, ($group.DataStoreName -replace '\s',''), $group.DataStoreName
            $links += "        style {0} stroke:#FFFFFF,fill:#6a4c93,color:white;" -f ($group.DataStoreName -replace '\s','')
        }
        $previousGroupDisk++
    }
}
Import-Module "$PSScriptRoot\_extras\EPS\1.0.0\EPS.psm1" -Force | Out-Null
$html = Invoke-EpsTemplate -Path "$PSScriptRoot\_extras\Diagram.eps"
$html | Out-File $PSScriptRoot\DiskMapping.html
"--------------------------------------------------`n"
Write-Host "Open $PSScriptRoot\DiskMapping.html in your favorate browser" -BackgroundColor DarkGreen
"`n--------------------------------------------------"
Disconnect-VIServer * -Force -Confirm:$false