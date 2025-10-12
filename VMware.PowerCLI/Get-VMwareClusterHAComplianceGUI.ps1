#    .NOTES
#    --------------------------------------------------------------------------------
#     Generated on:            12-October-25 8:15 PM
#     Generated for:           One click check VMware ESXi Cluster Admission Control Compliance
#     PowerShell Version:      V7
#    --------------------------------------------------------------------------------
#    .DESCRIPTION
#        vcloud-lab.com One click check VMware ESXi Cluster Admission Control Compliance

$assemblies = ('System.Windows.Forms', 'System.Data', 'System.Drawing', 'System.Design', 'PresentationFramework')
$assemblies | Foreach-Object {[void][reflection.assembly]::Load($_)}
Add-Type -AssemblyName "System.Drawing", "System.Windows.Forms", "System.Data", "System.Design", "PresentationFramework"

[System.Windows.Forms.Application]::EnableVisualStyles()
$formHAAdmission = New-Object 'System.Windows.Forms.Form'
$labelOverallResult = New-Object 'System.Windows.Forms.Label'
$statusstrip1 = New-Object 'System.Windows.Forms.StatusStrip'
$tabcontrol1 = New-Object 'System.Windows.Forms.TabControl'
$tabpage1_AdmissionControl = New-Object 'System.Windows.Forms.TabPage'
$groupbox_SelectedCluster = New-Object 'System.Windows.Forms.GroupBox'
$groupbox_DefineHostFailoverCapacityBy = New-Object 'System.Windows.Forms.GroupBox'
$picturebox_PerformaceDegradationVMsTolerate = New-Object 'System.Windows.Forms.PictureBox'
$label_Percent = New-Object 'System.Windows.Forms.Label'
$textbox_PerformanceDegration = New-Object 'System.Windows.Forms.TextBox'
$labelPercentageOfPerforma = New-Object 'System.Windows.Forms.Label'
$labelPerformanceDegradationVMsTolerate = New-Object 'System.Windows.Forms.Label'
$labelOfPersistentMemoryCapacity = New-Object 'System.Windows.Forms.Label'
$textbox_ReservePercentOfPersistentMemoryCap = New-Object 'System.Windows.Forms.TextBox'
$labelReserve = New-Object 'System.Windows.Forms.Label'
$labelSomeAmountOfPersiste = New-Object 'System.Windows.Forms.Label'
$textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity = New-Object 'System.Windows.Forms.TextBox'
$labelOverrideCalculatedPersistantMemory = New-Object 'System.Windows.Forms.Label'
$picturebox_ReservePersistentMemoryFailoverCapacity = New-Object 'System.Windows.Forms.PictureBox'
$textbox_ReservePersistentMemoryFailoverCapacity = New-Object 'System.Windows.Forms.TextBox'
$labelReservePersistentMem = New-Object 'System.Windows.Forms.Label'
$labelPercentMemory = New-Object 'System.Windows.Forms.Label'
$textbox_ReservedFailoverMemoryCapacity = New-Object 'System.Windows.Forms.TextBox'
$labelReservedFailoverMemoryCapacity = New-Object 'System.Windows.Forms.Label'
$labelPercentCPU = New-Object 'System.Windows.Forms.Label'
$textbox_ReservedFailoverCPUCapacity = New-Object 'System.Windows.Forms.TextBox'
$labelReservedFailoverCPUCap = New-Object 'System.Windows.Forms.Label'
$textbox_OverRideCalculatedFailoverCapacity = New-Object 'System.Windows.Forms.TextBox'
$picturebox_OverRideCalculatedFailoverCapacity = New-Object 'System.Windows.Forms.PictureBox'
$labelOverrideCalculatedFa = New-Object 'System.Windows.Forms.Label'
$picturebox_HostFailureClusterTolerates = New-Object 'System.Windows.Forms.PictureBox'
$textbox_DefineHostFailoverCapacityBy = New-Object 'System.Windows.Forms.TextBox'
$picturebox_DefineHostFailoverCaparityBy = New-Object 'System.Windows.Forms.PictureBox'
$labelDefineHostFailoverBy = New-Object 'System.Windows.Forms.Label'
$textbox_HostFailuresClusterTolerates = New-Object 'System.Windows.Forms.TextBox'
$labelMaximumIsOneLessThan = New-Object 'System.Windows.Forms.Label'
$labelHostFailuresClusterT = New-Object 'System.Windows.Forms.Label'
$textbox_AdmissionControlEnabled = New-Object 'System.Windows.Forms.TextBox'
$picturebox_AdmissionControlEnabled = New-Object 'System.Windows.Forms.PictureBox'
$labelAdmissionControlEnab = New-Object 'System.Windows.Forms.Label'
$textbox_PoweredOnHostCount = New-Object 'System.Windows.Forms.TextBox'
$labelPoweredOnHostCount = New-Object 'System.Windows.Forms.Label'
$textbox_ConnectedHostCount = New-Object 'System.Windows.Forms.TextBox'
$labelConnectedHostCount = New-Object 'System.Windows.Forms.Label'
$textbox_TotalHostCount = New-Object 'System.Windows.Forms.TextBox'
$labelTotalHostCount = New-Object 'System.Windows.Forms.Label'
$labelAdmissionControlIsAP = New-Object 'System.Windows.Forms.Label'
$tabpage2_OtherTab = New-Object 'System.Windows.Forms.TabPage'
$button_ShowClusterInfo = New-Object 'System.Windows.Forms.Button'
$picturebox_HAEnabled = New-Object 'System.Windows.Forms.PictureBox'
$textbox_HAEnabled = New-Object 'System.Windows.Forms.TextBox'
$labelHAEnabled = New-Object 'System.Windows.Forms.Label'
$labelSelectCluster = New-Object 'System.Windows.Forms.Label'
$combobox_ClusterList = New-Object 'System.Windows.Forms.ComboBox'
$groupbox1 = New-Object 'System.Windows.Forms.GroupBox'
$buttonLogOut = New-Object 'System.Windows.Forms.Button'
$buttonLogIn = New-Object 'System.Windows.Forms.Button'
$labelServer = New-Object 'System.Windows.Forms.Label'
$textboxServer = New-Object 'System.Windows.Forms.TextBox'
$maskedtextboxPassword = New-Object 'System.Windows.Forms.MaskedTextBox'
$labelPassword = New-Object 'System.Windows.Forms.Label'
$labelUser = New-Object 'System.Windows.Forms.Label'
$textboxUser = New-Object 'System.Windows.Forms.TextBox'
$toolstripprogressbar_HAAdmission = New-Object 'System.Windows.Forms.ToolStripProgressBar'
$toolstripstatuslabel_Error = New-Object 'System.Windows.Forms.ToolStripStatusLabel'
$toolstripstatuslabel_ReportPath = New-Object 'System.Windows.Forms.ToolStripStatusLabel'
$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'

$global:greenTickImageString = @"
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAAXNSR0IArs4c6QAAAARnQU1BAACx
jwv8YQUAAAAJcEhZcwAAEN4AABDeAaYSvNQAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5v
cmeb7jwaAAABZElEQVRIS82UsUrEQBCGP0HQF7C5NzgtLbS2slfBE0sfQC6+i5Y+xWEmB1fbmk6F
3EucKTyI7K7hks1sLkmjP3wQ2Nl/NjOzC/9CCWOECQn3Fvc99sP6acYewhThHaEIYNamNraXYk4Q
MsUwREbCqW+jK+ECIVdMtpETc+nb1RVzjLBSNnclD/+Jq3mfsoTI9J64hvrBQ4l8e5OgbVo0TCnv
rFlz7aNuPudQCWpjRcyZ3btgF+GrEfPC0SZBzHUjwLFG+A6aF+wgPCn7ChJuNgn0+q9/b/AIIQ2Y
Pyr7Sip90BOYk4/s+owDhNce5uYPHqoJJo0AR2rNS9Ou5i5BpUTtTX6rJelibqg12ah9TFPmnCM8
K2sa3pi6BNo8D0W5aAv2EZZKcF8y66XKPXbNS9OdlseulHlyhz7XwpVvp8ucol+5lttP7sv1JCLm
UzF0uLUoXPOuMjMt3NrbaTDfjTn/I/0AJndNJeQmW58AAAAASUVORK5CYII=
"@

$global:redCrossImageString = @"
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAAXNSR0IArs4c6QAAAARnQU1BAACx
jwv8YQUAAAAJcEhZcwAAA4sAAAOLAXXLF/sAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5v
cmeb7jwaAAACVklEQVRIS62WTWsTQRjHR09aP4CQqsxmJ9GT7WzciVWQ+vIRfKEV1EsvXlppfCm+
FIVWbSwoePQjeNGbXvSsUfFgdlsSitbsRTO5WAQPOzITd5I8s5tswD/8DwnJ7z/z7DzPLEIp9HMi
P9pyc8e4S8574/alNZo9+aWQ3Qd/N5SCQmakWbRLnJEKZyTkjAhpj+LIYZVanzyKb1QKmRH4/75q
uuQsZ+R7BO12V4C2T3FjnWanIMeQQGg7L5L7EDooINqR71hlyYBcrUHwAQHt3ThWGXKV/pVF1zrJ
EBjj0CjX5sSenZyRTQjjRw6I38+eil8354yA2uyM2FhdEt4hM9SnOPh8cPeuzurbp8WA/3n7WiiF
odhavacD6gtzImg0RBAE4uvL58JjeSNEni4dwF3yAQbIlfdIhpTvivrtkoZHVjuBAY71UcF/HN2f
iau9LIuEwhAIl59r85fNAIrDtbH8KGoV7eMQHnlr+ZYRAuH1O1chWHudZk8hznLTENwvJC1cedy+
KAOmIDR1wGL/gCq1LqDWYTIJoUnwnoAUIXIo/p+HPDtjwNXooHsz7T5g5D0MGOqYPlmBcOFRq9Jp
NNeehwGq0d686sAfJTTai/hGq1J8XQdsTOIdnJFvcSFqVCyW9HcRQI2Kxw/TjQq1C0bOxD0LaAiL
cVgbs8/1wCNxlyxDIHQMsMd+AT+AXC114TCy1G8nENi9ct+xVgRC2yDXULNITseO7+SARmJZkiTv
iCYjV1os9y7p0pcT03fwtaEvfSjZjOq1heWm5WuL79gn1KRMob+Ge0pQVtxgGwAAAABJRU5ErkJg
gg==
"@

