# Run the AutoHotkey script with no visible window
$script = "$env:APPDATA\KeyRandomizer\keyboard_shuffle.ahk"

# Launch in hidden mode
Start-Process -WindowStyle Hidden -FilePath "AutoHotkey.exe" -ArgumentList "`"$script`""

