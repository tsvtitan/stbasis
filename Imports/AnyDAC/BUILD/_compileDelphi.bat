rem *** Subroutine to build Delphi binaries
set pack=PACK\%pck%%tool%
set bpl=.\%libd%\%pck%%tool%.bpl

if "%tool%"=="D11" goto :D10
if "%tool%"=="D10" goto :D10
  "%cmp%\bin\dcc32.exe" -B -E.\%libd% -N.\%libd% -LE.\%libd% -LN.\%libd% -U.\%libd%;Source;"%indy_dcu%";"%indy_dcp%";"%synedit_dcu%";"%synedit_dcp%" -ISource -RSource %pack%.dpk
:D10
  "%cmp%\bin\dcc32.exe" -B -E.\%libd% -N.\%libd% -LE.\%libd% -LN.\%libd% -NB.\%libd% -NO.\%libd% -U.\%libd%;Source;"%indy_dcu%";"%indy_dcp%";"%synedit_dcu%";"%synedit_dcp%" -ISource -RSource %pack%.dpk
:CONT
if errorlevel 1 pause

if not "%pck%"=="daADDcl" move %bpl% %windir%\system32
