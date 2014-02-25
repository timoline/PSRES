<#
.Synopsis
   Disable RES Tracing for RES Powerfuse / Workspace Manager
.DESCRIPTION
   Disable RES Tracing for RES Powerfuse / Workspace Manager
.EXAMPLE
   Disable-RESTracing
#>
Function Disable-RESTracing {
[CmdletBinding()] 
param (
    # The name of the computer to connect to.
    [Parameter(Position=0, Mandatory=$true)]
    [String]
    $ComputerName,
    
    # The credential used to connect
    [Management.Automation.PSCredential]
    $Credential
)
    Write-Verbose 'Disabling RESTracing'
     #check OS and get paths
    if ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -eq "64-bit"){
        #64bit
        if (Test-Path "HKLM:\SOFTWARE\Wow6432Node\RES\Workspace Manager"){
            $path = "HKLM:\SOFTWARE\Wow6432Node\RES\Workspace Manager"}
        Elseif (Test-Path "HKLM:\SOFTWARE\Wow6432Node\RES\PowerFuse"){
            $path ="HKLM:\SOFTWARE\Wow6432Node\RES\PowerFuse"}
        Else {
            Write-Warning "Couldn't locate the registry keys for RES Powerfuse / Workspace Manager"
            break}
    }#end if
    Else {
        #32bit
        if (Test-Path "HKLM:\SOFTWARE\RES\Workspace Manager"){
            $path = "HKLM:\SOFTWARE\RES\Workspace Manager"}
        Elseif (Test-Path "HKLM:\SOFTWARE\RES\PowerFuse"){
            $path ="HKLM:\SOFTWARE\RES\PowerFuse"}
        Else {
            Write-Warning "Couldn't locate the registry keys for RES Powerfuse / Workspace Manager"
            break}
    } #end else

    if (!(Test-Path $path)){
        write-Error "The path Provided must exist"
        Break
    } #end if

    if ((Get-ItemProperty $path).trace) {
        Remove-ItemProperty -Name "Trace" -Path $path -Verbose}
    Else {Write-Warning "Trace key missing"}

    if ((Get-ItemProperty $path).tracedetailed) {
        Remove-ItemProperty -Name "TraceDetailed" -Path $path -Verbose}
    Else {Write-Warning "Tracedetailed key missing"}

    if ((Get-ItemProperty $path).TraceFile) {
        Remove-ItemProperty -Name "Tracefile" -Path $path -Verbose}
    Else {Write-Warning "Tracefile key missing"}

    #stop, wait and start the service
    (Get-Service | where {$_.name -eq "RES"}).stop()
    (Get-Service | where {$_.name -eq "RES"}).WaitForStatus("Stopped")
    (Get-Service | where {$_.name -eq "RES"}).start()
    (Get-Service | where {$_.name -eq "RES"}).WaitForStatus("Running")

    Write-Verbose 'RESTracing is disabled.'
} #end Function