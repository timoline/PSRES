<#
.SYNOPSIS
   Shows the registry path from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the registry path from RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESRegistryPath
#>
Function Get-RESRegistryPath 
{	
    [CmdletBinding()] 
    param()

    if ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -like "64*")
    {
        Write-Verbose "OSArchitecture is 64-bit"
       
        if (Test-Path "HKLM:\SOFTWARE\Wow6432Node\RES\Workspace Manager")
        {
            $Path = "HKLM:\SOFTWARE\Wow6432Node\RES\Workspace Manager"
        }
        Elseif (Test-Path "HKLM:\SOFTWARE\Wow6432Node\RES\PowerFuse")
        {
            $Path = "HKLM:\SOFTWARE\Wow6432Node\RES\PowerFuse"
        }
        Else 
        {
            Write-Warning "Couldn't locate the registry keys for RES Powerfuse / Workspace Manager"
            break
        }
    }#end if
    Else 
    {
        Write-Verbose "OSArchitecture is 32-bit"
        
        if (Test-Path "HKLM:\SOFTWARE\RES\Workspace Manager")
        {
            $Path = "HKLM:\SOFTWARE\RES\Workspace Manager"
        }
        Elseif (Test-Path "HKLM:\SOFTWARE\RES\PowerFuse")
        {
            $Path = "HKLM:\SOFTWARE\RES\PowerFuse"
        }
        Else 
        {
            Write-Warning "Couldn't locate the registry keys for RES Powerfuse / Workspace Manager"
            break
        }
    } #end else

    if (Test-Path $Path)
    {
        Return $Path
    } #end if   
}

