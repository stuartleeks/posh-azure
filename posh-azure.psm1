# load argument completions
foreach ($file in dir $PSScriptRoot\completions\*.ps1) {
    . $file.FullName
}

. $PSScriptRoot\posh-azure.ps1
