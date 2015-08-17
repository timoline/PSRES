<#

###################


#####################

.EXAMPLE 
    Get-RESAppMenus 
#>
function Get-RESAppMenus
{
    [CmdletBinding()] 
    param ( 
    
        # The Name 
        [Parameter()]
        [string] 
        $title = "*",
            
        # The Name 
        [Parameter()]
        [string] 
        $objectdesc = "*",

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
        $Xml = Join-Path $RESObjectsPath "app_menus.xml"
        $XPath = "//applicationmenu"
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
                         
                $title = select-xml -xml $Node -XPath './/title'
                $description = select-xml -xml $Node -XPath './description'                 
                $guid = select-xml -xml $Node -XPath './/guid'
                $updateguid = select-xml -xml $Node -XPath './/updateguid'
                $parentguid = select-xml -xml $Node -XPath './/parentguid'
                $enabled = select-xml -xml $Node -XPath './/enabled' 
                $objectdesc = select-xml -xml $Node -XPath './/objectdesc' 

                $Prop = @{
                    title = $title
                    description = $description
                    guid = $guid   
                    updateguid = $updateguid
                    parentguid = $parentguid                 
                    enabled = $enabled
                    objectdesc = $objectdesc              
                }

                $Result = New-Object PSObject -property $Prop

                return $Result
            }
        }

    }#process

    end 
    {
        $Node =  Select-Xml -Path $Xml -XPath $XPath | Select-Object -ExpandProperty node

        if ($Node)
        {
            $Node |
            Get-RESData |
            Where-Object {$_.title -like $title} | 
            Where-Object {$_.objectdesc -like $objectdesc} |  
            Where-Object {$_.Guid -like $Guid} |                            
            Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")}   
               
        }            
    }
}