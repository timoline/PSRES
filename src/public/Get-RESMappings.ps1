﻿<#
.SYNOPSIS
   Shows mappings and properties from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows mappings and properties from RES Workspace Manager / Powerfuse
.EXAMPLE  
    Get-RESMappings -Device "H:"
    Shows mapping and properties with device H:
#>
function Get-RESMappings 
{
    [CmdletBinding()] 
    param ( 
        # The device (Driveletter) 
        [Parameter()]
        [alias('Driveletter')]
        [string] 
        $Device = "*",

        # The description
        [Parameter()]
        [string] 
        $Description = "*",
        
        # disabled 
        [Switch]
        $Disabled            
    )

    begin 
    {
        $RESObjectsPath = Get-RESObjectsPath
        $Xml = Join-Path $RESObjectsPath "pl_map.xml"
        $XPath = "//mapping"
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
           
                $device = select-xml -xml $Node -XPath './device' 
                $description = select-xml -xml $Node -XPath './/description'
                $sharename = select-xml -xml $Node -XPath './/sharename'
                $username = select-xml -xml $Node -XPath './/username'
                $password = select-xml -xml $Node -XPath './/password'
                $password_long = select-xml -xml $Node -XPath './/password_long'
                $prompt = select-xml -xml $Node -XPath './/prompt'
                $hidedrive = select-xml -xml $Node -XPath './/hidedrive'
                $fastconnect = select-xml -xml $Node -XPath './/fastconnect' 
                $action = select-xml -xml $Node -XPath './/action' 
                $state = select-xml -xml $Node -XPath './/state' 
                
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
                    device           = $device
                    description      = $description
                    sharename        = $sharename
                    username         = $username
                    password         = $password
                    password_long    = $password_long   
                    prompt           = $prompt
                    hidedrive        = $hidedrive 
                    fastconnect      = $fastconnect
                    action           = $action
                    state            = $state
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
        $Node = Select-Xml -Path $Xml -XPath $Xpath | Select-Object -ExpandProperty node 

        if ($Node)
        {
            $Node |
                Get-RESData | 
                Where-Object {$_.Device -like $Device} |
                Where-Object {$_.description -like $description} |
                Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} 
        }            
    }
}