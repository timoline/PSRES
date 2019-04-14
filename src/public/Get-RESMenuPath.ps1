function Get-RESMenuPath
{
    [CmdletBinding()] 
    param ( 

        # The AppID
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] 
        $AppID       
    )
    begin 
    {
        $RESObjectsPath = Get-RESObjectsPath
        $XmlMenuTree = Join-Path $RESObjectsPath "menutree.xml"
        $XmlAppMenu = Join-Path $RESObjectsPath "app_menus.xml"
        
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
        return $TblMenuPath[[string]$AppID] -replace '\\App$', ''             
    }
    
}