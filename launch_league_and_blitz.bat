@echo off
setlocal EnableDelayedExpansion
echo Launching Blitz and League of Legends...

:: Define common installation paths
set "BLITZ_PATH=%LOCALAPPDATA%\Programs\Blitz\Blitz.exe"
set "RIOT_PATH_1=C:\Riot Games\Riot Client\RiotClientServices.exe"
set "RIOT_PATH_2=D:\Games\Riot Games\Riot Client\RiotClientServices.exe"
set "RIOT_PATH_3=C:\Program Files\Riot Games\Riot Client\RiotClientServices.exe"
set "RIOT_PATH_4=C:\Program Files (x86)\Riot Games\Riot Client\RiotClientServices.exe"

:: Check if Blitz exists at the default location
if not exist "%BLITZ_PATH%" (
    echo Blitz not found at default location. Please enter the path to Blitz.exe:
    set /p BLITZ_PATH=
    if not exist "!BLITZ_PATH!" (
        echo Error: Invalid path for Blitz.exe
        goto :EOF
    )
)

:: Check common Riot Client locations
set "RIOT_PATH="
if exist "%RIOT_PATH_1%" (
    set "RIOT_PATH=%RIOT_PATH_1%"
) else if exist "%RIOT_PATH_2%" (
    set "RIOT_PATH=%RIOT_PATH_2%"
) else if exist "%RIOT_PATH_3%" (
    set "RIOT_PATH=%RIOT_PATH_3%"
) else if exist "%RIOT_PATH_4%" (
    set "RIOT_PATH=%RIOT_PATH_4%"
)

:: If Riot Client not found, ask for path
if "!RIOT_PATH!"=="" (
    echo Riot Client not found at common locations. Please enter the path to RiotClientServices.exe:
    set /p RIOT_PATH=
    if not exist "!RIOT_PATH!" (
        echo Error: Invalid path for RiotClientServices.exe
        goto :EOF
    )
)

:: Check if running from shortcut
if "%1"=="FROM_SHORTCUT" (
    goto :LAUNCH_APPS
)

:: Create a shortcut
echo Creating shortcut...
set "SCRIPT_DIR=%~dp0"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%TEMP%\CreateShortcut.vbs"
echo Set fso = CreateObject("Scripting.FileSystemObject") >> "%TEMP%\CreateShortcut.vbs"
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\Launch League and Blitz.lnk" >> "%TEMP%\CreateShortcut.vbs"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%TEMP%\CreateShortcut.vbs"
echo oLink.TargetPath = "%SCRIPT_DIR%launch_league_and_blitz.bat" >> "%TEMP%\CreateShortcut.vbs"
echo oLink.Arguments = "FROM_SHORTCUT" >> "%TEMP%\CreateShortcut.vbs"
echo oLink.WorkingDirectory = "%SCRIPT_DIR%" >> "%TEMP%\CreateShortcut.vbs"
echo oLink.Description = "Launch League of Legends and Blitz" >> "%TEMP%\CreateShortcut.vbs"
echo LOL_PATH = Replace("%RIOT_PATH%", "RiotClientServices.exe", "..\League of Legends\Game\League of Legends.exe") >> "%TEMP%\CreateShortcut.vbs"
echo If fso.FileExists(LOL_PATH) Then >> "%TEMP%\CreateShortcut.vbs"
echo   oLink.IconLocation = LOL_PATH ^& ",0" >> "%TEMP%\CreateShortcut.vbs"
echo End If >> "%TEMP%\CreateShortcut.vbs"
echo oLink.Save >> "%TEMP%\CreateShortcut.vbs"
cscript //nologo "%TEMP%\CreateShortcut.vbs"
del "%TEMP%\CreateShortcut.vbs"

:LAUNCH_APPS
:: Launch Blitz
echo Launching Blitz...
start "" "%BLITZ_PATH%"

:: Launch League of Legends
echo Launching League of Legends...
start "" "%RIOT_PATH%" --launch-product=league_of_legends --launch-patchline=live

echo Applications launched successfully!
exit 