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


; ==============================================================================
; Function: GetCorsairLayout
; Description: Finds Corsair monitor and calculates Dynamic Zones based on % inputs
; Parameters:
;   - PctLeft: Width of Zone 1 (Decimal, e.g., 0.20)
;   - PctCenter: Width of Zone 2 (Decimal, e.g., 0.55)
;   - PctVertSplit: Where to split Zone 3 vertically (Decimal, e.g., 0.50 for half)
; ==============================================================================
GetCorsairLayout(TargetW := 2560, TargetH := 720, MainMonitorH := 1440, Offset := 8, 
                 PctLeft := 0.20, PctCenter := 0.55, PctVertSplit := 0.50)
{
    ; 1. FIND THE MONITOR
    MonitorCount := SysGet(80)
    CorsairX := 0
    CorsairY := 0
    Found := false

    Loop MonitorCount
    {
        MonitorGet(A_Index, &L, &T, &R, &B)
        if ((R - L) == TargetW) {
            CorsairX := L
            CorsairY := T
            Found := true
            break
        }
    }

    if (!Found) {
        MsgBox("Could not find Corsair monitor with width " . TargetW)
        ExitApp
    }

    ; 2. CALCULATE WIDTHS (Dynamic)
    W1 := Floor(TargetW * PctLeft)
    W2 := Floor(TargetW * PctCenter)
    W3 := TargetW - W1 - W2  ; Calculate remaining space to ensure perfect fit

    ; 3. CALCULATE HEIGHTS (Dynamic Vertical Split)
    H_Top := Floor(TargetH * PctVertSplit)
    H_Btm := TargetH - H_Top

    ; 4. DEFINE ZONES & APPLY OFFSETS
    RealY := MainMonitorH - 1
    Layout := Map()

    ; --- Zone 1: Left ---
    Layout["Z1_X"] := CorsairX - Offset
    Layout["Z1_W"] := W1 + (Offset * 2)
    Layout["Z1_H"] := TargetH + Offset + 1

    ; --- Zone 2: Center ---
    Layout["Z2_X"] := CorsairX + W1 - Offset
    Layout["Z2_W"] := W2 + (Offset * 2)
    Layout["Z2_H"] := TargetH + Offset + 1

    ; --- Zone 3: Right (Full Width Base) ---
    Layout["Z3_X"] := CorsairX + W1 + W2 - Offset
    Layout["Z3_W"] := W3 + (Offset * 2)

    ; --- Zone 3 Vertical Splits ---
    ; Top Half
    Layout["Z3Top_Y"] := RealY
    Layout["Z3Top_H"] := H_Top + Offset
    
    ; Bottom Half
    Layout["Z3Btm_Y"] := RealY + H_Top - Offset
    Layout["Z3Btm_H"] := H_Btm + (Offset * 2) + 1

    ; Common Y for full height zones
    Layout["RealY"] := RealY

    return Layout
}


; ==============================================================================
; Function: LaunchApp
; Description: Launches Chrome in App Mode and moves it to the target zone
; ==============================================================================
LaunchApp(Profile, Url, TitleSnippet, X, Y, W, H)
{
    ; 1. Define Chrome Path (Adjust if necessary)
    ChromePath := "C:\Program Files\Google\Chrome\Application\chrome.exe"
    
    ; 2. Construct the Command
    ; We use --app=URL to force it into a separate window, even with "Default" profile
    if (Profile == "Default") {
        RunCmd := Format('"{1}" --app="{2}"', ChromePath, Url)
    } else {
        RunCmd := Format('"{1}" --profile-directory="{2}" --app="{3}"', ChromePath, Profile, Url)
    }

    ; 3. Check if Window Exists
    if !WinExist(TitleSnippet) {
        Run RunCmd
        
        ; CRITICAL FIX: Wait for the window to actually load its title
        ; Wait up to 5 seconds for "Tabliss" (or whatever title) to appear
        if !WinWait(TitleSnippet, , 5) {
            ; If it times out, try finding it by generic Chrome class as a fallback
            if !WinWait("ahk_exe chrome.exe", , 2) {
                MsgBox "Error: Could not launch or find window for: " . TitleSnippet
                return
            }
        }
    }

    ; 4. Move and Activate
    ; We re-check WinExist to get the HWND (Handle) freshly
    if WinExist(TitleSnippet) {
        WinActivate ; Activates the "Found" window from WinExist
        
        ; Small sleep to ensure window is ready to move
        Sleep 50 
        
        WinRestore ; Un-maximize to ensure it can be moved
        WinMove X, Y, W, H
    }
}