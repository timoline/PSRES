<#
    Author: Andrew Morgan (@Andyjmorgan on Twitter, http://www.andrewmorgan.ie)
    Enable and Disable RES Tracing for powerfuse / Workspace manager
    Version: 1.0
    Any comments/ feedback welcome, ping me on twitter, drop me a comment on the blog or via e-mail (andrew at andrewmorgan dot ie)
#>

<#
.SYNOPSIS
   Enable RES Tracing for RES Powerfuse / Workspace Manager
.DESCRIPTION
   Enable RES Tracing for RES Powerfuse / Workspace Manager, only on local computer
.EXAMPLE
   Enable-RESTracing 
.EXAMPLE
   Enable-RESTracing -Logfile "C:\TMP"
#>
Function Enable-RESTracing 
{
    [CmdletBinding()] 
    param 
    (
        [Parameter()]
        [String]
        $Logfile="c:\RESTrace.log"
    )
    Write-Verbose 'Enabling RESTracing'

    $Path = Get-RESRegistryPath

    #create registry items
    Set-ItemProperty -name "Trace" -Path $path -Value "Yes" -Verbose
    Set-ItemProperty -name "TraceDetailed" -Path $path -Value "Yes" -Verbose
    Set-ItemProperty -name "TraceFile" -Path $path -Value $Logfile -Verbose

    #stop, wait and start the service
    (Get-Service | where {$_.name -eq "RES"}).stop()
    (Get-Service | where {$_.name -eq "RES"}).WaitForStatus("Stopped")
    (Get-Service | where {$_.name -eq "RES"}).start()
    (Get-Service | where {$_.name -eq "RES"}).WaitForStatus("Running")

    #Set the acl to allow users write:
    $acl = Get-Acl $Logfile
    $permission = "Everyone","FullControl","Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($accessRule)
    $acl | Set-Acl $Logfile

    #error checking
    if (!(Test-Path $LogFile))
    {
        Write-Error "Log file ($Logfile) does not exist!"
    }
    
    Write-Verbose 'RESTracing is enabled.'
} #end Function