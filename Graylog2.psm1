#Requires -Version 3
# ------------------------------------------------------------------------
# NAME: Graylog2.psm1
# AUTHOR: Stefan jarina (stefan@jarina.cz)
# DATE: 2018.11.01
#
# COMMENTS: Powershell module for managing Graylog2
# ------------------------------------------------------------------------


##########################################################################
# HELPER FUNCTIONS: Private functions - not exported to user
##########################################################################

function _Load_Local_Config {
    $path = "HKCU:\Software\TE\GraylogPSModule"
    If ((Test-Path $path))
    {
        try {
            $baseUrl = (Get-ItemProperty -Path $path\Config).BaseUrl
            $token = (Get-ItemProperty -Path $path\Config).Token
        }
        catch {
            Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
            Return
        }
        
        $psw = "token" | ConvertTo-SecureString -AsPlainText -Force
        $PScreds = New-Object -typename System.Management.Automation.PSCredential -argumentlist $token, $psw 

        return @{
            BaseUrl = $baseUrl;
            Cred = $PScreds
        }
    } else {
        Write-Output "There is no local configuration available, please use 'Connect-Graylog2RestApi' to generate config"
        return
    }
}

function _Generate_Local_Config {
    param (
        $BaseUrl,
        $Token
    )

    $path = "HKCU:\Software\TE\GraylogPSModule"
    If (!(Test-Path $path))
    {
        try {
            New-Item -Path $path -Force
            New-Item -Path $path\Config
            New-ItemProperty -Path $path\Config -PropertyType String -Name BaseUrl -Value $BaseUrl
            New-ItemProperty -Path $path\Config -PropertyType String -Name Token -Value $Token
            Write-Output "Configuration created and stored in registry."
        }
        catch {
            Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
            Return
        }

    }
}

function _Get_Token {
    param (
        $Result
    )
    try {
        $token = $Result.token
    }
    catch {
        Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
        Return
    }
    return $token
}

function _Rest_Api_Call {
    param (
        $UrlPath,
        $Method="Get",
        $Payload
    )
    $config = _Load_Local_Config
    if ($Payload) {
        $result = Invoke-RestMethod -Credential $config.Cred -Uri "$($config.BaseUrl)/$Urlpath" -Method $Method -ContentType "application/json" -Body ($Payload | ConvertTo-Json -Compress)
    } else {
        $result = Invoke-RestMethod -Credential $config.Cred -Uri "$($config.BaseUrl)/$Urlpath" -Method $Method -ContentType "application/json"
    }
    return $result
}

##########################################################################
# CONNECTION FUNCTIONS - Functions used for Login/Token Generation
##########################################################################

function Connect-Graylog2RestApi {
    <#
	.SYNOPSIS
	Connect to Graylog2 REST API
	.DESCRIPTION
	Connect to Graylog2 server through REST API and prompt for credentials.
	This function will request token and store it in users registry.
	.EXAMPLE
	Connect-Graylog2Rest -Address 69.69.69.69
	.EXAMPLE
	Connect-Graylog2Rest -Address 69.69.69.69 -Port 8080
	.PARAMETER Address
	IP address of Graylog2 REST API instance
	.PARAMETER Port
	Used to specified custom (aka non-12900) REST API port
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)][string]$Address,
        [int]$Port = 9000
    )

    try {
        $credential = Get-Credential
    }
    catch {
        Write-Host -ForegroundColor Red "You must specify your username and password in order for Graylog to issue token for future use."
    }
    try {
        $result = Invoke-RestMethod -Credential $credential -Uri "http://$($Address):$Port/api/users/$($credential.UserName)/tokens/icinga" -Method post -ContentType "application/json"
        $token = _Get_Token $result
        _Generate_Local_Config -BaseUrl "http://$($Address):$Port/api" -Token $token
    }
    catch {
        Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
        Return
    }
}


##########################################################################
# COMMON FUNCTIONS - Functions that does not interact with API Endpoint
##########################################################################

