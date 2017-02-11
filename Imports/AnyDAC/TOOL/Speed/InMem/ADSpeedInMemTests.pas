{ --------------------------------------------------------------------------- }
{ AnyDAC Speed Tester - inmemory tests unit                                   }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                 }
{                                                                             }
{ All rights reserved.                                                        }
{ --------------------------------------------------------------------------- }
{$I ..\ADSpeed.inc}

unit ADSpeedInMemTests;

interface

uses
  SysUtils, Classes, DB, Math, ADSpeedBase, ADSpeedBaseInMem;

type
  TADSpeedInMemDataSetTest = class(TADSpeedCustomInMemDataSetTest)
  private
    FUseIndexes: Boolean;
    FUseBatch: Boolean;
    FWithDelete: Boolean;
    FFldID, FFldStr, FFldInt: TField;
  protected
    function NeedPrepare: Boolean; virtual;
    procedure InternalPrepare; override;
    procedure InternalUnPrepare; override;
    procedure FillDataSet(ARecords: Integer);
  public
    constructor Create; override;
    class function GenerateString(ALen: Integer): String;
    property UseIndexes: Boolean read FUseIndexes write FUseIndexes;
    property UseBatch: Boolean read FUseBatch write FUseBatch;
    property WithDelete: Boolean read FWithDelete write FWithDelete;
    property FldID: TField read FFldID;
    property FldStr: TField read FFldStr;
    property FldInt: TField read FFldInt;
  end;

  TADSpeedInMemInsertDataSetTest = class(TADSpeedInMemDataSetTest)
  protected
    function NeedPrepare: Boolean; override;
    procedure InternalExecute; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemAppendDataSetTest = class(TADSpeedInMemDataSetTest)
  protected
    function NeedPrepare: Boolean; override;
    procedure InternalExecute; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemEditDataSetTest = class(TADSpeedInMemDataSetTest)
  protected
    function NeedPrepare: Boolean; override;
    procedure InternalPrepare; override;
    procedure InternalExecute; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemDeleteDataSetTest = class(TADSpeedInMemDataSetTest)
  protected
    function NeedPrepare: Boolean; override;
    procedure InternalPrepare; override;
    procedure InternalExecute; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemLocateByIDDataSetTest = class(TADSpeedInMemDataSetTest)
  protected
    function NeedPrepare: Boolean; override;
    procedure InternalPrepare; override;
    procedure InternalExecute; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemLocateByFIntegerDataSetTest = class(TADSpeedInMemDataSetTest)
  protected
    function NeedPrepare: Boolean; override;
    procedure InternalPrepare; override;
    procedure InternalExecute; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemLocateByFStringDataSetTest = class(TADSpeedInMemDataSetTest)
  protected
    function NeedPrepare: Boolean; override;
    procedure InternalPrepare; override;
    procedure InternalExecute; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemCloseDataSetTest = class(TADSpeedInMemDataSetTest)
  protected
    function NeedPrepare: Boolean; override;
    procedure InternalPrepare; override;
    procedure InternalExecute; override;
  public
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemInsertIndDataSetTest = class(TADSpeedInMemInsertDataSetTest)
  public
    constructor Create; override;
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemAppendIndDataSetTest = class(TADSpeedInMemAppendDataSetTest)
  public
    constructor Create; override;
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemEditIndDataSetTest = class(TADSpeedInMemEditDataSetTest)
  public
    constructor Create; override;
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemDeleteIndDataSetTest = class(TADSpeedInMemDeleteDataSetTest)
  public
    constructor Create; override;
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemLocateByIDIndDataSetTest = class(TADSpeedInMemLocateByIDDataSetTest)
  public
    constructor Create; override;
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemLocateByFIntegerIndDataSetTest = class(TADSpeedInMemLocateByFIntegerDataSetTest)
  public
    constructor Create; override;
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemLocateByFStringIndDataSetTest = class(TADSpeedInMemLocateByFStringDataSetTest)
  public
    constructor Create; override;
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

  TADSpeedInMemCloseIndDataSetTest = class(TADSpeedInMemCloseDataSetTest)
  public
    constructor Create; override;
    class function GetDescription: String; override;
    class function GetName: String; override;
  end;

implementation

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemDataSetTest                                                    }
{ --------------------------------------------------------------------------- }
constructor TADSpeedInMemDataSetTest.Create;
begin
  inherited Create;
  FUseBatch := G_AD_UseBatch;
end;

