#Requires AutoHotkey v2.0
SetTitleMatchMode 2  ; Allows for partial title matching
#Include "DashboardLib.ahk"

CleanDashboard()

; SWITCH LAYOUT
Send "^!#{0}" ; Ctrl + Alt + Win + 0
Sleep(500)

; Todoist (Left 20%)
LaunchApp("Profile 6", 
          "https://app.todoist.com/app/today", 
          "Todoist", 
          0, 0, 512, 1440)
		  
; Work Carousel (Middle 55%)
LaunchApp("Profile 5", 
          "https://text.npr.org/", 
          "NPR", 
          512, 0, 1408, 1440)

; Sharp (Right Top)
LaunchApp("Profile 10", 
          "https://sharptools.io/dashboard/view/5Bm9vEcFqQ4QNQAZZL5B?kiosk=true", 
          "Sharp",  
          1920, 0, 640, 720)

; Macro Deck (Right Bottom)
LaunchApp("Profile 7", 
          "http://localhost:8191/client/", 
          "Macro", 
          1920, 720, 640, 720)

ExitApp