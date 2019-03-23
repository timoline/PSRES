function Convert-RESGuidToWorkspace
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
        [alias('Workspace')]  
        [string] 
        $Guid       
    )
    #$Guid = "{E536D09E-3DA0-464A-84A5-F520C43C1429}"
    $Value = Get-RESWorkspaces -Guid $Guid     
    return $Value.name.node."#text" 
}