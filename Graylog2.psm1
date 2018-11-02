#Requires -Version 3
# ------------------------------------------------------------------------
# NAME: Graylog2.psm1
# AUTHOR: Stefan jarina (stefan@jarina.cz)
# DATE: 2018.11.01
#
# COMMENTS: Powershell module for managing Graylog2
# ------------------------------------------------------------------------


# HELPER FUNCTIONS: Private functions - not exported to user

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
        $Method,
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

# END HELPER FUNCTIONS

# CONNECTION FUNCTIONS

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

# END CONNECTION FUNCTIONS

# COMMON FUNCTIONS

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

# END COMMON FUNCTIONS

# STREAM/ALERTS
# END STREAM/ALERTS

# COUNTS

function Get-Graylog2MessageCounts {
	<#
	.SYNOPSIS
	Retrieve total message count handled by Graylog2
	.EXAMPLE
	Get-Graylog2MessageCounts
	#>

	try {
		$messageCount = _Rest_Api_Call -UrlPath "count/total" -Method get
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	Return [long]($messageCount.events)
}

# END COUNTS

# DASHBOARDS
# END DASHBOARDS

# EXTRACTORS

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
	
	if ((Get-Graylog2Inputs | ?{$_.Id -eq $inputId} | Measure-Object).Count -ne 1) {
		Write-Host -ForegroundColor Red "Error on input with inputId $inputId, please check before running this command again"
		Return
	}

	try {
		$extractors = Invoke-RestMethod -Method Get -Uri "http://$($restInstance):$restPort/system/inputs/$inputId/extractors" -Headers (_Get_HttpBasicHeader_)
	} catch {
		Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
		Return
	}

	return $extractors.extractors
}

# END EXTRACTORS

# INDEXER/CLUSTER
# END INDEXER/CLUSTER

# INDEXER/INDICES
# END INDEXER/INDICES

# MESSAGES
# END MESSAGES

# SEARCH/ABSOLUTE
# END SEARCH/ABSOLUTE

# SEARCH/SAVED
# END SEARCH/SAVED

# SOURCES
# END SOURCES

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

# END SYSTEM

# SYSTEM/BUFFERS
# END SYSTEM/BUFFERS

# SYSTEM/CLUSTER
# END SYSTEM/CLUSTER

# SYSTEM/DEFLECTOR
# END SYSTEM/DEFLECTOR

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

# USERS FUNCTIONS

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

# END USERS


# Hidding helper functions by exporting only available cmdlet

# COMMON FUNCTIONS
Export-ModuleMember -Function Connect-Graylog2RestApi
Export-ModuleMember -Function Get-Graylog2StreamRuleType

# SYSTEM
Export-ModuleMember -Function Get-Graylog2System

# ALERTS
Export-ModuleMember -Function Get-Graylog2StreamAlert
Export-ModuleMember -Function Test-Graylog2StreamAlert
Export-ModuleMember -Function New-Graylog2StreamAlertConditions
Export-ModuleMember -Function Get-Graylog2StreamAlertConditions
Export-ModuleMember -Function Remove-Graylog2StreamAlertConditions
Export-ModuleMember -Function New-Graylog2StreamAlertReceivers
Export-ModuleMember -Function Remove-Graylog2StreamAlertReceivers
Export-ModuleMember -Function Send-Graylog2DummyStreamAlert

# COUNTS
Export-ModuleMember -Function Get-Graylog2MessageCounts

# DASHBOARDS
Export-ModuleMember -Function Get-Graylog2Dashboards
Export-ModuleMember -Function New-Graylog2Dashboard
Export-ModuleMember -Function Get-Graylog2Dashboard
Export-ModuleMember -Function Remove-Graylog2Dashboard
Export-ModuleMember -Function Update-Graylog2Dashboard
Export-ModuleMember -Function Update-Graylog2DashboardPositions
Export-ModuleMember -Function Add-Graylog2DashboardWidget
Export-ModuleMember -Function Remove-Graylog2DashboardWidget
Export-ModuleMember -Function Update-Graylog2DashboardWidgetCachetime
Export-ModuleMember -Function Update-Graylog2DashboardWidgetDescription
Export-ModuleMember -Function Get-Graylog2DashboardWidget