{ --------------------------------------------------------------------------- }
function TADSpeedInMemDataSetTest.NeedPrepare: Boolean;
begin
  Result := not TestingInMemDataSet.DataSet.Active or
    (FUseIndexes <> (TestingInMemDataSet.GetIndexCount <> 0));
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemDataSetTest.InternalPrepare;
begin
  inherited InternalPrepare;
  with TestingInMemDataSet do begin
    if NeedPrepare() then begin
      DeleteDataSet;
      AddField('ID', ftAutoInc);
      AddField('FString', ftString, 100);
      AddField('FInteger', ftInteger);
      if FUseIndexes then begin
        AddIndex('index1', 'ID');
        AddIndex('index2', 'FString');
        AddIndex('index3', 'FInteger');
      end;
      CreateDataSet;
      DataSet.Open;
    end;
    FFldID := DataSet.FieldByName('ID');
    FFldStr := DataSet.FieldByName('FString');
    FFldInt := DataSet.FieldByName('FInteger');
    if FUseBatch then
      BeginBatch(FWithDelete);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemDataSetTest.InternalUnPrepare;
begin
  with TestingInMemDataSet do begin
    if FUseBatch then
      EndBatch;
  end;
  inherited InternalUnPrepare;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemDataSetTest.GenerateString(ALen: Integer): String;
var
  i, x: integer;
  c: char;
  pCh: PChar;
begin
  SetLength(Result, ALen);
  pCh := PChar(Result);
  for i := 1 to ALen do begin
    x := Random(101);
    if (x mod 2) = 0 then
      c := Chr(65 + (Random(260000000) mod 26))
    else
      c := Chr(48 + (Random(100000000) mod 10));
    pCh^ := c;
    Inc(pCh);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemDataSetTest.FillDataSet(ARecords: Integer);
var
  i: Integer;
begin
  with TestingInMemDataSet do begin
    BeginBatch(False);
    try
      for i := 1 to ARecords do
        with DataSet do begin
          Append;
          FFldInt.AsInteger := Random(MaxInt) mod (ARecords div 10);
          FFldStr.AsString := GenerateString(100);
          Post;
        end;
    finally
      EndBatch;
    end;
    if FUseBatch then
      BeginBatch(FWithDelete);
  end;
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemInsertDataSetTest                                              }
{ --------------------------------------------------------------------------- }
function TADSpeedInMemInsertDataSetTest.NeedPrepare: Boolean;
begin
  Result := True;
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemInsertDataSetTest.InternalExecute;
begin
  with TestingInMemDataSet.DataSet do begin
    Insert;
    FFldInt.AsInteger := Random(MaxInt) mod (Times div 10);
    FFldStr.AsString := GenerateString(100);
    Post;
  end;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemInsertDataSetTest.GetName: String;
begin
  Result := 'Insert';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemInsertDataSetTest.GetDescription: String;
begin
  Result := 'Insert N records (AutoInc, Int, Str)';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemAppendDataSetTest                                              }
{ --------------------------------------------------------------------------- }
function TADSpeedInMemAppendDataSetTest.NeedPrepare: Boolean;
begin
  Result := True;
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemAppendDataSetTest.InternalExecute;
begin
  with TestingInMemDataSet.DataSet do begin
    Append;
    FFldInt.AsInteger := Random(MaxInt) mod (Times div 10);
    FFldStr.AsString := GenerateString(100);
    Post;
  end;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemAppendDataSetTest.GetName: String;
begin
  Result := 'Append';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemAppendDataSetTest.GetDescription: String;
begin
  Result := 'Append N records (AutoInc, Int, Str)';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemEditDataSetTest                                                }
{ --------------------------------------------------------------------------- }
function TADSpeedInMemEditDataSetTest.NeedPrepare: Boolean;
begin
  Result := inherited NeedPrepare or
    (TestingInMemDataSet.DataSet.RecordCount <> Times);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemEditDataSetTest.InternalPrepare;
begin
  FWithDelete := False;
  inherited InternalPrepare;
  if NeedPrepare() then
    FillDataSet(Times);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemEditDataSetTest.InternalExecute;
begin
  with TestingInMemDataSet.DataSet do begin
    RecNo := Step;
    Edit;
    FFldInt.AsInteger := Random(MaxInt) mod (Times div 10);
    FFldStr.AsString := GenerateString(100);
    Post;
  end;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemEditDataSetTest.GetName: String;
begin
  Result := 'Edit';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemEditDataSetTest.GetDescription: String;
begin
  Result := 'Goto and edit N records (Int, Str)';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemDeleteDataSetTest                                              }
{ --------------------------------------------------------------------------- }
function TADSpeedInMemDeleteDataSetTest.NeedPrepare: Boolean;
begin
  Result := inherited NeedPrepare or
    (TestingInMemDataSet.DataSet.RecordCount <> Times);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemDeleteDataSetTest.InternalPrepare;
