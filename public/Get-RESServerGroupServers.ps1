Filter Get-RESServerGroupServers
{
    [CmdletBinding()] 
    param ( 
        # The ServerGroup 
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [alias('Name', 'Objectdesc')]  
        [string] 
        $ServerGroup       
    )
    $Value = Get-RESServerGroups -ServerGroup $ServerGroup | select -ExpandProperty servers
    return $Value.server.node."#text" 
}