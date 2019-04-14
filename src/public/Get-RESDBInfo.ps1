<#
.SYNOPSIS
   Shows the database info from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows the database info from RES Workspace Manager / Powerfuse
.EXAMPLE 
    Get-RESDBInfo
#>
Function Get-RESDBInfo 
{
    [CmdletBinding()] 
    param()
    Write-Verbose "Getting RESDBInfo"

    $KeyPath = Get-RESRegistryPath

    $DBSrvPrt = (Get-ItemProperty $KeyPath).DBServer 
    if ($DBSrvPrt)
    {
        $DBSrvPrt2 = $DBSrvPrt.split(",")  
        $DBServer = $DBSrvPrt2[0]   
        $DBPort = $DBSrvPrt2[1]
    }
    $DBName = (Get-ItemProperty $KeyPath).DBName 
    $DBUser = (Get-ItemProperty $KeyPath).DBUser
    $DBPassword = (Get-ItemProperty $KeyPath).DBPassword
    $DBPasswordConverted = (Get-ItemProperty $KeyPath).DBPasswordConverted 
    $DBPasswordEx = (Get-ItemProperty $KeyPath).DBPasswordEx       
    $DBState = (Get-ItemProperty $KeyPath).DBState    
    $DBType = (Get-ItemProperty $KeyPath).DBType
    $DBEncryption = (Get-ItemProperty $KeyPath).DBEncryption

    $Prop = @{
        DBServer            = $DBServer
        DBName              = $DBName
        DBPort              = $DBPort
        DBUser              = $DBUser
        DBPassword          = $DBPassword
        DBPasswordConverted = $DBPasswordConverted  
        DBPasswordEx        = $DBPasswordEx
        DBState             = $DBState
        DBType              = $DBType
        DBEncryption        = $DBEncryption
    }
    New-Object PSObject -property $Prop     
}
