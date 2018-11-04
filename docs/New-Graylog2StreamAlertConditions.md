---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# New-Graylog2StreamAlertConditions

## SYNOPSIS
Create a alert condition

## SYNTAX

```
New-Graylog2StreamAlertConditions [-streamId] <String> [-conditionType] <String> [[-thresholdType] <String>]
 [[-field] <String>] [[-conditionParameterType] <String>] [[-grace] <Int32>] [[-threshold] <Int32>]
 [[-backlog] <Int32>] [[-time] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
New-Graylog2StreamAlertConditions -streamId "5357b946e4b02d59485c8ee2" -conditionType "message_count" -grace 5 -time 5 -threshold 10 -thresholdType "more" -backlog 10
```

### EXAMPLE 2
```
New-Graylog2StreamAlertConditions -streamId "5357b946e4b02d59485c8ee2" -conditionType "field_value" -grace 5 -time 5 -field "user_id" -threshold 10 -thresholdType "higher" -conditionParameterType "max"
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

### -conditionType
Definie type of alert condition.
Must be one of "message_count", "field_value"

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

### -thresholdType
Type of alert threshold.
Must be one of "more" or "less" if conditionType = "message_count" or one of "lower" or "higher" if conditionType = "field_value"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -field
Field to based alert on

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -conditionParameterType
Condition parameter type.
Must be one of "mean", "min", "max", "sum" or "stddev"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -grace
Period until triggering a new alert

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -threshold
Threshold for the alert

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -backlog
When sending an alert, include the last XX messages of the stream evaluated for this alert condition

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -time
Time for the alert

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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