function Set-Picture
{
    param
    (
        [parameter(Mandatory = $true)]
        [string]$ImageResult,
        [parameter(Mandatory = $true)]
        [System.Windows.Forms.PictureBox]$PictureBox
    )
    if ($ImageResult -eq 'true')
    {
        $System_IO_MemoryStream = [System.IO.MemoryStream][System.Convert]::FromBase64String($greenTickImageString)
    }
    else
    {
        $System_IO_MemoryStream = [System.IO.MemoryStream][System.Convert]::FromBase64String($redCrossImageString)
    }
    $PictureBox.Image = [System.Drawing.Image]::FromStream($System_IO_MemoryStream)
    $System_IO_MemoryStream = $null
}

$formHAAdmission_Load = {
    Set-Picture -ImageResult 'false' -PictureBox $picturebox_HAEnabled
}

$buttonLogIn_Click = {
    $labelOverallResult.Text = "Cluster Status"
    $labelOverallResult.BackColor = 'Gray'
    $labelOverallResult.ForeColor = 'Black'
    
    $textbox_HAEnabled.Text = 'N/A'
    Set-Picture -ImageResult 'false' -PictureBox $picturebox_HAEnabled
    #region Login Information
    $toolstripprogressbar_HAAdmission.Value = Get-Random -Minimum 0 -Maximum 100
    $toolstripstatuslabel_Error.Text = $null
    $combobox_ClusterList.Items.Clear()
    
    try
    {
        Connect-VIServer -Server $textboxServer.Text -User $textboxUser.Text -Password $maskedtextboxPassword.Text -ErrorAction Stop | Out-Null
        $toolstripstatuslabel_Error.Text = "Login successful on vCenter Servers!"
        
        $global:clusterInfo = Get-Cluster -ErrorAction Stop #| Where-Object {$_.Name -eq 'SomeName'}
        $toolstripprogressbar_HAAdmission.Value = Get-Random -Minimum 0 -Maximum 100
        $global:completeClusterInfo = @()
        foreach ($cluster in $global:clusterInfo)
        {
            $esxis = $cluster | Get-VMHost
            $totalESXis = $esxis.Count
            $connectedESxis = $esxis | Where-Object { $_.ConnectionState -eq 'Connected' }
            $poweredOnESXis = $esxis | Where-Object { $_.PowerState -eq 'PoweredOn' }
            $allClusterInfo = $cluster | Select-Object Name,
                                                        @{ Name = 'Total_Esxi_Count'; Expression = { $totalESXis } }, HAEnabled, HAAdmissionControlEnabled, #HAFailoverLevel
                                                        @{ Name = 'Connected_Esxi_Count'; Expression = { $connectedESxis.Count } },
                                                        @{ Name = 'PoweredOn_Esxi_Count'; Expression = { $poweredOnESXis.Count } },
                                                        @{ Name = 'Host_Failures_Cluster_Tolerates'; Expression = { $_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.FailOverLevel } },
                                                        @{
                                                            Name	   = 'Define_Host_Failover_Capacity_By';
                                                            Expression = {
                                                                switch ($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.GetType().Name)
                                                                {
                                                                    'ClusterFailoverResourcesAdmissionControlPolicy' { 'Cluster Resource Percentage (R)'; break }
                                                                    'ClusterFailoverHostAdmissionControlPolicy' { 'Dedicated Failover Host (H)'; break }
                                                                    'ClusterFailoverLevelAdmissionControlPolicy' { 'Soft Policy / Disabled (s)'; break }
                                                                } #switch ($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.GetType().Name)
                                                            } #Expression = {
                                                        }, #@{Name='Define_Host_Failover_Capacity_By';
                                                        @{ Name = 'Override_calculated_failover_capacity'; Expression = { -not ($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.AutoComputePercentages) } },
                                                        @{ Name = 'Reserved_failover_CPU_capacity'; Expression = { $_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.CpuFailoverResourcesPercent } },
                                                        @{ Name = 'Reserved_failover_Memory_capacity'; Expression = { $_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.MemoryFailoverResourcesPercent } },
                                                        @{ Name = 'Reserve_Persistent_Memory_failover_capacity'; Expression = { $_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.PMemAdmissionControlEnabled } },
                                                        @{ Name = 'Override_calculated_Persistent_Memory_failover_capacity'; Expression = { -not ($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.AutoComputePMemFailoverResourcesPercent) } },
                                                        @{ Name = 'Reserve_Percentage_of_Persistent_Memory_capacity'; Expression = { $_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.PMemFailoverResourcesPercent } },
                                                        @{ Name = 'Performance_degradation_VMs_tolerate'; Expression = { $_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.ResourceReductionToToleratePercent } },
                                                        @{ Name = 'ESXi_Names'; Expression = { $esxis.Name -Join ',' } }
            $toolstripprogressbar_HAAdmission.Value = Get-Random -Minimum 0 -Maximum 100
            $combobox_ClusterList.Items.Add($allClusterInfo.Name)
            $global:completeClusterInfo += $allClusterInfo
            $toolstripprogressbar_HAAdmission.Value = Get-Random -Minimum 0 -Maximum 100
        } #foreach ($cluster in $clusterInfo)
        $combobox_ClusterList.SelectedItem = $allClusterInfo.Name
        $selectedCluster = $global:completeClusterInfo | Where-Object { $_.Name -eq $allClusterInfo.Name }
        $textbox_HAEnabled.Text = $selectedCluster.HAEnabled
        Set-Picture -ImageResult $selectedCluster.HAEnabled -PictureBox $picturebox_HAEnabled
        $completeClusterInfo | Export-Csv -NoTypeInformation -Path "$($env:TEMP)\re.csv"
        $toolstripstatuslabel_ReportPath.Text = "$($env:TEMP)\re.csv"
        $buttonLogOut.Enabled = $true
        $combobox_ClusterList.Enabled = $true
        $button_ShowClusterInfo.Enabled = $true
    }
    catch
    {
        $toolstripstatuslabel_Error.Text = $error[0].exception.message
    }
    $toolstripprogressbar_HAAdmission.Value = 100
    #endregion Login Information
}

$buttonLogOut_Click = {
    $labelOverallResult.Text = "Cluster Status"
    $labelOverallResult.BackColor = 'Gray'
    $labelOverallResult.ForeColor = 'Black'
    #region Logoff Information	
    $toolstripprogressbar_HAAdmission.Value = Get-Random -Minimum 0 -Maximum 100
    try
    {
        Disconnect-VIserver * -Force -Confirm:$false -ErrorAction Stop
        $toolstripstatuslabel_Error.Text = "Disconnected from all vCenter Servers!"
    }
    catch
    {
        $toolstripstatuslabel_Error.Text = $error[0].exception.message
    }
    $toolstripprogressbar_HAAdmission.Value = 100
    #endregion Logoff Information
    
    $red_Cross_System_IO_MemoryStream = [System.IO.MemoryStream][System.Convert]::FromBase64String($redCrossImageString)
    $picturebox_HAEnabled.Image = [System.Drawing.Image]::FromStream($red_Cross_System_IO_MemoryStream)
    $red_Cross_System_IO_MemoryStream = $null
    
    $button_ShowClusterInfo.Enabled = $false
    $textbox_HAEnabled.Text = 'N/A'
    $groupbox_SelectedCluster.Visible = $false
    $buttonLogOut.Enabled = $false
    $combobox_ClusterList.Enabled = $false
}
#endregion

