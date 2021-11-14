function HappyNewYear {
	Clear-Host
	$windowSize = $host.UI.RawUI.WindowSize

    $line1 = "$([char]9608) $([char]9608) $([char]9608)$([char]9608)$([char]9608) $([char]9608)$([char]9608)$([char]9608) $([char]9608)$([char]9608)$([char]9608) $([char]9608) $([char]9608)   $([char]9608)$([char]9608)  $([char]9608) $([char]9608)$([char]9608)$([char]9608) $([char]9608)   $([char]9608)   $([char]9608) $([char]9608) $([char]9608)$([char]9608)$([char]9608) $([char]9608)$([char]9608)$([char]9608) $([char]9608)$([char]9608)$([char]9608)"
    $line2 = "$([char]9608)$([char]9608)$([char]9608) $([char]9608)$([char]9604)$([char]9608) $([char]9608)$([char]9604)$([char]9608) $([char]9608)$([char]9604)$([char]9608) $([char]9608)$([char]9604)$([char]9608)   $([char]9608) $([char]9608) $([char]9608) $([char]9608)$([char]9604)  $([char]9608) $([char]9608) $([char]9608)   $([char]9608)$([char]9604)$([char]9608) $([char]9608)$([char]9604)  $([char]9608)$([char]9604)$([char]9608) $([char]9608)$([char]9604)$([char]9600)"
    $line3 = "$([char]9608) $([char]9608) $([char]9608) $([char]9608) $([char]9608)   $([char]9608)    $([char]9608)    $([char]9608)  $([char]9608)$([char]9608) $([char]9608)$([char]9604)$([char]9604) $([char]9608)$([char]9608)$([char]9608)$([char]9608)$([char]9608)    $([char]9608)  $([char]9608)$([char]9604)$([char]9604) $([char]9608) $([char]9608) $([char]9608) $([char]9608)"
    
	$hSpaces = [System.Math]::Round(($windowSize.Width - $line1.length) / 2)
	$vSpaces = [System.Math]::Round(($windowSize.Height - 3) / 2)
	
    "`n" * $vSpaces
    "$(' ' * $hSpaces)$($PSStyle.Blink)$($PSStyle.Bold)$($PSStyle.reverse)$($PSStyle.Background.Brightgreen)$line1$($PSStyle.Reset)"
    "$(' ' * $hSpaces)$($PSStyle.Blink)$($PSStyle.Bold)$($PSStyle.reverse)$($PSStyle.Background.Brightgreen)$line2$($PSStyle.Reset)"
    "$(' ' * $hSpaces)$($PSStyle.Blink)$($PSStyle.Bold)$($PSStyle.reverse)$($PSStyle.Background.Brightgreen)$line3$($PSStyle.Reset)"
    "`n" * $($vSpaces / 2)
	"$($PSStyle.Background.BrightRed)HAPPY $($PSStyle.Underline)$($PSStyle.Bold)NEW YEAR$($PSStyle.Reset)"
	"`n" * $(($vSpaces / 2) - 2)
}

HappyNewYear