# Send2Obsidian.ps1 (v2 - con soporte para plantillas)
# Lee una configuración avanzada desde 'config.json' para crear notas de forma dinámica.

# --- CARGAR CONFIGURACIÓN ---
$configPath = Join-Path $PSScriptRoot "config.json"
if (-not (Test-Path $configPath)) {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show("El archivo 'config.json' no se encuentra.`n`nPor favor, ejecuta primero el script 'Configurar.ps1'.", "Error de Configuración", "OK", "Error")
    exit
}
$config = Get-Content -Path $configPath | ConvertFrom-Json

# --- ASIGNAR VALORES DE CONFIGURACIÓN CON FALLBACKS ---
$assetsFolder = $config.assetsFolder
$notesFolder = $config.notesFolder
$editor = $config.editorPath
$obsidianTemplatePath = $config.obsidianTemplatePath
$timestampFormat = if ($config.timestampFormat) { $config.timestampFormat } else { "yyyyMMddHHmmss" }
$noteNameTemplate = if ($config.noteNameTemplate) { $config.noteNameTemplate } else { "capture-{{timestamp}}.md" }
$imageNameTemplate = if ($config.imageNameTemplate) { $config.imageNameTemplate } else { "img-QuickCap-{{timestamp}}.png" }

# --- GENERACIÓN DINÁMICA DE NOMBRES ---
$timestamp = Get-Date -Format $timestampFormat
$noteName = $noteNameTemplate.Replace("{{timestamp}}", $timestamp)
$imgName = $imageNameTemplate.Replace("{{timestamp}}", $timestamp)
$notePath = Join-Path $notesFolder $noteName

# --- OBTENCIÓN DE IMAGEN DEL PORTAPAPELES ---
Add-Type -AssemblyName System.Windows.Forms
$clipboardImage = [System.Windows.Forms.Clipboard]::GetImage()

# --- PROCESAMIENTO DE CONTENIDO DE NOTA (BASADO EN PLANTILLA) ---
$finalNoteContent = ""
$imageWikilink = ""

# Procesa la imagen primero, si existe
if ($clipboardImage -ne $null) {
    $imgPath = Join-Path $assetsFolder $imgName
    # Asegúrate de que la carpeta de assets exista
    if (-not (Test-Path (Split-Path $imgPath))) { New-Item -Path (Split-Path $imgPath) -ItemType Directory -Force | Out-Null }
    $clipboardImage.Save($imgPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $imageWikilink = "![[$imgName]]"
}

# Lógica principal de plantillas
if ($obsidianTemplatePath -and (Test-Path $obsidianTemplatePath)) {
    # Opción 1: El usuario configuró una plantilla válida
    $finalNoteContent = Get-Content -Path $obsidianTemplatePath -Raw
    
    # Reemplazar placeholders comunes en la plantilla
    $finalNoteContent = $finalNoteContent.Replace("{{timestamp}}", $timestamp)
    $finalNoteContent = $finalNoteContent.Replace("{{date}}", (Get-Date -Format "yyyy-MM-dd"))
    $finalNoteContent = $finalNoteContent.Replace("{{time}}", (Get-Date -Format "HH:mm"))
    
    # Placeholder especial para la imagen. Si hay una imagen, lo reemplaza. Si no, lo elimina.
    $finalNoteContent = $finalNoteContent.Replace("{{image_link}}", $imageWikilink)
    
} else {
    # Opción 2: Fallback - no hay plantilla o la ruta es inválida
    $frontmatter = @"
---
aliases: ["nota rapida-$timestamp"]
tags: [captura-rapida]
---
"@
    $finalNoteContent = $frontmatter
    if ($imageWikilink) {
        $finalNoteContent += "`n$imageWikilink`n"
    } else {
        $finalNoteContent += "`n## Comentario:`n"
    }
}

# --- GUARDAR NOTA Y ABRIRLA ---
# Asegúrate de que la carpeta de notas exista
if (-not (Test-Path (Split-Path $notePath))) { New-Item -Path (Split-Path $notePath) -ItemType Directory -Force | Out-Null }
$finalNoteContent | Out-File -FilePath $notePath -Encoding UTF8
Start-Process $editor $notePath -Wait

Write-Host "✅ Nota creada: $notePath"