;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%



#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MsgBox, A_Username %A_Username%`nA_MyDocuments  %A_MyDocuments%`nA_AppData %A_AppData%`nA_IsAdmin %A_IsAdmin%

if (!A_IsAdmin)
{
    Run, *RunAs "%A_ScriptFullPath%"    ;elevates the script to run in Admin mode
}

MsgBox, A_Username %A_Username%`nA_MyDocuments  %A_MyDocuments%`nA_AppData %A_AppData%`nA_IsAdmin %A_IsAdmin%