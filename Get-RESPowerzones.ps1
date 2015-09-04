<#

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
        $RESObjectsPath = Get-RESObjectsPath
        $Xml = Join-Path $RESObjectsPath "pwrzone.xml"
        $XPath = "//powerzone"        
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
            
                $name = select-xml -xml $Node -XPath './name' 
                $description = select-xml -xml $Node -XPath './/description'           
                $objectdesc = select-xml -xml $Node -XPath './/objectdesc' 
                $guid = select-xml -xml $Node -XPath './/guid' 
                $updateguid = select-xml -xml $Node -XPath './/updateguid'                 
                $enabled = select-xml -xml $Node -XPath './/enabled' 

                $type = select-xml -xml $Node -XPath './/powerzonerules/rule/type'
                $filter = select-xml -xml $Node -XPath './/powerzonerules/rule/filter'
                $type2 = select-xml -xml $Node -XPath './/powerzonerules/rule/type2'
                $filter2 = select-xml -xml $Node -XPath './/powerzonerules/rule/filter2'
                $comments = select-xml -xml $Node -XPath './/powerzonerules/rule/comments'
                $enabled = select-xml -xml $Node -XPath './/powerzonerules/rule/enabled'

                $powerzonerules = New-Object PSObject -property @{
                    type = $type
                    filter = $filter
                    type2 = $type2
                    filter2 = $filter2
                    comments = $comments
                    enabled = $enabled
                }
              
                $Prop = @{
                    Name = $name;
                    Description = $description;                       
                    powerzonerules =  $powerzonerules;                    
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
            Where-Object {$_.Rule -like $Rule} |    
            Where-Object {$_.Guid -like $Guid} |               
            Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} 
        }
    }
}