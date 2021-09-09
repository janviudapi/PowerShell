#Writen By: vJanvi
#Website: http://vcloud-lab.com
#Purpose: Generate XML Document

function Set-Log
{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact='Medium',
        HelpURI='http://vcloud-lab.com'
    )] #[CmdletBinding(
    Param
    ( 
        [parameter(Position=0, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)]
        [alias('C')]
        [String]$FilePath = 'C:\Temp\logs\info.log'
    ) #Param
    Begin {} #Begin
    Process 
    {
        if (Test-Path $FilePath)
        {
            $parentPath = Split-Path -Path $FilePath -Parent
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
            $fileExtension = [System.IO.Path]::GetExtension($FilePath)
            $dateTime = [System.DateTime]::Now
            $oldFileName = "{0}\$fileName-{1}{2:d2}{3:d2}{4}{5}$fileExtension" -f $parentPath, $dateTime.Year ,$dateTime.Month, $dateTime.Day, $dateTime.ToShortTimeString().Replace(':',''), $dateTime.Millisecond
            try
            {
                Rename-Item -Path $FilePath -NewName $oldFileName -Force -ErrorAction Stop
                Write-Host "Renamed filename - $oldFileName" -ForegroundColor DarkYellow
                [Void](New-Item -Path $FilePath -ItemType File -Force -ErrorAction Stop)
                Write-Host "File created - $FilePath" -ForegroundColor DarkGreen
            }
            catch 
            {
                Write-Host "File cannot be renamed or created, Check Permission or if in use - $FilePath" -BackgroundColor DarkRed
            }

        } #if (Test-Path $filePath)
        else 
        {
            try
            {
                [Void](New-Item -Path $FilePath -ItemType File -Force -ErrorAction Stop)
                Write-Host "File created - $FilePath" -ForegroundColor DarkGreen
            }
            catch
            {
                Write-Host "File cannot be created, Check Permission or if in use - $FilePath" -BackgroundColor DarkRed
            }
        } #else
    } #Process
    End {} #End
} #function Set-log

Set-log 'C:\Temp\logs\info.log'

#Referenace Document
#https://docs.microsoft.com/en-us/dotnet/api/system.xml.xmlwriter.writeprocessinginstruction?view=net-5.0

#$filePath = 'C:\Temp\logs\info.log'
#Step by step Article to create a XML Document using 

#Use XmlWriterSettings .net Object and Configure The XML format settings
$xmlsettings = New-Object System.Xml.XmlWriterSettings
$xmlsettings.Indent = $true
$indentChars = $(' ' * 4)
$xmlsettings.IndentChars = $indentChars 

#Create a empty XML file under given path with XML Settings
$xmlWriterObj = [System.XML.XmlWriter]::Create($filePath, $xmlsettings)

# Write the XML Declaration and set the XSL
$xmlWriterObj.WriteStartDocument()

#Define Additional XML format (Write the Processing Instruction node.)
$xmlWriterObj.WriteProcessingInstruction('xml-stylesheet', "type='text/xsl' href='style.xsl'")

#Define the DocumentType node
$xmlWriterObj.WriteDocType('rootinfo', $null , $null, '<!ENTITY rootinfo>')

#Define a Comment node
$xmlWriterObj.WriteComment("sample XML")

#Define Start the Root Element
$xmlWriterObj.WriteStartElement("Root") # <-- Start <Root> Element
    
    $xmlWriterObj.WriteStartElement('Object') # <-- Start <ChildObject>  Element

            $xmlWriterObj.WriteElementString('PropertyKey01','Value01')   # <-- Add Property key Value pair 1 Element
            $xmlWriterObj.WriteElementString('PropertyKey02','Value02')   # <-- Add Property key Value pair 2 Element
            $xmlWriterObj.WriteElementString('PropertyKey03','Value03')   # <-- Add Property key Value pair 2 Element

                $xmlWriterObj.WriteStartElement("SubChildObject") # <-- Start <SubChildObject> 
                
                    $xmlWriterObj.WriteEntityRef("h") #<-- add style and data
                    $xmlWriterObj.WriteElementString("SubPropertyKey01","Value01")
                    $xmlWriterObj.WriteElementString("SubPropertyKey02","Value02")

                $xmlWriterObj.WriteEndElement() # <-- Add End <SubObject>

    $xmlWriterObj.WriteEndElement() # <-- Add End <Object>

    #Define CDATA
    $xmlWriterObj.WriteCData("This is some CDATA")
    
$xmlWriterObj.WriteEndElement() # <-- Add End <Root> 

#This is End, Finalize and close the XML Document
$xmlWriterObj.WriteEndDocument()
$xmlWriterObj.Flush()
$xmlWriterObj.Close()