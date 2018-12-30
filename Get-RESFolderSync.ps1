<#
.SYNOPSIS
   Shows the FolderSync from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the FolderSync from RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESFolderSync -disabled 
    Shows the disabled FolderSync
#>
function Get-RESFolderSync
{
    [CmdletBinding()] 
    param ( 
        # The Description 
        [Parameter()]
        [string] 
        $Description = "*",

        # reg disabled 
        [Switch]
        $Disabled        
    
    )

    begin 
    {
        $RESObjectsPath = Get-RESObjectsPath
        $Xml = Join-Path $RESObjectsPath "pl_fsync.xml"
        $XPath = "//foldersync"
    }

    process 
    {

        Function Get-RESData
        {
            [CmdletBinding()]
            param 
            ( 
                [parameter(Mandatory = $true, ValueFromPipeline = $true)] 
                $Node 
            )
            process 
            {
                $description = select-xml -xml $Node -XPath './description'                          
                $localfolder = select-xml -xml $Node -XPath './/localfolder'
                $remotefolder = select-xml -xml $Node -XPath './/remotefolder'  
                $direction = select-xml -xml $Node -XPath './/direction'                               
                $runatapplicationstart = select-xml -xml $Node -XPath './/runatapplicationstart'
                $runatapplicationend = select-xml -xml $Node -XPath './/runatapplicationend'
                $runatlogon = select-xml -xml $Node -XPath './/runatlogon'
                $runatrefresh = select-xml -xml $Node -XPath './/runatrefresh'
                $runatreconnect = select-xml -xml $Node -XPath './/runatreconnect'
                $runatlogoff = select-xml -xml $Node -XPath './/runatlogoff'
                $runatinterval = select-xml -xml $Node -XPath './/runatinterval'  
                $waitforsync = select-xml -xml $Node -XPath './/waitforsync'                               
                $excludereadonly = select-xml -xml $Node -XPath './/excludereadonly'
                $excludehiddenfiles = select-xml -xml $Node -XPath './/excludehiddenfiles'
                $excludesystemfiles = select-xml -xml $Node -XPath './/excludesystemfiles'
                $saveinrecyclebin = select-xml -xml $Node -XPath './/saveinrecyclebin'
                $state = select-xml -xml $Node -XPath './/runatreconnect'
                             
                $guid = select-xml -xml $Node -XPath './/guid'
                $updateguid = select-xml -xml $Node -XPath './/updateguid'
                $parentguid = select-xml -xml $Node -XPath './/parentguid'
                $enabled = select-xml -xml $Node -XPath './/enabled' 
                $objectdesc = select-xml -xml $Node -XPath './/objectdesc' 
                $order = select-xml -xml $Node -XPath './/order' 

                $workspace = select-xml -xml $Node -XPath './/workspacecontrol/workspace' 
                $workspacecontrol = New-Object PSObject -property @{
                    workspace = $workspace
                }

                $type = select-xml -xml $Node -XPath './/accesscontrol/access/type'
                $object = select-xml -xml $Node -XPath './/accesscontrol/access/object'
                $domain = select-xml -xml $Node -XPath './/accesscontrol/access/domain'
                $inheritance = select-xml -xml $Node -XPath './/accesscontrol/access/inheritance'
                $accesscontrol = New-Object PSObject -property @{
                    type        = $type
                    object      = $object
                    domain      = $domain
                    inheritance = $inheritance
                }

                $Prop = @{
                    description           = $description       
                    localfolder           = $localfolder
                    remotefolder          = $remotefolder
                    direction             = $direction             
                    runatapplicationstart = $runatapplicationstart
                    runatapplicationend   = $runatapplicationend
                    runatlogon            = $runatlogon
                    runatrefresh          = $runatrefresh
                    runatreconnect        = $runatreconnect
                    runatlogoff           = $runatlogoff
                    runatinterval         = $runatinterval
                    waitforsync           = $waitforsync             
                    excludereadonly       = $excludereadonly
                    excludehiddenfiles    = $excludehiddenfiles
                    excludesystemfiles    = $excludesystemfiles
                    saveinrecyclebin      = $saveinrecyclebin
                    state                 = $state

                    accesscontrol         = $accesscontrol
                    workspacecontrol      = $workspacecontrol
                    guid                  = $guid   
                    updateguid            = $updateguid
                    parentguid            = $parentguid                 
                    enabled               = $enabled
                    objectdesc            = $objectdesc
                    order                 = $order                
                }

                $Result = New-Object PSObject -property $Prop

                return $Result
            }
        }

    }#process

    end 
    {
        $Node = Select-Xml -Path $Xml -XPath $XPath | Select-Object -ExpandProperty node 

        if ($Node)
        {
            $Node |
                Get-RESData | 
                Where-Object {$_.Description -like $Description} |               
                Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} 
        }            
    }
}