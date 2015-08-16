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
function Get-RESApps 
{
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

    begin 
    {
        Write-Verbose 'Getting info from RES Powerfuse / Workspace manager local DBCache'
    
        $LocalCachePath = Get-RESLocalCachePath

        $PwfObjectPath = Join-Path $LocalCachePath "Objects"
        $Xml     = Join-Path $PwfObjectPath "apps.xml"       
        $XPath = "//application"

    }#begin 

    process 
    {

		##############################################
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
				$Guid             = select-xml -xml $Node -XPath './guid' 
				$Title            = select-xml -xml $Node -XPath './/title' 
				$Description      = select-xml -xml $Node -XPath './/description' 
				$CommandLine      = select-xml -xml $Node -XPath './/commandline' 
				$Command          = Split-Path $CommandLine -Leaf
				$CommandPath          = Split-Path $CommandLine 
				$WorkingDir       = select-xml -xml $Node -XPath './/workingdir' 
				$Parameters       = select-xml -xml $Node -XPath './/parameters' 
        
				$Subscribed       = select-xml -xml $Node -XPath './/subscribed' 
				$Enabled    = select-xml -xml $Node -XPath './enabled' 
				$HideFromMenu = select-xml -xml $Node -XPath './/hidefrommenu'
				$AppID      = select-xml -xml $Node -XPath './/appid' 
				#$MenuPath    = $TblMenuPath[[string]$AppID] -replace '\\App$',''
				$MenuPath    = Get-RESMenuPath -AppID $AppID
				if (-not $MenuPath) 
				{
					$MenuPath = 'Disabled'
				}
				$AdministrativeNote = select-xml -xml $Node -XPath './/administrativenote' 
				$UnmanagedShortcuts = select-xml -xml $Node -XPath './/unmanagedshortcuts' 
				$Startmenu = select-xml -xml $Node -XPath './/startmenu' 
				$Desktop = select-xml -xml $Node -XPath './/desktop' 
				$AutoAll = select-xml -xml $Node -XPath './/autoall'
				$Startstyle = select-xml -xml $Node -XPath './/startstyle' 
				$SystemTray = select-xml -xml $Node -XPath './/systemtray'          
				$Quicklaunch = select-xml -xml $Node -XPath './/quicklaunch' 
				$CitrixDN = select-xml -xml $Node -XPath './/citrixdn' 

                $workspace = select-xml -xml $Node -XPath './/workspacecontrol/workspace' 
                $workspacecontrol = New-Object PSObject -property @{
                    workspace = $workspace
                }

				$accesstype = select-xml -xml $Node -XPath './/accesscontrol/accesstype' 
                $grouplist = select-xml -xml $Node -XPath './/accesscontrol/grouplist/group' 
                $notgrouplist = select-xml -xml $Node -XPath './/accesscontrol/notgrouplist/group'
                $accesscontrol = New-Object PSObject -property @{
                    accesstype = $accesstype
                    group = $grouplist
                    notgroup = $notgrouplist
                }


				$Prop = @{
					Guid = $Guid;
					Title = $Title;
					Description = $Description
					CommandLine = $CommandLine
					Command  = $Command
					CommandPath = $CommandPath
					Workingdir = $WorkingDir
					Parameters = $Parameters
					accesscontrol = $accesscontrol             
					Subscribed = $Subscribed
					Enabled = $Enabled
					HideFromMenu = $HideFromMenu
					AppID = $AppID
					MenuPath = $MenuPath
					AdministrativeNote = $AdministrativeNote
					UnmanagedShortcuts = $UnmanagedShortcuts
					Startmenu = $Startmenu
					Desktop = $Desktop
					AutoAll = $AutoAll
					Startstyle = $Startstyle
					SystemTray = $SystemTray
					Quicklaunch = $Quicklaunch
					CitrixDN = $CitrixDN
					workspacecontrol = $workspacecontrol
				}

				$Result = New-Object PSObject -property $Prop
				
				return $Result
			}#process
		}#function

    }#process

    end 
    {
        ##############################################
        $Node = Select-Xml -Path $Xml -XPath  $XPath | Select-Object -ExpandProperty node     

        if ($Node)
        {
            $Node | 
            Get-RESData | 
            Where-Object {$_.Title -like $Title} |
            Where-Object {$_.Group -like $Group} |
            Where-Object {$_.AppID -like $AppID} | 
            Where-Object {$_.MenuPath -like $MenuPath} |
            Where-Object {$_.Startstyle -match $Startstyle} |
            Where-Object {$_.Enabled -match (Get-ParamSW $Disabled "no")} |
            Where-Object {$_.CommandLine -match (Get-ParamSW $WebApp "iexplore.exe")} |
            Where-Object {$_.CommandLine -match (Get-ParamSW $AppV "sfttray.exe")} |
            Where-Object {$_.HideFromMenu -match (Get-ParamSW $HideFromMenu "yes")}

            Write-Verbose 'Showing Info from RES Powerfuse / Workspace manager local DBCache is successfull'
        }
    }#end
}