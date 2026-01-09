#Requires AutoHotkey v2.0
#Include "DashboardLib.ahk"

CleanDashboard()

; --- SWITCH LAYOUT ---
Send "^!#{0}" ; Ctrl + Alt + Win + 0
Sleep(500)

; Todoist (Left 20%)
LaunchApp("Profile 6", 
          "https://app.todoist.com/app/today", 
          "Todoist", 
          0, 0, 512, 1440)

; Work Carousel (Middle 55%)
LaunchApp("Profile 8", 
          "https://analytics.google.com/", 
          "Analytics", 
          512, 0, 1408, 1440)

; Pushover (Right Top)
LaunchApp("Profile 9", 
          "https://client.pushover.net/", 
          "Pushover",  
          1920, 0, 640, 720)

; Macro Deck (Right Bottom)
LaunchApp("Profile 7", 
          "http://localhost:8191/client/", 
          "Macro",
          1920, 720, 640, 720)

ExitApp