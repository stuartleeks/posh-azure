function AppServicePlanNameCompleter {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $boundParameters)

    $params = @{};
    $resourceGroupName = $boundParameters["ResourceGroupName"]
    if ($resourceGroupName -ne $null) {
        $params.ResourceGroupName = $resourceGroupName;
    }
    $ItemList = Get-AzureRmAppServicePlan @params | ForEach-Object { $_.Name } | Sort-Object # Select-Object with -ExpandParameter didn't work here!
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

# "'" + [string]::Join("', '", (Get-Command -Module *Azure* -Name *AzureRmAppServicePlan* -ParameterName Name -ParameterType string | Sort-Object -Property Name)) + "'" | clip

Register-ArgumentCompleter `
    -Command ( 'Get-AzureRmAppServicePlan', 'Get-AzureRmAppServicePlanMetrics', 'New-AzureRmAppServicePlan', 'Remove-AzureRmAppServicePlan', 'Set-AzureRmAppServicePlan'    
) `
    -Parameter 'Name' `
    -Description 'Complete the -Name parameter value for Azure cmdlets: Get-AzureRmAppServicePlan -Name <TAB>' `
    -ScriptBlock $function:AppServicePlanNameCompleter
    

