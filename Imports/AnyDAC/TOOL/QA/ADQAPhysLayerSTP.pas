{-------------------------------------------------------------------------------}
{ AnyDAC Phys Layer tests                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAPhysLayerSTP;

interface

uses
  Classes, Windows, SysUtils, DB,
  ADQAPack, ADQAPhysLayerCNN,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf;

type
  TADQAPhysSTPTsHolder = class (TADQAPhysTsHolderBase)
  private
    procedure FetchFromSource;
    procedure SwitchProc(AName: String; AType: TParamType = ptUnknown);
  public
    procedure RegisterTests; override;
    procedure TestDefineStdProcParamDB2;
    procedure TestDefineStdProcParamMSSQL;
    procedure TestDefineStdProcParamASA;
    procedure TestDefineStdProcParamOra;
    procedure TestStoredProcDB2;
    procedure TestStoredProcMSSQL1;
    procedure TestStoredProcMSSQL2;
    procedure TestStoredProcASA1;
    procedure TestStoredProcASA2;
    procedure TestStoredProcOra;
    procedure TestNextRecordset;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, SqlTimSt,
{$ELSE}
  ActiveX, ComObj,
{$ENDIF}  
  ADQAConst, ADQAUtils, ADQAVarField,
  daADStanUtil, daADStanConst, daADStanError;

{-------------------------------------------------------------------------------}
{ TADQAPhysSTPTsHolder                                                          }
{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.RegisterTests;
begin
  RegisterTest('StoredProc;Define stored proc params;Ora',      TestDefineStdProcParamOra, mkOracle);
  RegisterTest('StoredProc;Define stored proc params;MSSQL',    TestDefineStdProcParamMSSQL, mkMSSQL);
  RegisterTest('StoredProc;Define stored proc params;ASA',      TestDefineStdProcParamASA, mkASA);
  RegisterTest('StoredProc;Define stored proc params;DB2',      TestDefineStdProcParamDB2, mkDB2);
  RegisterTest('StoredProc;Stored proc;DB2',                    TestStoredProcDB2, mkDB2);
  RegisterTest('StoredProc;Stored proc;Oracle',                 TestStoredProcOra, mkOracle);
  RegisterTest('StoredProc;Stored proc;MSSQL',                  TestStoredProcMSSQL1, mkMSSQL);
  RegisterTest('StoredProc;Stored proc;MSSQL-Identity check',   TestStoredProcMSSQL2, mkMSSQL);
  RegisterTest('StoredProc;Stored proc;ASA',                    TestStoredProcASA1, mkASA);
  RegisterTest('StoredProc;Stored proc;ASA-Identity check',     TestStoredProcASA2, mkASA);
  RegisterTest('StoredProc;Next recordset',                     TestNextRecordset, mkOracle);
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.FetchFromSource;
begin
  with FCommIntf do begin
    Prepare('select * from {id ADQA_All_types}');
    try
      Open;
      CheckCommandState(csOpen, FCommIntf);
      Fetch(FTab);
    finally
      Unprepare;
    end;
  end
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.SwitchProc(AName: String;
  AType: TParamType = ptUnknown);
var
  lError:      Boolean;
  i, k,
  iFirstParam: Integer;
  eType:       TParamType;

  procedure CheckParam(AIndxArray: Integer; var AIndxParam: Integer);
  var
    s1, s2: String;
    lErr:   Boolean;
  begin
    with FCommIntf, FVarFieldList do begin
      if not IsOfUnknownType(AIndxArray) then
        Inc(AIndxParam)
      else
        Exit;
      s1 := FldTypeNames[Params[AIndxParam + iFirstParam].DataType];
      s2 := FldTypeNames[Types[AIndxArray]];
      if Types[AIndxArray] <> Params[AIndxParam + iFirstParam].DataType then begin
        lErr := True;
        case Types[AIndxArray] of
{$IFDEF AnyDAC_D6}
        ftBCD:
          if Params[AIndxParam + iFirstParam].DataType = ftFMTBcd then
             lErr := False;
{$ENDIF}
        ftFixedChar:
          if Params[AIndxParam + iFirstParam].DataType = ftString then
             lErr := False;
        ftCurrency:
          if Params[AIndxParam + iFirstParam].DataType in [ftBCD {$IFDEF AnyDAC_D6}, ftFMTBcd {$ENDIF}] then
            lErr := False;
        ftDate:
          if Params[AIndxParam + iFirstParam].DataType = ftDateTime then
            lErr := False;
        ftVarBytes:
          if Params[AIndxParam + iFirstParam].DataType = ftBytes then
            lErr := False;
        end;
        if lErr then
          Error(TypeMismError(s1, s2, FTab.Columns[AIndxArray].Name, AName));
      end;
    end;
  end;

begin
  eType := AType;
  if FRDBMSKind = mkMSSQL then
    iFirstParam := 1
  else
    iFirstParam := 0;
  with FCommIntf, FVarFieldList do
  try
    CommandText := AName;
    CommandKind := skStoredProcNoCrs;
    Prepare;
    CheckCommandState(csPrepared, FCommIntf);

    if Params.Count = 0 then begin
      Error(ParamCountIsZero(AName));
      Exit;
    end
    else if ((AName <> 'ADQA_All_Values') or not (FRDBMSKind = mkOracle)) and
            (AssignedCount + iFirstParam <> Params.Count) then begin
      Error(WrongExpectedCount('params', AName, Params.Count, AssignedCount +
            iFirstParam));
      Exit;
    end
    else if (FRDBMSKind = mkOracle) and (AName = 'ADQA_All_Values') and
            (AssignedCount * 2 <> Params.Count) then begin
      Error(WrongExpectedCount('params', AName, Params.Count, AssignedCount * 2));
      Exit;
    end;

    for i := iFirstParam to Params.Count - 1 do
      with Params[i] do begin
        lError := False;
        if (AName <> 'ADQA_All_Values') or not (FRDBMSKind = mkOracle) then begin
          if ParamType <> AType then
            lError := True;
        end
        else begin
          if i < Params.Count div 2 then begin
            eType := ptInput;
            if ParamType <> eType then
              lError := True;
          end
          else begin
            eType := ptOutput;
            if ParamType <> eType then
              lError := True;
          end;
        end;
        if lError then
          Error(WrongParamType(ParamTypes[ParamType], ParamTypes[eType], AName));
      end;
    k := -1;
    if (AName <> 'ADQA_All_Values') or not (FRDBMSKind = mkOracle) then
      for i := 0 to FVarFieldList.Count - 1 do
        CheckParam(i, k)
    else
      for i := 0 to (FVarFieldList.Count - 1) * 2 do
        CheckParam(i mod (FVarFieldList.Count), k);
  finally
    Unprepare;
    CommandKind := skUnknown;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestNextRecordset;
var
  i: Integer;
begin
  with FCommIntf do begin
    BaseObjectName := 'ADQA_pack_cursors';
    CommandText := 'getcursors';
    CommandKind := skStoredProcWithCrs;
    CheckCommandState(csInactive, FCommIntf);
    Prepare;
    i := 0;
    while True do begin
      Open;
      if State = csPrepared then
        break;
      try
        Define(FTab);
        Fetch(FTab);
        CheckRowsCount(FTab, CursorRowsCount[i]);
        Inc(i);
      except
        on E: Exception do begin
          Error(E.Message);
          Exit;
        end;
      end;
      NextRecordSet := True;
      Close;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestDefineStdProcParamDB2;
var
  i, j: Integer;
begin
  for i := 0 to 1 do
    with FCommIntf do begin
      SchemaName := 'SYSPROC';
      CommandText := ProcForDefineArgs[i];
      CommandKind := skStoredProc;
      Prepare;
      if Params.Count <> ParamsCountOfPrc[i] then begin
        Error(WrongExpectedCount('params', ProcForDefineArgs[i], Params.Count,
              ParamsCountOfPrc[i]));
        continue;
      end;
      for j := 0 to ParamsCountOfPrc[i] - 1 do begin
        if ParamTypesOfProc[i, j] = ftUnknown then
          break;
        if ParamTypesOfProc[i, j] <> Params[j].DataType then
          Error(TypeMismError(FldTypeNames[Params[j].DataType],
                FldTypeNames[ParamTypesOfProc[i, j]],
                'param #' + IntToStr(j), ProcForDefineArgs[i]));
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestDefineStdProcParamMSSQL;
begin
  GetParamsArray;
  // 1.
  SwitchProc('ADQA_Set_Values', ptInput);
  // 2.
  with FVarFieldList do begin
    Types[6]  := ftUnknown;
    Types[10] := ftUnknown;
    Types[17] := ftUnknown;
    Types[18] := ftUnknown;
  end;
  SwitchProc('ADQA_All_Values', ptInputOutput);
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestDefineStdProcParamASA;
begin
  GetParamsArray;
  with FVarFieldList do begin
    Types[1] := ftUnknown;
    Types[12] := ftUnknown;
    Types[16] := ftUnknown;
  end;
  // 1.
  SwitchProc('ADQA_Set_Values', ptInput);
  // 2.
  SwitchProc('ADQA_All_Values', ptOutput);
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestDefineStdProcParamOra;
begin
  GetParamsArray;
  // 1.
  SwitchProc('ADQA_Set_Values', ptInput);
  // 2.
  FVarFieldList.Types[4] := ftUnknown;
  SwitchProc('ADQA_All_Values');
  FVarFieldList.Types[4] := ftMemo;
  // 3.
  SwitchProc('ADQA_Get_Values', ptOutput);
  // 4.
  SwitchProc('ADQA_SetnGet_Values', ptInputOutput);
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestStoredProcDB2;
var
  i: Integer;
  V1, V2: Variant;
begin
  with FCommIntf do begin
    CommandText := 'SQLCOLUMNS';
    SchemaName  := 'SYSIBM';
    CommandKind := skStoredProc;
    Prepare;

    Params[0].Clear;
    Params[1].AsString := 'DB2ADMIN';
    Params[2].AsString := 'ADQA_All_types';
    Params[3].Clear;
    Params[4].Clear;

    Define(FTab);
    Open;
    Fetch(FTab);
  end;

  if not CheckRowsCount(FTab, 20) then
    Exit;

  for i := 0 to 19 do begin
    V1 := FTab.Rows[i].GetData('COLUMN_NAME');
    V2 := All_types_col_name[i];
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta('COLUMN_NAME', i, '', 'SQLCOLUMNS', 'DB2',
            V1, V2));

    V1 := FTab.Rows[i].GetData('TYPE_NAME');
    V2 := All_types_col_type[i];
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta('TYPE_NAME', i, '', 'SQLCOLUMNS', 'DB2',
            V1, V2));

    V1 := FTab.Rows[i].GetData('ORDINAL_POSITION');
    V2 := i + 1;
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta('ORDINAL_POSITION', i, '', 'SQLCOLUMNS', 'DB2',
            VarToStr(V1), VarToStr(V2)));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestStoredProcMSSQL1;
