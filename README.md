# posh-azure

A project intended to make working with the Azure PowerShell cmdlets a little more fun and productive.

Currently the project adds completion for parameters (e.g. ResourceGroupName, Location)

I plan to keep working on this to improve completion, but if there are parameters that aren't completing (or completing incorrectly) then raise an issue :-)

## Dependencies

* [Azure PowerShell cmdlets](https://docs.microsoft.com/en-us/powershell/azure/install-azurerm-ps?view=azurermps-4.2.0)
* [TabExpansionPlusPlus](https://www.powershellgallery.com/packages/TabExpansionPlusPlus/)

## Installation

After intalling the pre-requisites above, install [posh-azure](https://www.powershellgallery.com/packages/posh-azure) via PowerShell gallery

```powershell
 Install-Module -Name posh-azure
```
