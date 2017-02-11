@echo off
if not exist History.txt cd ..
set integr=
if not exist Build\_noIndy.txt set integr=%integr% -N
if not exist Build\_noSynedit.txt set integr=%integr% -S
Build\daSetEnv.exe -FBuild\_compileEnv.bat -ISource\daADEnv.inc %integr% -D2 -D3 -D4 -D5 -D6 -D7 -D8 -D9 -D10 -D11 -BCB2 -BCB3 -BCB4 -BCB5 -BCB6 -BCB7
