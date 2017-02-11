{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - tests unit                                            }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedDBTests;

interface

uses
  SysUtils, Classes, DB, Math, ADSpeedBase, ADSpeedBaseDB;

type
  TADSpeedFetchTest = class(TADSpeedCustomDBDataSetTest)
  protected
    procedure InternalPrepareStep; override;
    procedure InternalExecute; override;
  end;

  TADSpeedFetch1WithBLOBSTest = class(TADSpeedFetchTest)
  protected
    procedure InternalPrepare; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedFetch1WithoutBLOBSTest = class(TADSpeedFetchTest)
  protected
    procedure InternalPrepare; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedFetchAllWithBLOBSTest = class(TADSpeedFetchTest)
  protected
    procedure InternalPrepare; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedFetchAllWithoutBLOBSTest = class(TADSpeedFetchTest)
  protected
    procedure InternalPrepare; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedExecuteTest = class(TADSpeedCustomDBDataSetTest)
  private
    F1: Integer;
    F2: TDateTime;
    F3: Double;
    F4: Double;
    F5: Double;
    F6: Double;
    F7: String;
  protected
    procedure InternalPrepare; override;
    procedure InternalUnPrepare; override;
    procedure InternalPrepareStep; override;
    procedure InternalExecute; override;
  end;

  TADSpeedExecSQLTest = class(TADSpeedExecuteTest)
  protected
    procedure InternalPrepare; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedExecArraySQLTest = class(TADSpeedExecuteTest)
  protected
    procedure InternalPrepare; override;
    procedure InternalUnPrepare; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

implementation

{---------------------------------------------------------------------------}
{ TADSpeedFetchTest                                                         }
{---------------------------------------------------------------------------}
procedure TADSpeedFetchTest.InternalPrepareStep;
begin
  TestingDBDataSet.DataSet.Close;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedFetchTest.InternalExecute;
var
  i: Integer;
  oFld: TField;
begin
  TestingDBDataSet.DataSet.Open;
  while not TestingDBDataSet.DataSet.Eof do begin
    for i := 0 to TestingDBDataSet.DataSet.FieldCount - 1 do begin
      oFld := TestingDBDataSet.DataSet.Fields[i];
      case oFld.DataType of
      ftString, ftFixedChar, ftWideString:
        oFld.AsString;
      ftSmallint, ftInteger, ftWord, ftAutoInc:
        oFld.AsInteger;
      ftBoolean:
        oFld.AsBoolean;
      ftFloat:
        oFld.AsFloat;
      ftCurrency:
        oFld.AsCurrency;
{$IFDEF AnyDAC_D6}
      ftBCD:
        TBCDField(oFld).AsBCD;
      ftFMTBcd:
        TFMTBCDField(oFld).AsBCD;
      ftTimeStamp:
        TSQLTimeStampField(oFld).AsSQLTimeStamp;
{$ELSE}
      ftBCD:
        TBCDField(oFld).AsCurrency;
{$ENDIF}
      ftDate, ftTime, ftDateTime:
        oFld.AsDateTime;
      ftLargeint:
        TLargeIntField(oFld).AsLargeInt;
      else
        oFld.AsString;
      end;
    end;
    TestingDBDataSet.DataSet.Next;
  end;
end;

{---------------------------------------------------------------------------}
{ TADSpeedFetch1WithBLOBSTest                                               }
{---------------------------------------------------------------------------}
class function TADSpeedFetch1WithBLOBSTest.GetName: String;
begin
  Result := 'Fetch 1 (BLOBs)';
end;

{---------------------------------------------------------------------------}
class function TADSpeedFetch1WithBLOBSTest.GetDescription: String;
begin
  Result := 'Open and fetch SINGLE record WITH BLOB field to client';
end;

{---------------------------------------------------------------------------}
procedure TADSpeedFetch1WithBLOBSTest.InternalPrepare;
begin
  TestingDBDataSet.Setup(False, True, True);
  TestingDBDataSet.SQL := 'SELECT * FROM ADQA_Categories WHERE CategoryID = 0';
  inherited InternalPrepare;
end;

{---------------------------------------------------------------------------}
{ TADSpeedFetch1WithoutBLOBSTest                                            }
{---------------------------------------------------------------------------}
class function TADSpeedFetch1WithoutBLOBSTest.GetName: String;
begin
  Result := 'Fetch 1 (no BLOBs)';
end;

{---------------------------------------------------------------------------}
class function TADSpeedFetch1WithoutBLOBSTest.GetDescription: String;
begin
  Result := 'Open and fetch SINGLE record WITHOUT BLOB field to client';
end;

{---------------------------------------------------------------------------}
procedure TADSpeedFetch1WithoutBLOBSTest.InternalPrepare;
begin
  TestingDBDataSet.Setup(False, True, True);
  TestingDBDataSet.SQL := 'SELECT * FROM ADQA_Products WHERE ProductID = 0';
  inherited InternalPrepare;
end;

{---------------------------------------------------------------------------}
{ TADSpeedFetchAllWithBLOBSTest                                             }
{---------------------------------------------------------------------------}
class function TADSpeedFetchAllWithBLOBSTest.GetName: String;
begin
  Result := 'Fetch All (BLOBs)';
