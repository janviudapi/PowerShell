#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing 

#Website: http://vcloud-lab.com
#Written By: vJanvi
#Date: 14 Aug 2021
#Tested Environment:
    #Microsoft Windows 10
    #PowerShell Version 5.1
    #PowerCLI Version 12.3.0
    #vSphere 7

#Read xaml file
#$xamlFile = 'D:\Projects\PowerShell\WPF\Esxi_TCP-IP_Configuration\Esxi_TCP-IP_Configuration\MainWindow.xaml'

#<#
$xamlContent = @'
<Window x:Class="Esxi_TCP_IP_Configuration.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Esxi_TCP_IP_Configuration"
        mc:Ignorable="d"
        Title="ESXi server TCP/IP configuration      - http://vcloud-lab.com" Height="480" Width="800">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="28*"/>
            <ColumnDefinition Width="28*"/>
            <ColumnDefinition Width="28*"/>
            <ColumnDefinition Width="28*"/>
            <ColumnDefinition Width="28*"/>
            <ColumnDefinition Width="28*"/>
            <ColumnDefinition Width="28*"/>
            <ColumnDefinition Width="28*"/>
        </Grid.ColumnDefinitions>
        <Grid.RowDefinitions>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="28*"/>
            <RowDefinition Height="10*"/>
        </Grid.RowDefinitions>
        <GroupBox x:Name="groupBox_Authentication" Header="VC/ESXi Authentication" Grid.ColumnSpan="2"  Grid.RowSpan="6" Margin="5,5,5,0">
            <StackPanel>
                <Label x:Name="label_vCenter" Content="vCenter or ESXi Server:" Height="23" VerticalAlignment="Top" Margin="5,0,5,0"/>
                <TextBox x:Name="textBox_vCenter" Height="23" Text="marvel.vcloud-lab.com" TextWrapping="Wrap" Margin="5,0,5,0"/>
                <Label x:Name="label_UserName" Height="23" Content="UserName:" Margin="5,0,5,0"/>
                <TextBox x:Name="textBox_UserName" Height="23" Text="administrator@vsphere.local" TextWrapping="Wrap" Margin="5,0,5,0"/>
                <Label x:Name="label_Password"  Content="Password:" Height="23" Margin="5,0,5,0"/>
                <PasswordBox x:Name="passwordBox_Password" Height="23" Password="Password" Margin="5,0,5,0"/>
                <Button x:Name="button_Login" Content="Login" Height="21" Margin="5,2,5,2" Width="70" HorizontalAlignment="Right"/>
            </StackPanel>
        </GroupBox>
        <TextBlock x:Name="textBlock_ESXiList" Grid.Column="2" Text="ESXi Server List:" TextWrapping="Wrap" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,10,0,0" Grid.ColumnSpan="2"/>
        <Button x:Name="button_ESXiList" Content="ESXi List" Height="22"  Grid.Column="4" Margin="5,5,5,5" IsEnabled="False"/>
        <ListBox x:Name="listBox_ESXiList" Grid.Column="2" Grid.Row="1" Margin="5,0,5,5" Grid.ColumnSpan="3" Grid.RowSpan="5"/>
        <DataGrid x:Name="dataGrid_TcpIpConf" Grid.Row="7" Margin="5,0,5,5" Grid.ColumnSpan="5" Grid.RowSpan="3"/>
        <Button x:Name="button_TCPIPConf" Content="Get TCP/IP Conf" Height="22" Grid.Column="3" Grid.ColumnSpan="2" Margin="5,5,5,5" IsEnabled="False" Grid.Row="6"/>
        <TextBlock x:Name="textBlock_TcpIpConf" HorizontalAlignment="Left" Margin="5,0,5,5" Grid.Row="6" Text="Current TCP/IP Configuration:" TextWrapping="Wrap" VerticalAlignment="Center" Grid.ColumnSpan="2" />
        <TextBlock x:Name="textBlock_Logs" Grid.Column="5" Text="Configuration Logs:" TextWrapping="Wrap" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,10,0,0" Grid.ColumnSpan="2"/>
        <TextBox x:Name="logTextBox" Grid.Column="5" Margin="5,0,5,5" Grid.Row="1" Text="Logs" TextWrapping="Wrap" Grid.ColumnSpan="3" Grid.RowSpan="5" IsReadOnly="True" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Auto"/>
        <TextBox x:Name="textBox_Remove" Grid.Column="6" Margin="5,5,5,5" Grid.Row="7" Text="{Binding SelectedItem.Name, ElementName=dataGrid_TcpIpConf}" TextWrapping="Wrap" VerticalAlignment="Center" Grid.ColumnSpan="2" IsReadOnly="True"/>
        <Button x:Name="button_Add" Content="Add" Grid.Column="5" Grid.Row="8" Margin="15,7,15,10"/>
        <Button x:Name="button_Remove" Content="Remove" Grid.Column="5" Grid.Row="7" Margin="15,10,15,7" />
        <TextBox x:Name="textBox_Add" Grid.Column="6" Margin="5,5,5,5" Grid.Row="8" TextWrapping="Wrap" VerticalAlignment="Center" Grid.ColumnSpan="2"/>
        <TextBlock x:Name="textBlock_AddRemoveMessage" Grid.Column="5" HorizontalAlignment="Left" Grid.ColumnSpan="3" Margin="15,0,5,5" Grid.Row="9" Text="Restriction: Don't Add/Remove stacks names with Default, Provisioning, vMotion, defaultTcpipStack" TextWrapping="Wrap" VerticalAlignment="Center" Foreground="Maroon"/>
    </Grid>
