$Karpekar_Constant = 6174 

$i = 0
function Get-KarpekarConstant ($Number = 3689)
{
    if ($i -eq 0) 
    {
        $initNumber = $number
    }
    $i++
    $des = ($Number.ToString() -split '' | Sort-Object -Descending) -join ''
    $asc = ($Number.ToString() -split '' | Sort-Object) -join ''
    $result = $des.ToInt32($null) - $asc.ToInt32($null)
    Write-Host "[$($i.ToString().PadLeft(2,'0'))] $des - $asc = $result"
    if (($result.ToString().Length -le 3) -or ($des -eq $asc))
    {
        Write-Host "$initNumber is not good for test with Karpekar's Constant"
    }
    elseif ($result -ne $Karpekar_Constant) {
        Get-KarpekarConstant -Number $result
    }
    else 
    {
        "`n"
        Write-Host "Total calculations: $i"
    }
}

Get-KarpekarConstant -Number 4444