{-------------------------------------------------------------------------------}
{ AnyDAC Component Layer: TADMetaInfoQuery tests                                }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQACompLayerSTP;

interface

uses
  Classes, Windows, SysUtils, DB,
  ADQAPack, ADQACompLayerCNN,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf,
  daADDAptIntf,
  daADCompClient;

type
  TADQACompSTPTsHolder = class (TADQACompTsHolderBase)
  private
    FStorProc: TADStoredProc;
    procedure TestStoredProcMSSQL3;
    procedure DeleteFromSource;
    procedure FetchFromSource;
    procedure SwitchProc(AName: String; AType: TParamType = ptUnknown);
  public
    constructor Create(const AName: String); override;
    destructor Destroy; override;
    procedure ClearAfterTest; override;
    procedure RegisterTests; override;
    procedure TestDefineStdProcParamMSSQL;
    procedure TestDefineStdProcParamASA;
    procedure TestDefineStdProcParamOra;
    procedure TestNextRecordset;
    procedure TestStoredProcDB2;
    procedure TestStoredProcMSSQL1;
    procedure TestStoredProcMSSQL2;
    procedure TestStoredProcASA1;
    procedure TestStoredProcASA2;
    procedure TestStoredProcOra;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, SqlTimSt,
{$ENDIF}
  daADStanError,  
  ADQAConst, ADQAUtils;

{-------------------------------------------------------------------------------}
{ TADQACompSTPTsHolder                                                          }
{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.RegisterTests;
begin
  RegisterTest('Stored Proc;Define stor. proc params;Ora',   TestDefineStdProcParamOra, mkOracle);
  RegisterTest('Stored Proc;Define stor. proc params;MSSQL', TestDefineStdProcParamMSSQL, mkMSSQL);
  RegisterTest('Stored Proc;Define stor. proc params;ASA',   TestDefineStdProcParamASA, mkASA);
  RegisterTest('Stored Proc;DB2',                            TestStoredProcDB2, mkDB2);
  RegisterTest('Stored Proc;Oracle',                         TestStoredProcOra, mkOracle);
  RegisterTest('Stored Proc;MSSQL',                          TestStoredProcMSSQL1, mkMSSQL);
  RegisterTest('Stored Proc;MSSQL-Identity check',           TestStoredProcMSSQL2, mkMSSQL);
  RegisterTest('Stored Proc;MSSQL-Various',                  TestStoredProcMSSQL3, mkMSSQL);
  RegisterTest('Stored Proc;ASA',                            TestStoredProcASA1, mkASA);
  RegisterTest('Stored Proc;ASA-Identity check',             TestStoredProcASA2, mkASA);
  RegisterTest('Stored Proc;NextRecordSet',                  TestNextRecordset, mkOracle);
end;

{-------------------------------------------------------------------------------}
constructor TADQACompSTPTsHolder.Create(const AName: String);
begin
  inherited Create(AName);
  FStorProc := TADStoredProc.Create(nil);
  FStorProc.Connection := FConnection;
end;

{-------------------------------------------------------------------------------}
destructor TADQACompSTPTsHolder.Destroy;
begin
  FStorProc.Free;
  FStorProc := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.ClearAfterTest;
begin
  FStorProc.Close;
  FStorProc.SchemaName := '';
  FStorProc.PackageName := '';
  inherited ClearAfterTest;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.TestDefineStdProcParamMSSQL;
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
procedure TADQACompSTPTsHolder.TestDefineStdProcParamASA;
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
procedure TADQACompSTPTsHolder.TestDefineStdProcParamOra;
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
procedure TADQACompSTPTsHolder.TestNextRecordset;
var
  i: Integer;
begin
  with FStorProc do begin
    PackageName := 'ADQA_pack_cursors';
    StoredProcName := 'getcursors';
    Prepare;
    i := 0;
    Open;
    while True do begin
      try
        CheckRowsCount(Table, CursorRowsCount[i]);
        Inc(i);
      except
        on E: Exception do begin
          Error(E.Message);
          Exit;
        end;
      end;
      NextRecordSet;
      if RecordCount = 0 then
        break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.TestStoredProcDB2;
var
  i: Integer;
  V1, V2: Variant;
begin
  with FStorProc do begin
    StoredProcName := 'SQLCOLUMNS';
    SchemaName  := 'SYSIBM';
    Prepare;

    Params[0].Clear;
    Params[1].AsString := 'DB2ADMIN';
    Params[2].AsString := 'ADQA_All_types';
    Params[3].Clear;
    Params[4].Clear;

    Open;
  end;

  if not CheckRowsCount(nil, 20, FStorProc.RecordCount) then
    Exit;

  i := 0;
  while not FStorProc.Eof do begin
    V1 := FStorProc.Fields.FieldByName('COLUMN_NAME').AsString;
    V2 := All_types_col_name[i];
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta('COLUMN_NAME', i, '', 'SQLCOLUMNS', 'DB2',
            V1, V2));

    V1 := FStorProc.Fields.FieldByName('TYPE_NAME').AsString;
    V2 := All_types_col_type[i];
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta('TYPE_NAME', i, '', 'SQLCOLUMNS', 'DB2',
            V1, V2));

    V1 := FStorProc.Fields.FieldByName('ORDINAL_POSITION').AsInteger;
    V2 := i + 1;
    if AnsiCompareText(V1, V2) <> 0 then
      Error(WrongValueInColumnMeta('ORDINAL_POSITION', i, '', 'SQLCOLUMNS', 'DB2',
            VarToStr(V1), VarToStr(V2)));
    FStorProc.Next;
    Inc(i);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.TestStoredProcMSSQL1;
