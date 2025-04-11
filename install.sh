#!/bin/bash
# Bash installer for randomized keyboard remapper

# Target directory in %APPDATA%
win_appdata="$(powershell.exe -Command '[Environment]::GetFolderPath("ApplicationData")' | tr -d '\r')"
target_dir="$win_appdata\\KeyRandomizer"

# Create directory
powershell.exe -Command "New-Item -ItemType Directory -Force -Path '$target_dir'"

# Copy all required files
cp keyboard_shuffle.ahk keyboard_runner.ps1 startup.lnk /mnt/c/Users/$(whoami)/AppData/Roaming/KeyRandomizer/

# Set up startup shortcut
powershell.exe -Command "\$WshShell = New-Object -ComObject WScript.Shell; \$Shortcut = \$WshShell.CreateShortcut([Environment]::GetFolderPath('Startup') + '\\keyboard_shuffle.lnk'); \$Shortcut.TargetPath = 'powershell.exe'; \$Shortcut.Arguments = '-WindowStyle Hidden -ExecutionPolicy Bypass -File \"$target_dir\\keyboard_runner.ps1\"'; \$Shortcut.Save()"

echo "Installed. Will auto-start silently next reboot."
