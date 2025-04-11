; Initialize base key lists
originalKeys := []
mappedKeys := []

; List of remappable keys
remapList := "abcdefghijklmnopqrstuvwxyz0123456789`-=[]\;',./"
remapList .= "ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+{}|:\"<>?"

Loop, Parse, remapList
{
    originalKeys.Push(A_LoopField)
    mappedKeys.Push(A_LoopField)
}

; Create a function to remap all keys randomly
randomizeKeys()
{
    global originalKeys, mappedKeys
    RandomShuffle(mappedKeys)
    Loop % originalKeys.Length()
    {
        k1 := originalKeys[A_Index]
        k2 := mappedKeys[A_Index]
        Hotkey, *%k1%, SendMappedKey, On
    }
}

; Restore all keys
resetKeys()
{
    global originalKeys
    Loop % originalKeys.Length()
    {
        Hotkey, *% originalKeys[A_Index], Off
    }
}

; Randomly shuffle an array (Fisher-Yates)
RandomShuffle(arr)
{
    Loop % arr.Length()
    {
        Random, r, A_Index, arr.Length()
        temp := arr[A_Index]
        arr[A_Index] := arr[r]
        arr[r] := temp
    }
}

; Send remapped key
SendMappedKey:
    key := SubStr(A_ThisHotkey, 2) ; strip '*' from hotkey
    idx := originalKeys.IndexOf(key)
    if (idx)
        SendInput % mappedKeys[idx]
Return

; Intercept ESC to shuffle keys
~Esc::
    resetKeys()
    randomizeKeys()
Return

; Fun + Esc to reset keys
<AppsKey & Esc::
    resetKeys()
Return
