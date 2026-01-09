#Requires AutoHotkey v2.0
#Include "DashboardLib.ahk"

CleanDashboard()

; --- SWITCH LAYOUT ---
Send "^!#{1}" ; Ctrl + Alt + Win + 1
Sleep(500)

; Todoist (Left 33%)
LaunchApp("Profile 6", 
          "https://web.tabliss.io/", 
          "Tabliss", 
          0, 0, 512, 1440)

; Media (Right 66%)
LaunchApp("Profile 8", 
          "https://www.youtube.com/", 
          "YouTube", 
          512, 0, 1408, 1440)

ExitApp