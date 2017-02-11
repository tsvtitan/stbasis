{-------------------------------------------------------------------------------}
{ AnyDAC Component Layer: TADDataMove tests                                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQACompLayerDTM;

interface

uses
  Classes, Windows, SysUtils, DB,
  ADQAPack, ADQACompLayerCNN,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADDAptIntf,
  daADPhysIntf,
  daADCompClient, daADCompDataMove;

type
  TADQACompDTMTsHolder = class (TADQACompTsHolderBase)
  private
    FDataMove: TADDataMove;
    procedure EmptyTable(ADbToAscii: Boolean = False);
    procedure InsertToAsciiTab;
    procedure SetAsciiFields(ADbToAscii: Boolean = False);
  public
    constructor Create(const AName: String); override;
    destructor Destroy; override;
    procedure ClearAfterTest; override;
    procedure RegisterTests; override;
    procedure TestAsciiToRdbms;
    procedure TestAsciiToIdentityTab;
    procedure TestRdbmsToAscii;
    procedure TestRdbmsToRdbms;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, DateUtils,
{$ENDIF}
  daADStanUtil, daADStanConst,
  ADQAConst, ADQAUtils, ADQAVarField;

{-------------------------------------------------------------------------------}
{ TADQACompDTMTsHolder                                                          }
{-------------------------------------------------------------------------------}
procedure TADQACompDTMTsHolder.RegisterTests;
begin
  RegisterTest('DataMove;ASCII - RDBMS;DB2',       TestAsciiToRdbms, mkDB2);
  RegisterTest('DataMove;ASCII - RDBMS;MS Access', TestAsciiToRdbms, mkMSAccess);
  RegisterTest('DataMove;ASCII - RDBMS;MSSQL',     TestAsciiToRdbms, mkMSSQL);
  RegisterTest('DataMove;ASCII - RDBMS;ASA',       TestAsciiToRdbms, mkASA);
  RegisterTest('DataMove;ASCII - RDBMS;MySQL',     TestAsciiToRdbms, mkMySQL);
  RegisterTest('DataMove;ASCII - RDBMS;Oracle',    TestAsciiToRdbms, mkOracle);
  RegisterTest('DataMove;ASCII - RDBMS;Identity;DB2',       TestAsciiToIdentityTab, mkDB2);
  RegisterTest('DataMove;ASCII - RDBMS;Identity;MS Access', TestAsciiToIdentityTab, mkMSAccess);
  RegisterTest('DataMove;ASCII - RDBMS;Identity;MSSQL',     TestAsciiToIdentityTab, mkMSSQL);
  RegisterTest('DataMove;ASCII - RDBMS;Identity;ASA',       TestAsciiToIdentityTab, mkASA);
  RegisterTest('DataMove;ASCII - RDBMS;Identity;MySQL',     TestAsciiToIdentityTab, mkMySQL);
  RegisterTest('DataMove;ASCII - RDBMS;Identity;Oracle',    TestAsciiToIdentityTab, mkOracle);
  RegisterTest('DataMove;RDBMS - ASCII;DB2',       TestRdbmsToAscii, mkDB2);
  RegisterTest('DataMove;RDBMS - ASCII;MS Access', TestRdbmsToAscii, mkMSAccess);
  RegisterTest('DataMove;RDBMS - ASCII;MSSQL',     TestRdbmsToAscii, mkMSSQL);
  RegisterTest('DataMove;RDBMS - ASCII;ASA',       TestRdbmsToAscii, mkASA);
  RegisterTest('DataMove;RDBMS - ASCII;MySQL',     TestRdbmsToAscii, mkMySQL);
  RegisterTest('DataMove;RDBMS - ASCII;Oracle',    TestRdbmsToAscii, mkOracle);
  RegisterTest('DataMove;RDBMS - RDBMS;DB2',       TestRdbmsToRdbms, mkDB2);
  RegisterTest('DataMove;RDBMS - RDBMS;MS Access', TestRdbmsToRdbms, mkMSAccess);
  RegisterTest('DataMove;RDBMS - RDBMS;MSSQL',     TestRdbmsToRdbms, mkMSSQL);
  RegisterTest('DataMove;RDBMS - RDBMS;ASA',       TestRdbmsToRdbms, mkASA);
  RegisterTest('DataMove;RDBMS - RDBMS;MySQL',     TestRdbmsToRdbms, mkMySQL);
  RegisterTest('DataMove;RDBMS - RDBMS;Oracle',    TestRdbmsToRdbms, mkOracle);
end;

{-------------------------------------------------------------------------------}
constructor TADQACompDTMTsHolder.Create(const AName: String);
begin
  inherited Create(AName);
  FDataMove := TADDataMove.Create(nil);
  with FDataMove do begin
    Options := [poClearDest, poClearDestNoUndo, poAbortOnExc];
    LogFileAction := laNone;
    with AsciiDataDef do begin
      FormatSettings.DateSeparator := '-';
      FormatSettings.ShortDateFormat := 'yyyy/mm/dd';
      FormatSettings.ShortTimeFormat := 'hh:mm:ss';
      FormatSettings.DecimalSeparator := '.';
      WithFieldNames := True;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
destructor TADQACompDTMTsHolder.Destroy;
begin
  FDataMove.Free;
  FDataMove := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompDTMTsHolder.ClearAfterTest;
begin
  FQuery.Close;
  FDataMove.AsciiDataDef.Fields.Clear;
  inherited ClearAfterTest;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompDTMTsHolder.TestAsciiToRdbms;
var
  V1, V2: Variant;
  sTable: String;

  procedure MoveAllTypes(AComment: String = '');
  var
    i, j, k: Integer;

    function FieldsAreNull: Boolean;
    var
      i: Integer;
    begin
      Result := True;
      for i := 0 to FQuery.Fields.Count - 1 do begin
        Result := Result and VarIsNull(FQuery.Fields[i].Value);
        if not Result then
          case FQuery.Fields[i].DataType of
          ftBoolean:
            if FQuery.Fields[i].Value = False then
              Result := True;
          ftString,
          ftMemo,
          ftBlob:
            begin
              if FQuery.Fields[i].Value = '' then
                Result := True;
            end;
          ftBytes:
            Result := True;
          else
            Exit;
          end;
      end;
    end;

  begin
    with FDataMove do begin
      AsciiFileName := ADExpandStr('$(ADHOME)\DB\Data\' + sTable + '_' + GetDBMSName(FRDBMSKind));

      if AsciiDataDef.RecordFormat = rfCommaDoubleQuote then begin
        AsciiFileName := AsciiFileName + '.csv';
        AsciiDataDef.WithFieldNames := True;
      end
      else if AsciiDataDef.RecordFormat = rfFieldPerLine then
        AsciiFileName := AsciiFileName + '1.csv'
      else if AsciiDataDef.RecordFormat = rfFixedLength then
        AsciiFileName := AsciiFileName + '2.csv';

      SourceKind  := skAscii;
      Destination := FQuery;

      FQuery.SQL.Text := Format(SelectFromStmt, [sTable]);
      {if FDataMove.Mode in [dmAppendUpdate, dmUpdate, dmDelete] then
        FQuery.IndexFieldNames := GetIndexFlds[FRDBMSKind];}
      try
        try
          Execute;
          FQuery.Open;

          case FDataMove.Mode of
          dmAlwaysInsert:
            begin
              if FQuery.RecordCount <> 2 then begin
                Error(RecCountIsWrong(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                      FQuery.RecordCount, 2, AComment));
                Exit;
              end;
              i := -1;
              with FVarFieldList do
                while not FQuery.Eof do begin
                  Inc(i);
                  if FieldsAreNull then begin
                    Error(AllFieldsAreNull(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                                           AComment));
                    Exit;
                  end;
                  k := 0;
                  for j := 0 to FQuery.Fields.Count - 1 do begin
                    if IsOfUnknownType(j) then
                      continue;
                    if (i <> 1) then begin
                      if FRDBMSKind <> mkOracle then
                        k := j;
                      V1 := Null;
                      V1 := FQuery.Fields[k].Value;
                      V2 := VarValues[j];
                      try
                        if Compare(V1, V2, Types[j]) <> 0 then begin
                          if VarIsNull(V1) then
                            V1 := '';
                          Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                                VarToStr(V1), VarToStr(V2), AComment + '. Field - ' +
                                FQuery.Fields[j].FullName));
                          Exit;
                        end;
                      except
                        on E: Exception do begin
                          Error(ErrorOnCompareVal(FQuery.Fields[j].FullName, E.Message));
                          Exit;
                        end;
                      end;
                    end
                    else begin
                      V2 := FQuery.Fields[NullInField[FRDBMSKind]].Value;
                      if FQuery.Fields[NullInDateField[FRDBMSKind]].AsDateTime <> 0 then
                        Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                              VarToStr(FQuery.Fields[NullInDateField[FRDBMSKind]].Value),
                              '0000-00-00 00:00:00', AComment + '. Field - ' +
                              FQuery.Fields[NullInDateField[FRDBMSKind]].FullName));
                      if ((VarType(V2) = varString) and (VarToValue(V2, '') <> '')) or ((VarType(V2) = varSmallint) and (V2 <> 0)) then
                        Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                              VarToStr(FQuery.Fields[NullInField[FRDBMSKind]].Value),
                              '', AComment + '. Field - ' +
                              FQuery.Fields[NullInField[FRDBMSKind]].FullName));
                      break;
                    end;
                    if FRDBMSKind = mkOracle then
                      Inc(k);
                  end;
                  FQuery.Next;
                end;
              end;
          end;
        except
          on E: Exception do
            Error(ErrorOnPumpExec(E.Message,
                  DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat], AComment));
        end;
      finally
        FQuery.IndexFieldNames := '';
        FQuery.Close;
      end;
    end;
  end;

  procedure CheckMoving;
  begin
    // dmAlwaysInsert
    FDataMove.Mode := dmAlwaysInsert;
    // 1. Moving into the empty table
    EmptyTable;
    MoveAllTypes('Move into empty table');

    // 2. Moving into the full table
    EmptyTable;
    GetParamsArray;
    if FRDBMSKind = mkOracle then
      with FVarFieldList do begin
        Types[4]  := ftUnknown;
        Types[5]  := ftUnknown;
        Types[12] := ftUnknown;
        Types[13] := ftUnknown;
      end;
    Insert(FRDBMSKind = mkOracle);
    MoveAllTypes('Move into full table');
  end;