$button_ShowClusterInfo_Click = {
    $toolstripprogressbar_HAAdmission.Value = Get-Random -Minimum 0 -Maximum 100
    $groupbox_SelectedCluster.Text = $combobox_ClusterList.SelectedItem
    $selectedCluster = $global:completeClusterInfo | Where-Object { $_.Name -eq $combobox_ClusterList.SelectedItem }
    $esxiHosts = $global:clusterInfo | Where-Object { $_.Name -eq $selectedCluster.Name } | Get-VMHost
    
    $textbox_HAEnabled.Text = $selectedCluster.HAEnabled
    Set-Picture -ImageResult $selectedCluster.HAEnabled -PictureBox $picturebox_HAEnabled
    $textbox_TotalHostCount.Text = $selectedCluster.Total_Esxi_Count
    $textbox_ConnectedHostCount.Text = $selectedCluster.Connected_Esxi_Count
    $textbox_PoweredOnHostCount.Text = $selectedCluster.PoweredOn_Esxi_Count
    $textbox_AdmissionControlEnabled.Text = $selectedCluster.HAAdmissionControlEnabled
    Set-Picture -ImageResult $selectedCluster.HAAdmissionControlEnabled -PictureBox $picturebox_AdmissionControlEnabled
    $textbox_HostFailuresClusterTolerates.Text = $selectedCluster.Host_Failures_Cluster_Tolerates
    if ($esxiHosts.Count -lt 3)
    {
        $hostfailure = 'False'
        Set-Picture -ImageResult 'False' -PictureBox $picturebox_HostFailureClusterTolerates
    }
    elseif (($esxiHosts.Count -le 12) -and ($selectedCluster.Host_Failures_Cluster_Tolerates -eq 1))
    {
        $hostfailure = '1'
        Set-Picture -ImageResult 'True' -PictureBox $picturebox_HostFailureClusterTolerates
    }
    elseif (($esxiHosts.Count -gt 12) -and ($selectedCluster.Host_Failures_Cluster_Tolerates -eq 2))
    {
        $hostfailure = '2'
        Set-Picture -ImageResult 'True' -PictureBox $picturebox_HostFailureClusterTolerates
    }
    else
    {
        $hostfailure = 'False'
        Set-Picture -ImageResult 'False' -PictureBox $picturebox_HostFailureClusterTolerates
    }
    $textbox_DefineHostFailoverCapacityBy.Text = $selectedCluster.Define_Host_Failover_Capacity_By
    if ($selectedCluster.Define_Host_Failover_Capacity_By -eq 'Cluster Resource Percentage (R)')
    {
        Set-Picture -ImageResult 'True' -PictureBox $picturebox_DefineHostFailoverCaparityBy
    }
    else
    {
        Set-Picture -ImageResult 'False' -PictureBox $picturebox_DefineHostFailoverCaparityBy
    }
    
    $textbox_OverRideCalculatedFailoverCapacity.Text = $selectedCluster.Override_calculated_failover_capacity
    if ($selectedCluster.Override_calculated_failover_capacity -match 'False')
    {
        Set-Picture -ImageResult 'True' -PictureBox $picturebox_OverRideCalculatedFailoverCapacity
    }
    else
    {
        Set-Picture -ImageResult 'False' -PictureBox $picturebox_OverRideCalculatedFailoverCapacity
    }
    $textbox_ReservedFailoverCPUCapacity.Text = $selectedCluster.Reserved_failover_CPU_capacity
    $textbox_ReservedFailoverMemoryCapacity.Text = $selectedCluster.Reserved_failover_Memory_capacity
    $textbox_DefineHostFailoverCapacityBy.Text = $selectedCluster.Define_Host_Failover_Capacity_By
    $textbox_ReservePersistentMemoryFailoverCapacity.Text = $selectedCluster.Reserve_Persistent_Memory_failover_capacity
    if ($selectedCluster.Reserve_Persistent_Memory_failover_capacity -match 'False')
    {
        Set-Picture -ImageResult 'True' -PictureBox $picturebox_ReservePersistentMemoryFailoverCapacity
    }
    else
    {
        Set-Picture -ImageResult 'False' -PictureBox $picturebox_ReservePersistentMemoryFailoverCapacity
    }
    $textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity.Text = $selectedCluster.Override_calculated_Persistent_Memory_failover_capacity
    $textbox_ReservePercentOfPersistentMemoryCap.Text = $selectedCluster.Reserve_Percentage_of_Persistent_Memory_capacity
    $textbox_PerformanceDegration.Text = $selectedCluster.Performance_degradation_VMs_tolerate
    if ($selectedCluster.Performance_degradation_VMs_tolerate -eq 100)
    {
        Set-Picture -ImageResult 'True' -PictureBox $picturebox_PerformaceDegradationVMsTolerate
    }
    else
    {
        Set-Picture -ImageResult 'False' -PictureBox $picturebox_PerformaceDegradationVMsTolerate
    }
    
    $groupbox_SelectedCluster.Visible = $true
    $toolstripprogressbar_HAAdmission.Value = 100
    
    $complianceRules = @(
        @{ Name = 'HAEnabled'; Value = 'True' },
        @{ Name = 'HAAdmissionControlEnabled'; Value = 'True' },
        @{ Name = 'Define_Host_Failover_Capacity_By'; Value = 'Cluster Resource Percentage (R)' },
        @{ Name = 'Override_calculated_failover_capacity'; Value = 'False' },
        @{ Name = 'Reserve_Persistent_Memory_failover_capacity'; Value = 'False' },
        @{ Name = 'Performance_degradation_VMs_tolerate'; Value = '100' }
    )
    
    $complianceCount = 0
    
    foreach ($rule in $complianceRules)
    {
        $clusterValue = $selectedCluster.($rule.Name)
        if ($clusterValue -eq $($rule.Value))
        {
            $complianceCount++
        }
        Write-Host $($clusterValue -eq $rule.Value)
    }
    
    if ($selectedCluster.Host_Failures_Cluster_Tolerates -in @(1, 2))
    {
        Write-Host $selectedCluster.Host_Failures_Cluster_Tolerates
        $complianceCount++
    }
    
    
    $totalChecks = $complianceRules.Count + 1
    
    if ($complianceCount -eq $totalChecks)
    {
        $labelOverallResult.Text = "Compliant ($complianceCount / $totalChecks)"
        $labelOverallResult.BackColor = 'DarkGreen'
        $labelOverallResult.ForeColor = 'White'
    }
    else
    {
        $labelOverallResult.Text = "Non-Compliant ($complianceCount / $totalChecks)"
        $labelOverallResult.BackColor = 'DarkRed'
        $labelOverallResult.ForeColor = 'White'
    }
    
}

$Form_StateCorrection_Load=
{
    $formHAAdmission.WindowState = $InitialFormWindowState
}

$Form_Cleanup_FormClosed=
{
    try
    {
        $button_ShowClusterInfo.remove_Click($button_ShowClusterInfo_Click)
        $buttonLogOut.remove_Click($buttonLogOut_Click)
        $buttonLogIn.remove_Click($buttonLogIn_Click)
        $formHAAdmission.remove_Load($formHAAdmission_Load)
        $formHAAdmission.remove_Load($Form_StateCorrection_Load)
        $formHAAdmission.remove_FormClosed($Form_Cleanup_FormClosed)
    }
    catch { Out-Null }
    $formHAAdmission.Dispose()
    $labelOverallResult.Dispose()
    $statusstrip1.Dispose()
    $tabcontrol1.Dispose()
    $tabpage1_AdmissionControl.Dispose()
    $groupbox_SelectedCluster.Dispose()
    $groupbox_DefineHostFailoverCapacityBy.Dispose()
    $picturebox_PerformaceDegradationVMsTolerate.Dispose()
    $label_Percent.Dispose()
    $textbox_PerformanceDegration.Dispose()
    $labelPercentageOfPerforma.Dispose()
    $labelPerformanceDegradationVMsTolerate.Dispose()
    $labelOfPersistentMemoryCapacity.Dispose()
    $textbox_ReservePercentOfPersistentMemoryCap.Dispose()
    $labelReserve.Dispose()
    $labelSomeAmountOfPersiste.Dispose()
    $textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity.Dispose()
    $labelOverrideCalculatedPersistantMemory.Dispose()
    $picturebox_ReservePersistentMemoryFailoverCapacity.Dispose()
    $textbox_ReservePersistentMemoryFailoverCapacity.Dispose()
    $labelReservePersistentMem.Dispose()
    $labelPercentMemory.Dispose()
    $textbox_ReservedFailoverMemoryCapacity.Dispose()
    $labelReservedFailoverMemoryCapacity.Dispose()
    $labelPercentCPU.Dispose()
    $textbox_ReservedFailoverCPUCapacity.Dispose()
    $labelReservedFailoverCPUCap.Dispose()
    $textbox_OverRideCalculatedFailoverCapacity.Dispose()
    $picturebox_OverRideCalculatedFailoverCapacity.Dispose()
    $labelOverrideCalculatedFa.Dispose()
    $picturebox_HostFailureClusterTolerates.Dispose()
    $textbox_DefineHostFailoverCapacityBy.Dispose()
    $picturebox_DefineHostFailoverCaparityBy.Dispose()
    $labelDefineHostFailoverBy.Dispose()
    $textbox_HostFailuresClusterTolerates.Dispose()
    $labelMaximumIsOneLessThan.Dispose()
    $labelHostFailuresClusterT.Dispose()
    $textbox_AdmissionControlEnabled.Dispose()
    $picturebox_AdmissionControlEnabled.Dispose()
    $labelAdmissionControlEnab.Dispose()
    $textbox_PoweredOnHostCount.Dispose()
    $labelPoweredOnHostCount.Dispose()
    $textbox_ConnectedHostCount.Dispose()
    $labelConnectedHostCount.Dispose()
    $textbox_TotalHostCount.Dispose()
    $labelTotalHostCount.Dispose()
    $labelAdmissionControlIsAP.Dispose()
    $tabpage2_OtherTab.Dispose()
    $button_ShowClusterInfo.Dispose()
    $picturebox_HAEnabled.Dispose()
    $textbox_HAEnabled.Dispose()
    $labelHAEnabled.Dispose()
    $labelSelectCluster.Dispose()
    $combobox_ClusterList.Dispose()
    $groupbox1.Dispose()
    $buttonLogOut.Dispose()
    $buttonLogIn.Dispose()
    $labelServer.Dispose()
    $textboxServer.Dispose()
    $maskedtextboxPassword.Dispose()
    $labelPassword.Dispose()
    $labelUser.Dispose()
    $textboxUser.Dispose()
    $toolstripprogressbar_HAAdmission.Dispose()
    $toolstripstatuslabel_Error.Dispose()
    $toolstripstatuslabel_ReportPath.Dispose()
}

