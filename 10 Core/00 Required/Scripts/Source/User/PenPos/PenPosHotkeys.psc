Scriptname PenPos:PenPosHotkeys extends ObjectReference

; custom scripting by niston for Ulfberto - MIT license applies
;
;
; Copyright 2022 by niston
;
; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

; require SAM api
Import SAF

; public properties
String Property PluginName = "PenPos.esp" Auto Const
{Name of plugin containing the script implementation }

; constants
String PP_ADJUSTMENTNAME = "PenPosAdjustment" Const
Float PP_ADJUSTMENTSTEP_DEFAULT = 0.1 Const
Int idAdjustmentStepGlobal = 0x1 Const

; public functions
Function HKPenis1Inc()
	Debug.Trace(Self + ": DEBUG - HKPenis1Inc() called.")
	
	; this setting is inverted (- == up, + == down)
	SetPPAdjust("Penis_01", -GetAdjustmentStep())
EndFunction

Function HKPenis1Dec()
	Debug.Trace(Self + ": DEBUG - HKPenis1Dec() called.")
	
	; this setting is inverted (- == up, + == down)
	SetPPAdjust("Penis_01", GetAdjustmentStep())
EndFunction

Function HKBalls1Inc()
	Debug.Trace(Self + ": DEBUG - HKBallsInc() called.")
	
	; this setting is inverted (- == up, + == down)
	SetPPAdjust("Penis_Balls_01", -GetAdjustmentStep())
EndFunction

Function HKBalls1Dec()
	Debug.Trace(Self + ": DEBUG - HKBallsDec() called.")
	
	; this setting is inverted (- == up, + == down)
	SetPPAdjust("Penis_Balls_01", GetAdjustmentStep())
EndFunction

Function HKPenisOffsetInc()
	Debug.Trace(Self + ": DEBUG - HKPenisOffsetInc() called.")
	
	; this setting is inverted (- == up, + == down)
	SetPPAdjust("Penis_Offset", -GetAdjustmentStep())
EndFunction

Function HKPenisOffsetDec()
	Debug.Trace(Self + ": DEBUG - HKPenisOffsetDec() called.")
	
	; this setting is inverted (- == up, + == down)
	SetPPAdjust("Penis_Offset", GetAdjustmentStep())
EndFunction

Function HKClearAdjustments()
	Debug.Trace(Self + ": DEBUG - HKClearAdjustments() called.")
	
	ClearPPAdjust()	
EndFunction

; private functions
Actor Function GetSelectedActor()
	; get console selected ref
	Actor actSelected = Game.GetCurrentConsoleRef() as Actor
	If (actSelected == none)
		Debug.Notification("PenPos: No actor selected.")
		Return none
	EndIf
	Return actSelected
EndFunction

Function SetPPAdjust(String boneName, Float adjustmentValue)
	Debug.Trace(Self + ": DEBUG - SetPPAdjust(" + boneName + ", " + adjustmentValue + ") called.")
	
	Actor actSelected = GetSelectedActor()
	If (actSelected != none)
		; alter adjustment for boneName on selected actor
		AlterTransform(actSelected, boneName, adjustmentValue)			
	EndIf	
EndFunction

Function ClearPPAdjust()
	Debug.Trace(Self + ": DEBUG - ClearPPAdjust() called.")
	
	Actor actSelected = GetSelectedActor()
	If (actSelected != none)
		; remove adjustment from selected actor
		Int adjustmentHandle = GetPenPosActorAdjustment(actSelected)
		
		ClearTransform(actSelected, "Penis_01")
		ClearTransform(actSelected, "Penis_Balls_01")
		ClearTransform(actSelected, "Penis_Offset")
		RemoveAdjustment(actSelected, adjustmentHandle)
		
	EndIf
EndFunction