begin
  GetParamsArray;
  if FRDBMSKind = mkOracle then
    sTable := 'ADQA_All_types_DTM'
  else
    sTable := 'ADQA_All_types';
  FDataMove.AsciiDataDef.WithFieldNames := True;
  FDataMove.AsciiDataDef.RecordFormat := rfCommaDoubleQuote;
  CheckMoving;

  FDataMove.AsciiDataDef.WithFieldNames := True;
  FDataMove.AsciiDataDef.RecordFormat := rfFieldPerLine;
  CheckMoving;

  FDataMove.AsciiDataDef.WithFieldNames := True;
  FDataMove.AsciiDataDef.RecordFormat := rfFixedLength;
  SetAsciiFields;
  CheckMoving;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompDTMTsHolder.TestAsciiToIdentityTab;
var
  sTable: String;
  i: Integer;
  V1, V2: Variant;

  procedure PrepareTest;
  begin
    with FQuery do begin
      SQL.Text := Format(DeleteFromStmt, [sTable]);
      ExecSQL;
    end;
  end;

begin
  sTable := 'ADQA_Identity_tab';
  PrepareTest;
  with FDataMove do begin
    AsciiFileName := ADExpandStr('$(ADHOME)\DB\Data\' + sTable + '.csv');
    AsciiDataDef.WithFieldNames := True;
    AsciiDataDef.RecordFormat := rfCommaDoubleQuote;
    SourceKind  := skAscii;
    Destination := FQuery;

    FQuery.SQL.Text := Format(SelectFromStmt, [sTable]);

    try
      Execute;
      FQuery.Open;
    except
      on E: Exception do begin
        Error(ErrorOnPumpExec(E.Message,
              DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
              'ADQA_Identity_tab'));
        Exit;
      end;
    end;

    i := 0;
    with FQuery do
      while not Eof do begin
        V1 := FQuery.Fields[0].AsInteger;
        V2 := 1100 + i;
        if V1 <> V2 then
          Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                                VarToStr(V1), VarToStr(V2),
                                'ADQA_Identity_tab. Field - ' +
                                FQuery.Fields[0].FullName));

        V1 := FQuery.Fields[1].AsString;
        V2 := 'str' + IntToStr(i + 1);
        if V1 <> V2 then
          Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                                VarToStr(V1), VarToStr(V2),
                                'ADQA_Identity_tab. Field - ' +
                                FQuery.Fields[1].FullName));
        Inc(i);
        Next;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompDTMTsHolder.EmptyTable(ADbToAscii: Boolean = False);
