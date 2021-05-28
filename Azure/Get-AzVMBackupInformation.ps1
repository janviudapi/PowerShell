[CmdletBinding(SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    HelpURI='http://vcloud-lab.com',
    DefaultParameterSetName = 'AllVirtualMachines'
)]

<#
    .SYNOPSIS
    Collect Azure VM Backup Information

    .DESCRIPTION
    This Script collects Azure Virtual Machine Backup Recovery service vault information, This report includes the complete backup status Information of VM.

    .PARAMETER AllVirtualMachines
    Collect Backup information of the all Azure Virtual Machines, This is default parameter.

    .PARAMETER VirtualMachineList
    You can specify for which virtual machine you want backup information.

    .INPUTS
    None. Provides virtual machine information.

    .OUTPUTS
    Generate Backup information. You can pipe information to Export-CSV.

    .EXAMPLE
    PS> .\Get-AzVMBackupInformation.ps1
    
    VM_Name                         : vcloud-lab-vm01
    VM_Location                     : uksouth
    VM_ResourceGroupName            : VCLOUD-LAB.COM
    VM_BackedUp                     : True
    VM_RecoveryVaultName            : vault828
    VM_RecoveryVaultPolicy          : DailyPolicy-kosrnox0
    VM_BackupHealthStatus           : Passed
    VM_BackupProtectionStatus       : Healthy
    VM_LastBackupStatus             : Completed
    VM_LastBackupTime               : 27-05-2021 19:32:34
    VM_BackupDeleteState            : NotDeleted
    VM_BackupLatestRecoveryPoint    : 27-05-2021 19:32:37
    VM_Id                           : /subscriptions/9e22xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/VCLOUD-LAB.COM/providers/Microsoft.Compute/virtualMachines/vcloud-lab-vm01
    RecoveryVault_ResourceGroupName : vCloud-lab.com
    RecoveryVault_Location          : uksouth
    RecoveryVault_SubscriptionId    : /subscriptions/9e22xxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/vCloud-lab.com/providers/Microsoft.RecoveryServices/vaults/vault828

    .EXAMPLE
    PS> .\Get-AzVMBackupInformation.ps1 -AllVirtualMachines
    This produces same result as .\Get-AzVMBackupInformation.ps1 from all VMs

    .EXAMPLE
    PS> .\Get-AzVMBackupInformation.ps1 -VirtualMachineList
    Provide either single virtual machine name or in list
    
    .LINK
    Online version: http://vcloud-lab.com

    .LINK
    Get-AzVMBackupInformation.ps1
#>
Param
( 
    [parameter(Position=0, ParameterSetName = 'AllVMs' )]
    [Switch]$AllVirtualMachines,
    [parameter(Position=0, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName = 'VM' )]
    [alias('Name')]
    [String[]]$VirtualMachineList
) #Param
Begin 
{
    #Collecing Azure virtual machines Information
    Write-Host "Collecing Azure virtual machine Information" -BackgroundColor DarkGreen
    if (($PSBoundParameters.ContainsKey('AllVirtualMachines')) -or ($PSBoundParameters.Count -eq 0))
    {
        $vms = Get-AzVM
    } #if ($PSBoundParameters.ContainsKey('AllVirtualMachines'))
    elseif ($PSBoundParameters.ContainsKey('VirtualMachineList'))
    {
        $vms = @()
        foreach ($vmname in $VirtualMachineList)
        {
            $vms += Get-AzVM -Name $vmname
            
        } #foreach ($vmname in $VirtualMachineList)
    } #elseif ($PSBoundParameters.ContainsKey('VirtualMachineList'))

    #Collecing All Azure backup recovery vaults Information
    Write-Host "Collecting all Backup Recovery Vault information" -BackgroundColor DarkGreen
    $backupVaults = Get-AzRecoveryServicesVault
} #Begin 
Process
{
    $vmBackupReport = [System.Collections.ArrayList]::new()
    foreach ($vm in $vms) 
    {
        $recoveryVaultInfo = Get-AzRecoveryServicesBackupStatus -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Type 'AzureVM'
        if ($recoveryVaultInfo.BackedUp -eq $true)
        {
            Write-Host "$($vm.Name) - BackedUp : Yes"
            #Backup Recovery Vault Information
            $vmBackupVault = $backupVaults | Where-Object {$_.ID -eq $recoveryVaultInfo.VaultId}

            #Backup recovery Vault policy Information
            $container = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM -VaultId $vmBackupVault.ID -FriendlyName $vm.Name #-Status "Registered" 
            $backupItem = Get-AzRecoveryServicesBackupItem -Container $container -WorkloadType AzureVM -VaultId $vmBackupVault.ID
        } #if ($recoveryVaultInfo.BackedUp -eq $true)
        else 
        {
            Write-Host "$($vm.Name) - BackedUp : No" -BackgroundColor DarkRed
            $vmBackupVault = $null
            $container =  $null
            $backupItem =  $null
        } #else if ($recoveryVaultInfo.BackedUp -eq $true)
        
        [void]$vmBackupReport.Add([PSCustomObject]@{
            VM_Name = $vm.Name
            VM_Location = $vm.Location
            VM_ResourceGroupName = $vm.ResourceGroupName
            VM_BackedUp = $recoveryVaultInfo.BackedUp
            VM_RecoveryVaultName =  $vmBackupVault.Name
            VM_RecoveryVaultPolicy = $backupItem.ProtectionPolicyName
            VM_BackupHealthStatus = $backupItem.HealthStatus
            VM_BackupProtectionStatus = $backupItem.ProtectionStatus
            VM_LastBackupStatus = $backupItem.LastBackupStatus
            VM_LastBackupTime = $backupItem.LastBackupTime
            VM_BackupDeleteState = $backupItem.DeleteState
            VM_BackupLatestRecoveryPoint = $backupItem.LatestRecoveryPoint
            VM_Id = $vm.Id
            RecoveryVault_ResourceGroupName = $vmBackupVault.ResourceGroupName
            RecoveryVault_Location = $vmBackupVault.Location
            RecoveryVault_SubscriptionId = $vmBackupVault.ID
        }) #[void]$vmBackupReport.Add([PSCustomObject]@{
    } #foreach ($vm in $vms) 
} #Process
end
{
    $vmBackupReport
} #end
