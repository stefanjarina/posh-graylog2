---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# Get-Graylog2IndexerFailuresCount

## SYNOPSIS
Get total count of failed index operations since the given date

## SYNTAX

```
Get-Graylog2IndexerFailuresCount [-since] <String> [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
Get-Graylog2IndexerFailures -limit 100 -offset 10
```

## PARAMETERS

### -since
Specify date in "ISO8601".
Failures will be retrieved from this date

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
