<#
.Synopsis
   Shows Applications and properties from RES Workspace Manager / Powerfuse
.DESCRIPTION
   Shows Applications and properties from RES Workspace Manager / Powerfuse
.EXAMPLE
   Get-RESApps -Title "explorer"

   Description
   -----------
   Shows all applications with "explorer" in the title
.EXAMPLE
   Get-RESApps -Disabled -Application "expl*"

   Description
   -----------
   Shows all disabled applications with "expl*" in the title
.EXAMPLE
   Get-RESApps -AppID "38"
   
   Description
   -----------
   Shows the application with AppID 38
.EXAMPLE
   Get-RESApps -HideFromMenu | Out-Gridview
   
   Description
   -----------
   Shows all the applications which are hidden from the menu
.EXAMPLE
   Get-RESApps -WebApp | select title, parameters

   Description
   -----------
   Shows all the Web applications
.EXAMPLE
   Get-RESApps -AppV | select title, menupath

   Description
   -----------
   Shows all the AppV/Softgrid applications
#>
function Get-RESApps {
[CmdletBinding()] 
param ( 

    # The title (name) - pattern of the Application
    [Parameter()]
    [alias('Name','App','Application')]
    [string] 
    $Title = "*",

    # The Group / User - pattern which has access to the Application
    [Parameter()]
    [alias('User')]
    [string] 
    $Group = "*",

    # The AppID - pattern of the Application
    [Parameter()]
    $AppID = "*",

    # The MenuPath / menu - pattern to the Application
    [Parameter()]
    [alias('Menu')]
    [string]
    $MenuPath = "*",

    # Startstyle of the Application
    [ValidateSet("normal","maximized","minimized")]
    [string] 
    $Startstyle,

    # Application disabled 
    [alias('http')]
    [Switch]
    $WebApp,

    # Application disabled 
    [alias('Softgrid')]
    [Switch]
    $AppV,

    # Application disabled 
    [Switch]
    $Disabled,

    # Application hidden from the menu 
    [alias('Hidden')]
    [Switch]
    $HideFromMenu 
    
)

begin {

    Write-Verbose 'Getting info from RES Powerfuse / Workspace manager local DBCache'
    
    $LocalCachePath = Get-RESLocalCachePath

    $PwfObjectPath = Join-Path $LocalCachePath "Objects"
    $AppsXml       = Join-Path $PwfObjectPath 'apps.xml'
    $MenuTreeXml   = Join-Path $PwfObjectPath 'menutree.xml'
    $AppMenuXml    = Join-Path $PwfObjectPath 'app_menus.xml'

    }

process {
    ##############################################
    function ParamSW ($Paramsw,$Value) {
        if ($Paramsw -eq $true)
        { 
            return $Value
        } else 
        {
            return $null
        }  
    }

    ##############################################
    Function Get-ParentPath 
    {
        $Result = "App"
        $Node = $_.ParentNode
        $Guid = $Node.Guid
        $Result = $TblAppMenu[[string]$Guid] + '\' + $Result
        while ($Node.ParentNode)
        {
            $Node = $Node.ParentNode
            $Guid = $Node.Guid
            $Result = $TblAppMenu[[string]$Guid] + '\' + $Result
        }
        $Result
    }

    ##############################################
    Function Get-App {
    [CmdletBinding()]
    param ( [parameter(Mandatory=$true,ValueFromPipeline=$true)] $AppNode )
    process {
             $Guid             = select-xml -xml $AppNode -XPath './guid' 
             $Title            = select-xml -xml $AppNode -XPath './/title' 
             $Description      = select-xml -xml $AppNode -XPath './/description' 
             $CommandLine      = select-xml -xml $AppNode -XPath './/commandline' 
             $Command          = Split-Path $CommandLine -Leaf
             $CommandPath          = Split-Path $CommandLine 
             $WorkingDir       = select-xml -xml $AppNode -XPath './/workingdir' 
             $Parameters       = select-xml -xml $AppNode -XPath './/parameters' 
             $AccessType = select-xml -xml $AppNode -XPath './/accesstype'  
             $Group      = select-xml -xml $AppNode -XPath './/group'        
             $Subscribed       = select-xml -xml $AppNode -XPath './/subscribed' 
             $Enabled    = select-xml -xml $AppNode -XPath './enabled' 
             $HideFromMenu = select-xml -xml $AppNode -XPath './/hidefrommenu'
             $AppID      = select-xml -xml $AppNode -XPath './/appid' 
             $MenuPath    = $TblMenuPath[[string]$AppID] -replace '\\App$',''
             if (-not $MenuPath) {$MenuPath = 'Disabled'}
             $AdministrativeNote = select-xml -xml $AppNode -XPath './/administrativenote' 
             $UnmanagedShortcuts = select-xml -xml $AppNode -XPath './/unmanagedshortcuts' 
             $Startmenu = select-xml -xml $AppNode -XPath './/startmenu' 
             $Desktop = select-xml -xml $AppNode -XPath './/desktop' 
             $AutoAll = select-xml -xml $AppNode -XPath './/autoall'
             $Startstyle = select-xml -xml $AppNode -XPath './/startstyle' 
             $SystemTray = select-xml -xml $AppNode -XPath './/systemtray'          
             $Quicklaunch = select-xml -xml $AppNode -XPath './/quicklaunch' 
             $CitrixDN = select-xml -xml $AppNode -XPath './/citrixdn' 
             $Prop = @{
                       Guid = $Guid;
                       Title = $Title;
                       Description = $Description;
                       CommandLine = $CommandLine;
                       Command  = $Command;
                       CommandPath = $CommandPath;
                       Workingdir = $WorkingDir;
                       Parameters = $Parameters;
                       AccessType = $AccessType;                 
                       Subscribed = $Subscribed;
                       Group = $Group;
                       Enabled = $Enabled;
                       HideFromMenu = $HideFromMenu;
                       AppID = $AppID;
                       MenuPath = $MenuPath;
                       AdministrativeNote = $AdministrativeNote;
                       UnmanagedShortcuts = $UnmanagedShortcuts;
                       Startmenu = $Startmenu;
                       Desktop = $Desktop;
                       AutoAll = $AutoAll;
                       Startstyle = $Startstyle;
                       SystemTray = $SystemTray;
                       Quicklaunch = $Quicklaunch;
                       CitrixDN = $CitrixDN
                      }
             New-Object PSObject -property $Prop
        }
    }

    ##############################################
    Select-Xml -Path $AppMenuXml -XPath '//applicationmenu' | 
        Select-Object -ExpandProperty node |
        Foreach-Object -begin {$TblAppMenu = @{}} -process {$TblAppMenu[$_.guid] = $_.title}        

    Select-Xml -Path $MenuTreeXml -XPath '//app' | 
        Select-Object -ExpandProperty node |
        Foreach-Object -begin {$TblMenuPath = @{}} -process {$TblMenuPath[$_.appid] = Get-ParentPath $_}        

    }

end {

    ##############################################
    $AppNode = Select-Xml -Path $AppsXml -XPath '//application' | Select-Object -ExpandProperty node     

    $AppNode | 
    Get-App | 
    Where-Object {$_.Title -like $Title} |
    Where-Object {$_.Group -like $Group} |
    Where-Object {$_.AppID -like $AppID} | 
    Where-Object {$_.MenuPath -like $MenuPath} |
    Where-Object {$_.Startstyle -match $Startstyle} |
    Where-Object {$_.Enabled -match (ParamSW $Disabled "no")} |
    Where-Object {$_.CommandLine -match (ParamSW $WebApp "iexplore.exe")} |
    Where-Object {$_.CommandLine -match (ParamSW $AppV "sfttray.exe")} |
    Where-Object {$_.HideFromMenu -match (ParamSW $HideFromMenu "yes")}

    Write-Verbose 'Showing Info from RES Powerfuse / Workspace manager local DBCache is succefull'
    }
}