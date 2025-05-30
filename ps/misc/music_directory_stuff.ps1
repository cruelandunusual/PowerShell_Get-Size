

$FoldersList = Get-ChildItem
$FilesList = Get-ChildItem -Path $FolderList -Recurse


# create five fake artist Folders and two fake album subFolders within each one
for ($i = 1; $i -lt 3; $i++) {
    New-Item -ItemType Directory -Name "Artist Name $i";
    for ($j = 1; $j -lt 3; $j++) {
        $Path = "Artist Name $i";
        New-Item -Path $Path -ItemType Directory -Name "$(Get-Random)_ALBUM_$(Get-Random)"
    }
}

# remove the artist name directories
$FoldersList = Get-ChildItem
Remove-Item $FoldersList


# rename the artist name Folders
# (from previous incarnation of 'Folder 0', 'Folder 1', etc)
$FoldersList = Get-ChildItem
foreach ($Folder in $FoldersList) {
    Rename-Item $Folder "Artist Name $([array]::IndexOf($FoldersList, $Folder))"
}


# create a randomly named image file in each album Folder
$FoldersList = Get-ChildItem -Recurse
foreach ($Folder in $FoldersList) {
    if ($Folder.PSIsContainer -and $Folder.Name -match "_ALBUM_") {
        New-Item -Path $Folder -ItemType File -Name "$(Get-Random)_ALBUMCOVER_$(Get-Random).jpeg"
    }
}



# print the index number and name of each $File in $FilesList
$FilesList = Get-ChildItem -Recurse
foreach ($File in $FilesList) {
    if (!$File.PSIsContainer) { # if $File is not a Folder
        Write-Host "File number $([array]::IndexOf($FilesList, $File)), name $File is a file";
    }
}

# remove all files at the end of the tree nodes
$FilesList = Get-ChildItem -Recurse
foreach ($File in $FilesList) {
    if (!$File.PSIsContainer){
        Write-Host "Deleting $File";
        remove-item $File -Recurse;
    }
}


# remove files without _FILE_ in the file name
$FilesList = Get-ChildItem -Recurse
foreach ($File in $FilesList) {
    if (!$File.PSIsContainer -and $File.Name -notmatch "_FILE_" ) {# if $File is not a Folder AND it doesn't have _FILE_ in its name
        Write-Host "Deleting $File";
        remove-item $File -Recurse;
    }
}

##############################################################

