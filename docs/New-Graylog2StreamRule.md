---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# New-Graylog2StreamRule

## SYNOPSIS
Create a stream rule

## SYNTAX

```
New-Graylog2StreamRule [-streamId] <String> [-field] <String> [-value] <String> [-type] <String> [-inverted]
 [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
New-Graylog2StreamRule -streamId "53319288498e9ee49c6ffd57" -field "full_message" -value "Could not open device" -type "match regular expression" -inverted
```

### EXAMPLE 2
```
New-Graylog2StreamRule -streamId "53319288498e9ee49c6ffd57" -field "full_message" -value "Could not open device" -type "match exactly"
```

### EXAMPLE 3
```
New-Graylog2StreamRule -streamId "53319288498e9ee49c6ffd57" -field "level" -value "6" -type "greater than"
```

## PARAMETERS

### -streamId
Id of the stream

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

### -field
Field to based rule on

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

### -value
Value that will be used for rule

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -type
Type of rule, must be one of "match exactly", "match regular expression", "greater than" or "smaller than"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -inverted
Switch that will invert the rule

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
