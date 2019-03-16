---
external help file: PSRES-help.xml
Module Name: PSRES
online version:
schema: 2.0.0
---

# Get-RESMappings

## SYNOPSIS
Shows mappings and properties from RES Workspace Manager / Powerfuse

## SYNTAX

```
Get-RESMappings [[-Device] <String>] [[-Description] <String>] [-Disabled] [<CommonParameters>]
```

## DESCRIPTION
Shows mappings and properties from RES Workspace Manager / Powerfuse

## EXAMPLES

### EXAMPLE 1
```
Get-RESMappings -Device "H:"
```

Shows mapping and properties with device H:

## PARAMETERS

### -Device
The device (Driveletter)

```yaml
Type: String
Parameter Sets: (All)
Aliases: Driveletter

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disabled
disabled

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
