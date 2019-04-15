Import-Module "$PSScriptRoot/../src/PSRES.psd1" -Force

describe 'first-test' {

    $TestNumber = 2
    $result = $TestNumber

    it 'should return 2' {
        $result | should be 2
    }

}