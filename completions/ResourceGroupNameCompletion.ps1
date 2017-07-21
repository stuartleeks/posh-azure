function AzureGeneral_ResourceGroupNameCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)


    ### Attempt to read Azure location details from the cache
    $CacheKey = 'AzureGeneral_ResourceGroupNameCache'
    $NameCache = Get-CompletionPrivateData -Key $CacheKey

    ### If there is a valid cache for the Azure locations, then go ahead and return them immediately
    if ($NameCache -and (Get-Date) -gt $NameCache.ExpirationTime) {
        $ItemList = $NameCache
    } else {
        ### Create fresh completion results for Azure locations
        $ItemList = Get-AzureRmResourceGroup | Select-Object -ExpandProperty ResourceGroupName -Unique | Sort-Object

        # Update the cache for Azure locations
        Set-CompletionPrivateData -Key $CacheKey -Value $ItemList
    }
    
    ### Return the fresh completion results
    $wordToCompleteWildcard = $wordToComplete.Trim("'") + "*"

    $results = $ItemList `
            | Where-Object { $PSItem -like $wordToCompleteWildcard} `
            | Foreach-Object {
                if($PSItem -ne $null -and $PSItem -ne ""){
                    $CompletionResult = @{
                        CompletionText = $PSItem
                        ToolTip = $PSItem
                        ListItemText = $PSItem
                        CompletionResultType = [System.Management.Automation.CompletionResultType]::ParameterValue
                        }
                    New-CompletionResult @CompletionResult
                }
            }
    return $results
}

# "'" + [string]::Join("', '", (Get-Command -Module AzureRm* -ParameterName ResourceGroupName -ParameterType string | sort-object -Property Name| Sort-Object -Property Name)) + "'" | clip

