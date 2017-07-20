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

#  "'" + [string]::Join("', '", (Get-Command -Module AzureRm* -ParameterName ResourceGroupName -ParameterType string)) + "'" | clip

Register-ArgumentCompleter `
    -Command ( 'Add-AzureRmVhd', 'ConvertTo-AzureRmVMManagedDisk', 'Disable-AzureRmVMDiskEncryption', 'Export-AzureRmResourceGroup', 'Find-AzureRmResource', 'Get-AzureRmAvailabilitySet', 'Get-AzureRmContainerService', 'Get-AzureRmDisk', 'Get-AzureRmImage', 'Get-AzureRmRemoteDesktopFile', 'Get-AzureRmResource', 'Get-AzureRmResourceGroup', 'Get-AzureRmResourceGroupDeployment', 'Get-AzureRmResourceGroupDeploymentOperation', 'Get-AzureRmResourceLock', 'Get-AzureRmRoleAssignment', 'Get-AzureRmSnapshot', 'Get-AzureRmVM', 'Get-AzureRmVMAccessExtension', 'Get-AzureRmVMADDomainExtension', 'Get-AzureRmVMAEMExtension', 'Get-AzureRmVMBootDiagnosticsData', 'Get-AzureRmVMChefExtension', 'Get-AzureRmVMCustomScriptExtension', 'Get-AzureRmVMDiagnosticsExtension', 'Get-AzureRmVMDiskEncryptionStatus', 'Get-AzureRmVMDscExtension', 'Get-AzureRmVMDscExtensionStatus', 'Get-AzureRmVMExtension', 'Get-AzureRmVMSize', 'Get-AzureRmVMSqlServerExtension', 'Get-AzureRmVmss', 'Get-AzureRmVmssSku', 'Get-AzureRmVmssVM', 'Grant-AzureRmDiskAccess', 'Grant-AzureRmSnapshotAccess', 'Invoke-AzureRmResourceAction', 'New-AzureRmAvailabilitySet', 'New-AzureRmContainerService', 'New-AzureRmDisk', 'New-AzureRmImage', 'New-AzureRmResource', 'New-AzureRmResourceGroup', 'New-AzureRmResourceGroupDeployment', 'New-AzureRmResourceLock', 'New-AzureRmRoleAssignment', 'New-AzureRmSnapshot', 'New-AzureRmVM', 'New-AzureRmVMSqlServerAutoBackupConfig', 'New-AzureRmVMSqlServerKeyVaultCredentialConfig', 'New-AzureRmVmss', 'Publish-AzureRmVMDscConfiguration', 'Remove-AzureRmAvailabilitySet', 'Remove-AzureRmContainerService', 'Remove-AzureRmDisk', 'Remove-AzureRmImage', 'Remove-AzureRmResource', 'Remove-AzureRmResourceGroup', 'Remove-AzureRmResourceGroupDeployment', 'Remove-AzureRmResourceLock', 'Remove-AzureRmRoleAssignment', 'Remove-AzureRmSnapshot', 'Remove-AzureRmVM', 'Remove-AzureRmVMAccessExtension', 'Remove-AzureRmVMAEMExtension', 'Remove-AzureRmVMBackup', 'Remove-AzureRmVMChefExtension', 'Remove-AzureRmVMCustomScriptExtension', 'Remove-AzureRmVMDiagnosticsExtension', 'Remove-AzureRmVMDiskEncryptionExtension', 'Remove-AzureRmVMDscExtension', 'Remove-AzureRmVMExtension', 'Remove-AzureRmVMSqlServerExtension', 'Remove-AzureRmVmss', 'Restart-AzureRmVM', 'Restart-AzureRmVmss', 'Revoke-AzureRmDiskAccess', 'Revoke-AzureRmSnapshotAccess', 'Save-AzureRmResourceGroupDeploymentTemplate', 'Save-AzureRmVhd', 'Save-AzureRmVMImage', 'Set-AzureRmResource', 'Set-AzureRmResourceGroup', 'Set-AzureRmResourceLock', 'Set-AzureRmVM', 'Set-AzureRmVMAccessExtension', 'Set-AzureRmVMADDomainExtension', 'Set-AzureRmVMAEMExtension', 'Set-AzureRmVMBackupExtension', 'Set-AzureRmVMBginfoExtension', 'Set-AzureRmVMBootDiagnostics', 'Set-AzureRmVMChefExtension', 'Set-AzureRmVMCustomScriptExtension', 'Set-AzureRmVMDiagnosticsExtension', 'Set-AzureRmVMDiskEncryptionExtension', 'Set-AzureRmVMDscExtension', 'Set-AzureRmVMExtension', 'Set-AzureRmVMSqlServerExtension', 'Set-AzureRmVmss', 'Set-AzureRmVmssVM', 'Start-AzureRmVM', 'Start-AzureRmVmss', 'Stop-AzureRmResourceGroupDeployment', 'Stop-AzureRmVM', 'Stop-AzureRmVmss', 'Test-AzureRmResourceGroupDeployment', 'Test-AzureRmVMAEMExtension', 'Update-AzureRmContainerService', 'Update-AzureRmDisk', 'Update-AzureRmImage', 'Update-AzureRmSnapshot', 'Update-AzureRmVM', 'Update-AzureRmVmss', 'Update-AzureRmVmssInstance') `
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