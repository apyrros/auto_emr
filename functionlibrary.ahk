; function to allow gui to be movable
WM_LBUTTONDOWN() {
	PostMessage, 0xA1, 2,,, A
}

;Function to make sure the right side panel is open for data extraction.
OpenPowerscribeSidePanel(){
	WinGet, MMX2, MinMax, PowerScribe 360 | Reporting
	If (MMX2 == -1)
		WinRestore, PowerScribe 360 | Reporting
	WinActivate, PowerScribe 360 | Reporting
	WinGetText, panel, PowerScribe 360 | Reporting
	if(!InStr(panel, ".) - ")){
			ControlSend, Main Menu, {Alt Down}{v}{o}, PowerScribe 360 | Reporting
			Sleep 50
			ControlSend, Main Menu, {Alt Up}, PowerScribe 360 | Reporting
	}
	WinGetText, panel, PowerScribe 360 | Reporting
	isSuccess := InStr(panel, ".) - ") || InStr(panel, "TEMPORARY") 
	Return, isSuccess
}

TextCopiedMessageBox(){
Gui, TextCopied:New, +AlwaysOnTop, Text Copied
Gui, Color, 121212
Gui, -Caption 
Gui, Font, s18
Gui, Font, cFFFFFF

Gui, Add, Text, x10 y10  BackgroundTrans 0x201, Text has been copied to your clipboard

Gui, Show

Sleep, 2000

Gui, TextCopied:Destroy

Return
}

SendClipboardToPowerscribeEnd(){
	Global pscribetxtbox
	ControlSend, %pscribetxtbox%, {Control Down}{End}, PowerScribe 360 | Reporting
	sleep, 200
	ControlSend, %pscribetxtbox%, {Control Up}, PowerScribe 360 | Reporting
	sleep, 200
	ControlSend, %pscribetxtbox%, {Enter 2}, PowerScribe 360 | Reporting
	sleep, 200
	ControlSend, %pscribetxtbox%, {Shift Down}{Insert}, PowerScribe 360 | Reporting
	Sleep, 200
	ControlSend, %pscribetxtbox%, {Shift Up}, PowerScribe 360 | Reporting
	Sleep, 200
}

SendClipboardToPowerscribe(){
	Global pscribetxtbox
	Sleep 200
	ControlSend, %pscribetxtbox%, {Right}, PowerScribe 360 | Reporting	
	Sleep 50
	ControlSend, %pscribetxtbox%, {Enter}, PowerScribe 360 | Reporting	
	Sleep, 200
	ControlSend, %pscribetxtbox%, {Shift Down}{Insert}, PowerScribe 360 | Reporting
	Sleep, 200
	ControlSend, %pscribetxtbox%, {Shift Up}, PowerScribe 360 | Reporting
	Sleep, 200

	Return
}




; Copies the selected text to a variable while preserving the clipboard.
GetText(ByRef MyText = "", Option = "Copy")
{
   SavedClip := ClipboardAll
   Clipboard =
   If (Option == "Copy")
   {
      Send ^c
   }
   Else If (Option == "Cut")
   {
      Send ^x
   }
   ClipWait 0.5
   If ERRORLEVEL
   {
      Clipboard := SavedClip
      MyText =
      Return
   }
   MyText := Clipboard
   Clipboard := SavedClip
   Return MyText
}

/*
; Send text from a variable while preserving the clipboard.
PutText(MyText, Option = "")
{
   ; Decode text
   vSize := StrPut(MyText, "CP0")
   VarSetCapacity(vUtf8, vSize)
   vSize := StrPut(MyText, &vUtf8, vSize, "CP0")
   DecodedText := StrGet(&vUtf8, "UTF-8")

   ; Save clipboard and paste MyText
   SavedClip := ClipboardAll 
   Clipboard = 
   Sleep 20
   Clipboard := DecodedText
   If (Option == "AddSpace")
   {
      Send {Right}
      Send {Space}
   }
   Send ^v
   Sleep 100
   Clipboard := SavedClip
   Return
}   

*/



; Send text from a variable while preserving the clipboard.
PutText(MyText, Option = "")
{
   ; Save clipboard and paste MyText
   SavedClip := ClipboardAll 
   Clipboard = 
   Sleep 20
   Clipboard := MyText
   If (Option == "AddSpace")
   {
      Send {Right}
      Send {Space}
   }
   Send ^v
   Sleep 100
   Clipboard := SavedClip
   Return
}   


MessageGUI(Text, GuiName, Option){
	If(Option = "Create"){
		WinGetTitle, lastwindow, A
		Gui, %GuiName%:New, +AlwaysOnTop, GUI Prompt
		Gui, Color, 121212
		Gui, -Caption 
		Gui, Font, s18
		Gui, Font, cFFFFFF

		Gui, Add, Text, x10 y10  BackgroundTrans 0x201, %Text%

		Gui, Show
		WinActivate, %lastwindow%
	}

	If(Option ="Destroy"){
		Gui, %GuiName%:Destroy
	}
Return
}

;can get the control name by whatever text is in the control
GetPowerscribeControlbyText(Text){
WinGet, PowerscribeControls, ControlList, PowerScribe 360 | Reporting
Loop, Parse, PowerscribeControls, `n
{
	ControlGetText, TempControlText, %A_LoopField%, PowerScribe 360 | Reporting
	If(TempControlText = Text)
	{
		ControlName := A_LoopField
		Break
	}
}
Return ControlName
}

GetControlbyText(Text, Program){
WinGet, Controls, ControlList, %Program%
Loop, Parse, Controls, `n
{
	ControlGetText, TempControlText, %A_LoopField%, %Program%
	If(TempControlText = Text)
	{
		ControlName := A_LoopField
		Break
	}
}
Return ControlName
}


GetPowerscribeElementInfo(Element){
	OpenPowerscribeSidePanel()
	;GetPowerscribeControlbyText only returns the control name of the actual Element itself but not the corresponding value in the adjacent control
	;this function will return something like GE12345679 if Element is "MRN:"
	tempstr := StrSplit(GetPowerscribeControlbyText(Element), "_ad")
	;get the control name for the adjacent control
	nextcontrolnumber := tempstr[2] - 1
	;reassemable the control name
	nextcontrol := tempstr[1] . "_ad" . nextcontrolnumber
	Controlgettext, ElementInfo, %nextcontrol%, PowerScribe 360 | Reporting
	Return ElementInfo
}



GetPowerscribeTextboxname(){
;this function gets the appropriate control for powerscribes text box
Global pscribetxtboxArr := []
Global pscribetxtbox
Global pscribetxtbox2
WinGet, CtrlList, ControlList, PowerScribe 360 | Reporting
Loop, Parse, CtrlList, `n
{
	if (InStr(A_LoopField, "RICHEDIT50W")){
		pscribetxtboxArr.Push(A_LoopField)
	}
}
	pscribetxtbox := pscribetxtboxArr[1]
	pscribetxtbox2 := pscribetxtboxArr[2]
}