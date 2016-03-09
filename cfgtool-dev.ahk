#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#Include scripts\PixelChecksum.ahk
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
CoordMode, Tooltip, Screen

Global cfgfile
cfgfile=buttoncoords.ini

!LButton::GoTo,RecordButtonPosi
+LButton::GoTo,RecordSpell

RecordButtonPosi:
  MouseGetPos, mx, my

  InputBox, OutputVar, Config, Posi?
  If !ErrorLevel
  {
      IniWrite, %mx%, %cfgfile%, %OutputVar%, x
      IniWrite, %my%, %cfgfile%, %OutputVar%, y
  }
Return

RecordSpell:
  ChkSum := PixelChecksum(830,100,200,30)

  InputBox, OutputVar, Config, Skill Cat?
  If !ErrorLevel
  {
      IniWrite, %ChkSum%, %cfgfile%, SkillCat, %OutputVar%
  }
Return