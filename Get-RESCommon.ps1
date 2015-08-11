function Get-ParamSW 
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
    $Value = Get-RESServerGroups -ServerGroup $ServerGroup
    return $Value.servers.node."#text" 
}

function Get-RESMenuPath
{
    [CmdletBinding()] 
    param ( 

        # The AppID
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string] 
        $AppID       
    )
    begin 
    {
        $LocalCachePath = Get-RESLocalCachePath

        $PwfObjectPath = Join-Path $LocalCachePath "Objects"
        $XmlMenuTree   = Join-Path $PwfObjectPath "menutree.xml"
        $XmlAppMenu   = Join-Path $PwfObjectPath "app_menus.xml"
        
        $XPathMenuTree = "//app"
        $XPathAppMenu = "//applicationmenu"
        
        Function Get-ParentPath 
        {
            $Result = "App"
            $Node = $_.ParentNode
            $Guid = $Node.Guid
            $Result = $TblAppMenu[[string]$Guid] + '\' + $Result
            
            while ($Node.ParentNode)
            {
                $Node = $Node.ParentNode
                $Guid = $Node.Guid
                $Result = $TblAppMenu[[string]$Guid] + '\' + $Result
            }
            $Result
        }   
    }    
    process 
    {

        Select-Xml -Path $XmlAppMenu -XPath $XPathAppMenu | 
            Select-Object -ExpandProperty node |
            Foreach-Object -begin {$TblAppMenu = @{}} -process {$TblAppMenu[$_.guid] = $_.title}        

        Select-Xml -Path $XmlMenuTree -XPath  $XPathMenuTree | 
            Select-Object -ExpandProperty node |
            Foreach-Object -begin {$TblMenuPath = @{}} -process {$TblMenuPath[$_.appid] = Get-ParentPath $_}        
    }
    end 
    {                         
        return $TblMenuPath[[string]$AppID] -replace '\\App$',''             
    }
    
}