---
external help file: PSRES-help.xml
Module Name: PSRES
online version:
schema: 2.0.0
---

# Get-RESGlobalAuthorisedConnections

## SYNOPSIS
Shows authorised connections from RES Workspace Manager / Powerfuse

## SYNTAX

```
Get-RESGlobalAuthorisedConnections [[-Process] <String>] [-Disabled] [<CommonParameters>]
```

## DESCRIPTION
Shows authorised connections from RES Workspace Manager / Powerfuse

## EXAMPLES

### EXAMPLE 1
```
Get-RESGlobalAuthorised -process "*iexplorer*"
```

Shows authorised connections opened by the process iexplorer

## PARAMETERS

### -Process
The Process

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disabled
Authorisation disabled

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
