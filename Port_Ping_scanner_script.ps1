########################### Script 1 ####################################

$computers =  "ad001", "psdomain02", "192.168.34.39","server1"

foreach ($com in $computers)
{
    $ping = Test-Connection -computername $com -Quiet -Count 1
    $portcheck = Test-NetConnection -Port 445 -ComputerName $com -WarningAction SilentlyContinue

    $overall =  "Ping = $ping | Port = $($portcheck.TcpTestSucceeded)"
 
    [pscustomobject]@{
        ServerName = $com
        Success = $overall
        PingSucceeded = $ping
    }
}

########################### Script 2 ####################################

$computers = "ad001", "psdomain02", "192.168.34.39", "server1"

$jobs = foreach ($com in $computers) {
    Start-Job -ArgumentList $com -ScriptBlock {
        param($ComputerName)

        $ping = Test-Connection -ComputerName $ComputerName -Quiet -Count 1
        $portcheck = Test-NetConnection -Port 445 -ComputerName $ComputerName -WarningAction SilentlyContinue

        [pscustomobject]@{
            ServerName     = $ComputerName
            PingSucceeded = $ping
            PortSucceeded = $portcheck.TcpTestSucceeded
            Overall       = "Ping = $ping | Port = $($portcheck.TcpTestSucceeded)"
        }
    }
}

# Wait for all jobs to finish
Wait-Job $jobs

# Collect results
$results = Receive-Job $jobs | Select-Object ServerName, PingSucceeded, PortSucceeded, Overall

# Cleanup
Remove-Job $jobs

$results


########################### Script 3 ####################################

function Test-TcpPort {
    param (
        [parameter(Mandatory)][String]$ComputerName,
        [parameter(Mandatory)][Int]$Port,
        [parameter(Mandatory=$false)][Int]$ConnectionTimeout = 500 # Timeout in milliseconds
    )

    try 
    {
        $hostEntry = [System.Net.Dns]::GetHostAddresses($ComputerName)
        $ip = ($hostEntry | Where-Object AddressFamily -eq 'InterNetwork').IPAddressToString
    }
    catch
    {
        $ip = $ComputerName
    }

    try
    {
        $ping = New-Object System.Net.NetworkInformation.Ping
        $pingReply = $ping.Send($ip)
        if ($pingReply.Status -eq 'Success')
        {
            $pingStatus = $true
        }
        else {
            $pingStatus = $false
        }
    }
    catch
    {
        $pingStatus = $false
    }

    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $portConnectionStatus = $false
    try {
        $connectAsync = $tcpClient.BeginConnect($ip, $Port, $null, $null)
        $waitHandle = $connectAsync.AsyncWaitHandle
        if ($waitHandle.WaitOne($ConnectionTimeout, $false)) {
            $tcpClient.EndConnect($connectAsync)
            $portConnectionStatus = $true
        }
    }
    finally {
        $tcpClient.Close()
        $waitHandle.Dispose()
    }
    
    $result = [pscustomobject]@{
       ComputerName = $ComputerName
       IP = $ip
       PingStatus = $pingStatus
       PortConnectionStatus = $portConnectionStatus

    }

    return $result
}


$computers = "ad001", "server1", "psdomain02", "192.168.34.39"
$computers | ForEach-Object {Test-TcpPort -ComputerName $_ -Port 445}