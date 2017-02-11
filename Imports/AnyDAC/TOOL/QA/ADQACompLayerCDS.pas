{-------------------------------------------------------------------------------}
{ AnyDAC Component Layer: TADClientDataSet tests                                }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQACompLayerCDS;

interface

uses
  Classes, Windows, SysUtils, DB,
  ADQAPack,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf,
  daADDAptIntf,
  daADCompClient, daADCompDataSet;

type
  TADQACompCDSTsHolder = class (TADQATsHolderBase)
  private
    FClDataSet: TADClientDataSet;
    FAdapter: TADTableAdapter;
    FSelCommand: TADCommand;
    FDataSource: TDataSource;
    procedure CheckRecord(ARecNo: Integer);
    procedure ClearClDataSet(ACDS: TADClientDataSet);
    procedure CreateFieldsWithKind(AKind: TFieldKind; ALow: Integer = -1;
      AHigh: Integer = -1);
    procedure DefineFieldDS(AFieldNo: Integer; AOtherName: String = '';
      AOtherCDS: TADClientDataSet = nil);
    procedure DefineClDataSet(ACreateDS: Boolean = True; AOtherNames: Boolean = False);
    procedure DeleteFieldDS(AFieldNo: Integer);
    procedure FillingValues(ANotAppend: Boolean = False);
    procedure FillClDataSet;
    procedure DoCalcFields(ADataSet: TDataSet);
    function SetFieldVal(ANum: Integer; AVal: Variant; ACDS: TADClientDataSet = nil): Boolean;
    procedure SetRecVals(AFld, ARec: Integer; ACDS: TADClientDataSet = nil);
  public
    constructor Create(const AName: String); override;
    destructor Destroy; override;
    procedure ClearAfterTest; override;
    procedure RegisterTests; override;
    procedure TestCalcFields;
    procedure TestOnCalcFieldsEvent;
    procedure TestLookupFields;
    procedure TestFilling;
    procedure TestEditing;
    procedure TestEmpty;
    procedure TestIndexUnicity;
    procedure TestIndexDescention;
    procedure TestIndexCaseInsensibility;
    procedure TestFindKey;
    procedure TestLocateLookup;
    procedure TestNavigation;
    procedure TestFilter;
    procedure TestMasterDetail;
    procedure TestSetRange;
    procedure TestAggregates;
    procedure TestCloneCursor;
    procedure TestDefineFields;
    procedure TestFetching;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, SqlTimSt,
{$ELSE}
  ActiveX, ComObj, 
{$ENDIF}  
  ADQAConst, ADQAUtils, ADQAVarField;

