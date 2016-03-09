#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#InstallKeybdHook
#Include scripts\PixelChecksum.ahk
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
CoordMode, Tooltip, Screen

Global cfgfile
Global d3class

cfgfile=buttoncoords.ini
d3class=Monk

#If WinActive("Diablo III")
SC00C::GoTo,ChangeSpec

ChangeSpec:
  ChangeSpecPrimarys("GUIb1","defensive","SkillsSubTabB14","SkillsSubTabB26")
  ChangeSpecPrimarys("GUIb2","mantras","SkillsSubTabB12","SkillsSubTabB23")
  ChangeSpecPrimarys("GUIb3","defensive","SkillsSubTabB11","SkillsSubTabB25")
  ChangeSpecPrimarys("GUIb4","focus","SkillsSubTabB14","SkillsSubTabB24")
  ChangeSpecPrimarys("GUIb5","primary","SkillsSubTabB13","SkillsSubTabB23")
  ChangeSpecPrimarys("GUIb6","focus","SkillsSubTabB11","SkillsSubTabB23")
Return

ChangeSpecPrimarys(guibutton,cat,spell,rune)
{
  ClickButton(guibutton,"right")
  Loop, 6
  {
    wai:=WhereAmI()
    If (wai==cat)
    {
      ClickButton(spell,"left")
      ClickButton(rune,"left")
      ClickButton("SkillsSubTabBAccept","left")
      Break
    }
    ClickButton("SkillsSubTabARight","left")
  }
}

ClickButton(b,lor)
{
  IniRead,x,%cfgfile%,%b%,x
  IniRead,y,%cfgfile%,%b%,y
  MouseClick,%lor%,x,y
  Sleep,300
}

WhereAmI()
{
  IniRead, res, %cfgfile%, %d3class%SkillCat
  StringSplit, SecArray, res, `n,
  cs:=PixelChecksum(830,100,200,30)
  Loop, %secArray0%
  {
      sec := SecArray%a_index%
      StringSplit,ChkSum,sec,=,
      If (ChkSum2 == cs)
        Break
  }
  Return %ChkSum1%
}