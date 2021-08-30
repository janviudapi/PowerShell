#Convert To Base64
$readableText = 'This is Powershell!'

$encodedBytes = [System.Text.Encoding]::UTF8.GetBytes($readableText)
$encodedText = [System.Convert]::ToBase64String($encodedBytes)
$encodedText

#Convert from Base64:
$encodedValue = 'VGhpcyBpcyBQb3dlcnNoZWxsIQ=='

$decodedBytes = [System.Convert]::FromBase64String($encodedValue)
$decodedText = [System.Text.Encoding]::Utf8.GetString($decodedBytes)
$decodedText

[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($encodedText))
[System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($encodedText))
[System.Text.Encoding]::BigEndianUnicode.GetString([System.Convert]::FromBase64String($encodedText))
[System.Text.Encoding]::Default.GetString([System.Convert]::FromBase64String($encodedText))

#http://vcloud-lab.com/entries/powershell/powershell-gui-encode-decode-images
