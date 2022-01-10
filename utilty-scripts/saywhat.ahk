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

Gui, Add, Text,, Read to me:
Gui, Add, Edit, w375 vSpeakOutLoud 
Gui, Add, Button, default, Talk 
Gui, Show, w400 , Speak to Me!
return

ButtonTalk:
;  VarSetCapacity(SpeakOutLoud,0)
  Gui, Submit,NoHide
  GuiControl,,SpeakOutLoud,    ;This will clear the text box
  ComObjCreate("SAPI.SpVoice").Speak(SpeakOutLoud)
Return