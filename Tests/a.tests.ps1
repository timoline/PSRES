Import-Module "$PSScriptRoot/../src/PSRES.psd1" -Force -Verbose

describe 'first-test' {

    $TestNumber = 2
    $result = $TestNumber

    it 'should return 2' {
        $result | should be 2
    }

}

describe 'second-test' {

    $TestNumber = 3
    $result = $TestNumber

    it 'should return 3' {
        $result | should be 3
    }

}