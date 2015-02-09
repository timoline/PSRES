<#

###################
Access werkt nog niet goed

#####################

.EXAMPLE 
    Get-RESPrinters -Location "*duiven*" -disabled | select printer, location
#>
function Get-RESPrinters 
{
    [CmdletBinding()] 
    param ( 
        # The Printer (name) - pattern of the Printer
        [Parameter()]
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

        $LocalCachePath = Get-RESLocalCachePath

        $PwfObjectPath = Join-Path $LocalCachePath "Objects"
        $PrnXml       = Join-Path $PwfObjectPath 'pl_prn.xml'
    }

    process 
    {

        Function Get-Prn 
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
                $printer             = select-xml -xml $PrnNode -XPath './printer' 
                $backupprinter            = select-xml -xml $PrnNode -XPath './/backupprinter'
                $default= select-xml -xml $PrnNode -XPath './/default'
                $fastconnect= select-xml -xml $PrnNode -XPath './/fastconnect'
                $failover= select-xml -xml $PrnNode -XPath './/failover'
                $printerpreference= select-xml -xml $PrnNode -XPath './/printerpreference'
                $waitfortask= select-xml -xml $PrnNode -XPath './/waitfortask'
                $description         = select-xml -xml $PrnNode -XPath './/description'
                $driver            = select-xml -xml $PrnNode -XPath './/driver' 
                $comment = select-xml -xml $PrnNode -XPath './/comment' 
                $location            = select-xml -xml $PrnNode -XPath './/location' 
                $state = select-xml -xml $PrnNode -XPath './/state' 
                $enabled = select-xml -xml $PrnNode -XPath './/enabled' 
                $objectdesc = select-xml -xml $PrnNode -XPath './/objectdesc' 
                $order = select-xml -xml $PrnNode -XPath './/order'         
                $accesstype = select-xml -xml $PrnNode -XPath './/accesscontrol'


                $Prop = @{
                    Printer = $printer;
                    Backupprinter = $Backupprinter;
                    Default = $default;
                    Fastconnect = $fastconnect;
                    Failover = $failover;
                    Printerpreference = $printerpreference;   
                    Waitfortask = $waitfortask;
                    Description = $description;                    
                    Driver = $driver;
                    Comment = $comment;
                    Location = $location;    
                    State = $state;   

                    Enabled = $enabled;
                    Objectdesc = $objectdesc;    
                    Order = $order;  
                    Accesstype = $accesstype;
                }

                New-Object PSObject -property $Prop
            }
        }

    }#process

    end 
    {
        $PrnNode = Select-Xml -Path $PrnXml -XPath '//printermapping' | Select-Object -ExpandProperty node 

        $PrnNode |
        Get-Prn | 
        Where-Object {$_.Printer -like $Printer} |      
        Where-Object {$_.Location -like $Location} |              
        Where-Object {$_.Enabled -match (ParamSW $Disabled "no")} 

    }
}