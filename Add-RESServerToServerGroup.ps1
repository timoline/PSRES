<#
pwrtech.exe /serveradd=<servername> /group=<servergroup>
The above command will add a Citrix server to a group. 
Example: “%programfiles%\res Workspace Manager\pwrtech.exe” /serveradd=CTX10 /group=CTXServerGroup
#>
<#
.Synopsis
   Add a Citrix server to a RES ServerGroup
.DESCRIPTION
   Add a Citrix server to a RES ServerGroup
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Add-RESServerToServerGroup
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
            $ServerArg = "/serveradd=$Srv"
            $ServerGroupArg = "/group=$ServerGroup"
  
            & $pwrtech $ServerArg $ServerGroupArg 
            #Write-Host $pwrtech $ServerArg $ServerGroupArg  
        }
    }
}