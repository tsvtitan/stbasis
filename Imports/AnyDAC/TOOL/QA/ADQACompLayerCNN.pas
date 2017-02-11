{-------------------------------------------------------------------------------}
{ AnyDAC Component Layer: TADConnection tests                                   }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQACompLayerCNN;

interface

uses
  Classes, Windows, SysUtils, DB,
  ADQAPack,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf,
  daADDAptIntf,
  daADCompClient;

type
  TADQACompTsHolderBase = class (TADQATsHolderBase)
  protected
    procedure FillTables;
  public
    function RunBeforeTest: Boolean; override;
  end;

  TADQACompCNNTsHolder = class (TADQACompTsHolderBase)
  private
    FCommand: TADCommand;
    FTableAdapter: TADTableAdapter;
    FSchemaAdapter: TADSchemaAdapter;
  public
    constructor Create(const AName: String); override;
    destructor Destroy; override;
    procedure ClearAfterTest; override;
    procedure RegisterTests; override;
    procedure TestCommandDefAndMerge;
    procedure TestConnectionPooling;
    procedure TestParamBindMode;
    procedure TestSeveralCursors;
    procedure TestTransactions;
    procedure TestCommands;
    procedure TestMapping;
  end;

  TADQATsThreadForPoolingCmp = class (TThread)
  private
    FConnectionDef:    String;
    FCounter:    TADQATsThreadCounter;
    FConnection: TADConnection;
    FCommand:    TADCommand;
  public
    constructor Create(AConnectionDef: String; ACounter: TADQATsThreadCounter);
    destructor Destroy; override;
    procedure Execute; override;
  end;


implementation

uses
{$IFDEF AnyDAC_D6}
  Variants,
{$ENDIF}  
  ADQAConst, ADQAUtils,
  daADCompDataSet;

{-------------------------------------------------------------------------------}
{ TADQACompTsHolderBase                                                         }
{-------------------------------------------------------------------------------}
function TADQACompTsHolderBase.RunBeforeTest: Boolean;
begin
  Result := inherited RunBeforeTest;
  if FRDBMSKind <> mkUnknown then
    Result := CompConnSwitch;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompTsHolderBase.FillTables;
var
  i, j: Integer;
  oQryMast, oQryDetails: TADQuery;
