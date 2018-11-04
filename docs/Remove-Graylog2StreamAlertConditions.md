---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# Remove-Graylog2StreamAlertConditions

## SYNOPSIS
Delete an alert condition

## SYNTAX

```
Remove-Graylog2StreamAlertConditions [-streamId] <String> [-conditionId] <String> [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
Remove-Graylog2StreamAlertConditions -streamId "5357b946e4b02d59485c8ee2" -conditionId "a302c06d-8302-4d8c-8c5d-39d574355173"
```

## PARAMETERS

### -streamId
The stream id this new alert condition belongs to

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

### -conditionId
The condition id to be removed

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
