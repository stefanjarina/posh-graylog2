---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# Connect-Graylog2RestApi

## SYNOPSIS
Connect to Graylog2 REST API

## SYNTAX

```
Connect-Graylog2RestApi [-Address] <String> [[-Port] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Connect to Graylog2 server through REST API and prompt for credentials.
This function will request token and store it in users registry.

## EXAMPLES

### EXAMPLE 1
```
Connect-Graylog2Rest -Address 69.69.69.69
```

### EXAMPLE 2
```
Connect-Graylog2Rest -Address 69.69.69.69 -Port 8080
```

## PARAMETERS

### -Address
IP address of Graylog2 REST API instance

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Used to specified custom (aka non-12900) REST API port

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 9000
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
