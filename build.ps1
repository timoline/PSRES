[CmdletBinding()]
param(
    [switch]
    $Bootstrap,

    [switch]
    $Test,

    [switch]
    $Publish
)
# Bootstrap step
if ($Bootstrap.IsPresent)
{
    Write-Host "Validate and install missing prerequisits for building ..."


    # For testing
    if (-not (Get-Module -Name Pester -ListAvailable))
    {
        Write-Warning "Module 'Pester' is missing. Installing 'Pester' ..."
        Install-Module -Name Pester -Scope CurrentUser -Force
    }

}

# Test step
if ($Test.IsPresent)
{
    if (-not (Get-Module -Name Pester -ListAvailable))
    {
        throw "Cannot find the 'Pester' module. Please specify '-Bootstrap' to install build dependencies."
    }

    if ($env:TF_BUILD)
    {
        $res = Invoke-Pester "$PSScriptRoot/tests" -OutputFormat NUnitXml -OutputFile TestResults.xml -PassThru
        if ($res.FailedCount -gt 0) 
        { 
            throw "$($res.FailedCount) tests failed." 
        }
    }
    else
    {
        $res = Invoke-Pester -Path "$PSScriptRoot/test" -PassThru
    }
}

#Publish step
if ($Publish.IsPresent)
{
    if ((Test-Path .\output))
    {
        Remove-Item -Path .\Output -Recurse -Force
    }

    # Copy Module Files to Output Folder
    if (-not (Test-Path .\output\PSRES))
    {
        $null = New-Item -Path .\output\PSRES -ItemType Directory
    }

    Copy-Item -Path '.\src\*' -Filter *.* -Recurse -Destination .\output\PSRES -Force 

    # Copy Module README file
    Copy-Item -Path '.\README.md' -Destination .\output\PSRES -Force

    # Publish Module to PowerShell Gallery
    Try
    {
        # Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
        $params = @{
            Path        = ('{0}\Output\PSRES' -f $PSScriptRoot )
            NuGetApiKey = $env:psgallery
            ErrorAction = 'Stop'
        }

        Publish-Module @params
        Write-Output -InputObject ('PSRES PowerShell Module version published to the PowerShell Gallery')
    }
    Catch
    {
        throw $_
    }
}