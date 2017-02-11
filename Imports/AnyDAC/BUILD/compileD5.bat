@echo off
cls
if not exist History.txt cd ..

set tool=D5

rem *** Setup compilation
call Build\_compileSetup.bat
if "%cmpD5%"=="" goto :NoTool
set cmp=%cmpD5%
set def_bpl=%bplD5%
set def_dcp=%dcpD5%
set indy_dcu=%indyD5_dcu%
set indy_dcp=%indyD5_dcp%
set synedit_dcu=%syneditD5_dcu%
set synedit_dcp=%syneditD5_dcp%

rem *** Compile Delphi binaries
set pck=daADComI
call Build\_compileDelphi.bat 

set pck=daADPhys
call Build\_compileDelphi.bat

set pck=daADPhysODBC
call Build\_compileDelphi.bat

set pck=daADPhysMSAcc
call Build\_compileDelphi.bat

set pck=daADPhysMSSQL
call Build\_compileDelphi.bat

set pck=daADPhysDb2
call Build\_compileDelphi.bat

set pck=daADPhysASA
call Build\_compileDelphi.bat

set pck=daADPhysADS
call Build\_compileDelphi.bat

set pck=daADPhysMySQL
call Build\_compileDelphi.bat

set pck=daADPhysOracl
call Build\_compileDelphi.bat

set pck=daADComp
call Build\_compileDelphi.bat

set pck=daADGUIxForms
call Build\_compileDelphi.bat

set pck=daADDcl
call Build\_compileDelphi.bat

goto :done

:NoTool
echo Delphi 5 is not installed

:done
Build\_compileDone.bat