</Window>
'@
#>

#$xamlContent = Get-Content -Path $xamlFile -ErrorAction Stop
#[xml]$xaml = $xamlContent -replace 'x:Class=".*?"', '' -replace 'xmlns:d="http://schemas.microsoft.com/expression/blend/2008"', '' -replace 'mc:Ignorable="d"', ''
[xml]$xaml = $xamlContent -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace 'x:Class=".*?"', '' -replace 'd:DesignHeight="\d*?"', '' -replace 'd:DesignWidth="\d*?"', ''

#Read the forms in xaml
$reader = (New-Object System.Xml.XmlNodeReader $xaml) 
$form = [Windows.Markup.XamlReader]::Load($reader) 

#AutoFind all controls
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object { 
    New-Variable  -Name $_.Name -Value $form.FindName($_.Name) -Force 
}

Function Confirm-Powercli
{
	$AllModules = Get-Module -ListAvailable VMware.PowerCLI
	if (!$AllModules)
	{
		Show-MessageBox -Message "Install VMware Powercli 12.0 or Latest. `n`nUse either 'Install-Module VMware.VimAutomation.Core' `nor download Powercli from 'http://my.vmware.com'" -Title 'VMware Powercli Missing error' | Out-Null
	}
	else
	{
		Import-Module VMware.PowerCLI
		$PowercliVer = Get-Module -ListAvailable VMware.VimAutomation.Core | Select-Object -First 1
		$ReqVersion = New-Object System.Version('12.0.0.0')
		if ($PowercliVer.Version -gt $ReqVersion)
		{
			$logTextBox.Text = ''
			$logTextBox.AppendText("VMware PowerCLI Version: $($PowercliVer.Version).`r`n")
            $logTextBox.AppendText("$('-' * 50)`r`n")
			#$textboxLogs.Text = "VMware PowerCLI Version: $($PowercliVer.Version)"
		}
		else
		{
			Show-MessageBox -Message "Install VMware Powercli 6.0 or Latest. `n`nUse either 'Install-Module VMware.VimAutomation.Core' `nor download Powercli from 'http://my.vmware.com'" -Title 'Lower version Powercli' | Out-Null
		}
	}
}

function Show-MessageBox
{
	param (
		[string]$Message = "Show user friendly Text Message",
		[string]$Title = 'Title here',
		[ValidateRange(0, 5)]
		[Int]$Button = 0,
		[ValidateSet('None', 'Hand', 'Error', 'Stop', 'Question', 'Exclamation', 'Warning', 'Asterisk', 'Information')]
		[string]$Icon = 'Error'
	)
	#Note: $Button is equl to [System.Enum]::GetNames([System.Windows.Forms.MessageBoxButtons])   
	#Note: $Icon is equl to [System.Enum]::GetNames([System.Windows.Forms.MessageBoxIcon])   
	$MessageIcon = [System.Windows.Forms.MessageBoxIcon]::$Icon
	[System.Windows.Forms.MessageBox]::Show($Message, $Title, $Button, $MessageIcon)
}