$formHAAdmission.SuspendLayout()
$statusstrip1.SuspendLayout()
$tabcontrol1.SuspendLayout()
$tabpage1_AdmissionControl.SuspendLayout()
$groupbox_SelectedCluster.SuspendLayout()
$groupbox_DefineHostFailoverCapacityBy.SuspendLayout()
$picturebox_PerformaceDegradationVMsTolerate.BeginInit()
$picturebox_ReservePersistentMemoryFailoverCapacity.BeginInit()
$picturebox_OverRideCalculatedFailoverCapacity.BeginInit()
$picturebox_HostFailureClusterTolerates.BeginInit()
$picturebox_DefineHostFailoverCaparityBy.BeginInit()
$picturebox_AdmissionControlEnabled.BeginInit()
$picturebox_HAEnabled.BeginInit()
$groupbox1.SuspendLayout()

$formHAAdmission.Controls.Add($labelOverallResult)
$formHAAdmission.Controls.Add($statusstrip1)
$formHAAdmission.Controls.Add($tabcontrol1)
$formHAAdmission.Controls.Add($button_ShowClusterInfo)
$formHAAdmission.Controls.Add($picturebox_HAEnabled)
$formHAAdmission.Controls.Add($textbox_HAEnabled)
$formHAAdmission.Controls.Add($labelHAEnabled)
$formHAAdmission.Controls.Add($labelSelectCluster)
$formHAAdmission.Controls.Add($combobox_ClusterList)
$formHAAdmission.Controls.Add($groupbox1)
$formHAAdmission.AutoScaleDimensions = New-Object System.Drawing.SizeF(8, 17)
$formHAAdmission.AutoScaleMode = 'Font'
$formHAAdmission.ClientSize = New-Object System.Drawing.Size(882, 753)

$ImageString = @"
AAABAAEAICAAAAEAIACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAgBAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAELC45W
Dg6UsQ0NleEODpX3Dg6X/Q4Olv4ODpb/Dg6W/w4Olv8ODpb/Dg6W/w4Olv8ODpb/Dg6W/w4Olv8O
Dpb/Dg6W/g4Ol/0ODpb3DQ2V4Q4OlLILC49XAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAIkNDQ2UuQ8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8NDZS6AACJDQAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAQ0NlLkPD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8P
D5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8P
mv8NDZS5AAAAAQAAAAAAAAAAAAAAAAAAAAALC49XDw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/
Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8LC49XAAAAAAAAAAAAAAAAAAAAAA4OlLEPD5r/Dw+a/w8Pmv8P
D5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8P
mv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w4OlLEAAAAAAAAAAAAAAAAAAAAADQ2V
4Q8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8ODpn/HByf/yEhof8hIaH/
ISGh/yEhof8jI6L/IyOi/yMjov8VFZz/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/DQ2V4QAAAAAA
AAAAAAAAAAAAAAAODpb2Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/FRWc/7Ky
3v/+/v7///////////////////////////////////////X1+v9kZL3/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8ODpX3AAAAAAAAAAAAAAAAAAAAAA4Olv0PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/
Dw+a/w8Pmv9ra8D//////////////////////////////////////////////////////+Pj8/8O
Dpn/Dw+a/w8Pmv8PD5r/Dw+a/w4Ol/0AAAAAAAAAAAAAAAAAAAAADg6W/g8Pmv8PD5r/Dw+a/w8P
mv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/4WFy////////////////////////////////////////v7+
/////////////Pz+/xAQmv8PD5r/Dw+a/w8Pmv8PD5r/Dg6W/wAAAAAAAAAAAAAAAAAAAAAODpb/
Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/hobM////////////ra3c/xMTm/8S
Epv/EhKb/xISm/8lJaP////////////9/f7/ERGa/w8Pmv8PD5r/Dw+a/w8Pmv8ODpb/AAAAAAAA
AAAAAAAAAAAAAA4Olv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/xISm/9dXbr/e3vH/3l5xv+8vOP/////
///////Gxuf/cnLE/x4eoP8PD5r/Dw+a/yIiov////////////39/v8REZr/Dw+a/w8Pmv8PD5r/
Dw+a/w4Olv8AAAAAAAAAAAAAAAAAAAAADg6W/w8Pmv8PD5r/Dw+a/w8Pmv8ODpn/paXZ////////
///////////////////////////////+/v7/Tk60/w8Pmv8PD5r/IiKi/////////////f3+/xAQ
mv8PD5r/Dw+a/w8Pmv8PD5r/Dg6W/wAAAAAAAAAAAAAAAAAAAAAODpb/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv/5+fz//////////////////////////////////v7+/39/yf8PD5r/YmK8/ywspv8hIaH/
///////////8/P7/EBCa/w8Pmv8PD5r/Dw+a/w8Pmv8ODpb/AAAAAAAAAAAAAAAAAAAAAA4Olv8P
D5r/Dw+a/w8Pmv8PD5r/ERGb//7+/v///////////7294//T0+z///////7+/v98fMj/Dg6Z/46O
z///////goLK/x8fof////////////z8/v8QEJr/Dw+a/w8Pmv8PD5r/Dw+a/w4Olv8AAAAAAAAA
AAAAAAAAAAAADg6W/w8Pmv8PD5r/Dw+a/w8Pmv8REZr//v7+////////////HR2g/35+yP/+/v7/
fHzI/w8Pmv+Njc/////////////S0uz/v7/k/////////////Pz9/xAQmv8PD5r/Dw+a/w8Pmv8P
D5r/Dg6W/wAAAAAAAAAAAAAAAAAAAAAODpb/Dw+a/w8Pmv8PD5r/Dw+a/xERm//+/v7/////////
//8cHJ//HR2g/0xMs/8ODpn/kZHQ///////////////////////////////////////09Pr/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8ODpb/AAAAAAAAAAAAAAAAAAAAAA4Olv8PD5r/Dw+a/w8Pmv8PD5r/
ERGb//7+/v///////////xwcn/8PD5r/Dw+a/2Njvf//////////////////////////////////
/////////46Oz/8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w4Olv8AAAAAAAAAAAAAAAAAAAAADg6W/w8P
mv8PD5r/Dw+a/w8Pmv8REZv/////////////////HByf/w8Pmv8PD5r/LCym/29vwv/Kyun/////
//////+0tN//bm7C/25uwv9ISLL/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dg6W/wAAAAAAAAAA
AAAAAAAAAAAODpb/Dw+a/w8Pmv8PD5r/Dw+a/xERm/////////////////8oKKT/Ghqe/xkZnv8Z
GZ7/GRme/7i44f///////////4GByv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8P
mv8ODpb/AAAAAAAAAAAAAAAAAAAAAA4Olv4PD5r/Dw+a/w8Pmv8PD5r/EhKb////////////////
////////////////////////////////////////////gIDJ/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/
Dw+a/w8Pmv8PD5r/Dw+a/w4Olv8AAAAAAAAAAAAAAAAAAAAADg6W/Q8Pmv8PD5r/Dw+a/w8Pmv8P
D5r/6+v3//////////////////////////////////////////////////////9nZ7//Dw+a/w8P
mv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dg6X/QAAAAAAAAAAAAAAAAAAAAAODpb2Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv9ZWbn/7Oz3///////////////////////////////////////9/f7/
s7Pf/xQUnP8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8ODpX3AAAAAAAAAAAA
AAAAAAAAAA0NleEPD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8TE5v/ISGh/yEhof8hIaH/Hx+g/x4e
oP8dHaD/HByf/xcXnf8ODpn/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w0NleEAAAAAAAAAAAAAAAAAAAAADg6UsQ8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/
Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8P
D5r/Dw+a/w8Pmv8PD5r/Dg6VsQAAAAAAAAAAAAAAAAAAAAALC45WDw+a/w8Pmv8PD5r/Dw+a/w8P
mv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8LC49XAAAAAAAAAAAAAAAAAAAAAAAAAAENDZS5
Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8P
D5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/DQ2UuQAAAAEAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAiQ0NDZS5Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a
/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w8Pmv8PD5r/Dw+a/w0NlLkAAIkN
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAELC45WDg6UsQ0NleEODpb2Dg6W/Q4Olv4O
Dpb/Dg6W/w4Olv8ODpb/Dg6W/w4Olv8ODpb/Dg6W/w4Olv8ODpb/Dg6W/g4Olv0ODpb2DQ2V4Q4O
lLELC45WAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////
///////wAAAP4AAAB8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAAD
wAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA8AAAAPAAAADwAAAA+AAAAfw
AAAP//////////8=
"@
$System_IO_MemoryStream = [System.IO.MemoryStream][System.Convert]::FromBase64String($ImageString)

$formHAAdmission.Icon = [System.Drawing.Icon]::new($System_IO_MemoryStream)
$System_IO_MemoryStream = $null
$formHAAdmission.Name = 'formHAAdmission'
$formHAAdmission.Opacity = 0.95
$formHAAdmission.StartPosition = 'CenterScreen'
$formHAAdmission.Text = 'HA & Admission Control Settings'
$formHAAdmission.TopMost = $True
$formHAAdmission.add_Load($formHAAdmission_Load)

$labelOverallResult.AutoSize = $True
$labelOverallResult.Location = New-Object System.Drawing.Point(704, 701)
$labelOverallResult.Margin = '4, 0, 4, 0'
$labelOverallResult.Name = 'labelOverallResult'
$labelOverallResult.Size = New-Object System.Drawing.Size(97, 17)
$labelOverallResult.TabIndex = 17
$labelOverallResult.Text = 'Overall Result'

