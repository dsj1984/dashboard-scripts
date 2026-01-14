#Requires AutoHotkey v2.0
SetTitleMatchMode 2
#Include "DashboardLib.ahk"

; 1. SETUP & CLEANUP
CleanDashboard()

; 2. GET LAYOUT (Calculates coordinates automatically)
;    Pass in: (CorsairWidth, CorsairHeight, MainMonitorHeight, Offset, Left%, Center%, Split%)
Zones := GetCorsairLayout(2560, 720, 1440, 8, 1.0, 0, 1)


; 3. LAUNCH APPS
; -----------------------------------------------------------

; Zone 1: Tabliss (Always Static)
LaunchApp("Default", 
          "https://web.tabliss.io", 
          "New Tab", 
          Zones["Z1_X"], Zones["RealY"], Zones["Z1_W"], Zones["Z1_H"])

ExitApp