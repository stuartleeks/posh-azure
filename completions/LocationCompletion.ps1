function LocationCompleter
{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)


    ### Attempt to read Azure location details from the cache
    $CacheKey = 'AzureGeneral_LocationCache'
    $LocationCache = Get-CompletionPrivateData -Key $CacheKey

    ### If there is a valid cache for the Azure locations, then go ahead and return them immediately
    if ($LocationCache -and (Get-Date) -gt $LocationCache.ExpirationTime) {
        $ItemList = $LocationCache
    } else {
        ### Create fresh completion results for Azure locations
        $ItemList = Get-AzureRmResourceProvider | Select-Object -ExpandProperty ResourceTypes | Select-Object -ExpandProperty Locations -Unique | Sort-Object

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

#  "'" + [string]::Join("', '", (Get-Command -Module Azure* -ParameterName Location -ParameterType string | Sort-Object -Property Name)) + "'" | clip

Register-ArgumentCompleter `
    -Command ( 'Add-AzureTrafficManagerEndpoint', 'Get-AzureAutomationAccount', 'Get-AzureRmResourceGroup', 'Get-AzureRmResourceProvider', 'Get-AzureRmVMExtensionImage', 'Get-AzureRmVMExtensionImageType', 'Get-AzureRmVMImage', 'Get-AzureRmVMImageOffer', 'Get-AzureRmVMImagePublisher', 'Get-AzureRmVMImageSku', 'Get-AzureRmVMSize', 'Get-AzureRmVMUsage', 'Get-AzureSchedulerJob', 'Get-AzureSchedulerJobCollection', 'Get-AzureSchedulerJobHistory', 'Get-AzureSiteRecoveryVaultSettingsFile', 'Grant-AzureHDInsightHttpServicesAccess', 'Grant-AzureHDInsightRdpAccess', 'Invoke-AzureRecoveryServicesVaultUpgrade', 'New-AzureAffinityGroup', 'New-AzureAutomationAccount', 'New-AzureHDInsightCluster', 'New-AzureMediaServicesAccount', 'New-AzureNetworkSecurityGroup', 'New-AzureQuickVM', 'New-AzureRemoteAppCollection', 'New-AzureRemoteAppTemplateImage', 'New-AzureRemoteAppVNet', 'New-AzureReservedIP', 'New-AzureRmAvailabilitySet', 'New-AzureRmContainerServiceConfig', 'New-AzureRmDiskConfig', 'New-AzureRmImageConfig', 'New-AzureRmResource', 'New-AzureRmResourceGroup', 'New-AzureRmSnapshotConfig', 'New-AzureRmVM', 'New-AzureRmVmssConfig', 'New-AzureRouteTable', 'New-AzureSBNamespace', 'New-AzureSchedulerHttpJob', 'New-AzureSchedulerJobCollection', 'New-AzureSchedulerStorageQueueJob', 'New-AzureService', 'New-AzureSiteRecoveryVault', 'New-AzureSqlDatabaseServer', 'New-AzureStorageAccount', 'New-AzureStoreAddOn', 'New-AzureVirtualNetworkGateway', 'New-AzureVM', 'New-AzureWebsite', 'New-WAPackSBNamespace', 'New-WAPackWebsite', 'Publish-AzureServiceProject', 'Remove-AzureSchedulerJob', 'Remove-AzureSchedulerJobCollection', 'Revoke-AzureHDInsightHttpServicesAccess', 'Revoke-AzureHDInsightRdpAccess', 'Set-AzureRmVMAccessExtension', 'Set-AzureRmVMADDomainExtension', 'Set-AzureRmVMBginfoExtension', 'Set-AzureRmVMChefExtension', 'Set-AzureRmVMCustomScriptExtension', 'Set-AzureRmVMDiagnosticsExtension', 'Set-AzureRmVMDscExtension', 'Set-AzureRmVMExtension', 'Set-AzureRmVMSqlServerExtension', 'Set-AzureSchedulerHttpJob', 'Set-AzureSchedulerJobCollection', 'Set-AzureSchedulerStorageQueueJob', 'Set-AzureServiceProject', 'Set-AzureTrafficManagerEndpoint', 'Test-AzureRecoveryServicesVaultUpgrade'
) `
    -Parameter 'Location' `
    -ScriptBlock $function:LocationCompleter
    