Register-ArgumentCompleter `
    -Command ( 'Add-AzureRmVhd', 'ConvertTo-AzureRmVMManagedDisk', 'Disable-AzureRmVMDiskEncryption', 'Edit-AzureRmWebAppBackupConfiguration', 'Export-AzureRmResourceGroup', 'Find-AzureRmResource', 'Get-AzureRmAppServicePlan', 'Get-AzureRmAppServicePlanMetrics', 'Get-AzureRmAvailabilitySet', 'Get-AzureRmContainerService', 'Get-AzureRmDisk', 'Get-AzureRmImage', 'Get-AzureRmRemoteDesktopFile', 'Get-AzureRmResource', 'Get-AzureRmResourceGroup', 'Get-AzureRmResourceGroupDeployment', 'Get-AzureRmResourceGroupDeploymentOperation', 'Get-AzureRmResourceLock', 'Get-AzureRmRoleAssignment', 'Get-AzureRmSnapshot', 'Get-AzureRmVM', 'Get-AzureRmVMAccessExtension', 'Get-AzureRmVMADDomainExtension', 'Get-AzureRmVMAEMExtension', 'Get-AzureRmVMBootDiagnosticsData', 'Get-AzureRmVMChefExtension', 'Get-AzureRmVMCustomScriptExtension', 'Get-AzureRmVMDiagnosticsExtension', 'Get-AzureRmVMDiskEncryptionStatus', 'Get-AzureRmVMDscExtension', 'Get-AzureRmVMDscExtensionStatus', 'Get-AzureRmVMExtension', 'Get-AzureRmVMSize', 'Get-AzureRmVMSqlServerExtension', 'Get-AzureRmVmss', 'Get-AzureRmVmssSku', 'Get-AzureRmVmssVM', 'Get-AzureRmWebApp', 'Get-AzureRmWebAppBackup', 'Get-AzureRmWebAppBackupConfiguration', 'Get-AzureRmWebAppBackupList', 'Get-AzureRmWebAppCertificate', 'Get-AzureRmWebAppMetrics', 'Get-AzureRmWebAppPublishingProfile', 'Get-AzureRmWebAppSlot', 'Get-AzureRmWebAppSlotConfigName', 'Get-AzureRmWebAppSlotMetrics', 'Get-AzureRmWebAppSlotPublishingProfile', 'Get-AzureRmWebAppSSLBinding', 'Grant-AzureRmDiskAccess', 'Grant-AzureRmSnapshotAccess', 'Invoke-AzureRmResourceAction', 'New-AzureRmAppServicePlan', 'New-AzureRmAvailabilitySet', 'New-AzureRmContainerService', 'New-AzureRmDisk', 'New-AzureRmImage', 'New-AzureRmResource', 'New-AzureRmResourceGroup', 'New-AzureRmResourceGroupDeployment', 'New-AzureRmResourceLock', 'New-AzureRmRoleAssignment', 'New-AzureRmSnapshot', 'New-AzureRmVM', 'New-AzureRmVMSqlServerAutoBackupConfig', 'New-AzureRmVMSqlServerKeyVaultCredentialConfig', 'New-AzureRmVmss', 'New-AzureRmWebApp', 'New-AzureRmWebAppBackup', 'New-AzureRmWebAppSlot', 'New-AzureRmWebAppSSLBinding', 'Publish-AzureRmVMDscConfiguration', 'Remove-AzureRmAppServicePlan', 'Remove-AzureRmAvailabilitySet', 'Remove-AzureRmContainerService', 'Remove-AzureRmDisk', 'Remove-AzureRmImage', 'Remove-AzureRmResource', 'Remove-AzureRmResourceGroup', 'Remove-AzureRmResourceGroupDeployment', 'Remove-AzureRmResourceLock', 'Remove-AzureRmRoleAssignment', 'Remove-AzureRmSnapshot', 'Remove-AzureRmVM', 'Remove-AzureRmVMAccessExtension', 'Remove-AzureRmVMAEMExtension', 'Remove-AzureRmVMBackup', 'Remove-AzureRmVMChefExtension', 'Remove-AzureRmVMCustomScriptExtension', 'Remove-AzureRmVMDiagnosticsExtension', 'Remove-AzureRmVMDiskEncryptionExtension', 'Remove-AzureRmVMDscExtension', 'Remove-AzureRmVMExtension', 'Remove-AzureRmVMSqlServerExtension', 'Remove-AzureRmVmss', 'Remove-AzureRmWebApp', 'Remove-AzureRmWebAppBackup', 'Remove-AzureRmWebAppSlot', 'Remove-AzureRmWebAppSSLBinding', 'Reset-AzureRmWebAppPublishingProfile', 'Reset-AzureRmWebAppSlotPublishingProfile', 'Restart-AzureRmVM', 'Restart-AzureRmVmss', 'Restart-AzureRmWebApp', 'Restart-AzureRmWebAppSlot', 'Restore-AzureRmWebAppBackup', 'Revoke-AzureRmDiskAccess', 'Revoke-AzureRmSnapshotAccess', 'Save-AzureRmResourceGroupDeploymentTemplate', 'Save-AzureRmVhd', 'Save-AzureRmVMImage', 'Set-AzureRmAppServicePlan', 'Set-AzureRmResource', 'Set-AzureRmResourceGroup', 'Set-AzureRmResourceLock', 'Set-AzureRmVM', 'Set-AzureRmVMAccessExtension', 'Set-AzureRmVMADDomainExtension', 'Set-AzureRmVMAEMExtension', 'Set-AzureRmVMBackupExtension', 'Set-AzureRmVMBginfoExtension', 'Set-AzureRmVMBootDiagnostics', 'Set-AzureRmVMChefExtension', 'Set-AzureRmVMCustomScriptExtension', 'Set-AzureRmVMDiagnosticsExtension', 'Set-AzureRmVMDiskEncryptionExtension', 'Set-AzureRmVMDscExtension', 'Set-AzureRmVMExtension', 'Set-AzureRmVMSqlServerExtension', 'Set-AzureRmVmss', 'Set-AzureRmVmssVM', 'Set-AzureRmWebApp', 'Set-AzureRmWebAppSlot', 'Set-AzureRmWebAppSlotConfigName', 'Start-AzureRmVM', 'Start-AzureRmVmss', 'Start-AzureRmWebApp', 'Start-AzureRmWebAppSlot', 'Stop-AzureRmResourceGroupDeployment', 'Stop-AzureRmVM', 'Stop-AzureRmVmss', 'Stop-AzureRmWebApp', 'Stop-AzureRmWebAppSlot', 'Swap-AzureRmWebAppSlot', 'Switch-AzureRmWebAppSlot', 'Test-AzureRmResourceGroupDeployment', 'Test-AzureRmVMAEMExtension', 'Update-AzureRmContainerService', 'Update-AzureRmDisk', 'Update-AzureRmImage', 'Update-AzureRmSnapshot', 'Update-AzureRmVM', 'Update-AzureRmVmss', 'Update-AzureRmVmssInstance'
 ) `
    -Parameter 'ResourceGroupName' `
    -Description 'Complete the -ResourceGroupName parameter value for Azure cmdlets: New-AzureRmResourceGroupDeployment -ResourceGroupName <TAB>' `
    -ScriptBlock $function:AzureGeneral_ResourceGroupNameCompleter
    

Register-ArgumentCompleter `
    -Command ( 'Get-AzureRmResourceGroup', "Remove-AzureRmResourceGroup") `
    -Parameter 'Name' `
    -Description 'Complete the -Name parameter value for Azure cmdlets: Get-AzureRmResourceGroup -Name <TAB>' `
    -ScriptBlock $function:AzureGeneral_ResourceGroupNameCompleter

    
Register-ArgumentCompleter `
    -Command ( 'Find-AzureRmResource') `
    -Parameter 'ResourceGroupNameEquals' `
    -Description 'Complete the -ResourceGroupNameEquals parameter value for Azure cmdlets: Find-AzureRmResource -ResourceGroupNameEquals <TAB>' `
    -ScriptBlock $function:AzureGeneral_ResourceGroupNameCompleter