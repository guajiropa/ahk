/*
This modification of the original SynonymLookup.ahk script no longer merely opens the Web 
page targeted with the selected word but rather downloads the source code text directly 
from the site. Since AutoHotkey does not need to render the Web page, it's fast while 
capturing the code in a variable.

Next, using the RegExMatch() function to extract synonyms from the code, the script inserts 
each word into a pop-up menu. After selecting a word from the menu, the script replaces the
original selected word in the editing field.

You will find a number of useful AutoHotkey tricks described in the script below. These 
techniques may apply equally as well to other applications where you want to extract data from
a Web page. The script requires an Internet connection to work.

After selecting a word in your document, the Hotkey combination CTRL+ALT+L downloads the source 
code from the Web site Thesaurus.com to parse synonyms for the selected word.

Find more free AutoHotkey scripts and apps at:
http://www.computoredge.com/AutoHotkey/Free_AutoHotkey_Scripts_and_Apps_for_Learning_and_Generating_Ideas.html

April 17, 2018 Update: This latest version includes a jump to restart the process which forces the script to wait
until the menu contains more than one item before displaying. I think the initial problem resulted from
slow Web downloads.

April 27, 2018 Update: Thesaurus.com changed their page format so I changed the Regular Expression. I use 
the link in the page which included special characters and needed some adjustments. I corrected most special
characters but you may occasionally see some strange code in the menu. Plus, you might also get antonyms, so I 
added a warning icon to each antonym in a menu—if any—plus, a link directly to Thesaurus.com.

I also added a trap to break any infinite loop after 10 attempts when the Web page source code has changed format,
thus giving the user a chance to find the latest version by jumping to the download page.

September 6, 2020 I fixed the RegEx for the new version of the site. It doesn't differentiate
between synonyms and antonyms. You have to do that yourself—at least until I figure out a new way to 
implement the changes.

September 22, 2020 Corrected the antonym marking in the menu — mostly.


*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^!l::

/*
The script begins with the standard Clipboard routine where the user first selects
a word in any text or editing field.
*/

; If the source code format changes on the Web page, the GoTo loop won't stop.
; Adding the Try_Count variable counts the number of retries and exits after 10.

Try_Count := 0

If (ConnectedToInternet() = 0)
  {
    MsgBox Internet not connected!
	Return
  }
                                                      
  OldClipboard:= ClipboardAll
  Clipboard:= ""
  Send, ^c ;copies selected text
  ClipWait 0
  If ErrorLevel
    {
      MsgBox, No Text Selected!
      Return
    }
	
MenuReload:

SynonymList := Clipboard
	
	; The GetWebPage() function loads source code from the target Web into the variable SynPage.


   SynPage := GetWebPage("https://www.thesaurus.com/browse/" . Clipboard)

  
;Sleep 500
  
; The variable NewSynPos tracks the location of each synonym as AutoHotkey looks through the Web page.
; This allows the Loop to jump to the next synonym.
 
  NewSynPos := 1 
  
; The variable ItemCount increments as each synonym is added to the menu for starting new columns.
; This prevents the list from becoming too long.

  ItemCount := 1
  
; The next four lines assign the first menu items as a title highlighting the selected work in all caps, 
; with a bullet, and as a non-functioning default

   StringUpper, KeyWord, Clipboard
   Menu, Synonym, add, %KeyWord%, LoadPage, +Radio
   Menu, Synonym, check, %KeyWord%
   Menu, Synonym, default, %KeyWord%
   
; The variable AntonymPos (start) and AntonymStop (end) mark where antonyms start and stop in a page.
   
     AntonymPos := RegExMatch(SynPage,"antonyms")        
     AntonymStop := RegExMatch(SynPage,"synonyms")        