begin
  oQryMast := TADQuery.Create(nil);
  oQryDetails := TADQuery.Create(nil);
  oQryMast.Connection := FConnection;
  oQryDetails.Connection := FConnection;
  try
    with oQryDetails do begin
      SQL.Text := 'delete from {id ADQA_details_autoinc}';
      ExecSQL;
      SQL.Text := 'delete from {id ADQA_master_autoinc}';
      ExecSQL;

      SQL.Text := 'insert into {id ADQA_master_autoinc}(name1) values(:name1)';
      Params.ArraySize := 10;
      for i := 0 to 9 do
        Params[0].AsStrings[i] := 'first' + IntToStr(i);
      Execute(10);

      SQL.Text := 'insert into {id ADQA_details_autoinc}(fk_id1, name2) values(:id1, :name2)';
      Params.ArraySize := 5;
      oQryMast.SQL.Text := 'select * from {id ADQA_master_autoinc} order by id1';
      oQryMast.Open;
      while not oQryMast.Eof do begin
        for j := 0 to 4 do begin
          Params[0].AsIntegers[j] := oQryMast.FieldByName('id1').AsInteger;
          Params[1].AsStrings[j] := 'second' + IntToStr(j);
        end;
        Execute(5);
        oQryMast.Next;
      end;
    end;
  finally
    oQryMast.Free;
    oQryDetails.Free;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADQACompCNNTsHolder                                                          }
{-------------------------------------------------------------------------------}
procedure TADQACompCNNTsHolder.RegisterTests;
begin
  RegisterTest('Connection;Transactions;DB2',          TestTransactions, mkDB2, False);
  RegisterTest('Connection;Transactions;MS Access',    TestTransactions, mkMSAccess, False);
  RegisterTest('Connection;Transactions;MSSQL',        TestTransactions, mkMSSQL, False);
  RegisterTest('Connection;Transactions;ASA',          TestTransactions, mkASA, False);
  RegisterTest('Connection;Transactions;MySQL',        TestTransactions, mkMySQL, False);
  RegisterTest('Connection;Transactions;Oracle',       TestTransactions, mkOracle, False);
  RegisterTest('Connection;Several Cursors;DB2',       TestSeveralCursors, mkDB2);
  RegisterTest('Connection;Several Cursors;MS Access', TestSeveralCursors, mkMSAccess);
  RegisterTest('Connection;Several Cursors;MSSQL',     TestSeveralCursors, mkMSSQL);
  RegisterTest('Connection;Several Cursors;ASA',       TestSeveralCursors, mkASA);
  RegisterTest('Connection;Several Cursors;MySQL',     TestSeveralCursors, mkMySQL);
  RegisterTest('Connection;Several Cursors;Oracle',    TestSeveralCursors, mkOracle);
  RegisterTest('Connection;Pooling;DB2',               TestConnectionPooling, mkDB2, False);
  RegisterTest('Connection;Pooling;MS Access',         TestConnectionPooling, mkMSAccess, False);
  RegisterTest('Connection;Pooling;MSSQL',             TestConnectionPooling, mkMSSQL, False);
  RegisterTest('Connection;Pooling;ASA',               TestConnectionPooling, mkASA, False);
  RegisterTest('Connection;Pooling;MySQL',             TestConnectionPooling, mkMySQL, False);
  RegisterTest('Connection;Pooling;Oracle',            TestConnectionPooling, mkOracle, False);
  RegisterTest('Command;Def. with merge;DB2',          TestCommandDefAndMerge, mkDB2);
  RegisterTest('Command;Def. with merge;MS Access',    TestCommandDefAndMerge, mkMSAccess);
  RegisterTest('Command;Def. with merge;MSSQL',        TestCommandDefAndMerge, mkMSSQL);
  RegisterTest('Command;Def. with merge;ASA',          TestCommandDefAndMerge, mkASA);
  RegisterTest('Command;Def. with merge;MySQL',        TestCommandDefAndMerge, mkMySQL);
  RegisterTest('Command;Def. with merge;Oracle',       TestCommandDefAndMerge, mkOracle);
  RegisterTest('Command;Params-Bind mode;DB2',         TestParamBindMode, mkDB2);
  RegisterTest('Command;Params-Bind mode;MS Access',   TestParamBindMode, mkMSAccess);
  RegisterTest('Command;Params-Bind mode;MSSQL',       TestParamBindMode, mkMSSQL);
  RegisterTest('Command;Params-Bind mode;ASA',         TestParamBindMode, mkASA);
  RegisterTest('Command;Params-Bind mode;MySQL',       TestParamBindMode, mkMySQL);
  RegisterTest('Command;Params-Bind mode;Oracle',      TestParamBindMode, mkOracle);
  RegisterTest('Adapter;Commands',                     TestCommands, mkMySQL);
  RegisterTest('Adapter;Mapping',                      TestMapping, mkMySQL);
end;

{-------------------------------------------------------------------------------}
constructor TADQACompCNNTsHolder.Create(const AName: String);
begin
  inherited Create(AName);
  FCommand := TADCommand.Create(nil);
  FCommand.Connection := FConnection;
  FTableAdapter := TADTableAdapter.Create(nil);
  FSchemaAdapter := TADSchemaAdapter.Create(nil);
end;

{-------------------------------------------------------------------------------}
destructor TADQACompCNNTsHolder.Destroy;
begin
  FCommand.Free;
  FCommand := nil;
  FTableAdapter.Free;
  FTableAdapter := nil;
  FSchemaAdapter.Free;
  FSchemaAdapter := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCNNTsHolder.ClearAfterTest;
