# Configurar.ps1 (v2 - con soporte para plantillas)
# Guía al usuario para establecer rutas, plantillas de nombrado y una plantilla de nota de Obsidian.

# --- FUNCIONES DE DIÁLOGO ---
# Función para seleccionar carpetas
function Get-FolderPath {
    param([string]$Description, [string]$InitialDirectory = [System.Environment]::GetFolderPath('MyDocuments'))
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        Description = $Description
        ShowNewFolderButton = $true
        SelectedPath = $InitialDirectory
    }
    if ($dialog.ShowDialog() -eq 'OK') { return $dialog.SelectedPath } else { return $null }
}

# Función para seleccionar archivos
function Get-FilePath {
    param([string]$Description, [string]$InitialDirectory, [string]$Filter = "Archivos Markdown (*.md)|*.md|Todos los archivos (*.*)|*.*")
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
        Title = $Description
        InitialDirectory = $InitialDirectory
        Filter = $Filter
    }
    if ($dialog.ShowDialog() -eq 'OK') { return $dialog.FileName } else { return $null }
}

# Función para obtener texto del usuario
function Get-UserInput {
    param([string]$Prompt, [string]$Title, [string]$DefaultText)
    Add-Type -AssemblyName Microsoft.VisualBasic
    return [Microsoft.VisualBasic.Interaction]::InputBox($Prompt, $Title, $DefaultText)
}

# --- INICIO DE LA CONFIGURACIÓN ---
Write-Host "Iniciando configuración avanzada de la herramienta de captura para Obsidian..." -ForegroundColor Cyan

$configPath = Join-Path $PSScriptRoot "config.json"

# 1. Configuración de Rutas
$vaultRoot = Get-FolderPath -Description "1/4: Selecciona la carpeta raíz de tu Vault de Obsidian"
if (-not $vaultRoot) { Write-Warning "Configuración cancelada."; return }

$assetsFolder = Get-FolderPath -Description "2/4: Selecciona la carpeta para guardar imágenes (Assets)" -InitialDirectory $vaultRoot
if (-not $assetsFolder) { Write-Warning "Configuración cancelada."; return }

$notesFolder = Get-FolderPath -Description "3/4: Selecciona la carpeta para guardar notas de captura" -InitialDirectory $vaultRoot
if (-not $notesFolder) { Write-Warning "Configuración cancelada."; return }

# 2. Configuración de Plantilla de Nota (Opcional)
$useTemplate = [System.Windows.Forms.MessageBox]::Show("¿Quieres usar una plantilla de nota existente de Obsidian?`n`nSi dices 'No', se usará una plantilla por defecto.", "Configurar Plantilla de Nota", "YesNo", "Question")
$obsidianTemplatePath = ""
if ($useTemplate -eq 'Yes') {
    $obsidianTemplatePath = Get-FilePath -Description "Selecciona tu archivo de plantilla para capturas (.md)" -InitialDirectory $vaultRoot
    if (-not $obsidianTemplatePath) {
        Write-Warning "No se seleccionó plantilla. Se usará la plantilla por defecto."
    }
}

# 3. Configuración de Nombres y Timestamp
Write-Host "`nAhora, vamos a configurar los nombres de archivo. Puedes usar '{{timestamp}}' como marcador de posición." -ForegroundColor Cyan

$timestampFormat = Get-UserInput -Prompt "Introduce el formato para la marca de tiempo (timestamp):`n(Ej: yyyy-MM-dd HH.mm.ss)" -Title "4/4: Formato de Timestamp" -DefaultText "yyyyMMddHHmmss"
$noteNameTemplate = Get-UserInput -Prompt "Introduce la plantilla para el nombre de la nota:`nUsa {{timestamp}} para la fecha/hora." -Title "4/4: Plantilla de Nombre de Nota" -DefaultText "capture-{{timestamp}}.md"
$imageNameTemplate = Get-UserInput -Prompt "Introduce la plantilla para el nombre de la imagen:`nUsa {{timestamp}} para la fecha/hora." -Title "4/4: Plantilla de Nombre de Imagen" -DefaultText "img-QuickCap-{{timestamp}}.png"

# Crear y guardar el objeto de configuración
$config = [PSCustomObject]@{
    vaultRoot            = $vaultRoot
    assetsFolder         = $assetsFolder
    notesFolder          = $notesFolder
    editorPath           = "notepad.exe"
    obsidianTemplatePath = $obsidianTemplatePath
    timestampFormat      = $timestampFormat
    noteNameTemplate     = $noteNameTemplate
    imageNameTemplate    = $imageNameTemplate
}

$config | ConvertTo-Json -Depth 3 | Out-File -FilePath $configPath -Encoding UTF8

Write-Host "`n✅ ¡Configuración avanzada guardada exitosamente en '$configPath'!" -ForegroundColor Green