var
  sTable: String;
begin
  if (FRDBMSKind <> mkOracle) and not ADbToAscii then
    sTable := 'ADQA_All_types'
  else
    sTable := 'ADQA_All_types_DTM';
  if ADbToAscii then
    sTable := 'ADQA_Ascii_types';

  FConnection.StartTransaction;
  with FQuery do begin
    SQL.Text := Format(DeleteFromStmt, [sTable]);
    ExecSQL;
  end;
  FConnection.Commit;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompDTMTsHolder.TestRdbmsToAscii;

  procedure CheckFile;
  var
    oTestList: TStringList;
    sField, sTestField,
    sTestFields: String;
    cDelim: Char;
    i, j: Integer;

    function GetStringFromBinary(ABin: String): String;
    begin
      ABin := Trim(ABin);
      SetLength(Result, Length(ABin) div 2);
      HexToBin(PChar(ABin), PChar(Result), Length(Result));
    end;

    procedure CheckField(AIndx: Integer; AField: String);
    var
      S1: String;
      rFrmtSettings: TFormatSettings;
      lBoolVal, lIsBoolField: Boolean;
      D1, D2: TDateTime;
{$IFNDEF AnyDAC_D7}
      prevDecSep: Char;
{$ENDIF}
    begin
      S1 := FQuery.Fields[AIndx].AsString;
      case FQuery.Fields[AIndx].DataType of
      ftFloat:
        begin
{$IFDEF AnyDAC_D7}
          rFrmtSettings.DecimalSeparator := '.';
          if Compare(FQuery.Fields[AIndx].AsFloat,
                     StrToFloat(AField, rFrmtSettings), ftFloat) <> 0 then
{$ELSE}
          prevDecSep := DecimalSeparator;
          DecimalSeparator := '.';
          if Compare(FQuery.Fields[AIndx].AsFloat,
                     StrToFloat(AField), ftFloat) <> 0 then
{$ENDIF}
            Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                  AField, S1, FQuery.Fields[AIndx].FullName));
{$IFNDEF AnyDAC_D7}
          DecimalSeparator := prevDecSep;
{$ENDIF}
          Exit;
        end;
      ftString,
      ftMemo:
        if FDataMove.AsciiDataDef.RecordFormat = rfCommaDoubleQuote then
          S1 := Format('%s%s%s', [cDelim, FQuery.Fields[AIndx].AsString, cDelim]);
      ftBytes,
      ftVarBytes,
      ftBlob,
      ftOraBlob:
        AField := GetStringFromBinary(AField);
{$IFDEF AnyDAC_D6}
      ftTimeStamp,
{$ENDIF}      
      ftDate,
      ftTime,
      ftDateTime:
        begin
          with FDataMove.AsciiDataDef do begin
            rFrmtSettings.ShortDateFormat := ShortDateFormat;
            rFrmtSettings.ShortTimeFormat := ShortTimeFormat;
            rFrmtSettings.DateSeparator   := DateSeparator;
            ShortDateFormat := FormatSettings.ShortDateFormat;
            ShortTimeFormat := FormatSettings.ShortTimeFormat;
            DateSeparator   := FormatSettings.DateSeparator;
          end;
          try
            S1 := FQuery.Fields[AIndx].AsString;
            if (AnsiCompareText(FQuery.Fields[AIndx].FullName, 'atTime') = 0) and
               (Compare(S1, AField, ftString) <> 0) then begin
              D1 := StrToDateTime(AField);
              D2 := FQuery.Fields[AIndx].AsDateTime;
              if (D1 - Trunc(D1)) <> (D2 - Trunc(D2)) then
                Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                      AField, S1, FQuery.Fields[AIndx].FullName));
              Exit;
            end;
          finally
            ShortDateFormat := rFrmtSettings.ShortDateFormat;
            ShortTimeFormat := rFrmtSettings.ShortTimeFormat;
            DateSeparator   := rFrmtSettings.DateSeparator;
          end;
        end;
      ftBCD,
      ftSmallInt,
      ftBoolean:
          begin
            lBoolVal := False;
            lIsBoolField := AnsiCompareText(FQuery.Fields[AIndx].FullName, 'atBool') = 0;
            if FQuery.Fields[AIndx].DataType = ftBoolean then
              lBoolVal := FQuery.Fields[AIndx].AsBoolean
            else if lIsBoolField then
              lBoolVal := FQuery.Fields[AIndx].AsInteger <> 0;
            if (Compare(S1, AField, ftString) <> 0) and lIsBoolField then begin
              if lBoolVal then begin
                if (AnsiCompareText(AField, 'T') <> 0) and
                   (AnsiCompareText(AField, 'True') <> 0) then
                  Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                        AField, S1, FQuery.Fields[AIndx].FullName));
              end
              else begin
                if (AnsiCompareText(AField, 'F') <> 0) and
                   (AnsiCompareText(AField, 'False') <> 0) then
                  Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                        AField, S1, FQuery.Fields[AIndx].FullName));
              end;
              Exit;
            end;
          end;
      end;
      if Compare(S1, AField, ftString) <> 0 then
        Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                                AField, S1, FQuery.Fields[AIndx].FullName));
    end;

  begin
    oTestList := TStringList.Create;
    oTestList.LoadFromFile(FDataMove.AsciiFileName);
    try
      case FDataMove.AsciiDataDef.RecordFormat of
      rfCommaDoubleQuote:
        begin
          if FQuery.RecordCount <> (oTestList.Count - 1) then begin
            Error(RecCountIsWrong(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                  oTestList.Count - 1,
                  FQuery.RecordCount, ''));
            Exit;
          end;
          cDelim := FDataMove.AsciiDataDef.Delimiter;
          i := 1;
          j := 0;
          sTestFields := oTestList[0];
          while i <= Length(sTestFields) do begin
            sTestField := ADExtractFieldName(sTestFields, i);
            sField := '"' + FQuery.Fields[j].FullName + '"';
            if Compare(sField, sTestField, ftString) <> 0 then
              Error(WrongInsertedVals(DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat],
                    sTestField, sField, ''));
            Inc(j);
          end;
          FQuery.Next;
          i := 1;
          j := 0;
          sTestFields := oTestList[1];
          while i <= Length(sTestFields) do begin
            sTestField := ADExtractFieldName(sTestFields, i);
            CheckField(j, sTestField);
            Inc(j);
          end;
        end;
      rfFieldPerLine:
        begin
          for i := 0 to oTestList.Count - 1 do begin
            sTestField := oTestList[i];
            CheckField(i, sTestField);
          end;
        end;
      rfFixedLength:
        begin
          sTestFields := oTestList[0];
          j := 1;
          for i := 0 to FQuery.Fields.Count - 1 do begin
            sTestField := Copy(sTestFields, j, FDataMove.AsciiDataDef.Fields[i].FieldSize);
            CheckField(i, sTestField);
            j := j + FDataMove.AsciiDataDef.Fields[i].FieldSize;
          end;
        end;
      end;
    finally
      oTestList.Free;
    end;
  end;

  procedure RunMove(ATable: String);
  var
    sCurFile, sPref: String;
  begin
    sCurFile := ATable + GetDBMSName(FRDBMSKind);
    sPref := GetEnvironmentVariable('Temp');
    if sPref = '' then
      sPref := GetEnvironmentVariable('Tmp');
    if sPref <> '' then
      sPref := sPref + '\';
    with FDataMove do begin
      if AsciiDataDef.RecordFormat = rfCommaDoubleQuote then begin
        sCurFile := sCurFile + 'W.csv';
        AsciiDataDef.WithFieldNames := True;
      end
      else if AsciiDataDef.RecordFormat = rfFieldPerLine then
        sCurFile := sCurFile + 'W1.csv'
      else if AsciiDataDef.RecordFormat = rfFixedLength then
        sCurFile := sCurFile + 'W2.csv';

      sCurFile := sPref + sCurFile;
      AsciiFileName := sCurFile;
      SourceKind  := skDataSet;
      DestinationKind := skAscii;
      Source := FQuery;

      FQuery.SQL.Text := Format(SelectFromStmt, [ATable]);
      try
        Execute;
        FQuery.Open;
      except
        on E: Exception do begin
          Error(ErrorOnPumpExec(E.Message,
                DTMRecFormat[FDataMove.AsciiDataDef.RecordFormat], ''));
          Exit;
        end;
      end;
      CheckFile;
    end;
  end;