begin
  FCommand.Close;
  FTableAdapter.Reset;
  if FTableAdapter.DatSTable <> nil then
    FTableAdapter.DatSTable.Reset;
  inherited ClearAfterTest;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCNNTsHolder.TestCommands;
var
  i: Integer;
  aCmd: array [0..3] of TADCommand;

  procedure PrepareTest;
  var
    i, j: Integer;
  begin
    for i := 0 to 3 do begin
      aCmd[i] := TADCommand.Create(nil);
      aCmd[i].Connection := FConnection;
    end;
    with FQuery do begin
      SQL.Text := 'delete from {id ADQA_map1}';
      ExecSQL;

      SQL.Text := 'delete from {id ADQA_map2}';
      ExecSQL;

      SQL.Text := 'delete from {id ADQA_map3}';
      ExecSQL;

      SQL.Text := 'delete from {id ADQA_map4}';
      ExecSQL;

      for i := 1 to 4 do begin
        SQL.Text := 'insert into {id ADQA_map' + IntToStr(i) +
                '}(id' + IntToStr(i) + ', name' + IntToStr(i) + ') values(:id, :name)';
        Params.ArraySize := 5;
        for j := 0 to 4 do begin
          Params[0].AsIntegers[j] := j;
          Params[1].AsStrings[j]  := 'string' + IntToStr(j);
        end;
        try
          Execute(5);
        except
          on E: Exception do
            Error(E.Message);
        end;
      end;
    end;
  end;

begin
  PrepareTest;
  try
    with FTableAdapter do begin
      SourceRecordSetName := '`ADQA_map1`';
      ColumnMappings.Add('id1',   'id');
      ColumnMappings.Add('name1', 'name');

      SelectCommand := aCmd[0];
      SelectCommand.CommandText.Text := 'select * from {id ADQA_map1} order by id1';
      Define;
      Fetch;

      InsertCommand := aCmd[1];
      InsertCommand.CommandText.Text := 'insert into {id ADQA_map2}(id2, name2)' +
                                        ' values(:NEW_id, :NEW_name)';

      DeleteCommand := aCmd[2];
      DeleteCommand.CommandText.Text := 'delete from {id ADQA_map3} where id3 = :OLD_id';

      UpdateCommand := aCmd[3];
      UpdateCommand.CommandText.Text := 'update {id ADQA_map4} set id4 = :NEW_id,' +
                                        ' name4 = :NEW_name where id4 = :OLD_id';

      // 1.
      for i := 0 to 4 do
        DatSTable.Rows.Add([1000 + i, 'somth.' + IntToStr(i)]);
      i := Update;
      if i <> 0 then begin
        Error(ErrorOnUpdate(i, 0));
        Exit;
      end;

      with FQuery do begin
        SQL.Text := 'select * from {id ADQA_map2} order by id2';
        Open;
      end;
      if not CheckRowsCount(nil, 10, FQuery.RecordCount) then
        Exit;
      for i := 5 to 9 do
        if FQuery.Table.Rows[i].CompareRows(DatSTable.Rows[i], rvDefault, []) <> 0 then
          Error(ComparingRowFails('row num = ' + IntToStr(i)));

      // 2.
      DatSTable.Rows[0].Delete;
      i := Update;
      if i <> 0 then begin
        Error(ErrorOnUpdate(i, 0));
        Exit;
      end;

      with FQuery do begin
        SQL.Text := 'select * from {id ADQA_map3} order by id3';
        Open;
      end;
      if not CheckRowsCount(nil, 4, FQuery.RecordCount) then
        Exit;
      for i := 0 to 3 do
        if FQuery.Table.Rows[i].CompareRows(DatSTable.Rows[i + 1], rvDefault, []) <> 0 then
          Error(ComparingRowFails('row num = ' + IntToStr(i)));

      // 3.
      for i := 0 to 3 do
        with DatSTable.Rows[i + 1] do begin
          BeginEdit;
          SetValues([1100 + i, 'string110' + IntToStr(i)]);
          EndEdit;
        end;
      i := Update;
      if i <> 1 then begin
        Error(ErrorOnUpdate(i, 1));
        Exit;
      end;

      with FQuery do begin
        SQL.Text := 'select * from {id ADQA_map4} order by id4';
        Open;
      end;
      if not CheckRowsCount(nil, 5, FQuery.RecordCount) then
        Exit;
      for i := 0 to 3 do
        if FQuery.Table.Rows[i + 1].CompareRows(DatSTable.Rows[i + 1], rvDefault, []) <> 0 then
          Error(ComparingRowFails('row num = ' + IntToStr(i)));
    end;
  finally
    for i := 0 to 3 do begin
      aCmd[i].Free;
      aCmd[i] := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCNNTsHolder.TestMapping;
