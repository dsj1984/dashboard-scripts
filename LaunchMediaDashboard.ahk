#Requires AutoHotkey v2.0
SetTitleMatchMode 2
#Include "DashboardLib.ahk"

CleanDashboard()

; --- THE TRICK ---
; We set Left to 33% and Center to 67%. 
; This adds up to 1.00, so Zone 3 becomes size 0.
Zones := GetCorsairLayout(2560, 720, 1440, 8, 0.33, 0.67, 1.0)

; 1. Tabliss (Left 33%)
LaunchApp("Default", 
          "https://web.tabliss.io", 
          "New Tab",
          Zones["Z1_X"], Zones["RealY"], Zones["Z1_W"], Zones["Z1_H"])

; 2. YouTube (Right 67%)
LaunchApp("Default", 
          "https://www.youtube.com", 
          "YouTube", 
          Zones["Z2_X"], Zones["RealY"], Zones["Z2_W"], Zones["Z2_H"])

ExitApp