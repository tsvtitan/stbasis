{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - dataset and test registration unit                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedRegDBOra;

interface


implementation

uses
  ADSpeedBase,
  ADSpeedBaseDB,
  ADSpeedDBTests,
  ADSpeedBDE,
  ADSpeedSQLDirect,
  ADSpeedNCOCI8,
  ADSpeedDOA,
  ADSpeedODAC,
{$IFDEF AnyDAC_D6}
  ADSpeedDbExpr,
{$ENDIF}
  ADSpeedAD,
  ADSpeedADO,
  ADSpeedODBC;

var
  ADSpeedTestManager: TADSpeedTestManager = nil;

{---------------------------------------------------------------------------}
function Reg: TADSpeedTestManager;
begin
  if ADSpeedTestManager = nil then begin
    ADSpeedTestManager := TADSpeedDBTestManager.Create;
    // register tests
    ADSpeedTestManager.RegisterTest(TADSpeedFetch1WithBLOBSTest, 1000);
    ADSpeedTestManager.RegisterTest(TADSpeedFetch1WithoutBLOBSTest, 1000);
    ADSpeedTestManager.RegisterTest(TADSpeedFetchAllWithBLOBSTest, 1);
    ADSpeedTestManager.RegisterTest(TADSpeedFetchAllWithoutBLOBSTest, 1);
    ADSpeedTestManager.RegisterTest(TADSpeedExecSQLTest, 10000);
    ADSpeedTestManager.RegisterTest(TADSpeedExecArraySQLTest, 10000);
    // register DB's
    ADSpeedTestManager.RegisterDS(TADSpeedOraBDEQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedOraSQLDirectQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedNCOCI8Query);
    ADSpeedTestManager.RegisterDS(TADSpeedDbxOraADQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedDirOraADQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedDOAQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedODACQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedOraDbExprQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedCrlabOraDbExprQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedCrlabNetOraDbExprQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedCrlabOraSQLDataSetQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedOra4OraADOQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedMs4OraADOQuery);
    { TODO : Cant connect using ODBExpress to Oracle server.
             All the time tries to connect using BEQ. }
//    ADSpeedTestManager.RegisterDS(TADSpeedOra4OraODBCQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedMs4OraODBCQuery);
    // exclusions
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedOra4OraADOQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedMs4OraADOQuery);
    { TODO : Cant connect using ODBExpress to Oracle server.
             All the time tries to connect using BEQ. }
//    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedOra4OraODBCQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedMs4OraODBCQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedOraBDEQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedOraSQLDirectQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedOraDbExprQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedCrlabOraDbExprQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedCrlabNetOraDbExprQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedCrlabOraSQLDataSetQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecSQLTest,      TADSpeedCrlabOraSQLDataSetQuery);
  end;
  Result := ADSpeedTestManager;
end;

{---------------------------------------------------------------------------}
procedure UnReg;
begin
  ADSpeedTestManager.Free;
  ADSpeedTestManager := nil;
end;

{---------------------------------------------------------------------------}
initialization
  ADSpeedRegister := @Reg;
  ADSpeedUnregister := @UnReg;

end.

