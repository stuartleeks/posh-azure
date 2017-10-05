function WebAppNameCompleter {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $boundParameters)

    $resourceGroupName = $boundParameters["ResourceGroupName"]
    if ($resourceGroupName -ne $null) {
        ### Create fresh completion results for Azure locations
        $ItemList = Get-AzureRmWebApp -ResourceGroupName $resourceGroupName | ForEach-Object { $_.Name } | Sort-Object # Select-Object with -ExpandParameter didn't work here!
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
    -Command ( 'Edit-AzureRmWebAppBackupConfiguration', 'Get-AzureRmWebApp', 'Get-AzureRmWebAppBackup', 'Get-AzureRmWebAppBackupConfiguration', 'Get-AzureRmWebAppBackupList', 'Get-AzureRmWebAppCertificate', 'Get-AzureRmWebAppMetrics', 'Get-AzureRmWebAppPublishingProfile', 'Get-AzureRmWebAppSlot', 'Get-AzureRmWebAppSlotConfigName', 'Get-AzureRmWebAppSlotMetrics', 'Get-AzureRmWebAppSlotPublishingProfile', 'Get-AzureRmWebAppSSLBinding', 'New-AzureRmWebApp', 'New-AzureRmWebAppBackup', 'New-AzureRmWebAppSlot', 'New-AzureRmWebAppSSLBinding', 'Remove-AzureRmWebApp', 'Remove-AzureRmWebAppBackup', 'Remove-AzureRmWebAppSlot', 'Remove-AzureRmWebAppSSLBinding', 'Reset-AzureRmWebAppPublishingProfile', 'Reset-AzureRmWebAppSlotPublishingProfile', 'Restart-AzureRmWebApp', 'Restart-AzureRmWebAppSlot', 'Restore-AzureRmWebAppBackup', 'Set-AzureRmWebApp', 'Set-AzureRmWebAppSlot', 'Set-AzureRmWebAppSlotConfigName', 'Start-AzureRmWebApp', 'Start-AzureRmWebAppSlot', 'Stop-AzureRmWebApp', 'Stop-AzureRmWebAppSlot', 'Swap-AzureRmWebAppSlot', 'Switch-AzureRmWebAppSlot'
 ) `
    -Parameter 'Name' `
    -ScriptBlock $function:WebAppNameCompleter
    

