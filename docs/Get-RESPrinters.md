---
external help file: PSRES-help.xml
Module Name: PSRES
online version:
schema: 2.0.0
---

# Get-RESPrinters

## SYNOPSIS
Shows printers and properties from RES Workspace Manager / Powerfuse

## SYNTAX

```
Get-RESPrinters [[-Printer] <String>] [[-Location] <String>] [-Disabled] [<CommonParameters>]
```

## DESCRIPTION
Shows printers and properties from RES Workspace Manager / Powerfuse

## EXAMPLES

### EXAMPLE 1
```
Get-RESPrinters -Location "*duiven*" -disabled | select printer, location
```

## PARAMETERS

### -Printer
The Printer (name) - pattern of the Printer

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
The Location - pattern of the Location

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
Printer disabled

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
