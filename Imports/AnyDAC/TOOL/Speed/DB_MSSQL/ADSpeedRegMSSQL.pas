{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - dataset and test registration unit                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedRegMSSQL;

interface


implementation

uses
  ADSpeedBase,
  ADSpeedBaseDB,
  ADSpeedDBTests,
  ADSpeedBDE,
  ADSpeedSQLDirect,
  ADSpeedSDAC,
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
    ADSpeedTestManager.RegisterDS(TADSpeedMssqlBDEQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedMssqlSQLDirectQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedDirMssqlADQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedMssqlDbExprQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedCrlabMssqlDbExprQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedMs4MssqlADOQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedMs4MssqlODBCQuery);
    ADSpeedTestManager.RegisterDS(TADSpeedSDACQuery);
    // exclusions
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedMs4MssqlADOQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedMs4MssqlODBCQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedMssqlBDEQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedMssqlSQLDirectQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedMssqlDbExprQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedCrlabMssqlDbExprQuery);
    ADSpeedTestManager.ExcludeTest(TADSpeedExecArraySQLTest, TADSpeedSDACQuery);
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

