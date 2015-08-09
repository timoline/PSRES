﻿function Get-ParamSW 
{
    [CmdletBinding()] 
    param ( 
        # The Parameter of the switch
        [Parameter()]
        [string] 
        $Paramsw,
        
        # The Value of the switch
        [Parameter()]
        [string] 
        $Value 
    
    )
    process 
    {
        if ($Paramsw -eq $true)
        { 
            return $Value
        } 
        else 
        {
            return $null
        }  
    }#process 
}

Filter Get-RESWorkspaceName
{
    [CmdletBinding()] 
    param ( 
        # The guid 
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] 
        $Guid       
    )
    #$Guid = "{E536D09E-3DA0-464A-84A5-F520C43C1429}"
    $Value = Get-RESWorkspaces -Guid $Guid     
    return $Value.name.node."#text" 
}

Filter Get-RESPowerzoneName
{
    [CmdletBinding()] 
    param ( 
        # The guid 
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] 
        $Guid       
    )
    #$Guid = "{EF0E53B1-B968-48EF-8089-C3ABB154E34F}"
    $Value = Get-RESPowerzones -Guid $Guid 
    return $Value.name.node."#text" 
}

Filter Get-RESServerGroupServers
{
    [CmdletBinding()] 
    param ( 
        # The ServerGroup 
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [alias('Name','Objectdesc')]  
        [string] 
        $ServerGroup       
    )
    $Value = Get-RESServerGroups -Objectdesc $ServerGroup
    $Value.servers.node."#text" 
}