begin
  EmptyTable(True);
  InsertToAsciiTab;
  FDataMove.AsciiDataDef.RecordFormat := rfCommaDoubleQuote;
  RunMove('ADQA_Ascii_types');

  FDataMove.AsciiDataDef.RecordFormat := rfFieldPerLine;
  RunMove('ADQA_Ascii_types');

  FDataMove.AsciiDataDef.RecordFormat := rfFixedLength;
  SetAsciiFields(True);
  RunMove('ADQA_Ascii_types');
end;

{-------------------------------------------------------------------------------}
procedure TADQACompDTMTsHolder.TestRdbmsToRdbms;
var
  i, iVal: Integer;
  oSourceQry, oDestQry: TADQuery;
  sTable: String;
  eDestDB: TADRDBMSKind;
  oConn: TADConnection;
  lError, lVal: Boolean;
  D1, D2: TDateTime;
  rVal: Double;

  function InsertToSourceDBTable: Boolean;
  begin
    Result := True;
    with FQuery do begin
      SQL.Text := Format('insert into {id %s} (ftString, ftSmallint, ftInteger, ' +
                  'ftWord, ftBoolean, ftFloat, ftCurrency, ftBcd, ftDate, ftTime, ' +
                  'ftDateTime, ftBytes, ftBlob, ftMemo) values(:ftString, ' +
                  ':ftSmallint, :ftInteger, :ftWord, :ftBoolean, :ftFloat, ' +
                  ':ftCurrency, :ftBcd, :ftDate, :ftTime, :ftDateTime, :ftBytes, ' +
                  ':ftBlob, :ftMemo)', [sTable]);

      Params[0].AsString    := Strings[0];
      Params[1].AsSmallInt  := Smallints[0];
      Params[2].AsInteger   := Integers[0];
      Params[3].AsWord      := Words[0];
