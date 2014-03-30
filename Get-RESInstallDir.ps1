Function Get-RESInstallDir {
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