var
  i:      Integer;
  V1, V2: Variant;

  procedure PrepareTest;
  var
    i: Integer;
  begin
    with FQuery do begin
      SQL.Text := 'delete from {id ADQA_map1}';
      ExecSQL;
      SQL.Text := 'delete from {id ADQA_map2}';
      ExecSQL;

      SQL.Text := 'insert into {id ADQA_map1}(id1, name1) values(:id1, :name1)';
      Params.ArraySize := 10;
      for i := 0 to 9 do begin
        Params[0].AsIntegers[i] := i;
        Params[1].AsStrings[i] := 'first' + IntToStr(i);
      end;
      Execute(10);

      SQL.Text := 'insert into {id ADQA_map2}(id2, name2) values(:id2, :name2)';
      Params.ArraySize := 10;
      for i := 0 to 9 do begin
        Params[0].AsIntegers[i] := i;
        Params[1].AsStrings[i] := 'first' + IntToStr(i);
      end;
      Execute(10);
    end;

    FTableAdapter.SchemaAdapter := FSchemaAdapter;  // here in the procedure System._IntfClear an exception is raised
    FSchemaAdapter.DatSManager := FDatSManager;
    FSchemaAdapter.DatSManager.UpdatesRegistry := True;
  end;

begin
  PrepareTest;

  // fetching information from base
  with FTableAdapter do begin
    SourceRecordSetName := '`ADQA_map1`';
    DatSTableName := 'mapper';
    UpdateTableName := '`ADQA_map2`';
    ColumnMappings.Add('id1', 'num', '`id2`');
    ColumnMappings.Add('name1', 'title', '`name2`');

    SelectCommand := FCommand;
    SelectCommand.CommandText.Text := 'select * from {id ADQA_map1} order by id1';
    Define;
    Fetch;
  end;

  // changing information
  for i := 0 to 9 do
    with FTableAdapter.DatSTable.Rows[i] do begin
      BeginEdit;
      SetValues([i * 10, 'second' + IntToStr(i)]);
      EndEdit;
    end;
  // updating information in the base
  i := FSchemaAdapter.Update;
  if i <> 0 then
    Error(ErrorOnUpdate(i, 0));

  // checking info in the base
  with FQuery do begin
    SQL.Text := 'select * from {id ADQA_map2} order by id2';
    Open;
  end;

  if not CheckRowsCount(nil, 10, FQuery.RecordCount) then
    Exit;

  for i := 0 to FQuery.Table.Rows.Count - 1 do begin
    V1 := FQuery.Table.Rows[i].GetData(0);
    V2 := FSchemaAdapter.DatSManager.Tables.ItemsS['mapper'].Rows[i].GetData(0);
    if Compare(V1, V2) <> 0 then
      Error(WrongValueInTable(FQuery.Table.Columns[0].Name, i,
                              VarToStr(V1), VarToStr(V2)));

    V1 := FQuery.Table.Rows[i].GetData(1);
    V2 := FSchemaAdapter.DatSManager.Tables.ItemsS['mapper'].Rows[i].GetData(1);
    if Compare(V1, V2) <> 0 then
      Error(WrongValueInTable(FQuery.Table.Columns[1].Name, i,
                              VarToStr(V1), VarToStr(V2)));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCNNTsHolder.TestCommandDefAndMerge;
