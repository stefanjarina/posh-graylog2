---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# Get-Graylog2Sources

## SYNOPSIS
Get a list of all sources (not more than 5000) that have messages in the current indices.
The result is cached for 10 seconds

## SYNTAX

```
Get-Graylog2Sources [-msRange] <Int32> [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
Get-Graylog2Sources -msRange 86400
```

## PARAMETERS

### -msRange
Relative timeframe to search in.
The parameter is in seconds relative to the current time.
86400 means 'in the last day', 0 is special and means 'across all indices'

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
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