var
  i, k:   Integer;
  V1, V2: Variant;

  function StorProcSwitch(const AName: String; ACmdKind: TADPhysCommandKind): Boolean;
  var
    i: Integer;
  begin
    Result := True;
    try
      with FStorProc, FVarFieldList do begin
        StoredProcName := AName;
        Prepare;
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
        if ACmdKind <> skStoredProcNoCrs then
          Open
        else
          ExecProc;
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
      if FQuery.RecordCount = 0 then begin
        Error(ErrorOnStorProc('ADQA_Set_Values', 'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then begin
            V1 := VarValues[i];
            V2 := FQuery.Fields[i].Value;
            if AnsiCompareText(FQuery.Fields[i].FullName, 'tsmalldatetime') = 0 then begin
{$IFDEF AnyDAC_D6}
              if Abs(SQLTimeStampToDateTime(VarToSQLTimeStamp(V1)) -
                      SQLTimeStampToDateTime(VarToSQLTimeStamp(V2))) > 0.001 then
{$ELSE}
              if Abs(V1 - V2) > 0.001 then
{$ENDIF}
                Error(ErrorOnStorProcParam('ADQA_Set_Values',
                      FQuery.Fields[i].FullName,
                      VarToStr(V1), VarToStr(V2)));
              continue;
            end;
            if Compare(V1, V2, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Set_Values',
                    FQuery.Fields[i].FullName,
                    VarToStr(V1), VarToStr(V2)));
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
    if StorProcSwitch('ADQA_All_Values', skStoredProcNoCrs) then begin // output params
      k := 0;
      with FStorProc, FVarFieldList do
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
    if StorProcSwitch('ADQA_Get_Values', skStoredProcWithCrs) then
      with FVarFieldList do begin
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then begin
            if Compare(VarValues[i], FStorProc.Fields[i].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Get_Values', FStorProc.Fields[i].FullName,
                    VarToStr(VarValues[i]), VarToStr(FStorProc.Fields[i].Value)));
          end;
      end
    else
      Error(CannotTestStorProc('ADQA_Get_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Get_Values', E.Message));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.TestStoredProcMSSQL2;
