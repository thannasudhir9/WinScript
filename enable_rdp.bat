@echo off
setlocal

:: --- Configuration ---
:: Replace 'YOUR_USERNAME' with the actual username you want to grant RDP access to.
:: If you want to grant access to the user currently running the script, use %USERNAME%.
:: For example: set RDP_USER=%USERNAME%
set "RDP_USER=YOUR_USERNAME" 

:: --- Script Start ---
echo.
echo ===========================================
echo  Enabling Remote Desktop and Firewall Rules
echo ===========================================
echo.

:: 1. Enable Remote Desktop
echo Enabling Remote Desktop...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 0 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "PortNumber" /t REG_DWORD /d 3389 /f >nul
echo Remote Desktop enabled.

:: 2. Configure Windows Firewall for Remote Desktop
echo Configuring Windows Firewall for Remote Desktop...
netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes >nul
echo Firewall rules for Remote Desktop configured.

:: 3. Add User to Remote Desktop Users Group
:: This allows the specified user to connect via Remote Desktop.
:: IMPORTANT: The user must have a password set to connect via RDP.
echo Adding user "%RDP_USER%" to the Remote Desktop Users group...
net localgroup "Remote Desktop Users" "%RDP_USER%" /add
if %errorlevel% equ 0 (
    echo User "%RDP_USER%" added to Remote Desktop Users group successfully.
) else (
    echo Error: Could not add user "%RDP_USER%" to Remote Desktop Users group.
    echo Please ensure the username is correct and exists.
)

echo.
echo ===========================================
echo  Remote Desktop Setup Complete!
echo ===========================================
echo.
echo You can now connect to this machine using Remote Desktop Connection.
echo Make sure "%RDP_USER%" has a password set.
echo.
pause
endlocal