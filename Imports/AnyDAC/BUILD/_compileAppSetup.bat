rem *** Find appropriate compiler

Build\daSetEnv.exe -D11 -FBuild\_compileEnv.bat
if not exist Build\_compileEnv.bat goto :D10
call Build\_compileEnv.bat
set cmp=%cmpD11%
set tool=D11
if not "%cmp%"=="" goto :EOF

:D10
Build\daSetEnv.exe -D10 -FBuild\_compileEnv.bat
if not exist Build\_compileEnv.bat goto :D9
call Build\_compileEnv.bat
set cmp=%cmpD10%
set tool=D10
if not "%cmp%"=="" goto :EOF

:D9
Build\daSetEnv.exe -D9 -FBuild\_compileEnv.bat
if not exist Build\_compileEnv.bat goto :D7
call Build\_compileEnv.bat
set cmp=%cmpD9%
set tool=D9
if not "%cmp%"=="" goto :EOF

:D7
Build\daSetEnv.exe -D7 -FBuild\_compileEnv.bat
if not exist Build\_compileEnv.bat goto :D6
call Build\_compileEnv.bat
set cmp=%cmpD7%
set tool=D7
if not "%cmp%"=="" goto :EOF

:D6
Build\daSetEnv.exe -D6 -FBuild\_compileEnv.bat
if not exist Build\_compileEnv.bat goto :D5
call Build\_compileEnv.bat
set cmp=%cmpD6%
set tool=D6
if not "%cmp%"=="" goto :EOF

:D5
Build\daSetEnv.exe -D5 -FBuild\_compileEnv.bat
if not exist Build\_compileEnv.bat goto :Bad
call Build\_compileEnv.bat
set cmp=%cmpD5%
set tool=D5
if not "%cmp%"=="" goto :EOF

:Bad
echo =========================================================
echo Cant build AnyDAC tool projects !
echo You must have installed D5, D6, D7, D2005, D2006 or D2007
echo =========================================================
pause
exit
