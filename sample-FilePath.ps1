<#
.SYNOPSIS
   sample-FilePath.ps1
.DESCRIPTION
   See page 20 of Cem Kaner, et al, "Testing Computer Software", on program paths.
   This simple adder script is derived from the description.

.EXAMPLE
   powershell.exe -noprofile -nologo  -command "c:\tools\sample-FilePath.ps1" 

.NOTES
   Author: Brian Warris
   Date:   2018-02-09
   

#>
function Get-NextInt
{
    [CmdletBinding()]
    Param 
    (
        [string]$Prompt = $(throw "Failed to pass a prompt")
    )
    [int]$rv = 0
    try
    {
        Write-Host $Prompt
        $text = $(Read-Host).Trim()
        if ($text.ToLower() -eq 'x')
        {
            throw "X was entered to exit."
        }
        else
        {
            $rv = [convert]::ToInt32($text, 10)
        }
    }
    catch
    {
        throw $_
    }
    return $rv;
}

Write-Output  "This is a simple adder program; Press X to exit."
$exit = $false;
while (-not $exit)
{
    try
    {
        <# notes on overflow testing:
        max signed int  2147483647
        max signed long 9223372036854775807, if datatype is changed to a long.
        #>
        $num1 = Get-NextInt -Prompt "Enter your first number"
        $num2 = Get-NextInt -Prompt "Enter your second number"
        <#  Note the promotion to long that occurs on attempted overflow!
Enter your first number
2147483647
Enter your second number
77
Sum of 2147483647 and 77 = 2147483724  #>
        Write-Host "Sum of $num1 and $num2 = $($num1 + $num2)"
 #       Write-Host "type of these numbers is  $($num1.GetType().ToString())"   Int32  as expected
        Write-Host "Simple adder now starts with another pair of numbers.$($env:newLine)"
    }
    catch
    {
        Write-Host "exiting on condition: $_"
        $exit = $true
    }
}

exit 0
