#SingleInstance, force

/*
 *********************************************************************
 * This script saves X and Y coordinates in a file when you click.   *
 * It is very useful for quickly determining positions on the screen *
 * or to record several x - y positions to be parsed later on by     *
 * a macro which would click those positions automatically.          *
 *                                                                   *
 * Use the Right Mouse button or Esc to exit the application.        *
 *********************************************************************
 */

CoordMode, Mouse, Screen
s_file := "coords.txt" 					; Change as desired

Loop
{
	MouseGetPos, X, Y
	ToolTip, x(%X%)`, y(%Y%) 			; Tooltip to make everything easier
	Sleep 10
}

Esc::
RButton::
	ExitApp
~LButton::FileAppend, Click %X%`,%Y%`n, %s_file%  ; Save coords to parse e.g. 300,400