#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#n::
Run Notepad
return

#IfWinActive, ahk_class Notepad
^a::MsgBox You pressed Ctrl+A while Notepad is active. Pressing Ctrl+A in any other window will pass the Ctrl+A to that window.
#c::MsgBox You pressed Win+C while Notepad is the active window.

#IfWinActive
#c::MsgBox You pressed Win+C while any window except Notepad is active.

;#If MouseIsOver("ahk_class Shell_TrayWnd")
;WheelUp::Send {Volume_Up}
;WheelDown::Send {Volume_Down}

#If, MouseIsOver(ahk_class Shell_TrayWnd)
WheelUp::Send {Volume_Up}
WheelDown::Send {Volume_Down}