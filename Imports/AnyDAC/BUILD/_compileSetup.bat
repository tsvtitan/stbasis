set prevTemp=%temp%
set prevTmp=%tmp%
set temp=c:\
set tmp=c:\

rem *** Create _compileEnv.bat file, which setup Tool Bin directory
set integr=
if not exist Build\_noIndy.txt set integr=%integr% -N
if not exist Build\_noSynedit.txt set integr=%integr% -S
Build\daSetEnv.exe -FBuild\_compileEnv.bat -ISource\daADEnv.inc %integr% -D2 -D3 -D4 -D5 -D6 -D7 -D8 -D9 -D10 -D11 -BCB2 -BCB3 -BCB4 -BCB5 -BCB6 -BCB7
call Build\_compileEnv.bat

rem *** Create binary directories
if not exist Lib md Lib
if not exist Lib\%tool% md Lib\%tool%
set libd=Lib\%tool%

rem *** Remove all binaries
if exist %libd%\*.dcu del /S /Q %libd%\*.dcu
if exist %libd%\*.bpl del /S /Q %libd%\*.bpl
if exist %libd%\*.dcp del /S /Q %libd%\*.dcp
if exist %libd%\*.bpi del /S /Q %libd%\*.bpi
if exist %libd%\*.bpl del /S /Q %libd%\*.bpl
if exist %libd%\*.hpp del /S /Q %libd%\*.hpp
if exist %libd%\*.lib del /S /Q %libd%\*.lib
if exist %libd%\*.obj del /S /Q %libd%\*.obj
if exist Source\*.dcu del /S /Q Source\*.dcu
if exist Source\*.bpl del /S /Q Source\*.bpl
if exist Source\*.dcp del /S /Q Source\*.dcp
if exist Source\*.bpi del /S /Q Source\*.bpi
if exist Source\*.bpl del /S /Q Source\*.bpl
if exist Source\*.hpp del /S /Q Source\*.hpp
if exist Source\*.lib del /S /Q Source\*.lib
if exist Source\*.obj del /S /Q Source\*.obj

rem *** Copy common for all packages files
copy Source\*.dfm %libd%
copy Source\*.res %libd%