[void]$statusstrip1.Items.Add($toolstripprogressbar_HAAdmission)
[void]$statusstrip1.Items.Add($toolstripstatuslabel_ReportPath)
[void]$statusstrip1.Items.Add($toolstripstatuslabel_Error)
$statusstrip1.Location = New-Object System.Drawing.Point(0, 728)
$statusstrip1.Name = 'statusstrip1'
$statusstrip1.Padding = '1, 0, 19, 0'
$statusstrip1.Size = New-Object System.Drawing.Size(882, 25)
$statusstrip1.TabIndex = 16
$statusstrip1.Text = 'statusstrip1'

$tabcontrol1.Controls.Add($tabpage1_AdmissionControl)
$tabcontrol1.Controls.Add($tabpage2_OtherTab)
$tabcontrol1.Location = New-Object System.Drawing.Point(13, 143)
$tabcontrol1.Margin = '4, 4, 4, 4'
$tabcontrol1.Name = 'tabcontrol1'
$tabcontrol1.SelectedIndex = 0
$tabcontrol1.Size = New-Object System.Drawing.Size(856, 554)
$tabcontrol1.TabIndex = 15

$tabpage1_AdmissionControl.Controls.Add($groupbox_SelectedCluster)
$tabpage1_AdmissionControl.Location = New-Object System.Drawing.Point(4, 26)
$tabpage1_AdmissionControl.Margin = '4, 4, 4, 4'
$tabpage1_AdmissionControl.Name = 'tabpage1_AdmissionControl'
$tabpage1_AdmissionControl.Padding = '3, 3, 3, 3'
$tabpage1_AdmissionControl.Size = New-Object System.Drawing.Size(848, 524)
$tabpage1_AdmissionControl.TabIndex = 0
$tabpage1_AdmissionControl.Text = 'Admission Control'
$tabpage1_AdmissionControl.UseVisualStyleBackColor = $True

$groupbox_SelectedCluster.Controls.Add($groupbox_DefineHostFailoverCapacityBy)
$groupbox_SelectedCluster.Controls.Add($picturebox_HostFailureClusterTolerates)
$groupbox_SelectedCluster.Controls.Add($textbox_DefineHostFailoverCapacityBy)
$groupbox_SelectedCluster.Controls.Add($picturebox_DefineHostFailoverCaparityBy)
$groupbox_SelectedCluster.Controls.Add($labelDefineHostFailoverBy)
$groupbox_SelectedCluster.Controls.Add($textbox_HostFailuresClusterTolerates)
$groupbox_SelectedCluster.Controls.Add($labelMaximumIsOneLessThan)
$groupbox_SelectedCluster.Controls.Add($labelHostFailuresClusterT)
$groupbox_SelectedCluster.Controls.Add($textbox_AdmissionControlEnabled)
$groupbox_SelectedCluster.Controls.Add($picturebox_AdmissionControlEnabled)
$groupbox_SelectedCluster.Controls.Add($labelAdmissionControlEnab)
$groupbox_SelectedCluster.Controls.Add($textbox_PoweredOnHostCount)
$groupbox_SelectedCluster.Controls.Add($labelPoweredOnHostCount)
$groupbox_SelectedCluster.Controls.Add($textbox_ConnectedHostCount)
$groupbox_SelectedCluster.Controls.Add($labelConnectedHostCount)
$groupbox_SelectedCluster.Controls.Add($textbox_TotalHostCount)
$groupbox_SelectedCluster.Controls.Add($labelTotalHostCount)
$groupbox_SelectedCluster.Controls.Add($labelAdmissionControlIsAP)
$groupbox_SelectedCluster.Location = New-Object System.Drawing.Point(7, 7)
$groupbox_SelectedCluster.Margin = '4, 4, 4, 4'
$groupbox_SelectedCluster.Name = 'groupbox_SelectedCluster'
$groupbox_SelectedCluster.Padding = '4, 4, 4, 4'
$groupbox_SelectedCluster.Size = New-Object System.Drawing.Size(834, 510)
$groupbox_SelectedCluster.TabIndex = 4
$groupbox_SelectedCluster.TabStop = $False
$groupbox_SelectedCluster.Text = 'Selected Cluster:'
$groupbox_SelectedCluster.Visible = $False

$groupbox_DefineHostFailoverCapacityBy.Controls.Add($picturebox_PerformaceDegradationVMsTolerate)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($label_Percent)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($textbox_PerformanceDegration)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelPercentageOfPerforma)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelPerformanceDegradationVMsTolerate)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelOfPersistentMemoryCapacity)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($textbox_ReservePercentOfPersistentMemoryCap)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelReserve)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelSomeAmountOfPersiste)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelOverrideCalculatedPersistantMemory)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($picturebox_ReservePersistentMemoryFailoverCapacity)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($textbox_ReservePersistentMemoryFailoverCapacity)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelReservePersistentMem)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelPercentMemory)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($textbox_ReservedFailoverMemoryCapacity)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelReservedFailoverMemoryCapacity)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelPercentCPU)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($textbox_ReservedFailoverCPUCapacity)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelReservedFailoverCPUCap)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($textbox_OverRideCalculatedFailoverCapacity)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($picturebox_OverRideCalculatedFailoverCapacity)
$groupbox_DefineHostFailoverCapacityBy.Controls.Add($labelOverrideCalculatedFa)
$groupbox_DefineHostFailoverCapacityBy.Location = New-Object System.Drawing.Point(8, 183)
$groupbox_DefineHostFailoverCapacityBy.Margin = '4, 4, 4, 4'
$groupbox_DefineHostFailoverCapacityBy.Name = 'groupbox_DefineHostFailoverCapacityBy'
$groupbox_DefineHostFailoverCapacityBy.Padding = '4, 4, 4, 4'
$groupbox_DefineHostFailoverCapacityBy.Size = New-Object System.Drawing.Size(818, 319)
$groupbox_DefineHostFailoverCapacityBy.TabIndex = 42
$groupbox_DefineHostFailoverCapacityBy.TabStop = $False
$groupbox_DefineHostFailoverCapacityBy.Text = 'Define host failover capacity by:'

$picturebox_PerformaceDegradationVMsTolerate.Location = New-Object System.Drawing.Point(339, 281)
$picturebox_PerformaceDegradationVMsTolerate.Margin = '4, 4, 4, 4'
$picturebox_PerformaceDegradationVMsTolerate.Name = 'picturebox_PerformaceDegradationVMsTolerate'
$picturebox_PerformaceDegradationVMsTolerate.Size = New-Object System.Drawing.Size(27, 25)
$picturebox_PerformaceDegradationVMsTolerate.TabIndex = 16
$picturebox_PerformaceDegradationVMsTolerate.TabStop = $False

$label_Percent.AutoSize = $True
$label_Percent.Location = New-Object System.Drawing.Point(311, 284)
$label_Percent.Margin = '4, 0, 4, 0'
$label_Percent.Name = 'label_Percent'
$label_Percent.Size = New-Object System.Drawing.Size(20, 17)
$label_Percent.TabIndex = 64
$label_Percent.Text = '%'

$textbox_PerformanceDegration.Location = New-Object System.Drawing.Point(268, 281)
$textbox_PerformanceDegration.Margin = '4, 4, 4, 4'
$textbox_PerformanceDegration.Name = 'textbox_PerformanceDegration'
$textbox_PerformanceDegration.ReadOnly = $True
$textbox_PerformanceDegration.Size = New-Object System.Drawing.Size(35, 23)
$textbox_PerformanceDegration.TabIndex = 63
$textbox_PerformanceDegration.Text = '50'

$labelPercentageOfPerforma.ForeColor = [System.Drawing.SystemColors]::ControlDarkDark 
$labelPercentageOfPerforma.Location = New-Object System.Drawing.Point(8, 246)
$labelPercentageOfPerforma.Margin = '4, 0, 4, 0'
$labelPercentageOfPerforma.Name = 'labelPercentageOfPerforma'
$labelPercentageOfPerforma.Size = New-Object System.Drawing.Size(802, 38)
$labelPercentageOfPerforma.TabIndex = 62
$labelPercentageOfPerforma.Text = 'Percentage of performance degradation the VMs in the cluster are allowed to tolerate during a failure. 0% - Raises a warning if there is insufficient failover capacity to guarantee the same performance after VMs restart. 100% - Warning is disabled.'

$labelPerformanceDegradationVMsTolerate.AutoSize = $True
$labelPerformanceDegradationVMsTolerate.Location = New-Object System.Drawing.Point(8, 284)
$labelPerformanceDegradationVMsTolerate.Margin = '4, 0, 4, 0'
$labelPerformanceDegradationVMsTolerate.Name = 'labelPerformanceDegradationVMsTolerate'
$labelPerformanceDegradationVMsTolerate.Size = New-Object System.Drawing.Size(252, 17)
$labelPerformanceDegradationVMsTolerate.TabIndex = 60
$labelPerformanceDegradationVMsTolerate.Text = 'Performance degradation VMs tolerate'

$labelOfPersistentMemoryCapacity.AutoSize = $True
$labelOfPersistentMemoryCapacity.Location = New-Object System.Drawing.Point(212, 215)
$labelOfPersistentMemoryCapacity.Margin = '4, 0, 4, 0'
$labelOfPersistentMemoryCapacity.Name = 'labelOfPersistentMemoryCapacity'
$labelOfPersistentMemoryCapacity.Size = New-Object System.Drawing.Size(213, 17)
$labelOfPersistentMemoryCapacity.TabIndex = 59
$labelOfPersistentMemoryCapacity.Text = '% of Persistent Memory capacity'

