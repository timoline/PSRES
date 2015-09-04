<#

.EXAMPLE 
    Get-RESPrinters -Location "*duiven*" -disabled | select printer, location
#>
function Get-RESPrinters 
{
    [CmdletBinding()] 
    param ( 
        # The Printer (name) - pattern of the Printer
        [Parameter()]
        [alias('Name')]
        [string] 
        $Printer = "*",
        
        # The Location - pattern of the Location
        [Parameter()]
        [string] 
        $Location = "*",          
        
       # Printer disabled 
        [Switch]
        $Disabled
    
    )

    begin 
    {
        $RESObjectsPath = Get-RESObjectsPath
        $Xml = Join-Path $RESObjectsPath "pl_prn.xml"
        $XPath = "//printermapping"             
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
           
                $printer = select-xml -xml $Node -XPath './printer' 
                $backupprinter = select-xml -xml $Node -XPath './/backupprinter'
                $default = select-xml -xml $Node -XPath './/default'
                $fastconnect = select-xml -xml $Node -XPath './/fastconnect'
                $failover = select-xml -xml $Node -XPath './/failover'
                $printerpreference = select-xml -xml $Node -XPath './/printerpreference'
                $waitfortask = select-xml -xml $Node -XPath './/waitfortask'
                $description = select-xml -xml $Node -XPath './/description'
                $driver = select-xml -xml $Node -XPath './/driver' 
                $comment = select-xml -xml $Node -XPath './/comment' 
                $location = select-xml -xml $Node -XPath './/location' 
                $state = select-xml -xml $Node -XPath './/state' 
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
                    Printer = $printer
                    Backupprinter = $Backupprinter
                    Default = $default
                    Fastconnect = $fastconnect
                    Failover = $failover
                    Printerpreference = $printerpreference
                    Waitfortask = $waitfortask
                    Description = $description               
                    Driver = $driver
                    Comment = $comment
                    Location = $location
                    State = $state
                    Enabled = $enabled
                    Objectdesc = $objectdesc
                    Order = $order
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
        
        if ($Node)
        {
            $Node |
            Get-RESData | 
            Where-Object {$_.Printer -like $Printer} |      
            Where-Object {$_.Location -like $Location} |              
            Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} 
        }            
    }
}