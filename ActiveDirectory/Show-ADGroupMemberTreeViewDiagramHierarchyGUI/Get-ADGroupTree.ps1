Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'AD Group Info Form'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter the AD Group in the space below:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$textBox.Text = "Administrators"
$form.Controls.Add($textBox)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $GroupName = $textBox.Text
}
else 
{
    $GroupName = 'Administrators'
}
function Show-ADGroupTreeViewDiagram {
    #requires -version 5
    <#
    .SYNOPSIS
        Show DownStream tree view hierarchy of members groups recursively of a Active Directory Group in GUI HTML.
    .DESCRIPTION
        The Show-ADGroupTreeViewDiagram list all nested group list of a AD user and created diagram from it and show on GUI HTML page. It requires only valid parameter AD username, 
    .PARAMETER GroupName
        Prompts you valid active directory Group name. You can use first character as an alias, If information is not provided it provides 'Domain Admins' group information.
    .INPUTS
        Microsoft.ActiveDirectory.Management.ADGroup
    .OUTPUTS
        Microsoft.ActiveDirectory.Management.ADGroup
        Microsoft.ActiveDirectory.Management.ADuser
    .NOTES
        Version:        3.0
        Author:         Janvi
        Creation Date:  01 May 2024
        Purpose/Change: Get the nested downstream group info of member and view in HTML
        Useful URLs: http://vcloud-lab.com
    .EXAMPLE
        PS C:\>.\Show-ADGroupTreeViewDiagram -GroupName 'Administrators'
    
        This list all the upstream memberof group of a Group.
    #>
    
    [CmdletBinding(SupportsShouldProcess=$True,
        ConfirmImpact='Medium',
        HelpURI='http://vcloud-lab.com')]
    Param
    (
        [parameter(Position=0, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true, HelpMessage='Type valid AD Group')]
        [alias('Group')]
        [String]$GroupName = 'Domain Admins',
        [parameter(DontShow=$True)]
        [alias('U')]
        $UpperValue = [System.Int32]::MaxValue,
        [parameter(DontShow=$True)]
        [alias('L')]
        $LowerValue = 2
    )
    begin {
        if (!(Get-Module Activedirectory)) {
            try {
                Import-Module ActiveDirectory -ErrorAction Stop 
            }
            catch {
                Write-Host -Object "ActiveDirectory Module didn't find, Please install it and try again" -BackgroundColor DarkRed
                Break
            }
        }
        try {
            $Group =  Get-ADGroup $GroupName -Properties members -ErrorAction Stop 
            $Members = $Group | Select-Object -ExpandProperty members 
            $rootname = $Group.Name
            $memberOfGroups = Get-ADGroupMember $Group.Name
            foreach ($memberOf in $memberOfGroups.Name) 
            {
                $groupInfo = "{0}({1}) --> {2}({3});" -f $($rootname -replace '\s',''), $rootname, $($memberOf -replace '\s',''), $memberOf
                $groupInfo | Out-File -FilePath $PSScriptRoot\Extras\rawdiagram.mmd -Append
            }
        }
        catch {
            Write-Host -Object "`'$GroupName`' groupname doesn't exist in Active Directory, Please try again." -BackgroundColor DarkRed
            $result = 'Break'
            Break
        }
    }
    Process {
        $Minus = $LowerValue - 2
        $Spaces = " " * $Minus
        $Lines = "__"
        "{0}{1}{2}{3}" -f $Spaces, '|', $Lines, $rootname        
        $LowerValue++
        $LowerValue++
        if ($LowerValue -le $UpperValue) {
            foreach ($member in $Members) {
                try {
                    $UpperGroup = Get-ADGroup $member -Properties Members, Memberof -ErrorAction Stop
                }
                catch {
                    Continue
                }
                #$LowerGroup = $UpperGroup |
                $LowerGroup = $UpperGroup | Get-ADGroupMember
                $LoopCheck = $UpperGroup.memberof | ForEach-Object {$_ -contains $lowerGroup.distinguishedName}
                if ($LoopCheck -Contains $True) {
                    $rootname = $UpperGroup.Name
                    Write-Host "Loop found on $($UpperGroup.Name), Skipping..." -BackgroundColor DarkRed
                    Continue
                }
                #"xxx $($LowerGroup.name)"
                #$Member
                #"--- $($UpperGroup.Name) `n"
                Show-ADGroupTreeViewDiagram -GroupName $member -LowerValue $LowerValue -UpperValue $UpperValue
            } #foreach ($member in $MemberOf) {
        }
    } #Process
}
Clear-Content -Path $PSScriptRoot\Extras\diagram.mmd -Force
Clear-Content -Path $PSScriptRoot\Extras\rawdiagram.mmd -Force
'flowchart TD;' | Out-File -FilePath $PSScriptRoot\Extras\diagram.mmd
Show-ADGroupTreeViewDiagram -GroupName $GroupName
$rawDiagram = Get-Content $PSScriptRoot\Extras\rawdiagram.mmd #-Raw
$null = $rawDiagram[1] -match '^(.*?)\('
$rawDiagram[0] = "{0} style {1} fill:#CC5500,color:white;" -f $rawDiagram[0], $Matches[1]
Add-Content -Path $PSScriptRoot\Extras\diagram.mmd -Value ($rawDiagram | Sort-Object | Get-Unique)
$diagram = Get-Content -Path $PSScriptRoot\Extras\diagram.mmd #-Raw
Write-Host "`nLoading Diagram $($diagram.noinfo)"
Import-Module "$PSScriptRoot\Extras\EPS\1.0.0\EPS.psm1" -Force | Out-Null
$html = Invoke-EpsTemplate -Path "$PSScriptRoot\Extras\Diagram.eps"
$html | Out-File -FilePath "$PSScriptRoot\Diagram.html"
#Invoke-Expression $PSScriptRoot\Diagram.html