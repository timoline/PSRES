<#
pwrtech.exe /serverremove=<servername> /group=<servergroup>
Removes a Citix server from a specific group. 
Example: “%programfiles%\res Workspace Manager\pwrtech.exe” /serverremove=CTX10 /group=CTXServerGroup

pwrtech.exe /serverremove=<servername> /group=*
Removes specified server from ALL groups at once. 
Example: “%programfiles%\res Workspace Manager\pwrtech.exe” /serverremove=CTX10 /group=*
#>
<#
.Synopsis
   Removes a Citix server from a specific RES ServerGroup
.DESCRIPTION
   Removes a Citix server from a specific RES ServerGroup
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Remove-RESServerFromServerGroup
{
    [CmdletBinding()]
    Param
    (
        # Servername
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [Alias("ComputerName")] 
        [string[]]
        $Server,

        # Servergroup
        [parameter(Position=1, Mandatory=$true)]
        [Alias("Group")]
        [string]
        $ServerGroup
    )

    Process
    {
        $RESPFDIR =  Get-RESInstallDir
        $pwrtech = Join-Path $RESPFDIR "pwrtech.exe"

        Foreach ($Srv in $Server) 
        {
            $ServerArg = "/serverremove=$Srv"
            $ServerGroupArg = "/group=$ServerGroup"
  
            & $pwrtech $ServerArg $ServerGroupArg 
            #Write-Host $pwrtech $ServerArg $ServerGroupArg  
        }
    }#Process

}