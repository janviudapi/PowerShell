#created by vcloud-lab.com

$vc = 'vCenter.vcloud-lab.com'
$esx = 'esxiserver.vcloud-lab.com'
$vcUser = 'administrator@vsphere.local'
$vcPassword = 'Computer@123'

$newUserName = 'testuser'
$newUserPassword = 'Computer@123'
$permissionRole = 'Admin'

Import-Module VMware.VimAutomation.Core
Connect-VIServer $vc -User $vcUser -Password $vcPassword

$esxcli = Get-EsxCli -VMHost $esx -V2

#List of all esxi accounts Before add
$esxiUserListBeforeAdd = @()
$esxiUserListBeforeAdd = $esxcli.system.permission.list.Invoke()
$esxiUserListBeforeAdd | Format-Table -AutoSize

#Create new user on ESXi
$esxcliArgs = $esxcli.system.account.add.CreateArgs()
$esxcliArgs.id = $newUserName
$esxcliArgs.password = $newUserPassword
$esxcliArgs.passwordconfiguration = $newUserPassword
$esxcliArgs = $esxcli.system.account.add.Invoke($esxcliArgs)

$permissionArg = $esxcli.system.permission.set.CreateArgs()
$permissionArg.id = $newUserName
$permissionArg.role = $permissionRole
$permissionArg = $esxcli.system.permission.set.Invoke($permissionArg)

#List of all esxi account After add
$esxiUserListAfterAdd = @()
$esxiUserListAfterAdd = $esxcli.system.permission.list.Invoke()
$esxiUserListAfterAdd | Format-Table -AutoSize

#Remove the user on ESXi
$esxcliArgs = $esxcli.system.account.remove.CreateArgs()
$esxcliArgs.id = $newUserName
$esxcliArgs = $esxcli.system.account.add.Invoke($esxcliArgs)

#List of all esxi account After delete
$esxiUserListAfterDelete = @()
$esxiUserListAfterDelete = $esxcli.system.permission.list.Invoke()
$esxiUserListAfterDelete | Format-Table -AutoSize