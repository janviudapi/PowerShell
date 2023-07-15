#<#
Clear-Host

$notExist = $true
$pingIteration = 1
do {
    Write-Host -ForegroundColor Cyan "- Ping Interation: $pingIteration"
    $rackUnits = Import-CSV $PSScriptRoot\RackServers.csv
    $allServerList = $rackUnits | Group-Object ServerName #Select-Object -Unique ServerName
    $nonEmptyServerList = $allServerList | where-Object {-not [string]::IsNullOrEmpty($_.name)}
    
    Get-Job | Remove-Job -Force -Confirm:$false

    $nonEmptyServerList | ForEach-Object { #-ThrottleLimit 10 -Parallel {
        $null = Start-ThreadJob {
            #$argServerName = $args[0]
            try {
                $pingTest = Test-Connection -TargetName $args[0] -Count 1 -ErrorAction Stop
                [PSCustomObject]@{
                    #New-Object psobject -Property[ordered]@{ 
                    id = $pingTest.Destination
                    servername = $args[0]
                    name = $pingTest.Destination
                    ipaddress = ($null -ne $pingTest.Address) ? $pingTest.Address.IPAddressToString : $pingTest.Destination
                    status = ($pingTest.Status.ToString() -eq 'Success') ? 'on' : 'off'
                } #[PSCustomObject]@{
            } #try {
            catch {
                [PSCustomObject]@{
                    id = $args[0]
                    servername = $args[0]
                    name = $args[0]
                    ipaddress = 'Unknown'
                    status = 'unknown'
                }
            } #catch {
            finally {}
        } -ArgumentList $_.Name.Trim() -ThrottleLimit 10 #$null = Start-ThreadJob
    } #$serverList | ForEach-Object {

    Start-Sleep -Seconds 10
    $report = Get-Job | Wait-Job | Receive-Job #| Select-Object @{N='id'; E={$_.Destination}}, @{N='name'; E={$_.Destination}}, @{N='ipAddress'; E={$_.Address.IPAddressToString}}, @{N='status'; E={($_.Status -eq 'Success') ? 'On' : 'Off'}} #Using the ternary operator syntax

    $information =  New-Object System.Collections.ArrayList
    foreach ($rack in $rackUnits)
    {
        if ($rack.ServerName -in $report.serverName)
        {
            $matchReport = $report | Where-object {$_.servername -eq  $rack.ServerName }
        }
        else {
            $matchReport = [PSCustomObject]@{
                id = 'n/a'
                servername = 'n/a'
                name = 'n/a'
                ipaddress = 'n/a'
                status = 'n/a'
            }
        }
        $rackInfo = @{}
        $serverInfo = @{}
        $rack.psobject.properties | Foreach-Object { $rackInfo[$_.Name] = $_.Value }
        $matchReport.psobject.properties | Foreach-Object { $serverInfo[$_.Name] = $_.Value }
        [void]$rackInfo.Add('serverinfo', $serverInfo)
        [void]$information.Add($rackInfo)
    }

    $information | ConvertTo-Json | Out-File $PSScriptRoot\dbase\serverData.json
    $pingIteration++
} while (
    # Condition that stops the loop if it returns false 
    $notExist -eq $true
) #while (
#>



