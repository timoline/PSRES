<#

###################


#####################

.EXAMPLE 
    Get-RESGlobalAuthorisedConnections
#>
function Get-RESGlobalAuthorisedConnections 
{
    [CmdletBinding()] 
    param ( 
        # The Process 
        [Parameter()]
        [string] 
        $Process = "*",        
        
       # Authorisation disabled 
        [Switch]
        $Disabled        
    
    )

    begin 
    {

        $LocalCachePath = Get-RESLocalCachePath

        $PwfObjectPath = Join-Path $LocalCachePath "Objects"
        $Xml = Join-Path $PwfObjectPath "sec_globauthip.xml"
        $XPath = "//authip"
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

                $remoteaddress = select-xml -xml $Node -XPath './/remoteaddress'                          
                $remotesubnet = select-xml -xml $Node -XPath './remotesubnet' 
                $remoteport = select-xml -xml $Node -XPath './/remoteport'
                $process = select-xml -xml $Node -XPath './/process'
                $udp = select-xml -xml $Node -XPath './/udp'
                $inbound = select-xml -xml $Node -XPath './/inbound'
                $outbound = select-xml -xml $Node -XPath './/outbound'
                $guid = select-xml -xml $Node -XPath './/guid'
                $updateguid = select-xml -xml $Node -XPath './/updateguid'
                $parentguid = select-xml -xml $Node -XPath './/parentguid'
                $enabled = select-xml -xml $Node -XPath './/enabled' 
                $objectdesc = select-xml -xml $Node -XPath './/objectdesc' 

                $Prop = @{
                    remoteaddress = $remoteaddress
                    remotesubnet = $remotesubnet                    
                    remoteport = $remoteport
                    process = $process
                    udp = $udp
                    inbound = $inbound   
                    outbound = $outbound   
                    guid = $guid
                    updateguid = $updateguid
                    parentguid = $parentguid                 
                    enabled = $enabled
                    objectdesc = $objectdesc
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
            Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} 
        }            
    }
}