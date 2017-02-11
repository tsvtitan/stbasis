@echo off
cls
if not exist History.txt cd ..

set tool=C6

rem *** Setup compilation
call Build\_compileSetup.bat
if "%cmpBCB6%"=="" goto :NoTool
set cmp=%cmpBCB6%
set def_bpl=%bplBCB6%
set def_dcp=%dcpBCB6%
set SYNEDIT_DCU=%syneditBCB6_dcu%
set SYNEDIT_DCP=%syneditBCB6_dcp%
if "%SYNEDIT_DCP%"=="" goto :NoSynEdit
  set SYNEDIT_BPI=%syneditBCB6_pak%.bpi
:NoSynEdit
set INDY_DCU=%indyBCB6_dcu%
set INDY_DCP=%indyBCB6_dcp%
if "%INDY_DCP%"=="" goto :NoIndy
  set DAADMONITOR=daADMoniBase.obj daADMoniIndyBase.obj daADMoniIndyClient.obj daADMoniIndyServer.obj daADMoniCustom.obj daADStanTracer.obj daADMoniFlatFile.obj 
  set INDY_BPI=%indyBCB6_pak%.bpi
:NoIndy

rem *** Compile C++Builder binaries
mkdir sourceforcompile
copy source\DAADENV.INC sourceforcompile\*.*
copy source\daAD.inc sourceforcompile\*.*
copy Pack\daADComIC6.res sourceforcompile\*.*
copy source\daADComIC6.cpp sourceforcompile\*.*
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

copy Pack\daADPhysC6.res sourceforcompile\*.*
copy source\daADPhysC6.cpp sourceforcompile\*.*
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

copy Pack\daADPhysODBCC6.res sourceforcompile\*.*
copy source\daADPhysODBCC6.cpp sourceforcompile\*.*
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

copy Pack\daADPhysMSAccC6.res sourceforcompile\*.*
copy source\daADPhysMSAccC6.cpp sourceforcompile\*.*
copy source\daADPhysMSAcc.pas sourceforcompile\*.*

set pck=daADPhysMSAcc
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysMSSQLC6.res sourceforcompile\*.*
copy source\daADPhysMSSQLC6.cpp sourceforcompile\*.*
copy source\daADPhysMSSQL.pas sourceforcompile\*.*

set pck=daADPhysMSSQL
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysDb2C6.res sourceforcompile\*.*
copy source\daADPhysDb2C6.cpp sourceforcompile\*.*
copy source\daADPhysDb2.pas sourceforcompile\*.*

set pck=daADPhysDb2
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysASAC6.res sourceforcompile\*.*
copy source\daADPhysASAC6.cpp sourceforcompile\*.*
copy source\daADPhysASA.pas sourceforcompile\*.*

set pck=daADPhysASA
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysADSC6.res sourceforcompile\*.*
copy source\daADPhysADSC6.cpp sourceforcompile\*.*
copy source\daADPhysADS.pas sourceforcompile\*.*

set pck=daADPhysADS
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysMySQLC6.res sourceforcompile\*.*
copy source\daADPhysMySQLC6.cpp sourceforcompile\*.*
copy source\daADPhysMySQL.pas sourceforcompile\*.*
copy source\daADPhysMySQLCli.pas sourceforcompile\*.*
copy source\daADPhysMySQLWrapper.pas sourceforcompile\*.*

set pck=daADPhysMySQL
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysOraclC6.res sourceforcompile\*.*
copy source\daADPhysOraclC6.cpp sourceforcompile\*.*
copy source\daADPhysOracl.pas sourceforcompile\*.*
copy source\daADPhysOraclCli.pas sourceforcompile\*.*
copy source\daADPhysOraclWrapper.pas sourceforcompile\*.*

set pck=daADPhysOracl
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADCompC6.res sourceforcompile\*.*
copy source\daADCompC6.cpp sourceforcompile\*.*
copy source\daADCompClient.pas sourceforcompile\*.*
copy source\daADCompDataMove.pas sourceforcompile\*.*
copy source\daADStanSQLParser.pas sourceforcompile\*.*

set pck=daADComp
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADPhysDBExpC6.res sourceforcompile\*.*
copy source\daADPhysDBExpC6.cpp sourceforcompile\*.*
copy source\daADPhysDBExp.pas sourceforcompile\*.*
copy source\daADPhysDBExpMeta.pas sourceforcompile\*.*
copy source\daADPhysDBExpReg.pas sourceforcompile\*.*

set pck=daADPhysDBExp
call Build\_compileBCB.bat 

del /S /Q sourceforcompile\*.pas
del /S /Q sourceforcompile\*.cpp
del /S /Q sourceforcompile\*.res

copy Pack\daADGUIxFormsC6.res sourceforcompile\*.*
copy source\daADGUIxFormsC6.cpp sourceforcompile\*.*
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

copy Pack\daADDclC6.res sourceforcompile\*.*
copy source\daADDclC6.cpp sourceforcompile\*.*
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
echo C++Builder 6 is not installed

:done
Build\_compileDone.bat
