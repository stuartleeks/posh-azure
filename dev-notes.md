
Release steps
* update module version in posh-azure.psd1
* update release notes in README.md
* Publish the module to PowerShell Gallery: Publish-Module -Path . -NuGetApiKey $key
* tags, e.g. git tag v0.3.0 -m "v0.3.0"
* push changes and tag