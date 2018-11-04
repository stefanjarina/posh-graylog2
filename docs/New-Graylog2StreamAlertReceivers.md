---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# New-Graylog2StreamAlertReceivers

## SYNOPSIS
Add an alert receiver

## SYNTAX

```
New-Graylog2StreamAlertReceivers [-streamId] <String> [-entity] <String> [-type] <String> [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
New-Graylog2StreamAlertReceivers -streamId "5357b946e4b02d59485c8ee2" -entity "admin" -type "users"
```

### EXAMPLE 2
```
New-Graylog2StreamAlertReceivers -streamId "5357b946e4b02d59485c8ee2" -entity "graylog2@vmdude.fr" -type "emails"
```

## PARAMETERS

### -streamId
The stream id this new alert receiver belongs to

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

### -entity
Name/ID of user or email address to add as alert receiver

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

### -type
Type of receiver.
Must be one of "users" or "emails"

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
