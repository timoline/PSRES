<#
.SYNOPSIS
   Shows the substitutes from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the substitutes from RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESSubst
#>
function Get-RESSubst 
{
    [CmdletBinding()] 
    param ( 
        # The VirtualDrive 
        [Parameter()]
        [string] 
        $VirtualDrive = "*",

        # subst disabled 
        [Switch]
        $Disabled        
    
    )

    begin 
    {
        $RESObjectsPath = Get-RESObjectsPath
        $Xml = Join-Path $RESObjectsPath "pl_subst.xml"
        $XPath = "//substitute"
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
       
                $virtualdrive = select-xml -xml $Node -XPath './virtualdrive' 
                $path = select-xml -xml $Node -XPath './/path'
                $description = select-xml -xml $Node -XPath './/description'
                $state = select-xml -xml $Node -XPath './/state'
                $hidedrive = select-xml -xml $Node -XPath './/hidedrive'              
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
                    virtualdrive     = $virtualdrive
                    path             = $path
                    description      = $description
                    state            = $state
                    hidedrive        = $hidedrive
                    accesscontrol    = $accesscontrol
                    workspacecontrol = $workspacecontrol
                    guid             = $guid   
                    updateguid       = $updateguid
                    parentguid       = $parentguid                 
                    enabled          = $enabled
                    objectdesc       = $objectdesc
                    order            = $order                
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
                Where-Object {$_.virtualdrive -like $virtualdrive} |               
                Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} 
        }            
    }
}