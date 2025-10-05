Import-Module VMware.VimAutomation.Core 
Connect-VIServer -Server marvel.vcloud-lab.com -User administrator@vsphere.local -Password Computer@123

$clusterInfo = Get-Cluster #| Where-Object {$_.Name -eq 'SomeName'}
$completeClusterInfo = @()
foreach ($cluster in $clusterInfo)
{
    $esxis = $cluster | Get-VMHost
    $totalESXis = $esxis.Count
    $connectedESxis = $esxis | Where-Object {$_.ConnectionState -eq 'Connected'}
    $poweredOnESXis = $esxis | Where-Object {$_.PowerState -eq 'PoweredOn'}
    $allClusterInfo = $cluster | Select-Object Name, 
        @{Name='Total_Esxi_Count'; Expression={$totalESXis}}, HAEnabled, HAAdmissionControlEnabled, #HAFailoverLevel
        @{Name='Connected_Esxi_Count'; Expression={$connectedESxis.Count}},
        @{Name='PoweredOn_Esxi_Count'; Expression={$poweredOnESXis.Count}},
        @{Name='Host_Failures_Cluster_Tolerates'; Expression={$_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.FailOverLevel}},

        @{Name='Define_Host_Failover_Capacity_By'; 
            Expression = {
                switch ($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.GetType().Name)
                {
                    'ClusterFailoverResourcesAdmissionControlPolicy' {'Cluster Resource Percentage (R)'; break}
                    'ClusterFailoverHostAdmissionControlPolicy' {'Dedicated Failover Host (H)'; break}
                    'ClusterFailoverLevelAdmissionControlPolicy' {'Soft Policy / Disabled (s)'; break}
                } #switch ($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.GetType().Name)
            } #Expression = {
        }, #@{Name='Define_Host_Failover_Capacity_By';
        @{Name='Override_calculated_failover_capacity'; Expression={-not($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.AutoComputePercentages)}},
        @{Name='Reserved_failover_CPU_capacity'; Expression={$_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.CpuFailoverResourcesPercent}},
        @{Name='Reserved_failover_Memory_capacity'; Expression={$_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.MemoryFailoverResourcesPercent}},
        @{Name='Reserve_Persistent_Memory_failover_capacity'; Expression={$_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.PMemAdmissionControlEnabled}},
        @{Name='Override_calculated_Persistent_Memory_failover_capacity'; Expression={-not($_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.AutoComputePMemFailoverResourcesPercent)}},
        @{Name='Reserve_Percentage_of_Persistent_Memory_capacity'; Expression={$_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.PMemFailoverResourcesPercent}},
        @{Name='Performance_degradation_VMs_tolerate'; Expression={$_.ExtensionData.Configuration.DasConfig.AdmissionControlPolicy.ResourceReductionToToleratePercent}},
        @{Name='ESXi_Names'; Expression={$esxis.Name -Join ','}}

        $completeClusterInfo += $allClusterInfo
} #foreach ($cluster in $clusterInfo)

$completeClusterInfo