function Convert-RESGuidToPowerzone
{
    [CmdletBinding()] 
    param ( 
        # The guid 
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript( {
                try
                {
                    [System.Guid]::Parse($_) | Out-Null
                    $true
                }
                catch
                {
                    $false
                }
            })]
        [alias('Powerzone')] 
        [string] 
        $Guid       
    )
    #$Guid = "{EF0E53B1-B968-48EF-8089-C3ABB154E34F}"
    $Value = Get-RESPowerzones -Guid $Guid 
    return $Value.name.node."#text" 
}