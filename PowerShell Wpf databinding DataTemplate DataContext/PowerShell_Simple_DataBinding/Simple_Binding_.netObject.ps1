Add-Type -AssemblyName PresentationFramework

# Define a .NET class representing your data object
class Person {
    [string] $Name
    [int] $Age
}

# Create an instance of the Person class
$person = [Person]::new()
$person.Name = "John Doe"
$person.Age = 30

# Create a new Window object
$window = New-Object System.Windows.Window
$window.Title = "Data Binding Example"
$window.Height = 200
$window.Width = 300

# Create a Grid to hold the controls
$grid = New-Object System.Windows.Controls.Grid
$window.Content = $grid

# Create a StackPanel to hold the text blocks and text boxes
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.HorizontalAlignment = "Center"
$stackPanel.VerticalAlignment = "Center"
$grid.Children.Add($stackPanel)

# Create a TextBlock for the name
$txtNameLabel = New-Object System.Windows.Controls.TextBlock
$txtNameLabel.Text = "Name:"
$stackPanel.Children.Add($txtNameLabel)

# Create a TextBox for the name and bind it to the person's Name property
$txtName = New-Object System.Windows.Controls.TextBox
$txtName.SetBinding([System.Windows.Controls.TextBox]::TextProperty, "Name")
$txtName.DataContext = $person
$stackPanel.Children.Add($txtName)

# Create a TextBlock for the age
$txtAgeLabel = New-Object System.Windows.Controls.TextBlock
$txtAgeLabel.Text = "Age:"
$stackPanel.Children.Add($txtAgeLabel)

# Create a TextBox for the age and bind it to the person's Age property
$txtAge = New-Object System.Windows.Controls.TextBox
$txtAge.SetBinding([System.Windows.Controls.TextBox]::TextProperty, "Age")
$txtAge.DataContext = $person
[void]$stackPanel.Children.Add($txtAge)

# Show the window
$window.ShowDialog() | Out-Null
