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

# "'" + [string]::Join("', '", (Get-Command -Module AzureRm* -ParameterName DeploymentName -ParameterType string | Sort-Object -Property Name)) + "'" | clip

Register-ArgumentCompleter `
    -Command ( 'Show-AzureRmResourceGroupDeploymentProgress', 'Get-AzureRmResourceGroupDeployment', 'Get-AzureRmResourceGroupDeploymentOperation', 'New-AzureRmResourceGroupDeployment', 'Remove-AzureRmResourceGroupDeployment', 'Save-AzureRmResourceGroupDeploymentTemplate', 'Stop-AzureRmResourceGroupDeployment' ) `
    -Parameter 'DeploymentName' `
    -ScriptBlock $function:DeploymentNameCompleter
    
Register-ArgumentCompleter `
    -Command ( 'Get-AzureRmResourceGroupDeployment', 'Remove-AzureRmResourceGroupDeployment', 'Stop-AzureRmResourceGroupDeployment') `
    -Parameter 'Name' `
    -ScriptBlock $function:DeploymentNameCompleter
    

