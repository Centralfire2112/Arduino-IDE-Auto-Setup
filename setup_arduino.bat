@echo off
setlocal enabledelayedexpansion

:: Set variables
set "ARDUINO_DIR=C:\arduino-ide"
set "ARDUINO_EXE=Arduino IDE.exe"
set "SHORTCUT_NAME=Arduino IDE.lnk"
set "DOWNLOAD_URL=https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.3_Windows_64bit.zip"
set "TEMP_ZIP=%TEMP%\arduino-ide.zip"

:: Detect Desktop location universally using PowerShell
for /f "usebackq delims=" %%i in (`powershell -Command "[Environment]::GetFolderPath('Desktop')"`) do set "DESKTOP=%%i"
:: Fallback to standard Desktop if PowerShell query fails
if not defined DESKTOP set "DESKTOP=%USERPROFILE%\Desktop"
if not exist "!DESKTOP!" (
    if exist "%USERPROFILE%\OneDrive\Desktop" set "DESKTOP=%USERPROFILE%\OneDrive\Desktop"
)

echo ========================================
echo Arduino IDE Setup Script
echo ========================================
echo.
echo [DEBUG] Desktop location: !DESKTOP!
echo.

:: Clean up any previous temp installations
if exist "C:\arduino-temp" (
    echo [INFO] Cleaning up previous temporary files...
    rmdir /s /q "C:\arduino-temp" 2>nul
)

:: Check if Arduino IDE folder exists
if exist "%ARDUINO_DIR%\Arduino IDE.exe" (
    echo [INFO] Arduino IDE folder found at %ARDUINO_DIR%
    set ARDUINO_PATH=%ARDUINO_DIR%\Arduino IDE.exe
    echo [INFO] Arduino IDE executable found
    goto :CreateShortcut
) else if exist "%ARDUINO_DIR%" (
    echo [WARNING] Arduino IDE folder exists but executable not found.
    echo [INFO] Will download and install Arduino IDE...
    goto :Download
) else (
    echo [INFO] Arduino IDE not found at %ARDUINO_DIR%
    echo [INFO] Downloading Arduino IDE...
    goto :Download
)

:Download
echo.
echo [INFO] Downloading Arduino IDE from official website...
echo [INFO] This may take several minutes depending on your connection...

:: Download using PowerShell
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%TEMP_ZIP%' -UseBasicParsing}"

if not exist "%TEMP_ZIP%" (
    echo [ERROR] Download failed. Please check your internet connection.
    pause
    exit /b 1
)

echo [INFO] Download complete!
echo.
echo [INFO] Extracting Arduino IDE to %ARDUINO_DIR%...

:: Extract using PowerShell
set "EXTRACT_TEMP=C:\arduino-temp"
echo [INFO] Extracting to temporary location...
powershell -Command "& {Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%EXTRACT_TEMP%' -Force}" 2>nul

if errorlevel 1 (
    echo [ERROR] Extraction failed. The zip file may be corrupted.
    echo [INFO] Please check your internet connection and try again.
    del "%TEMP_ZIP%" 2>nul
    pause
    exit /b 1
)

echo [INFO] Extraction complete!

:: Find the extracted Arduino IDE executable in temp location
set "FOUND=0"
for /r "%EXTRACT_TEMP%" %%F in ("Arduino IDE.exe") do (
    if exist "%%F" (
        set ARDUINO_PATH=%%F
        set "FOUND=1"
        echo [INFO] Arduino IDE found at: %%F
        
        :: Get the parent directory of the executable
        for %%D in ("%%~dpF.") do set EXTRACTED_DIR=%%~fD
        
        echo [INFO] Moving to %ARDUINO_DIR%...
        
        :: Remove old directory if exists
        if exist "%ARDUINO_DIR%" (
            echo [INFO] Removing old installation...
            rmdir /s /q "%ARDUINO_DIR%"
        )
        
        :: Move to final location
        move "!EXTRACTED_DIR!" "%ARDUINO_DIR%" >nul 2>&1
        
        if exist "%ARDUINO_DIR%\Arduino IDE.exe" (
            set ARDUINO_PATH=%ARDUINO_DIR%\Arduino IDE.exe
            echo [INFO] Installation successful!
        ) else (
            echo [WARNING] Move failed, using temp location
        )
        
        goto :CleanupAndShortcut
    )
)

if "!FOUND!"=="0" (
    echo [ERROR] Could not find Arduino IDE executable after extraction.
    echo [ERROR] The downloaded file may be incomplete or corrupted.
    echo [INFO] Please try running this script again.
    pause
    exit /b 1
)

:CleanupAndShortcut
:: Verify we have a valid path
if not defined ARDUINO_PATH (
    echo [ERROR] Arduino path not set correctly.
    pause
    exit /b 1
)

echo [INFO] Arduino IDE location: !ARDUINO_PATH!

:: Clean up temp files
if exist "%TEMP_ZIP%" del "%TEMP_ZIP%"
if exist "%EXTRACT_TEMP%" (
    if not "!ARDUINO_PATH!"=="" (
        if exist "!ARDUINO_PATH!" (
            echo [INFO] Cleaning up temporary extraction folder...
            rmdir /s /q "%EXTRACT_TEMP%" 2>nul
        )
    )
)

:CreateShortcut
echo.
echo [INFO] Creating desktop shortcut...

:: Create a PowerShell script file to avoid escaping issues
set "PS_SCRIPT=%TEMP%\create_shortcut.ps1"
echo $WshShell = New-Object -ComObject WScript.Shell > "!PS_SCRIPT!"
echo $Shortcut = $WshShell.CreateShortcut('%DESKTOP%\%SHORTCUT_NAME%') >> "!PS_SCRIPT!"
echo $Shortcut.TargetPath = '!ARDUINO_PATH!' >> "!PS_SCRIPT!"
echo $Shortcut.WorkingDirectory = '%ARDUINO_DIR%' >> "!PS_SCRIPT!"
echo $Shortcut.Description = 'Arduino IDE' >> "!PS_SCRIPT!"
echo $Shortcut.Save() >> "!PS_SCRIPT!"

powershell -ExecutionPolicy Bypass -File "!PS_SCRIPT!"
del "!PS_SCRIPT!"

if exist "%DESKTOP%\%SHORTCUT_NAME%" (
    echo [SUCCESS] Desktop shortcut created successfully!
) else (
    echo [ERROR] Failed to create desktop shortcut.
    echo [INFO] You can manually create a shortcut to: !ARDUINO_PATH!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo Arduino IDE is ready to use.
echo You can launch it from the desktop shortcut.
echo.
pause
