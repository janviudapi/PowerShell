Add-Type -AssemblyName PresentationFramework

# Define a .NET class representing your data object
class Person {
    [string] $Name
    [int] $Age
}

# Create an instance of the Person class
$person = [Person]::new()
$person.Name = "John Wick"
$person.Age = 60

# Create XAML markup for the WPF application
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Data Binding Example" Height="200" Width="300">
    <Grid>
        <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
            <TextBlock Text="Name:"/>
            <TextBox Text="{Binding Name, Mode=TwoWay}"/>
            <TextBlock Text="Age:"/>
            <TextBox Text="{Binding Age, Mode=TwoWay}"/>
        </StackPanel>
    </Grid>
</Window>
"@

# Create a WPF XML reader and load the XAML markup
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader] $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Set the data context of the window to the person object
$window.DataContext = $person

# Show the window
$window.ShowDialog() | Out-Null