function Get-Graylog2StreamRuleType {
	<#
	.SYNOPSIS
	Display static stream rule type
	.DESCRIPTION
	This is used to make easier stream management
	.EXAMPLE
	Get-Graylog2StreamRuleType
	#>

	$streamRuleType = @()
	foreach ($ruletype in (@("match exactly",1),@("match regular expression",2),@("greater than",3),@("smaller than",4))) {
		$tmpDbLine = "" | Select-Oject Name, TypeId
		$tmpDbLine.Name = $ruletype[0]
		$tmpDbLine.TypeId = $ruletype[1]
		$streamRuleType += $tmpDbLine
	}

	Return $streamRuleType
}

##########################################################################
# REST API FUNCTIONS - Functions that interact with API Endpoint
##########################################################################

# Alerts: Manage stream alerts for all streams
# END Alerts

# Counts: Message counts

function Get-Graylog2MessageCounts {
	<#
	.SYNOPSIS
	Retrieve total message count handled by Graylog2
	.EXAMPLE
	Get-Graylog2MessageCounts
	#>

	try {
		$messageCount = _Rest_Api_Call -UrlPath "count/total"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return [long]($messageCount.events)
}

# END Counts

# Dashboards: Manage Dashboards
# END Dashboards

# Dashboards/Widgets: Manage widgets of an existing dashboard
# END Dashboards/Widgets

# Extractors: Extractors of an input

function Get-Graylog2Extractors {
	<#
	.SYNOPSIS
	List all extractors of an input
	.EXAMPLE
	Get-Graylog2Extractors -inputId "52d6abb4498e2b793a713fc7"
	.PARAMETER inputId
	The input id to list extractors
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)][string]$inputId
	)
	
	if ((Get-Graylog2Inputs | Where-Object { $_.Id -eq $inputId } | Measure-Object).Count -ne 1) {
		Write-Host -ForegroundColor Red "Error on input with inputId $inputId, please check before running this command again"
		Return
	}

	try {
		$extractors = _Rest_Api_Call -UrlPath "system/inputs/$inputId/extractors"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	return $extractors.extractors
}

# END Extractors

# Indexer/Cluster: Indexer cluster information

function Get-Graylog2ClusterHealth {
	<#
	.SYNOPSIS
	Get cluster and shard health overview
	.EXAMPLE
	Get-Graylog2ClusterHealth
	#>

	try {
		$clusterHealth = _Rest_Api_Call -Uri -UrlPath "system/indexer/cluster/health"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $clusterHealth
}

function Remove-Graylog2Extractor {
	<#
	.SYNOPSIS
	Delete an extractor
	.EXAMPLE
	Remove-Graylog2Extractor -inputId "52d6abb4498e2b793a713fc7" -extractorId "52d6abb4498e2b793a713fc7"
	.PARAMETER inputId
	The input id to delete extractor from
	.PARAMETER extractorId
	The extractor id to delete
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)][string]$inputId,
		[Parameter(Mandatory=$True)][string]$extractorId
	)
	
	if ((Get-Graylog2Extractors -inputId $inputId | Where-Object { $_.extractorId -eq $extractorId } | Measure-Object).Count -ne 1) {
		Write-Host -ForegroundColor Red "Error on extractor with extractorId $extractorId, please check before running this command again"
		Return
	}

	try {
		$extractorDeleted = _Rest_Api_Call -Method Delete -UrlPath "system/inputs/$inputId/exractors/$extractorId"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Write-Debug "Extractor $extractorId from input $inputId deleted successfully"
	Return
}

# END Indexer/Cluster

# Indexer/Failures

function Get-Graylog2IndexerFailures {
	<#
	.SYNOPSIS
	Get a list of failed index operations
	.EXAMPLE
	Get-Graylog2IndexerFailures -limit 100 -offset 10
	.PARAMETER limit
	Limit of failures to retrieve
	.PARAMETER offset
	number of failures to skip
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)][int]$limit,
		[Parameter(Mandatory=$True)][int]$offset
	)

	try {
		$failures = _Rest_Api_Call -UrlPath "system/indexer/failures?limit=$limit&offset=$offset"
	}
	catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}
	
	return $failures.failures
}

