# Description
This PowerShell Core `Get-Size` module shows a human-readable size value when listing files and directories, similar to Bash `du -h`.  

`Get-ChildItem` shows file sizes in bytes, which can be difficult to understand at a glance, and in any case it only shows the `Length` property for files, not folders, e.g.:  

![get-childitem_output_screenshot](<screenshots/get-childitem_output_screenshot.jpg>)

`Get-Size` gets the size of both files __*and*__ folders, in a more easily understandable format.

The text in the size column is color-coded for clarity, with a different color for sizes up to 1MB, sizes between 1MB and 1GB, and for sizes 1GB and above. Sizes are truncated to two decimal places, e.g:  

![get-size_output_screenshot](<screenshots/get-size_output_screenshot.jpg>)

`Get-Size` respects the user's terminal color settings for files and folders, i.e. folder highlighting is preserved.  
It also shows the item `Type` in the leftmost column in case those settings don't differentiate between files and folders. This is particularly useful because the results are sorted by either Name or Size, so directories and files may be adjacent in the results, e.g.:  

![get-size_leftmost_column_screenshot](<screenshots/get-size leftmost column.jpg>)  
# Usage
Input can be items in a comma separated list (aka symbols), e.g.:  
```
Get-Size D:\Music, D:\Pictures, myfile.txt
```
Variables storing a list of items can also be used, e.g.:  
```
$mylist = Get-ChildItem D:\Documents\
Get-Size $mylist  
```
Combinations of the two are supported:
```
Get-Size $mylist, D:\Pictures
```
The modifiable options are `-SortProperty` and `-Descending` / `-Ascending`.   
`-Descending` and `-Ascending` are simple switches.  
`-SortProperty` expects either `Name` or `Size`.  

The options can be given in any order, e.g.  
```
Get-Size -Descending -SortProperty Name
```
```
Get-Size -SortProperty Name -Descending  
```
By default `Get-Size` sorts its results by size in ascending order, so `-Ascending` can be ommitted.  

Leaving out filenames, variables or wildcards will default to showing the content of the current directory, the same way `Get-ChildItem` works, so the following are all equivalent:  

```
Get-Size  
```
```
Get-Size -Ascending  
```
```
Get-Size -Ascending -SortProperty Size  
```
```
Get-Size -Ascending -SortProperty Size *  
```  

# Notes
Large folders with deep nested structures and many files may take some time to calculate. Write-Progress has been implemented as a convenience to the user.  

# Installation
`Get-Size` requires PowerShell Core, minimum version 7.0  
To install, clone this repo and copy the __*SizeModule*__ folder to the __*Modules*__ folder for your user, typically:
- __Linux__  / __MacOS__
  - ~/.local/share/powershell/Modules
- __Windows__
  - %USERPROFILE%\Documents\PowerShell\Modules

*(Entering* `$env:PSModulePath` *at the command prompt will reveal the location on your system.)*  

Then at the prompt enter:  
```
Import-Module SizeModule
```  
Once imported the module will be available for all future sessions.  