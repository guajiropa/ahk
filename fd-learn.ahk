/*
* This is the begining of the AHK script, also refered to as the auto execute section of the AHK script. Everything 
* up to the first return will execute automaticlly when the script loads.
*/
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

str_to_send := "This is a string to share" 
MsgBox % "Howdy Bitches!!"
MsgBox % "This is where the script is stored: `r`n"A_ScriptDir
Gosub, tst_sub
myFunc(str_to_send)
Return

tst_sub: ; this is a test subroutine
MsgBox % "And this mesage box is from a subroutine."
Return

myFunc(shared_string)
{
    MsgBox % "While this message box is `r`nfrom a function call. `r`n"shared_string
    return
}