$moduleName = "PSRES"
$modulePath = "out\$moduleName"
$docPath = "$modulePath\docs" 
$author = 'Timrz'
$version = '0.0.1'

Install-Module PlatyPS -Scope CurrentUser -Force -verbose
Install-Module Pester -Scope CurrentUser -Force -verbose

Import-Module $moduleName -Force -Verbose

#New-MarkdownHelp -Module $moduleName -OutputFolder $docPath -WithModulePage -Force

Update-MarkdownHelpModule  $docPath -RefreshModulePage -verbose