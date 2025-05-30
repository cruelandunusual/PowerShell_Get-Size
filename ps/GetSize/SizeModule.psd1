@{
    RootModule        = 'SizeModule.psm1'
    ModuleVersion     = '1.0.0'
    Author            = 'Peter Smith'
    Description       = 'A custom PowerShell module for displaying human readable sizes of objects'
    PowerShellVersion = '7.0'
    FunctionsToExport = 'Get-Size', 'Get-SizeScale'
    CmdletsToExport   = @()
    AliasesToExport   = @()
}