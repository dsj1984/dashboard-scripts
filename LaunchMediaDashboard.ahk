#Requires AutoHotkey v2.0
SetTitleMatchMode 2
#Include "DashboardLib.ahk"

; --- 1. HANDLE ARGUMENTS ---
; Default to "YouTube" if no argument is passed
TargetMode := "YouTube"
if (A_Args.Length > 0) {
    TargetMode := A_Args[1]
}

; --- 2. DEFINE MEDIA SOURCES ---
; Map "Key" -> {Url, Title}
MediaSources := Map()
MediaSources["YouTube"] := {Url: "https://www.youtube.com", Title: "YouTube"}
MediaSources["TV"]      := {Url: "https://tv.youtube.com",  Title: "YouTube TV"}
MediaSources["Music"]   := {Url: "https://music.amazon.com", Title: "music.amazon"}
MediaSources["Spotify"] := {Url: "https://open.spotify.com", Title: "Spotify"}

; Safety Check: Fallback to YouTube if arg is invalid
if !MediaSources.Has(TargetMode)
    TargetMode := "YouTube"

SelectedMedia := MediaSources[TargetMode]


; --- 3. CLEAN & PREPARE LAYOUT ---
CleanDashboard()

; 33% Left / 67% Right
Zones := GetCorsairLayout(2560, 720, 1440, 8, 0.33, 0.67, 1.0)

; --- 4. LAUNCH APPS ---

; Zone 1: Tabliss (Always Static)
LaunchApp("Default", 
          "https://web.tabliss.io", 
          "New Tab", 
          Zones["Z1_X"], Zones["RealY"], Zones["Z1_W"], Zones["Z1_H"])

; Zone 2: DYNAMIC MEDIA APP
LaunchApp("Default", 
          SelectedMedia.Url, 
          SelectedMedia.Title, 
          Zones["Z2_X"], Zones["RealY"], Zones["Z2_W"], Zones["Z2_H"])


; THROW FOCUS BACK TO MAIN MONITOR
try {
    WinActivate "ahk_class Shell_TrayWnd"
}

ExitApp