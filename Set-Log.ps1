#Created By: http://vcloud-lab.com
#Auther: vJanvi
#Date: 5 August 2017
#Description:  Create a new file if not exist, if Exist rename it and create a new file.

function Set-Log
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact='Medium',
        HelpURI='http://vcloud-lab.com'
    )] #[CmdletBinding(
    Param
    ( 
        [parameter(Position=0, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [alias('C')]
        [String]$FilePath = 'C:\Temp\logs\info.log'
    ) #Param
    Begin {} #Begin
    Process 
    {
        if (Test-Path $FilePath)
        {
            $parentPath = Split-Path -Path $FilePath -Parent
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
            $fileExtension = [System.IO.Path]::GetExtension($FilePath)
            $dateTime = [System.DateTime]::Now
            $oldFileName = "{0}\$fileName-{1}{2:d2}{3:d2}{4}{5}$fileExtension" -f $parentPath, $dateTime.Year ,$dateTime.Month, $dateTime.Day, $dateTime.ToShortTimeString().Replace(':',''), $dateTime.Millisecond
            try
            {
                Rename-Item -Path $FilePath -NewName $oldFileName -Force -ErrorAction Stop
                Write-Host "Renamed filename - $oldFileName" -ForegroundColor DarkYellow
                [Void](New-Item -Path $FilePath -ItemType File -Force -ErrorAction Stop)
                Write-Host "File created - $FilePath" -ForegroundColor DarkGreen
            }
            catch 
            {
                Write-Host "File cannot be renamed or created, Check Permission or if in use - $FilePath" -BackgroundColor DarkRed
            }

        } #if (Test-Path $filePath)
        else 
        {
            try
            {
                [Void](New-Item -Path $FilePath -ItemType File -Force -ErrorAction Stop)
                Write-Host "File created - $FilePath" -ForegroundColor DarkGreen
            }
            catch
            {
                Write-Host "File cannot be created, Check Permission or if in use - $FilePath" -BackgroundColor DarkRed
            }
        } #else
    } #Process
    End {} #End
} #function Set-log