(*      if FRDBMSKind in [mkDB2, mkOracle] then
        Params[4].AsSmallInt := Integer(Booleans[0])
      else
*)        Params[4].AsBoolean := Booleans[0];
      Params[5].AsFloat     := Floats[0];
      Params[6].AsCurrency  := Currencies[6];
      Params[7].AsBCD       := Bcds[0];
      Params[8].AsDateTime  := Dates[1];
      Params[9].AsDateTime  := Times[1];
      Params[10].AsDateTime := DateTimes[4];
      Params[11].AsVarByte  := Bytes[0];
      Params[12].AsVarByte  := Blobs[0];
      Params[13].AsString   := Memos[0];

      try
        ExecSQL;
      except
        on E: Exception do begin
          Error(E.Message);
          Result := False;
        end;
      end;
    end;
  end;

begin
  sTable := 'ADQA_DB_types';
  with FQuery do begin
    SQL.Text := Format(DeleteFromStmt, [sTable]);
    ExecSQL;
  end;

  oSourceQry := FQuery;

  oDestQry := TADQuery.Create(nil);       // for another RDBMS
  oConn := TADConnection.Create(nil);
  oConn.LoginPrompt := False;
  oDestQry.Connection := oConn;

  oSourceQry.FormatOptions.OwnMapRules := True;    // for current RDBMS
  oSourceQry.FormatOptions.MapRules.Clear;
  oDestQry.FormatOptions.OwnMapRules := True;
  oDestQry.FormatOptions.MapRules.Clear;
  try
    if InsertToSourceDBTable then
      for eDestDB := Low(TADRDBMSKind) to High(TADRDBMSKind) do begin
        if eDestDB in [mkUnknown, FRDBMSKind, mkOther, mkADS] then
          continue;
        oConn.Close;
        oConn.ConnectionDefName := GetConnectionDef(eDestDB); // connection to another RDBMS

        oSourceQry.SQL.Text := Format(SelectFromStmt, [sTable]);
        oDestQry.SQL.Text := Format(SelectFromStmt, [sTable]);
        with FDataMove do begin
          SourceKind := skDataSet;
          DestinationKind := skDataSet;
          Source := oSourceQry;
          Destination := oDestQry;

          try
            Execute;
          except
            on E: Exception do begin
              Error(ErrorOnPumpExec(E.Message, '', ''));
              Continue;
            end;
          end;
          oSourceQry.Open;
          oDestQry.Open;
          if not CheckRowsCount(nil, oSourceQry.RecordCount, oDestQry.RecordCount) then
            Exit;
          while not oSourceQry.Eof do begin
            for i := 0 to oSourceQry.Fields.Count - 1 do
              case oSourceQry.Fields[i].DataType of
              ftBoolean:
                try
                  if oDestQry.Fields[i].DataType = ftBoolean then
                    lVal := oDestQry.Fields[i].AsBoolean
                  else
                    lVal := Boolean(oDestQry.Fields[i].AsInteger);
                  if Compare(lVal, oSourceQry.Fields[i].AsBoolean) <> 0 then
                    Error(WrongField(oSourceQry.Fields[i].FullName, GetConnectionDef(eDestDB),
                          oDestQry.Fields[i].AsString, oSourceQry.Fields[i].AsString));
                except
                  on E: Exception do
                    Error(ErrorOnCompareVal(oSourceQry.Fields[i].FullName, E.Message) +
                          '. [' + GetConnectionDef(eDestDB) + ']');
                end;
              ftBcd:
                try
                  if oDestQry.Fields[i].DataType = ftBoolean then
                    rVal := Integer(oDestQry.Fields[i].AsBoolean)
                  else
                    rVal := oDestQry.Fields[i].Value;
                  if Compare(rVal, oSourceQry.Fields[i].Value, ftBcd) <> 0 then
                    Error(WrongField(oSourceQry.Fields[i].FullName, GetConnectionDef(eDestDB),
                          oDestQry.Fields[i].AsString, oSourceQry.Fields[i].AsString));
                except
                  on E: Exception do
                    Error(ErrorOnCompareVal(oSourceQry.Fields[i].FullName, E.Message) +
                          '. [' + GetConnectionDef(eDestDB) + ']');
                end;
              ftSmallint:
                try
                  if oDestQry.Fields[i].DataType = ftBoolean then
                    iVal := Integer(oDestQry.Fields[i].AsBoolean)
                  else
                    iVal := oDestQry.Fields[i].AsInteger;
                  if Compare(iVal, oSourceQry.Fields[i].AsInteger) <> 0 then
                    Error(WrongField(oSourceQry.Fields[i].FullName, GetConnectionDef(eDestDB),
                          oDestQry.Fields[i].AsString, oSourceQry.Fields[i].AsString));
                except
                  on E: Exception do
                    Error(ErrorOnCompareVal(oSourceQry.Fields[i].FullName, E.Message) +
                          '. [' + GetConnectionDef(eDestDB) + ']');
                end;
{$IFDEF AnyDAC_D6}
              ftTimeStamp,
{$ENDIF}              
              ftTime:
                begin
                  lError := False;
                  D1 := oDestQry.Fields[i].AsDateTime;
                  D2 := oSourceQry.Fields[i].AsDateTime;
                  if AnsiCompareText(oSourceQry.Fields[i].FullName, 'ftDate') = 0 then
                    if Trunc(D1) <> Trunc(D2) then
                      lError := True;
                  if AnsiCompareText(oSourceQry.Fields[i].FullName, 'ftTime') = 0 then
                    if (D1 - Trunc(D1)) <> (D2 - Trunc(D2)) then
                      lError := True;
                  if AnsiCompareText(oSourceQry.Fields[i].FullName, 'ftDateTime') = 0 then
                    if D1 <> D2 then
                      lError := True;
                  if lError then
                    Error(WrongField(oSourceQry.Fields[i].FullName, GetConnectionDef(eDestDB),
                          oDestQry.Fields[i].AsString, oSourceQry.Fields[i].AsString));
                end;
              else
                if AnsiCompareStr(oDestQry.Fields[i].AsString, oSourceQry.Fields[i].AsString) <> 0 then
                  Error(WrongField(oSourceQry.Fields[i].FullName, GetConnectionDef(eDestDB),
                        oDestQry.Fields[i].AsString, oSourceQry.Fields[i].AsString));
              end;
            oSourceQry.Next;
            oDestQry.Next;
          end;
        end;
      end;
  finally
    oDestQry.Free;
    oConn.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompDTMTsHolder.SetAsciiFields(ADbToAscii: Boolean = False);
