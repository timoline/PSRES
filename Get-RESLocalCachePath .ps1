﻿Function Get-RESLocalCachePath 
{	
    [CmdletBinding()] 
    param()

    Write-Verbose "Getting RESLocalCachePath"

    $KeyPath = Get-RESRegistryPath
    if ((Get-ItemProperty $KeyPath).LocalCachePath) 
    {
        (Get-ItemProperty $KeyPath).LocalCachePath
    }
    Else 
    {
        $RESInstallDir =  Get-RESInstallDir
        $LocalCachePath = Join-Path $RESInstallDir "\data\DBcache"
        return $LocalCachePath 
    }   
}