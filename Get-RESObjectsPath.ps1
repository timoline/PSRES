﻿Function Get-RESObjectsPath 
{	
    [CmdletBinding()] 
    param()

    Write-Verbose "Getting RESObjectsPath"

    $LocalCachePath = Get-RESLocalCachePath
    $RESObjectsPath = Join-Path $LocalCachePath "Objects"
    return $RESObjectsPath
}