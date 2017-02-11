@echo off
cls
if not exist History.txt cd ..

set tool=C5

rem *** Setup compilation
call Build\_compileSetup.bat
if "%cmpBCB5%"=="" goto :NoTool
set cmp=%cmpBCB5%
set def_bpl=%bplBCB5%
set def_dcp=%dcpBCB5%
set SYNEDIT_DCU=%syneditBCB5_dcu%
set SYNEDIT_DCP=%syneditBCB5_dcp%
if "%SYNEDIT_DCP%"=="" goto :NoSynEdit
  set SYNEDIT_BPI=%syneditBCB5_pak%.bpi
:NoSynEdit
set INDY_DCU=%indyBCB5_dcu%
set INDY_DCP=%indyBCB5_dcp%
if "%INDY_DCP%"=="" goto :NoIndy
  set DAADMONITOR=daADMoniBase.obj daADMoniIndyBase.obj daADMoniIndyClient.obj daADMoniIndyServer.obj daADMoniCustom.obj daADStanTracer.obj daADMoniFlatFile.obj 
  set INDY_BPI=%indyBCB5_pak%.bpi
:NoIndy

rem *** Compile C++Builder binaries
mkdir sourceforcompile
copy source\DAADENV.INC sourceforcompile\*.*
copy source\daAD.inc sourceforcompile\*.*
copy Pack\daADComIC5.res sourceforcompile\*.*
copy source\daADComIC5.cpp sourceforcompile\*.*
copy source\daADDAptColumn.pas sourceforcompile\*.*
copy source\daADDAptIntf.pas sourceforcompile\*.*
copy source\daADDatSManager.pas sourceforcompile\*.*
copy source\daADGUIxIntf.pas sourceforcompile\*.*
copy source\daADPhysIntf.pas  sourceforcompile\*.*
copy source\daADStanConst.pas sourceforcompile\*.*
copy source\daADStanError.pas sourceforcompile\*.*
copy source\daADStanFactory.pas sourceforcompile\*.*
copy source\daADStanFCCompareTextShaUnit.pas  sourceforcompile\*.*
copy source\daADStanFCCPUID.pas sourceforcompile\*.*
copy source\daADStanFCFillCharDKCUnit.pas sourceforcompile\*.*
copy source\daADStanFCFillCharUnit.pas sourceforcompile\*.*
copy source\daADStanFCMoveJOHUnit4.pas sourceforcompile\*.*
copy source\daADStanIntf.pas sourceforcompile\*.*
copy source\daADStanOption.pas sourceforcompile\*.*
copy source\daADStanParam.pas sourceforcompile\*.*
copy source\daADStanResStrs.pas sourceforcompile\*.*
copy source\daADStanUtil.pas sourceforcompile\*.*
copy source\daADStanAsync.pas sourceforcompile\*.*
copy source\daADStanDef.pas sourceforcompile\*.*
copy source\daADStanExpr.pas sourceforcompile\*.*
copy source\daADStanPool.pas sourceforcompile\*.*
copy source\daADStanRegExpr.pas sourceforcompile\*.*
copy source\daADCompDataSet.pas sourceforcompile\*.*
copy source\daADGUIxFormsWait.pas sourceforcompile\*.*

set pck=daADComI
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysC5.res sourceforcompile\*.*
copy source\daADPhysC5.cpp sourceforcompile\*.*
copy source\daADPhysADSMeta.pas sourceforcompile\*.*
copy source\daADPhysASAMeta.pas sourceforcompile\*.*
copy source\daADPhysOraclMeta.pas sourceforcompile\*.*
copy source\daADPhysCmdGenerator.pas sourceforcompile\*.*
copy source\daADPhysCmdPreprocessor.pas sourceforcompile\*.*
copy source\daADPhysConnMeta.pas sourceforcompile\*.*
copy source\daADPhysDb2Meta.pas sourceforcompile\*.*
copy source\daADPhysManager.pas sourceforcompile\*.*
copy source\daADPhysMSAccMeta.pas sourceforcompile\*.*
copy source\daADPhysMSSQLMeta.pas sourceforcompile\*.*
copy source\daADPhysMySQLMeta.pas sourceforcompile\*.*
copy source\daADDAptmanager.pas sourceforcompile\*.*
copy source\daADPhysScript.pas sourceforcompile\*.*
copy source\daADPhysScriptCommands.pas sourceforcompile\*.*

if "%INDY_DCP%"=="" goto :NoCopyMon
copy source\daADMoni*.pas sourceforcompile\*.*
copy source\daADStanTracer.pas sourceforcompile\*.*

:NoCopyMon

set pck=daADPhys
call Build\_compileBCB.bat 
del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysODBCC5.res sourceforcompile\*.*
copy source\daADPhysODBCC5.cpp sourceforcompile\*.*
copy source\daADPhysODBCCli.pas sourceforcompile\*.*
copy source\daADPhysODBCWrapper.pas sourceforcompile\*.*
copy source\daADPhysODBCMeta.pas sourceforcompile\*.*
copy source\daADPhysODBC.pas sourceforcompile\*.*
copy source\daADPhysODBCBase.pas sourceforcompile\*.*

