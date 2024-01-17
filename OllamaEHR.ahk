#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey 000000000
;;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

DetectHiddenWindows, On

CoordMode, Mouse, Screen

#Include tf.ahk
#Include functionlibrary.ahk
#Include JSON.ahk

MainbuttonW :=  200
MainbuttonH := 25
MainbuttonGap := 5


Gui, EpicAI: New, +AlwaysOnTop, EpicAI
Gui, Color, 121212, 666666
Gui, Font, cFFFFFF

Gui, Add, Text, x5 y+8, FUNCTIONS
Gui, Add, Progress, w%MainButtonW% h%MainbuttonH%  x+%MainbuttonGap% y+5 x5 Disabled Background252525 vSummarize
Gui, Add, Text, xp yp wp hp BackgroundTrans 0x201 gSummarize, Summarize Clinical Data

Gui, Add, Progress, w%MainButtonW% h%MainbuttonH%  x+%MainbuttonGap% yp x+5 Disabled Background252525 vSOAP
Gui, Add, Text, xp yp wp hp BackgroundTrans 0x201 gSOAP, Generate SOAP note

Gui, Add, Progress, w%MainButtonW% h%MainbuttonH%  x+%MainbuttonGap% yp x+5 Disabled Background252525 vCancerHx
Gui, Add, Text, xp yp wp hp BackgroundTrans 0x201 gCancerHx, Any Cancer Hx?

Gui, Add, Progress, w%MainButtonW% h%MainbuttonH%  x+%MainbuttonGap% yp x+5 Disabled Background252525 vChemoHx
Gui, Add, Text, xp yp wp hp BackgroundTrans 0x201 gChemoHx, Chemo Hx

Gui, Add, Progress, w%MainButtonW% h%MainbuttonH%  x+%MainbuttonGap% y+5 x5 Disabled Background252525 vRadiation
Gui, Add, Text, xp yp wp hp BackgroundTrans 0x201 gRadiationHx, Any Radiation Hx?

Gui, Add, Text, y+5 x5, CLINICAL DATA
Gui, Add, Text, yp xp+405, OUTPUT

Gui, Add, Edit, vPasteBin y+5 x5 w400 h200
Gui, Add, Edit, vOllamaOutput yp x+5 w400 h200

Gui, Show


;Gui,Bing:  Show, x%X% y%Y% w260, Bing Interface
Gui, EpicAI:  Show,, EpicAI Interface
Return

Summarize:
Ollama_Output := JSON.Load(Epic_GeneratePrompt("Summarize the clinical data in 5 bullet points. Do not fabricate any details, and only base your responses on the clinical data provided."))[1].output
GuiControl,, OllamaOutput, %Ollama_Output%  ; Set the content of the Edit control to the clipboard
GuiControl,, PasteBin, %clipboard%  ; Set the content of the Edit control to the clipboard

Return

SOAP:
Ollama_Output := JSON.Load(Epic_GeneratePrompt("Based on the following clinical data, write me a concise SOAP noted. Do not fabricate any details, and only base your responses on the clinical data provided."))[1].output
GuiControl,, OllamaOutput, %Ollama_Output%  ; Set the content of the Edit control to the clipboard
GuiControl,, PasteBin, %clipboard%  ; Set the content of the Edit control to the clipboard

Return

CancerHx:
Ollama_Output := JSON.Load(Epic_GeneratePrompt("Based on the following clinical data, does the patient have a history of cancer of any kind? Exclude family history of cancer. Do not fabricate any details, and only base your responses on the clinical data provided."))[1].output
GuiControl,, OllamaOutput, %Ollama_Output%  ; Set the content of the Edit control to the clipboard
GuiControl,, PasteBin, %clipboard%  ; Set the content of the Edit control to the clipboard

Return

; This hotkey (Ctrl+Shift+V) will paste the clipboard contents into the Edit control
ChemoHx:
Ollama_Output := JSON.Load(Epic_GeneratePrompt("List any chemotherapy agents the patient has recieved. Do not fabricate any details, and only base your responses on the clinical data provided."))[1].output
GuiControl,, OllamaOutput, %Ollama_Output%  ; Set the content of the Edit control to the clipboard
GuiControl,, PasteBin, %clipboard%  ; Set the content of the Edit control to the clipboard

Return


RadiationHx:
Ollama_Output := JSON.Load(Epic_GeneratePrompt("Has the patient ever recieved radiation therapy? Do not fabricate any details, and only base your responses on the clinical data provided."))[1].output
GuiControl,, OllamaOutput, %Ollama_Output%  ; Set the content of the Edit control to the clipboard
GuiControl,, PasteBin, %clipboard%  ; Set the content of the Edit control to the clipboard

Return

;Additional 

Epic_GeneratePrompt(Prompt){
Clipboard := ""

Loop, 5 { 
	WinActivate, Hyperspace
	
	; Retrieve the position and size of the target window
	WinGetPos, X, Y, Width, Height, Hyperspace

	; Calculate the coordinates of the bottom right corner
	TargetX := X + Width - 120
	TargetY := Y + Height - 120
	
	;Msgbox % X . ", " Y . ", " Width . ", " Height . ", " TargetX . ", " TargetY
	
	Send, !{c}
	MouseMove, TargetX, TargetY, 0  ; '0' for immediate movement
	Sleep 50
	Send, {Click Right}
	Sleep 100
	;Send, {Click %TargetX% %TargetY% Right}
	Send, {Up 5}
	Send, {Enter}
	Sleep 1000

	try {
		If (Clipboard != "")
			Break
	} 
}


Tooltip 1

Clincal_Data := String2JsonString(Clipboard)

FullCommand := Clincal_Data . "###\n" . Prompt

jsonobj := "{""text"":""" FullCommand """}"

Url := "http://127.0.0.0.1:11434/"



; Create the HTTP request and set headers
http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
; Set timeouts (in milliseconds)
; The parameters are: ResolveTimeout, ConnectTimeout, SendTimeout, and ReceiveTimeout
http.SetTimeouts(5000, 5000, 10000, 1200000) ; For example, here it's set to 5 seconds for resolve, 5 seconds for connect, 10 seconds for send, and 30 seconds for receive

http.Open("POST", Url, false)
http.SetRequestHeader("Content-Type", "application/json")

Tooltip 2
; Send the request with the JSON body
http.Send(jsonobj)

Tooltip 3

; Optionally handle the response
Response := "[" . http.ResponseText . "]"
Response := StrReplace(Response, "`n", "")
Response := StrReplace(Response, "{  """, "{""")
;ResponseObj := JSON.Load(Response)
;Msgbox % ResponseObj[1].output
;Msgbox % IsObject(ResponseObj)
;Msgbox % ResponseObj.MaxIndex()
;clipboard := Response

*/

Tooltip 4
Return Response
}



String2JsonString(tempstr){
; Escape special characters for JSON
tempstr := StrReplace(tempstr, "\", "\\")
tempstr := StrReplace(tempstr, """", "\""")
tempstr := StrReplace(tempstr, "`n", "\n")
tempstr := StrReplace(tempstr, "`r", "\r")
tempstr := StrReplace(tempstr, "`t", "\t")
; Replace non-ASCII characters with Unicode escape sequences
; Loop over each character in the string
Loop, Parse, tempstr
{
    char := SubStr(A_LoopField, 1, 1)
    if (Asc(char) > 127) ; Non-ASCII character
    {
        unicodeChar := Format("u{1:04X}", Asc(char))
        tempstr := StrReplace(tempstr, char, unicodeChar, All)
    }
}

Return tempstr
}