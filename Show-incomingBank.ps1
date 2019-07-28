<#
.SYNOPSIS
    Show-incomingBank.ps1
.DESCRIPTION
    show which transactions found in specified csv files were moneys coming into the account
.EXAMPLE
   powershell.exe -noprofile -nologo  -file  "h:\Tools\Show-incomingBank.ps1"   -FilesPath   H:\BOA\stmt0*19.csv
.NOTES
   Author: Brian Warris    06/23/2019
#>

[CmdletBinding()]
Param
(
        [Parameter(Mandatory=$True)][string]$FilesPath
)
$Dir = $(Split-Path "$FilesPath"  -Parent)
$Inc = $(Split-Path "$FilesPath"  -Leaf)
$rt = @()
if (test-path  -Path  "$Dir" -ErrorAction Continue)
{
    (Get-ChildItem -Path "$($Dir)" -Filter "$($Inc)" -Recurse   -ErrorAction Continue)  | Select-Object -Property "FullName"  | ForEach-Object -Process {
        $FileName = "$($_.FullName)" 
        $fc = Get-Content -Path "$FileName" 
        $i = 0
        #cont = $false
        foreach ($line in $fc)
        {
            # remain quiet until this line is found
            if (-not $cont)
            {
                $cont = $line.StartsWith('Date,Description,Amount')
            }
            else
            {
                $entry = $line -Split ","
                $es = "$($entry[2])"
                $id = "$($entry[0])"
                $other = "$($entry[1])"
             #   write-host  "$id  $other  $es"
                $key = "$id $other"
                if ($es  -and ($line.IndexOf(',,') -lt 0) -and $es.StartsWith('"') -and -not $rt.Contains($key))
                {
                    $rt += $key
            	    $e = $es.Substring(1, $es.Length - 2)
                    $a = $e -as [float]      # [float]::Parse($e)
                    if ($a -and ($a -gt 0.0))
                    {
                         Write-host  "$($FileName) - $($i) $($line)"
                    }
                }
            }
            $i += 1
        }
    } 
}
else
{
    Write-Host "$($Dir) was not found!"
}