Confirm-Powercli
function Update-DataGrid {
	param (
		[string]$ESXiName,
		[System.Windows.Controls.DataGrid]$DataGrid
	)

    $Global:Esxcli = Get-EsxCli -VMHost $listBox_ESXiList.SelectedValue
    $tcpIpCompleteInfo = $esxcli.network.ip.netstack.list.invoke()
    #$tcpIpInfo = $tcpIpCompleteInfo| Select-Object Name, NetstackInstance, Enabled, Portgroup, PortSet, MTU

    $tcpIpInfoList = New-Object System.Collections.ArrayList
    foreach ($tcpIpInfo in $tcpIpCompleteInfo)
    {
        #$Global:NetStackName = @{netstack = $tcpIpInfo.Name}
        #$tcpIpDetails = $Esxcli.network.ip.netstack.get.invoke($netStackName)
        $tcpIpDetails = $esxcli.network.ip.netstack.get.Invoke($tcpIpInfo.Name)
        
        $tcpIpInfoList += [PSCustomObject]@{
            Name = $tcpIpDetails.Name;
            Enabled = $tcpIpDetails.Enabled;
            State = $tcpIpDetails.State;
            IPv6Enabled = $tcpIpDetails.IPv6Enabled
        }
    }
    $dataGrid_TcpIpConf.Clear()
    $dataGrid_TcpIpConf.ItemsSource = $tcpIpInfoList
    $dataGrid_TcpIpConf.IsReadOnly = $true
}

$button_Login.Add_click({
    try
    {
        $Global:VCConnection = Connect-Viserver -Server $textBox_vCenter.Text -User $textBox_UserName.Text -Password $passwordBox_Password.Password -ErrorAction Stop
        $logTextBox.AppendText("Connected Server: $($VCConnection.Name) `nVersion: $($VCConnection.Version) `nUser: $($VCConnection.User)`r`n")
        $logTextBox.AppendText("$('-' * 50)`r`n")
        $button_Login.IsEnabled = $false
        $button_ESXiList.isEnabled = $true
        
        $listBox_ESXiList.Clear()
        
        $Global:ESXiList = Get-VMHost
        $listBox_ESXiList.Items.Clear()
        foreach ($esxiServer in $ESXiList) 
        {
            $listBox_ESXiList.Items.Add($esxiServer.Name)
        }
        #$listBox_ESXiList.ItemsSource = $ESXiList.Name
        $listBox_ESXiList.SelectedItem = $listBox_ESXiList.Items[0]
        $listBox_ESXiList.SelectedValue = $listBox_ESXiList.Items[0]
        
        $button_TCPIPConf.IsEnabled = $true
    }
    catch
    {
        $logTextBox.AppendText("Connection to vCenter/ESXi failed, Try again `nError: $($error[0].Exception.Message)`r`n")
        $logTextBox.AppendText("$('-' * 50)`r`n")
        $button_Login.IsEnabled = $true
    }

})

$button_ESXiList.Add_click({
    $Global:ESXiList = Get-VMHost
    $listBox_ESXiList.Items.Clear()
    foreach ($esxiServer in $ESXiList) 
    {
        $listBox_ESXiList.Items.Add($esxiServer.Name)
    }
    #$listBox_ESXiList.ItemsSource = $ESXiList.Name
    $listBox_ESXiList.SelectedItem = $listBox_ESXiList.Items[0]
    $listBox_ESXiList.SelectedValue = $listBox_ESXiList.Items[0]
    $button_TCPIPConf.IsEnabled = $true

    
})

$button_TCPIPConf.Add_click({
    <#
    $Global:Esxcli = Get-EsxCli -VMHost $listBox_ESXiList.SelectedValue
    $Global:TcpIpCompleteInfo = $esxcli.network.ip.interface.list.invoke()
    $tcpIpInfo = $tcpIpCompleteInfo| Select-Object Name, NetstackInstance, Enabled, Portgroup, PortSet, MTU

    $tcpIpInfoList = New-Object System.Collections.ArrayList
    foreach ($tcpIpInfo in $tcpIpCompleteInfo)
    {
        $tcpIpInfoList += [PSCustomObject]@{
            NetstackInstance = $tcpIpInfo.NetstackInstance;
            Name = $tcpIpInfo.Name;
            Enabled = $tcpIpInfo.Enabled;
            Portgroup = $tcpIpInfo.Portgroup;
            PortSet = $tcpIpInfo.PortSet;
            MTU = $tcpIpInfo.MTU
        }
    }
    $dataGrid_TcpIpConf.Clear()
    $dataGrid_TcpIpConf.ItemsSource = $tcpIpInfoList
    $dataGrid_TcpIpConf.IsReadOnly = $true
    #>

    Update-DataGrid -ESXiName $listBox_ESXiList.SelectedValue -DataGrid $dataGrid_TcpIpConf

    $logTextBox.AppendText("Selected ESXi host: $($listBox_ESXiList.SelectedValue)`r`n")
    $logTextBox.AppendText("$('-' * 50)`r`n")

    #foreach ($tcpip in $tcpIpInfo) 
    #{
    #    $dataGrid_TcpIpConf.Items.Add($tcpip)
    #}
    #$esxcli.network.ip.interface.list.invoke()
})

