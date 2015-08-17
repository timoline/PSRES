<#

###################


#####################

.EXAMPLE 
    Get-RESVars 
#>
function Get-RESVars 
{
    [CmdletBinding()] 
    param ( 
        # The Name 
        [Parameter()]
        [string] 
        $Name = "*",

       # Var disabled 
        [Switch]
        $Disabled        
    
    )

    begin 
    {
        $RESObjectsPath = Get-RESObjectsPath
        $Xml = Join-Path $RESObjectsPath "pl_var.xml"
        $XPath = "//variable"        
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
           
                $description = select-xml -xml $Node -XPath './description' 
                $name = select-xml -xml $Node -XPath './/name'
                $value = select-xml -xml $Node -XPath './/value'
                $state = select-xml -xml $Node -XPath './/state'
                $guid = select-xml -xml $Node -XPath './/guid'
                $updateguid = select-xml -xml $Node -XPath './/updateguid'
                $parentguid = select-xml -xml $Node -XPath './/parentguid'
                $enabled = select-xml -xml $Node -XPath './/enabled' 
                $objectdesc = select-xml -xml $Node -XPath './/objectdesc' 
                $order = select-xml -xml $Node -XPath './/order' 
                $type = select-xml -xml $Node -XPath './/accesscontrol/access/type'
                $access = select-xml -xml $Node -XPath './/accesscontrol/access/object'

                $accesscontrol = New-Object PSObject -property @{
                    type = $type
                    access = $access
                }

                $Prop = @{
                    description = $description
                    name = $name
                    value = $value
                    state = $state
                    accesscontrol = $accesscontrol
                    guid = $guid   
                    updateguid = $updateguid
                    parentguid = $parentguid                 
                    enabled = $enabled
                    objectdesc = $objectdesc
                    order = $order                
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