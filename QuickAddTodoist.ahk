#Requires AutoHotkey v2.0

; 1. Save current clipboard to restore later
OldClipboard := A_Clipboard
A_Clipboard := "" ; Start completely clean

; 2. Send Copy Command
Send "^c"

; 3. Wait up to 1 second for text to appear.
; If it fails (returns 0), we DO NOT load the old clipboard. We just proceed empty.
if ClipWait(1) {
    capturedText := A_Clipboard
    
    ; --- SAFETY FIX: Flatten the text ---
    ; Replace all newlines (`n and `r) with spaces.
    ; This prevents Todoist from trying to create 30 separate tasks.
    capturedText := StrReplace(capturedText, "`r`n", " ")
    capturedText := StrReplace(capturedText, "`n", " ")
    capturedText := StrReplace(capturedText, "`r", " ")
} else {
    capturedText := "" ; Safety: Ensure variable is empty if copy failed
}

; 4. Open Todoist Quick Add (Control + Space)
Send "^{Space}"

; 5. Wait for the window
if WinWait("Todoist", , 2) {
    ; Only paste if we actually caught new text
    if (capturedText != "") {
        ; We put the "Safe" flattened text onto the clipboard just for this paste
        A_Clipboard := capturedText
        Send "^v"
        Sleep 100 ; Short breath to let paste finish
    }
}

; 6. Restore your original clipboard (so you don't lose your previous work)
A_Clipboard := OldClipboard