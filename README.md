This is my collection of PowerShell scripts, including my Get-Size module,  
which shows a more human readable size value when listing files and directories,  
inspired by the -h switch when using the BASH ls command.  

It bothers me that Get-ChildItem shows filenames in byte legths,  
quite useless at a glance, and in any case it only shows the length property for files.  

![Get-ChildItem output](https://github.com/user-attachments/assets/01b0e1f2-3c03-4d3b-8301-1f4203bdd526)

Get-Size gets the size of files AND folders, in an instantly understandable format;  

![Get-Size output](https://github.com/user-attachments/assets/45a5def4-015f-4646-bdaf-6a4082ca3ae5)

It respects the colour coding of files and folders, although shows the item type in the leftmost column  
in case the user's terminal colour settings don't differentiate between files and folders.  

You can pass multiple items in a comma separated list of symbols, e.g.  
"Get-Size D:\Audio, $HOME\Documents, myfile.txt"  
including variables storing a list of items, e.g.  
"Get-Size $mylist"  

The modifiable options are -SortProperty and -Descending/-Ascending.  
-Descending and -Ascending are simple switches; -SortProperty expects either Name or Size.  
By default it sorts by Size in -Ascending order, so you can leave out the -Ascending switch.  
The switches can be given in any order, e.g.  
"Get-Size -Descending -SortProperty Name", "Get-Size -SortProperty Name -Descending"  
Leaving out any filenames, variables or wildcards will default to showing the content of the current directory,  
the same way Get-ChildItem works.  
The following will all do the same thing:  
"Get-Size"  
"Get-Size -Ascending"  
"Get-Size -Ascending SortProperty Size"  
"Get-Size -Ascending SortProperty Size *"  

The repository also contains my WIP PowerShell ToDoList app.