var
  lWasExc: Boolean;

  procedure ConfigureTable;
  begin
    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;
    FTab.SourceName := EncodeName(FRDBMSKind, 'Categories');
    with FTab.Columns.Add('CategoryID', dtInt32) do begin
      SourceID := 1;
      SourceName := 'Categoryid';
      AutoIncrement := True;
      AutoIncrementSeed := -2;
      AutoIncrementStep := -3;
    end;
  end;

  procedure DefineTab(ATable: String; AMode: TADPhysMetaInfoMergeMode);
  begin
    with FCommand do begin
      CommandText.Text := Format(SelectFromStmt, [ATable]);
      Define(FTab, AMode);
    end;
  end;

  procedure DefineManager(ATable: String; AMode: TADPhysMetaInfoMergeMode);
  begin
    with FCommand do begin
      CommandText.Text := Format(SelectFromStmt, [ATable]);
      Define(FDatSManager, nil, AMode);
    end;
  end;

begin
  ConfigureTable;
  DefineTab('Categories', mmOverride);
  CheckColumnsCount(FTab, 4);

  ConfigureTable;
  lWasExc := False;
  try
    DefineTab('Categories', mmRely);
  except
    on E: Exception do begin
      Error(E.Message);
      lWasExc := True;
    end;
  end;
  if not lWasExc then
    CheckColumnsCount(FTab, 1);

  ConfigureTable;
  DefineManager('Products', mmRely);
  if FDatSManager.Tables.Count <> 1 then
    Error(WrongTableCount(1, FDatSManager.Tables.Count))
  else
    CheckColumnsCount(FTab, 1);

  ConfigureTable;
  DefineManager('Products', mmOverride);
  if FDatSManager.Tables.Count <> 2 then
    Error(WrongTableCount(2, FDatSManager.Tables.Count))
  else begin
    DefineManager('Categories', mmOverride);
    CheckColumnsCount(FTab, 4, -1, '[Define(FDatSManager, nil, mmOverride)]');
    if AnsiCompareText(FTab.SourceName, EncodeName(FRDBMSKind, 'Categories')) <> 0 then
      Error(WrongTableName(EncodeName(FRDBMSKind,'Categories'), FTab.SourceName) +
                           '. [Define(FDatSManager, nil, mmOverride)]');

    CheckColumnsCount(FDatSManager.Tables[1], 10, -1, '[Define(FDatSManager, nil, mmOverride)]');
    if AnsiCompareText(FDatSManager.Tables[1].SourceName, EncodeName(FRDBMSKind,'Products')) <> 0 then
      Error(WrongTableName(EncodeName(FRDBMSKind,'Products'), FDatSManager.Tables[1].SourceName));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCNNTsHolder.TestConnectionPooling;
var
  oConnectionDef:   IADStanConnectionDef;
  iTickTrue,
  iTickFalse: LongWord;

  procedure CreateConnectionDef(APooled: Boolean);
  begin
    ADManager.Open;
    oConnectionDef := ADManager.ConnectionDefs.AddConnectionDef as IADStanConnectionDef;
    oConnectionDef.ParentDefinition := ADManager.ConnectionDefs.ConnectionDefByName(GetConnectionDef(FRDBMSKind));
    oConnectionDef.Name := 'Pooled';
    oConnectionDef.Pooled := APooled;
  end;

  function RunThreads: LongWord;
  var
    oCounter: TADQATsThreadCounter;
    i:        Integer;
  begin
    oCounter := TADQATsThreadCounter.Create(C_THREAD_COUNT);
    try
      Result := GetTickCount;
      for i := 0 to C_THREAD_COUNT - 1 do begin
        TADQATsThreadForPoolingCmp.Create('Pooled', oCounter);
        if i = 0 then
          Sleep(10000);
      end;
      oCounter.Wait;
      Result := GetTickCount - Result - 10000;
    finally
      oConnectionDef := nil;
      ADPhysManager.Close(False);
      Trace('>> while ADPhysManager.State <> dmsInactive do Sleep(0);');
      while ADPhysManager.State <> dmsInactive do
        Sleep(0);
      Trace('<< while ADPhysManager.State <> dmsInactive do Sleep(0);');
      oCounter.Free;
    end;
  end;

