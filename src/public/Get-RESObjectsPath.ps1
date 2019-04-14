<#
.SYNOPSIS
   Shows the objects path from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the objects path from RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESObjectsPath
#>
Function Get-RESObjectsPath 
{	
    [CmdletBinding()] 
    param()

    Write-Verbose "Getting RESObjectsPath"

    $LocalCachePath = Get-RESLocalCachePath
    $RESObjectsPath = Join-Path $LocalCachePath "Objects"
    return $RESObjectsPath
}
