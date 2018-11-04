---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# Resume-Graylog2Index

## SYNOPSIS
Reopen a closed index

## SYNTAX

```
Resume-Graylog2Index [-index] <String> [<CommonParameters>]
```

## DESCRIPTION
This will also trigger an index ranges rebuild job

## EXAMPLES

### EXAMPLE 1
```
Resume-Graylog2Index -index "graylog2_23"
```

## PARAMETERS

### -index
Name of the index to reopen

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
