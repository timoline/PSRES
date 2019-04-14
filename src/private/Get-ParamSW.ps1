function Get-ParamSW 
{
    [CmdletBinding()] 
    param ( 
        # The Parameter of the switch
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet("True", "False")] 
        [string] 
        $Paramsw,
        
        # The Value of the switch
        [Parameter(Mandatory = $true, Position = 1)]
        [string] 
        $Value 
    
    )
    process 
    {
        if ($Paramsw -eq $true)
        { 
            return $Value
        } 
        else 
        {
            return $null
        }  
    }#process 
}



