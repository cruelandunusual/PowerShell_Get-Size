This is my PowerShell `Get-Size` module, which shows a more human readable size value when listing files and directories, much like BASH `ls -h`.  

It's not very useful that `Get-ChildItem` shows filenames in bytes, it's difficult to understand at a glance, and in any case it only shows the `Length` property for files, not folders, e.g.:  

![Get-ChildItem output](https://github.com/user-attachments/assets/01b0e1f2-3c03-4d3b-8301-1f4203bdd526)

`Get-Size` gets the size of files __*and*__ folders, in an instantly understandable format, e.g.:  

![Get-Size output](https://github.com/user-attachments/assets/45a5def4-015f-4646-bdaf-6a4082ca3ae5)

It respects the colour coding of files and folders, although shows the item type in the leftmost column in case the user's terminal colour settings don't differentiate between files and folders.  

You can pass multiple items in a comma separated list of symbols, e.g.  
```
Get-Size D:\Audio, $HOME\Documents, myfile.txt
```
including variables storing a list of items, e.g.  
```
Get-Size $mylist  
```
as well as combinations of the two:
```
Get-Size $mylist, D:\Documents
```
The modifiable options are `-SortProperty` and `-Descending` / `-Ascending`.  
`-Descending` and `-Ascending` are simple switches.  
*(By default `Get-Size` sorts its results by size in ascending order, so you can leave out `-Ascending`.)*  

`-SortProperty` expects either `Name` or `Size`.  

The switches can be given in any order, e.g.  
```
Get-Size -Descending -SortProperty Name
```
```
Get-Size -SortProperty Name -Descending  
```
Leaving out filenames, variables or wildcards will default to showing the content of the current directory, the same way `Get-ChildItem` works, so the following are equivalent:  

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
To install, copy the __*SizeModule*__ folder to the __*PowerShell/Modules*__ directory for your user. (`$env:PSModulePath` will reveal the location on your system.)  
Then at the prompt enter:  
```
Import-Module SizeModule
```  
Once imported the module will be available for all future sessions.  
The repository also contains my WIP PowerShell ToDoList app.
