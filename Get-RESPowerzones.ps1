<#
###################
Rules/filters werkt nog niet goed

#####################
.EXAMPLE 
    Get-RESPrinters -Location "*duiven*" -disabled | select printer, location
#>
function Get-RESPowerzones 
{
    [CmdletBinding()] 
    param ( 
        # The powerzone (name) - pattern of the Powerzone
        [Parameter()]
        [string] 
        $Name = "*",    
        
        # The rule (name) - pattern of the rule
        [Parameter()]
        [string] 
        $Rule = "*",                
        
       # Printer disabled 
        [Switch]
        $Disabled
    
    )

    begin 
    {

        $LocalCachePath = Get-RESLocalCachePath

        $PwfObjectPath = Join-Path $LocalCachePath "Objects"
        $PwrXml       = Join-Path $PwfObjectPath 'pwrzone.xml'
    }

    process 
    {

        Function Get-Pwr
        {
            [CmdletBinding()]
            param 
            ( 
                [parameter(Mandatory=$true,ValueFromPipeline=$true)] 
                $PrnNode 
            )
            process 
            {
                ##############################################
                function ParamSW ($Paramsw,$Value) 
                {
                    if ($Paramsw -eq $true)
                    { 
                        return $Value
                    } else 
                    {
                        return $null
                    }  
                }

                ##############################################            
                $name = select-xml -xml $PrnNode -XPath './name' 
                $description = select-xml -xml $PrnNode -XPath './/description'           
                $rule = select-xml -xml $PrnNode -XPath ".//filter"
                $objectdesc = select-xml -xml $PrnNode -XPath './/objectdesc' 
                $guid = select-xml -xml $PrnNode -XPath './/guid' 
                $updateguid = select-xml -xml $PrnNode -XPath './/updateguid'                 
                $enabled = select-xml -xml $PrnNode -XPath './/enabled' 
              

                $Prop = @{
                    Name = $name;
                    Description = $description;   
                    
                    Rule =  $rule;
                    
                    Objectdesc = $objectdesc;  
                    guid = $guid
                    updateguid = $updateguid
                    enabled = $enabled
       
                }

                New-Object PSObject -property $Prop
            }
        }

    }#process

    end 
    {
        $PwrNode = Select-Xml -Path $PwrXml -XPath '//powerzone' | Select-Object -ExpandProperty node 

        $PwrNode |
        Get-Pwr |
        Where-Object {$_.Name -like $Name} |       
        Where-Object {$_.Rule -like $Rule} |                 
        Where-Object {$_.Enabled -match (ParamSW $Disabled "no")} 

    }
}