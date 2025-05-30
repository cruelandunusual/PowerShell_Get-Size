


function New-List {
    param (
        [string[]]$ParameterName
    )
    for ($i = 0; $i -lt $ParameterName.Count; $i++) { 

        write-host($ParameterName[$i])
    }

    <#     foreach($Parameter in $ParameterName) {
        
        Write-Host($Parameter)
    } #>
}

<# get list of com objects -- not all will be usable with Powershell! #>
# Get-ChildItem HKLM:\Software\Classes -ea 0| Where-Object {$_.PSChildName -match '^\w+\.\w+$' -and (Get-ItemProperty "$($_.PSPath)\CLSID" -ea 0)}
# | Format-Table PSChildName | Out-File "W:\bash_and_ps\ps\com_objects.txt"

<# different ways of measuring objects #>
# Get-ChildItem | Measure-Object -Property length -Minimum -Maximum -Sum -Average

<# ---- #>

function New-Greeting {
    [CmdletBinding(
        SupportsShouldProcess=$true
    )]
    param(
        [Parameter()]
        [string]
        $Name = "World"

    )

    if ($PSCmdlet.ShouldProcess($Name)) {
        $greeting = "Hello, $Name!"
        $greeting
    }
}




# Create a dummy data table with three columns: Name, Age, and Occupation
$data = @(
    [PSCustomObject]@{Name = 'Alice'; Age = 25; Occupation = 'Teacher' }
    [PSCustomObject]@{Name = 'Bob'; Age = 30; Occupation = 'Engineer' }
    [PSCustomObject]@{Name = 'Charlie'; Age = 35; Occupation = 'Doctor' }
    [PSCustomObject]@{Name = 'David'; Age = 40; Occupation = 'Lawyer' }
    [PSCustomObject]@{Name = 'Eve'; Age = 45; Occupation = 'Artist' }
)

$PSStyle.Formatting.TableHeader = "$($PSStyle.Foreground.FromRGB(218,112,214))"

$data | Format-Table @{
    Label      = 'Name'
    Expression =
    { switch ($_.Name) {
            { $_ } { $color = "$($PSStyle.Foreground.FromRGB(255,255,49))$($PSStyle.Blink)" } # Use PSStyle to set the color
        }
        "$color$($_.Name)$($PSStyle.Reset)" # Use PSStyle to reset the color
    }
}, @{
    Label      = 'Age'
    Expression =
    { switch ($_.age) {
            { $_ -gt 30 } { $color = "$($PSStyle.Foreground.FromRGB(255,20,147))$($PSStyle.Blink)" } # Use PSStyle to set the color
        }
        "$color$($_.age)$($PSStyle.Reset)" # Use PSStyle to reset the color
    }
}, @{
    Label      = 'Occupation'
    Expression =
    { switch ($_.Occupation) {
            { $_ } { $color = "$($PSStyle.Foreground.FromRGB(152,255,152))$($PSStyle.Blink)" } # Use PSStyle to set the color
        }
        "$color$($_.Occupation)$($PSStyle.Reset)" # Use PSStyle to reset the color
    }
}


<#
Make histogram of volume free space.
The code below is my javascript vertical histogram printing code.
#>
# // Working on that exercise above prompted me to dig out
# // the old C code I wrote to print a histogram vertically
# const histogram = [4, 3, 7, 10, 3, 9, 2, 1];
# let max = 0;
# for (let i = 0; i < histogram.length; i++) {
#     if (histogram[i] > max) {
#         max = histogram[i]; // store the largest number in the array
#     }
# }

# let starStr = ""; // initialise a string for printing each line
# for (let y = max; y > 0; y--) { // loop down from highest value to lowest
#     for (let x = 0; x < histogram.length; x++) {
#         if (histogram[x] < y) {
#             starStr += "  "; // append space if current element is less than max
#         }
#         else {
#             starStr += "* "; // else append a star
#         }
#     }
#     console.log(starStr);
#     starStr = "";
# }
 

<# renaming the Ralph McQuarrie files such that (00) becomes (01), etc #>
Set-Location 'D:\Pictures\Ralph McQuarrie Star Wars art'
$files = Get-ChildItem # gets all the ralph mcquarrie files; there's nothing else in the folder

<#
The lines below are my mucking about attempt at finding a good pattern match to isolate the files
in some way. The algorithm is this:
- start at the last file (i.e. (19))
- get the number part; store it as a number, not as text
- increment by 1
- rename the file using a suitable -match statement with this new number part
#>

<#
Renaming the Ralph McQuarrie files such that Ralph McQuarrie (00).jpg becomes
Ralph McQuarrie (01).jpg, etc.
Unfortunately the loop below converts the numbers less than 10 to single digit.
So (00) becomes (1) when I add 1 to it. There's a way to force a digit to have a leading
zero if it would otherwise be a single digit number but I don't understand what's going on
in the snippet I found online:
---- from "https://forums.overclockers.co.uk/threads/powershell-convert-1-digit-number-to-2-digit-number.18279138/"
"{0:D2}" -f $number
The above can be used to format a number and make sure it is at least two digits.
----------------
So I ended up rerunning my initial code which padded out the single digit numbers
to two digits after I'd done the increment. The code for that is:
foreach ($file in $files) {Rename-Item $file ($file.name -replace '\(','(0')}
#>
$firstPart = 'Ralph McQuarrie ('
$lastPart = ').jpg'
for ($i = $files.Length-1; $i -ge 0; $i--) {
    [int]$num = $files[$i].name.Substring(17,2) # this extracts the 2 digit number part of the name as an int
    $num = $num + 1 # this increments it, but unfortunately converts values less than 10 to be single digit
    rename-item $files[$i] $firstPart$num$lastPart # this renames it with the new number
}


$items = Get-ChildItem

foreach ($item in $items) {
    $mylist = @{
        Name = $item.Name
        Mode = $item.Mode
    }
    return $mylist
}