$textbox_ReservePercentOfPersistentMemoryCap.Location = New-Object System.Drawing.Point(169, 212)
$textbox_ReservePercentOfPersistentMemoryCap.Margin = '4, 4, 4, 4'
$textbox_ReservePercentOfPersistentMemoryCap.Name = 'textbox_ReservePercentOfPersistentMemoryCap'
$textbox_ReservePercentOfPersistentMemoryCap.ReadOnly = $True
$textbox_ReservePercentOfPersistentMemoryCap.Size = New-Object System.Drawing.Size(35, 23)
$textbox_ReservePercentOfPersistentMemoryCap.TabIndex = 58
$textbox_ReservePercentOfPersistentMemoryCap.Text = '50'

$labelReserve.AutoSize = $True
$labelReserve.Location = New-Object System.Drawing.Point(100, 215)
$labelReserve.Margin = '4, 0, 4, 0'
$labelReserve.Name = 'labelReserve'
$labelReserve.Size = New-Object System.Drawing.Size(61, 17)
$labelReserve.TabIndex = 57
$labelReserve.Text = 'Reserve'

$labelSomeAmountOfPersiste.ForeColor = [System.Drawing.SystemColors]::ControlDarkDark 
$labelSomeAmountOfPersiste.Location = New-Object System.Drawing.Point(8, 122)
$labelSomeAmountOfPersiste.Margin = '4, 0, 4, 0'
$labelSomeAmountOfPersiste.Name = 'labelSomeAmountOfPersiste'
$labelSomeAmountOfPersiste.Size = New-Object System.Drawing.Size(802, 38)
$labelSomeAmountOfPersiste.TabIndex = 56
$labelSomeAmountOfPersiste.Text = 'Some amount of persistent memory capacity in the cluster would be dedicated for failover purpose even if the virtual machines in the cluster are not using persistent memory currently.'

$textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity.Location = New-Object System.Drawing.Point(470, 188)
$textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity.Margin = '4, 4, 4, 4'
$textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity.Name = 'textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity'
$textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity.ReadOnly = $True
$textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity.Size = New-Object System.Drawing.Size(65, 23)
$textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity.TabIndex = 55
$textbox_OverrideCalculatedPersistentMemoryFailoverMemoryFailoverCapacity.Text = 'False'

$labelOverrideCalculatedPersistantMemory.AutoSize = $True
$labelOverrideCalculatedPersistantMemory.Location = New-Object System.Drawing.Point(100, 191)
$labelOverrideCalculatedPersistantMemory.Margin = '4, 0, 4, 0'
$labelOverrideCalculatedPersistantMemory.Name = 'labelOverrideCalculatedPersistantMemory'
$labelOverrideCalculatedPersistantMemory.Size = New-Object System.Drawing.Size(362, 17)
$labelOverrideCalculatedPersistantMemory.TabIndex = 54
$labelOverrideCalculatedPersistantMemory.Text = 'Override calculated Persistent Memory failover capacity:'

$picturebox_ReservePersistentMemoryFailoverCapacity.Location = New-Object System.Drawing.Point(65, 164)
$picturebox_ReservePersistentMemoryFailoverCapacity.Margin = '4, 4, 4, 4'
$picturebox_ReservePersistentMemoryFailoverCapacity.Name = 'picturebox_ReservePersistentMemoryFailoverCapacity'
$picturebox_ReservePersistentMemoryFailoverCapacity.Size = New-Object System.Drawing.Size(27, 25)
$picturebox_ReservePersistentMemoryFailoverCapacity.TabIndex = 53
$picturebox_ReservePersistentMemoryFailoverCapacity.TabStop = $False

$textbox_ReservePersistentMemoryFailoverCapacity.Location = New-Object System.Drawing.Point(400, 164)
$textbox_ReservePersistentMemoryFailoverCapacity.Margin = '4, 4, 4, 4'
$textbox_ReservePersistentMemoryFailoverCapacity.Name = 'textbox_ReservePersistentMemoryFailoverCapacity'
$textbox_ReservePersistentMemoryFailoverCapacity.ReadOnly = $True
$textbox_ReservePersistentMemoryFailoverCapacity.Size = New-Object System.Drawing.Size(65, 23)
$textbox_ReservePersistentMemoryFailoverCapacity.TabIndex = 52
$textbox_ReservePersistentMemoryFailoverCapacity.Text = 'False'

$labelReservePersistentMem.AutoSize = $True
$labelReservePersistentMem.Location = New-Object System.Drawing.Point(100, 167)
$labelReservePersistentMem.Margin = '4, 0, 4, 0'
$labelReservePersistentMem.Name = 'labelReservePersistentMem'
$labelReservePersistentMem.Size = New-Object System.Drawing.Size(292, 17)
$labelReservePersistentMem.TabIndex = 51
$labelReservePersistentMem.Text = 'Reserve Persistent Memory failover capacity:'

$labelPercentMemory.AutoSize = $True
$labelPercentMemory.Location = New-Object System.Drawing.Point(386, 86)
$labelPercentMemory.Margin = '4, 0, 4, 0'
$labelPercentMemory.Name = 'labelPercentMemory'
$labelPercentMemory.Size = New-Object System.Drawing.Size(74, 17)
$labelPercentMemory.TabIndex = 50
$labelPercentMemory.Text = '% Memory'

$textbox_ReservedFailoverMemoryCapacity.Location = New-Object System.Drawing.Point(340, 83)
$textbox_ReservedFailoverMemoryCapacity.Margin = '4, 4, 4, 4'
$textbox_ReservedFailoverMemoryCapacity.Name = 'textbox_ReservedFailoverMemoryCapacity'
$textbox_ReservedFailoverMemoryCapacity.ReadOnly = $True
$textbox_ReservedFailoverMemoryCapacity.Size = New-Object System.Drawing.Size(35, 23)
$textbox_ReservedFailoverMemoryCapacity.TabIndex = 49
$textbox_ReservedFailoverMemoryCapacity.Text = '50'

$labelReservedFailoverMemoryCapacity.AutoSize = $True
$labelReservedFailoverMemoryCapacity.Location = New-Object System.Drawing.Point(99, 86)
$labelReservedFailoverMemoryCapacity.Margin = '4, 0, 4, 0'
$labelReservedFailoverMemoryCapacity.Name = 'labelReservedFailoverMemoryCapacity'
$labelReservedFailoverMemoryCapacity.Size = New-Object System.Drawing.Size(233, 17)
$labelReservedFailoverMemoryCapacity.TabIndex = 48
$labelReservedFailoverMemoryCapacity.Text = 'Reserved failover Memory capacity:'

$labelPercentCPU.AutoSize = $True
$labelPercentCPU.Location = New-Object System.Drawing.Point(358, 59)
$labelPercentCPU.Margin = '4, 0, 4, 0'
$labelPercentCPU.Name = 'labelPercentCPU'
$labelPercentCPU.Size = New-Object System.Drawing.Size(52, 17)
$labelPercentCPU.TabIndex = 47
$labelPercentCPU.Text = '% CPU'

$textbox_ReservedFailoverCPUCapacity.Location = New-Object System.Drawing.Point(315, 56)
$textbox_ReservedFailoverCPUCapacity.Margin = '4, 4, 4, 4'
$textbox_ReservedFailoverCPUCapacity.Name = 'textbox_ReservedFailoverCPUCapacity'
$textbox_ReservedFailoverCPUCapacity.ReadOnly = $True
$textbox_ReservedFailoverCPUCapacity.Size = New-Object System.Drawing.Size(35, 23)
$textbox_ReservedFailoverCPUCapacity.TabIndex = 46
$textbox_ReservedFailoverCPUCapacity.Text = '50'

$labelReservedFailoverCPUCap.AutoSize = $True
$labelReservedFailoverCPUCap.Location = New-Object System.Drawing.Point(99, 59)
$labelReservedFailoverCPUCap.Margin = '4, 0, 4, 0'
$labelReservedFailoverCPUCap.Name = 'labelReservedFailoverCPUCap'
$labelReservedFailoverCPUCap.Size = New-Object System.Drawing.Size(211, 17)
$labelReservedFailoverCPUCap.TabIndex = 45
$labelReservedFailoverCPUCap.Text = 'Reserved failover CPU capacity:'

$textbox_OverRideCalculatedFailoverCapacity.Location = New-Object System.Drawing.Point(348, 31)
$textbox_OverRideCalculatedFailoverCapacity.Margin = '4, 4, 4, 4'
$textbox_OverRideCalculatedFailoverCapacity.Name = 'textbox_OverRideCalculatedFailoverCapacity'
$textbox_OverRideCalculatedFailoverCapacity.ReadOnly = $True
$textbox_OverRideCalculatedFailoverCapacity.Size = New-Object System.Drawing.Size(65, 23)
$textbox_OverRideCalculatedFailoverCapacity.TabIndex = 44
$textbox_OverRideCalculatedFailoverCapacity.Text = 'False'

$picturebox_OverRideCalculatedFailoverCapacity.Location = New-Object System.Drawing.Point(64, 31)
$picturebox_OverRideCalculatedFailoverCapacity.Margin = '4, 4, 4, 4'
$picturebox_OverRideCalculatedFailoverCapacity.Name = 'picturebox_OverRideCalculatedFailoverCapacity'
$picturebox_OverRideCalculatedFailoverCapacity.Size = New-Object System.Drawing.Size(27, 25)
$picturebox_OverRideCalculatedFailoverCapacity.TabIndex = 43
$picturebox_OverRideCalculatedFailoverCapacity.TabStop = $False

$labelOverrideCalculatedFa.AutoSize = $True
$labelOverrideCalculatedFa.Location = New-Object System.Drawing.Point(99, 34)
$labelOverrideCalculatedFa.Margin = '4, 0, 4, 0'
$labelOverrideCalculatedFa.Name = 'labelOverrideCalculatedFa'
$labelOverrideCalculatedFa.Size = New-Object System.Drawing.Size(241, 17)
$labelOverrideCalculatedFa.TabIndex = 42
$labelOverrideCalculatedFa.Text = 'Override calculated failover capacity:'