# EXTRACTORS
Export-ModuleMember -Function Get-Graylog2Extractors
Export-ModuleMember -Function New-Graylog2Extractor
Export-ModuleMember -Function Remove-Graylog2Extractor

# INDEXER/CLUSTER
Export-ModuleMember -Function Get-Graylog2ClusterHealth
Export-ModuleMember -Function Get-Graylog2ClusterName

# INDEXER/INDICES
Export-ModuleMember -Function Get-Graylog2ClosedIndices
Export-ModuleMember -Function Remove-Graylog2Index
Export-ModuleMember -Function Get-Graylog2IndexInformation
Export-ModuleMember -Function Close-Graylog2Index
Export-ModuleMember -Function Resume-Graylog2Index

# MESSAGES
Export-ModuleMember -Function Get-Graylog2MessageAnalyze
Export-ModuleMember -Function Get-Graylog2Message

# SEARCH/ABSOLUTE

# SEARCH/SAVED
Export-ModuleMember -Function Get-Graylog2SavedSearches
Export-ModuleMember -Function New-Graylog2SavedSearch
Export-ModuleMember -Function Get-Graylog2SavedSearch
Export-ModuleMember -Function Remove-Graylog2SavedSearch

# SOURCES
Export-ModuleMember -Function Get-Graylog2Sources

# STATICFIELDS
Export-ModuleMember -Function New-Graylog2InputStaticfields
Export-ModuleMember -Function Remove-Graylog2InputStaticfields

# STREAMRULES
Export-ModuleMember -Function Get-Graylog2StreamRules
Export-ModuleMember -Function New-Graylog2StreamRule
Export-ModuleMember -Function Get-Graylog2StreamRule
Export-ModuleMember -Function Remove-Graylog2StreamRule
Export-ModuleMember -Function Update-Graylog2StreamRule

# STREAMS
Export-ModuleMember -Function Get-Graylog2Streams
Export-ModuleMember -Function New-Graylog2Stream
Export-ModuleMember -Function Get-Graylog2EnabledStream
Export-ModuleMember -Function Get-Graylog2Stream
Export-ModuleMember -Function Remove-Graylog2Stream
Export-ModuleMember -Function Update-Graylog2Stream
Export-ModuleMember -Function Copy-Graylog2Stream
Export-ModuleMember -Function Suspend-Graylog2Stream
Export-ModuleMember -Function Resume-Graylog2Stream
Export-ModuleMember -Function Test-Graylog2Stream
Export-ModuleMember -Function Get-Graylog2StreamThroughput

# SYSTEM
Export-ModuleMember -Function Get-Graylog2SystemOverview
Export-ModuleMember -Function Get-Graylog2SystemFields
Export-ModuleMember -Function Get-Graylog2JVMInformation
Export-ModuleMember -Function Get-Graylog2Permissions
Export-ModuleMember -Function Get-Graylog2UserPermissions
Export-ModuleMember -Function Suspend-Graylog2MessageProcessing
Export-ModuleMember -Function Resume-Graylog2MessageProcessing
Export-ModuleMember -Function Get-Graylog2ThreadDump

# SYSTEM/BUFFERS
Export-ModuleMember -Function Get-Graylog2BufferInformation

# SYSTEM/CLUSTER
Export-ModuleMember -Function Get-Graylog2Node
Export-ModuleMember -Function Get-Graylog2Nodes
Export-ModuleMember -Function Get-Graylog2NodeInformation

# SYSTEM/DEFLECTOR
Export-ModuleMember -Function Get-Graylog2DeflectorStatus
Export-ModuleMember -Function Get-Graylog2DeflectorConfiguration
Export-ModuleMember -Function New-Graylog2CycleDeflector