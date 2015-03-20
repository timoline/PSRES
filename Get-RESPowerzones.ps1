<#
###################
Rules/filters werkt nog niet goed

#####################
.EXAMPLE 
    Get-RESPowerzones -name "*test*" 
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

        # The guid - pattern of the guid
        [Parameter()]
        [string] 
        $Guid = "*",  
        
       # Printer disabled 
        [Switch]
        $Disabled
    
    )

    begin 
    {

        $LocalCachePath = Get-RESLocalCachePath

        $PwfObjectPath = Join-Path $LocalCachePath "Objects"
        $PwrXml = Join-Path $PwfObjectPath 'pwrzone.xml'
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
                    Guid = $guid
                    Updateguid = $updateguid
                    enabled = $enabled
       
                }

                $Result = New-Object PSObject -property $Prop
                <#
                for ($i = 0; $i -lt $rule.Count; $i++) {
                    Add-Member -InputObject $Result -MemberType NoteProperty -Name "Rule[$i]" -Value $rule[$i]                    
                }

                for ($i = 0; $i -lt $enabled.Count; $i++) {
                    Add-Member -InputObject $Result -MemberType NoteProperty -Name "Enabled[$i]" -Value $enabled[$i]                    
                }
                #>
                return $result
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
        Where-Object {$_.Guid -like $Guid} |               
        Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} 
    }
}