$picturebox_HostFailureClusterTolerates.Location = New-Object System.Drawing.Point(270, 125)
$picturebox_HostFailureClusterTolerates.Margin = '4, 4, 4, 4'
$picturebox_HostFailureClusterTolerates.Name = 'picturebox_HostFailureClusterTolerates'
$picturebox_HostFailureClusterTolerates.Size = New-Object System.Drawing.Size(27, 25)
$picturebox_HostFailureClusterTolerates.TabIndex = 22
$picturebox_HostFailureClusterTolerates.TabStop = $False

$textbox_DefineHostFailoverCapacityBy.Location = New-Object System.Drawing.Point(249, 152)
$textbox_DefineHostFailoverCapacityBy.Margin = '4, 4, 4, 4'
$textbox_DefineHostFailoverCapacityBy.Name = 'textbox_DefineHostFailoverCapacityBy'
$textbox_DefineHostFailoverCapacityBy.ReadOnly = $True
$textbox_DefineHostFailoverCapacityBy.Size = New-Object System.Drawing.Size(292, 23)
$textbox_DefineHostFailoverCapacityBy.TabIndex = 21
$textbox_DefineHostFailoverCapacityBy.Text = 'False'

$picturebox_DefineHostFailoverCaparityBy.Location = New-Object System.Drawing.Point(552, 152)
$picturebox_DefineHostFailoverCaparityBy.Margin = '4, 4, 4, 4'
$picturebox_DefineHostFailoverCaparityBy.Name = 'picturebox_DefineHostFailoverCaparityBy'
$picturebox_DefineHostFailoverCaparityBy.Size = New-Object System.Drawing.Size(27, 25)
$picturebox_DefineHostFailoverCaparityBy.TabIndex = 20
$picturebox_DefineHostFailoverCaparityBy.TabStop = $False

$labelDefineHostFailoverBy.AutoSize = $True
$labelDefineHostFailoverBy.Location = New-Object System.Drawing.Point(8, 155)
$labelDefineHostFailoverBy.Margin = '4, 0, 4, 0'
$labelDefineHostFailoverBy.Name = 'labelDefineHostFailoverBy'
$labelDefineHostFailoverBy.Size = New-Object System.Drawing.Size(209, 17)
$labelDefineHostFailoverBy.TabIndex = 19
$labelDefineHostFailoverBy.Text = 'Define host failover capacity by:'

$textbox_HostFailuresClusterTolerates.Location = New-Object System.Drawing.Point(223, 125)
$textbox_HostFailuresClusterTolerates.Margin = '4, 4, 4, 4'
$textbox_HostFailuresClusterTolerates.Name = 'textbox_HostFailuresClusterTolerates'
$textbox_HostFailuresClusterTolerates.ReadOnly = $True
$textbox_HostFailuresClusterTolerates.Size = New-Object System.Drawing.Size(35, 23)
$textbox_HostFailuresClusterTolerates.TabIndex = 18
$textbox_HostFailuresClusterTolerates.Text = '0'

$labelMaximumIsOneLessThan.AutoSize = $True
$labelMaximumIsOneLessThan.ForeColor = [System.Drawing.SystemColors]::ControlDarkDark 
$labelMaximumIsOneLessThan.Location = New-Object System.Drawing.Point(305, 128)
$labelMaximumIsOneLessThan.Margin = '4, 0, 4, 0'
$labelMaximumIsOneLessThan.Name = 'labelMaximumIsOneLessThan'
$labelMaximumIsOneLessThan.Size = New-Object System.Drawing.Size(340, 17)
$labelMaximumIsOneLessThan.TabIndex = 17
$labelMaximumIsOneLessThan.Text = 'Maximum is one less than number of hosts in cluster.'

$labelHostFailuresClusterT.AutoSize = $True
$labelHostFailuresClusterT.Location = New-Object System.Drawing.Point(8, 128)
$labelHostFailuresClusterT.Margin = '4, 0, 4, 0'
$labelHostFailuresClusterT.Name = 'labelHostFailuresClusterT'
$labelHostFailuresClusterT.Size = New-Object System.Drawing.Size(207, 17)
$labelHostFailuresClusterT.TabIndex = 17
$labelHostFailuresClusterT.Text = 'Host Failures Cluster Tolerates:'

$textbox_AdmissionControlEnabled.Location = New-Object System.Drawing.Point(197, 94)
$textbox_AdmissionControlEnabled.Margin = '4, 4, 4, 4'
$textbox_AdmissionControlEnabled.Name = 'textbox_AdmissionControlEnabled'
$textbox_AdmissionControlEnabled.ReadOnly = $True
$textbox_AdmissionControlEnabled.Size = New-Object System.Drawing.Size(65, 23)
$textbox_AdmissionControlEnabled.TabIndex = 16
$textbox_AdmissionControlEnabled.Text = 'False'

$picturebox_AdmissionControlEnabled.Location = New-Object System.Drawing.Point(270, 94)
$picturebox_AdmissionControlEnabled.Margin = '4, 4, 4, 4'
$picturebox_AdmissionControlEnabled.Name = 'picturebox_AdmissionControlEnabled'
$picturebox_AdmissionControlEnabled.Size = New-Object System.Drawing.Size(27, 25)
$picturebox_AdmissionControlEnabled.TabIndex = 16
$picturebox_AdmissionControlEnabled.TabStop = $False

$labelAdmissionControlEnab.AutoSize = $True
$labelAdmissionControlEnab.Location = New-Object System.Drawing.Point(8, 97)
$labelAdmissionControlEnab.Margin = '4, 0, 4, 0'
$labelAdmissionControlEnab.Name = 'labelAdmissionControlEnab'
$labelAdmissionControlEnab.Size = New-Object System.Drawing.Size(181, 17)
$labelAdmissionControlEnab.TabIndex = 7
$labelAdmissionControlEnab.Text = 'Admission Control Enabled:'

$textbox_PoweredOnHostCount.Location = New-Object System.Drawing.Point(544, 61)
$textbox_PoweredOnHostCount.Margin = '4, 4, 4, 4'
$textbox_PoweredOnHostCount.Name = 'textbox_PoweredOnHostCount'
$textbox_PoweredOnHostCount.ReadOnly = $True
$textbox_PoweredOnHostCount.Size = New-Object System.Drawing.Size(35, 23)
$textbox_PoweredOnHostCount.TabIndex = 6
$textbox_PoweredOnHostCount.Text = '0'

$labelPoweredOnHostCount.AutoSize = $True
$labelPoweredOnHostCount.Location = New-Object System.Drawing.Point(376, 64)
$labelPoweredOnHostCount.Margin = '4, 0, 4, 0'
$labelPoweredOnHostCount.Name = 'labelPoweredOnHostCount'
$labelPoweredOnHostCount.Size = New-Object System.Drawing.Size(160, 17)
$labelPoweredOnHostCount.TabIndex = 5
$labelPoweredOnHostCount.Text = 'PoweredOn Host Count:'

$textbox_ConnectedHostCount.Location = New-Object System.Drawing.Point(333, 61)
$textbox_ConnectedHostCount.Margin = '4, 4, 4, 4'
$textbox_ConnectedHostCount.Name = 'textbox_ConnectedHostCount'
$textbox_ConnectedHostCount.ReadOnly = $True
$textbox_ConnectedHostCount.Size = New-Object System.Drawing.Size(35, 23)
$textbox_ConnectedHostCount.TabIndex = 4
$textbox_ConnectedHostCount.Text = '0'

$labelConnectedHostCount.AutoSize = $True
$labelConnectedHostCount.Location = New-Object System.Drawing.Point(177, 64)
$labelConnectedHostCount.Margin = '4, 0, 4, 0'
$labelConnectedHostCount.Name = 'labelConnectedHostCount'
$labelConnectedHostCount.Size = New-Object System.Drawing.Size(154, 17)
$labelConnectedHostCount.TabIndex = 3
$labelConnectedHostCount.Text = 'Connected Host Count:'

$textbox_TotalHostCount.Location = New-Object System.Drawing.Point(134, 61)
$textbox_TotalHostCount.Margin = '4, 4, 4, 4'
$textbox_TotalHostCount.Name = 'textbox_TotalHostCount'
$textbox_TotalHostCount.ReadOnly = $True
$textbox_TotalHostCount.Size = New-Object System.Drawing.Size(35, 23)
$textbox_TotalHostCount.TabIndex = 2
$textbox_TotalHostCount.Text = '0'

$labelTotalHostCount.AutoSize = $True
$labelTotalHostCount.Location = New-Object System.Drawing.Point(8, 64)
$labelTotalHostCount.Margin = '4, 0, 4, 0'
$labelTotalHostCount.Name = 'labelTotalHostCount'
$labelTotalHostCount.Size = New-Object System.Drawing.Size(118, 17)
$labelTotalHostCount.TabIndex = 1
$labelTotalHostCount.Text = 'Total Host Count:'

$labelAdmissionControlIsAP.ForeColor = [System.Drawing.SystemColors]::ControlDarkDark 
$labelAdmissionControlIsAP.Location = New-Object System.Drawing.Point(8, 20)
$labelAdmissionControlIsAP.Margin = '4, 0, 4, 0'
$labelAdmissionControlIsAP.Name = 'labelAdmissionControlIsAP'
$labelAdmissionControlIsAP.Size = New-Object System.Drawing.Size(826, 38)
$labelAdmissionControlIsAP.TabIndex = 0
$labelAdmissionControlIsAP.Text = 'Admission control is a policy used by vSphere HA to ensure failover capacity within a cluster. Raising the number of potential host failures will increase the availability constraints and capacity reserved.'

