#Requires AutoHotkey v2.0
SetTitleMatchMode 2

; Define where we keep our list of active window IDs
SessionFile := A_Temp . "\AHK_Dashboard_Session.txt"

; --- CLEANUP: THE TERMINATOR ---
CleanDashboard() {
    global SessionFile
    
    ; 1. If no session file exists, there is nothing to clean
    if !FileExist(SessionFile)
        return

    ; 2. Read the file (it's just a list of ID numbers)
    fileContent := FileRead(SessionFile)
    
    ; 3. Loop through every ID in the file
    Loop Parse, fileContent, "`n", "`r" {
        thisId := A_LoopField
        if (thisId = "")
            continue
            
        ; 4. Kill it by ID (We don't care what the title is)
        try {
            if WinExist("ahk_id " . thisId)
                WinClose("ahk_id " . thisId)
        }
    }
    
    ; 5. Delete the list (Start fresh)
    FileDelete(SessionFile)
    Sleep(500)
}

; --- LAUNCHER: THE REGISTRAR ---
LaunchApp(profile, url, waitTitle, x, y, w, h) {
    global SessionFile

    ; 1. Launch Chrome
    chromePath := "C:\Program Files\Google\Chrome\Application\chrome.exe"
    runStr := Format('"{1}" --profile-directory="{2}" --app={3}', chromePath, profile, url)
    Run(runStr)

    ; 2. Wait for it to appear (by generic title)
    try {
        hwnd := WinWait(waitTitle, , 5)
    } catch {
        MsgBox("Script timed out waiting for: " . waitTitle)
        return
    }

    ; 3. Move it
    WinActivate(hwnd)
    WinMove(x, y, w, h, hwnd)

    ; 4. REGISTER IT: Add this specific ID to our session list
    FileAppend(hwnd . "`n", SessionFile)
}