<#
.Synopsis
   Forcing a local cache update for Workspace Manager / PowerFuse.
.DESCRIPTION
   Forcing a local cache update for Workspace Manager / PowerFuse.
.EXAMPLE
   Update-RESLocalCache -ComputerName "SRV0001"
#>
function Update-RESLocalCache 
{
    [CmdletBinding()] 
    param 
    (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true)]	
        [Alias("CN","ComputerName","__SERVER")] 
        [string]
        $Server  
    )

    Process
    {
        Write-Verbose 'Forcing a local cache update for RES Powerfuse / Workspace Manager.'

        $ResPath = (Get-RESRegistryPath).Substring(6) 
        $RegKey = "UpdateGUIDs"

        $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Server ) 
        $RegistryKey = $Registry.OpenSubKey($ResPath,$true)       
        $RegistryKey.DeleteSubKeyTree($RegKey)
        Write-Verbose "Deleting key."

        #stop, wait and start the service
        (Get-Service -ComputerName $Server | where {$_.name -eq "RES"}).stop()
        (Get-Service -ComputerName $Server | where {$_.name -eq "RES"}).WaitForStatus("Stopped")
        Write-Verbose 'RES Service Stopped.'        
        
        (Get-Service -ComputerName $Server | where {$_.name -eq "RES"}).start()
        (Get-Service -ComputerName $Server | where {$_.name -eq "RES"}).WaitForStatus("Running")
        Write-Verbose 'RES Service Started.'
    
        Write-Verbose 'Local cache update for RES Powerfuse / Workspace Manager is succefully forced.'
    }
 }