$tabpage2_OtherTab.Location = New-Object System.Drawing.Point(4, 26)
$tabpage2_OtherTab.Margin = '4, 4, 4, 4'
$tabpage2_OtherTab.Name = 'tabpage2_OtherTab'
$tabpage2_OtherTab.Padding = '3, 3, 3, 3'
$tabpage2_OtherTab.Size = New-Object System.Drawing.Size(848, 524)
$tabpage2_OtherTab.TabIndex = 1
$tabpage2_OtherTab.Text = 'Other Tab'
$tabpage2_OtherTab.UseVisualStyleBackColor = $True

$button_ShowClusterInfo.Enabled = $False
$button_ShowClusterInfo.Location = New-Object System.Drawing.Point(465, 108)
$button_ShowClusterInfo.Margin = '4, 4, 4, 4'
$button_ShowClusterInfo.Name = 'button_ShowClusterInfo'
$button_ShowClusterInfo.Size = New-Object System.Drawing.Size(204, 26)
$button_ShowClusterInfo.TabIndex = 14
$button_ShowClusterInfo.Text = 'Show Cluster Information'
$button_ShowClusterInfo.UseVisualStyleBackColor = $True
$button_ShowClusterInfo.add_Click($button_ShowClusterInfo_Click)

$picturebox_HAEnabled.Location = New-Object System.Drawing.Point(842, 110)
$picturebox_HAEnabled.Margin = '4, 4, 4, 4'
$picturebox_HAEnabled.Name = 'picturebox_HAEnabled'
$picturebox_HAEnabled.Size = New-Object System.Drawing.Size(27, 25)
$picturebox_HAEnabled.TabIndex = 12
$picturebox_HAEnabled.TabStop = $False

$textbox_HAEnabled.Location = New-Object System.Drawing.Point(771, 110)
$textbox_HAEnabled.Margin = '4, 4, 4, 4'
$textbox_HAEnabled.Name = 'textbox_HAEnabled'
$textbox_HAEnabled.ReadOnly = $True
$textbox_HAEnabled.Size = New-Object System.Drawing.Size(63, 23)
$textbox_HAEnabled.TabIndex = 11
$textbox_HAEnabled.Text = 'N/A'

$labelHAEnabled.AutoSize = $True
$labelHAEnabled.Location = New-Object System.Drawing.Point(676, 113)
$labelHAEnabled.Margin = '4, 0, 4, 0'
$labelHAEnabled.Name = 'labelHAEnabled'
$labelHAEnabled.Size = New-Object System.Drawing.Size(87, 17)
$labelHAEnabled.TabIndex = 10
$labelHAEnabled.Text = 'HA Enabled:'

$labelSelectCluster.AutoSize = $True
$labelSelectCluster.Location = New-Object System.Drawing.Point(13, 113)
$labelSelectCluster.Margin = '4, 0, 4, 0'
$labelSelectCluster.Name = 'labelSelectCluster'
$labelSelectCluster.Size = New-Object System.Drawing.Size(99, 17)
$labelSelectCluster.TabIndex = 9
$labelSelectCluster.Text = 'Select Cluster:'

$combobox_ClusterList.FormattingEnabled = $True
$combobox_ClusterList.Location = New-Object System.Drawing.Point(120, 110)
$combobox_ClusterList.Margin = '4, 4, 4, 4'
$combobox_ClusterList.Name = 'combobox_ClusterList'
$combobox_ClusterList.Size = New-Object System.Drawing.Size(337, 25)
$combobox_ClusterList.TabIndex = 1

$groupbox1.Controls.Add($buttonLogOut)
$groupbox1.Controls.Add($buttonLogIn)
$groupbox1.Controls.Add($labelServer)
$groupbox1.Controls.Add($textboxServer)
$groupbox1.Controls.Add($maskedtextboxPassword)
$groupbox1.Controls.Add($labelPassword)
$groupbox1.Controls.Add($labelUser)
$groupbox1.Controls.Add($textboxUser)
$groupbox1.Location = New-Object System.Drawing.Point(13, 13)
$groupbox1.Margin = '4, 4, 4, 4'
$groupbox1.Name = 'groupbox1'
$groupbox1.Padding = '4, 4, 4, 4'
$groupbox1.Size = New-Object System.Drawing.Size(856, 89)
$groupbox1.TabIndex = 0
$groupbox1.TabStop = $False
$groupbox1.Text = 'Server Information and  Credentials'

$buttonLogOut.Enabled = $False
$buttonLogOut.Location = New-Object System.Drawing.Point(307, 49)
$buttonLogOut.Margin = '4, 4, 4, 4'
$buttonLogOut.Name = 'buttonLogOut'
$buttonLogOut.Size = New-Object System.Drawing.Size(100, 30)
$buttonLogOut.TabIndex = 8
$buttonLogOut.Text = 'Log Out'
$buttonLogOut.UseVisualStyleBackColor = $True
$buttonLogOut.add_Click($buttonLogOut_Click)

$buttonLogIn.Location = New-Object System.Drawing.Point(199, 49)
$buttonLogIn.Margin = '4, 4, 4, 4'
$buttonLogIn.Name = 'buttonLogIn'
$buttonLogIn.Size = New-Object System.Drawing.Size(100, 30)
$buttonLogIn.TabIndex = 7
$buttonLogIn.Text = 'Log In'
$buttonLogIn.UseVisualStyleBackColor = $True
$buttonLogIn.add_Click($buttonLogIn_Click)

$labelServer.AutoSize = $True
$labelServer.Location = New-Object System.Drawing.Point(8, 25)
$labelServer.Margin = '4, 0, 4, 0'
$labelServer.Name = 'labelServer'
$labelServer.Size = New-Object System.Drawing.Size(54, 17)
$labelServer.TabIndex = 6
$labelServer.Text = 'Server:'

$textboxServer.Location = New-Object System.Drawing.Point(70, 22)
$textboxServer.Margin = '4, 4, 4, 4'
$textboxServer.Name = 'textboxServer'
$textboxServer.Size = New-Object System.Drawing.Size(337, 23)
$textboxServer.TabIndex = 5
$textboxServer.Text = 'marvel.vcloud-lab.com'

$maskedtextboxPassword.Location = New-Object System.Drawing.Point(511, 53)
$maskedtextboxPassword.Margin = '4, 4, 4, 4'
$maskedtextboxPassword.Name = 'maskedtextboxPassword'
$maskedtextboxPassword.PasswordChar = '*'
$maskedtextboxPassword.Size = New-Object System.Drawing.Size(337, 23)
$maskedtextboxPassword.TabIndex = 4
$maskedtextboxPassword.Text = 'Computer@123'

$labelPassword.AutoSize = $True
$labelPassword.Location = New-Object System.Drawing.Point(421, 56)
$labelPassword.Margin = '4, 0, 4, 0'
$labelPassword.Name = 'labelPassword'
$labelPassword.Size = New-Object System.Drawing.Size(73, 17)
$labelPassword.TabIndex = 3
$labelPassword.Text = 'Password:'

$labelUser.AutoSize = $True
$labelUser.Location = New-Object System.Drawing.Point(421, 25)
$labelUser.Margin = '4, 0, 4, 0'
$labelUser.Name = 'labelUser'
$labelUser.Size = New-Object System.Drawing.Size(42, 17)
$labelUser.TabIndex = 1
$labelUser.Text = 'User:'

$textboxUser.Location = New-Object System.Drawing.Point(511, 22)
$textboxUser.Margin = '4, 4, 4, 4'
$textboxUser.Name = 'textboxUser'
$textboxUser.Size = New-Object System.Drawing.Size(337, 23)
$textboxUser.TabIndex = 0
$textboxUser.Text = 'administrator@vsphere.local'

$toolstripprogressbar_HAAdmission.Name = 'toolstripprogressbar_HAAdmission'
$toolstripprogressbar_HAAdmission.Size = New-Object System.Drawing.Size(100, 19)

$toolstripstatuslabel_Error.Name = 'toolstripstatuslabel_Error'
$toolstripstatuslabel_Error.Size = New-Object System.Drawing.Size(49, 20)
$toolstripstatuslabel_Error.Text = 'Result'

$toolstripstatuslabel_ReportPath.Name = 'toolstripstatuslabel_ReportPath'
$toolstripstatuslabel_ReportPath.Size = New-Object System.Drawing.Size(86, 20)
$toolstripstatuslabel_ReportPath.Text = 'Report Path'
$groupbox1.ResumeLayout()
$picturebox_HAEnabled.EndInit()
$picturebox_AdmissionControlEnabled.EndInit()
$picturebox_DefineHostFailoverCaparityBy.EndInit()
$picturebox_HostFailureClusterTolerates.EndInit()
$picturebox_OverRideCalculatedFailoverCapacity.EndInit()
$picturebox_ReservePersistentMemoryFailoverCapacity.EndInit()
$picturebox_PerformaceDegradationVMsTolerate.EndInit()
$groupbox_DefineHostFailoverCapacityBy.ResumeLayout()
$groupbox_SelectedCluster.ResumeLayout()
$tabpage1_AdmissionControl.ResumeLayout()
$tabcontrol1.ResumeLayout()
$statusstrip1.ResumeLayout()
$formHAAdmission.ResumeLayout()

$InitialFormWindowState = $formHAAdmission.WindowState

$formHAAdmission.add_Load($Form_StateCorrection_Load)
$formHAAdmission.add_FormClosed($Form_Cleanup_FormClosed)
$formHAAdmission.ShowDialog()