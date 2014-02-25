<#
.Synopsis
   Forcing a local cache update for Workspace Manager / PowerFuse.
.DESCRIPTION
   Forcing a local cache update for Workspace Manager / PowerFuse.
.EXAMPLE
   Update-RESLocalCache -ComputerName "SRV0001"
#>
function Update-RESLocalCache {
[CmdletBinding()] 
param (
[Parameter(
	Position=0,
    Mandatory = $true,
	ValueFromPipeline=$true,
	ValueFromPipelineByPropertyName=$true
)]		
[Alias("CN","__SERVER","IPAddress")]
[string[]]$ComputerName=""   
)
    foreach($c in $ComputerName)
    {	
        Write-Verbose 'Forcing a local cache update for RES Powerfuse / Workspace Manager.'

        $ResPath = (Get-RESRegistryPath).Substring(6) 
        $RegKey = "UpdateGUIDs"

        $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $c ) 
        $RegistryKey = $Registry.OpenSubKey($ResPath,$true)       
        $RegistryKey.DeleteSubKeyTree($RegKey)
        Write-Verbose "Deleting key."

        #stop, wait and start the service
        (Get-Service -ComputerName $c | where {$_.name -eq "RES"}).stop()
        (Get-Service -ComputerName $c | where {$_.name -eq "RES"}).WaitForStatus("Stopped")
        Write-Verbose 'Service Stopped.'        
        
        (Get-Service -ComputerName $c | where {$_.name -eq "RES"}).start()
        (Get-Service -ComputerName $c | where {$_.name -eq "RES"}).WaitForStatus("Running")
        Write-Verbose 'Service Started.'
    
        Write-Verbose 'Local cache update for RES Powerfuse / Workspace Manager is succefully forced.'
    }
 }