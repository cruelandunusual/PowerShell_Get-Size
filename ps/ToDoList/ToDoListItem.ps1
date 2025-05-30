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



<# ------------------------------------------------------------------------------- #>

class ToDoList {
    # Static property to hold the list of ListItems
    static [System.Collections.Generic.List[ToDoListItem]] $ListItems
    # Static method to initialize the list of ListItems. Called in the other
    # static methods to avoid needing to explicit initialize the value.
    static [void] Initialize() {
        [ToDoList]::Initialize($false)
    }
    static [bool] Initialize([bool]$Force) {
        if ([ToDoList]::ListItems.Count -gt 0 -and -not $Force) {
            return $false
        }
        [ToDoList]::ListItems = [System.Collections.Generic.List[ToDoListItem]]::new()
        return $true
    }
    # Ensure a book is valid for the list.
    static [void] Validate([ToDoListItem]$ToDoListItem) {
        $Prefix = @(
            'ToDoListItem validation failed: ToDoListItem must be defined with the Title,'
            'Author, and PublishDate properties, but'
        ) -join ' '
        if ($null -eq $ToDoListItem) { throw "$Prefix was null" }
        if ([string]::IsNullOrEmpty($ToDoListItem.Title)) {
            throw "$Prefix Title wasn't defined"
        }
        if ([string]::IsNullOrEmpty($ToDoListItem.Author)) {
            throw "$Prefix Author wasn't defined"
        }
        if ([datetime]::MinValue -eq $ToDoListItem.PublishDate) {
            throw "$Prefix PublishDate wasn't defined"
        }
    }
    # Static methods to manage the list of ListItems.
    # Add a book if it's not already in the list.
    static [void] Add([ToDoListItem]$ToDoListItem) {
        [ToDoList]::Initialize()
        [ToDoList]::Validate($ToDoListItem)
        if ([ToDoList]::ListItems.Contains($ToDoListItem)) {
            throw "ToDoListItem '$ToDoListItem' already in list"
        }

        $FindPredicate = {
            param([ToDoListItem]$b)

            $b.Title -eq $ToDoListItem.Title -and
            $b.Author -eq $ToDoListItem.Author -and
            $b.PublishDate -eq $ToDoListItem.PublishDate
        }.GetNewClosure()
        if ([ToDoList]::ListItems.Find($FindPredicate)) {
            throw "ToDoListItem '$ToDoListItem' already in list"
        }

        [ToDoList]::ListItems.Add($ToDoListItem)
    }
    # Clear the list of ListItems.
    static [void] Clear() {
      [ToDoList]::Initialize()
      [ToDoList]::ListItems.Clear()
    }
    # Find a specific book using a filtering scriptblock.
    static [ToDoListItem] Find([scriptblock]$Predicate) {
        [ToDoList]::Initialize()
        return [ToDoList]::ListItems.Find($Predicate)
    }
    # Find every book matching the filtering scriptblock.
    static [ToDoListItem[]] FindAll([scriptblock]$Predicate) {
        [ToDoList]::Initialize()
        return [ToDoList]::ListItems.FindAll($Predicate)
    }
    # Remove a specific book.
    static [void] Remove([ToDoListItem]$ToDoListItem) {
        [ToDoList]::Initialize()
        [ToDoList]::ListItems.Remove($ToDoListItem)
    }
    # Remove a book by property value.
    static [void] RemoveBy([string]$Property, [string]$Value) {
        [ToDoList]::Initialize()
        $Index = [ToDoList]::ListItems.FindIndex({
            param($b)
            $b.$Property -eq $Value
        }.GetNewClosure())
        if ($Index -ge 0) {
            [ToDoList]::ListItems.RemoveAt($Index)
        }
    }
}



function doNothing () {
    $scriptBlock = {
        return $true
    }
}

write-output $scriptBlock