function Get-Graylog2IndexerFailuresCount {
	<#
	.SYNOPSIS
	Get total count of failed index operations since the given date
	.EXAMPLE
	Get-Graylog2IndexerFailures -limit 100 -offset 10
	.PARAMETER since
	Specify date in "ISO8601". Failures will be retrieved from this date
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)][string]$since
	)

	try {
		$failuresCount = _Rest_Api_Call -UrlPath "system/indexer/failures/count?since=$since"
	}
	catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}
	
	return $failuresCount.count
}

# END Indexer/Failures

# Indexer/Indices: Index Information

function Get-Graylog2Indices {
	<#
	.SYNOPSIS
	Get a list of all open, closed and reopened indices
	.EXAMPLE
	Get-Graylog2Indices
	#>
	# TODO: Return better object
	try {
		$closedIndices = _Rest_Api_Call -UrlPath "system/indexer/indices"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	if ($closedIndices.total -eq 0) {
		Write-Host -ForegroundColor Yellow "No closed indices."
		Return
	}

	Return $closedIndices
}
function Get-Graylog2ClosedIndices {
	<#
	.SYNOPSIS
	Get a list of closed indices that can be reopened.
	.EXAMPLE
	Get-Graylog2ClosedIndices
	#>

	try {
		$closedIndices = _Rest_Api_Call -UrlPath "system/indexer/indices/closed"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	if ($closedIndices.total -eq 0) {
		Write-Host -ForegroundColor Yellow "No closed indices."
		Return
	}

	Return $closedIndices.indices
}

function Remove-Graylog2Index {
	<#
	.SYNOPSIS
	Delete an index.
	.DESCRIPTION
	This will also trigger an index ranges rebuild job.
	.EXAMPLE
	Remove-Graylog2Index -index "graylog2_23"
	.PARAMETER index
	Name of the index to remove
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)][string]$index
	)

	try {
		$removedIndex = _Rest_Api_Call -Method Delete -UrlPath "system/indexer/indices/$index"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Write-Debug "Index $index deleted successfully"
	Return
}

# END Indexer/Indices

# Indexer/Overview

function Get-Graylog2IndexerOverview {
	<#
	.SYNOPSIS
	Get overview of current indexing state, including deflector config, cluster state, index ranges & message counts
	.EXAMPLE
	Get-Graylog2IndexerOverview
	#>
	# TODO: return custom object
	try {
		$indexerOverview = _Rest_Api_Call -UrlPath "system/indexer/overview"
	}
	catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}
	
	return $indexerOverview | Format-List
}

function Get-Graylog2IndexerOverviewIndexSet {
	<#
	.SYNOPSIS
	Get overview of current indexing state for the given index set, including deflector config, cluster state, index ranges & message counts
	.EXAMPLE
	Get-Graylog2IndexerOverviewIndexSet -id "5b6061ad4a34162461964bc2"
	.PARAMETER id
	Id of an IndexSet
	#>
	# TODO: check if indexSetId exists
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)][string]$id
	)

	try {
		$indexerOverview = $(_Rest_Api_Call -UrlPath "system/indexer/overview/$id")
	}
	catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}
	
	return $indexerOverview
}

# END Indexer/Overview

# Messages
# END Messages

# Roles: User Roles
# END Roles

# Search/Absolute: Message search
# END Search/Absolute

# Search/Saved: Message search
# END Search/Saved

# Sources: Listing message sources (e.g. hosts sending logs)

function Get-Graylog2Sources {
	<#
	.SYNOPSIS
	Get a list of all sources (not more than 5000) that have messages in the current indices. The result is cached for 10 seconds
	.EXAMPLE
	Get-Graylog2Sources -msRange 86400
	.PARAMETER msRange
	Relative timeframe to search in. The parameter is in seconds relative to the current time. 86400 means 'in the last day', 0 is special and means 'across all indices'
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)][int]$msRange
	)

	try {
		$sourcesList = _Rest_Api_Call -UrlPath "sources?range=$msRange"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	# As retrieved sources is based on an unique object with NoteProperty member, we need to decompose it in order to get usable objects
	$reportSources = @()
	foreach ($source in $sourcesList.sources | Get-Member -MemberType NoteProperty) {
		$line = $null | Select-Object Source, Count
		$line.Source = $source.Name
		$line.Count = [int]($source.Definition.ToString().Split("=")[1].Trim())
		$reportSources += $line
	}

	return $reportSources
}

