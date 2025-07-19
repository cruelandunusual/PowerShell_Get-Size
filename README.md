# Get-Size - a PowerShell cmdlet for human-readable file and folder listings

![Linux](https://img.shields.io/badge/-Linux-grey?logo=linux)
![macOS](https://img.shields.io/badge/-macOS-black?logo=apple)
![Windows](https://img.shields.io/badge/-Windows-red)
![PowerShell](https://img.shields.io/badge/-PowerShell_Core-blue)

## Description
This PowerShell Core `Get-Size` cmdlet shows a human-readable size value when listing files and folders, similar to Bash `du -h`.  

`Get-ChildItem` shows file sizes in bytes, which can be difficult to understand at a glance, and in any case it only shows the `Length` property for files, not folders, e.g.:  

![get-childitem_output_screenshot](<screenshots/get-childitem_output_screenshot.jpg>)

`Get-Size` gets the size of both files __*and*__ folders, in a more easily understandable format.

The text in the size column is color-coded for clarity, with a different color for sizes up to 1MB, sizes between 1MB and 1GB, and for sizes 1GB and above. Sizes are truncated to two decimal places, e.g:  

![get-size_output_screenshot](<screenshots/get-size_output_screenshot.jpg>)

Folder highlighting is preserved as per the user's terminal settings, however the item `Type` is shown in the leftmost column in case the user's settings don't differentiate files and folders. This is particularly useful because the results are sorted by either Name or Size, so folders and files may be adjacent in the results, e.g.:  

![get-size_leftmost_column_screenshot](<screenshots/get-size_leftmost_column.jpg>)  

## Usage
Input can be items in a comma separated list (aka symbols), e.g.:  
```powershell
Get-Size D:\Music, D:\Pictures, myfile.txt
```
Variables storing a list of items can also be used, e.g.:  
```powershell
$mylist = Get-ChildItem D:\Documents\
Get-Size $mylist  
```
Combinations of the two are supported:
```powershell
Get-Size $mylist, D:\Pictures
```
The modifiable options are `-SortProperty` and `-Descending` / `-Ascending`.   
`-Descending` and `-Ascending` are simple switches.  
`-SortProperty` expects either `Name` or `Size`.  

The options can be given in any order, e.g.  
```powershell
Get-Size -Descending -SortProperty Name
```
```powershell
Get-Size -SortProperty Name -Descending  
```
By default `Get-Size` sorts its results by size in ascending order, so `-Ascending` can be ommitted.  

Leaving out filenames, variables or wildcards will default to showing the content of the current directory, the same way `Get-ChildItem` works, so the following are all equivalent:  

```powershell
Get-Size  
```
```powershell
Get-Size -Ascending  
```
```powershell
Get-Size -Ascending -SortProperty Size  
```
```powershell
Get-Size -Ascending -SortProperty Size *  
```  
`Get-Size` is fully documented; type `Get-Help Get-Size` for documentation on using the cmdlet, including examples:  

![get-size_get-help_output_screenshot](<screenshots/get-size_get-help_output_screenshot2.jpg>)  

## Notes
Large folders with deep nested structures and many files may take some time to calculate. Write-Progress has been implemented as a convenience to the user.  

## Installation
`Get-Size` requires PowerShell Core, minimum version 7.0.  
To install, clone this repo and copy the __*SizeModule*__ folder to the __*Modules*__ folder for your user, typically:
- __Linux__  / __macOS__
  - ~/.local/share/powershell/Modules
- __Windows__
  - %USERPROFILE%\Documents\PowerShell\Modules

*(Entering* `$env:PSModulePath` *at the command prompt will reveal the location on your system.)*  

> [!TIP]  
> Entering `$env:PSModulePath` at the command prompt will reveal the location on your system.  
> `Set-Location ($env:PSModulePath).Split(';')[0]` # cd to the module location on Windows  
> `Set-Location ($env:PSModulePath).Split(':')[0]` # macOS / Linux version  

Then at the prompt enter:  
```powershell
Import-Module SizeModule
```  
Once imported the module will be available for all future sessions.  
