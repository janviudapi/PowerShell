Add-Type -AssemblyName System.Web

$date = (Get-Date).AddDays(-7).DateTime

$url="http://softcurry.com/$date"
$url


#Encode Url
$encodedUrl = [System.Web.HttpUtility]::UrlEncode($url) 
$encodedUrl

#Decode Url
$decodedUrl = [System.Web.HttpUtility]::UrlDecode($encodedUrl)
$decodedUrl
