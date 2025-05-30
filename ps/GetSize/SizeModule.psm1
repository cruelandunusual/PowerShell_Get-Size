<#
 Gets the size of a file or folder;
 can pass multiple items in a comma separated list of symbols,
 e.g. Get-Size D:\Audio, $HOME\Documents, myfile.txt
 including variables storing a list of items, e.g. Get-Size $mylist
#>
function Get-Size {
    [CmdletBinding()] # < This makes it an advanced function
    param(
        [Parameter(
            #Position = 0, 
            #Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        #[ValidateNotNullOrEmpty()] # Ensure the array isn't null or empty
        [array]$List,
        [string]$SortProperty,
        [switch]$Descending,
        [switch]$Ascending
    )
    Begin {
        if (!$SortProperty) {
            $SortProperty = 'Size'
        }

    }

    Process {
        # Executes once for each pipeline object
        $Output = @() # initialise the array to return
        $TotalSize = 0
        foreach ($ListItem in $List) {
            $Item = Get-Item $ListItem # need to explicitly get the item in case only a symbol is passed, e.g. .\Documents instead of $Documents
            if ($Item -is [array]) {
                <# If $Item is itself an array of items then Get-Size $Item will recursively get the size of each element #>
                if ($Descending) {
                    Get-Size $Item -SortProperty $SortProperty -Descending
                }
                else {
                    Get-Size $Item -SortProperty $SortProperty
                }
                #Write-Output "recursion not supported for now"
            }
            else {
                $Type = "File"
                $Size = 0 # (re)set to zero each loop iteration; not strictly necessary but I prefer it for clarity
                #! testing for a file using Test-Path fails for some files with non-standard chars in name, e.g. '['
                #if(Test-Path $Item -PathType Leaf) {
                #! testing for a file using .PSIsContainer sidesteps any tests on file name
                if (!$Item.PSIsContainer) {
                    # it's a file so get its length property
                    $Size = $Item.Length
                }
                else {
                    # it's a folder so recursively compute size
                    $Type = "Directory"
                    $Size = (Get-ChildItem -Recurse -Path $Item | Measure-Object -Property Length -Sum).Sum
                    if ($null -eq $Size) {
                        # empty directory so no Lengths were -Summed; in this case we'll set $Size to zero
                        $Size = 0
                    }
                }
                $TotalSize += $Size
                $SizeResult = Get-SizeScale $Size # get a hashtable of size and scale factor for human-readability
                $SizeStr = [string]$SizeResult.FileSize + ' ' + $SizeResult.Scale
                $Output += [PSCustomObject]@{
                    Type        = $Type
                    Name        = $Item.Name
                    NameString  = $Item.NameString
                    SizeStr     = $SizeStr
                    Size        = $Size
                }
            }
        }

        # Calculate a histogram of each item's size
        <#
        if ($Output.Length -gt 1) {
            foreach ($element in $Output) {
                $printStr = ''
                $percentValue = [Math]::Round(($element.Size / $TotalSize) * 100)
                for ($i = 1; $i -le $percentValue; $i++) {
                    $printStr += $blockChar
                }
                $element.Percentage = $printStr
            }
        }
        #>
        
        # Apply sorting logic
        if ($Descending) {
            $Output = $Output | Sort-Object -Property $SortProperty -Descending
        }
        else {
            # default sort is ascending, no need to specify it
            $Output = $Output | Sort-Object -Property $SortProperty
        }
        return $Output | Format-Table 'Type', @{Name = 'Name'; Expression = {$_.NameString}}, @{Name = 'Size'; Expression = { $_.SizeStr }; Alignment = 'right' }
    }
    End {
    }
}

<#
 Returns a hashtable containing the size of an item in GB, MB or KB,
 truncated to two decimal places, with an appropriate scale indicator
 as the second hashtable element
#>
function Get-SizeScale {
    param(
        [Parameter(Mandatory = $true)] # The parameter is mandatory
        $Size
    )
    $SizeScale = 'KB'
    if ($Size -gt 1GB) {
        $FileSizeFormatted = $Size / 1GB
        $SizeScale = 'GB'
    }
    elseif ($Size -gt 1MB) {
        $FileSizeFormatted = $Size / 1MB
        $SizeScale = 'MB'
    }
    else {
        $FileSizeFormatted = $Size / 1KB
    }
    $FileSizeFormatted = [math]::Round($FileSizeFormatted, 2) # truncate to two decimal places
    return @{
        FileSize = $FileSizeFormatted
        Scale    = $SizeScale
    }
}
