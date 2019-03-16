---
external help file: PSRES-help.xml
Module Name: PSRES
online version:
schema: 2.0.0
---

# Get-RESApps

## SYNOPSIS
Shows Applications and properties from RES Workspace Manager / Powerfuse

## SYNTAX

```
Get-RESApps [[-Title] <String>] [[-Group] <String>] [[-AppID] <Object>] [[-MenuPath] <String>]
 [[-Startstyle] <String>] [-WebApp] [-AppV] [-Disabled] [-HideFromMenu] [<CommonParameters>]
```

## DESCRIPTION
Shows Applications and properties from RES Workspace Manager / Powerfuse

## EXAMPLES

### EXAMPLE 1
```
Get-RESApps -Title "explorer"
```

Description
-----------
Shows all applications with "explorer" in the title

### EXAMPLE 2
```
Get-RESApps -Disabled -Application "expl*"
```

Description
-----------
Shows all disabled applications with "expl*" in the title

### EXAMPLE 3
```
Get-RESApps -AppID 38
```

Description
-----------
Shows the application with AppID 38

### EXAMPLE 4
```
Get-RESApps -HideFromMenu | Out-Gridview
```

Description
-----------
Shows all the applications which are hidden from the menu

### EXAMPLE 5
```
Get-RESApps -WebApp | select title, parameters
```

Description
-----------
Shows all the Web applications

### EXAMPLE 6
```
Get-RESApps -AppV | select title, menupath
```

Description
-----------
Shows all the AppV/Softgrid applications

## PARAMETERS

### -Title
The title (name) - pattern of the Application

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name, App, Application

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
The Group / User - pattern which has access to the Application

```yaml
Type: String
Parameter Sets: (All)
Aliases: User

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppID
The AppID - pattern of the Application

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -MenuPath
The MenuPath / menu - pattern to the Application

```yaml
Type: String
Parameter Sets: (All)
Aliases: Menu

Required: False
Position: 4
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Startstyle
Startstyle of the Application

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

### -WebApp
Application disabled

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: http

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppV
Application disabled

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Softgrid

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disabled
Application disabled

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

### -HideFromMenu
Application hidden from the menu

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Hidden

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
