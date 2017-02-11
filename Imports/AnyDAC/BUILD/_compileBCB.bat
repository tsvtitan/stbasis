rem *** Subroutine to build C++Builder binaries
set pack=%pck%%tool%

"%cmp%\bin\bpr2mak.exe" Pack\%pack%.bpk
"%cmp%\bin\make.exe" -f Pack\%pack%.mak
if errorlevel 1 pause

if not "%pck%"=="daADDcl" goto :RTP
  move %pack%.bpl %libd%
  goto :ETC
:RTP
  move %pack%.bpl %windir%\system32
:ETC
move %pack%.bpi %libd%
move %pack%.lib %libd%
move sourceforcompile\*.hpp %libd%
move sourceforcompile\*.obj %libd%
move *.obj %libd%
move sourceforcompile\*.dcu %libd%

if exist pack\*.mak del /S /Q pack\*.mak
if exist *.tds del /S /Q *.tds
