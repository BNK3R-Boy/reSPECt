/*   __    __  __          __ __       __    __                 _       __                   
    / /_  / /_/ /_____  _ / // /____ _/ /_  / /________________(_)___  / /_ ____  _______
   / __ \/ __/ __/ __ \(_) // // __ '/ __ \/ //_/ ___/ ___/ __/ / __ \/ __// __ \/ __/ _ \
  / / / / /_/ /_/ /_/ / / // // /_/ / / / / ,< (__  ) /__/ / / / /_/ / /__/ /_/ / / / // / 
 /_/ /_/\__/\__/ .___(_) // / \__,_/_/ /_/_/|_/____/\___/_/ /_/ .___/\__(_)____/_/  \__ /  
              /_/     /_//_/                                 /_/                   (___/   
 
 http://ahkscript.org/boards/viewtopic.php?&t=4431
__________________________________________________________________________________________
*/

PixelCheckSum( X, Y, W, H, Title := "" ) { ;               By SKAN,   http://goo.gl/X5dfvn
;                                                          CD:08/Jun/2009 | MD:01/Sep/2014

  Static DIBSECTION, SRCCOPY := 0x00CC0020, CAPTUREBLT := 0x40000000, BPP := 32
  Local hWnd, hDC, mDC, hBM, oBM, nSize, pBITMAPINFOHEADER, ppvBits := 0
  
  If not VarSetCapacity( DIBSECTION )
         VarSetCapacity( DIBSECTION, 104, 0 ) 
  
  pBITMAPINFOHEADER := &DIBSECTION + ( A_PtrSize = 4 ? 24 : 32 )
  
  NumPut(  40, pBITMAPINFOHEADER +  0, "UInt"   ) 
  NumPut(   W, pBITMAPINFOHEADER +  4, "UInt"   )
  NumPut(   H, pBITMAPINFOHEADER +  8, "UInt"   )
  NumPut(   1, pBITMAPINFOHEADER + 12, "UShort" )
  NumPut( BPP, pBITMAPINFOHEADER + 14, "UShort" )

  hWnd  := WinExist( Title )
  hDC   := DllCall( "GetDC", "Ptr",hWnd, "UPtr" )
  mDC   := DllCall( "CreateCompatibleDC", UInt,hDC, "UPtr" )

  hBM   := DllCall( "CreateDIBSection", "Ptr", mDC, "Ptr", pBITMAPINFOHEADER, "Int",0
                                      , "PtrP",ppvBits, "Ptr",0, "Int",0, "UPtr" )
  
  oBM   := DllCall( "SelectObject", "Ptr",mDC, "Ptr",hBM, "UPtr" )
  
  DllCall( "BitBlt", "Ptr",mDC, "Int",0, "Int",0, "Int",W, "Int",H, "Ptr",hDC
                   , "Int",X, "Int",Y, "UInt",SRCCOPY | CAPTUREBLT )

  DllCall( "SelectObject", "Ptr",mDC, "Ptr",oBM )
  DllCall( "DeleteDC",  "Ptr",mDC )
  DllCall( "ReleaseDC", "Ptr",hWnd, "Ptr",hDC )

  DllCall( "GetObject", "Ptr",hBM, "Int",( A_PtrSize = 4 ? 84 : 104 ), "Ptr",&DIBSECTION )
  nSize := NumGet( pBITMAPINFOHEADER + 20, "UInt" ) 
  
Return DllCall( "NTDLL\RtlComputeCrc32", "UInt",0, "Ptr",ppvBits, "UInt",nSize, "UInt" )
     , DllCall( "DeleteObject", "Ptr",hBM )    
}

/*
; Example - Wait for a Screen Region to change

ChkSum := PixelChecksum( 0,0,32,32 )

While % ( ChkSum = PixelChecksum( 0,0,32,32 ) )
   Sleep, 100
MsgBox, Screen Region Change Detected!
*/