begin
  SetConnectionDefFileName(CONN_DEF_STORAGE, True);

  CreateConnectionDef(True);
  iTickTrue := RunThreads;
  Trace(C_AD_PhysRDBMSKinds[FRDBMSKind] + ', pooled time = ' + FloatToStr(iTickTrue / 1000) + ' sec');

  CreateConnectionDef(False);
  iTickFalse := RunThreads;
  Trace(C_AD_PhysRDBMSKinds[FRDBMSKind] + ', not pooled time = ' + FloatToStr(iTickFalse / 1000) + ' sec');

  if iTickFalse < iTickTrue then
    Error(PoolingError(iTickFalse, iTickTrue));
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCNNTsHolder.TestParamBindMode;
var
  j:      TADParamBindMode;
  i:      Integer;
  V1, V2: Variant;
begin
  for j := Low(TADParamBindMode) to High(TADParamBindMode) do
    with FCommand do begin
      CommandText.Text := 'delete from {id ADQA_ParamBind}';
      Execute;

      ParamBindMode := j;
      CommandText.Text := 'insert into {id ADQA_ParamBind}(p1, p2, p3, p4) ' +
                     'values(:p1, :p2, :p1, :p4)';
      if (j = pbByName) then begin
        if (FRDBMSKind = mkOracle) and (Params.Count <> 3) or
           (FRDBMSKind <> mkOracle) and (Params.Count <> 4) then begin
          if FRDBMSKind = mkOracle then
            Error(WrongParCount(Params.Count, 3) + '. [pbByName]')
          else
            Error(WrongParCount(Params.Count, 4) + '. [pbByName]');
          CommandText.Text := '';
          CommandKind := skUnknown;
          continue;
        end;
        with Params do begin
          ParamByName('p1').AsString := 'str0';
          ParamByName('p2').AsString := 'str1';
          ParamByName('p4').AsString := 'str2';
        end;
        Prepare;
        Execute;

        CommandText.Text := 'select * from {id ADQA_ParamBind}';
        try
          Define(FTab);
          Open;
          Fetch(FTab, True);
        except
          on E: Exception do begin
            Error(E.Message);
            Exit;
          end;
        end;

        for i := 0 to 3 do begin
          V1 := FTab.Rows[0].GetData(i);
          if i in [0, 1] then
            V2 := 'str' + IntToStr(i)
          else if i = 2 then
            V2 := 'str0'
          else
            V2 := 'str2';
          if AnsiCompareText(V1, V2) <> 0 then
            Error(ParBindMode(ParamBindModes[j], VarToStr(V2), VarToStr(V1)));
        end;
      end
      else begin
        if (Params.Count <> 4) then begin
          Error(WrongParCount(Params.Count, 4) + '. [pbByNumber]');
          continue;
        end;
        if Params[0].Name <> Params[2].Name then
          Error(WrongParamName(Params[2].Name, Params[0].Name));
        for i := 0 to 3 do
          Params[i].AsString := 'str' + IntToStr(i);
        Prepare;
        try
          Execute;
        except
          on E: Exception do begin
            Error(E.Message);
            Exit;
          end;
        end;

        CommandText.Text := 'select * from {id ADQA_ParamBind}';
        Define(FTab);
        Open;
        Fetch(FTab, True);

        for i := 0 to 3 do begin
          V1 := FTab.Rows[0].GetData(i);
          V2 := 'str' + IntToStr(i);
          if AnsiCompareText(V1, V2) <> 0 then
            Error(ParBindMode(ParamBindModes[j], VarToStr(V2), VarToStr(V1)));
        end;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCNNTsHolder.TestSeveralCursors;
