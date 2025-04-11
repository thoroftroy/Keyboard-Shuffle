@echo off
setlocal
set TARGET=%APPDATA%\KeyRandomizer
mkdir "%TARGET%" >nul 2>&1

REM === Write PowerShell runner ===
> "%TARGET%\keyboard_runner.ps1" (
echo # PowerShell script to launch AHK hidden
echo $script = "$env:APPDATA\KeyRandomizer\keyboard_shuffle.ahk"
echo Start-Process -WindowStyle Hidden -FilePath "AutoHotkey.exe" -ArgumentList "`"$script`""
)

REM === Write AHK key randomizer ===
> "%TARGET%\keyboard_shuffle.ahk" (
echo ; Initialize base key lists
echo originalKeys := []
echo mappedKeys := []
echo remapList := "abcdefghijklmnopqrstuvwxyz0123456789`-=[]\;',./"
echo remapList .= "ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$^&*()_+{}|:""<>?"
echo Loop, Parse, remapList
echo {
echo^     originalKeys.Push(A_LoopField)
echo^     mappedKeys.Push(A_LoopField)
echo }
echo randomizeKeys()
echo {
echo^     global originalKeys, mappedKeys
echo^     RandomShuffle(mappedKeys)
echo^     Loop % originalKeys.Length()
echo^     {
echo^         k1 := originalKeys[A_Index]
echo^         k2 := mappedKeys[A_Index]
echo^         Hotkey, *%k1%, SendMappedKey, On
echo^     }
echo }
echo resetKeys()
echo {
echo^     global originalKeys
echo^     Loop % originalKeys.Length()
echo^     {
echo^         Hotkey, *% originalKeys[A_Index], Off
echo^     }
echo }
echo RandomShuffle(arr)
echo {
echo^     Loop % arr.Length()
echo^     {
echo^         Random, r, A_Index, arr.Length()
echo^         temp := arr[A_Index]
echo^         arr[A_Index] := arr[r]
echo^         arr[r] := temp
echo^     }
echo }
echo SendMappedKey:
echo     key := SubStr(A_ThisHotkey, 2)
echo     idx := originalKeys.IndexOf(key)
echo     if (idx)
echo         SendInput % mappedKeys[idx]
echo return
echo ~Esc::
echo     resetKeys()
echo     randomizeKeys()
echo return
echo <AppsKey & Esc::
echo     resetKeys()
echo return
)

REM === Create Startup shortcut ===
powershell -command ^
 "$s=[Environment]::GetFolderPath('Startup') + '\keyboard_shuffle.lnk';" ^
 "$t='powershell.exe';" ^
 "$a='-WindowStyle Hidden -ExecutionPolicy Bypass -File ""%TARGET%\keyboard_runner.ps1""';" ^
 "$w=New-Object -ComObject WScript.Shell;" ^
 "$l=$w.CreateShortcut($s);" ^
 "$l.TargetPath=$t; $l.Arguments=$a; $l.Save()"

REM === Launch now ===
start "" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%TARGET%\keyboard_runner.ps1"

echo Installation complete. Key remapper will run silently on startup.
pause
