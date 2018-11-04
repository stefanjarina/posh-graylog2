---
external help file: Graylog2-help.xml
Module Name: Graylog2
online version:
schema: 2.0.0
---

# New-Graylog2SavedSearch

## SYNOPSIS
Create a new saved search

## SYNTAX

```
New-Graylog2SavedSearch [-title] <String> [-queryTitle] <String> [-rangeType] <String> [-query] <String>
 [[-relative] <String>] [[-from] <DateTime>] [[-to] <DateTime>] [[-keyword] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### EXAMPLE 1
```
New-Graylog2SavedSearch -title "Saved Search 1" -queryTitle "Long VMFS3 rsv time" -rangeType "relative" -query "Long VMFS3 rsv" -relative 28800
```

### EXAMPLE 2
```
New-Graylog2SavedSearch -title "Saved Search 2" -queryTitle "Long VMFS3 rsv time" -rangeType "absolute" -query "Long VMFS3 rsv" -from ((Get-Date).AddDays(-3)) -to (Get-Date)
```

### EXAMPLE 3
```
New-Graylog2SavedSearch -title "Saved Search 3" -queryTitle "Long VMFS3 rsv time" -rangeType "keyword" -query "Long VMFS3 rsv" -keyword "last day"
```

## PARAMETERS

### -title
Title of the saved search

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

### -queryTitle
Title of the query

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

### -rangeType
Type of the range search, must be one of 'relative','absolute' or 'keyword'

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

### -query
Query that will be executed for this search

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

### -relative
Set the number is seconds to use for relative search

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

### -from
Start of the time range, must be DateTime type

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -to
End of the time range, must be DateTime type

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -keyword
Keyword sentence to be used for saved search

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