var
  i, iVal, iPar: Integer;

  function Insert: Boolean;
  begin
    Result := True;
    try
      with FStorProc do begin
        StoredProcName := 'ADQA_Identity_return';
        Prepare;
        if Params.Count <> 2 then begin
          Error(WrongParCount(Params.Count, 2));
          Result := False;
          Exit;
        end;
        ExecProc;
      end
    except
      on E: Exception do begin
        Error(ErrorOnStorProc('ADQA_Identity_return', E.Message));
        Result := False;
      end
    end
  end;

begin
  with FQuery do begin
    SQL.Text := 'delete from {id ADQA_Identity_tab}';
    ExecSQL;
  end;
  for i := 0 to 100 do begin
    if not Insert then
      Exit;
    if Compare(FStorProc.Params[0].Value, 1) <> 0 then
      Error(WrongValueInParam('@RETURN_VALUE', VarToStr(FStorProc.Params[0].Value), '1'));

    if FStorProc.Params[1].Value = Null then begin
      Error(VariantIsNull);
      Exit;
    end
    else
      iPar := VarAsType(FStorProc.Params[1].Value, varInteger);

    with FQuery do begin
      SQL.Text := 'select * from {id ADQA_Identity_tab} order by auto';
      Open;
      Last
    end;
    iVal := FQuery.Fields[0].AsInteger;
    if Compare(iPar, iVal) <> 0 then begin
      Error(WrongValueInParam('@ID', VarToStr(FStorProc.Params[1].Value),
            IntToStr(iVal)));
      break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.TestStoredProcMSSQL3;
var
  adqCustomers: TADQuery;
  dsCustomers: TDataSource;
  adqCustOrdersOrders: TADQuery;
  dsCustOrdersOrders: TDataSource;
  adqCustOrderHist: TADQuery;
  dsCustOrderHist: TDataSource;
  cmdSetAppRole: TADCommand;
  sp: TADStoredProc;
begin
  // 1. EXEC & TADQuery & Open
  // 1.1. Create
  adqCustomers := TADQuery.Create(nil);
  with adqCustomers do begin
    Connection := FConnection;
    SQL.Add('SELECT C.CustomerID, C.CompanyName');
    SQL.Add('FROM Customers C');
  end;
  dsCustomers := TDataSource.Create(nil);
  with dsCustomers do
    DataSet := adqCustomers;

  adqCustOrdersOrders := TADQuery.Create(nil);
  with adqCustOrdersOrders do begin
    Connection := FConnection;
    SQL.Add('exec CustOrderHist :CustomerID');
    with Params.Add do begin
      Name := 'CustomerID';
      DataType := ftWideString;
      ParamType := ptInput;
      Size := 12;
      Value := 'ALFKI';
    end;
    DataSource := dsCustomers;
  end;
  dsCustOrdersOrders := TDataSource.Create(nil);
  with dsCustOrdersOrders do
    DataSet := adqCustOrdersOrders;

  adqCustOrderHist := TADQuery.Create(nil);
  with adqCustOrderHist do begin
    Connection := FConnection;
    SQL.Add('exec CustOrdersOrders :CustomerID');
    with Params.Add do begin
      Name := 'CustomerID';
      DataType := ftWideString;
      ParamType := ptInput;
      Size := 12;
      Value := 'ALFKI';
    end;
    DataSource := dsCustomers;
  end;
  dsCustOrderHist := TDataSource.Create(nil);
  with dsCustOrderHist do
    DataSet := adqCustOrderHist;

  try
    // 1.2 Open
    adqCustomers.Open;
    adqCustOrdersOrders.Open;
    adqCustOrderHist.Open;

    // 1.3 fmAll
    adqCustomers.Disconnect;
    adqCustOrdersOrders.Disconnect;
    adqCustOrderHist.Disconnect;
    adqCustomers.FetchOptions.Mode := fmAll;
    adqCustOrdersOrders.FetchOptions.Mode := fmAll;
    adqCustOrderHist.FetchOptions.Mode := fmAll;
    adqCustomers.Open;
    adqCustOrdersOrders.Open;
    adqCustOrderHist.Open;
  finally
    adqCustomers.Free;
    dsCustomers.Free;
    adqCustOrdersOrders.Free;
    dsCustOrdersOrders.Free;
    adqCustOrderHist.Free;
    dsCustOrderHist.Free;
  end;

  // 2. sp_setapprole
  cmdSetAppRole := TADCommand.Create(nil);
  cmdSetAppRole.Connection := FConnection;
  cmdSetAppRole.CommandText.Add('EXEC sp_setapprole ''AppRoleName'', ''Password''');
  cmdSetAppRole.ResourceOptions.DirectExecute := True;
  try
    try
      cmdSetAppRole.Execute();
    except
      on E: EADDBEngineException do
        if Pos('Could not find application role ''AppRoleName''', E.Message) = 0 then
          raise;
    end;
  finally
    cmdSetAppRole.Free;
  end;

  // 3. SET NOCOUNT OFF
  sp := TADStoredProc.Create(nil);
  try
    sp.Connection := FConnection;
    sp.StoredProcName := 'ADQA_TestOutCounting';
    sp.Prepare;
    sp.ParamByName('@P').Clear;
    sp.ExecProc;
    if sp.ParamByName('@P').AsInteger <> 5 then
      Error('Procedure out param is not fetched');
  finally
    sp.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.TestStoredProcASA1;
