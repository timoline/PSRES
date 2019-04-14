$moduleName = "PSRES"
$modulePath = "$moduleName"
$docPath = "out\docs" 
$author = 'Timrz'
$version = '0.0.1'

Install-Module PlatyPS -Scope CurrentUser -Force -verbose
Install-Module Pester -Scope CurrentUser -Force -verbose

# copy artifacts
New-Item -Type Directory out -ErrorAction SilentlyContinue -Verbose
New-Item -Type Directory out\docs -ErrorAction SilentlyContinue -Verbose
Copy-Item -Recurse -Force src out -Verbose

Remove-Module $moduleName -ErrorAction SilentlyContinue
Import-Module $pwd\out\$moduleName.psm1 -Force -Verbose

New-MarkdownHelp -Module $moduleName -OutputFolder $docPath -WithModulePage -Force

Update-MarkdownHelpModule  $docPath -RefreshModulePage -verbose