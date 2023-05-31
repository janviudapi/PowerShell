Add-Type -AssemblyName System.Windows.Forms

#Written By: vcloud-lab.com 
#Auther: vjanvi

# Create a form object
$form = New-Object System.Windows.Forms.Form
$form.Text = "Slider and TextBox Data Binding Example"
$form.Size = New-Object System.Drawing.Size(400, 200)

# Create a panel for the stack panel layout
$panel = New-Object System.Windows.Forms.Panel
$panel.Dock = [System.Windows.Forms.DockStyle]::Fill

# Create a stack panel
$stackPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$stackPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
$stackPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
$stackPanel.WrapContents = $false
$stackPanel.Padding = New-Object System.Windows.Forms.Padding(10)

# Create a slider control
$slider = New-Object System.Windows.Forms.TrackBar
$slider.Name = "sourceSlider"
$slider.Minimum = 0
$slider.Maximum = 100
$slider.Width = 120
$slider.Value = $slider.Minimum + (($slider.Maximum - $slider.Minimum) / 2)
$slider.Margin = New-Object System.Windows.Forms.Padding(5)

# Create a textbox control
$textBox = New-Object System.Windows.Forms.TextBox
[void]$textBox.DataBindings.Add("Text", $slider, "Value", $true, "OnPropertyChanged")
$textBox.Margin = New-Object System.Windows.Forms.Padding(5)

# Add the controls to the stack panel
[void]$stackPanel.Controls.Add($slider)
[void]$stackPanel.Controls.Add($textBox)

# Add the stack panel to the panel
[void]$panel.Controls.Add($stackPanel)

# Add the panel to the form
[void]$form.Controls.Add($panel)

# Show the form
$form.ShowDialog() | Out-Null

<#
Add-Type -AssemblyName PresentationFramework

#Written By: vcloud-lab.com 
#Auther: vjanvi

# Create a Window object
$window = New-Object System.Windows.Window
$window.Title = "Binding Example"
$window.Height = 200
$window.Width = 300

# Create a Grid object
$grid = New-Object System.Windows.Controls.Grid

# Create a StackPanel object
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.HorizontalAlignment = "Center"
$stackPanel.VerticalAlignment = "Center"

# Create a TextBox as the source control
$sourceTextBox = New-Object System.Windows.Controls.TextBox
$sourceTextBox.Name = "sourceTextBox"
$sourceTextBox.Text = "Hello"
$sourceTextBox.Width = 120

# Create a TextBox as the target control
$targetTextBox = New-Object System.Windows.Controls.TextBox
$targetTextBox.Text = $sourceTextBox.Text
$targetTextBox.Width = 120
$targetTextBox.IsReadOnly = $true

# Create a Binding object
$binding = New-Object System.Windows.Data.Binding
$binding.Source = $sourceTextBox
$binding.Path = New-Object System.Windows.PropertyPath("Text")
$binding.Mode = "OneWay"

# Apply the binding to the target TextBox
$targetTextBox.SetBinding([System.Windows.Controls.TextBox]::TextProperty, $binding)

# Add the controls to the StackPanel
[void]$stackPanel.Children.Add($sourceTextBox)
[void]$stackPanel.Children.Add($targetTextBox)

# Add the StackPanel to the Grid
[void]$grid.Children.Add($stackPanel)

# Set the Grid as the content of the Window
$window.Content = $grid

# Show the window
$window.ShowDialog() | Out-Null

#>