function VMNameCompleter {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $boundParameters)

    $resourceGroupName = $boundParameters["ResourceGroupName"]
    if ($resourceGroupName -ne $null) {
        ### Create fresh completion results for Azure locations
        $ItemList = Get-AzureRmVM -ResourceGroupName $resourceGroupName | ForEach-Object { $_.Name } | Sort-Object # Select-Object with -ExpandParameter didn't work here!
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

# "'" + [string]::Join("', '", (Get-command -Module AzureRM* -Name *VM* -ParameterName VMName)) + "'" | clip

Register-ArgumentCompleter `
    -Command ( 'ConvertTo-AzureRmVMManagedDisk', 'ConvertTo-AzureRmVMManagedDisk', 'Disable-AzureRmVMDiskEncryption', 'Disable-AzureRmVMDiskEncryption', 'Get-AzureRmVM', 'Get-AzureRmVM', 'Get-AzureRmVMAccessExtension', 'Get-AzureRmVMAccessExtension', 'Get-AzureRmVMADDomainExtension', 'Get-AzureRmVMADDomainExtension', 'Get-AzureRmVMAEMExtension', 'Get-AzureRmVMAEMExtension', 'Get-AzureRmVMBootDiagnosticsData', 'Get-AzureRmVMBootDiagnosticsData', 'Get-AzureRmVMChefExtension', 'Get-AzureRmVMChefExtension', 'Get-AzureRmVMCustomScriptExtension', 'Get-AzureRmVMCustomScriptExtension', 'Get-AzureRmVMDiagnosticsExtension', 'Get-AzureRmVMDiagnosticsExtension', 'Get-AzureRmVMDiskEncryptionStatus', 'Get-AzureRmVMDiskEncryptionStatus', 'Get-AzureRmVMDscExtension', 'Get-AzureRmVMDscExtension', 'Get-AzureRmVMDscExtensionStatus', 'Get-AzureRmVMDscExtensionStatus', 'Get-AzureRmVMExtension', 'Get-AzureRmVMExtension', 'Get-AzureRmVMSize', 'Get-AzureRmVMSize', 'Get-AzureRmVMSqlServerExtension', 'Get-AzureRmVMSqlServerExtension', 'New-AzureRmVMConfig', 'New-AzureRmVMConfig', 'Remove-AzureRmVM', 'Remove-AzureRmVM', 'Remove-AzureRmVMAccessExtension', 'Remove-AzureRmVMAccessExtension', 'Remove-AzureRmVMAEMExtension', 'Remove-AzureRmVMAEMExtension', 'Remove-AzureRmVMBackup', 'Remove-AzureRmVMBackup', 'Remove-AzureRmVMChefExtension', 'Remove-AzureRmVMChefExtension', 'Remove-AzureRmVMCustomScriptExtension', 'Remove-AzureRmVMCustomScriptExtension', 'Remove-AzureRmVMDiagnosticsExtension', 'Remove-AzureRmVMDiagnosticsExtension', 'Remove-AzureRmVMDiskEncryptionExtension', 'Remove-AzureRmVMDiskEncryptionExtension', 'Remove-AzureRmVMDscExtension', 'Remove-AzureRmVMDscExtension', 'Remove-AzureRmVMExtension', 'Remove-AzureRmVMExtension', 'Remove-AzureRmVMSqlServerExtension', 'Remove-AzureRmVMSqlServerExtension', 'Save-AzureRmVMImage', 'Save-AzureRmVMImage', 'Set-AzureRmVMAccessExtension', 'Set-AzureRmVMAccessExtension', 'Set-AzureRmVMADDomainExtension', 'Set-AzureRmVMADDomainExtension', 'Set-AzureRmVMAEMExtension', 'Set-AzureRmVMAEMExtension', 'Set-AzureRmVMBackupExtension', 'Set-AzureRmVMBackupExtension', 'Set-AzureRmVMBginfoExtension', 'Set-AzureRmVMBginfoExtension', 'Set-AzureRmVMChefExtension', 'Set-AzureRmVMChefExtension', 'Set-AzureRmVMCustomScriptExtension', 'Set-AzureRmVMCustomScriptExtension', 'Set-AzureRmVMDiagnosticsExtension', 'Set-AzureRmVMDiagnosticsExtension', 'Set-AzureRmVMDiskEncryptionExtension', 'Set-AzureRmVMDiskEncryptionExtension', 'Set-AzureRmVMDscExtension', 'Set-AzureRmVMDscExtension', 'Set-AzureRmVMExtension', 'Set-AzureRmVMExtension', 'Set-AzureRmVMSqlServerExtension', 'Set-AzureRmVMSqlServerExtension', 'Test-AzureRmVMAEMExtension', 'Test-AzureRmVMAEMExtension'   
 ) `
    -Parameter 'VMName' `
    -Description 'Complete the -VMName parameter value for Azure cmdlets: Get-AzureRmVMExtension -VMName <TAB>' `
    -ScriptBlock $function:VMNameCompleter
    

# "'" + [string]::Join("', '", (Get-command -Module AzureRM* -Name *AzureRmVM -ParameterName Name)) + "'" | clip

Register-ArgumentCompleter `
-Command ( 'Get-AzureRmVM', 'Get-AzureRmVM', 'Remove-AzureRmVM', 'Remove-AzureRmVM', 'Restart-AzureRmVM', 'Restart-AzureRmVM', 'Set-AzureRmVM', 'Set-AzureRmVM', 'Start-AzureRmVM', 'Start-AzureRmVM', 'Stop-AzureRmVM', 'Stop-AzureRmVM'
) `
-Parameter 'Name' `
-Description 'Complete the -Name parameter value for Azure cmdlets: Get-AzureRmVM -Name <TAB>' `
-ScriptBlock $function:VMNameCompleter
