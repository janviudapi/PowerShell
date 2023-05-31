Add-Type -AssemblyName PresentationFramework

#Written By: vcloud-lab.com 
#Auther: vjanvi

# Create XAML markup for the WPF application
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Slider and TextBox Data Binding Example" Height="200" Width="400">
    <Grid>
        <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
            <Slider x:Name="sourceSlider" Value="50" Minimum="0" Maximum="100" Width="120" Margin="5"/>
            <TextBox Text="{Binding ElementName=sourceSlider, Path=Value, Mode=TwoWay, UpdateSourceTrigger=PropertyChanged}" Margin="5"/>
        </StackPanel>
    </Grid>
</Window>
"@

# Create a WPF XML reader and load the XAML markup
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader] $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Show the window
$window.ShowDialog() | Out-Null

<#
Add-Type -AssemblyName PresentationFramework

#Written By: vcloud-lab.com 
#Auther: vjanvi

# Create XAML markup for the WPF application
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Binding Example" Height="200" Width="300">
    <Grid>
        <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
            <TextBox x:Name="sourceTextBox" Text="Hello" Width="120"/>
            <TextBox Text="{Binding ElementName=sourceTextBox, Path=Text, Mode=OneWay}" Width="120" IsReadOnly="True"/>
        </StackPanel>
    </Grid>
</Window>
"@

# Create a WPF XML reader and load the XAML markup
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader] $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Show the window
$window.ShowDialog() | Out-Null
#>