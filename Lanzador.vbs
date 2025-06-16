' Lanzador.vbs
' Este script ejecuta otro script de PowerShell de forma completamente invisible.

' Obtiene la ruta de la carpeta donde se encuentra este script VBS.
Set objFSO = CreateObject("Scripting.FileSystemObject")
strPath = objFSO.GetParentFolderName(WScript.ScriptFullName)

' Construye la ruta completa al script de PowerShell que queremos ejecutar.
strScriptPS = objFSO.BuildPath(strPath, "Send2Obsidian.ps1")

' Prepara el comando completo para ejecutar PowerShell.
' Usamos comillas para manejar rutas con espacios.
strCommand = "powershell.e" & "xe -NoProfile -ExecutionPolicy Bypass -File """ & strScriptPS & """"

' Crea un objeto Shell para ejecutar el comando.
Set objShell = CreateObject("WScript.Shell")

' Ejecuta el comando.
' El '0' significa "ocultar la ventana".
' El 'False' significa "no esperar a que el script termine antes de continuar".
objShell.Run strCommand, 0, False