Function Get-RESLocalCachePath {	
    $KeyPath = Get-RESRegistryPath
    if ((Get-ItemProperty $KeyPath).LocalCachePath) 
    {
        (Get-ItemProperty $KeyPath).LocalCachePath
    }
    Else 
    {
        $RESInstallDir =  Get-RESInstallDir
        $LocalCachePath = Join-Path $RESInstallDir "\data\DBcache"
        $LocalCachePath 
    }   
}