Function Get-RESRegistryPath 
{	
	if ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -like "64*")
    {
        #64bit
        if (Test-Path "HKLM:\SOFTWARE\Wow6432Node\RES\Workspace Manager")
        {
            $path = "HKLM:\SOFTWARE\Wow6432Node\RES\Workspace Manager"
        }
        Elseif (Test-Path "HKLM:\SOFTWARE\Wow6432Node\RES\PowerFuse")
        {
            $path ="HKLM:\SOFTWARE\Wow6432Node\RES\PowerFuse"
        }
        Else 
        {
            Write-Warning "Couldn't locate the registry keys for RES Powerfuse / Workspace Manager"
            break
        }
    }#end if
    Else 
    {
        #32bit
        if (Test-Path "HKLM:\SOFTWARE\RES\Workspace Manager")
        {
            $path = "HKLM:\SOFTWARE\RES\Workspace Manager"
        }
        Elseif (Test-Path "HKLM:\SOFTWARE\RES\PowerFuse")
        {
            $path ="HKLM:\SOFTWARE\RES\PowerFuse"
        }
        Else 
        {
            Write-Warning "Couldn't locate the registry keys for RES Powerfuse / Workspace Manager"
            break
        }
    } #end else

    if (Test-Path $path)
    {
        Return $path
    } #end if   
}

