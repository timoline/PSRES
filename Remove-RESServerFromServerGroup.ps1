<#
pwrtech.exe /serverremove=<servername> /group=<servergroup>
Removes a Citix server from a specific group. 
Example: “%programfiles%\res Workspace Manager\pwrtech.exe” /serverremove=CTX10 /group=CTXServerGroup

pwrtech.exe /serverremove=<servername> /group=*
Removes specified server from ALL groups at once. 
Example: “%programfiles%\res Workspace Manager\pwrtech.exe” /serverremove=CTX10 /group=*
#>
<#
.SYNOPSIS
   Removes a Citix server from a specific RES ServerGroup
.DESCRIPTION
   Removes a Citix server from a specific RES ServerGroup
.EXAMPLE
   Remove-RESServerFromServerGroup
#>
function Remove-RESServerFromServerGroup
{
    [CmdletBinding()]
    Param
    (
        # Servername
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true)]
        [Alias("ComputerName")] 
        [string]
        $Server,

        # Servergroup
        [parameter(Position=1, Mandatory=$true)]
        [Alias("Group")]
        [string]
        $ServerGroup
    )

    Process
    {
        Write-Verbose "Starting to remove a Server From a RESServerGroup"
        $RESPFDIR =  Get-RESInstallDir
        $pwrtech = Join-Path $RESPFDIR "pwrtech.exe"

        Write-Verbose "Remove Server $Server from RESServerGroup $ServerGroup"
        $ServerArg = "/serverremove=$Server"
        $ServerGroupArg = "/group=$ServerGroup"
  
        & $pwrtech $ServerArg $ServerGroupArg 
        #Write-Host $pwrtech $ServerArg $ServerGroupArg         
    }#Process
}