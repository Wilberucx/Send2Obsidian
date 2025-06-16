@echo off
:: Configurar (Ejecutar como Admin).bat
:: Este script solicita privilegios de administrador para ejecutar el
:: script de configuración de PowerShell, asegurando que se puedan
:: cambiar las políticas de ejecución si es necesario.

:: --- COMPROBACIÓN DE PRIVILEGIOS DE ADMINISTRADOR ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: Si el comando anterior falla, el errorlevel no será 0.
if '%errorlevel%' NEQ '0' (
    echo Solicitando privilegios de administrador...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    :: --- EJECUCIÓN DEL SCRIPT DE POWERSHELL ---
    :: Si hemos llegado aquí, tenemos privilegios de administrador.
    
    rem Cambia el directorio actual a la carpeta donde está este script.
    pushd "%~dp0"
    
    rem Define la ruta al script de configuración de PowerShell.
    set "PowerShellScript=%~dp0Configurar.ps1"
    
    echo.
    echo Privilegios de administrador obtenidos.
    echo Iniciando el asistente de configuracion de PowerShell...
    echo.

    rem Ejecuta el script de configuración. Se mostrará la ventana de PowerShell.
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PowerShellScript%"
    
    rem Vuelve al directorio original.
    popd
    
    echo.
    echo El asistente de configuracion ha finalizado.
    pause
    exit /B