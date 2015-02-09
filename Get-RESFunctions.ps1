function Get-ParamSW ($Paramsw,$Value) 
{
    if ($Paramsw -eq $true)
    { 
        return $Value
    } else 
    {
        return $null
    }  
}