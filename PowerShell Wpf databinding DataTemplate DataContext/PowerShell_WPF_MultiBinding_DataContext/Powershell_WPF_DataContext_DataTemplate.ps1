$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" x:Name="MainWindow"
        Title="DataTemplate example - vCloud-lab.com" Height="350" Width="400">

<Grid Margin="10">
    <TextBlock Text="    Drive     ||     UsedSpace Percent     ||         TotalSpace GB" />
    <ItemsControl ItemsSource="{Binding MyLogicalDiskListProperty}" Margin="20">
        <ItemsControl.ItemTemplate>
            <DataTemplate>
                <Grid Margin="5">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="30" />
                        <ColumnDefinition Width="150" />
                        <ColumnDefinition Width="50" />
                        <ColumnDefinition Width="*" />
                    </Grid.ColumnDefinitions>
                    <TextBlock Text="{Binding DriveName}" />
                    <ProgressBar Name="ProgressBarUsedValue" Grid.Column="1" Minimum="0" Maximum="100" Value="{Binding UsedPercentage}"/>
                    <!-- <TextBlock Text=" Grid.Column="2" Minimum="0" {Binding ElementName=ProgressBarElement, Path=Value, StringFormat={}{0:0}%}" HorizontalAlignment="Center" VerticalAlignment="Center" /> -->
                    <TextBlock HorizontalAlignment="Center" VerticalAlignment="Center" Grid.Column="1">
                        <TextBlock.Text>
                            <MultiBinding StringFormat="{}Used: {0}%/ Total: {1}GB">
                                <Binding Path="Value" ElementName="ProgressBarUsedValue" />
                                <Binding Path="Text" ElementName="TexBoxTotalSize" />
                            </MultiBinding>
                        </TextBlock.Text>
                    </TextBlock>
                    <TextBlock Name="TexBoxTotalSize" Grid.Column="3" Text="{Binding Size}" Margin="5,0"/>
                </Grid>
            </DataTemplate>
        </ItemsControl.ItemTemplate>
    </ItemsControl>

</Grid>
</Window>
"@

[void][System.Reflection.Assembly]::LoadWithPartialName('PresentationFramework')

#Read XAML
$window = [Windows.Markup.XamlReader]::Parse($xaml)

$logicalDiskData = Get-CimInstance -Query "Select * from Win32_LogicalDisk" 

#[System.Collections.ArrayList]$logicalDisksInfo = @()
#$logicalDisksInfo = New-Object -TypeName 'System.Collections.ArrayList'
$logicalDisksInfo = [System.Collections.ArrayList]::new()

foreach ($drive in $logicalDiskData)
{
    $size = $drive.Size / 1gb
    $freeSpace = $drive.FreeSpace / 1gb
    $usedSpace = $size - $freeSpace
    $usedPercent = ($usedSpace / $size) * 100
    
    $logicalDisks = New-Object psobject
    Add-Member -InputObject $logicalDisks -Name DriveName -MemberType NoteProperty -Value $drive.DeviceID
    #$logicalDisks | Add-Member -Name DriveName -MemberType NoteProperty -Value $drive.VolumeName
    $logicalDisks | Add-Member -Name UsedPercentage -MemberType NoteProperty -Value ([System.Math]::Round($usedPercent))
    $logicalDisks | Add-Member -Name Size -MemberType NoteProperty -Value ([System.Math]::Round($size))
    Add-Member -InputObject $logicalDisks -Name usedSpace -MemberType NoteProperty -Value ([System.Math]::Round($usedSpace))
    $logicalDisks | Add-Member -Name FreeSpace -MemberType NoteProperty -Value ([System.Math]::Round($freeSpace))
    [void]$logicalDisksInfo.add($logicalDisks)
}

$myViewModel = New-Object PSObject -Property @{
    MyLogicalDiskListProperty = $logicalDisksInfo
}

$window.DataContext = $myViewModel

$window.ShowDialog()