Function ClearTransform(ObjectReference refActor, String boneName)
	Debug.Trace(Self + ": DEBUG - ClearAdjustment(" + refActor + ", " + boneName + ") called.")
	
	; get ppos adjustment for actor
	Int ppAdjustHandle = GetPenPosActorAdjustment(refActor)

	; get current transform for bone
	Transform boneTransform = GetNodeTransform(refActor, boneName, ppAdjustHandle)
	If (!boneTransform)
		Debug.Trace(Self + ": ERROR - GetNodeTransform(" + refActor + ", " + boneName + ", " + ppAdjustHandle + ") returned none.")
		Return
	EndIf
	
	Debug.Trace(Self + ": DEBUG - Transform.Roll value for bone (" + boneName + ") on actor (" + refActor + ") currently is (" + boneTransform.Roll + ").")
	
	; add zValue to Roll on transform
	boneTransform.Roll = 0
	
	Debug.Trace(Self + ": DEBUG - New Transform.Roll value for bone (" + boneName + ") on actor (" + refActor + ") is (" + boneTransform.Roll + ").")
	
	; set adjusted bone transform
	SetNodeTransform(refActor, boneName, ppAdjustHandle, boneTransform)	
EndFunction

Function AlterTransform(ObjectReference refActor, String boneName, Float zValue)
	Debug.Trace(Self + ": DEBUG - AlterTransform(" + refActor + ", " + boneName + ", " + zValue + ") called.")
	
	; get ppos adjustment for actor
	Int ppAdjustHandle = GetPenPosActorAdjustment(refActor)

	; get current transform for bone
	Transform boneTransform = GetNodeTransform(refActor, boneName, ppAdjustHandle)
	If (!boneTransform)
		Debug.Trace(Self + ": ERROR - GetNodeTransform(" + refActor + ", " + boneName + ", " + ppAdjustHandle + ") returned none.")
		Return
	EndIf
	
	Debug.Trace(Self + ": DEBUG - Transform.Roll value for bone (" + boneName + ") on actor (" + refActor + ") currently is (" + boneTransform.Roll + ").")
	
	; add zValue to Roll on transform
	boneTransform.Roll += zValue
	
	Debug.Trace(Self + ": DEBUG - New Transform.Roll value for bone (" + boneName + ") on actor (" + refActor + ") is (" + boneTransform.Roll + ").")
	
	; set adjusted bone transform
	SetNodeTransform(refActor, boneName, ppAdjustHandle, boneTransform)	
EndFunction

Int Function GetPenPosActorAdjustment(ObjectReference refActor)	
	Int[] adjustmentHandles = GetAdjustments(refActor, PluginName)
	Int i = 0
	While (i < adjustmentHandles.Length)
		String adjustmentName = GetAdjustmentName(refActor, adjustmentHandles[i])
		If (adjustmentName == PP_ADJUSTMENTNAME)
			; found it, return handle
			Debug.Trace(Self +": DEBUG - Found adjustment (" + PP_ADJUSTMENTNAME + ") on actor (" + refActor + "), handle is (" + adjustmentHandles[i] + ").")
			Return adjustmentHandles[i]
		EndIf
		i += 1
	EndWhile
	
	Debug.Trace(Self + ": DEBUG - Adjustment (" + PP_ADJUSTMENTNAME + ") not found on actor (" + refActor + "); Creating new...")
	
	; not found, create new
	Int ppAdjustHandle = -1
	ppAdjustHandle = CreateAdjustment(refActor, PP_ADJUSTMENTNAME, PluginName)
	; make sure it's created
	If (ppAdjustHandle < 0)
		Debug.Trace(Self + ": ERROR - AlterTransform failed: CreateAdjustment(" + refActor + ", " + PP_ADJUSTMENTNAME + ", " + PluginName + ") returned < 0.")
	EndIf
	
	Debug.Trace(Self + ": DEBUG - Adjustment (" + PP_ADJUSTMENTNAME + ") created on actor (" + refActor + "); Handle is (" + ppAdjustHandle + ").")
	
	Return ppAdjustHandle
EndFunction

Float Function GetAdjustmentStep()
	; obtain adjustment step global
	GlobalVariable glbAdjustmentStep = Game.GetFormFromFile(idAdjustmentStepGlobal, PluginName) as GlobalVariable
	If (glbAdjustmentStep == none)
		Debug.Trace(Self + ": GetAdjustmentStep() failed - glbAdjustmentStep is none.")
		Return 0
	EndIf
	
	; get adjustment step value from global, apply default if zero
	Float fAdjustmentStep = glbAdjustmentStep.GetValue()
	If (fAdjustmentStep == 0)
		fAdjustmentStep = PP_ADJUSTMENTSTEP_DEFAULT
		glbAdjustmentStep.SetValue(fAdjustmentStep)
	EndIf
	Return fAdjustmentStep
EndFunction