var
  oQry1: TADQuery;
  oQry2: TADQuery;
begin
  oQry1 := TADQuery.Create(nil);
  oQry2 := TADQuery.Create(nil);
  oQry1.Connection := FConnection;
  oQry2.Connection := FConnection;
  try
    FConnection.TxOptions.Isolation := xiReadCommitted;
    FConnection.StartTransaction;
    if not FConnection.InTransaction then
      Error(TransIsInactive);
    try
      with oQry1 do begin
        with FetchOptions do begin
          Mode := fmOnDemand;
          RowsetSize := 10;
        end;
        SQL.Text := 'select * from {id Order Details}';
        Open;
      end;
      FConnection.Commit;
      if FConnection.InTransaction then
        Error(TransIsActive);
    except
      FConnection.Rollback;
      if FConnection.InTransaction then
        Error(TransIsActive);
    end;
    CheckRowsCount(nil, 10, oQry1.RecordCount);
    FConnection.StartTransaction;
    if not FConnection.InTransaction then
      Error(TransIsInactive);
    try
      with oQry2 do begin
        with FetchOptions do begin
          Mode := fmOnDemand;
          RowsetSize := 20;
        end;
        SQL.Text := 'select * from {id Order Details}';
        try
          Open;
        except
          on E: Exception do
            Error(E.Message);
        end;
      end;
      FConnection.Commit;
      if FConnection.InTransaction then
        Error(TransIsActive);
    except
      FConnection.Rollback;
      if FConnection.InTransaction then
        Error(TransIsActive);
    end;
    CheckRowsCount(nil, 20, oQry2.RecordCount);
    oQry1.GetNextPacket;
    CheckRowsCount(nil, 20, oQry1.RecordCount);
    oQry2.GetNextPacket;
    CheckRowsCount(nil, 40, oQry2.RecordCount);
  finally
    oQry1.Free;
    oQry2.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompCNNTsHolder.TestTransactions;
var
  oConn1, oConn2: TADConnection;
  oQry1, oQry2:   TADQuery;
  i, j: Integer;

  procedure PrepareTest;
  var
    i: Integer;
  begin
    SetConnectionDefFileName(CONN_DEF_STORAGE, True);

    oQry1 := TADQuery.Create(nil);
    oQry2 := TADQuery.Create(nil);

    oConn1 := TADConnection.Create(nil);
    oConn1.ConnectionDefName := GetConnectionDef(FRDBMSKind);
    if FRDBMSKind in [mkMSAccess, mkMSSQL, mkDB2] then
      oConn1.TxOptions.Isolation := xiDirtyRead
    else
      oConn1.TxOptions.Isolation := xiReadCommitted;
    oQry1.Connection := oConn1;

    oConn2 := TADConnection.Create(nil);
    oConn2.ConnectionDefName := GetConnectionDef(FRDBMSKind);
    if FRDBMSKind in [mkMSAccess, mkMSSQL, mkDB2] then
      oConn2.TxOptions.Isolation := xiDirtyRead
    else
      oConn2.TxOptions.Isolation := xiReadCommitted;
    oQry2.Connection := oConn2;
    try
      oConn1.LoginPrompt := False;
      oConn1.Open;
      oConn1.StartTransaction;
      with oQry1 do begin
        SQL.Text := 'delete from {id ADQA_TransTable}';
        ExecSQL;
      end;
      for i := 0 to 9 do
        with oQry1 do begin
          SQL.Text := Format('insert into {id ADQA_TransTable}(id, name) ' +
                             'values(%d, ''not changed%d'')', [i, i]);
          ExecSQL;
        end;
      oConn1.Commit;
    except
      on E: Exception do
        Error(E.Message);
    end;
  end;

