@{
    # Module manifest for module 'PSRES'

    # MODULE
    ModuleToProcess        = 'PSRES.psm1'    # Script module or binary module file associated with this manifest
    ModuleVersion          = '2.0'
    GUID                   = '44232733-b480-4ec4-b56b-9d6f4ea2de9a'
    Description            = 'Defines common RES functions'

    # AUTHOR
    Author                 = 'M.Timmers'
    CompanyName            = 'Borg'
    Copyright              = 'Copyright 2014. All rights reserved.'

    # CONTENTS
    ScriptsToProcess       = @()            # Script files (.ps1) that are run in the caller's environment prior to importing this module
    NestedModules          = @()            # Modules to import as nested modules of the module specified in ModuleToProcess
    TypesToProcess         = @()            # Type files (.ps1xml) to be loaded when importing this module
    FormatsToProcess       = @()            # Format files (.ps1xml) to be loaded when importing this module

    # EXPORTS
    FunctionsToExport      = '*'            # Functions to export from this module
    CmdletsToExport        = '*'            # Cmdlets to export from this module
    VariablesToExport      = '*'            # Variables to export from this module
    AliasesToExport        = '*'            # Aliases to export from this module

    # REQUIREMENTS
    PowerShellVersion      = '2.0'          # Minimum version of the Windows PowerShell engine required by this module
    PowerShellHostName     = ''             # Name of the Windows PowerShell host required by this module
    PowerShellHostVersion  = ''             # Minimum version of the Windows PowerShell host required by this module
    DotNetFrameworkVersion = ''             # Minimum version of the .NET Framework required by this module
    CLRVersion             = '2.0.50727'    # Minimum version of the common language runtime (CLR) required by this module
    ProcessorArchitecture  = ''             # Processor architecture (None, X86, Amd64, IA64) required by this module
    RequiredModules        = @()            # Modules that must be imported into the global environment prior to importing this module
    RequiredAssemblies     = @()            # Assemblies that must be loaded prior to importing this module
}
