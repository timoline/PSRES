<#
.SYNOPSIS
   Shows the tasks from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the tasks from RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESTasks
#>
function Get-RESTasks
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
        $Xml = Join-Path $RESObjectsPath "pl_task.xml"
        $XPath = "//exttask"
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
                $command = select-xml -xml $Node -XPath './/command'
                $waitforapplication = select-xml -xml $Node -XPath './/waitforapplication'  
                $runonce = select-xml -xml $Node -XPath './/runonce'                               
                $script = select-xml -xml $Node -XPath './/script'
                $scriptext = select-xml -xml $Node -XPath './/scriptext'
                $timeoutperiod = select-xml -xml $Node -XPath './/timeoutperiod'
                $hideapplication = select-xml -xml $Node -XPath './/hideapplication'
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
                    description        = $description       
                    command            = $command
                    waitforapplication = $waitforapplication
                    runonce            = $runonce             
                    script             = $script
                    scriptext          = $scriptext
                    timeoutperiod      = $timeoutperiod
                    hideapplication    = $hideapplication
                    state              = $state

                    accesscontrol      = $accesscontrol
                    workspacecontrol   = $workspacecontrol
                    guid               = $guid   
                    updateguid         = $updateguid
                    parentguid         = $parentguid                 
                    enabled            = $enabled
                    objectdesc         = $objectdesc
                    order              = $order                
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