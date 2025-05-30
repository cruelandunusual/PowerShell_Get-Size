<#
To do list in PowerShell
This is very much a work in progress
#>
class ToDoListItem {
    # Class properties
    [int]      $Index # required, created automatically on creation
    [string]   $Name # required, but can default to item1, item2, etc.
    [string]   $Content # default empty
    [string]   $Priority # default medium [low, medium, high]
    [string]   $Status # default pending
    [datetime] $DueDate # default empty
    [datetime] $DateAdded # default to time at creation
    [string[]] $Tags # default empty [list of subject areas]

    # Default constructor
    ToDoListItem() {
        $this.Init(@{})
    }
    # Convenience constructor from hashtable
    ToDoListItem([hashtable]$Properties) {
        $this.Init($Properties)
    }
    # Common constructor for title and author
    ToDoListItem([string]$Name, [string]$Content) {
        $this.Init(@{Name = $Name; Content = $Content })
    }

    # Shared initializer method
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }

    [string] GetName() {
        return $this.Name
    }

    [string] GetContent() {
        return $this.Content
    }

    [string] GetPriority() {
        return $this.Priority
    }

    [string] GetStatus() {
        return $this.Status
    }

    [datetime] GetDueDate() {
        return $this.DueDate
    }

    [bool] IsOverdue() {
        return (Get-Date) -gt $this.DueDate
    }

    # Method to return a string representation of the list item
    [string] ToString() {
        return "$($this.Name), priority: $($this.Priority), $($this.DueDate)"
    }

    WriteFile() {
        New-Item -ItemType File -Name $this.Name".txt"
        $file = Get-Item -Path $this.Name
        Set-Content -Path $file -Value $this.Content
    }
}

<#
[string]   $Name # required, but can default to item1, item2, etc.
[string]   $Content # default empty
[string]   $Priority # default medium [low, medium, high]
[string]   $Status # default ongoing [ongoing, completed]
[datetime] $DueDate # default empty
[datetime] $DateAdded # default to time at creation
[string[]] $Tags # default empty [list of subject areas]
#>

$ListItem_01 = [ToDoListItem]::new(@{
    Name         = 'My first list item'
    Content      = 'Write a full module for creating PowerShell to-do lists'
    Priority     = 'Medium'
    Status       = 'Ongoing'
    DueDate      = '2025-05-21'
    DateAdded    = Get-Date
    Tags         = @('Programming', 'PowerShell')
})

$ListItem_01
$Name = $ListItem_01.GetName()
$Priority = $ListItem_01.GetPriority()
# <#"To do list item#> "$Name has $Priority priority"
$ListItem_01.IsOverdue()
$ListItem_01.WriteFile()



function New-ToDoListItem($name) {
    $ListItem_01 = [ToDoListItem]::new(@{
            Name      = $name
        })
        return $ListItem_01
}
