foreach ($file in dir $PSScriptRoot\completions\*.ps1)
{
    . $file.FullName
}