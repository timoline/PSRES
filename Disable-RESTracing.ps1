<#
.Synopsis
   Disable RES Tracing for RES Powerfuse / Workspace Manager
.DESCRIPTION
   Disable RES Tracing for RES Powerfuse / Workspace Manager, only on local computer
.EXAMPLE
   Disable-RESTracing
#>
Function Disable-RESTracing 
{
[CmdletBinding()] 
    param 
    (

    )
    Write-Verbose 'Disabling RESTracing'
    
    $Path = Get-RESRegistryPath

    if ((Get-ItemProperty $path).trace) 
    {
        Remove-ItemProperty -Name "Trace" -Path $path -Verbose
    }
    Else 
    {
        Write-Warning "Trace key missing"
    }

    if ((Get-ItemProperty $path).tracedetailed) 
    {
        Remove-ItemProperty -Name "TraceDetailed" -Path $path -Verbose
    }
    Else 
    {
        Write-Warning "Tracedetailed key missing"
    }

    if ((Get-ItemProperty $path).TraceFile) 
    {
        Remove-ItemProperty -Name "Tracefile" -Path $path -Verbose
    }
    Else 
    {
        Write-Warning "Tracefile key missing"
    }

    #stop, wait and start the service
    (Get-Service | where {$_.name -eq "RES"}).stop()
    (Get-Service | where {$_.name -eq "RES"}).WaitForStatus("Stopped")
    (Get-Service | where {$_.name -eq "RES"}).start()
    (Get-Service | where {$_.name -eq "RES"}).WaitForStatus("Running")

    Write-Verbose 'RESTracing is disabled.'
} #end Function