# END Sources

# STATICFIELDS
# END STATICFIELDS

# STREAMRULES
# END STREAMRULES

# STREAMS
# END STREAMS

# SYSTEM

function Get-Graylog2SystemOverview {
    <#
	.SYNOPSIS
	Display System information
	.DESCRIPTION
	Display Graylog2 Instance System information
	.EXAMPLE
	Get-Graylog2System
	#>
    _Rest_Api_Call -UrlPath system -Method get
}

function Get-Graylog2JVMInformation {
	<#
	.SYNOPSIS
	Get JVM information
	.EXAMPLE
	Get-Graylog2JVMInformation
	#>

	try {
		$jvmInformation = _Rest_Api_Call -UrlPath "system/jvm"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $jvmInformation
}

function Get-Graylog2ThreadDump {
	<#
	.SYNOPSIS
	Get a thread dump
	.EXAMPLE
	Get-Graylog2ThreadDump
	#>

	try {
		$threadDump = _Rest_Api_Call -UrlPath "system/threaddump"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $threadDump
}

# END SYSTEM

# SYSTEM/BUFFERS
# END SYSTEM/BUFFERS

# SYSTEM/CLUSTER
# END SYSTEM/CLUSTER

# SYSTEM/DEFLECTOR
# END SYSTEM/DEFLECTOR

# System/Fields: Get list of message fields that exist.
function Get-Graylog2SystemFields {
	<#
	.SYNOPSIS
	Get list of message fields that exist
	.EXAMPLE
	Get-Graylog2SystemFields -limit
	.PARAMETER limit
	Maximum number of fields to return. Set to 0 for all fields
	#>

	[CmdletBinding()]
	param (
		[int]$limit = 0
	)

	try {
		$systemFields = _Rest_Api_Call -UrlPath "system/fields?limit=$limit"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $systemFields.fields
}

# END System/Fields

# SYSTEM/INPUTS

function Get-Graylog2Inputs {
	<#
	.SYNOPSIS
	Get all inputs of this node
	.EXAMPLE
	Get-Graylog2Inputs
	#>

	try {
        $nodeInput = _Rest_Api_Call -Method get -UrlPath "system/inputs"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	if ($nodeInput.total -eq 0) {
		Write-Host -ForegroundColor Yellow "No saved search."
		Return
	}

	Return $nodeInput.inputs
}

# END SYSTEM/INPUTS

# System/MessageProcessors: Manage message processors
function Suspend-Graylog2MessageProcessing {
	<#
	.SYNOPSIS
	Pauses message processing
	.EXAMPLE
	Suspend-Graylog2MessageProcessing
	#>

	try {
		$suspendedMessageProcessing = _Rest_Api_Call -Method Put -Url "system/processing/pause"
		Write-Host "Message processing is paused"
		Write-Host -ForegroundColor Yellow "Inputs that are able to reject or requeue messages will do so, others will buffer messages in memory. Keep an eye on the heap space utilization while message processing is paused."
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $suspendedMessageProcessing
}

function Resume-Graylog2MessageProcessing {
	<#
	.SYNOPSIS
	Pauses message processing
	.EXAMPLE
	Resume-Graylog2MessageProcessing
	#>

	try {
		$resumedMessageProcessing = _Rest_Api_Call -Method Put -UrlPath "system/processing/resume"
		Write-Host -ForegroundColor Green "Message processing is resumed"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $resumedMessageProcessing
}

# END System/MessageProcessors

# SYSTEM/PERMISSIONS: Retrieval of system permissions
function Get-Graylog2Permissions {
	<#
	.SYNOPSIS
	Get all available user permissions
	.EXAMPLE
	Get-Graylog2Permissions
	#>

	try {
		$permissions = _Rest_Api_Call -UrlPath "system/permissions"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $permissions.permissions
}

function Get-Graylog2UserPermissions {
	<#
	.SYNOPSIS
	Get the initial permissions assigned to a reader account
	.EXAMPLE
	Get-Graylog2UserPermissions
	.PARAMETER username
	Username of user as it is in graylog
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$True)][string]$username
	)

	if ((Get-Graylog2Users | Where-Object { $_.username -eq $username } | Measure-Object).Count -ne 1) {
		Write-Host -ForegroundColor Red "Error on user $username, please check before running this command again"
		Return
	}

	try {
		$userPermissions = _Rest_Api_Call -UrlPath "system/permissions/reader/$username"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $userPermissions.permissions
}

# END SYSTEM/PERMISSIONS

# SYSTEM/PLUGINS: Plugin Information
function Get-Graylog2Plugins {
	<#
	.SYNOPSIS
	List all installed plugins on this node.
	.EXAMPLE
	Get-Graylog2Permissions
	#>

	try {
		$permissions = _Rest_Api_Call -UrlPath "system/plugins"
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $permissions.permissions
}


# Users: User Accounts

function Get-Graylog2Users {
	<#
	.SYNOPSIS
	List all users
	.EXAMPLE
	Get-Graylog2Users
	#>

	try {
        $users = _Rest_Api_Call -Method Get -UrlPath users
	} catch {
        Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return $users.users
}

# END Users

#################################################################
# EXPORTS
#################################################################

# Hidding helper functions by exporting only available cmdlet

# COMMON FUNCTIONS
Export-ModuleMember -Function Connect-Graylog2RestApi
Export-ModuleMember -Function Get-Graylog2StreamRuleType

# ALERTS
#Export-ModuleMember -Function Get-Graylog2StreamAlert
#Export-ModuleMember -Function Test-Graylog2StreamAlert
#Export-ModuleMember -Function New-Graylog2StreamAlertConditions
#Export-ModuleMember -Function Get-Graylog2StreamAlertConditions
#Export-ModuleMember -Function Remove-Graylog2StreamAlertConditions
#Export-ModuleMember -Function New-Graylog2StreamAlertReceivers
#Export-ModuleMember -Function Remove-Graylog2StreamAlertReceivers
#Export-ModuleMember -Function Send-Graylog2DummyStreamAlert

# COUNTS
Export-ModuleMember -Function Get-Graylog2MessageCounts

# DASHBOARDS
#Export-ModuleMember -Function Get-Graylog2Dashboards
#Export-ModuleMember -Function New-Graylog2Dashboard
#Export-ModuleMember -Function Get-Graylog2Dashboard
#Export-ModuleMember -Function Remove-Graylog2Dashboard
#Export-ModuleMember -Function Update-Graylog2Dashboard
#Export-ModuleMember -Function Update-Graylog2DashboardPositions
#Export-ModuleMember -Function Add-Graylog2DashboardWidget
#Export-ModuleMember -Function Remove-Graylog2DashboardWidget
#Export-ModuleMember -Function Update-Graylog2DashboardWidgetCachetime
#Export-ModuleMember -Function Update-Graylog2DashboardWidgetDescription
#Export-ModuleMember -Function Get-Graylog2DashboardWidget

# EXTRACTORS
Export-ModuleMember -Function Get-Graylog2Extractors
#Export-ModuleMember -Function New-Graylog2Extractor
#Export-ModuleMember -Function Remove-Graylog2Extractor

# INDEXER/CLUSTER
Export-ModuleMember -Function Get-Graylog2ClusterHealth
Export-ModuleMember -Function Get-Graylog2ClusterName

# Indexer/Failures
Export-ModuleMember -Function Get-Graylog2IndexerFailures
Export-ModuleMember -Function Get-Graylog2IndexerFailuresCount

# INDEXER/INDICES
Export-ModuleMember -Function Get-Graylog2Indices
Export-ModuleMember -Function Get-Graylog2ClosedIndices
Export-ModuleMember -Function Remove-Graylog2Index
Export-ModuleMember -Function Get-Graylog2IndexInformation
Export-ModuleMember -Function Close-Graylog2Index
Export-ModuleMember -Function Resume-Graylog2Index

# Indexer/Overview
Export-ModuleMember -Function Get-Graylog2IndexerOverview
Export-ModuleMember -Function Get-Graylog2IndexerOverviewIndexSet

# MESSAGES
#Export-ModuleMember -Function Get-Graylog2MessageAnalyze
#Export-ModuleMember -Function Get-Graylog2Message

# SEARCH/ABSOLUTE

# SEARCH/SAVED
#Export-ModuleMember -Function Get-Graylog2SavedSearches
#Export-ModuleMember -Function New-Graylog2SavedSearch
#Export-ModuleMember -Function Get-Graylog2SavedSearch
#Export-ModuleMember -Function Remove-Graylog2SavedSearch

# SOURCES
Export-ModuleMember -Function Get-Graylog2Sources

# STATICFIELDS
#Export-ModuleMember -Function New-Graylog2InputStaticfields
#Export-ModuleMember -Function Remove-Graylog2InputStaticfields

# STREAMRULES
#Export-ModuleMember -Function Get-Graylog2StreamRules
#Export-ModuleMember -Function New-Graylog2StreamRule
#Export-ModuleMember -Function Get-Graylog2StreamRule
#Export-ModuleMember -Function Remove-Graylog2StreamRule
#Export-ModuleMember -Function Update-Graylog2StreamRule

# STREAMS
#Export-ModuleMember -Function Get-Graylog2Streams
#Export-ModuleMember -Function New-Graylog2Stream
#Export-ModuleMember -Function Get-Graylog2EnabledStream
#Export-ModuleMember -Function Get-Graylog2Stream
#Export-ModuleMember -Function Remove-Graylog2Stream
#Export-ModuleMember -Function Update-Graylog2Stream
#Export-ModuleMember -Function Copy-Graylog2Stream
#Export-ModuleMember -Function Suspend-Graylog2Stream
#Export-ModuleMember -Function Resume-Graylog2Stream
#Export-ModuleMember -Function Test-Graylog2Stream
#Export-ModuleMember -Function Get-Graylog2StreamThroughput

# System
Export-ModuleMember -Function Get-Graylog2SystemOverview
Export-ModuleMember -Function Get-Graylog2JVMInformation
Export-ModuleMember -Function Get-Graylog2ThreadDump

# System/Buffers
#Export-ModuleMember -Function Get-Graylog2BufferInformation

# System/Cluster
#Export-ModuleMember -Function Get-Graylog2Node
#Export-ModuleMember -Function Get-Graylog2Nodes
#Export-ModuleMember -Function Get-Graylog2NodeInformation

# System/Deflector
#Export-ModuleMember -Function Get-Graylog2DeflectorStatus
#Export-ModuleMember -Function Get-Graylog2DeflectorConfiguration
#Export-ModuleMember -Function New-Graylog2CycleDeflector

# System/Fields
Export-ModuleMember -Function Get-Graylog2SystemFields

# System/Inputs
Export-ModuleMember -Function Get-Graylog2Inputs
#Export-ModuleMember -Function New-Graylog2Input
#Export-ModuleMember -Function Get-Graylog2InputTypes
#Export-ModuleMember -Function Get-Graylog2InputType
#Export-ModuleMember -Function Remove-Graylog2Input
#Export-ModuleMember -Function Get-Graylog2InputInformation
#Export-ModuleMember -Function Start-Graylog2Input

# System/MessageProcessors
Export-ModuleMember -Function Suspend-Graylog2MessageProcessing
Export-ModuleMember -Function Resume-Graylog2MessageProcessing

# System/Permissions
Export-ModuleMember -Function Get-Graylog2Permissions
Export-ModuleMember -Function Get-Graylog2UserPermissions

# System/Plugins
Export-ModuleMember -Function Get-Graylog2Plugins

# Users
Export-ModuleMember -Function Get-Graylog2Users