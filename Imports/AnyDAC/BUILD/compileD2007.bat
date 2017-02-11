@echo off
cls
if not exist History.txt cd ..

set tool=D11

rem *** Setup compilation
call Build\_compileSetup.bat
if "%cmpD11%"=="" goto :NoTool
set cmp=%cmpD11%
set def_bpl=%bplD11%
set def_dcp=%dcpD11%
set indy_dcu=%indyD11_dcu%
set indy_dcp=%indyD11_dcp%
set synedit_dcu=%syneditD11_dcu%
set synedit_dcp=%syneditD11_dcp%

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

set pck=daADPhysTDBX
call Build\_compileDelphi.bat

set pck=daADComp
call Build\_compileDelphi.bat

set pck=daADGUIxForms
call Build\_compileDelphi.bat

set pck=daADDcl
call Build\_compileDelphi.bat

goto :done

:NoTool
echo Delphi 2007 is not installed

:done
Build\_compileDone.bat
