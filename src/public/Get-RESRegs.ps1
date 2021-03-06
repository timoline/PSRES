﻿<#
.SYNOPSIS
   Shows the registry settings from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the registry settings  from RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESRegs
#>
function Get-RESRegs 
{
    [CmdletBinding()] 
    param ( 
        # The Name 
        [Parameter()]
        [string] 
        $Name = "*",

        # reg disabled 
        [Switch]
        $Disabled        
    
    )

    begin 
    {
        $RESObjectsPath = Get-RESObjectsPath
        $Xml = Join-Path $RESObjectsPath "pl_reg.xml"
        $XPath = "//registry"
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
           
                $name = select-xml -xml $Node -XPath './/name'
                $type = select-xml -xml $Node -XPath './/type'  
                $runonce = select-xml -xml $Node -XPath './/runonce'                               
                $description = select-xml -xml $Node -XPath './description' 
                $policysettings = select-xml -xml $Node -XPath './/policysettings'
                $admfile = select-xml -xml $Node -XPath './/admfile'
              
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
                    name             = $name
                    type             = $type
                    runonce          = $runonce
                    description      = $description                    
                    policysettings   = $policysettings
                    admfile          = $admfile
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
                Where-Object {$_.Name -like $Name} |               
                Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} 
        }            
    }
}