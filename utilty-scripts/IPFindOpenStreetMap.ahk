; IPFindOpenStreetMap.ahk 
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Jack Dunning (https://jacksautohotkeyblog.wordpress.com/about/contact-jack/)
;
; Script Function:
;	Find IP addresses in selected text and access the Web for geographic location. Hotkey CTRL+ALT+I
;
; March 3, 2019, Rewrote the script to use a more reliable Web page with better information.
; April 23, 2021, Fixed for changed Web page formatting. Added list to map. Converted to GUI.
; May 6, 2021, Switched to new source page since blocked by old source.
; May 10, 2021, Added maps from OpenStreetMap.com to GUI
; May 20, 2021, Switched to iFrame with embedded Google Map
; May 27, 2021, Dumped Google in favor of OpenStreetMap.org

; The following next Regular Expression is for complete validation within range of 0-255
; ^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$
; Reduced RegEx for a match only
; \b(\d{1,3}\.){3}\d{1,3}\b 

; Windows Registry change for IE compatibility with AutoHotkey
; Discussed in https://jacks-autohotkey-blog.com/2021/05/17/embed-google-maps-in-an-autohotkey-gui-no-api-required/ 
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

 RegRead,KeyValue,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION,AutoHotkey.exe
 If ErrorLevel
    RegWrite, REG_DWORD,HKEY_CURRENT_USER\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION,AutoHotkey.exe,11001


HTML1 := "<div style='width: 100%'><iframe width='100%' height='225' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='https://www.openstreetmap.org/export/embed.html?bbox="
HTML2 := "&amp;layer=cyclemap' style='border: 1px solid black'></iframe></div>"

; MsgBox %HTML1%[lat,long]%HTML2%

Return

^!i::
  OldClipboard:= ClipboardAll
  Clipboard:= ""
  Send, ^c ;copies selected text
  ClipWait 0
  If ErrorLevel
    {
      MsgBox, No Text Selected!
      Return
    }
CountIP := 1
Next := 1
Loop
{
  FoundPos := RegExMatch(Clipboard, "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b" , ipaddress%CountIP%, Next)
  Next := FoundPos + StrLen(ipaddress%CountIP%)
  If FoundPos = 0
    Break
  CountIP++
}
Gui, +AlwaysOnTop
If IPAddress1
  {
    CountIP--
    Loop, %CountIP%
    {
       	CheckIP := ipaddress%A_Index%
       	WhereIs := GetLocation(CheckIP)


; For latitude, longitude map
		MapEmbed := HTML1 . WhereIs[4]-2 . "," . WhereIs[3]-3 . "," . WhereIs[4]+2 . "," . WhereIs[3]+3 . "&amp;marker=" . WhereIs[3] . "," . WhereIs[4] . HTML2

; msgbox % MapEmbed
		FileDelete, %A_ScriptDir%\OpenStreetMapEmbed.html
		FileAppend , %MapEmbed%, %A_ScriptDir%\OpenStreetMapEmbed.html


; msgbox % WhereIs[1] "`r" City "`r" City1  "`r" State "`r" State1 "`r" Country "`r" country1
		WhereIs[1] := StrReplace(WhereIs[1],"Postal code","`rPostal code:`t")
		WhereIs[1] := StrReplace(WhereIs[1],"Region","`rRegion/State:")
		WhereIs[1] := StrReplace(WhereIs[1],"Country","`rCountry:`t`t")
		WhereIs[1] := StrReplace(WhereIs[1],"State:","State:`t")
		WhereIs[1] := StrReplace(WhereIs[1],"Continent","`rContinent:`t")
		WhereIs[1] := StrReplace(WhereIs[1],"Metro code","`rMetro code:`t")
		WhereIs[1] := StrReplace(WhereIs[1],"City","`rCity:`t`t")
		WhereIs[1] := StrReplace(WhereIs[1],"Coordinates","`rCordinates:`t")

		
		Gui, Add, Text, xm section, % CheckIP . WhereIs[1] 
		Gui Add, ActiveX, ys x250 w225 h175 vWB%A_Index%, Shell.Explorer
		FilePathName := A_ScriptDir . "\OpenStreetMapEmbed.html"
		WB%A_Index%.Navigate(FilePathName)
		Gui, Add , Link, xs yp+120, % "<a href=""https://tools.keycdn.com/geo?host=" . CheckIp . """>IP Data" . "</a>" 
; For latitude, longitude map link
		Gui, Add, Link, yp+15, % WhereIs[2]
		Gui, Add, Link, yp+15, <a href="https://www.openstreetmap.org/copyright">© OpenStreetMap contributors</a>
    }
}
Else
  WhereIs := "No IPs Found!"

Clipboard := OldClipboard

Gui, Add, Button,xm section, Close
Gui, Show,,IP Locations OpenStreetMap (Scroll to zoom)

Return

GetLocation(findip)
{
UrlDownloadToFile, % "https://tools.keycdn.com/geo?host=" . findip, iplocate
	IPsearch := "https://tools.keycdn.com/geo?host=" . findip
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", IPsearch)
	whr.Send()
	  sleep 100
	version := whr.ResponseText
	RegExMatch(version, "s)Location</p>(.*?)Time</dt>", Location)
    FileRead, version2, iplocate
	RegExMatch(version, "Coordinates</dt><dd class=""col-8 text-monospace"">(.*?) \(lat\) / (.*?)\(long\)", Map)
	Map := Map1 . "," . Map2
; For OpenStreetMap
	MapLink := "<a href=""https://www.openstreetmap.org/?mlat=" . map1 . "&mlon=" . map2 . "#map=5/" . Map . "&layers=C"">Go to larger map" . "</a>"
;	MapGet := "https://www.openstreetmap.org/?mlat=" . map1 . "&mlon=" . map2 . "#map=5/" . Map1 . "/" . Map2
; Strip out HTML tags
	Location := RegExReplace(Location1,"<.+?>")
; For OpenStreetMap
	Return [Location,MapLink,Map1,Map2]

}

ButtonClose:
	WinClose
Return

GuiClose:
	Gui, Destroy
Return