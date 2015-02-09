function Get-ParamSW 
{
    [CmdletBinding()] 
    param ( 
        # The Parameter of the switch
        [Parameter()]
        [string] 
        $Paramsw,
        
        # The Value of the switch
        [Parameter()]
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