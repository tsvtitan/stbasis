rem *** Subroutine to build AnyDAC application binary
cd %apppath%

if "%tool%"=="D11" goto :D9
if "%tool%"=="D10" goto :D9
if "%tool%"=="D9" goto :D9
  "%cmp%\bin\dcc32.exe" -U..\..\Source;"%cmp%\lib" -I..\..\Source -R"%cmp%\lib" %1 %2 %3 %4 %5 %appname%.dpr
  goto :Done
:D9
  "%cmp%\bin\dcc32.exe" -U..\..\Source;"%cmp%\lib";"%cmp%\lib\INDY10" -I..\..\Source -R"%cmp%\lib" %1 %2 %3 %4 %5 %appname%.dpr
:Done

if errorlevel 1 pause
cd ..\..
