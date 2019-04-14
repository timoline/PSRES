<#
.SYNOPSIS
   Shows the version of RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the version of RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESVersion
#>
Function Get-RESVersion 
{
    [CmdletBinding()] 
    param()
    Write-Verbose "Getting RESVersion"

    $KeyPath = Get-RESRegistryPath

    $Version = (Get-ItemProperty $KeyPath).Version 
    $UpgradeLevel = (Get-ItemProperty $KeyPath).UpgradeLevel 
    $StartLevel = (Get-ItemProperty $KeyPath).StartLevel
    $StartVersion = (Get-ItemProperty $KeyPath).StartVersion
    $SubRevision = (Get-ItemProperty $KeyPath).SubRevision 

    $Prop = @{
        Version      = $Version
        UpgradeLevel = $UpgradeLevel
        StartLevel   = $StartLevel
        StartVersion = $StartVersion
        SubRevision  = $SubRevision
    }
    New-Object PSObject -property $Prop     
}