var
  i, k:   Integer;
  V1, V2: Variant;

  function StorProcSwitch(const AName: String; ACmdKind: TADPhysCommandKind): Boolean;
  var
    i: Integer;
  begin
    Result := True;
    try
      with FStorProc, FVarFieldList do begin
        StoredProcName := AName;
        Prepare;
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
        if ACmdKind <> skStoredProcNoCrs then
          Open
        else
          ExecProc;
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
      if FQuery.RecordCount = 0 then begin
        Error(ErrorOnStorProc('ADQA_Set_Values', 'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then begin
            V1 := VarValues[i];
            V2 := FQuery.Fields[i].Value;
            if Compare(V1, V2, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Set_Values',
                    FQuery.Fields[i].FullName,
                    VarToStr(V1), VarToStr(V2)));
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
    if StorProcSwitch('ADQA_All_Values', skStoredProcNoCrs) then begin // output params
      k := -1;
      with FStorProc, FVarFieldList do
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
    if StorProcSwitch('ADQA_Get_values', skStoredProcWithCrs) then begin
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then
            if Compare(VarValues[i], FStorProc.Fields[i].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Get_Values', FStorProc.Fields[i].FullName,
                    VarToStr(VarValues[i]), VarToStr(FStorProc.Fields[i].Value)));
    end
    else
      Error(CannotTestStorProc('ADQA_Get_Values'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('ADQA_Get_Values', E.Message));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.TestStoredProcASA2;
var
  i, iVal, iPar: Integer;

  function Insert: Boolean;
  begin
    Result := True;
    try
      with FStorProc do begin
        StoredProcName := 'ADQA_Identity_return';
        Prepare;
        if Params.Count <> 1 then begin
          Error(WrongParCount(Params.Count, 1));
          Result := False;
          Exit;
        end;
       ExecProc;
      end
    except
      on E: Exception do begin
        Error(ErrorOnStorProc('ADQA_Identity_return', E.Message));
        Result := False;
      end
    end
  end;

begin
  with FQuery do begin
    SQL.Text := 'delete from {id ADQA_Identity_tab}';
    ExecSQL;
  end;
  for i := 0 to 100 do begin
    if not Insert then
      Exit;

    if FStorProc.Params[0].Value = Null then begin
      Error(VariantIsNull);
      Exit;
    end
    else
      iPar := VarAsType(FStorProc.Params[0].Value, varInteger);
    with FQuery do begin
      SQL.Text := 'select * from {id ADQA_Identity_tab} order by auto';
      Open;
      Last
    end;
    iVal := FQuery.Fields[0].AsInteger;
    if Compare(iPar, iVal) <> 0 then begin
      Error(WrongValueInParam('@ID', VarToStr(FStorProc.Params[0].Value),
            IntToStr(iVal)));
      break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.TestStoredProcOra;
var
  i, k: Integer;

  function StorProcSwitch(const AName: String; ACmdKind: TADPhysCommandKind;
                          ASetVal: Boolean; APack: Boolean = False): Boolean;
  var
    i, k: Integer;
  begin
    Result := True;
    try
      with FStorProc, FVarFieldList do begin
        if APack then
          PackageName := 'ADQA_All_types_PACK';
        StoredProcName := AName;
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
        if ACmdKind = skStoredProcWithCrs then
          Open
        else
          ExecProc;
      end;
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
      if FQuery.RecordCount = 0 then begin
        Error(ErrorOnStorProc('ADQA_Set_Values', 'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then
            if Compare(VarValues[i], FQuery.Fields[i].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Set_Values',
                    FQuery.Fields[i].FullName,
                    VarToStr(VarValues[i]), VarToStr(FQuery.Fields[i].Value)));
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
            if Compare(VarValues[i], FStorProc.Params[AssignedCount + k].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_All_Values',
                    FQuery.Fields[i].FullName, VarToStr(VarValues[i]),
                    VarToStr(FStorProc.Params[AssignedCount + k].Value)));
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
            if Compare(VarValues[i], FStorProc.Params[k].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('ADQA_Get_Values',
                    FQuery.Fields[i].FullName, VarToStr(VarValues[i]),
                    VarToStr(FStorProc.Params[k].Value)));
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
      if FQuery.RecordCount = 0 then begin
        Error(ErrorOnStorProc('Get_Valuesp in ADQA_ALL_TYPES_PACK',
              'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then
            if Compare(VarValues[i], FQuery.Fields[i].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('Get_Valuesp in ADQA_ALL_TYPES_PACK',
                    FQuery.Fields[i].FullName, VarToStr(VarValues[i]),
                    VarToStr(FQuery.Fields[i].Value)));
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
      if FQuery.RecordCount = 0 then begin
        Error(ErrorOnStorProc('Get_Valuesf in ADQA_ALL_TYPES_PACK',
              'There are no inserted rows!'));
        Exit;
      end;
      with FVarFieldList do
        for i := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(i) then
            if Compare(VarValues[i], FQuery.Fields[i].Value, Types[i]) <> 0 then
              Error(ErrorOnStorProcParam('Get_Valuesf in ADQA_ALL_TYPES_PACK',
                    FQuery.Fields[i].FullName, VarToStr(VarValues[i]),
                    VarToStr(FQuery.Fields[i].Value)));
    end
    else
      Error(CannotTestStorProc('Get_Valuesf in ADQA_ALL_TYPES_PACK'));
  except
    on E: Exception do
      Error(ErrorOnStorProc('Get_Valuesf in ADQA_ALL_TYPES_PACK', E.Message));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.DeleteFromSource;
begin
  with FQuery do begin
    SQL.Text := 'delete from {id ADQA_All_types}';
    try
      ExecSQL;
    except
      on E: Exception do
        Error(E.Message);
    end;
  end
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.FetchFromSource;
begin
  with FQuery do begin
    SQL.Text := 'select * from {id ADQA_All_types}';
    try
      Open;
    except
      on E: Exception do
        Error(E.Message);
    end;
  end
end;

{-------------------------------------------------------------------------------}
procedure TADQACompSTPTsHolder.SwitchProc(AName: String; AType: TParamType = ptUnknown);
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
    with FStorProc, FVarFieldList do begin
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
  with FStorProc, FVarFieldList do begin
    StoredProcName := AName;
    Prepare;
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
      for i := 0 to FVarFieldList.Count - 1 * 2 do
        CheckParam(i mod (FVarFieldList.Count), k);
  end;
end;

initialization

  ADQAPackManager.RegisterPack('Comp Layer', TADQACompSTPTsHolder);

end.
