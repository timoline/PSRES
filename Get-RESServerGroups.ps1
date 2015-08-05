<#

###################


#####################

.EXAMPLE 
    Get-RESServerGroups 
#>
function Get-RESServerGroups
{
    [CmdletBinding()] 
    param ( 
        # The Name 
        [Parameter()]
        [alias('Name')]        
        [string] 
        $Objectdesc = "*",

       # Var disabled 
        [Switch]
        $Disabled        
    
    )

    begin 
    {

        $LocalCachePath = Get-RESLocalCachePath

        $PwfObjectPath = Join-Path $LocalCachePath "Objects"
        $Xml = Join-Path $PwfObjectPath "ctx_srvgroups.xml"
        $XPath = "//servergroup"
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
                         
                $servers = select-xml -xml $Node -XPath './/servers/server'
                $guid = select-xml -xml $Node -XPath './/guid'
                $updateguid = select-xml -xml $Node -XPath './/updateguid'
                $enabled = select-xml -xml $Node -XPath './/enabled' 
                $objectdesc = select-xml -xml $Node -XPath './/objectdesc' 

                $Prop = @{
                    servers = $servers
                    guid = $guid   
                    updateguid = $updateguid             
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
        $Node = Select-Xml -Path $Xml -XPath $xpath | Select-Object -ExpandProperty node 

        if ($Node)
        {
            $Node |
            Get-RESData |
            Where-Object {$_.objectdesc -like $Objectdesc} |               
            Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")}             
        }            
    }
}