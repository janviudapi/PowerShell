<#
    .NOTES
    --------------------------------------------------------------------------------
     Code generated by:  Visual Studio Code
     Created on:         01/17/2021 4:57 AM
     Generated by:       http://vcloud-lab.com
     Written by:         J U
     Tested on:          Windows 10, PowerShell 5.1
    --------------------------------------------------------------------------------
    .DESCRIPTION
        GUI script generated using Visual Studio Code
#>

#Install Kubernetes on Windows
[CmdletBinding()]
param (
    [Parameter(
        Position=0,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true,
        HelpMessage='Type folder path to download kubectl.exe'
    )]
    [Alias('Folder')]
    [string]$Path = 'C:\Kubernetes' #change here
)
$kubectlPath = $Path

if (-not(Test-Path $kubectlPath))
{
    Write-Host "`t-- New directory $kubectlPath created."
    $parent = Split-Path $kubectlPath -parent
    $leaf = Split-Path $kubectlPath -leaf
    New-Item -Name $leaf -Path $parent -ItemType Directory | Out-Null
}
else {
    Write-Host "`t-- directory $kubectlPath already exists."
}

if (-not(Test-Path "$kubectlPath\kubectl.exe"))
{
    Write-Host "`t-- Downloading latest version kubectl.exe to directory $kubectlPath."
    $latestVersion = Invoke-RestMethod -Uri 'https://storage.googleapis.com/kubernetes-release/release/stable.txt' 
    Invoke-WebRequest -Uri "https://storage.googleapis.com/kubernetes-release/release/$latestVersion/bin/windows/amd64/kubectl.exe" -OutFile "$kubectlPath\kubectl.exe"
}
else {
    Write-Host "`t-- kubectl.exe already exists under directory $kubectlPath."
}

$pathList = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User) -split ';'
if (-not($pathList -contains $kubectlPath))
{
    Write-Host "`t-- Setting up Environment variable 'path' - $kubectlPath."
    [System.Environment]::SetEnvironmentVariable('Path', "$([System.Environment]::GetEnvironmentVariable('Path'));$kubectlPath", [System.EnvironmentVariableTarget]::User)
}
else {
    Write-Host "`t-- Environment variable 'path' - $kubectlPath already exists."
}