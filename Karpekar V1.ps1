$originalNumber = $number = '0099' #5930 #3335 #1111 #5637 
$Karpekar_Constant = 6174 
$i = 0

function Start-KarpekarCalc ($number)
{
    if ($number.Length -ne 4)
    {
        Write-Host "Type 4 digit number, Number $originalNumber is not suitable Karpekar Constant calculation." -BackgroundColor Red
    }
    do 
    {
        $i++
        $des = ($number.ToString() -split '' | Sort-Object -Descending) -join ''
        $asc = ($Number.ToString() -split '' | Sort-Object) -join ''
        $number = $des.ToInt32($null) - $asc.ToInt32($null)
        Write-Host "[$($i.ToString().PadLeft(2,'0'))] $des - $asc = $number"
        if ($number -eq $Karpekar_Constant)
        {
            Write-Host "Total calculations: $i" -ForegroundColor Green
            Write-Host "Number I tested: $originalNumber" -ForegroundColor Green
        }
        elseif ($number -eq 0)
        {
            Write-Host "Number $originalNumber is not suitable all digits are same." -BackgroundColor Red
            break
        }
        elseif ($number -le 999)
        {
            Write-Host "Number $originalNumber is not suitable for as it contains 3 same digits either lower or higher than a single digit." -BackgroundColor Red
            break
        }
    } until ($number -eq $Karpekar_Constant)
}

Start-KarpekarCalc -Number $number