var
  i, k:   Integer;
  V1, V2: Variant;

  function StorProcSwitch(const AName: String; ACmdKind: TADPhysCommandKind): Boolean;
  var
    i: Integer;
  begin
    Result := True;
    try
      with FCommIntf, FVarFieldList do begin
        try
          CommandText := AName;
          CommandKind := ACmdKind;
          CheckCommandState(csInactive, FCommIntf);
          Prepare;
          CheckCommandState(csPrepared, FCommIntf);
          k := 0;
          if (AName <> 'ADQA_All_Values') and (AName <> 'ADQA_Get_cursor1') then
            if Params.Count > 1 then
              for i := 0 to FVarFieldList.Count - 1 do begin
                if not IsOfUnknownType(i) then
                  Inc(k)
                else
                  continue;
                with Params[k] do
                  Value := VarValues[i];
              end;
          if CommandKind = skStoredProcWithCrs then begin
            Define(FTab);
            Open;
            CheckCommandState(csOpen, FCommIntf);
            Fetch(FTab);
          end
          else
            Execute;
        finally
          Unprepare;
          CommandKind := skUnknown;
        end
      end
    except
      on E: Exception do begin
        Error(ErrorOnStorProc(AName, E.Message));
        Result := False;
      end
    end
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  // 1. IN - parameters
  try
    if StorProcSwitch('ADQA_Set_Values', skStoredProcNoCrs) then begin // input params only
      FetchFromSource;
      if FTab.Rows.Count = 0 then begin
        Error(ErrorOnStorProc('ADQA_Set_Values', 'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then begin
            V1 := VarValues[i];
            V2 := FTab.Rows[0].GetData(i);
            if AnsiCompareText(FTab.Columns[i].Name, 'tsmalldatetime') = 0 then begin
{$IFDEF AnyDAC_D6}
              if Abs(SQLTimeStampToDateTime(VarToSQLTimeStamp(V1)) -
                      SQLTimeStampToDateTime(VarToSQLTimeStamp(V2))) > 0.001 then // ????
{$ELSE}
              if Abs(V1 - V2) > 0.001 then                                        // ????
{$ENDIF}
                Error(ErrorOnStorProcParam('ADQA_Set_Values', FTab.Columns[i].Name,
                  VarToStr(VarValues[i]), VarToStr(FTab.Rows[0].GetData(i))));
              continue;
            end;
            if Compare(VarValues[i], FTab.Rows[0].GetData(i), Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Set_Values', FTab.Columns[i].Name,
                VarToStr(VarValues[i]), VarToStr(FTab.Rows[0].GetData(i))));
          end;
    end
    else
      Error(CannotTestStorProc('ADQA_Set_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Set_Values', E.Message));
  end;

  // 2. INOUT
  try
    with FVarFieldList do begin
      Types[6]  := ftUnknown;
      Types[10] := ftUnknown;
      Types[17] := ftUnknown;
      Types[18] := ftUnknown;
    end;
    if StorProcSwitch('ADQA_All_Values', skStoredProc) then begin // output params
      k := 0;
      with FCommIntf, FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then begin
            Inc(k);
            if Compare(VarValues[i], Params[k].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_All_Values', Params[k].Name,
                VarToStr(VarValues[i]), VarToStr(Params[k].Value)));
          end;
    end
    else
      Error(CannotTestStorProc('ADQA_All_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_All_Values', E.Message));
  end;

  // 3. proc. with cursor
  try
    DeleteFromSource;
    if not Insert then
      Exit;
    if StorProcSwitch('ADQA_Get_Values', skStoredProcWithCrs) then begin
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then
            if Compare(VarValues[i], FTab.Rows[0].GetData(i), Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Get_Values', FTab.Columns[i].Name,
                    VarToStr(VarValues[i]), VarToStr(FTab.Rows[0].GetData(i))));
    end
    else
      Error(CannotTestStorProc('ADQA_Get_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Get_Values', E.Message));
  end;

  { The Procedures below can not return a recordset (cursor variable) seeing MSSQL would not let it.
  This is a cite from MSSQL BOL: "The cursor data type cannot be bound to application variables through the database APIs
                        such as OLE DB, ODBC, daADO, and DB-Library. Because OUTPUT parameters must be bound before
                        an application can execute a stored procedure, stored procedures with cursor OUTPUT parameters
                        cannot be called from the database APIs. These procedures can be called from Transact-SQL
                        batches, stored procedures, or triggers only when the cursor OUTPUT variable is assigned
                        to a Transact-SQL local cursor variable...".
  // 4. proc. with cursor output parameter
  try
    if StorProcSwitch('ADQA_Get_cursor1', skStoredProcWithCrs) then begin
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if VarValues[i] <> FTab.Rows[0].GetData(i) then
            Error(ErrorOnStorProcParam('ADQA_Get_cursor1', FTab.Columns[i].Name,
              VarToStr(VarValues[i]), VarToStr(FTab.Rows[0].GetData(i))));
    end
    else
      Error(CannotTestStorProc('ADQA_Get_cursor1'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Get_cursor1', E.Message));
  end;

  // 5. proc. with cursor 2
  try
    if StorProcSwitch('ADQA_Get_cursor2', skStoredProcWithCrs) then begin
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if VarValues[i] <> FTab.Rows[0].GetData(i) then
            Error(ErrorOnStorProcParam('ADQA_Get_cursor2', FTab.Columns[i].Name,
              VarToStr(VarValues[i]), VarToStr(FTab.Rows[0].GetData(i))));
    end
    else
      Error(CannotTestStorProc('ADQA_Get_cursor2'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Get_cursor2', E.Message));
  end;
  }
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestStoredProcMSSQL2;
var
  i, iVal, iPar: Integer;

  function Insert: Boolean;
  begin
    Result := True;
    try
      with FCommIntf do begin
        try
          CommandText := 'ADQA_Identity_return';
          CommandKind := skStoredProc;
          CheckCommandState(csInactive, FCommIntf);
          Prepare;
          CheckCommandState(csPrepared, FCommIntf);
          if Params.Count <> 2 then begin
            Error(WrongParCount(Params.Count, 2));
            Result := False;
            Exit;
          end;
          Execute;
        finally
          Unprepare;
          CheckCommandState(csInactive, FCommIntf);
          CommandKind := skUnknown;
        end
      end
    except
      on E: Exception do begin
        Error(ErrorOnStorProc('ADQA_Identity_return', E.Message));
        Result := False;
      end
    end
  end;

begin
  with FCommIntf do begin
    Prepare('delete from {id ADQA_Identity_tab}');
    Execute;
  end;
  for i := 0 to 100 do begin
    if not Insert then
      Exit;
    if Compare(FCommIntf.Params[0].Value, 1) <> 0 then
      Error(WrongValueInParam('@RETURN_VALUE', VarToStr(FCommIntf.Params[0].Value), '1'));

    if FCommIntf.Params[1].Value = Null then begin
      Error(VariantIsNull);
      Exit;
    end
    else
      iPar := VarAsType(FCommIntf.Params[1].Value, varInteger);
    RefetchTable('ADQA_Identity_tab', FTab, FCommIntf, 'auto');
    iVal := FTab.Rows[FTab.Rows.Count - 1].GetData(0);
    if Compare(iPar, iVal) <> 0 then begin
      Error(WrongValueInParam('@ID', VarToStr(FCommIntf.Params[1].Value), IntToStr(iVal)));
      break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestStoredProcASA1;
var
  i, k:   Integer;
  V1, V2: Variant;

  function StorProcSwitch(const AName: String; ACmdKind: TADPhysCommandKind): Boolean;
  var
    i: Integer;
  begin
    Result := True;
    try
      with FCommIntf, FVarFieldList do begin
        try
          CommandText := AName;
          CommandKind := ACmdKind;
          CheckCommandState(csInactive, FCommIntf);
          Prepare;
          CheckCommandState(csPrepared, FCommIntf);
          k := -1;
          if (AName <> 'ADQA_All_Values') and (AName <> 'ADQA_Get_cursor') and
            (AName <> 'ADQA_Get_values') then
            if Params.Count > 0 then
              for i := 0 to FVarFieldList.Count - 1 do begin
                if not IsOfUnknownType(i) then
                  Inc(k)
                else
                  continue;
                with Params[k] do
                  Value := VarValues[i];
              end;
          if CommandKind = skStoredProcWithCrs then begin
            Define(FTab);
            Open;
            CheckCommandState(csOpen, FCommIntf);
            Fetch(FTab);
          end
          else
            Execute;
        finally
          Unprepare;
          CommandKind := skUnknown;
        end
      end
    except
      on E: Exception do begin
        Error(ErrorOnStorProc(AName, E.Message));
        Result := False;
      end
    end
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  with FVarFieldList do begin
    Types[1] := ftUnknown;
    Types[12] := ftUnknown;
    Types[16] := ftUnknown;
  end;
  // 1. IN - parameters
  try
    if StorProcSwitch('ADQA_Set_Values', skStoredProcNoCrs) then begin // input params only
      FetchFromSource;
      if FTab.Rows.Count = 0 then begin
        Error(ErrorOnStorProc('ADQA_Set_Values', 'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then begin
            V1 := VarValues[i];
            V2 := FTab.Rows[0].GetData(i);

            if Compare(VarValues[i], FTab.Rows[0].GetData(i), Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Set_Values', FTab.Columns[i].Name,
                VarToStr(VarValues[i]), VarToStr(FTab.Rows[0].GetData(i))));
          end;
    end
    else
      Error(CannotTestStorProc('ADQA_Set_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Set_Values', E.Message));
  end;

  // 2. OUT
  try
    with FVarFieldList do begin
      Types[1] := ftUnknown;
      Types[12] := ftUnknown;
      Types[16] := ftUnknown;
    end;
    if StorProcSwitch('ADQA_All_Values', skStoredProc) then begin // output params
      k := -1;
      with FCommIntf, FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then begin
            Inc(k);
            if Compare(VarValues[i], Params[k].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_All_Values', Params[k].Name,
                VarToStr(VarValues[i]), VarToStr(Params[k].Value)));
          end;
    end
    else
      Error(CannotTestStorProc('ADQA_All_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_All_Values', E.Message));
  end;

  // 3. proc. with cursor
  try
    DeleteFromSource;
    FTab.Clear;
    if not Insert then
      Exit;
    if StorProcSwitch('ADQA_Get_values', skStoredProcWithCrs) then begin
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then
            if Compare(VarValues[i], FTab.Rows[0].GetData(i), Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Get_Values', FTab.Columns[i].Name,
                    VarToStr(VarValues[i]), VarToStr(FTab.Rows[0].GetData(i))));
    end
    else
      Error(CannotTestStorProc('ADQA_Get_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Get_Values', E.Message));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestStoredProcASA2;
var
  i, iVal, iPar: Integer;

  function Insert: Boolean;
  begin
    Result := True;
    try
      with FCommIntf do begin
        try
          CommandText := 'ADQA_Identity_return';
          CommandKind := skStoredProc;
          CheckCommandState(csInactive, FCommIntf);
          Prepare;
          CheckCommandState(csPrepared, FCommIntf);
          if Params.Count <> 1 then begin
            Error(WrongParCount(Params.Count, 1));
            Result := False;
            Exit;
          end;
          Execute;
        finally
          Unprepare;
          CheckCommandState(csInactive, FCommIntf);
          CommandKind := skUnknown;
        end
      end
    except
      on E: Exception do begin
        Error(ErrorOnStorProc('ADQA_Identity_return', E.Message));
        Result := False;
      end
    end
  end;

begin
  with FCommIntf do begin
    Prepare('delete from {id ADQA_Identity_tab}');
    Execute;
  end;
  for i := 0 to 100 do begin
    if not Insert then
      Exit;

    if FCommIntf.Params[0].Value = Null then begin
      Error(VariantIsNull);
      Exit;
    end
    else
      iPar := VarAsType(FCommIntf.Params[0].Value, varInteger);
    RefetchTable('ADQA_Identity_tab', FTab, FCommIntf, 'auto');
    iVal := FTab.Rows[FTab.Rows.Count - 1].GetData(0);
    if Compare(iPar, iVal) <> 0 then begin
      Error(WrongValueInParam('@ID', VarToStr(FCommIntf.Params[0].Value), IntToStr(iVal)));
      break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQAPhysSTPTsHolder.TestStoredProcOra;
var
  i, k: Integer;

  function StorProcSwitch(const AName: String; ACmdKind: TADPhysCommandKind;
                          ASetVal: Boolean; APack: Boolean = False): Boolean;
  var
    i, k: Integer;
  begin
    Result := True;
    try
      with FCommIntf, FVarFieldList do
        try
          if APack then
            BaseObjectName := 'ADQA_All_types_PACK';
          CommandText := AName;
          CommandKind := ACmdKind;
          CheckCommandState(csInactive, FCommIntf);
          Prepare;
          k := -1;
          if (Params.Count > 0) and not APack then
            for i := 0 to FVarFieldList.Count - 1 do begin
              if not IsOfUnknownType(i) then
                Inc(k)
              else
                continue;
              with Params[k] do
                if ASetVal then
                  Value := VarValues[i];
            end;
          if CommandKind = skStoredProcWithCrs then begin
            Open;
            CheckCommandState(csOpen, FCommIntf);
            Fetch(FTab);
          end
          else
            Execute;
        finally
          Unprepare;
          CheckCommandState(csInactive, FCommIntf);
          CommandKind := skUnknown;
        end
    except
      on E: Exception do begin
        Error(ErrorOnStorProc(AName, E.Message));
        Result := False;
      end
    end
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  // check stored proc. without package
  // 1. IN - parameters
  try
    if StorProcSwitch('ADQA_Set_Values', skStoredProcNoCrs, True) then begin // input params only
      FetchFromSource;
      if FTab.Rows.Count = 0 then begin
        Error(ErrorOnStorProc('ADQA_Set_Values', 'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then
            if Compare(VarValues[i], FTab.Rows[0].GetData(i), Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Set_Values', FTab.Columns[i].Name,
                    VarToStr(VarValues[i]), VarToStr(FTab.Rows[0].GetData(i))));
    end
    else
      Error(CannotTestStorProc('ADQA_Set_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Set_Values', E.Message));
  end;

  // 2. IN, OUT - parameters
  FVarFieldList.Types[4] := ftUnknown;
  try
    if StorProcSwitch('ADQA_All_Values', skStoredProc, True) then begin // input and output params
      k := -1;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then begin
            Inc(k);
            if Compare(VarValues[i], FCommIntf.Params[AssignedCount + k].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_All_Values', FTab.Columns[i].Name,
                    VarToStr(VarValues[i]),
                    VarToStr(FCommIntf.Params[AssignedCount + k].Value)));
        end;
    end
    else
      Error(CannotTestStorProc('ADQA_All_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_All_Values', E.Message));
  end;
  FVarFieldList.Types[4] := ftMemo;

  // 3. OUT params
  try
    if StorProcSwitch('ADQA_Get_Values', skStoredProc, False) then begin // output params only
      k := -1;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then begin
            Inc(k);
            if Compare(VarValues[i], FCommIntf.Params[k].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Get_Values', FTab.Columns[i].Name,
                    VarToStr(VarValues[i]),
                    VarToStr(FCommIntf.Params[k].Value)));
          end;
    end
    else
      Error(CannotTestStorProc('ADQA_Get_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Get_Values', E.Message));
  end;

  // check stored proc. in package
  // 1. proc. with cursor
  try
    if StorProcSwitch('Get_Valuesp', skStoredProcWithCrs, False, True) then begin
      FetchFromSource;
      if FTab.Rows.Count = 0 then begin
        Error(ErrorOnStorProc('Get_Valuesp in ADQA_ALL_TYPES_PACK',
              'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then
            if Compare(VarValues[i], FTab.Rows[0].GetData(i), Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('Get_Valuesp in ADQA_ALL_TYPES_PACK',
                    FTab.Columns[i].Name, VarToStr(VarValues[i]),
                    VarToStr(FTab.Rows[0].GetData(i))));
    end
    else
      Error(CannotTestStorProc('Get_Valuesp in ADQA_ALL_TYPES_PACK'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('Get_Valuesp in ADQA_ALL_TYPES_PACK', E.Message));
  end;

  // 2. function with cursor
  try
    if StorProcSwitch('Get_Valuesf', skStoredProcWithCrs, False, True) then begin
      FetchFromSource;
      if FTab.Rows.Count = 0 then begin
        Error(ErrorOnStorProc('Get_Valuesf in ADQA_ALL_TYPES_PACK',
              'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then
            if Compare(VarValues[i], FTab.Rows[0].GetData(i), Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('Get_Valuesf in ADQA_ALL_TYPES_PACK',
                    FTab.Columns[i].Name, VarToStr(VarValues[i]),
                    VarToStr(FTab.Rows[0].GetData(i))));
    end
    else
      Error(CannotTestStorProc('Get_Valuesf in ADQA_ALL_TYPES_PACK'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('Get_Valuesf in ADQA_ALL_TYPES_PACK', E.Message));
  end;
end;


initialization

  ADQAPackManager.RegisterPack('Phys Layer', TADQAPhysSTPTsHolder);

end.
