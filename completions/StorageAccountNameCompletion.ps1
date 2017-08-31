function StorageAccountNameCompleter {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $boundParameters)

    $params = @{};
    $resourceGroupName = $boundParameters["ResourceGroupName"]
    if ($resourceGroupName -ne $null) {
        $params.ResourceGroupName = $resourceGroupName;
    }
    $ItemList = Get-AzureRmStorageAccount @params | ForEach-Object { $_.StorageAccountName } | Sort-Object # Select-Object with -ExpandParameter didn't work here!
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

# "'" + [string]::Join("', '", (Get-command -Module AzureRM.Storage -Name *Storage* -ParameterName Name -ParameterType string | Sort-Object -Property Name)) + "'" | clip

Register-ArgumentCompleter `
    -Command ( 'Get-AzureRmStorageAccount', 'Get-AzureRmStorageAccountKey', 'Get-AzureRmStorageAccountNameAvailability', 'Get-AzureStorageContainerAcl', 'New-AzureRmStorageAccount', 'New-AzureRmStorageAccountKey', 'Remove-AzureRmStorageAccount', 'Set-AzureRmCurrentStorageAccount', 'Set-AzureRmStorageAccount'    
) `
    -Parameter 'Name' `
    -Description 'Complete the -Name parameter value for Azure cmdlets: Get-AzureRmStorageAccount -Name <TAB>' `
    -ScriptBlock $function:StorageAccountNameCompleter
    