begin
  PrepareTest;
  try
    try
      // test
      oConn1.StartTransaction;
      if not oConn1.InTransaction then
        Error(TransIsInactive);
      with oQry1 do begin
        SQL.Text := Format('update {id ADQA_TransTable} set id = %d where id = %d',
                           [NEW_VAL1, 3]);
        ExecSQL;
      end;
      oConn2.LoginPrompt := False;
      oConn2.Open;
      oConn2.StartTransaction;
      if not oConn2.InTransaction then
        Error(TransIsInactive);
      with oQry2 do begin
        SQL.Text := Format('update {id ADQA_TransTable} set id = %d where id = %d',
                           [NEW_VAL2, 4]);
        ExecSQL;
      end;
      oConn1.Commit;
      if oConn1.InTransaction then
        Error(TransIsActive);
      oQry1.SQL.Text := 'select * from {id ADQA_TransTable} order by id';
      oQry1.Open;

      oConn2.Commit;
      if oConn2.InTransaction then
        Error(TransIsActive);
      oQry2.SQL.Text := 'select * from {id ADQA_TransTable} order by id';
      oQry2.Open;

      // analysis
      with oQry1 do begin
        Last;
        i := Fields[0].AsInteger;
        Prior;
        j := Fields[0].AsInteger;
        if (i <> NEW_VAL1) and (j <> NEW_VAL1) then
          Error('#1. ' + ErrorResultTrans);
        if (oConn1.TxOptions.Isolation = xiDirtyRead) and (i <> NEW_VAL2) or
           (oConn1.TxOptions.Isolation <> xiDirtyRead) and (i = NEW_VAL2) then
          Error(ThereIsUnexpRow);
      end;
      with oQry2 do begin
        Last;
        i := Fields[0].AsInteger;
        Prior;
        j := Fields[0].AsInteger;
        if (i <> NEW_VAL1) and (j <> NEW_VAL1) then
          Error('#2. ' + ErrorResultTrans);
        if i <> NEW_VAL2 then
          Error('#3. ' + ErrorResultTrans);
      end;
    except
      on E: Exception do
        Error(E.Message);
    end;
  finally
    oConn1.Free;
    oConn1 := nil;
    oConn2.Free;
    oConn2 := nil;
    oQry1.Free;
    oQry1 := nil;
    oQry2.Free;
    oQry2 := nil;
  end;
end;

{-------------------------------------------------------------------------------}
{  TADQATsThreadForPooling                                                      }
{-------------------------------------------------------------------------------}
constructor TADQATsThreadForPoolingCmp.Create(AConnectionDef: String;
      ACounter: TADQATsThreadCounter);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FConnectionDef := AConnectionDef;
  FCounter := ACounter;
  FConnection := TADConnection.Create(nil);
  FConnection.LoginPrompt := False;
  FCommand := TADCommand.Create(nil);
  Resume;
end;

{-------------------------------------------------------------------------------}
destructor TADQATsThreadForPoolingCmp.Destroy;
begin
  FConnection.Free;
  FConnection := nil;
  FCommand.Free;
  FCommand := nil;
  FCounter.Decrease;
  FCounter := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsThreadForPoolingCmp.Execute;
const
  C_COUNT = 2;
var
  i: Integer;
begin
  FConnection.ConnectionDefName := FConnectionDef;
  FConnection.Open;
  FCommand.Connection := FConnection;
  for i := 0 to C_COUNT - 1 do begin
    FCommand.CommandText.Text := 'select * from {id Shippers}';
    FCommand.Open;
  end;
end;

initialization

  ADQAPackManager.RegisterPack('Comp Layer', TADQACompCNNTsHolder);

end.