{-------------------------------------------------------------------------------}
{ TADQACompCDSTsHolder                                                          }
{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.RegisterTests;
begin
  RegisterTest('CDS;Filling',                TestFilling, mkUnknown);
  RegisterTest('CDS;Editing',                TestEditing, mkUnknown);
  RegisterTest('CDS;Emptying',               TestEmpty, mkUnknown);
  RegisterTest('CDS;Unique Index',           TestIndexUnicity, mkUnknown);
  RegisterTest('CDS;Descending Index',       TestIndexDescention, mkUnknown);
  RegisterTest('CDS;Case insensitive Index', TestIndexCaseInsensibility, mkUnknown);
  RegisterTest('CDS;FindKey',                TestFindKey, mkUnknown);
  RegisterTest('CDS;Locate/Lookup',          TestLocateLookup, mkUnknown);
  RegisterTest('CDS;Navigation',             TestNavigation, mkUnknown);
  RegisterTest('CDS;Filter',                 TestFilter, mkUnknown);
  RegisterTest('CDS;MasterDetail',           TestMasterDetail, mkUnknown);
  RegisterTest('CDS;SetRange',               TestSetRange, mkUnknown);
  RegisterTest('CDS;Aggregates',             TestAggregates, mkUnknown);
  RegisterTest('CDS;Cloning cursor',         TestCloneCursor, mkUnknown);
  RegisterTest('CDS;Dynamic definition',     TestDefineFields, mkUnknown);
  RegisterTest('CDS;Fetching;DB2',           TestFetching, mkDB2);
  RegisterTest('CDS;Fetching;MS Access',     TestFetching, mkMSAccess);
  RegisterTest('CDS;Fetching;MSSQL',         TestFetching, mkMSSQL);
  RegisterTest('CDS;Fetching;ASA',           TestFetching, mkASA);
  RegisterTest('CDS;Fetching;MySQL',         TestFetching, mkMySQL);
  RegisterTest('CDS;Fetching;Oracle',        TestFetching, mkOracle);
  RegisterTest('CDS;OnCalcFields',           TestOnCalcFieldsEvent, mkUnknown);
  RegisterTest('CDS;Lookup fields',          TestLookupFields, mkUnknown);
  RegisterTest('CDS;Calculated fields',      TestCalcFields, mkUnknown);
end;

{-------------------------------------------------------------------------------}
constructor TADQACompCDSTsHolder.Create(const AName: String);
begin
  inherited Create(AName);
  FClDataSet  := TADClientDataSet.Create(nil);
  FAdapter := TADTableAdapter.Create(nil);
  FSelCommand := TADCommand.Create(nil);
  FDataSource := TDataSource.Create(nil);
  FDataSource.DataSet := FClDataSet;
end;

{-------------------------------------------------------------------------------}
destructor TADQACompCDSTsHolder.Destroy;
begin
  FClDataSet.Free;
  FClDataSet := nil;
  FAdapter.Free;
  FAdapter := nil;
  FSelCommand.Free;
  FSelCommand := nil;
  FDataSource.Free;
  FDataSource := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.ClearAfterTest;
begin
  ClearClDataSet(FClDataSet);
  FClDataSet.Adapter := nil;
  FAdapter.Reset;
  FSelCommand.Disconnect;
  inherited ClearAfterTest;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.CheckRecord(ARecNo: Integer);
var
  V1, V2: Variant;

  function GetFieldVal(AName: String; ANum: Integer; ALen: Integer = 0): Variant;
  var
    oFld: TField;
    s: String;
  begin
    oFld := FClDataSet.FindField(AName);
    if oFld = nil then begin
      Result := Unassigned;
      Exit;
    end;
    try
      case FldTypes[ANum] of
      ftString, ftBlob,
      ftMemo, ftFixedChar:
        Result := oFld.AsString;
      ftWideString:
        Result := TWideStringField(oFld).Value;
      ftBytes, ftVarBytes:
        begin
          SetString(s, PChar(FClDataSet.FieldByName(AName).AsString), ALen);
          Result := s;
        end;
      ftSmallint,
      ftInteger,
      ftWord,
      ftAutoInc:
        Result := oFld.AsInteger;
      ftBoolean:
        Result := oFld.AsBoolean;
      ftFloat:
        Result := oFld.AsFloat;
      ftCurrency,
      ftBCD:
        Result := oFld.AsCurrency;
      ftDate,
      ftDateTime,
      ftTime:
        Result := oFld.AsDateTime;
      ftGuid:
        Result := GUIDToString(TGuidField(oFld).AsGuid);
{$IFDEF AnyDAC_D6}
      ftLargeint:
        Result := TLargeintField(oFld).AsLargeInt;
      ftTimeStamp:
        Result := VarSQLTimeStampCreate(TSQLTimeStampField(oFld).Value);
      ftFMTBcd:
        Result := VarFMTBcdCreate(TFMTBcdField(oFld).Value);
{$ELSE}
      ftLargeint:
        begin
          TVarData(Result).VType := varInt64;
          Decimal(Result).Lo64 := TLargeintField(oFld).AsLargeInt;
        end;
{$ENDIF}
      else
        ASSERT(False);
      end;
    except
      on E: Exception do begin
        Error(E.Message);
        Result := Unassigned;
        Exit;
      end;
    end;
  end;

begin
    V1 := GetFieldVal('ftString', 0);
    V2 := Strings[ARecNo];
    if Compare(V1, V2, FldTypes[0]) <> 0 then
      Error(SetFieldValueError('ftString'));

    V1 := GetFieldVal('ftSmallInt', 1);
    V2 := SmallInts[ARecNo];
    if Compare(V1, V2, FldTypes[1]) <> 0 then
      Error(SetFieldValueError('ftSmallInt'));

    V1 := GetFieldVal('ftInteger', 2);
    V2 := Integers[ARecNo];
    if Compare(V1, V2, FldTypes[2]) <> 0 then
      Error(SetFieldValueError('ftInteger'));

    V1 := GetFieldVal('ftWord', 3);
    V2 := Words[ARecNo];
    if Compare(V1, V2, FldTypes[3]) <> 0 then
      Error(SetFieldValueError('ftWord'));

    V1 := GetFieldVal('ftBoolean', 4);
    V2 := Booleans[ARecNo];
    if Compare(V1, V2, FldTypes[4]) <> 0 then
      Error(SetFieldValueError('ftBoolean'));

    V1 := GetFieldVal('ftFloat', 5);
    V2 := Floats[ARecNo];
    if Compare(V1, V2, FldTypes[5]) <> 0 then
      Error(SetFieldValueError('ftFloat'));

    V1 := GetFieldVal('ftCurrency', 6);
    V2 := Currencies[ARecNo];
    if Compare(V1, V2, FldTypes[6]) <> 0 then
      Error(SetFieldValueError('ftCurrency'));

    V1 := GetFieldVal('ftBCD', 7);
    V2 := Bcds[ARecNo];
    if Compare(V1, V2, FldTypes[7]) <> 0 then
      Error(SetFieldValueError('ftBCD'));

    V1 := GetFieldVal('ftDate', 8);
    V2 := Dates[ARecNo];
    if Compare(V1, V2, FldTypes[8]) <> 0 then
      Error(SetFieldValueError('ftDate'));

    V1 := GetFieldVal('ftTime', 9);
    V2 := Times[ARecNo];
    if Compare(V1, V2, FldTypes[9]) <> 0 then
      Error(SetFieldValueError('ftTime'));

    V1 := GetFieldVal('ftDateTime', 10);
    V2 := DateTimes[ARecNo];
    if Compare(V1, V2, FldTypes[10]) <> 0 then
      Error(SetFieldValueError('ftDateTime'));

    V1 := GetFieldVal('ftBytes', 11, Length(Bytes[ARecNo]));
    V2 := Bytes[ARecNo];
    if (Compare(V1, V2, FldTypes[11]) <> 0) and not VarIsEmpty(V1) then
      Error(SetFieldValueError('ftBytes'));

    V1 := GetFieldVal('ftVarBytes', 12, Length(VarBytes[ARecNo]));
    V2 := VarBytes[ARecNo];
    if (Compare(V1, V2, FldTypes[12]) <> 0) and not VarIsEmpty(V1) then
      Error(SetFieldValueError('ftVarBytes'));

    V1 := GetFieldVal('ftAutoInc', 13);
    V2 := AutoIncs[ARecNo];
    if (Compare(V1, V2, FldTypes[13]) <> 0) and not VarIsEmpty(V1) then
      Error(SetFieldValueError('ftAutoInc'));

    V1 := GetFieldVal('ftBlob', 14);
    V2 := Blobs[ARecNo];
    if (Compare(V1, V2, FldTypes[14]) <> 0) and not VarIsEmpty(V1) then
      Error(SetFieldValueError('ftBlob'));

    V1 := GetFieldVal('ftMemo', 15);
    V2 := Memos[ARecNo];
    if (Compare(V1, V2, FldTypes[15]) <> 0) and not VarIsEmpty(V1) then
      Error(SetFieldValueError('ftMemo'));

    V1 := GetFieldVal('ftFixedChar', 16);
    V2 := FixedChars[ARecNo];
    if Compare(V1, V2, FldTypes[16]) <> 0 then
      Error(SetFieldValueError('ftFixedChar'));

    V1 := GetFieldVal('ftWideString', 17);
    V2 := WideStrings[ARecNo];
    if Compare(V1, V2, FldTypes[17]) <> 0 then
      Error(SetFieldValueError('ftWideString'));

    V1 := GetFieldVal('ftGuid', 18);
    V2 := Guids[ARecNo];
    if (Compare(V1, V2, FldTypes[18]) <> 0) and not VarIsEmpty(V1) then
      Error(SetFieldValueError('ftGuid'));

    V1 := GetFieldVal('ftLargeInt', 19);
{$IFDEF AnyDAC_D6}
    V2 := LargeInts[ARecNo];
{$ELSE}
    TVarData(V2).VType := varInt64;
    Decimal(V2).Lo64 := LargeInts[ARecNo];
{$ENDIF}
    if Compare(V1, V2, FldTypes[19]) <> 0 then
      Error(SetFieldValueError('ftLargeInt'));

{$IFDEF AnyDAC_D6}
    V1 := GetFieldVal('ftTimeStamp', 20);
    V2 := VarSQLTimeStampCreate(TimeStamps[ARecNo]);
    if Compare(V1, V2, FldTypes[20]) <> 0 then
      Error(SetFieldValueError('ftTimeStamp'));

    V1 := GetFieldVal('ftFMTBcd', 21);
    V2 := VarFMTBcdCreate(FMTBcds[ARecNo]);
    if Compare(V1, V2, FldTypes[21]) <> 0 then
      Error(SetFieldValueError('ftFMTBcd'));
{$ENDIF}      
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.ClearClDataSet(ACDS: TADClientDataSet);
begin
  with ACDS do begin
    OnCalcFields := nil;
    if not(State = dsInactive) then
      EmptyDataSet;
    FieldDefs.Clear;
    Fields.Clear;
    Close;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.CreateFieldsWithKind(AKind: TFieldKind; ALow: Integer;
  AHigh: Integer);
var
  i: Integer;
begin
  if ALow < 0 then
    ALow := 0;
  if AHigh < 0 then
    AHigh := FClDataSet.FieldDefs.Count - 1;
  with FClDataSet do
    for i := ALow to AHigh do begin
      if (FieldDefs[i].DataType in [ftBytes, ftVarBytes, ftBlob, ftMemo, ftGuid, ftAutoInc]) and
         (AKind in [fkCalculated, fkLookup]) then
        continue;
      FieldDefs[i].CreateField(FClDataSet).FieldKind := AKind
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.DefineFieldDS(AFieldNo: Integer; AOtherName: String;
  AOtherCDS: TADClientDataSet);
var
  i: Integer;
  Idx: TADIndex;
  CDS: TADClientDataSet;
begin
  // Fields
  if AOtherCDS = nil then
    CDS := FClDataSet
  else
    CDS := AOtherCDS;
  if (AFieldNo > FIELD_COUNT) and (AOtherName = '') then
    raise Exception.CreateFmt(FieldIndexErrorMsg, [AFieldNo, FIELD_COUNT]);
  if AOtherName = '' then
    CDS.FieldDefs.Add(FldNames[AFieldNo], FldTypes[AFieldNo], FldSizes[AFieldNo])
  else if not(FldTypes[AFieldNo] in [ftBytes, ftVarBytes, ftBlob, ftMemo, ftGuid, ftAutoInc]) then
    CDS.FieldDefs.Add(AOtherName, FldTypes[AFieldNo], FldSizes[AFieldNo]);

  if AOtherName <> '' then
    Exit;

  // Indices
  for i := 0 to INDEX_COUNT - 1 do begin
    Idx := CDS.Indexes.Add;
    Idx.Name := IdxPrefs[i] + FldNames[AFieldNo];
    Idx.Fields := FldNames[AFieldNo];
    if not (IsNonTextField(AFieldNo) or IsBooleanField(AFieldNo)) or
      IsBooleanField(AFieldNo) and (IdxValues[i] = soDescending) then
      Idx.Options := Idx.Options + [IdxValues[i]];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.DeleteFieldDS(AFieldNo: Integer);
var
  i: Integer;
  oIdx: TADIndex;
  sFldName: String;
begin
  sFldName := FldNames[AFieldNo];
  i := 0;
  while i <= FClDataSet.FieldDefs.Count - 1 do begin
    if Pos(sFldName, FClDataSet.FieldDefs[i].Name) <> 0 then
      FClDataSet.FieldDefs.Delete(i)
    else
      Inc(i);
  end;
  for i := 0 to INDEX_COUNT - 1 do begin
    oIdx := FClDataSet.Indexes.FindIndex(IdxPrefs[i] + sFldName);
    oIdx.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.DefineClDataSet(ACreateDS: Boolean; AOtherNames: Boolean);
var
  i: Integer;
  lDefine: Boolean;
begin
  try
    with FClDataSet do begin
      Close;
      lDefine := (FieldCount <> FIELD_COUNT) or AOtherNames;
      if lDefine then begin
        if not AOtherNames then begin
          FieldDefs.Clear;
          Indexes.Clear;
          IndexDefs.Clear;
          Aggregates.Clear;
        end;
        for i := 0 to FIELD_COUNT - 1 do
          if not AOtherNames then
            DefineFieldDS(i)
          else
            DefineFieldDS(i, FldNames[i] + '_calc');
        if AOtherNames then
          Exit;
      end;
      IndexesActive := True;
      AggregatesActive := True;
      if ACreateDS then
        CreateDataSet;
    end;
  except
    on E: Exception do
      Error(E.Message);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.FillingValues(ANotAppend: Boolean = False);
var
  i: Integer;
{$IFNDEF AnyDAC_D6}
  v: variant;
{$ENDIF}
begin
  try
    if not ANotAppend then
      FClDataSet.EmptyDataSet;
    if FClDataSet.Fields.Count > 0 then
      for i := 0 to RECORD_COUNT - 1 do
        with FClDataSet do begin
          if not ANotAppend then
            Append;
          SetFieldVal(0,  Strings[i]);
          SetFieldVal(1,  SmallInts[i]);
          SetFieldVal(2,  Integers[i]);
          SetFieldVal(3,  Words[i]);
          SetFieldVal(4,  Booleans[i]);
          SetFieldVal(5,  Floats[i]);
          SetFieldVal(6,  Currencies[i]);
          SetFieldVal(7,  Bcds[i]);
          SetFieldVal(8,  Dates[i]);
          SetFieldVal(9,  Times[i]);
          SetFieldVal(10, DateTimes[i]);
          SetFieldVal(11, Bytes[i]);
          SetFieldVal(12, VarBytes[i]);
          SetFieldVal(13, AutoIncs[i]);
          SetFieldVal(14, Blobs[i]);
          SetFieldVal(15, Memos[i]);
          SetFieldVal(16, FixedChars[i]);
          SetFieldVal(17, WideStrings[i]);
          SetFieldVal(18, Guids[i]);
{$IFDEF AnyDAC_D6}
          SetFieldVal(19, LargeInts[i]);
          SetFieldVal(20, VarSQLTimeStampCreate(TimeStamps[i]));
          SetFieldVal(21, VarFMTBcdCreate(FMTBcds[i]));
{$ELSE}
          TVarData(v).VType := varInt64;
          Decimal(v).Lo64 := LargeInts[i];
          SetFieldVal(19, v);
{$ENDIF}
          if not ANotAppend then
            Post
          else
            break;
        end;
  except
    on E: Exception do
      Error(E.Message);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.FillClDataSet;
begin
  DefineClDataSet;
  FillingValues;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.DoCalcFields(ADataSet: TDataSet);
begin
  FillingValues(True);
end;

{-------------------------------------------------------------------------------}
function TADQACompCDSTsHolder.SetFieldVal(ANum: Integer; AVal: Variant;
  ACDS: TADClientDataSet): Boolean;
var
  oFld: TField;
begin
  if ACDS = nil then
    ACDS := FClDataSet;
  Result := True;
  oFld := ACDS.FindField(FldNames[ANum]);
  if oFld = nil then
    Exit;
  try
    case FldTypes[ANum] of
    ftString,
    ftBytes,
    ftVarBytes,
    ftBlob,
    ftMemo,
    ftFixedChar:
      oFld.AsString := AVal;
    ftWideString:
      TWideStringField(oFld).Value := AVal;
    ftSmallint,
    ftInteger,
    ftWord,
    ftAutoInc:
      oFld.AsInteger := AVal;
    ftBoolean:
      oFld.AsBoolean := AVal;
    ftFloat:
      oFld.AsFloat := AVal;
    ftCurrency,
    ftBCD:
      oFld.AsCurrency := AVal;
    ftDate,
    ftDateTime,
    ftTime:
      oFld.AsDateTime := AVal;
    ftGuid:
      TGuidField(oFld).AsGuid := StringToGUID(AVal);
{$IFDEF AnyDAC_D6}
    ftLargeint:
      TLargeintField(oFld).AsLargeInt := AVal;
    ftTimeStamp:
      TSQLTimeStampField(oFld).Value := VarToSQLTimeStamp(AVal);
    ftFMTBcd:
      TFMTBcdField(oFld).Value := VarToBcd(AVal);
{$ELSE}
    ftLargeint:
      oFld.AsVariant := AVal;
{$ENDIF}
    else
      ASSERT(False);
    end;
  except
    on E: Exception do begin
      Error(E.Message);
      Result := False;
      Exit;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.SetRecVals(AFld, ARec: Integer; ACDS: TADClientDataSet);
{$IFNDEF AnyDAC_D6}
var
  v: variant;
{$ENDIF}
begin
  case AFld of
  0:  SetFieldVal(0,  Strings[ARec],     ACDS);
  1:  SetFieldVal(1,  SmallInts[ARec],   ACDS);
  2:  SetFieldVal(2,  Integers[ARec],    ACDS);
  3:  SetFieldVal(3,  Words[ARec],       ACDS);
  4:  SetFieldVal(4,  Booleans[ARec],    ACDS);
  5:  SetFieldVal(5,  Floats[ARec],      ACDS);
  6:  SetFieldVal(6,  Currencies[ARec],  ACDS);
  7:  SetFieldVal(7,  Bcds[ARec],        ACDS);
  8:  SetFieldVal(8,  Dates[ARec],       ACDS);
  9:  SetFieldVal(9,  Times[ARec],       ACDS);
  10: SetFieldVal(10, DateTimes[ARec],   ACDS);
  11: SetFieldVal(11, Bytes[ARec],       ACDS);
  12: SetFieldVal(12, VarBytes[ARec],    ACDS);
  13: SetFieldVal(13, AutoIncs[ARec],    ACDS);
  14: SetFieldVal(14, Blobs[ARec],       ACDS);
  15: SetFieldVal(15, Memos[ARec],       ACDS);
  16: SetFieldVal(16, FixedChars[ARec],  ACDS);
  17: SetFieldVal(17, WideStrings[ARec], ACDS);
  18: SetFieldVal(18, Guids[ARec],       ACDS);
{$IFDEF AnyDAC_D6}
  19: SetFieldVal(19, LargeInts[ARec],   ACDS);
  20: SetFieldVal(20, VarSQLTimeStampCreate(TimeStamps[ARec]), ACDS);
  21: SetFieldVal(21, VarFMTBcdCreate(FMTBcds[ARec]),          ACDS);
{$ELSE}
  19:
    begin
      TVarData(v).VType := varInt64;
      Decimal(v).Lo64 := LargeInts[ARec];
      SetFieldVal(19, v,                 ACDS);
    end;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestCalcFields;
var
  i: Integer;
  aSign: array[0..3] of Char;
  POper: TOp;

  procedure Define;
  begin
    DefineClDataSet(False);
    DefineClDataSet(False, True);
    CreateFieldsWithKind(fkData, 0, FIELD_COUNT - 1);
    CreateFieldsWithKind(fkInternalCalc, FIELD_COUNT);
  end;

  procedure SetNonNumericExpr;
  var
    i: Integer;
  begin
    with FClDataSet do
      for i := FIELD_COUNT to Fields.Count - 1 do
        case Fields[i].DataType of
        ftString:
          Fields[i].DefaultExpression := 'ftWideString + ftFixedChar';
        ftWideString:
          Fields[i].DefaultExpression := 'ftString + ftFixedChar';
        ftFixedChar:
          Fields[i].DefaultExpression := 'ftString + ftWideString';
        ftBoolean:
          Fields[i].DefaultExpression := 'True';
        ftDate:
          Fields[i].DefaultExpression := '''' + DateToStr(Dates[0]) + '''';
        ftTime:
          Fields[i].DefaultExpression := '''' + TimeToStr(Times[0]) + '''';
        ftDateTime:
          Fields[i].DefaultExpression := '''' + DateTimeToStr(DateTimes[0]) + '''';
{$IFDEF AnyDAC_D6}
        ftTimeStamp:
          Fields[i].DefaultExpression := '''' + DateTimeToStr(SQLTimeStampToDateTime(TimeStamps[0])) + '''';
{$ENDIF}          
        end;
  end;

  procedure SetAndCheckNumericExpr(ASign: String);
  var
    i, j, k: Integer;
    V1, V2:  Variant;
    d:       Double;
    oResFld: TField;

    procedure ClearExpr;
    var
      i: Integer;
    begin
      with FClDataSet do
        for i := FIELD_COUNT to FieldCount - 1 do
          Fields[i].DefaultExpression := '';
    end;

  begin
    k := -1;
    with FClDataSet do
      for i := 0 to FIELD_COUNT - 1 do begin
        if Fields[i].DataType in [ftBytes, ftVarBytes, ftAutoInc,
                                  ftBlob, ftMemo, ftGuid] then
          continue;
        Inc(k);
        if Fields[i].DataType in [ftString, ftBoolean, ftDate, ftTime, ftDateTime,
                                  ftFixedChar, ftWideString {$IFDEF AnyDAC_D6}, ftTimeStamp {$ENDIF}] then
          continue;
        for j := 0 to FIELD_COUNT - 1 do begin
          if j = i then
            continue;
          if Fields[j].DataType in [ftString, ftBoolean, ftDate, ftTime, ftDateTime,
                                    ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo,
                                    ftFixedChar, ftWideString, ftGuid {$IFDEF AnyDAC_D6}, ftTimeStamp {$ENDIF}] then
            continue;

          Close;
          ClearExpr;
          oResFld := Fields[FIELD_COUNT + k];
          oResFld.DefaultExpression := Format('%s %s %s', [Fields[i].FullName,
                                              ASign, Fields[j].FullName]);
          CreateDataSet;

          if oResFld.DataType in
             [ftSmallint, ftInteger, ftLargeint, ftWord] then begin
            V1 := 28;
            V2 := 14;
          end
          else begin
            if Fields[i].DataType in
               [ftSmallint, ftInteger, ftLargeint, ftWord] then
              V1 := 98
            else
              V1 := 1444.235213;
            if Fields[j].DataType in
               [ftSmallint, ftInteger, ftLargeint, ftWord] then
              V2 := 118
            else
              V2 := 244.9313;
          end;

          try
            Append;
            SetFieldValue(Fields[i], V1);
            SetFieldValue(Fields[j], V2);
            Post;
          except
            on E: Exception do begin
              Error(ErrorOnCalcField(oResFld.FullName, Fields[i].FullName,
                    Fields[j].FullName, Format('%s %s %s', [VarToStr(V1), ASign,
                                               VarToStr(V2)]), E.Message));
              continue;
            end;
          end;

          if VarIsNull(oResFld.Value) then begin
            Error(CalcFieldValNull(oResFld.FullName, Fields[i].FullName,
                  Fields[j].FullName, Format('%s %s %s', [VarToStr(V1), ASign,
                                             VarToStr(V2)])));
            continue;
          end;

          d := Abs(POper(V1, V2) - oResFld.Value);
          if d > 0.1 then
            Error(WrongCalcFieldValNull(oResFld.FullName,
                  Fields[FIELD_COUNT + k].AsString, FloatToStr(POper(V1, V2)),
                  Fields[i].FullName, Fields[j].FullName,
                  Format('%s %s %s', [VarToStr(V1), ASign, VarToStr(V2)])));

          Delete;
        end;
      end;
  end;

  procedure CheckNonNumericFields;
  var
    i: Integer;
    V1, V2: Variant;
  begin
    with FClDataSet do
      for i := FIELD_COUNT to Fields.Count - 1 do
        case Fields[i].DataType of
        ftString:
          begin
            V1 := Fields[i].AsString;
            V2 := Fields.FieldByName('ftWideString').AsString +
                  Fields.FieldByName('ftFixedChar').AsString;
            if V1 <> V2 then
              Error(FieldsDiffer(Fields[i].FullName, V1, V2));
          end;
        ftWideString:
          begin
            V1 := Fields[i].AsString;
            V2 := Fields.FieldByName('ftString').AsString +
                  Fields.FieldByName('ftFixedChar').AsString;
            if V1 <> V2 then
              Error(FieldsDiffer(Fields[i].FullName, V1, V2));
          end;
        ftFixedChar:
          begin
            V1 := Fields[i].AsString;
            V2 := Fields.FieldByName('ftString').AsString +
                  Fields.FieldByName('ftWideString').AsString;
            if V1 <> V2 then
              Error(FieldsDiffer(Fields[i].FullName, V1, V2));
          end;
        ftBoolean:
          begin
            V1 := Fields[i].AsBoolean;
            V2 := True;
            if V1 <> V2 then
              Error(FieldsDiffer(Fields[i].FullName, VarToStr(V1), VarToStr(V2)));
          end;
        ftDate:
          begin
            V1 := Fields[i].AsString;
            V2 := DateToStr(Dates[0]);
            if V1 <> V2 then
              Error(FieldsDiffer(Fields[i].FullName, VarToStr(V1), VarToStr(V2)));
          end;
        ftTime:
          begin
            V1 := Fields[i].AsString;
            V2 := TimeToStr(Times[0]);
            if V1 <> V2 then
              Error(FieldsDiffer(Fields[i].FullName, VarToStr(V1), VarToStr(V2)));
          end;
        ftDateTime:
          begin
            V1 := Fields[i].AsString;
            V2 := DateTimeToStr(DateTimes[0]);
            if V1 <> V2 then
              Error(FieldsDiffer(Fields[i].FullName, VarToStr(V1), VarToStr(V2)));
          end;
{$IFDEF AnyDAC_D6}
        ftTimeStamp:
          begin
            V1 := VarSQLTimeStampCreate(Fields[i].AsSQLTimeStamp);
            V2 := VarSQLTimeStampCreate(TimeStamps[0]);
            if V1 <> V2 then
              Error(FieldsDiffer(Fields[i].FullName, VarToStr(V1), VarToStr(V2)));
          end;
{$ENDIF}          
        end;
  end;

begin
  // non numeric fields
  // defining
  Define;

  // setting up non numeric expression
  SetNonNumericExpr;
  FClDataSet.CreateDataSet;

  try
    FClDataSet.Append;
    FillingValues(True);
    FClDataSet.Post;
  except
    on E: Exception do
      Error(E.Message);
  end;

  // checking
  CheckNonNumericFields;

  // numeric fields
  try
    ClearClDataSet(FClDataSet);
    Define;

    aSign[0] := '+';
    aSign[1] := '-';
    aSign[2] := '*';
    aSign[3] := '/';

    for i := 0 to 3 do begin
      case i of
      0: POper := SumOp;
      1: POper := DeducOp;
      2: POper := MulOp;
      3: POper := DivOp;
      end;
      SetAndCheckNumericExpr(aSign[i]);
    end;
  except
    on E: Exception do
      Error(E.Message);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestOnCalcFieldsEvent;
begin
  FClDataSet.OnCalcFields := DoCalcFields;
  DefineClDataSet(False);
  CreateFieldsWithKind(fkCalculated);
  FClDataSet.CreateDataSet;
  with FClDataSet do begin
    Append;
    Post;
  end;
  CheckRecord(0);
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestLookupFields;
var
  i, j: Integer;
  cdsLookUp: TADClientDataSet;
  V1, V2: Variant;

  procedure PopulateCDS(AFld: Integer);
  var
    i: Integer;
  begin
    for i := 0 to RECORD_COUNT - 1 do begin
      with FClDataSet do begin
        Append;
        Fields[0].AsString := 'String' + IntToStr(i);
        Post;
      end;
      with cdsLookUp do begin
        Append;
        Fields[0].AsString := 'String' + IntToStr(i);
        SetRecVals(AFld, i, cdsLookUp);
        Post;
      end;
    end;
  end;

begin
  cdsLookUp := TADClientDataSet.Create(nil);
  try
    for i := 0 to FIELD_COUNT - 1 do begin
      if FldTypes[i] in [ftBytes, ftVarBytes, ftBlob, ftMemo,
              ftGuid, ftAutoInc] then
        continue;
      // closing
      ClearClDataSet(FClDataSet);
      ClearClDataSet(cdsLookUp);

      // defining
      DefineFieldDS(0, 'key_field');
      DefineFieldDS(i, FldNames[i] + '_lookup');
      with FClDataSet do begin
        FieldDefs[0].CreateField(FClDataSet);
        with FieldDefs[1].CreateField(FClDataSet) do begin
          KeyFields := 'key_field';
          LookupKeyFields := 'lookup_key';
          LookupResultField := FldNames[i];
          Lookup := True;
          LookupDataSet := cdsLookUp;
        end;
      end;

      DefineFieldDS(0, 'lookup_key', cdsLookUp);
      DefineFieldDS(i, '', cdsLookUp); // result field
      with cdsLookUp do begin
        FieldDefs[0].CreateField(cdsLookUp);
        FieldDefs[1].CreateField(cdsLookUp);
      end;

      // creating
      cdsLookUp.CreateDataSet;
      FClDataSet.CreateDataSet;

      // populating
      PopulateCDS(i);

      // checking
      try
        FClDataSet.First;
        cdsLookUp.First;
        for j := 0 to RECORD_COUNT - 1 do begin
          case FClDataSet.Fields[1].DataType of
          ftLargeint:
            begin
{$IFDEF AnyDAC_D6}
              V1 := TLargeIntField(FClDataSet.Fields[1]).AsLargeInt;
              V2 := TLargeIntField(cdsLookUp.Fields[1]).AsLargeInt;
{$ELSE}
              TVarData(V1).VType := varInt64;
              Decimal(V1).Lo64 := TLargeIntField(FClDataSet.Fields[1]).AsLargeInt;
              TVarData(V2).VType := varInt64;
              Decimal(V2).Lo64 := TLargeIntField(cdsLookUp.Fields[1]).AsLargeInt;
{$ENDIF}
            end
          else
            begin
              V1 := FClDataSet.Fields[1].Value;
              V2 := cdsLookUp.Fields[1].Value;
            end;
          end;
          if Compare(V1, V2) <> 0 then begin
            Error(ErrorLookupFields(FldNames[i], VarToStr(V1), VarToStr(V2)));
            break;
          end;
          FClDataSet.Next;
          cdsLookUp.Next;
        end;
      except
        on E: Exception do
          Error(ErrorOnField(E.Message, cdsLookUp.Fields[1].FullName));
      end;
    end;
  finally
    cdsLookUp.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestFilling;
var
  i: Integer;
begin
  FillClDataSet;
  with FClDataSet do begin
    First;
    i := 0;
    while not Eof and (i < RECORD_COUNT) do begin
      CheckRecord(i);
      Inc(i);
      Next;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestEmpty;
begin
  FillClDataSet;
  FClDataSet.First;
  try
    while not FClDataSet.Eof do
      FClDataSet.Delete;
    FillClDataSet;
    FClDataSet.EmptyDataSet;
  except
    on E: Exception do
      Error(EmptyDSError(E.Message));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestIndexUnicity;
var
  V:        Variant;
  oFld:     TField;
  i, j,
  recCount: Integer;
  oIndex:   TADIndex;
begin
  FillClDataSet;
  for j := 0 to 1 do // ioPrimary..ioUnique
    for i := 0 to FIELD_COUNT - 1 do begin
      oIndex := FClDataSet.Indexes[i * INDEX_COUNT + j];
      if not (IsBooleanField(i) or IsNonTextField(i)) then
        try
          recCount := FClDataSet.RecordCount;
          oIndex.Active := True;
          oIndex.Selected := True;
          with FClDataSet do
            try
              oFld := FieldByName(FldNames[i]);
              V := oFld.Value;
              try
                Append;
                SetFieldValue(oFld, V);
                Post;
                Delete;
                Error(UniqueIndexError(oIndex.Name));
              except
                Cancel;
              end;
            finally
              oIndex.Selected := False;
              oIndex.Active := False;
              if recCount <> FClDataSet.RecordCount then begin
                Error(UnSelectIndexError(oIndex.Name));
                while recCount < FClDataSet.RecordCount do begin
                  Last;
                  Delete;
                end;
              end;
            end;
        except
          on E: Exception do begin
            oIndex.Active := False;
            Error(ActivateIndexError(oIndex.Name, E.Message));
          end;
        end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestIndexDescention;
var
  i: Integer;
  oIndex: TADIndex;
begin
  FillClDataSet;
  for i := 0 to FIELD_COUNT - 1 do begin
    oIndex := FClDataSet.Indexes[i * INDEX_COUNT + 2]; // soDescendingGS
    if not IsNonTextField(i) then
      try
        oIndex.Active := True;
        oIndex.Selected := True;
        try
          FClDataSet.First;
          if FClDataSet.FieldByName('ftString').AsString <> Strings[DescendNums[i]] then
            Error(DescendIndexError(oIndex.Name));
        finally
          oIndex.Active := False;
          oIndex.Selected := False;
        end;
      except
        on E: Exception do begin
          oIndex.Active := False;
          Error(ActivateIndexError(oIndex.Name, E.Message));
        end;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestIndexCaseInsensibility;
var
  i: Integer;
  oIndex: TADIndex;
begin
  FillClDataSet;
  for i := 0 to FIELD_COUNT - 1 do begin
    oIndex := FClDataSet.Indexes[i * INDEX_COUNT + 3]; // ioCaseInsensetive
    if IsStringField(i) then
    try
      oIndex.Active := True;
      oIndex.Selected := True;
      try
        FClDataSet.First;
        if (AnsiCompareText(FClDataSet.FieldByName('ftString').AsString,
                            Strings[CaseInsensNums1[i]]) <> 0) and
           (AnsiCompareText(FClDataSet.FieldByName('ftString').AsString,
                            Strings[CaseInsensNums2[i]]) <> 0) then begin
          Error(CaseInsensIndexError(oIndex.Name));
          Exit;
        end;
      finally
        oIndex.Active := False;
        oIndex.Selected := False;
      end;
    except
      on E: Exception do begin
        oIndex.Active := False;
        Error(ActivateIndexError(oIndex.Name, E.Message));
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestFindKey;
var
  i, j: Integer;
  oIndex: TADIndex;
  oFld: TField;
  lPrevRO: Boolean;
begin
  FillClDataSet;
  for i := 0 to FIELD_COUNT - 1 do
    if not IsNonTextField(i) then
      for j := 0 to INDEX_COUNT - 1 do begin
        oIndex := FClDataSet.Indexes[i * INDEX_COUNT + j];
        try
          oIndex.Active := True;
          oIndex.Selected := True;
          try
            FClDataSet.SetKey;
            oFld := FClDataSet.FieldByName(FldNames[i]);
            lPrevRO := oFld.ReadOnly;
            oFld.ReadOnly := True;
            try
              SetFieldValue(oFld, GetDefaultValue(i));
              if not FClDataSet.GotoKey then
                Error(FindKeyError(FldNames[i], oIndex.Name));
            finally
              oFld.ReadOnly := lPrevRO;
            end;
          finally
            oIndex.Active := False;
            oIndex.Selected := False;
          end;
        except
          on E: Exception do begin
            oIndex.Active := False;
            Error(ActivateIndexError(oIndex.Name, E.Message));
          end;
        end;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestLocateLookup;
var
  i, j, k:     Integer;
  V, KeyValue,
  ResultValue: Variant;
  NoOptions:   Boolean;
  oOptions:    TLocateOptions;
  oIndex:      TADIndex;
  Flds:        String;
  bmk1, bmk2:  TBookmark;
begin
  FillClDataSet;
  for i := 0 to FIELD_COUNT - 1 do
    if not IsNonTextField(i) then
      for k := 0 to 1 do begin
        if ((k = 0) or (i <> 0) and (FldTypes[i] <> ftLargeInt)) then
          for j := 0 to 2 do
            if (IsStringField(i) or (j = 0)) and ((k < 1) or (i > 0)) then begin
              NoOptions := False;
              case j of
                0:
                  begin
                    oOptions := [];
                    NoOptions := True;
                    if k = 0 then
                      KeyValue := GetMinValue(i)
                    else
                      KeyValue := VarArrayOf([GetMinValue(i), Strings[LookupNums[i]]]);
                    ResultValue := Strings[LookupNums[i]];
                  end;
                1:
                  begin
                    oOptions := [loCaseInsensitive];
                    if FldTypes[i] = ftWideString then
                      KeyValue := WideStrings[LocateCINums[i][0]]
                    else
                      KeyValue := Strings[LocateCINums[i][0]];
                    ResultValue := Strings[LocateCINums[i][1]];
                  end;
                2:
                  begin
                    oOptions := [loPartialKey];
                    if FldTypes[i] = ftWideString then
                      KeyValue := WideStrings[LocatePKNums[i][0]]
                    else
                      KeyValue := Strings[LocatePKNums[i][0]];
                    ResultValue := Strings[LocatePKNums[i][1]];
                  end;
              end;
              if NoOptions then begin
                if k = 0 then begin
                  oIndex := FClDataSet.Indexes[i * INDEX_COUNT];
                  try
                    oIndex.Active := True;
                    oIndex.Selected := True;
                    bmk1 := nil;
                    bmk2 := nil;
                    try
                      if not FClDataSet.Locate(FldNames[i], KeyValue, []) then
                        Error(LocateError(FldNames[i]));
                      bmk1 := FClDataSet.GetBookmark;
                      V := FClDataSet.Lookup(FldNames[i], KeyValue, 'ftString');
                      bmk2 := FClDataSet.GetBookmark;
                      if V <> ResultValue then
                        Error(LookupError(FldNames[i], VarToStr(V), VarToStr(ResultValue)));
                      if FClDataSet.CompareBookmarks(bmk1, bmk2) <> 0 then
                        Error(LocRecPosChangedErrorMsg);
                    finally
                      if bmk1 <> nil then
                        FClDataSet.FreeBookmark(bmk1);
                      if bmk2 <> nil then
                        FClDataSet.FreeBookmark(bmk2);
                      oIndex.Active := False;
                      oIndex.Selected := False;
                    end;
                  except
                    on E: Exception do begin
                      oIndex.Active := False;
                      Error(ActivateIndexError(oIndex.Name, E.Message));
                    end;
                  end;
                end
                else begin
                  bmk1 := nil;
                  bmk2 := nil;
                  try
                    Flds := FldNames[i] + ';' + FldNames[0];
                    if not FClDataSet.Locate(Flds, KeyValue, []) then
                      Error(LocateError(Flds));
                    bmk1 := FClDataSet.GetBookmark;
                    V := FClDataSet.Lookup(Flds, KeyValue, 'ftString');
                    bmk2 := FClDataSet.GetBookmark;
                    if V <> ResultValue then
                      Error(LookupError(Flds, VarToStr(V), VarToStr(ResultValue)));
                    if FClDataSet.CompareBookmarks(bmk1, bmk2) <> 0 then
                      Error(LocRecPosChangedErrorMsg);
                  finally
                    if bmk1 <> nil then
                      FClDataSet.FreeBookmark(bmk1);
                    if bmk2 <> nil then
                      FClDataSet.FreeBookmark(bmk2);
                  end;
                end;
              end
              else begin
                if FClDataSet.Locate(FldNames[i], KeyValue, oOptions) then begin
                  if FClDataSet.FieldByName('ftString').AsString <> ResultValue then
                    Error(LocateWithOptionsError(FldNames[i], oOptions));
                end
                else
                  Error(LocateError(FldNames[i]));
              end;
            end;
      end;
  bmk1 := nil;
  bmk2 := nil;
  try
    bmk1 := FClDataSet.GetBookmark;
    FClDataSet.Locate('ftString', 'no such value', []);
    bmk2 := FClDataSet.GetBookmark;
    if FClDataSet.CompareBookmarks(bmk1, bmk2) <> 0 then
      Error(LocRecPosChangedErrorMsg);
  finally
    if bmk1 <> nil then
      FClDataSet.FreeBookmark(bmk1);
    if bmk2 <> nil then
      FClDataSet.FreeBookmark(bmk2);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestNavigation;
var
  i: Integer;
begin
  FillClDataSet;
  with FClDataSet do begin
    First;
    Prior;
    if FieldByName('ftString').AsString <> Strings[0] then
      Error(NavigationError('Prior'));
    for i := 0 to 2 do begin
      Next;
      if FieldByName('ftString').AsString <> Strings[i + 1] then begin
        Error(NavigationError('Next'));
        Break;
      end;
    end;
    Last;
    if FieldByName('ftString').AsString <> Strings[RECORD_COUNT - 1] then
      Error(NavigationError('Last'));
    if FieldByName('ftString').AsString <> Strings[RECORD_COUNT - 1] then
      Error(NavigationError('Next'));
    for i := RECORD_COUNT - 1 downto RECORD_COUNT - 3 do begin
      Prior;
      if FieldByName('ftString').AsString <> Strings[i - 1] then begin
        Error(NavigationError('Prior'));
        Break;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestFilter;
var
  i, j: Integer;
  str: String;
  NoOptions: Boolean;
  oOptions: TFilterOptions;
{$IFDEF AnyDAC_D6}
  prevDateSeparator:   Char;
  prevShortTimeFormat,
  prevShortDateFormat: String;
{$ENDIF}  
begin
  FillClDataSet;
{$IFDEF AnyDAC_D6}
  prevShortDateFormat := ShortDateFormat;
  prevShortTimeFormat := ShortTimeFormat;
  prevDateSeparator   := DateSeparator;
{$ENDIF}
  for i := 0 to FIELD_COUNT - 1 do
    if not IsNonTextField(i) and (FldTypes[i] <> ftLargeInt) and (FldTypes[i] <> ftWideString) then
      for j := 0 to 2 do
        if IsStringField(i) or (j = 0) then begin
          NoOptions := False;
          oOptions := [];
          case j of
            0: NoOptions := True;
            1: oOptions := [foCaseInsensitive];
            2: oOptions := [foNoPartialCompare];
          end;
          with FClDataSet do
            try
{$IFDEF AnyDAC_D6}
              if FldTypes[i] = ftTimeStamp then begin
                ShortDateFormat := 'mm/dd/yyyy';
                ShortTimeFormat := 'hh:mm:ss';
                DateSeparator   := '/';
              end;
{$ENDIF}
              str := VarToStr(GetDefaultValue(i, False));
              FilterOptions := oOptions;
              if IsStringField(i) then
                str := FldNames[i] + ' <> ''' + str + '*'''
              else if IsNumericField(i) then
                str := FldNames[i] + ' <> ' + str
              else
                str := FldNames[i] + ' <> ''' + str + '''';
              try
                Filter := str;
                Filtered := True;
                str := FieldByName('ftString').AsString;
                if (j = 1) and (RecordCount <> RECORD_COUNT - 3) or
                   (j = 2) and  (RecordCount <> RECORD_COUNT) or
                   NoOptions and (RecordCount <> RECORD_COUNT - 2) and IsStringField(i) or
                   NoOptions and (RecordCount <> RECORD_COUNT - 1) and not IsStringField(i) then
                  Error(FilterError(FldNames[i], oOptions));
                if str <> FieldByName('ftString').AsString then
                  Error(FilterCountError);
              except
                on E: Exception do
                  Error(CantCreateFilter(FldNames[i]));
              end;
{$IFDEF AnyDAC_D6}
              if FldTypes[i] = ftTimeStamp then begin
                DateSeparator := prevDateSeparator;
                ShortTimeFormat := prevShortTimeFormat;
                ShortDateFormat := prevShortDateFormat;
              end;
{$ENDIF}              
            finally
              Filtered := False;
              Filter := '';
            end;
        end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestSetRange;
var
  i, j, recCnt: Integer;
  oIndex: TADIndex;
  VMin, VMax: Variant;
begin
  FillClDataSet;
  recCnt := FClDataSet.RecordCount;
  for i := 0 to FIELD_COUNT - 1 do
    if not IsNonTextField(i) and (FldTypes[i] <> ftLargeInt) then
      for j := 0 to INDEX_COUNT - 1 do begin
        oIndex := FClDataSet.Indexes[i * INDEX_COUNT + j];
        try
          oIndex.Active := True;
          oIndex.Selected := True;
          try
            GetRangeValue(i, VMin, VMax);
            if soDescending in oIndex.Options then
              FClDataSet.SetRange([VMax], [VMin])
            else
              FClDataSet.SetRange([VMin], [VMax]);
            try
              if FClDataSet.RecordCount <> SetRangeNums[i] then
                Error(SetRangeError(FldNames[i], oIndex.Name));
            finally
              FClDataSet.CancelRange;
              if FClDataSet.RecordCount <> recCnt then
                Error(CancelRangeError(FldNames[i], oIndex.Name));
            end;
          finally
            oIndex.Active := False;
            oIndex.Selected := False;
          end;
        except
          on E: Exception do begin
            oIndex.Active := False;
            Error(ActivateIndexError(oIndex.Name, E.Message));
          end;
        end;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestMasterDetail;
var
  oDetailDS: TADClientDataSet;
  i: Integer;

  function IsRightFilterCount(FilterCount, FieldNum: Integer): Boolean;
  begin
    Result := (FilterCount = 1) or
              (FilterCount = 2) and (IsStringField(FieldNum) or IsNonTextField(FieldNum)) and
              (AnsiCompareText(oDetailDS.FieldByName(FldNames[i]).AsString, Strings[0]) = 0) or
              (FilterCount = 9) and IsBooleanField(FieldNum);
  end;

begin
  FillClDataSet;
  FClDataSet.EnableControls;
  oDetailDS := TADClientDataSet.Create(nil);
  with oDetailDS do
    try
      IndexesActive := False;
      AggregatesActive := False;
      CloneCursor(FClDataSet, False);
      MasterSource := FDataSource;
      for i := 0 to FIELD_COUNT - 1 do
        if not IsNonTextField(i) then begin
          IndexFieldNames := FldNames[i];
          MasterFields := FldNames[i];
          if not IsRightFilterCount(RecordCount, i) then
            Error(MasterDetailError(FldNames[i]));
        end;
    finally
      Free;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestAggregates;
var
  i, k:    Integer;
  oAgg:    TADAggregate;
  eKind:   TADAggregateKind;
  Res,
  IdxOk:   Boolean;
  oIndex:  TADIndex;
  C1, C2:  Currency;
  VRes:    Variant;
{$IFDEF AnyDAC_D6}
  B:       TBcd;
{$ENDIF}  
begin
  FillClDataSet;
  for i := 0 to FIELD_COUNT - 1 do
    if not IsNonTextField(i) then
    for k := 0 to INDEX_COUNT do begin
      IdxOk := False;
      oIndex := nil;
      if k < INDEX_COUNT then begin
        try
          oIndex := FClDataSet.Indexes[i * INDEX_COUNT + k];
          oIndex.Active := True;
          oIndex.Selected := True;
          IdxOk := True;
        except
          on E: Exception do begin
            oIndex.Active := False;
            Error(ActivateIndexError(oIndex.Name, E.Message));
          end;
        end;
      end
      else
        IdxOk := True;
      if IdxOk then
        try
          for eKind := Low(TADAggregateKind) to High(TADAggregateKind) do
            if not (eKind in [akFirst, akLast]) and
               (IsNumericField(i) or not (eKind in [akSum, akAvg])) then begin
              oAgg := FClDataSet.Aggregates.Add;
              with oAgg do begin
                case eKind of
                  akSum:   Expression := 'sum(' + FldNames[i] + ')';
                  akAvg:   Expression := 'avg(' + FldNames[i] + ')';
                  akCount: Expression := 'count(*)'; // not suported: '(' + FldNames[i] + ')';
                  akMin:   Expression := 'min(' + FldNames[i] + ')';
                  akMax:   Expression := 'max(' + FldNames[i] + ')';
                end;
                Name := Expression;
                if oIndex <> nil then
                  IndexName := oIndex.Name
                else begin
                  IndexName := '';
                end;
                Active := True;
                try
                  case eKind of
                    akSum:   VRes := GetSumValue(i);
                    akAvg:   VRes := GetAggValue(i);
                    akCount: VRes := RECORD_COUNT;
                    akMin:   VRes := GetMinValue(i);
                    akMax:   VRes := GetMaxValue(i);
                  end;

                  if VarIsNull(Value) then
                    Res := False
                  else if FldTypes[i] = ftFloat then
                    Res := abs(Value - VRes) <= 0.000001
                  else if FldTypes[i] in [ftCurrency, ftBcd] then begin
                    C1 := Value;
                    C2 := VRes;
                    Res := abs(C1 - C2) <= 0.1;
                  end
{$IFDEF AnyDAC_D6}
                  else if FldTypes[i] = ftFMTBcd then begin
                    BcdSubtract(VarToBcd(Value), VarToBcd(VRes), B);
                    if BCDToCurr(B, C1) then
                      Res := (abs(C1) <= 0.0001)
                    else
                      Res := False;
                  end
{$ENDIF}
                  else if IsStringField(i) and (k = Integer(soNoCase)) then
                    Res := UpperCase(VRes) = UpperCase(Value)
                  else
                    Res := Value = VRes;
                  if not Res then
                    Error(AggregatesError(AggKindNames[eKind], FldNames[i], IndexName));
                finally
                  Active := False;
                end;
              end;
            end;
        finally
          if oIndex <> nil then begin
            oIndex.Selected := False;
            oIndex.Active := False;
          end;
        end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestCloneCursor;
var
  oClonedDS: TADClientDataSet;
  C1, C2: TADClientDataSet;
begin
  FillClDataSet;
  oClonedDS := TADClientDataSet.Create(nil);
  try
    oClonedDS.CloneCursor(FClDataSet, False);
    // open issue
  finally
    oClonedDS.Free;
  end;

  // Provided by Lazy Cat
  C1 := TADClientDataSet.Create(nil);
  with C1.FieldDefs.AddFieldDef do
  begin
    Name := 'id';
    DataType := ftInteger;
  end;
  C1.CreateDataSet;
  // сейчас C1.FFilterView.Name = _AD_FLT_
  C1.AppendRecord([1]);
  C1.AppendRecord([2]);
  C1.AppendRecord([3]);
  C1.AppendRecord([4]);

  C2 := TADClientDataSet.Create(nil);
  C2.CloneCursor(C1, True);

  C2.Filter := 'id > 1';
  C2.Filtered := True;

  C1.Filter := 'id > 1';
  C1.Filtered := True;
  // сейчас C1.FFilterView.Name = _AD_FLT_2
  C1.Filtered := False;
  // сейчас C1.FFilterView.Name = _AD_FLT_3 и счетчик ссылок = 2

  C2.Close;
  // сейчас C1.FFilterView.Name = _AD_FLT_3 и счетчик ссылок = 1
  C1.Free;
  // сейчас в TADDataSet.ResetViews попытка _дважды_
  // уменьшить счетчик ссылок на C1.FFilterView => AV
  C2.Free;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestDefineFields;
var
  i: Integer;
begin
  FClDataSet.Close;
  FClDataSet.FieldDefs.Clear;
  FClDataSet.IndexDefs.Clear;
  FClDataSet.Indexes.Clear;
  FClDataSet.Aggregates.Clear;
  try
    for i := 0 to 4 do
      DefineFieldDS(i);
    try
      FClDataSet.CreateDataSet;
    except
      on E: Exception do
        Error(DefineFieldsError(E.Message));
    end;
    FillingValues;
    FClDataSet.Close;
    DeleteFieldDS(0);
    DeleteFieldDS(1);
    FClDataSet.CreateDataSet;
    FillingValues;
    FClDataSet.Close;
    try
      DefineFieldDS(2);
      Error(DefineExistingFieldError);
    except
    end;
    FClDataSet.CreateDataSet;
    FillingValues;
    FClDataSet.Close;
    try
      DefineFieldDS(0);
      DefineFieldDS(0);
      Error(DefineSameFieldsError);
    except
    end;
    FClDataSet.CreateDataSet;
    FillingValues;
  except
    on E: Exception do
      Error(E.Message);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestFetching;
var
  i: Integer;
  V1, V2: Variant;
begin
  if not CompConnSwitch then begin
    Error(CannotContinueTest);
    Exit;
  end;
  GetParamsArray;
  if Insert then begin
    if FRDBMSKind = mkMSAccess then
      Sleep(550);
    if FRDBMSKind = mkDB2 then
      Sleep(0);
    FSelCommand.Connection  := FConnection;
    FSelCommand.CommandText.Text := 'select * from {id ADQA_All_types}';
    FAdapter.SelectCommand  := FSelCommand;
    FClDataSet.Adapter      := FAdapter;

    FClDataSet.Open;

    for i := 0 to FVarFieldList.Count - 1 do begin
      if FVarFieldList.IsOfUnknownType(i) then
        continue;

      V1 := FClDataSet.Fields[i].Value;
      V2 := FVarFieldList.VarValues[i];
      if Compare(V1, V2, FVarFieldList.Types[i]) <> 0 then
        Error(WrongValInQryField(FClDataSet.Fields[i].FullName, VarToStr(V1), VarToStr(V2)));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCDSTsHolder.TestEditing;
var
  i: Integer;
  WrongList: TStringList;

  procedure AppendData;
  var
    i: Integer;
  begin
    for i := 0 to RECORD_COUNT - 1 do
      with FClDataSet do begin
        Append;
        FieldByName('ftString').AsString := Strings[i];
        FieldByName('ftSmallInt').AsInteger := SmallInts[i];
        FieldByName('ftInteger').AsInteger := Integers[i];
        FieldByName('ftWord').AsInteger := Words[i];
        FieldByName('ftBoolean').AsBoolean := Booleans[i];
        FieldByName('ftFloat').AsFloat := Floats[i];
        FieldByName('ftCurrency').AsCurrency := Currencies[i];
        FieldByName('ftBCD').AsCurrency := Bcds[i];
        FieldByName('ftDate').AsDateTime := Dates[i];
        FieldByName('ftTime').AsDateTime := Times[i];
        FieldByName('ftDateTime').AsDateTime := DateTimes[i];
        FieldByName('ftBytes').AsString := Bytes[i];
        FieldByName('ftVarBytes').AsString := VarBytes[i];
        FieldByName('ftAutoInc').AsInteger := AutoIncs[i];
        FieldByName('ftBlob').AsString := Blobs[i];
        FieldByName('ftMemo').AsString := Memos[i];
        FieldByName('ftFixedChar').AsString := FixedChars[i];
        TWideStringField(FieldByName('ftWideString')).Value := WideStrings[i];
        TGuidField(FieldByName('ftGuid')).AsGuid := StringToGUID(Guids[i]);
        FieldByName('ftLargeInt').AsInteger := Integers[i];
        FieldByName('ftTimeStamp').AsDateTime := Dates[i];
        FieldByName('ftFMTBcd').AsCurrency := Bcds[i];
        Post;
      end;
  end;

  procedure EditData;
  begin
    with FClDataSet do begin
      First;
      Edit;
      FieldByName('ftString').AsString := VarToStr(GetMaxValue(0));
      FieldByName('ftSmallInt').AsInteger := GetMaxValue(1);
      FieldByName('ftInteger').AsInteger := GetMaxValue(2);
      FieldByName('ftWord').AsInteger := GetMaxValue(3);
      FieldByName('ftBoolean').AsBoolean := GetMaxValue(4);
      FieldByName('ftFloat').AsFloat := GetMaxValue(5);
      FieldByName('ftCurrency').AsCurrency := GetMaxValue(6);
      FieldByName('ftBCD').AsCurrency := GetMaxValue(7);
      FieldByName('ftDate').AsDateTime := VarToDateTime(GetMaxValue(8));
      FieldByName('ftTime').AsDateTime := VarToDateTime(GetMaxValue(9));
      FieldByName('ftDateTime').AsDateTime := VarToDateTime(GetMaxValue(8)); //Dates
      FieldByName('ftBytes').AsString := VarToStr(GetMaxValue(11));
      FieldByName('ftVarBytes').AsString := VarToStr(GetMaxValue(12));
      FieldByName('ftAutoInc').AsInteger := GetMaxValue(13);
      FieldByName('ftBlob').AsString := VarToStr(GetMaxValue(14));
      FieldByName('ftMemo').AsString := VarToStr(GetMaxValue(15));
      FieldByName('ftFixedChar').AsString := VarToStr(GetMaxValue(16));
      TWideStringField(FieldByName('ftWideString')).Value := VarToStr(GetMaxValue(17));
      TGuidField(FieldByName('ftGuid')).AsGuid := StringToGUID(VarToStr(GetMaxValue(18)));
      FieldByName('ftLargeInt').AsInteger := GetMaxValue(2); // Integers
      FieldByName('ftTimeStamp').AsDateTime := VarToDateTime(GetMaxValue(8)); // Dates
      FieldByName('ftFMTBcd').AsCurrency := GetMaxValue(7); // Bcds
      Post;
    end;
  end;

  procedure GetDistinguishRecord(AList: TStrings);
  var
    Str1, Str2: string;
    r: Double;
  begin
    AList.Clear;
    with FClDataSet do begin
      First;
      if FieldByName('ftString').AsString <> VarToStr(GetMaxValue(0)) then
        AList.Add('ftString');
      if FieldByName('ftSmallInt').AsInteger <> GetMaxValue(1) then
        AList.Add('ftSmallInt');
      if FieldByName('ftInteger').AsInteger <> GetMaxValue(2) then
        AList.Add('ftInteger');
      if FieldByName('ftWord').AsInteger <> GetMaxValue(3) then
        AList.Add('ftWord');
      if FieldByName('ftBoolean').AsBoolean <> GetMaxValue(4) then
        AList.Add('ftBoolean');
      if FieldByName('ftFloat').AsFloat <> GetMaxValue(5) then
        AList.Add('ftFloat');
      r := Abs(FieldByName('ftCurrency').AsCurrency - GetMaxValue(6));
      if r > 0.01 then
        AList.Add('ftCurrency');
      if FieldByName('ftBCD').AsCurrency <> GetMaxValue(7) then
        AList.Add('ftBCD');
      if FieldByName('ftDate').AsDateTime <> VarToDateTime(GetMaxValue(8)) then
        AList.Add('ftDate');
      if FieldByName('ftTime').AsDateTime <> VarToDateTime(GetMaxValue(9)) then
        AList.Add('ftTime');
      if FieldByName('ftDateTime').AsDateTime <> VarToDateTime(GetMaxValue(8)) then //Dates
        AList.Add('ftDateTime');
      Str1 := VarToStr(GetMaxValue(11));
      SetString(Str2, PChar(FieldByName('ftBytes').AsString), Length(Str1));
      if Str1 <> Str2 then
        AList.Add('ftBytes');
      Str1 := VarToStr(GetMaxValue(12));
      SetString(Str2, PChar(FieldByName('ftVarBytes').AsString), Length(Str1));
      if Str1 <> Str2 then
        AList.Add('ftVarBytes');
      if FieldByName('ftAutoInc').AsInteger <> GetMaxValue(13) then
        AList.Add('ftAutoInc');
      if FieldByName('ftBlob').AsString <> VarToStr(GetMaxValue(14)) then
        AList.Add('ftBlob');
      if FieldByName('ftMemo').AsString <> VarToStr(GetMaxValue(15)) then
        AList.Add('ftMemo');
      if FieldByName('ftFixedChar').AsString <> VarToStr(GetMaxValue(16)) then
        AList.Add('ftFixedChar');
      if TWideStringField(FieldByName('ftWideString')).Value <> VarToStr(GetMaxValue(17)) then
        AList.Add('ftWideString');
      if TGuidField(FieldByName('ftGuid')).AsString <> VarToStr(GetMaxValue(18)) then
        AList.Add('ftGuid');
      if FieldByName('ftLargeInt').AsInteger <> GetMaxValue(2) then // Integers
        AList.Add('ftLargeInt');
      if FieldByName('ftTimeStamp').AsDateTime <> VarToDateTime(GetMaxValue(8)) then // Dates
        AList.Add('ftTimeStamp');
      if FieldByName('ftFMTBcd').AsCurrency <> GetMaxValue(7) then // Bcds
        AList.Add('ftFMTBcd');
    end;
  end;

  procedure EmptyClDataSet;
  begin
    if FClDataSet.Table <> nil then
      try
        FClDataSet.Open;
        FClDataSet.EmptyDataSet;
      except
        on E: Exception do
          Error(EmptyDSError(E.Message));
      end;
    DefineClDataSet;
  end;

begin
  with FClDataSet do
    for i := 0 to 1 do begin
      WrongList := TStringList.Create;
      if i = 0 then
        CachedUpdates := True
      else
        CachedUpdates := False;
      try
        try
          EmptyClDataSet;
          AppendData;
          if CachedUpdates then
            ApplyUpdates;
          EditData;
          if CachedUpdates then
            ApplyUpdates;
          GetDistinguishRecord(WrongList);
          if WrongList.Count <> 0 then
            Error(EditFCDSError(WrongList));
        except
          on E: Exception do
            Error(E.Message);
        end;
      finally
        WrongList.Free;
      end;
    end;
end;


initialization

  ADQAPackManager.RegisterPack('Comp Layer', TADQACompCDSTsHolder);

end.