;	 MsgBox, %AntonymPos%  %AntonymStop% 

 ; The beginning of the loop which increments through the Web page variable while extracting synonyms.
   
  Loop
  {
  
; The RegExMatch function extracts each synonym based upon unique surrounding HTML code. updated September 6, 2020

  SynPos := RegExMatch(SynPage,"""targetTerm"":""(.*?)"",""targetSlug""",Synonym,NewSynPos)        ; 

	AntonymCheck := SubStr(SynPage, NewSynPos , SynPos-NewSynPos)
  If InStr(AntonymCheck,"Antonyms") {
	AntonymPos := 1
	}
  If InStr(AntonymCheck,"Synonyms") {
	AntonymPos := 0
	}



; If not found in thesaurus Break.


  If SynPage ~= "no thesaurus results"
  {
     Menu, Synonym, add, No thesaurus results!, LoadPage
	 Break
  }
  
; When AutoHotkey no longer finds a synonym, the script exits the Loop.

  If SynPos = 0
     Break

; By incrementing the position in the RegExMatch() function, AutoHotkey jumps to the next synonym.

	 
  NewSynPos := SynPos+1
  
;  Newer versions of the script use synonyms which may include special codes.
;  These StrReplace() function statements fix the words with the correct symbols.
  
    Synonym1 := StrReplace(Synonym1,"%20","-")                ;  tête-à-tête t%C3%AAte-%C3%A0-t%C3%AAte

    Synonym1 := StrReplace(Synonym1,"%27","'")
    Synonym1 := StrReplace(Synonym1,"%C3%A9","é")
    Synonym1 := StrReplace(Synonym1,"%C3%AF","ï")
    Synonym1 := StrReplace(Synonym1,"%C3%AA","ê")
    Synonym1 := StrReplace(Synonym1,"%C3%A0","à")

; Synonym1 represents the first subpattern (the synonym). AutoHotkey checks the SynonymList variable for redundancy.
; If found, the Loop skips to the next iteration. (No need to add it again, thus keeping the columns even.)

 	 If InStr(SynonymList,Synonym1)
       Continue
	   
; When the number of menu items reaches 20, the script starts a new menu column and resets the counter.
; In both cases, the script adds new menu item.
	 
	If ItemCount = 20
	{
                    Menu, Synonym, add, %Synonym1%, SynonymAction, +BarBreak
	   ItemCount := 1
	}  
	Else
	{
                     Menu, Synonym, add, %Synonym1%, SynonymAction

	   ItemCount++
	}

; When found between AntonymPos and AntonymStop, the word is an antonym adding a special warning icon.


	If (AntonymPos = 1) ; and (SkipOne = 0) ; and (AntonymPos < SynPos) and (SynPos < AntonymStop)    
	    Menu, Synonym, Icon, %Synonym1%, %A_Windir%\system32\SHELL32.dll, 78
	SkipOne = 0
; To prevent AutoHotkey from processing redundant words in the menu, the script adds each new synonym to a list of included words.

	SynonymList := SynonymList . "," . Synonym1

  }

; Display the menu.

; If the source code format changes on the Web page, the GoTo loop won't stop.
; Adding the Try_Count variable counts the number of retries and exits after 10.

  Try_Count++
  If (Try_Count = 10)
  {
    Menu, Synonym, add,App Broken! Check for update?, LoadAppPage
    Menu, Synonym, Icon, App Broken! Check for update?, %A_Windir%\system32\SHELL32.dll, 78,
  }

; If only one item appears in the menu (download not complete), the process starts over until it works.
; Otherwise, it adds options to visit Thesaurus.com and displays the menu.

 
 Menu_item_count := DllCall("GetMenuItemCount", "ptr", MenuGetHandle("Synonym"))
 
 If Menu_item_count = 1
    GoTo, MenuReload
 Else
  {
     Menu, Synonym, add, Visit, LoadPage, +Radio
     Menu, Synonym, check, Visit
     Menu, Synonym, Icon, Visit, %A_Windir%\system32\SHELL32.dll, 44
     Menu, Synonym, add, Thesaurus.com, LoadPage
     Menu, Synonym, Icon, Thesaurus.com, %A_Windir%\system32\SHELL32.dll, 44
;	 MsgBox, Attempts %Try_Count%
     Menu, Synonym, Show
  }
  
; After selection or cancelation, the script deletes the menu.

  Menu, Synonym, DeleteAll
  
; Restore the old Clipboard contents.

  Clipboard := OldClipboard

Return

; Subroutine inserts the new synonym in place of the selected word.

SynonymAction:
   SendInput %A_ThisMenuItem%{raw}
Return

; Subroutine loads the Web page into the default browser.

LoadPage:
  Run https://www.thesaurus.com/browse/%Clipboard%
Return

; The GetWebPage() function downloads the code from a Web page and returns the source code.

GetWebPage(WebPage)
{
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")   
    whr.Open("GET", WebPage, true)
    whr.Send()
    whr.WaitForResponse()
    RefSource := whr.ResponseText
    Return RefSource
}

ConnectedToInternet(flag=0x40) { 
  Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0) 
}

LoadAppPage:
       Run, http://www.computoredge.com/AutoHotkey/Free_AutoHotkey_Scripts_and_Apps_for_Learning_and_Generating_Ideas.html#SynonymLookup
Return