@echo off
cls
if not exist History.txt cd ..

set tool=D10

rem *** Setup compilation
call Build\_compileSetup.bat
if "%cmpD10%"=="" goto :NoTool
set cmp=%cmpD10%
set def_bpl=%bplD10%
set def_dcp=%dcpD10%
set indy_dcu=%indyD10_dcu%
set indy_dcp=%indyD10_dcp%
set synedit_dcu=%syneditD10_dcu%
set synedit_dcp=%syneditD10_dcp%

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

set pck=daADPhysDBExp
call Build\_compileDelphi.bat

set pck=daADComp
call Build\_compileDelphi.bat

set pck=daADGUIxForms
call Build\_compileDelphi.bat

set pck=daADDcl
call Build\_compileDelphi.bat

goto :done

:NoTool
echo Delphi 2006 is not installed

:done
Build\_compileDone.bat