set pck=daADPhysODBC
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysMSAccC5.res sourceforcompile\*.*
copy source\daADPhysMSAccC5.cpp sourceforcompile\*.*
copy source\daADPhysMSAcc.pas sourceforcompile\*.*

set pck=daADPhysMSAcc
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysMSSQLC5.res sourceforcompile\*.*
copy source\daADPhysMSSQLC5.cpp sourceforcompile\*.*
copy source\daADPhysMSSQL.pas sourceforcompile\*.*

set pck=daADPhysMSSQL
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res


copy Pack\daADPhysDb2C5.res sourceforcompile\*.*
copy source\daADPhysDb2C5.cpp sourceforcompile\*.*
copy source\daADPhysDb2.pas sourceforcompile\*.*

set pck=daADPhysDb2
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res


copy Pack\daADPhysASAC5.res sourceforcompile\*.*
copy source\daADPhysASAC5.cpp sourceforcompile\*.*
copy source\daADPhysASA.pas sourceforcompile\*.*

set pck=daADPhysASA
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res


copy Pack\daADPhysADSC5.res sourceforcompile\*.*
copy source\daADPhysADSC5.cpp sourceforcompile\*.*
copy source\daADPhysADS.pas sourceforcompile\*.*

set pck=daADPhysADS
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res


copy Pack\daADPhysMySQLC5.res sourceforcompile\*.*
copy source\daADPhysMySQLC5.cpp sourceforcompile\*.*
copy source\daADPhysMySQL.pas sourceforcompile\*.*
copy source\daADPhysMySQLCli.pas sourceforcompile\*.*
copy source\daADPhysMySQLWrapper.pas sourceforcompile\*.*

set pck=daADPhysMySQL
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res


copy Pack\daADPhysOraclC5.res sourceforcompile\*.*
copy source\daADPhysOraclC5.cpp sourceforcompile\*.*
copy source\daADPhysOracl.pas sourceforcompile\*.*
copy source\daADPhysOraclCli.pas sourceforcompile\*.*
copy source\daADPhysOraclWrapper.pas sourceforcompile\*.*

set pck=daADPhysOracl
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADCompC5.res sourceforcompile\*.*
copy source\daADCompC5.cpp sourceforcompile\*.*
copy source\daADCompClient.pas sourceforcompile\*.*
copy source\daADCompDataMove.pas sourceforcompile\*.*
copy source\daADStanSQLParser.pas sourceforcompile\*.*

set pck=daADComp
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADGUIxFormsC5.res sourceforcompile\*.*
copy source\daADGUIxFormsC5.cpp sourceforcompile\*.*
copy source\daADGUIxFormsUtil.pas sourceforcompile\*.*
copy source\daADGUIxFormsControls.pas sourceforcompile\*.*
copy source\daADGUIxFormsfAbout.pas sourceforcompile\*.*
copy source\daADGUIxFormsfAsync.pas sourceforcompile\*.*
copy source\daADGUIxFormsfConnEdit.pas sourceforcompile\*.*
copy source\daADGUIxFormsfError.pas sourceforcompile\*.*
copy source\daADGUIxFormsfFetchOptions.pas sourceforcompile\*.*
copy source\daADGUIxFormsfFormatOptions.pas sourceforcompile\*.*
copy source\daADGUIxFormsfLogin.pas sourceforcompile\*.*
copy source\daADGUIxFormsfOptsBase.pas sourceforcompile\*.*
copy source\daADGUIxFormsfQBldr.pas sourceforcompile\*.*
copy source\daADGUIxFormsfQBldrConn.pas sourceforcompile\*.*
copy source\daADGUIxFormsfQBldrLink.pas sourceforcompile\*.*
copy source\daADGUIxFormsfQEdit.pas sourceforcompile\*.*
copy source\daADGUIxFormsfResourceOptions.pas sourceforcompile\*.*
copy source\daADGUIxFormsfUpdateOptions.pas sourceforcompile\*.*      
copy source\daADGUIxFormsfUSEdit.pas sourceforcompile\*.*      
copy source\daADGUIxFormsQBldr.pas sourceforcompile\*.*      
copy source\daADGUIxFormsQBldrCtrls.pas sourceforcompile\*.*      
copy source\*.dfm sourceforcompile\*.*      
copy source\*.res sourceforcompile\*.*      

set pck=daADGUIxForms
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res
del /S /Q sourceforcompile\*.dfm

copy Pack\daADDclC5.res sourceforcompile\*.*
copy source\daADDclC5.cpp sourceforcompile\*.*
copy source\daADCompReg.pas sourceforcompile\*.*
copy source\daADDcl.dcr sourceforcompile\*.*

set pck=daADDcl
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

del /S /Q sourceforcompile\*.*
rmdir sourceforcompile

goto :done

:NoTool
echo C++Builder 5 is not installed

:done
Build\_compileDone.bat
