# load argument completions
foreach ($file in dir $PSScriptRoot\completions\*.ps1) {
    . $file.FullName
}

<#
 # Helper function for other cmdlets
 #>
function ParseOperationDuration($durationString) {

    # TODO - create tests for this behavior!
    # expected behaviour (should put in tests)
    #(ParseOperationDuration "PT21.501S").ToString() # Timespan: 21.501 seconds
    #(ParseOperationDuration "PT5M21.501S").ToString() # Timespan: 5 minutes 21.501 seconds
    #(ParseOperationDuration "PT1H5M21.501S").ToString() # Timespan: 1 hour 5 minutes 21.501 seconds
    #(ParseOperationDuration "PT 21.501S").ToString() # throws exception for unhandled format

    $negative = $false
    if ($durationString.StartsWith("-"))
    {
        $negative = $true;
        $durationString = $durationString.Substring(1)
    }
    $timespan = $null
    switch -Regex ($durationString) {
        "^PT(?<seconds>\d*.\d*)S$" {
            $timespan = New-TimeSpan -Seconds $matches["seconds"]
        }
        "^PT(?<minutes>\d*)M(?<seconds>\d*.\d*)S$" {
            $timespan = New-TimeSpan -Minutes $matches["minutes"] -Seconds $matches["seconds"]
        }
        "^PT(?<hours>\d*)H(?<minutes>\d*)M(?<seconds>\d*.\d*)S$" {
            $timespan = New-TimeSpan -Hours $matches["hours"] -Minutes $matches["minutes"] -Seconds $matches["seconds"]
        }
    }
    if ($null -eq $timespan) {
        $message = "unhandled duration format '$durationString'"
        throw $message
    }
    if ($negative){
        $timespan = [TimeSpan]::Zero - $timespan
    }
    $timespan
}

function GetOperations($deployment) {
    Get-AzureRmResourceGroupDeploymentOperation `
        -ResourceGroupName $ResourceGroupName `
        -DeploymentName $deployment.DeploymentName `
        | ForEach-Object {
        $timeStamp = [System.DateTime]::Parse($_.Properties.Timestamp);
        $duration = (ParseOperationDuration $_.Properties.Duration);
        [PSCustomObject]@{ 
            "Id"                = $_.OperationId; 
            "ProvisioningState" = $_.Properties.ProvisioningState; 
            "ResourceType"      = $_.Properties.TargetResource.ResourceType; 
            "ResourceName"      = $_.Properties.TargetResource.ResourceName; 
            "StartTime"         = $timeStamp - $duration; 
            "EndTime"           = $timeStamp; 
            "Duration"          = $duration;
            "Error"             = $_.Properties.StatusMessage.Error;
        }
    } `
        | Sort-Object -Property StartTime, ResourceType, ResourceName, Id
}
function DumpOperations($operations) {
    # $tableFormat = @{Expression = {$_.Id}; Label = "ID"}, `
    # @{Expression = {$_.ProvisioningState}; Label = "State"; width = 15}, `
    # @{Expression = {$_.ResourceType}; Label = "ResourceType"; width = 15}, `
    # @{Expression = {$_.ResourceName}; Label = "ResourceName"; width = 15}, `
    # @{Expression = {$_.StartTime}; Label = "StartTime"; width = 40}
    $tableFormat = @{Expression = {$_.ProvisioningState}; Label = "State"; width = 12}, `
    @{Expression = {$_.ResourceType}; Label = "ResourceType"; width = 45}, `
    @{Expression = {$_.ResourceName}; Label = "ResourceName"; width = 45}, `
    @{Expression = {$_.StartTime}; Label = "StartTime"; width = 20}, `
    @{Expression = {$_.Duration}; Label = "Duration"; width = 20}

    $text = $operations | Format-Table  $tableFormat | Out-String
    $text.Split("`n") | ForEach-Object {
        $line = $_.Trim("`r")
        if ($line.StartsWith("Succeeded")) {
            Write-Host -ForegroundColor DarkGray $line
        }
        elseif ($line.StartsWith("Running")) {
            Write-Host -ForegroundColor Green $line
        }
        elseif ($line.StartsWith("Failed")) {
            Write-Host -ForegroundColor Red $line
        }
        else {
            Write-Host $line
        }
    }
}

function GetOutputs($deployment){
    $deployment.Outputs.Keys | `
        ForEach-Object { 
            [PSCustomObject]@{
                Name=$_
                Type=$deployment.Outputs[$_].Type
                Value=$deployment.Outputs[$_].Value
            }
        } 
}
function DumpOutputs($deployment){
    $outputs = GetOutputs $deployment
    $outputs | Format-Table
}

function GetDeployments($deploymentName) {
    $deployment = Get-AzureRmResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -Name $deploymentName `
        -ErrorAction SilentlyContinue

    if ($deployment -eq $null) {
        return $null
    }

    $operations = GetOperations $deployment

    $deploymentSummary = [PSCustomObject]@{Deployment = $deployment; Operations = $operations};
    $deployments = @($deploymentSummary)

    $nestedNames = $operations `
        | Where-Object { $_.ResourceType -eq "Microsoft.Resources/deployments" } `
        | Select-Object -ExpandProperty ResourceName 
    foreach ($nestedName in $nestedNames) {
        $nestedDeployments = GetDeployments $nestedName
        if ($nestedDeployments -ne $null) {
            $deployments = $deployments + $nestedDeployments
        }
    }

    return $deployments
}

function Show-AzureRmResourceGroupDeploymentProgress() {
    [CmdletBinding()]
    param(
        [string] $ResourceGroupName,
        [string] $DeploymentName = "",
        [int]    $RefreshDelay = 10 # seconds
    )
    $ErrorActionPreference = "Stop"

    if ($DeploymentName -eq "") {
        $deployment = Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
            | Sort-Object -Property Timestamp -Descending `
            | Select-Object -First 1 
        if ($deployment -eq $null){
            Write-Host "No deployments"
            return
        }
        $DeploymentName = $deployment.DeploymentName
    }

    do {
        $deployments = GetDeployments $DeploymentName

        if ($deployments -eq $null) {
            Write-Host "No deployments"
            return
        }
        Clear-Host
        foreach ($summary in $deployments) {
            $deployment = $summary.Deployment
            $operations = $summary.Operations
            $duration = (get-date) - $deployment.Timestamp
            if ($deployments[0].Deployment.ProvisioningState -eq "Running") {
                Write-Host "Deployment: $($deployment.DeploymentName) ($($deployment.ProvisioningState) - duration $duration)"
            } else
            {
                Write-Host "Deployment: $($deployment.DeploymentName) ($($deployment.ProvisioningState))" # skip duration once completed as we don't know the end time
            }
            DumpOperations $operations
        }

        if ($deployments[0].Deployment.ProvisioningState -ne "Running") {
            Write-Host "Deployment finished"
            Write-Host "Outputs:"
            DumpOutputs $deployment
            return
        }

        Start-Sleep -Seconds $RefreshDelay
    } while ( $true) 

}