begin
  FDataMove.AsciiDataDef.Fields.Clear;
  with FDataMove.AsciiDataDef.Fields do
    if not ADbToAscii then
      case FRDBMSKind of
      mkMSAccess:
        begin
          // tint1
          with Add do begin
            DataType := atNumber;
            FieldSize := 3;
          end;
          // tint2
          with Add do begin
            DataType := atNumber;
            FieldSize := 3;
          end;
          // tint4
          with Add do begin
            DataType := atNumber;
            FieldSize := 7;
          end;
          // tsingle
          with Add do begin
            DataType := atFloat;
            FieldSize := 17;
          end;
          // tdouble
          with Add do begin
            DataType := atFloat;
            FieldSize := 11;
          end;
          // tbigint
          with Add do begin
            DataType := atFloat;
            FieldSize := 16;
          end;
          // ttext
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tmemo
          with Add do begin
            DataType := atMemo;
            FieldSize := 7;
          end;
          // tdatetime
          with Add do begin
            DataType := atDateTime;
            FieldSize := 20;
          end;
          // tcurrency
          with Add do begin
            DataType := atFloat;
            FieldSize := 8;
          end;
          // tboolean
          with Add do begin
            DataType := atBool;
            FieldSize := 2;
          end;
          // tlongbinary
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // tGUID
          with Add do begin
            DataType := atString;
            FieldSize := 39;
          end;
          // tbinary
          with Add do begin
            DataType := atBlob;
            FieldSize := 101;
          end;
        end;
      mkMSSQL:
        begin
          // tbigint
          with Add do begin
            DataType := atLongInt;
            FieldSize := 19;
          end;
          // tbinary
          with Add do begin
            DataType := atBlob;
            FieldSize := 101;
          end;
          // tbit
          with Add do begin
            DataType := atBool;
            FieldSize := 2;
          end;
          // tchar
          with Add do begin
            DataType := atString;
            FieldSize := 11;
          end;
          // tdatetime
          with Add do begin
            DataType := atDateTime;
            FieldSize := 20;
          end;
          // tfloat
          with Add do begin
            DataType := atFloat;
            FieldSize := 9;
          end;
          // timage
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // tint
          with Add do begin
            DataType := atNumber;
            FieldSize := 7;
          end;
          // tmoney
          with Add do begin
            DataType := atFloat;
            FieldSize := 9;
          end;
          // tnchar
          with Add do begin
            DataType := atString;
            FieldSize := 11;
          end;
          // tntext
          with Add do begin
            DataType := atMemo;
            FieldSize := 7;
          end;
          // tnumeric
          with Add do begin
            DataType := atFloat;
            FieldSize := 7;
          end;
          // tnvarchar
          with Add do begin
            DataType := atString;
            FieldSize := 7;
          end;
          // treal
          with Add do begin
            DataType := atFloat;
            FieldSize := 5;
          end;
          // tsmalldatetime
          with Add do begin
            DataType := atDateTime;
            FieldSize := 20;
          end;
          // tsmallint
          with Add do begin
            DataType := atNumber;
            FieldSize := 3;
          end;
          // tsmallmoney
          with Add do begin
            DataType := atFloat;
            FieldSize := 8;
          end;
          // tsql_variant
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // ttext
          with Add do begin
            DataType := atMemo;
            FieldSize := 6;
          end;
          // ttimestamp
          with Add do begin
            DataType := atBlob;
            FieldSize := 1;
          end;
          // ttinyint
          with Add do begin
            DataType := atNumber;
            FieldSize := 2;
          end;
          // tuniqueidentifier
          with Add do begin
            DataType := atString;
            FieldSize := 39;
          end;
          // tvarbinary
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // tvarchar
          with Add do begin
            DataType := atString;
            FieldSize := 7;
          end;
        end;
      mkASA:
        begin
          // tbigint
          with Add do begin
            DataType := atLongInt;
            FieldSize := 8;
          end;
          // tubigint
          with Add do begin
            DataType := atLongInt;
            FieldSize := 19;
          end;
          // tbinary
          with Add do begin
            DataType := atBlob;
            FieldSize := 101;
          end;
          // tbit
          with Add do begin
            DataType := atBool;
            FieldSize := 2;
          end;
          // tchar
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tdate
          with Add do begin
            DataType := atDate;
            FieldSize := 11;
          end;
          // ttime
          with Add do begin
            DataType := atTime;
            FieldSize := 9;
          end;
          // tdecimal
          with Add do begin
            DataType := atFloat;
            FieldSize := 16;
          end;
          // tdouble
          with Add do begin
            DataType := atFloat;
            FieldSize := 9;
          end;
          // tfloat
          with Add do begin
            DataType := atFloat;
            FieldSize := 11;
          end;
          // tlongbinary
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // tint
          with Add do begin
            DataType := atNumber;
            FieldSize := 8;
          end;
          // tuint
          with Add do begin
            DataType := atNumber;
            FieldSize := 7;
          end;
          // tnumeric
          with Add do begin
            DataType := atFloat;
            FieldSize := 9;
          end;
          // treal
          with Add do begin
            DataType := atFloat;
            FieldSize := 9;
          end;
          // tsmallint
          with Add do begin
            DataType := atNumber;
            FieldSize := 5;
          end;
          // tusmallint
          with Add do begin
            DataType := atNumber;
            FieldSize := 3;
          end;
          // tlongvarchar
          with Add do begin
            DataType := atMemo;
            FieldSize := 7;
          end;
          // ttimestamp
          with Add do begin
            DataType := atDateTime;
            FieldSize := 20;
          end;
          // ttinyint
          with Add do begin
            DataType := atNumber;
            FieldSize := 2;
          end;
          // tvarbinary
          with Add do begin
            DataType := atBlob;
            FieldSize := 13;
          end;
          // tvarchar
          with Add do begin
            DataType := atString;
            FieldSize := 5;
          end;
        end;
      mkMySQL:
        begin
          // ttinyint
          with Add do begin
            DataType := atNumber;
            FieldSize := 3;
          end;
          // tbit
          with Add do begin
            DataType := atBool;
            FieldSize := 2;
          end;
          // tbool
          with Add do begin
            DataType := atBool;
            FieldSize := 2;
          end;
          // tsmallint
          with Add do begin
            DataType := atNumber;
            FieldSize := 2;
          end;
          // tmediumint
          with Add do begin
            DataType := atNumber;
            FieldSize := 7;
          end;
          // tint
          with Add do begin
            DataType := atNumber;
            FieldSize := 8;
          end;
          // tinteger
          with Add do begin
            DataType := atNumber;
            FieldSize := 8;
          end;
          // tbigint
          with Add do begin
            DataType := atLongInt;
            FieldSize := 19;
          end;
          // treal
          with Add do begin
            DataType := atFloat;
            FieldSize := 9;
          end;
          // tdouble
          with Add do begin
            DataType := atFloat;
            FieldSize := 11;
          end;
          // tfloat
          with Add do begin
            DataType := atFloat;
            FieldSize := 8;
          end;
          // tdecimal
          with Add do begin
            DataType := atFloat;
            FieldSize := 19;
          end;
          // tnumeric
          with Add do begin
            DataType := atNumber;
            FieldSize := 8;
          end;
          // tchar
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tvarchar
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tdate
          with Add do begin
            DataType := atDate;
            FieldSize := 11;
          end;
          // ttime
          with Add do begin
            DataType := atTime;
            FieldSize := 9;
          end;
          // tyear
          with Add do begin
            DataType := atNumber;
            FieldSize := 2;
          end;
          // ttimestamp
          with Add do begin
            DataType := atDateTime;
            FieldSize := 20;
          end;
          // tdatetime
          with Add do begin
            DataType := atDateTime;
            FieldSize := 20;
          end;
          // ttinyblob
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // tblob
          with Add do begin
            DataType := atBlob;
            FieldSize := 13;
          end;
          // tmediumblob
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // tlongblob
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // ttinytext
          with Add do begin
            DataType := atString;
            FieldSize := 7;
          end;
          // ttext
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tmediumtext
          with Add do begin
            DataType := atString;
            FieldSize := 7;
          end;
          // tlongtext
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
        end;
      mkOracle:
        begin
          // tnvarchar2
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tvarchar2
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tnumber
          with Add do begin
            DataType := atNumber;
            FieldSize := 11;
          end;
          // tfloat
          with Add do begin
            DataType := atFloat;
            FieldSize := 9;
          end;
          // tdate
          with Add do begin
            DataType := atDateTime;
            FieldSize := 20;
          end;
          // traw
          with Add do begin
            DataType := atBlob;
            FieldSize := 37;
          end;
          // trowid
          with Add do begin
            DataType := atString;
            FieldSize := 19;
          end;
          // tnchar
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tchar
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
        end;
      mkDB2:
        begin
          // tbigint
          with Add do begin
            DataType := atLongInt;
            FieldSize := 19;
          end;
          // tblob
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // tchar
          with Add do begin
            DataType := atString;
            FieldSize := 11;
          end;
          // tchar_bit
          with Add do begin
            DataType := atBlob;
            FieldSize := 13;
          end;
          // tclob
          with Add do begin
            DataType := atMemo;
            FieldSize := 7;
          end;
          // tdate
          with Add do begin
            DataType := atDate;
            FieldSize := 11;
          end;
          // tdecimal
          with Add do begin
            DataType := atFloat;
            FieldSize := 8;
          end;
          // tdouble
          with Add do begin
            DataType := atFloat;
            FieldSize := 9;
          end;
          // tgraphic
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tinteger
          with Add do begin
            DataType := atLongInt;
            FieldSize := 7;
          end;
          // tlongvarchar
          with Add do begin
            DataType := atMemo;
            FieldSize := 7;
          end;
          // tlongvargraphic
          with Add do begin
            DataType := atMemo;
            FieldSize := 7;
          end;
          // treal
          with Add do begin
            DataType := atFloat;
            FieldSize := 10;
          end;
          // tsmallint
          with Add do begin
            DataType := atNumber;
            FieldSize := 3;
          end;
          // ttime
          with Add do begin
            DataType := atTime;
            FieldSize := 9;
          end;
          // ttimestamp
          with Add do begin
            DataType := atDateTime;
            FieldSize := 20;
          end;
          // tvarchar
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tvarchar_bit
          with Add do begin
            DataType := atBlob;
            FieldSize := 11;
          end;
          // tvargraphic
          with Add do begin
            DataType := atString;
            FieldSize := 6;
          end;
          // tdbclob
          with Add do begin
            DataType := atMemo;
            FieldSize := 7;
          end;
        end;
      end
    else begin
      with Add do begin
        DataType := atString;
        FieldSize := 5;
      end;
      with Add do begin
        DataType := atFloat;
        FieldSize := 8;
      end;
      with Add do begin
        DataType := atNumber;
        FieldSize := 4;
      end;
      with Add do begin
        DataType := atBool;
        FieldSize := 1;
      end;
      with Add do begin
        DataType := atLongInt;
        FieldSize := 6;
      end;
      with Add do begin
        DataType := atDate;
        FieldSize := 10;
      end;
      with Add do begin
        DataType := atTime;
        FieldSize := 8;
      end;
      with Add do begin
        DataType := atDateTime;
        FieldSize := 19;
      end;
      with Add do begin
        DataType := atBlob;
        FieldSize := 10;
      end;
      with Add do begin
        DataType := atMemo;
        FieldSize := 6;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompDTMTsHolder.InsertToAsciiTab;