$button_Remove.Add_click({ 
    #if (($textBox_Remove.Text -match "defaultTcpipStack|Default|Provisioning|vMotion"))
    if ($textBox_Remove.Text -in 'defaultTcpipStack', 'Default', 'Provisioning', 'vMotion')
    {
        Show-MessageBox -Message "Don't try to Add or Remove TCP/IP netstack name equal to 'defaultTcpipStack', 'Default', 'Provisioning', 'vMotion' `n`n`nChoose another TCP/IP netstack" -Title 'Choose different TCP/IP stack' -Button 0 -Icon Stop
    }
    elseif (($textBox_Remove.Text -eq $null) -or ($textBox_Remove.Text.trim() -eq '')) 
    {
        Show-MessageBox -Message "Don't keep TCP/IP netstack name empty or null" -Title 'Choose correct TCP/IP stack' -Button 0 -Icon Stop
    }
    else
    {
        #$esxcli.network.ip.netstack.remove.invoke(@{netstack = 'test'})
        $interaface = $null
        $removedStack = $textBox_Remove.Text
        $vmKernals = $Esxcli.network.ip.interface.list()
        $interaface = $vmKernals | Where-Object {$_.NetstackInstance -eq $textBox_Remove.Text.Trim()}
        if (($interaface -eq $null) -or ($interaface -eq ''))
        {
            $Esxcli.network.ip.netstack.remove.invoke($textBox_Remove.Text.Trim())
        }
        else 
        {
            Show-MessageBox -Message "Can't delete TCP/IP stack'$($textBox_Remove.Text.Trim())', It is used by VMKernel '$($vmKernals.Name)'." -Title 'TCP/IP stack is in use' -Button 0 -Icon Stop
        }
        Update-DataGrid -ESXiName $listBox_ESXiList.SelectedValue -DataGrid $dataGrid_TcpIpConf
        $logTextBox.AppendText("Removed TCP/IP Stack Name: $($removedStack)`r`n")
        $logTextBox.AppendText("$('-' * 50)`r`n")
    }
})

$button_Add.Add_click({ 
    #if (($textBox_Add.Text -eq 'defaultTcpipStack' -or $textBox_Add.Text -eq 'Default' -or $textBox_Add.Text -eq 'Provisioning' -or $textBox_Add.Text - 'vMotion'))
    if ($textBox_Add.Text -in 'defaultTcpipStack', 'Default', 'Provisioning', 'vMotion')
    {
        Show-MessageBox -Message "Don't try to Add or Remove TCP/IP netstack name equal to 'defaultTcpipStack', 'Default', 'Provisioning', 'vMotion' `n`n`nChoose another TCP/IP netstack" -Title 'Choose different TCP/IP stack' -Button 0 -Icon Stop
    }
    elseif (($textBox_Add.Text -eq $null) -or ($textBox_Add.Text.trim() -eq ''))
    {
        Show-MessageBox -Message "TCP/IP netstack name shouldn't be empty or null" -Title 'Choose correct TCP/IP stack' -Button 0 -Icon Stop
    }
    elseif ($textBox_Add.Text -in $dataGrid_TcpIpConf.Items.Name)
    {
        Show-MessageBox -Message "TCP/IP netstack name with $($textBox_Add.Text) already exist" -Title 'TCP/IP stack already exist' -Button 0 -Icon Stop
    }
    else
    {
        $addedStack = $textBox_Add.Text
        $Esxcli.network.ip.netstack.add.invoke($false, $textBox_Add.Text.Trim())        
        ###---
        #$esxcliOld = Get-EsxCli -VMHost ironman.vcloud-lab.com
        #$esxcliOld.network.ip.netstack.add($false, $textBox_Add.Text.Trim())
        ###---
        #$esxcliOld.network.ip.netstack.add.invoke(@{disabled = $false; netstack = $textBox_Add.Text})
        #$Esxcli.network.ip.netstack.add.invoke($textBox_Add.Text.Trim())
        Update-DataGrid -ESXiName $listBox_ESXiList.SelectedValue -DataGrid $dataGrid_TcpIpConf
        $textBox_Add.Text = ''
        $logTextBox.AppendText("Added TCP/IP Stack Name: $addedStack`r`n")
        $logTextBox.AppendText("$('-' * 50)`r`n")
    }
    
})

$form.Add_Closing({Disconnect-VIServer * -Confirm:$false}) 
[void]$form.ShowDialog()