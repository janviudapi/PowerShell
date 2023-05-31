Add-Type -AssemblyName PresentationFramework

# Define data items in Json
$list = @'
[
    {
        "Name": "John Doe",
        "Age": "30"
    },
    {
        "Name": "Jane Smith",
        "Age": "25"
    },
    {
        "Name": "Bob Johnson",
        "Age": "40"
    }
]
'@

# Create sample data
$people = $list | ConvertFrom-Json

# Create XAML markup for the WPF application
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="DataGrid with Data Binding and DataTemplate Example" Height="300" Width="400">
    <Grid>
        <DataGrid x:Name='DataGrid' ItemsSource="{Binding}" AutoGenerateColumns="False">
            <DataGrid.Columns>
                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>
                <DataGridTemplateColumn Header="Age">
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBlock Text="{Binding Age}" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                    <DataGridTemplateColumn.CellEditingTemplate>
                        <DataTemplate>
                            <TextBox Text="{Binding Age, UpdateSourceTrigger=PropertyChanged}" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </DataTemplate>
                    </DataGridTemplateColumn.CellEditingTemplate>
                </DataGridTemplateColumn>
            </DataGrid.Columns>
        </DataGrid>
    </Grid>
</Window>
"@

# Create a WPF XML reader and load the XAML markup
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader] $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Set the data context for the DataGrid
$dataContext = $window.FindName('DataGrid')
$dataContext.ItemsSource = $people

# Show the window
$window.ShowDialog() | Out-Null

<#

Add-Type -AssemblyName PresentationFramework

# Define a class for the data items
class Person {
    [string]$Name
    [int]$Age

    Person([string]$name, [int]$age) {
        $this.Name = $name
        $this.Age = $age
    }
}

# Create sample data
$people = @(
    [Person]::new('John Doe', 30),
    [Person]::new('Jane Smith', 25),
    [Person]::new('Bob Johnson', 40)
)

# Create a data source (ObservableCollection of PSObjects)
#$people = New-Object System.Collections.ObjectModel.ObservableCollection[PSObject]

# Add data to the data source
#$people.Add([PSCustomObject]@{ Name = "John Doe"; Age = 30 })
#$people.Add([PSCustomObject]@{ Name = "Jane Smith"; Age = 25 })

# Create XAML markup for the WPF application
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="DataGrid with Data Binding and DataTemplate Example" Height="300" Width="400">
    <Grid>
        <DataGrid x:Name='DataGrid' ItemsSource="{Binding}" AutoGenerateColumns="False">
            <DataGrid.Columns>
                <DataGridTextColumn Header="Name" Binding="{Binding Name}" Width="*"/>
                <DataGridTemplateColumn Header="Age">
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <TextBlock Text="{Binding Age}" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
            </DataGrid.Columns>
        </DataGrid>
    </Grid>
</Window>
"@

# Create a WPF XML reader and load the XAML markup
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader] $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Set the data context for the DataGrid
$dataContext = $window.FindName('DataGrid')
$dataContext.ItemsSource = $people

# Show the window
$window.ShowDialog() | Out-Null

#>