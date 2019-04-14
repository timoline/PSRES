$moduleName = "PSRES"
$modulePath = "$moduleName"
$docPath = "$modulePath\docs" 
$author = 'Timrz'
$version = '0.0.1'

Install-Module PlatyPS -Scope CurrentUser -Force -verbose
Install-Module Pester -Scope CurrentUser -Force -verbose

# copy artifacts
New-Item -Type Directory out -ErrorAction SilentlyContinue > $null
Copy-Item -Recurse -Force src out

Remove-Module $moduleName -ErrorAction SilentlyContinue
Import-Module $pwd\out\$moduleName -Force -Verbose

#New-MarkdownHelp -Module $moduleName -OutputFolder $docPath -WithModulePage -Force

Update-MarkdownHelpModule  $docPath -RefreshModulePage -verbose