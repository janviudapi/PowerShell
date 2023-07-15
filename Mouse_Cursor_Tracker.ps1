Add-Type -AssemblyName PresentationCore,PresentationFramework

# Create the WPF window
$window = New-Object System.Windows.Window
$window.Title = "Mouse Tracker"
$window.Width = 400
$window.Height = 300
$window.WindowStartupLocation = "CenterScreen"

# Create the label to display mouse position
$label = New-Object System.Windows.Controls.Label
$label.HorizontalAlignment = "Center"
$label.VerticalAlignment = "Center"

# Add the label to the window's content
$window.Content = $label

# Subscribe to the MouseMove event
$window.Add_MouseMove({
    $position = [System.Windows.Input.Mouse]::GetPosition($window)
    $label.Content = "X: $($position.X), Y: $($position.Y)"
})

# Show the window
$window.ShowDialog() | Out-Null