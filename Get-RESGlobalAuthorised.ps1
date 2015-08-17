<#

###################


#####################

.EXAMPLE 
    Get-RESGlobalAuthorised 
#>
function Get-RESGlobalAuthorised 
{
    [CmdletBinding()] 
    param ( 
        # The Process 
        [Parameter()]
        [string] 
        $Process = "*",
        
        # The Process [rwx]
        [Parameter()]
        [alias('Permission')]        
        [string] 
        $Operation = "*",
        
       # Authorisation disabled 
        [Switch]
        $Disabled        
    
    )

    begin 
    {
        $RESObjectsPath = Get-RESObjectsPath
        $Xml = Join-Path $RESObjectsPath "sec_globauth.xml"
        $XPath = "//authfile"
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

                $authorizedfile = select-xml -xml $Node -XPath './/authorizedfile'                          
                $description = select-xml -xml $Node -XPath './description' 
                $process = select-xml -xml $Node -XPath './/process'
                $operation = select-xml -xml $Node -XPath './/operation'
                $learningmode = select-xml -xml $Node -XPath './/learningmode'
                $guid = select-xml -xml $Node -XPath './/guid'
                $updateguid = select-xml -xml $Node -XPath './/updateguid'
                $parentguid = select-xml -xml $Node -XPath './/parentguid'
                $enabled = select-xml -xml $Node -XPath './/enabled' 
                $objectdesc = select-xml -xml $Node -XPath './/objectdesc' 

                $type = select-xml -xml $Node -XPath './/accesscontrol/access/type'
                $access = select-xml -xml $Node -XPath './/accesscontrol/access/object'
                $accesscontrol = New-Object PSObject -property @{
                    type = $type
                    access = $access
                }

                $Prop = @{

                    authorizedfile = $authorizedfile
                    description = $description                    
                    process = $process
                    operation = $operation
                    learningmode = $learningmode
                    guid = $guid   
                    updateguid = $updateguid
                    parentguid = $parentguid                 
                    enabled = $enabled
                    objectdesc = $objectdesc
                    accesscontrol = $accesscontrol

                }

                $Result = New-Object PSObject -property $Prop
                <#
                for ($i = 0; $i -lt $Accesstype.Count; $i++) {
                    Add-Member -InputObject $Result -MemberType NoteProperty -Name "Accesstype[$i]" -Value $Accesstype[$i]                   
                }
                #>
                return $Result
            }
        }

    }#process

    end 
    {
        $Node = Select-Xml -Path $Xml -XPath $XPath | Select-Object -ExpandProperty node 

        if ($node)
        {
            $Node |
            Get-RESData | 
            Where-Object {$_.Process -like $Process} |               
            Where-Object {$_.Operation -like $Operation} |                
            Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} 
        }            
    }
}