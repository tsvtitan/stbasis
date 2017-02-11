{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - inmemory dataset and test registration unit           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedRegInMem;

interface


implementation

uses
  ADSpeedBase,
  ADSpeedBaseInMem,
  ADSpeedInMemTests,
  ADSpeedADCDS,
  ADSpeedCDS,
  ADSpeedDXM,
  ADSpeedKBM;

var
  ADSpeedTestManager: TADSpeedTestManager = nil;

{---------------------------------------------------------------------------}
function Reg: TADSpeedTestManager;
begin
  if ADSpeedTestManager = nil then begin
    ADSpeedTestManager := TADSpeedInMemTestManager.Create;
    // register tests
    // indexed
    ADSpeedTestManager.RegisterTest(TADSpeedInMemInsertIndDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemEditIndDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemLocateByIDIndDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemLocateByFIntegerIndDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemLocateByFStringIndDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemDeleteIndDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemAppendIndDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemCloseIndDataSetTest, 1);
    // not indexed
    ADSpeedTestManager.RegisterTest(TADSpeedInMemInsertDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemEditDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemLocateByIDDataSetTest, 10000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemLocateByFIntegerDataSetTest, 10000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemLocateByFStringDataSetTest, 10000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemDeleteDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemAppendDataSetTest, 100000);
    ADSpeedTestManager.RegisterTest(TADSpeedInMemCloseDataSetTest, 1);
    // register DS's
    ADSpeedTestManager.RegisterDS(TADSpeedADClientDataSet);
    ADSpeedTestManager.RegisterDS(TADSpeedClientDataSet);
    ADSpeedTestManager.RegisterDS(TADSpeedDxMemData);
    ADSpeedTestManager.RegisterDS(TADSpeedKbmMemTable);
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

