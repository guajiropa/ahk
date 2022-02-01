/*
**  AHK FAQ2 work thru file
**  RJP 01/22/22
***********************************************************************************************************************
** ! = Alt
** + = Shift
** ^ = Ctrl
** # = Win
*/

#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%


;strMsg = this is my "quoted" results: 
;MsgBox % strMsg 5 + 5

;InputBox, strUsername, System User Name, Pleas supply the username: , , 400, 150,,,,, 
;MsgBox % "Target strUsername is: " strUsername

;FileSelectFile, fileLoc, S24, %A_ScriptDir%, Please Select A File, *.ahk
;MsgBox % fileLoc

;FileSelectFolder, folderLoc, F:\SRC\repos\ahk, 3, Please Select A Folder
;MsgBox % folderLoc

/*
** Fakeing Multi-Thread Simulation scripting
--
F1::
SetTimer, F2, 5
Loop
{
    ToolTip, % "loop1:" a_index, % A_ScreenWidth/2, % A_ScreenHeight/2, 1   
}
ToolTip 
Return

F2::
counter +=1 
ToolTip, % "loop2:" counter, % (A_ScreenWidth/2) + 100, % A_ScreenHeight/2, 2    
Return

Esc::ExitApp
--
*/

;a::z
;z::a

;a & s::Y

; use the tilde to still send the orignal key + whatever ahk assignment is set

;~a::z

/*
** how to check for the active window you want from ahk script
--
SetTitleMatchMode, 2

if WinActive("Visual Studio Code")
    msgbox True
Else
    msgbox false
--
*/

/*

/*
**
** Context sensitve hotkeys
**
** ! = Alt
** + = Shift
** ^ = Ctrl
** # = Win
--
SetTitleMatchMode, 2

#IfWinActive Notepad
^y::msgbox % "This is my Hotkey"
#IfWinActive
^y::msgbox % "Notepad.exe is not the active window"

;if WinActive("Notepad")
;    msgbox % "This is my Hotkey"
;return
--
*/

/*
** #Include will search the following three places:
**    Local Library | %A_ScriptDir%\Lib\
**     User Library | %A_MyDocuments%\AutoHotkey\Lib\
** Standard Library | %A_AhkPath%\Lib\
**
** you can include files from anywhere, however you will need the complete pathname to include a file if it 
** is not in one of the default search paths listed above.
--

#Include <Coord Saver>

--
*/

/*
** Check user access level (UAC)
--

;msgbox % A_IsAdmin
if (!A_IsAdmin)
{
    Run, *RunAs "%A_ScriptFullPath%"
    ExitApp
}

msgbox % A_IsAdmin

--
*/