# rename the jpg file in each album Folder to be "Artist Name - Album Name.jpg"
$FilesList = Get-ChildItem -Recurse -File
foreach ($File in $FilesList) {
    if ($File.Extension -eq ".jpg") { # checking for file extension only works with the dot included
        
        $ParentPath = $File.PSParentPath;
        $ParentPathArray = $ParentPath.Split('\');
        $ArtistName = $ParentPathArray[$ParentPathArray.Count-2];
        $AlbumName = $ParentPathArray[$ParentPathArray.Count-1];
        
        $NewName = "$ArtistName - $AlbumName.jpg";
        Rename-Item $File $NewName;
        Write-Host "$NewName";
    }
}



# find all files at the end of the tree nodes
$FilesList = Get-ChildItem -Recurse
foreach ($File in $FilesList) {
    if (!$File.PSIsContainer){
        Write-Host "Found $File";
        remove-item $File -Recurse;
    }
}


#######################################################


function Show-Something{
    param(
        [int]$number,
        [string]$color
    )
    Write-Host "show number $number on the screen" -ForegroundColor $color
}
# Show-Something -number 42 -color "green"

#################################################

function New-AlbumCover {
    [CmdletBinding()]  # < This makes it an advanced function
    param(
        [Parameter(Mandatory=$true)]
        [string]$imageType,
        [ValidateNotNullOrEmpty()] # Ensure that a parameter is not null or empty
        [array]$FoldersList
    )
    #$FoldersList = Get-ChildItem -Recurse
    foreach ($Folder in $FoldersList) {
        if ($Folder.PSIsContainer -and $Folder.Name -match "_ALBUM_") {# if we're in a Folder and it has _ALBUM_ in the name
            $Name = "$(Get-Random)_ALBUMCOVER_$(Get-Random)$imageType" # create a filname with random numbers at start and end of BaseName
            Write-Verbose "Creating file $Name"
            New-Item -Path $Folder -ItemType File -Name "$Name" # create an image file
        }
    }
}

###################################################

function Remove-FileType {
    [CmdletBinding()]  # < This makes it an advanced function
    param (
        [Parameter(Mandatory = $true)]
        [string]$Extension,
        [ValidateNotNullOrEmpty()] # Ensure the array isn't null or empty
        [array]$FoldersList
    )
    foreach ($File in $FoldersList) {
        if ($File.Extension -eq "$extension") {
            Write-Verbose "Deleting $File"; # we can specify the -Verbose parameter when calling the function
            Remove-Item $File -Recurse;
        }
    }
}

################################################

# rename the jpg file in each album Folder to be "Artist Name - Album Name.jpg"
function Rename-AlbumArtFiles {
    [CmdletBinding()]  # < This makes it an advanced function
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ExtensionList,
        [ValidateNotNullOrEmpty()] # Ensure the array isn't null or empty
        [array]$FoldersList
    )

    foreach ($File in $FoldersList) {
        if (!$File.PSIsContainer) {
            if ($File.Extension -in $ExtensionList) {
                # Write-Verbose $File.Name
                $ext = $File.Extension
                $ParentPath = $File.PSParentPath;
                $ParentPathArray = $ParentPath.Split('\');
                $ArtistName = $ParentPathArray[$ParentPathArray.Count - 2];
                $AlbumName = $ParentPathArray[$ParentPathArray.Count - 1];
                $NewName = "$ArtistName - $AlbumName$ext";
                Rename-Item $File $NewName;
                Write-Verbose "$NewName";
                
            }
        }
    }
}

<#
Trying to find filenames with characters in them
that typically end up being junk characters in the mp3 tag, 
e.g. three underscores in a row (___) is sometimes in the filename
instead of a double quote character. Usually the mp3 tag converts
this properly but sometimes it substitutes the wrong character, e.g.
a question mark (?) instead of the double quote, so a file called
___meathead___ should be tagged as "meathead" but could be ?meathead? instead
#>
foreach ($item in $files) {
    Select-String -Pattern '___'
}


$files = Get-ChildItem -recurse -Path "D:\Music"
$files.Name | Select-String -Pattern "'" | Out-File -Path D:\singlequotes.txt # use $file.Name to search name only, not contents



<#
This was something I saw on stackexchange, to output the parent Folder of a matched file
but I can't get it to work with what I'm trying to do, it throws this error:
Cannot bind argument to parameter 'Path' because it is an empty string.
#>
$testFiles = Get-ChildItem -Recurse -Path "D:\Programming\bash_and_ps\ps\Music"
$testFiles.Name | Select-String -Pattern "___" | ForEach-Object {
    "$(split-path (split-path $_ -parent) -leaf)\$($_.Filename)"
}


<#
From the same stackexchange page, this also doesn't work - I need to pass $testFiles.Name
to Select-String otherwise it searches the whole file contents. Even though these are binary
files, it still manages to find several instances of the triple underscore pattern throughout
quite a few of the files, even those without the pattern in the file name.
Passing $testFiles.Name doesn't work, it throws this error:
Cannot find path 'D:\Programming\bash_and_ps\ps\InputStream' because it does not exist.
#>
$testFiles.Name | Select-String -CaseSensitive -Pattern '___' | ForEach-Object {
    $file = get-item $_.Path;
    write-output (join-path $file.Directory.BaseName $file.Name)
}


<#
Copilot's effort
It works. It's basically what I was looking for. Key things to take from this:
* Get-ChildItem -File returns only file ImageFileSearchResults, not directories
* $_.Name -like is easier and more succinctly like what I was looking for with Select-String
* Select-Object with the splatting is a neat way of formatting nicely tabled ImageFileSearchResults
** The main thing to take from this though is not to use Select-String when
   searching for patterns in file names. That's what Get-ChildItem.Name is for.
   I actually feel a bit foolish having spent so long trying to use Select-String
   on a returned object name. It's so much easier with Get-ChildItem
#>
# Define the directory to search and the pattern
$SearchPath = "D:\Music\"
$Pattern = '"[A-Z]'
$RegexPattern = '_{2,2}[A-Za-z]'
$OutputFile = "D:\output.txt"

# This is copilot's original answer
# Recursively get files matching the pattern and output the parent Folder and file name
Get-ChildItem -Path $SearchPath -Recurse -File | Where-Object {
    $_.Name -like "*$Pattern*"
} | Select-Object @{
    Name = "FolderList"
    Expression = { $_.DirectoryName }
}, Name


# This is my modified version to output ImageFileSearchResults to a file
Get-ChildItem -Path $SearchPath -Recurse -File | Where-Object {
    $_.Name -like "*$Pattern*"
} | Select-Object @{
    Name = "FolderList"
    Expression = {
        $_.DirectoryName
    }
}, Name | Out-File -Path $OutputFile


# This is my mod using regex for matching filenames to a pattern
Get-ChildItem -Path $SearchPath -Recurse -File | Where-Object {
    #$_.Name -like "*$Pattern*"
    $_.Name -match $RegexPattern
} | Select-Object @{
    Name = "FolderList"
    Expression = {
         $_.DirectoryName
    }
}, Name

# | Out-File -Path $OutputFile



$SearchPath = "C:\Users\peter\Desktop"
$ExtensionList = @('.jpg', '.png', '.jpeg') <# array syntax #>
# $ExtensionList = @('.mp3', '.m4a', '.wav', '.aif') <# array syntax #>

$ImageFileSearchResults = Get-ChildItem -Path $SearchPath -Recurse -File | Where-Object {$_.Extension -in $ExtensionList}

$FolderList = foreach ($file in $ImageFileSearchResults) {
    Split-Path -path $file -Resolve
}
$FolderList = $FolderList | Select-Object -Unique
$Extension = '.jpg'
foreach ($Folder in $FolderList) {
    $FolderImageItems = Split-Path -Path $Folder'\*'$Extension -Leaf -Resolve
    $FolderImageItems.Count
    $AlbumName = Split-Path -Path $Folder -Leaf -Resolve
    $ArtistName = Split-Path -Path $Folder'\..\' -Leaf -Resolve
    $NewName = $ArtistName + ' - ' + $AlbumName + $Extension # + '_' + (Get-Random) + '.jpg'
    if ($FolderImageItems.Count -eq 1) {
        rename-item $Folder'\'$FolderImageItems $NewName
    }
}

$ImageFileSearchResults = Get-ChildItem -path $SearchPath -File -Recurse | Where-Object {$_.Extension -eq $Extension}


function Rename-AlbumArtFiles {
    [CmdletBinding()]  # < This makes it an advanced function
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()] # Ensure the array isn't null or empty
        [array]$FolderList,
        [string]$Extension
    )
    foreach ($Folder in $FolderList) {
        $FolderImageItems = Split-Path -Path $Folder'\*'$Extension -Leaf -Resolve
        $AlbumName = Split-Path -Path $Folder -Leaf -Resolve
        $ArtistName = Split-Path -Path $Folder'\..\' -Leaf -Resolve
        $NewName = $ArtistName + ' - ' + $AlbumName + $Extension
        if ($FolderImageItems.Count -gt 1) {
            Write-Verbose "Creating file fail.txt"
            New-Item -Type File -Path $Folder -Name 'fail.txt'
        }
        else {
            # Write-Verbose "Creating file $NewName"
            Rename-Item $Folder'\'$FolderImageItems $NewName
        }
    }
}

<# testing ImageFileSearchResults#>
$png = Get-ChildItem -path $SearchPath -File -Recurse | Where-Object {$_.Extension -eq '.png'}
$jpeg = Get-ChildItem -path $SearchPath -File -Recurse | Where-Object {$_.Extension -eq '.jpeg'}
$jpg = Get-ChildItem -path $SearchPath -File -Recurse | Where-Object {$_.Extension -eq '.jpg'}


<#
Ludwig Göransson has png file
Thom Yorke The Eraser has jpeg file
#>

$list = foreach ($item in $table) {$item.Split('@')[0]; $item.Split('@')[1]}

$table = Get-Content D:\temp\musictosort.txt
$path = get-location | split-path -Resolve
foreach ($item in $table) {
    $newPath=$path+'\'+$item.Split('@')[0]
    set-location $newPath
    $files = Get-ChildItem
    $album = new-item -Type Directory -Name $item.Split('@')[1]
    Move-Item $files $album
}