end;

{---------------------------------------------------------------------------}
class function TADSpeedFetchAllWithBLOBSTest.GetDescription: String;
begin
  Result := 'Open and fetch ALL records WITH BLOB field to client';
end;

{---------------------------------------------------------------------------}
procedure TADSpeedFetchAllWithBLOBSTest.InternalPrepare;
begin
  TestingDBDataSet.Setup(True, True, True);
  TestingDBDataSet.SQL := 'SELECT * FROM ADQA_Categories';
  inherited InternalPrepare;
end;

{---------------------------------------------------------------------------}
{ TADSpeedFetchAllWithoutBLOBSTest                                          }
{---------------------------------------------------------------------------}
class function TADSpeedFetchAllWithoutBLOBSTest.GetName: String;
begin
  Result := 'Fetch All (no BLOBs)';
end;

{---------------------------------------------------------------------------}
class function TADSpeedFetchAllWithoutBLOBSTest.GetDescription: String;
begin
  Result := 'Open and fetch ALL records WITHOUT BLOB field to client';
end;

{---------------------------------------------------------------------------}
procedure TADSpeedFetchAllWithoutBLOBSTest.InternalPrepare;
begin
  TestingDBDataSet.Setup(True, False, True);
  TestingDBDataSet.SQL := 'SELECT * FROM ADQA_Products';
  inherited InternalPrepare;
end;

{---------------------------------------------------------------------------}
{ TADSpeedExecuteTest                                                       }
{---------------------------------------------------------------------------}
procedure TADSpeedExecuteTest.InternalPrepare;
var
  j: Integer;
begin
  TestingDBDataSet.Setup(False, False, True);
  F1 := Integer(Random(1000));
  F2 := NOW();
  F3 := Random(9999999999);
{$IFDEF AnyDAC_D6}
  F4 := RoundTo(Random * Random(9999999999), -4);
{$ELSE}
  F4 := Random * Random(9999999999);
{$ENDIF}
  F5 := Random(9999);
  F6 := Random * Random(999);
  SetLength(F7, 50);
  for j := 1 to Length(F7) do
    F7[j] := Char(Ord('a') + Random(25));
  TestingDBDataSet.SQL := 'insert into ADQA_OrderDetails (OrderID, OnDate, ProductID, ' +
    ' UnitPrice, Quantity, Discount, Notes) values (:f1, :f2, :f3, :f4, :f5, :f6, :f7)';
  TestingDBDataSet.DefineParam('f1', ftFloat, -1, ptInput);
  TestingDBDataSet.DefineParam('f2', ftDateTime, -1, ptInput);
  TestingDBDataSet.DefineParam('f3', ftFloat, -1, ptInput);
  TestingDBDataSet.DefineParam('f4', ftFloat, -1, ptInput);
  TestingDBDataSet.DefineParam('f5', ftFloat, -1, ptInput);
  TestingDBDataSet.DefineParam('f6', ftFloat, -1, ptInput);
  TestingDBDataSet.DefineParam('f7', ftString, 100, ptInput);
  inherited InternalPrepare;
  TestingDBDataSet.StartTransaction;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedExecuteTest.InternalUnPrepare;
begin
  TestingDBDataSet.RollbackTransaction;
  inherited InternalUnPrepare;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedExecuteTest.InternalPrepareStep;
begin
  F1 := F1 + 1;
  TestingDBDataSet.Params[0] := F1;
  TestingDBDataSet.Params[1] := F2;
  TestingDBDataSet.Params[2] := F3;
  TestingDBDataSet.Params[3] := F4;
  TestingDBDataSet.Params[4] := F5;
  TestingDBDataSet.Params[5] := F6;
  TestingDBDataSet.Params[6] := F7;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedExecuteTest.InternalExecute;
begin
  TestingDBDataSet.Execute;
end;

{---------------------------------------------------------------------------}
{ TADSpeedExecSQLTest                                                       }
{---------------------------------------------------------------------------}
class function TADSpeedExecSQLTest.GetName: String;
begin
  Result := 'ExecSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedExecSQLTest.GetDescription: String;
begin
  Result := 'Execute command using ExecSQL';
end;

{---------------------------------------------------------------------------}
procedure TADSpeedExecSQLTest.InternalPrepare;
begin
  TestingDBDataSet.ArraySize := 1;
  inherited InternalPrepare;
end;

{---------------------------------------------------------------------------}
{ TADSpeedExecArraySQLTest                                                  }
{---------------------------------------------------------------------------}
class function TADSpeedExecArraySQLTest.GetName: String;
begin
  Result := 'Array ExecSQL';
end;

{---------------------------------------------------------------------------}
class function TADSpeedExecArraySQLTest.GetDescription: String;
begin
  Result := 'Execute command using Array ExecSQL';
end;

{---------------------------------------------------------------------------}
procedure TADSpeedExecArraySQLTest.InternalPrepare;
begin
  TestingDBDataSet.ArraySize := Times;
  inherited InternalPrepare;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedExecArraySQLTest.InternalUnPrepare;
begin
  inherited InternalUnPrepare;
  TestingDBDataSet.ArraySize := 1;
end;

end.

