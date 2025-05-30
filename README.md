This is my collection of PowerShell scripts, including my Get-Size module,
which shows a more human readable size value when listing files and directories, inspired
by the bash switch -h when using the ls command.

It bothers me that PowerShell shows filenames in byte legths,
quite useless at a glance, and in any case it only shows the length property for folders.

![Get-ChildItem output](https://github.com/user-attachments/assets/01b0e1f2-3c03-4d3b-8301-1f4203bdd526)


Get-Size gets the size of a file or folder;

You can pass multiple items in a comma separated list of symbols,

e.g. Get-Size D:\Audio, $HOME\Documents, myfile.txt

including variables storing a list of items, e.g. Get-Size $mylist

![Get-Size output](https://github.com/user-attachments/assets/45a5def4-015f-4646-bdaf-6a4082ca3ae5)

It respects the colour coding of files and folders, although shows the item type in the left most column in case the user's terminal colour settings don't differentiate between files and folders.


The repository also contains my WIP PowerShell ToDoList app.
