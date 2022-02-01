#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


#SingleInstance, Force
#MaxThreadsPerHotkey, 2

;spam a key
F1::
toggle := !toggle

While (toggle)
{
    ;tooltip the loop is running
    send E
}
Return