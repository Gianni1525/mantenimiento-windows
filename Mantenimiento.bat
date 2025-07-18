@echo off
title Mantenimiento de Windows - Gianni Monroy
color 0A

:MENU
cls
echo ============================================
echo         MANTENIMIENTO DE WINDOWS
echo ============================================
echo.
echo    Editor: Gianni Monroy
echo    Version: 2.1
echo.
echo 1. Revision del sistema
echo 2. Limpieza basica
echo 3. Limpieza completa
echo 4. Analisis completo
echo 5. Salir
echo.
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto REVISION
if "%opcion%"=="2" goto LIMPIEZA_BASICA
if "%opcion%"=="3" goto LIMPIEZA_COMPLETA
if "%opcion%"=="4" goto ANALISIS_COMPLETO
if "%opcion%"=="5" goto SALIR
if "%opcion%"=="6" goto ACTUALIZAR
goto MENU

:REVISION
cls
echo [1/4] Revision del sistema: comprobando integridad...
sfc /scannow

echo Revisando imagen de Windows...
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /RestoreHealth
pause
goto MENU

:LIMPIEZA_BASICA
cls
echo [2/4] Limpieza basica: optimizando discos y checando errores...
defrag C: /O
defrag D: /O

chkdsk C: /scan
chkdsk D: /scan
pause
goto MENU

:LIMPIEZA_COMPLETA
cls
echo [3/4] Limpieza completa: temporales, red, firewall y bloatware...

echo Restableciendo DNS y red...
ipconfig /flushdns
netsh int ip reset
netsh winsock reset
netsh advfirewall reset

echo Ejecutando Liberador de espacio...
cleanmgr /sagerun:1

echo Borrando temporales...
del /s /q %temp%\*.* 2>nul
del /s /q C:\Windows\Temp\*.* 2>nul

echo Creando punto de restauracion...
reagentc /info
reagentc /enable
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Mantenimiento Completo", 100, 7

echo Verificando procesos y arranque...
tasklist | findstr /I /C:"malware" /C:"virus"
wmic startup get caption,command

echo Comprobando estado fisico del disco...
wmic diskdrive get status
pause
goto MENU

:ANALISIS_COMPLETO
cls
echo [4/4] Analisis completo: ejecutando TODO el mantenimiento...
sfc /scannow
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /RestoreHealth

defrag C: /O
defrag D: /O

chkdsk C: /scan
chkdsk D: /scan

ipconfig /flushdns
netsh int ip reset
netsh winsock reset
netsh advfirewall reset

cleanmgr /sagerun:1

del /s /q %temp%\*.* 2>nul
del /s /q C:\Windows\Temp\*.* 2>nul

reagentc /info
reagentc /enable
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Mantenimiento Total", 100, 7

tasklist | findstr /I /C:"malware" /C:"virus"
wmic startup get caption,command
wmic diskdrive get status

echo Mantenimiento completo finalizado.
pause
goto MENU



:SALIR
echo Saliendo del programa...
timeout /t 2 >nul
exit