begin
  with FQuery do begin
    SQL.Text := 'insert into {id ADQA_Ascii_types}(atString, atFloat, atNumber, ' +
                'atBool, atLongInt, atDate, atTime, atDateTime, atBlob, atMemo) ' +
                'values(:atString, :atFloat, :atNumber, :atBool, ' +
                ':atLongInt, :atDate, :atTime, :atDateTime, :atBlob, :atMemo)';

    Params[0].AsString   := Strings[0];
    Params[1].AsFloat    := Floats[0];
    Params[2].AsWord     := Words[0];
    if FRDBMSKind in [mkDB2, mkOracle] then
      Params[3].AsSmallInt  := Integer(Booleans[0])
    else
      Params[3].AsBoolean := Booleans[0];
    Params[4].AsInteger  := Integers[0];
    Params[5].AsDateTime := Dates[1];
    //Params[5].AsDate     := Dates[1];  // This comment is needed for MSSQL.
                                         // If param data type is ftDate or ftTime
                                         // the exception 'Optional
    //Params[6].AsTime     := Times[2];  // feature not implemented' is raised,
                                         // but if param type is ftDateTime all is O'k.
    Params[6].AsDateTime := Times[2];
    Params[7].AsDateTime := DateTimes[4];
    Params[8].AsVarByte  := Blobs[0];
    Params[9].AsMemo     := Memos[0];
    try
      ExecSQL;
    except
      on E: Exception do begin
        Error(E.Message);
        raise;
      end;
    end;
  end;
end;

initialization

  ADQAPackManager.RegisterPack('Comp Layer', TADQACompDTMTsHolder);

end.
