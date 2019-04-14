<#
.SYNOPSIS
   Shows the install directory from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the install directory from RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESInstallDir
#>
Function Get-RESInstallDir 
{
    [CmdletBinding()] 
    param()

    Write-Verbose "Getting RESInstallDir"

    $KeyPath = Get-RESRegistryPath
    if ((Get-ItemProperty $KeyPath).InstallDir) 
    {
        (Get-ItemProperty $KeyPath).InstallDir
    }
    Else 
    {
        Get-Content env:RESPFDIR
    }	   
}