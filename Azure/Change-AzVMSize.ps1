<#
.SYNOPSIS
    Stops an Azure Virtual Machine, changes its size, and then starts it again.

.DESCRIPTION
    This script automates the process of resizing an Azure Virtual Machine.
    It first retrieves the specified VM, gracefully stops it (which is required
    for most VM size changes), updates its hardware profile with the new VM size,
    and then starts the VM back up.
    Error handling is included to provide informative messages if operations fail.

.PARAMETER VmName
    The name of the Azure Virtual Machine to be resized.

.PARAMETER ResourceGroupName
    The name of the Azure Resource Group where the Virtual Machine resides.

.PARAMETER NewVmSize
    The new Azure VM size (e.g., 'Standard_DS2_v2', 'Standard_D4s_v3').
    Ensure the new size is compatible with the existing VM configuration
    (e.g., supported disk types, available in the region).

.EXAMPLE
    # Resize a VM named 'MyWebAppVM' in 'ProductionRG' to 'Standard_D4s_v3'
    .\Resize-AzVM.ps1 -VmName "MyWebAppVM" -ResourceGroupName "ProductionRG" -NewVmSize "Standard_D4s_v3"

.EXAMPLE
    # Resize a VM and provide credentials if not already logged in (advanced)
    # Connect-AzAccount # Ensure you are logged into Azure
    # Get-AzSubscription | Out-GridView -PassThru | Select-AzSubscription # Select correct subscription
    # .\Resize-AzVM.ps1 -VmName "AppServer" -ResourceGroupName "DevServers" -NewVmSize "Standard_B2s"

.NOTES
    - Ensure you are logged into your Azure account via `Connect-AzAccount` before running this script.
    - Ensure you have selected the correct Azure subscription using `Select-AzSubscription` if you have multiple.
    - Not all VM sizes are available in all regions or compatible with all disk types.
      You can use `Get-AzVMSize -Location <YourAzureRegion>` to see available sizes.
    - Stopping the VM will incur downtime. Plan accordingly.
    - The original script had a commented-out line for tagging. You can uncomment and
      customize this line to automatically tag the VM after a size change if needed:
      `Get-AzResource -ResourceGroupName $ResourceGroupName -Name $VmName -ResourceType 'Microsoft.Compute/virtualMachines' | Set-AzResource -Tag @{ 'VMSizeChange' = 'True' } -Force`
    - Created by Janvi on 2024-10-01.
    - link: https://vcloud-lab.com
    - This script is provided as-is without warranty of any kind.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$VmName = 'test',

    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName = 'test',

    [Parameter(Mandatory=$true)]
    [string]$NewVmSize = 'Standard_DS1_v2' #'Standard_DS2_v2'
)

Write-Host "--- Azure VM Resizing Script ---" -ForegroundColor Cyan

# --- Step 1: Validate Azure Connection ---
try {
    if (-not (Get-Module -Name Az.Compute -ListAvailable)) {
        Write-Warning "Az.Compute module not found. Please install Azure PowerShell modules: Install-Module -Name Az -Scope CurrentUser"
    }
    $azContext = Get-AzContext -ErrorAction SilentlyContinue
    if (-not $azContext) {
        Write-Error "Not connected to Azure. Please run 'Connect-AzAccount' and 'Select-AzSubscription' if needed."
    }
    Write-Host "Connected to Azure subscription: $($azContext.Subscription.Name)" -ForegroundColor Green
}
catch {
    Write-Error "Azure connection check failed: $($_.Exception.Message)"
}

# --- Step 2: Get the Virtual Machine ---
Write-Host "Retrieving VM '$VmName' in Resource Group '$ResourceGroupName'..." -ForegroundColor Cyan
try {
    $vm = Get-AzVM -Name $VmName -ResourceGroupName $ResourceGroupName -ErrorAction Stop
    Write-Host "VM '$VmName' found. Current size: $($vm.HardwareProfile.VmSize)" -ForegroundColor Green
}
catch {
    Write-Error "Failed to retrieve VM '$VmName'. Error: $($_.Exception.Message)"
    Write-Error "Please ensure VM name and Resource Group are correct."
}

# --- Step 3: Stop the Virtual Machine ---
Write-Host "Stopping VM '$VmName'..." -ForegroundColor Yellow
try {
    $vm | Stop-AzVM -Force -ErrorAction Stop | Out-Null # -Force bypasses confirmation
    Write-Host "VM '$VmName' stopped successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to stop VM '$VmName'. Error: $($_.Exception.Message)"
}

# --- Step 4: Update VM Size ---
Write-Host "Attempting to change VM size from '$($vm.HardwareProfile.VmSize)' to '$NewVmSize'..." -ForegroundColor Cyan
try {
    $vm.HardwareProfile.VmSize = $NewVmSize
    $vm | Update-AzVM -ErrorAction Stop | Out-Null
    Write-Host "VM '$VmName' size update initiated successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to update VM size for '$VmName'. Error: $($_.Exception.Message)"
    Write-Error "Common reasons: Incompatible VM size, size not available in region, or resource locks."
}

# --- Step 5: Verify New VM Size (Optional, but good practice) ---
Write-Host "Verifying new VM size..." -ForegroundColor Cyan
try {
    # Re-retrieve VM object to get the latest properties
    $vm = Get-AzVM -Name $VmName -ResourceGroupName $ResourceGroupName -ErrorAction Stop
    Write-Host "VM '$VmName' new size: $($vm.HardwareProfile.VmSize)" -ForegroundColor Green
}
catch {
    Write-Warning "Could not re-retrieve VM properties to verify size. Error: $($_.Exception.Message)"
}

# --- Step 6: Start the Virtual Machine ---
Write-Host "Starting VM '$VmName'..." -ForegroundColor Yellow
try {
    $vm | Start-AzVM -ErrorAction Stop | Out-Null
    Write-Host "VM '$VmName' started successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to start VM '$VmName'. Error: $($_.Exception.Message)"
}

Write-Host "--- VM Resizing Script Completed ---" -ForegroundColor Green