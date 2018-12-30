<#
.SYNOPIS
   Shows the munu from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the munu from RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESAppMenus -disabled 
    Shows the disabled menus
#>
function Get-RESAppMenus
{
    [CmdletBinding()] 
    param ( 
    
        # The Name 
        [Parameter()]
        [string] 
        $Title = "*",
            
        # The objectdesc 
        [Parameter()]
        [string] 
        $Objectdesc = "*",

        # The description 
        [Parameter()]
        [string] 
        $Description = "*",

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
                [parameter(Mandatory = $true, ValueFromPipeline = $true)] 
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
                    title       = $title
                    description = $description
                    guid        = $guid   
                    updateguid  = $updateguid
                    parentguid  = $parentguid                 
                    enabled     = $enabled
                    objectdesc  = $objectdesc              
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
                Where-Object {$_.title -like $title} | 
                Where-Object {$_.objectdesc -like $objectdesc} |  
                Where-Object {$_.description -like $description} |  
                Where-Object {$_.Guid -like $Guid} |                            
                Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")}   
               
        }            
    }
}