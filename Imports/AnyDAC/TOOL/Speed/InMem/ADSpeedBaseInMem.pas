{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - base inmemory dataset test classes                    }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedBaseInMem;

interface

uses
  Classes, DB,
  daADStanIntf,
  ADSpeedBase;

type
  TADSpeedCustomInMemDataSet = class;
  TADSpeedCustomInMemDataSetTest = class;
  TADSpeedInMemTestManager = class;

  TADSpeedCustomInMemDataSet = class(TADSpeedCustomDataSet)
  public
    procedure DeleteDataSet; virtual;
    procedure CreateDataSet; virtual;
    procedure AddField(const AName: String; AType: TFieldType; ASize: Integer = 0); virtual;
    procedure AddIndex(const AName, AFieldNames: String); virtual;
    procedure SetIndex(const AName: String; AIndex: Integer = 0); virtual;
    function GetIndexCount: Integer; virtual;
  end;

  TADSpeedCustomInMemDataSetTest = class(TADSpeedCustomDataSetTest)
  private
    function GetTestingInMemDataSet: TADSpeedCustomInMemDataSet;
  protected
    procedure InternalUnPrepare; override;
  public
    property TestingInMemDataSet: TADSpeedCustomInMemDataSet read GetTestingInMemDataSet;
  end;

  TADSpeedInMemTestManager = class(TADSpeedTestManager)
  private
    FRecordCount: Integer;
    procedure SetRecordCount(const AValue: Integer);
  public
    constructor Create;
    property RecordCount: Integer read FRecordCount write SetRecordCount;
  end;

var
  G_AD_UseBatch: Boolean = True;

implementation

uses
  Windows, SysUtils,
  daADStanFactory;

{---------------------------------------------------------------------------}
{ TADSpeedCustomInMemDataSet                                                }
{---------------------------------------------------------------------------}
procedure TADSpeedCustomInMemDataSet.AddField(const AName: String;
  AType: TFieldType; ASize: Integer);
begin
  DataSet.FieldDefs.Add(AName, AType, ASize);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomInMemDataSet.AddIndex(const AName, AFieldNames: String);
begin
  // nothing
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomInMemDataSet.CreateDataSet;
begin
  // nothing
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomInMemDataSet.DeleteDataSet;
begin
  DataSet.Close;
  DataSet.FieldDefs.Clear;
  DataSet.Fields.Clear;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomInMemDataSet.SetIndex(const AName: String;
  AIndex: Integer);
begin
  // nothing
end;

{---------------------------------------------------------------------------}
function TADSpeedCustomInMemDataSet.GetIndexCount: Integer;
begin
  Result := 0;
end;

{---------------------------------------------------------------------------}
{ TADSpeedCustomInMemDataSetTest                                            }
{---------------------------------------------------------------------------}
function TADSpeedCustomInMemDataSetTest.GetTestingInMemDataSet: TADSpeedCustomInMemDataSet;
begin
  Result := TADSpeedCustomInMemDataSet(TestingDataSet);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomInMemDataSetTest.InternalUnPrepare;
begin
  with TestingInMemDataSet do
    SetIndex('', -1);
  inherited InternalUnPrepare;
end;

{---------------------------------------------------------------------------}
{ TADSpeedInMemTestManager                                                  }
{---------------------------------------------------------------------------}
constructor TADSpeedInMemTestManager.Create;
begin
  inherited Create;
  FShareDataSets := True;
  FRecordCount := 100000;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedInMemTestManager.SetRecordCount(const AValue: Integer);
var
  i: Integer;
begin
  if FRecordCount <> AValue then begin
    for i := 0 to TestCount - 1 do
      if TestTimes[i] = FRecordCount then
        TestTimes[i] := AValue;
    FRecordCount := AValue;
  end;
end;

end.
