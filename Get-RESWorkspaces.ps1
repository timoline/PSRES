<#

###################


#####################

.EXAMPLE 
    Get-RESWorkspaces 
#>
function Get-RESWorkspaces 
{
    [CmdletBinding()] 
    param ( 
        # The Name 
        [Parameter()]
        [string] 
        $Name = "*",

        # The guid - pattern of the guid
        [Parameter()]
        [string] 
        $Guid = "*", 

       # Var disabled 
        [Switch]
        $Disabled        
    
    )

    begin 
    {
        $RESObjectsPath = Get-RESObjectsPath
        $Xml = Join-Path $RESObjectsPath "workspaces.xml"
        $XPath = "//workspace"
    }

    process 
    {

        Function Get-RESData
        {
            [CmdletBinding()]
            param 
            ( 
                [parameter(Mandatory=$true,ValueFromPipeline=$true)] 
                $Node 
            )
            process 
            { 
                         
                $required = select-xml -xml $Node -XPath './/required'
                $name = select-xml -xml $Node -XPath './/name'
                $description = select-xml -xml $Node -XPath './description'                 
                $selectablebyuser = select-xml -xml $Node -XPath './/selectablebyuser'
                $includeallcomputers = select-xml -xml $Node -XPath './/includeallcomputers'                
                $guid = select-xml -xml $Node -XPath './/guid'
                $updateguid = select-xml -xml $Node -XPath './/updateguid'
                $parentguid = select-xml -xml $Node -XPath './/parentguid'
                $enabled = select-xml -xml $Node -XPath './/enabled' 
                $objectdesc = select-xml -xml $Node -XPath './/objectdesc' 

                $computertype = select-xml -xml $Node -XPath './/computercontrol/item/type'
                $computeragent = select-xml -xml $Node -XPath './/computercontrol/item/agent'
                $computerguid = select-xml -xml $Node -XPath './/computercontrol/item/guid'

                $computercontrol = New-Object PSObject -property @{
                    type = $computertype
                    agent = $computeragent
                    guid = $computerguid
                }

                $type = select-xml -xml $Node -XPath './/accesscontrol/access/type'
                $object = select-xml -xml $Node -XPath './/accesscontrol/access/object'
                $accesscontrol = New-Object PSObject -property @{
                    type = $type
                    object = $object
                }
                
                $Prop = @{
                    required = $required
                    name = $name
                    description = $description
                    selectablebyuser = $selectablebyuser
                    includeallcomputers = $includeallcomputers                                         
                    accesscontrol = $accesscontrol
                    guid = $guid   
                    updateguid = $updateguid
                    parentguid = $parentguid                 
                    enabled = $enabled
                    objectdesc = $objectdesc  
                    computercontrol = $computercontrol            
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
            Where-Object {$_.Guid -like $Guid} |                            
            Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")}             
        }            
    }
}