begin
  FWithDelete := True;
  inherited InternalPrepare;
  if NeedPrepare() then
    FillDataSet(Times);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemDeleteDataSetTest.InternalExecute;
begin
  with TestingInMemDataSet.DataSet do
    Delete;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemDeleteDataSetTest.GetName: String;
begin
  Result := 'Delete';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemDeleteDataSetTest.GetDescription: String;
begin
  Result := 'Delete N records';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemLocateByIDDataSetTest                                          }
{ --------------------------------------------------------------------------- }
function TADSpeedInMemLocateByIDDataSetTest.NeedPrepare: Boolean;
begin
  Result := inherited NeedPrepare or
    (TestingInMemDataSet.DataSet.RecordCount <> Times);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemLocateByIDDataSetTest.InternalPrepare;
begin
  FUseBatch := False;
  inherited InternalPrepare;
  if NeedPrepare() then
    FillDataSet(Times);
  if FUseIndexes then
    TestingInMemDataSet.SetIndex('index1', 0);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemLocateByIDDataSetTest.InternalExecute;
var
  x: Integer;
begin
  with TestingInMemDataSet.DataSet do begin
    RecNo := Step;
    x := FFldID.AsInteger;
    RecNo := 1;
    if not Locate('ID', x, []) then
      raise Exception.Create('Locate By ID test failed');
    if FFldID.AsInteger <> x then
      raise Exception.Create('Locate By ID test failed invalid record found');
  end;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByIDDataSetTest.GetName: String;
begin
  Result := 'Locate ID';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByIDDataSetTest.GetDescription: String;
begin
  Result := 'Locate by ID N records';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemLocateByFIntegerDataSetTest                                    }
{ --------------------------------------------------------------------------- }
function TADSpeedInMemLocateByFIntegerDataSetTest.NeedPrepare: Boolean;
begin
  Result := inherited NeedPrepare or
    (TestingInMemDataSet.DataSet.RecordCount <> Times);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemLocateByFIntegerDataSetTest.InternalPrepare;
begin
  FUseBatch := False;
  inherited InternalPrepare;
  if NeedPrepare() then
    FillDataSet(Times);
  if FUseIndexes then
    TestingInMemDataSet.SetIndex('index3', 0);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemLocateByFIntegerDataSetTest.InternalExecute;
var
  x: Integer;
begin
  with TestingInMemDataSet.DataSet do begin
    RecNo := Step;
    x := FFldInt.AsInteger;
    RecNo := 1;
    if not Locate('FInteger', x, []) then
      raise Exception.Create('Locate By FInteger test failed');
    if FFldInt.AsInteger <> x then
      raise Exception.Create('Locate By FInteger test failed invalid record found');
  end;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByFIntegerDataSetTest.GetName: String;
begin
  Result := 'Locate Int';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByFIntegerDataSetTest.GetDescription: String;
begin
  Result := 'Locate by FInteger N records';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemLocateByFStringDataSetTest                                     }
{ --------------------------------------------------------------------------- }
function TADSpeedInMemLocateByFStringDataSetTest.NeedPrepare: Boolean;
begin
  Result := inherited NeedPrepare or
    (TestingInMemDataSet.DataSet.RecordCount <> Times);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemLocateByFStringDataSetTest.InternalPrepare;
begin
  FUseBatch := False;
  inherited InternalPrepare;
  if NeedPrepare() then
    FillDataSet(Times);
  if FUseIndexes then
    TestingInMemDataSet.SetIndex('index2', 0);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemLocateByFStringDataSetTest.InternalExecute;
var
  s: String;
begin
  with TestingInMemDataSet.DataSet do begin
    RecNo := Step;
    s := FFldStr.AsString;
    RecNo := 1;
    if not Locate('FString', s, []) then
      raise Exception.Create('Locate By FString test failed');
    if FFldStr.AsString <> s then
      raise Exception.Create('Locate By FString test failed record found');
  end;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByFStringDataSetTest.GetName: String;
begin
  Result := 'Locate Str';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByFStringDataSetTest.GetDescription: String;
begin
  Result := 'Locate by FString N records';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemCloseDataSetTest                                               }
{ --------------------------------------------------------------------------- }
function TADSpeedInMemCloseDataSetTest.NeedPrepare: Boolean;
begin
  Result := inherited NeedPrepare or
    (TestingInMemDataSet.DataSet.RecordCount <> TADSpeedInMemTestManager(ADSpeedRegister).RecordCount);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemCloseDataSetTest.InternalPrepare;
