#
# .SYNOPSIS
#
#    Auto-complete the -Location parameter value for Azure PowerShell cmdlets. (version 1.0)
#
# .NOTES
#    
#    Created by Stuart Leeks
#    http://blogs.msdn.com/stuartleeks
#    http://twitter.com/stuartleeks
#
function DeploymentNameCompleter {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $boundParameters)

    $resourceGroupName = $boundParameters["ResourceGroupName"]
    if ($resourceGroupName -ne $null) {
        ### Create fresh completion results for Azure locations
        $ItemList = Get-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName | Select-Object -ExpandProperty DeploymentName -Unique | Sort-Object
        ### Return the fresh completion results
        $wordToCompleteWildcard = $wordToComplete.Trim("'") + "*"

        $results = $ItemList `
            | Where-Object { $PSItem -like $wordToCompleteWildcard} `
            | Foreach-Object {
            if ($PSItem -ne $null -and $PSItem -ne "") {
                $CompletionResult = @{
                    CompletionText       = $PSItem
                    ToolTip              = $PSItem
                    ListItemText         = $PSItem
                    CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
                }
                New-CompletionResult @CompletionResult
            }
        }
        return $results
    }
}

#  "'" + [string]::Join("', '", (Get-Command -Module Azure* -ParameterName DeploymentName -ParameterType string)) + "'" | clip

Register-ArgumentCompleter `
    -Command ( 'Get-AzureDeploymentEvent', 'Get-AzureRmResourceGroupDeployment', 'Get-AzureRmResourceGroupDeploymentOperation', 'Move-AzureService', 'New-AzureDeployment', 'New-AzureRmResourceGroupDeployment', 'New-AzureVM', 'Publish-AzureServiceProject', 'Remove-AzureRmResourceGroupDeployment', 'Save-AzureRmResourceGroupDeploymentTemplate', 'Stop-AzureRmResourceGroupDeployment') `
    -Parameter 'ResourceGroupName' `
    -Description 'Complete the -DeploymentName parameter value for Azure cmdlets: Get-AzureDeploymentEvent -DeploymentName <TAB>' `
    -ScriptBlock $function:DeploymentNameCompleter
    
Register-ArgumentCompleter `
    -Command ( 'Get-AzureRmResourceGroupDeployment', 'Remove-AzureRmResourceGroupDeployment', 'Stop-AzureRmResourceGroupDeployment') `
    -Parameter 'Name' `
    -Description 'Complete the -Name parameter value for Azure cmdlets: Get-AzureDeploymentEvent -Name <TAB>' `
    -ScriptBlock $function:DeploymentNameCompleter
    

