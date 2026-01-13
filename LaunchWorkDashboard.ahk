#Requires AutoHotkey v2.0
SetTitleMatchMode 2
#Include "DashboardLib.ahk"

; 1. SETUP & CLEANUP
CleanDashboard()

; 2. GET LAYOUT (Calculates coordinates automatically)
;    Pass in: (CorsairWidth, CorsairHeight, MainMonitorHeight, Offset, Left%, Center%, Split%)
Zones := GetCorsairLayout(2560, 720, 1440, 8, 0.20, 0.55, 0.50)


; 3. LAUNCH APPS
; -----------------------------------------------------------

; Zone 1: Todoist (Left 20%)
LaunchApp("Profile 6", 
          "https://app.todoist.com/app/today", 
          "Todoist", 
          Zones["Z1_X"], Zones["RealY"], Zones["Z1_W"], Zones["Z1_H"])

; Zone 2: Work Carousel (Center 55%)
LaunchApp("Profile 8", 
          "https://analytics.google.com/", 
          "Analytics", 
          Zones["Z2_X"], Zones["RealY"], Zones["Z2_W"], Zones["Z2_H"])

; Zone 3 Top: SharpTools (Right Top)
LaunchApp("Profile 9", 
          "https://client.pushover.net/", 
          "Pushover",  
          Zones["Z3_X"], Zones["Z3Top_Y"], Zones["Z3_W"], Zones["Z3Top_H"])

; Zone 3 Bottom: Macro Deck (Right Bottom)
LaunchApp("Profile 7", 
          "http://localhost:8191/client/", 
          "Macro", 
          Zones["Z3_X"], Zones["Z3Btm_Y"], Zones["Z3_W"], Zones["Z3Btm_H"])

ExitApp