begin
  FUseBatch := False;
  inherited InternalPrepare;
  if NeedPrepare() then
    FillDataSet(TADSpeedInMemTestManager(ADSpeedRegister).RecordCount);
end;

{ --------------------------------------------------------------------------- }
procedure TADSpeedInMemCloseDataSetTest.InternalExecute;
begin
  TestingInMemDataSet.DataSet.Close;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemCloseDataSetTest.GetName: String;
begin
  Result := 'Close';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemCloseDataSetTest.GetDescription: String;
begin
  Result := 'Close dataset with RecordCount records';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemInsertIndDataSetTest                                           }
{ --------------------------------------------------------------------------- }
constructor TADSpeedInMemInsertIndDataSetTest.Create;
begin
  inherited Create;
  FUseIndexes := True;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemInsertIndDataSetTest.GetName: String;
begin
  Result := inherited GetName() + ' (3 ind''s)';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemInsertIndDataSetTest.GetDescription: String;
begin
  Result := inherited GetDescription() + ' into indexed dataset';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemAppendIndDataSetTest                                           }
{ --------------------------------------------------------------------------- }
constructor TADSpeedInMemAppendIndDataSetTest.Create;
begin
  inherited Create;
  FUseIndexes := True;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemAppendIndDataSetTest.GetName: String;
begin
  Result := inherited GetName() + ' (3 ind''s)';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemAppendIndDataSetTest.GetDescription: String;
begin
  Result := inherited GetDescription() + ' into indexed dataset';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemEditIndDataSetTest                                             }
{ --------------------------------------------------------------------------- }
constructor TADSpeedInMemEditIndDataSetTest.Create;
begin
  inherited Create;
  FUseIndexes := True;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemEditIndDataSetTest.GetName: String;
begin
  Result := inherited GetName() + ' (3 ind''s)';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemEditIndDataSetTest.GetDescription: String;
begin
  Result := inherited GetDescription() + ' in indexed dataset';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemDeleteIndDataSetTest                                           }
{ --------------------------------------------------------------------------- }
constructor TADSpeedInMemDeleteIndDataSetTest.Create;
begin
  inherited Create;
  FUseIndexes := True;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemDeleteIndDataSetTest.GetName: String;
begin
  Result := inherited GetName() + ' (3 ind''s)';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemDeleteIndDataSetTest.GetDescription: String;
begin
  Result := inherited GetDescription() + ' in indexed dataset';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemLocateByIDIndDataSetTest                                       }
{ --------------------------------------------------------------------------- }
constructor TADSpeedInMemLocateByIDIndDataSetTest.Create;
begin
  inherited Create;
  FUseIndexes := True;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByIDIndDataSetTest.GetName: String;
begin
  Result := inherited GetName() + ' (3 ind''s)';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByIDIndDataSetTest.GetDescription: String;
begin
  Result := inherited GetDescription() + ' in indexed dataset';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemLocateByFIntegerIndDataSetTest                                 }
{ --------------------------------------------------------------------------- }
constructor TADSpeedInMemLocateByFIntegerIndDataSetTest.Create;
begin
  inherited Create;
  FUseIndexes := True;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByFIntegerIndDataSetTest.GetName: String;
begin
  Result := inherited GetName() + ' (3 ind''s)';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByFIntegerIndDataSetTest.GetDescription: String;
begin
  Result := inherited GetDescription() + ' in indexed dataset';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemLocateByFStringIndDataSetTest                                  }
{ --------------------------------------------------------------------------- }
constructor TADSpeedInMemLocateByFStringIndDataSetTest.Create;
begin
  inherited Create;
  FUseIndexes := True;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByFStringIndDataSetTest.GetName: String;
begin
  Result := inherited GetName() + ' (3 ind''s)';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemLocateByFStringIndDataSetTest.GetDescription: String;
begin
  Result := inherited GetDescription() + ' in indexed dataset';
end;

{ --------------------------------------------------------------------------- }
{ TADSpeedInMemCloseIndDataSetTest                                            }
{ --------------------------------------------------------------------------- }
constructor TADSpeedInMemCloseIndDataSetTest.Create;
begin
  inherited Create;
  FUseIndexes := True;
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemCloseIndDataSetTest.GetName: String;
begin
  Result := inherited GetName() + ' (3 ind''s)';
end;

{ --------------------------------------------------------------------------- }
class function TADSpeedInMemCloseIndDataSetTest.GetDescription: String;
begin
  Result := inherited GetDescription() + ' in indexed dataset';
end;

end.

