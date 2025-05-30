class ToDoList {
    # Static property to hold the list of ListItems
    static [System.Collections.Generic.List[ToDoListItem]] $ListItems
    # Static method to initialize the list of ListItems. Called in the other
    # static methods to avoid needing to explicit initialize the value.
    static [void] Initialize()             { [ToDoList]::Initialize($false) }
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
            'Priority, and Due Date properties, but'
        ) -join ' '
        if ($null -eq $ToDoListItem) { throw "$Prefix was null" }
        if ([string]::IsNullOrEmpty($ToDoListItem.Name)) {
            throw "$Prefix Name wasn't defined"
        }
        if ([string]::IsNullOrEmpty($ToDoListItem.Priority)) {
            throw "$Prefix Priority wasn't defined"
        }
        if ([datetime]::MinValue -eq $ToDoListItem.DueDate) {
            throw "$Prefix Due Date wasn't defined"
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

            $b.Title -eq $ToDoListItem.Name -and
            $b.Author -eq $ToDoListItem.Priority -and
            $b.PublishDate -eq $ToDoListItem.DueDate
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