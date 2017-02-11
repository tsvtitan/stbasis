{-------------------------------------------------------------------------------}
{ AnyDAC DApt Layer tests                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQADAptLayer;

interface

uses
  Classes, Windows, SysUtils,
  ADQAPack,
  daADStanIntf, daADStanOption, daADStanParam,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf,
  daADDAptIntf;

type
  TADQAErrorHandlerForThread = class;

  TADQADAptTsHolder = class (TADQATsHolderBase)
  private
    FSchAdapt: IADDAptSchemaAdapter;
    FAdapt:    IADDAptTableAdapter;
    procedure ChangeDatSRow;
    function DAptConnectionSwitch: Boolean;
    procedure PrepareTestLocking;
  public
    function RunBeforeTest: Boolean; override;
    procedure ClearAfterTest; override;
    procedure RegisterTests; override;
    procedure TestIdentityUpdate;
    procedure TestIdentityRefresh;
    procedure TestInsertNoValues;
    procedure TestInTrans;
    procedure TestOptimLocking;
    procedure TestPessLocking;
    procedure TestCommands;
    procedure TestMapping;
    procedure TestMySQLTimestamp;
    procedure TestStoredProc;
    procedure TestUpdateHandler;
  end;

  TADQATsThreadWithAdapter = class (TThread)
  private
    FConnection: IADPhysConnection;
    FAdapter: IADDAptTableAdapter;
    FTick1, FTick2,
    FWhere, FCntErrors: Integer;
    FWait: Boolean;
    FOwner: TADQATsHolderBase;
    FRDBMS: String;
  public
    constructor Create(ARDBMS: TADRDBMSKind; AWait: Boolean; AWhere: Integer;
      AErrHandler: TADQAErrorHandlerForThread = nil);
    procedure Execute; override;
    property Owner: TADQATsHolderBase read FOwner write FOwner;
    property Tick1: Integer read FTick1 write FTick1;
    property Tick2: Integer read FTick2 write FTick2;
  end;

  TADQAUpdateHandler = class (TInterfacedObject, IADDAptUpdateHandler)
  private
    FUpdateAction:    TADErrorAction;
    FReconcileAction: TADDAptReconcileAction;
    FCurrentVal:      Integer;
  public
    constructor Create;
    procedure ReconcileRow(ARow: TADDatSRow; var Action: TADDAptReconcileAction);
    procedure UpdateRow(ARow: TADDatSRow; ARequest: TADPhysUpdateRequest;
      AUpdOptions: TADPhysUpdateRowOptions; var AAction: TADErrorAction);
    property ReconcileAction: TADDAptReconcileAction read FReconcileAction write FReconcileAction;
    property UpdateAction: TADErrorAction read FUpdateAction write FUpdateAction default eaDefault;
  end;

  TADQAErrorHandlerForThread = class (TInterfacedObject, IADStanErrorHandler)
  private
    FErrorAction: TADErrorAction;
    FErrCounter:  Integer;
  public
    constructor Create;
    procedure HandleException(const AInitiator: IADStanObject; var AException: Exception);
    property ErrorAction: TADErrorAction read FErrorAction write FErrorAction;
    property ErrCounter: Integer read FErrCounter write FErrCounter;
  end;


implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, SqlTimSt,
{$ELSE}
  ActiveX, ComObj, 
{$ENDIF}  
  DB, 
  daADStanFactory, daADStanUtil,
  ADQAConst, ADQAUtils;

{-------------------------------------------------------------------------------}
{ TADQADAptTsHolder                                                             }
{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.RegisterTests;
begin
  RegisterTest('Mapping',                   TestMapping, mkMySQL);
  RegisterTest('Commands',                  TestCommands, mkMySQL);
  RegisterTest('Identity;Update;DB2',       TestIdentityUpdate, mkDB2);
  RegisterTest('Identity;Update;MS Access', TestIdentityUpdate, mkMSAccess);
  RegisterTest('Identity;Update;MSSQL',     TestIdentityUpdate, mkMSSQL);
  RegisterTest('Identity;Update;ASA',       TestIdentityUpdate, mkASA);
  RegisterTest('Identity;Update;MySQL',     TestIdentityUpdate, mkMySQL);
  RegisterTest('Identity;Update;Oracle',    TestIdentityUpdate, mkOracle);
  RegisterTest('Identity;Refresh;DB2',      TestIdentityRefresh, mkDB2);
  RegisterTest('Identity;Refresh;MS Access',TestIdentityRefresh, mkMSAccess);
  RegisterTest('Identity;Refresh;MSSQL',    TestIdentityRefresh, mkMSSQL);
  RegisterTest('Identity;Refresh;ASA',      TestIdentityRefresh, mkASA);
  RegisterTest('Identity;Refresh;MySQL',    TestIdentityRefresh, mkMySQL);
  RegisterTest('Identity;Refresh;Oracle',   TestIdentityRefresh, mkOracle);
  RegisterTest('Locking;Pessimistic;DB2',   TestPessLocking, mkDB2);
  RegisterTest('Locking;Pessimistic;MS Access',
                                            TestPessLocking, mkMSAccess);
  RegisterTest('Locking;Pessimistic;MSSQL', TestPessLocking, mkMSSQL);
  RegisterTest('Locking;Pessimistic;ASA',   TestPessLocking, mkASA);
  RegisterTest('Locking;Pessimistic;MySQL', TestPessLocking, mkMySQL);
  RegisterTest('Locking;Pessimistic;Oracle',TestPessLocking, mkOracle);
  RegisterTest('Locking;Optimistic;DB2',    TestOptimLocking, mkDB2);
  RegisterTest('Locking;Optimistic;MS Access',
                                            TestOptimLocking, mkMSAccess);
  RegisterTest('Locking;Optimistic;MSSQL',  TestOptimLocking, mkMSSQL);
  RegisterTest('Locking;Optimistic;ASA',    TestOptimLocking, mkASA);
  RegisterTest('Locking;Optimistic;MySQL',  TestOptimLocking, mkMySQL);
  RegisterTest('Locking;Optimistic;Oracle', TestOptimLocking, mkOracle);
  RegisterTest('In transaction;DB2',        TestInTrans, mkDB2);
  RegisterTest('In transaction;MS Access',  TestInTrans, mkMSAccess);
  RegisterTest('In transaction;MSSQL',      TestInTrans, mkMSSQL);
  RegisterTest('In transaction;ASA',        TestInTrans, mkASA);
  RegisterTest('In transaction;MySQL',      TestInTrans, mkMySQL);
  RegisterTest('In transaction;Oracle',     TestInTrans, mkOracle);
  RegisterTest('Insert NO vals;DB2',        TestInsertNoValues, mkDB2);
  RegisterTest('Insert NO vals;MS Access',  TestInsertNoValues, mkMSAccess);
  RegisterTest('Insert NO vals;MSSQL',      TestInsertNoValues, mkMSSQL);
  RegisterTest('Insert NO vals;ASA',        TestInsertNoValues, mkASA);
  RegisterTest('Insert NO vals;MySQL',      TestInsertNoValues, mkMySQL);
  RegisterTest('Insert NO vals;Oracle',     TestInsertNoValues, mkOracle);
  RegisterTest('Update handler',            TestUpdateHandler, mkMySQL);
  RegisterTest('Stored procedure',          TestStoredProc, mkOracle);
  RegisterTest('MySQL timestamp',           TestMySQLTimestamp, mkMySQL);
end;

{-------------------------------------------------------------------------------}
function TADQADAptTsHolder.RunBeforeTest: Boolean;
begin
  Result := inherited RunBeforeTest;
  if FRDBMSKind <> mkUnknown then
    Result := DAptConnectionSwitch;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.ClearAfterTest;
begin
  FSchAdapt := nil;
  FAdapt    := nil;
  inherited ClearAfterTest;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.PrepareTestLocking;
var
  i: Integer;
begin
  with FCommIntf do begin
    Prepare('delete from {id ADQA_LockTable}');
    Execute;
    for i := 0 to 9 do begin
      Prepare('insert into {id ADQA_LockTable}(id, name) values(' + IntToStr(i) +
              ', ''not changed' + IntToStr(i) + ''')');
      Execute;
    end;
    Disconnect;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.ChangeDatSRow;
begin
  with FAdapt.DatSTable.Rows[NUM_WHERE] do begin
    BeginEdit;
    SetValues([1000, 'changed by Adapter']);
    EndEdit;
  end;
end;

{-------------------------------------------------------------------------------}
function TADQADAptTsHolder.DAptConnectionSwitch: Boolean;
begin
  Result := True;
  try
    FDatSManager.Reset;
    FTab := FDatSManager.Tables.Add;

    SetConnectionDefFileName(CONN_DEF_STORAGE);
    OpenPhysManager;

    ADPhysManager.CreateConnection(GetConnectionDef(FRDBMSKind), FConnIntf);
    FConnIntf.LoginPrompt := False;
    FConnIntf.Open;
    FConnIntf.CreateCommand(FCommIntf);

    ADCreateInterface(IADDAptSchemaAdapter, FSchAdapt);
    FSchAdapt.DatSManager := FDatSManager;
    FSchAdapt.DatSManager.UpdatesRegistry := True;
  except
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestIdentityUpdate;
var
  oCmd:       IADPhysCommand;
  oMastAdapt,
  oDetAdapt:  IADDAptTableAdapter;
  oMasterRow: TADDatSRow;
  oMastTab,
  oDetTab:    TADDatSTable;
  i, j,
  iLastMastId,
  iLastDetId: Integer;

  procedure PrepareTest;
  var
    i, j: Integer;
    oTab: TADDatSTable;
  begin
    oTab     := FDatSManager.Tables.Add;
    oMastTab := FDatSManager.Tables.Add;
    oDetTab  := FDatSManager.Tables.Add;

    with FCommIntf do begin
      Prepare('delete from {id ADQA_details_autoinc}');
      Execute;
      Prepare('delete from {id ADQA_master_autoinc}');
      Execute;

      for i := 0 to 9 do begin
        Prepare('insert into {id ADQA_master_autoinc}(name1) values(''first' +
                IntToStr(i) + ''')');
        Execute;
      end;

      Prepare('select * from {id ADQA_master_autoinc} order by id1');
      Define(oTab);
      Open;
      Fetch(oTab);

      iLastMastId := oTab.Rows[9].GetData('id1');

      for i := 0 to 9 do
        for j := 0 to 4 do begin
          Prepare('insert into {id ADQA_details_autoinc}(fk_id1, name2) ' +
                  'values(' + VarToStr(oTab.Rows[i].GetData(0)) + ', ''second' +
                   IntToStr(j) + ''')');
          Execute;
        end;

      Prepare('select * from {id ADQA_details_autoinc} order by id2');
      Define(oTab);
      Open;
      Fetch(oTab);

      iLastDetId := oTab.Rows[49].GetData('id2');
    end;
  end;

  procedure CheckFilling;
  var
    i, j:   Integer;
    V1, V2: Variant;
  begin
    for i := 0 to 5 do begin
      V1 := oMastTab.Rows[i + 10].GetData('id1');
      V2 := iLastMastId + i + 1;
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInTable('id1', i, VarToStr(V1), VarToStr(V2)));

      for j := 0 to 2 do begin
        V1 := oDetTab.Rows[(i * 3) + j + 50].GetData('id2');
        V2 := iLastDetId + (i * 3) + j + 1;
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInTable('id2', j, VarToStr(V1), VarToStr(V2)));

        V1 := oDetTab.Rows[(i * 3) + j + 50].GetData('fk_id1');
        V2 := iLastMastId + i + 1;
        if Compare(V1, V2) <> 0 then
          Error(WrongValueInTable('id2', j, VarToStr(V1), VarToStr(V2)));
      end;
    end;
  end;

  procedure CheckRowStates(AState: TADDatSRowState; AAdapt: IADDAptTableAdapter);
  var
    i: Integer;
  begin
    with AAdapt.DatSTable do
      for i := 0 to Rows.Count - 1 do
        if Rows[i].RowState <> AState then
          Error(WrongRowState(RowsStates[Rows[i].RowState], RowsStates[AState],
                'DatSTableName ' + AAdapt.DatSTableName));
  end;

  procedure ReFetchTables;
  begin
    with FCommIntf do begin
      Prepare('select * from {id ADQA_master_autoinc} order by id1');
      Define(oMastTab);
      Open;
      Fetch(oMastTab);

      Prepare('select * from {id ADQA_details_autoinc} order by id2');
      Define(oDetTab);
      Open;
      Fetch(oDetTab);
    end;
  end;

begin
  PrepareTest;

  oMastAdapt := FSchAdapt.TableAdapters.Add(EncodeName(FRDBMSKind, 'ADQA_master_autoinc'), 'master');
  with oMastAdapt do begin
    ColumnMappings.Add('id1',   'parent_id');
    ColumnMappings.Add('name1', 'title1');
    FConnIntf.CreateCommand(oCmd);
    SelectCommand := oCmd;
    SelectCommand.Prepare('select * from {id ADQA_master_autoinc} order by id1');
    Define;
    if DatSTable = nil then begin
      Error(DatSTableISNil);
      Exit;
    end;
    if not CheckColumnsCount(DatSTable, 2) then
      Exit;
    with DatSTable.Columns[0] do begin
      ServerAutoIncrement := True;
      AutoIncrementSeed := -1;
      AutoIncrementStep := -1;
    end;
    Fetch(True);
    CheckCommandState(csPrepared, SelectCommand);
  end;

  oDetAdapt := FSchAdapt.TableAdapters.Add(EncodeName(FRDBMSKind, 'ADQA_details_autoinc'), 'details');
  with oDetAdapt do begin
    ColumnMappings.Add('id2',    'child_id');
    ColumnMappings.Add('fk_id1', 'fk_parent_id');
    ColumnMappings.Add('name2',  'title2');
    FConnIntf.CreateCommand(oCmd);
    SelectCommand := oCmd;
    SelectCommand.Prepare('select * from {id ADQA_details_autoinc} order by id2');
    Define;
    if DatSTable = nil then begin
      Error(DatSTableISNil);
      Exit;
    end;
    if not CheckColumnsCount(DatSTable, 3) then
      Exit;
    with DatSTable.Columns[0] do begin
      ServerAutoIncrement := True;
      AutoIncrementSeed := -1;
      AutoIncrementStep := -1;
    end;
    Fetch(True);
    CheckCommandState(csPrepared, SelectCommand);
  end;

  with FSchAdapt.DatSManager.Tables.ItemsS['master'] do
    Constraints.AddUK('master_pk',  'parent_id', True);
  with FSchAdapt.DatSManager.Tables.ItemsS['details'] do begin
    Constraints.AddUK('details_pk', 'child_id',  True);
    with Constraints.AddFK('details_fk_master', 'master', 'parent_id',
                           'fk_parent_id') do begin
      UpdateRule := crCascade;
      DeleteRule := crCascade;
      AcceptRejectRule := arCascade;
    end;
  end;

  for i := 0 to 5 do begin
    oMasterRow := oMastAdapt.DatSTable.Rows.Add([Unassigned, 'third' + IntToStr(i)]);
    for j := 0 to 2 do
      oDetAdapt.DatSTable.Rows.Add([Unassigned, oMasterRow.GetData('parent_id'),
                                    'third' + IntToStr(j)]);
  end;

  i := FSchAdapt.Update;
  if i <> 0 then begin
    Error(ErrorOnUpdate(i, 0));
    Exit;
  end;

  if FSchAdapt.DatSManager.Updates.GetCount(nil) <> 24 then
    Error('Number of changed rows must be 24');

  FSchAdapt.DatSManager.AcceptChanges;
  CheckRowStates(rsUnchanged, oMastAdapt);
  CheckRowStates(rsUnchanged, oDetAdapt);
  ReFetchTables;
  CheckFilling;

  // check then identity fields when we update another fields
  for i := 0 to oMastAdapt.DatSTable.Rows.Count - 1 do
    with oMastAdapt.DatSTable.Rows[i] do begin
      BeginEdit;
      SetData(1, 'fourth_mast' + IntToStr(i));
      EndEdit;
    end;

  for i := 0 to oDetAdapt.DatSTable.Rows.Count - 1 do
    with oDetAdapt.DatSTable.Rows[i] do begin
      BeginEdit;
      SetData(2, 'fourth_det' + IntToStr(i));
      EndEdit;
    end;

  i := FSchAdapt.Update;
  if i <> 0 then
    Error(ErrorOnUpdate(i, 0));
  FSchAdapt.DatSManager.AcceptChanges;
  CheckRowStates(rsUnchanged, oMastAdapt);
  CheckRowStates(rsUnchanged, oDetAdapt);
  ReFetchTables;
  CheckFilling;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestIdentityRefresh;
var
  oCmd:   IADPhysCommand;
  oAdapt: IADDAptTableAdapter;
  oTab:   TADDatSTable;
  i, iLastId: Integer;

  procedure PrepareTest;
  var
    i: Integer;
  begin
    oTab := FDatSManager.Tables.Add;

    with FCommIntf do begin
      if FRDBMSKind in [mkOracle] then begin
        Prepare('delete from {id ADQA_details_autoinc}');
        Execute;
      end;

      Prepare('delete from {id ADQA_master_autoinc}');
      Execute;

      for i := 0 to 9 do begin
        Prepare('insert into {id ADQA_master_autoinc}(name1) values(''first' +
                IntToStr(i) + ''')');
        Execute;
      end;

      Prepare('select * from {id ADQA_master_autoinc} order by id1');
      Define(oTab);
      Open;
      Fetch(oTab);

      iLastId := oTab.Rows[9].GetData('id1');
    end;
  end;

  procedure CheckFilling(ATab: TADDatSTable);
  var
    i:      Integer;
    V1, V2: Variant;
  begin
    for i := 0 to 5 do begin
      V1 := ATab.Rows[i + 10].GetData(0);
      V2 := iLastId + i + 1;
      if Compare(V1, V2) <> 0 then
        Error(WrongValueInTable('id1', i, VarToStr(V1), VarToStr(V2)));
    end;
  end;

  procedure ReFetchTables;
  begin
    with FCommIntf do begin
      Prepare('select * from {id ADQA_master_autoinc} order by id1');
      Define(oTab);
      Open;
      Fetch(oTab);
    end;
  end;

begin
  PrepareTest;

  oAdapt := FSchAdapt.TableAdapters.Add(EncodeName(FRDBMSKind, 'ADQA_master_autoinc'), 'master');
  with oAdapt do begin
    ColumnMappings.Add('id1');
    ColumnMappings.Add('name1');
    FConnIntf.CreateCommand(oCmd);
    SelectCommand := oCmd;
    SelectCommand.Prepare('select * from {id ADQA_master_autoinc} order by id1');
    Define;
    if DatSTable = nil then begin
      Error(DatSTableISNil);
      Exit;
    end;
//???    if not (FRDBMSKind in [mkMSAccess, mkMSSQL, mkMySQL, mkASA]) then
      DatSTable.Columns[0].ServerAutoIncrement := True;
    if not CheckColumnsCount(DatSTable, 2) then
      Exit;
    Fetch(True);
  end;

  for i := 0 to 5 do
    oAdapt.DatSTable.Rows.Add([Unassigned, 'third' + IntToStr(i)]);

  i := FSchAdapt.Update;
  if i <> 0 then begin
    Error(ErrorOnUpdate(i, 0));
    Exit;
  end;
  FSchAdapt.DatSManager.AcceptChanges;

  CheckFilling(oAdapt.DatSTable);

  // check then identity fields when we update another fields
  for i := 0 to oAdapt.DatSTable.Rows.Count - 1 do
    with oAdapt.DatSTable.Rows[i] do begin
      BeginEdit;
      SetData(1, 'fourth' + IntToStr(i));
      EndEdit;
    end;

  i := FSchAdapt.Update;
  if i <> 0 then
    Error(ErrorOnUpdate(i, 0));
  FSchAdapt.DatSManager.AcceptChanges;

  CheckFilling(oAdapt.DatSTable);
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestInsertNoValues;
var
  i: Integer;
  V: Variant;

  procedure PrepareTest;
  var
    oCmd: IADPhysCommand;
  begin
    FTab := FDatSManager.Tables.Add;

    with FCommIntf do begin
      Prepare('delete from {id ADQA_NoValsTable}');
      Execute;
    end;

    FAdapt := FSchAdapt.TableAdapters.Add(EncodeName(FRDBMSKind, 'ADQA_NoValsTable'), 'NoValues');
    with FAdapt do begin
      ColumnMappings.Add('id', 'id');
      ColumnMappings.Add('name', 'name');

      FConnIntf.CreateCommand(oCmd);
      SelectCommand := oCmd;
      SelectCommand.Prepare('select * from {id ADQA_NoValsTable} order by id');
      Define;
      Fetch;
      CheckCommandState(csPrepared, SelectCommand);
    end;
  end;

begin
  PrepareTest;
  for i := 0 to 4 do
    FAdapt.DatSTable.Rows.Add([]);
  try
    i := FAdapt.Update;
    if i <> 0 then
      Error(ErrorOnUpdate(i, 0));
  except
    on E: Exception do
      Error(E.Message);
  end;
  RefetchTable('ADQA_NoValsTable', FTab, FCommIntf);
  if not CheckRowsCount(FTab, 5) then
    Exit;
  for i := 0 to 4 do begin
    V := FTab.Rows[i].GetData(0);
    if VarToValue(V, 0) <> 2000 then begin
      Error(WrongValueInTable('0', i, VarToValue(V, 0), '2000'));
      Exit;
    end;
    V := FTab.Rows[i].GetData(1);
    if AnsiCompareText(VarToValue(V, ''), 'hello') <> 0 then begin
      Error(WrongValueInTable('1', i, VarToValue(V, ''), 'hello'));
      Exit;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestInTrans;
var
  oCmd: IADPhysCommand;
  i: Integer;

  procedure NewAdapter;
  begin
    FAdapt := FSchAdapt.TableAdapters.Add(EncodeName(FRDBMSKind, 'ADQA_LockTable'), 'OptimLock');
    with FAdapt do begin
      ColumnMappings.Add('id', 'id');
      ColumnMappings.Add('name', 'name');

      FConnIntf.CreateCommand(oCmd);
      SelectCommand := oCmd;
      SelectCommand.Prepare('select * from {id ADQA_LockTable} order by id');
      Define;
      Fetch;
      CheckCommandState(csPrepared, SelectCommand);
    end;
  end;

begin
  PrepareTestLocking;
  NewAdapter;
  ChangeDatSRow;
  // 1.
  with FConnIntf do begin
    TxBegin;
    try
      i := FAdapt.Update;
      if i <> 0 then
        Error(ErrorOnUpdate(i, 0));
      if not TxIsActive then
        Error(TransIsInactive);
    finally
      TxRollback;
    end;
  end;

  PrepareTestLocking;
  NewAdapter;
  ChangeDatSRow;
  // 2.
  i := FAdapt.Update;
  if i <> 0 then
    Error(ErrorOnUpdate(i, 0));
  if FConnIntf.TxIsActive then
    Error(TransIsActive);
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestOptimLocking;
var
  iErrCnt: Integer;

  procedure NewAdapter;
  var
    oCmd: IADPhysCommand;
  begin
    FAdapt := FSchAdapt.TableAdapters.Add(EncodeName(FRDBMSKind, 'ADQA_LockTable'), 'OptimLock');
    with FAdapt do begin
      ColumnMappings.Add('id', 'id');
      ColumnMappings.Add('name', 'name');

      FConnIntf.CreateCommand(oCmd);
      SelectCommand := oCmd;
      SelectCommand.Prepare('select * from {id ADQA_LockTable} order by id');
      Define;
      Fetch;
      CheckCommandState(csPrepared, SelectCommand);
      with Options.UpdateOptions do begin
        LockMode   := lmOptimistic;
        UpdateMode := upWhereAll;
      end;
    end;
  end;

begin
  FTab := TADDatSTable.Create;
  try
    // 1.
    PrepareTestLocking;
    NewAdapter;
    ChangeDatSRow;
    with FCommIntf do begin
      FConnIntf.TxBegin;
      Prepare('update {id ADQA_LockTable} set id = 1000, name = ''changed by Adapter''' +
              ' where id = ' + IntToStr(NUM_WHERE));
      Execute;
      FConnIntf.TxCommit;

      iErrCnt := -1;
      FConnIntf.TxBegin;
      try
        iErrCnt := FAdapt.Update;
        FConnIntf.TxCommit;
      except
        on E: Exception do begin
          FConnIntf.TxRollback;
          Error(E.Message);
        end;
      end;
      if iErrCnt <> 1 then
        Error('#1. ' + CntErrOnUpdateIsWrong(iErrCnt, 1));
      RefetchTable('ADQA_LockTable', FTab, FCommIntf);
      with FTab do
        if (Rows[Rows.Count - 1].GetData(0) = 1000) and
           (Rows[Rows.Count - 2].GetData(0) = 1000) then
          Error(ThereAreTwoUpdRows);
    end;

    // 2.
    PrepareTestLocking;
    NewAdapter;
    ChangeDatSRow;
    with FCommIntf do begin
      Prepare('delete from {id ADQA_LockTable} where id = ' + IntToStr(NUM_WHERE));
      Execute;

      iErrCnt := FAdapt.Update;
      if iErrCnt <> 1 then
        Error('#2. ' + CntErrOnUpdateIsWrong(iErrCnt, 1));
      RefetchTable('ADQA_LockTable', FTab, FCommIntf);
      with FTab do
        if Rows[Rows.Count - 1].GetData(0) = 1000 then
          Error(ThereIsUnexpRow);
    end;
  finally
    FTab.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestPessLocking;
var
  oMyErrorHandler: TADQAErrorHandlerForThread;
  oThread:  TADQATsThreadWithAdapter;
  i: Integer;

  procedure Freezer;
  begin
    FConnIntf.TxBegin;
    try
      try
        with FCommIntf do begin
          Prepare('update {id ADQA_LockTable} ' +
                  'set name = ''changed by Freezer'' ' +
                  'where id = ' + IntToStr(NUM_WHERE));
          try
            try
              Execute;
            except
              on E: Exception do
                Error(E.Message);
            end;
          finally
            Unprepare;
          end;
        end;
        if FRDBMSKind in [mkMSAccess] then
          Trace('oThread.Resume');
        oThread.Resume;
        Sleep(4000);
      finally
        if FRDBMSKind in [mkMSAccess] then
          Trace('>> FConnIntf.TxRollback');
        FConnIntf.TxRollback;
        if FRDBMSKind in [mkMSAccess] then
          Trace('<< FConnIntf.TxRollback');
      end;
    except
    end;
  end;

  procedure Wait;
  begin
    if FRDBMSKind in [mkMSAccess] then
      Trace('>> oThread.WaitFor');
    oThread.WaitFor;
    if FRDBMSKind in [mkMSAccess] then
      Trace('<< oThread.WaitFor');
  end;

begin
  FTab := FDatSManager.Tables.Add;
  if FRDBMSKind <> mkMySQL then begin
    PrepareTestLocking;
    oThread := TADQATsThreadWithAdapter.Create(FRDBMSKind, False, NUM_WHERE);
    try
      Freezer;
      // waiting
      Wait;
      with oThread do
        if (Tick2 - Tick1) > 3900 then
          Error(UpdateExecTimeBig(Tick2 - Tick1, 3900));
      RefetchTable('ADQA_LockTable', FTab, FCommIntf);
      if FTab.Rows[FTab.Rows.Count - 1].GetData(0) = 1000 then
        Error(UpdateDuringTrans);
    finally
      oThread.Free;
    end;
  end;

  if not (FRDBMSKind in [mkMSAccess, mkASA]) then begin
    // other test - with UpdateOptions.LockWait := True
    PrepareTestLocking;
    oThread := TADQATsThreadWithAdapter.Create(FRDBMSKind, True, NUM_WHERE);
    try
      Freezer;
      // waiting
      Wait;
      with oThread do
        if (Tick2 - Tick1) < 3900 then
          Error(UpdateExecTimeSmall(Tick2 - Tick1, 3900));
      RefetchTable('ADQA_LockTable', FTab, FCommIntf);
      if FTab.Rows[FTab.Rows.Count - 1].GetData(0) <> 1000 then
        Error('#1. ' + DontUpdateAfterTrans);
    finally
      oThread.Free;
    end;
  end;

  // other test - with UpdateAction := eaRetry
  if not(FRDBMSKind in [mkMySQL]) then begin
    if FRDBMSKind in [mkMSAccess] then
      Trace('PrepareTestLocking');
    PrepareTestLocking;
    oMyErrorHandler := TADQAErrorHandlerForThread.Create;
    oMyErrorHandler.ErrorAction := eaRetry;
    if FRDBMSKind in [mkMSAccess] then
      Trace('oThread := TADQATsThreadWithAdapter.Create(FRDBMSKind, False, NUM_WHERE, oMyErrorHandler)');
    oThread := TADQATsThreadWithAdapter.Create(FRDBMSKind, False, NUM_WHERE, oMyErrorHandler);
    oThread.Owner := Self;
    try
      if FRDBMSKind in [mkMSAccess] then
        Trace('Freezer');
      Freezer;
      // waiting
      Wait;
      if FRDBMSKind in [mkMSAccess, mkDB2] then
        i := 2
      else
        i := 4;
      if oMyErrorHandler.ErrCounter <> i then
        Error(WrongCountOfUpdate(oMyErrorHandler.ErrCounter, i));

      Sleep(2000); // Required for MSAccess to reread the commited changes
                   // after the background thread with adapter had finished a work
      RefetchTable('ADQA_LockTable', FTab, FCommIntf);
      if FTab.Rows[FTab.Rows.Count - 1].GetData(0) <> 1000 then
        Error('#2. ' + DontUpdateAfterTrans);
    finally
      oThread.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestCommands;
var
  i: Integer;
  oCmd: IADPhysCommand;

  procedure PrepareTest;
  var
    i, j: Integer;
  begin
    with FCommIntf do begin
      Prepare('delete from {id ADQA_map1}');
      Execute;

      Prepare('delete from {id ADQA_map2}');
      Execute;

      Prepare('delete from {id ADQA_map3}');
      Execute;

      Prepare('delete from {id ADQA_map4}');
      Execute;

      for i := 1 to 4 do begin
        CommandText := 'insert into {id ADQA_map' + IntToStr(i) + '}(id' +
                       IntToStr(i) + ', name' + IntToStr(i) +
                       ') values(:id, :name)';
        Params.ArraySize := 5;
        Prepare;
        for j := 0 to 4 do begin
          Params[0].AsIntegers[j] := j;
          Params[1].AsStrings[j]  := 'string' + IntToStr(j);
        end;
        try
          try
            Execute(5);
          except
            on E: Exception do
              Error(E.Message);
          end;
        finally
          Unprepare;
        end;
      end;
    end;

    FTab := FDatSManager.Tables.Add;
  end;

begin
  PrepareTest;

  FAdapt := FSchAdapt.TableAdapters.Add(EncodeName(FRDBMSKind, 'ADQA_map1'), 'SelectCommand');
  with FAdapt do begin
    ColumnMappings.Add('id1',   'id');
    ColumnMappings.Add('name1', 'name');

    FConnIntf.CreateCommand(oCmd);
    SelectCommand := oCmd;
    SelectCommand.Prepare('select * from {id ADQA_map1} order by id1');
    Define;
    Fetch;
    CheckCommandState(csPrepared, SelectCommand);

    FConnIntf.CreateCommand(oCmd);
    InsertCommand := oCmd;
    InsertCommand.CommandText := 'insert into {id ADQA_map2}(id2, name2) ' +
                                 'values(:NEW_id, :NEW_name)';
    CheckCommandState(csInactive, InsertCommand);

    FConnIntf.CreateCommand(oCmd);
    DeleteCommand := oCmd;
    DeleteCommand.CommandText := 'delete from {id ADQA_map3} where id3 = :OLD_id';
    CheckCommandState(csInactive, DeleteCommand);

    FConnIntf.CreateCommand(oCmd);
    UpdateCommand := oCmd;
    UpdateCommand.CommandText := 'update {id ADQA_map4} set id4 = :NEW_id, ' +
                                 'name4 = :NEW_name where id4 = :OLD_id';
    CheckCommandState(csInactive, UpdateCommand);

    // 1.
    for i := 0 to 4 do
      DatSTable.Rows.Add([1000 + i, 'somth.' + IntToStr(i)]);
    i := FSchAdapt.Update;
    if i <> 0 then
      Error(ErrorOnUpdate(i, 0));

    with FCommIntf do begin
      Prepare('select * from {id ADQA_map2} order by id2');
      Define(FTab);
      Open;
      Fetch(FTab);
    end;
    if not CheckRowsCount(FTab, 10) then
      Exit;
    for i := 5 to 9 do
      if FTab.Rows[i].CompareRows(DatSTable.Rows[i], rvDefault, []) <> 0 then
        Error(ComparingRowFails('row num = ' + IntToStr(i)));

    // 2.
    DatSTable.Rows[0].Delete;
    i := FSchAdapt.Update;
    if i <> 0 then
      Error(ErrorOnUpdate(i, 0));

    with FCommIntf do begin
      Prepare('select * from {id ADQA_map3} order by id3');
      Define(FTab);
      Open;
      Fetch(FTab);
    end;
    if not CheckRowsCount(FTab, 4) then
      Exit;
    for i := 0 to 3 do
      if FTab.Rows[i].CompareRows(DatSTable.Rows[i + 1], rvDefault, []) <> 0 then
        Error(ComparingRowFails('row num = ' + IntToStr(i)));

    // 3.
    for i := 0 to 3 do
      with DatSTable.Rows[i + 1] do begin
        BeginEdit;
        SetValues([1100 + i, 'string110' + IntToStr(i)]);
        EndEdit;
      end;
    i := FSchAdapt.Update;
    if i <> 1 then
      Error(ErrorOnUpdate(i, 1));

    with FCommIntf do begin
      Prepare('select * from {id ADQA_map4} order by id4');
      Define(FTab);
      Open;
      Fetch(FTab);
    end;
    if not CheckRowsCount(FTab, 5) then
      Exit;
    for i := 0 to 3 do
      if FTab.Rows[i + 1].CompareRows(DatSTable.Rows[i + 1], rvDefault, []) <> 0 then
        Error(ComparingRowFails('row num = ' + IntToStr(i)));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestMapping;
var
  oAdapt: IADDAptTableAdapter;
  oCmd:   IADPhysCommand;
  oTab:   TADDatSTable;
  i:      Integer;
  V1, V2: Variant;

  procedure PrepareTest;
  var
    i: Integer;
  begin
    with FCommIntf do begin
      Prepare('delete from {id ADQA_map1}');
      Execute;
      Prepare('delete from {id ADQA_map2}');
      Execute;

      for i := 0 to 9 do begin
        Prepare('insert into {id ADQA_map1}(id1, name1) values(' + IntToStr(i) +
                ', ''first' + IntToStr(i) + ''')');
        Execute;
      end;
      for i := 0 to 9 do begin
        Prepare('insert into {id ADQA_map2}(id2, name2) values(' + IntToStr(i) +
                ', ''first' + IntToStr(i) + ''')');
        Execute;
      end;
    end;
  end;

begin
  PrepareTest;

  // fetching information from base
  oAdapt := FSchAdapt.TableAdapters.Add('`ADQA_map1`', 'mapper', '`ADQA_map2`');
  with oAdapt do begin
    ColumnMappings.Add('id1', 'num', '`id2`');
    ColumnMappings.Add('name1', 'title', '`name2`');
    FConnIntf.CreateCommand(oCmd);
    SelectCommand := oCmd;
    SelectCommand.Prepare('select * from {id ADQA_map1} order by id1');
    Define;
    Fetch;
    CheckCommandState(csPrepared, SelectCommand);
  end;

  // changing information
  for i := 0 to 9 do
    with oAdapt.DatSTable.Rows[i] do begin
      BeginEdit;
      SetValues([i * 10, 'second' + IntToStr(i)]);
      EndEdit;
    end;
  // updating information in the base
  i := FSchAdapt.Update;
  if i <> 0 then
    Error(ErrorOnUpdate(i, 0));

  // checking info in the base
  oTab := FDatSManager.Tables.Add('`map2`');

  with FCommIntf do begin
    Prepare('select * from {id ADQA_map2} order by id2');
    Define(oTab);
    Open;
    Fetch(oTab);
  end;

  if not CheckRowsCount(oTab, 10) then
    Exit;

  for i := 0 to oTab.Rows.Count - 1 do begin
    V1 := oTab.Rows[i].GetData(0);
    V2 := FSchAdapt.DatSManager.Tables.ItemsS['mapper'].Rows[i].GetData(0);
    if Compare(V1, V2) <> 0 then
      Error(WrongValueInTable(oTab.Columns[0].Name, i, VarToStr(V1), VarToStr(V2)));

    V1 := oTab.Rows[i].GetData(1);
    V2 := FSchAdapt.DatSManager.Tables.ItemsS['mapper'].Rows[i].GetData(1);
    if Compare(V1, V2) <> 0 then
      Error(WrongValueInTable(oTab.Columns[1].Name, i, VarToStr(V1), VarToStr(V2)));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestMySQLTimestamp;
var
  i: Integer;
  V1, V2: Variant;
begin
  with FCommIntf do begin
    Prepare('delete from {id ADQA_timestamp}');
    Execute;
  end;

  FAdapt := FSchAdapt.TableAdapters.Add('`ADQA_timestamp`');
  with FAdapt do begin
    SelectCommand := FCommIntf;
    FCommIntf.Prepare('select * from {id ADQA_timestamp}');
    Define;
    DatSTable.Columns[0].ServerAutoIncrement := True;
    Fetch;

    if not(caAllowNull in DatSTable.Columns[1].Attributes) then
      Error(WrongTimestampAttr);

    DatSTable.Rows.Add([]);
    with DatSTable.Rows.Add([]) do begin
      BeginEdit;
{$IFDEF AnyDAC_D6}
      SetData(1, VarSQLTimeStampCreate(TimeStamps[0]));
{$ELSE}
      SetData(1, ADSQLTimeStampToDateTime(TimeStamps[0]));
{$ENDIF}
      EndEdit;
    end;

    i := FSchAdapt.Update;
    if i <> 0 then begin
      Error(ErrorOnUpdate(i, 0));
      Exit;
    end;
    FSchAdapt.DatSManager.AcceptChanges;

    FTab := FDatSManager.Tables.Add;
    SelectCommand := nil;
    with FCommIntf do begin
      Prepare('select distinct curdate() from {id Categories}');
      Define(FTab);
      Open;
      Fetch(FTab);
    end;

{$IFDEF AnyDAC_D6}
    V1 := SQLTimeStampToDateTime(VarToSQLTimeStamp(DatSTable.Rows[0].GetData(1)));
{$ELSE}
    V1 := DatSTable.Rows[0].GetData(1);
{$ENDIF}
    V2 := VarAsType(FTab.Rows[0].GetData(0), varDate);
    if Abs(V1 - V2) >= 1 then
      Error(WrongValueInColumn(DatSTable.Columns[1].Name, '', VarToStr(DatSTable.Rows[0].GetData(1)),
                 VarToStr(FTab.Rows[0].GetData(0))) + '. Inserted null value');

    V1 := DatSTable.Rows[1].GetData(1);
{$IFDEF AnyDAC_D6}
    V2 := VarSQLTimeStampCreate(TimeStamps[0]);
{$ELSE}
    V2 := ADSQLTimeStampToDateTime(TimeStamps[0]);
{$ENDIF}
    if V1 <> V2 then
      Error(WrongValueInColumn(DatSTable.Columns[1].Name, '', VarToStr(V2),
                 VarToStr(V1)) + '. Inserted non null value');
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestStoredProc;
var
  oCmd:   IADPhysCommand;
  oAdapt: IADDAptTableAdapter;
  i:      Integer;
begin
  oAdapt := FSchAdapt.TableAdapters.Add('', 'StorProc');
  FConnIntf.CreateCommand(oCmd);
  oAdapt.SelectCommand := oCmd;
  with oAdapt.SelectCommand do begin
    BaseObjectName := 'ADQA_testpack';
    CommandText := 'SelectShippers';
    CommandKind := skStoredProcWithCrs;
    Options.FetchOptions.AutoClose := True;
    Prepare;
  end;
  oAdapt.Define;
  oAdapt.Fetch;
  CheckCommandState(csPrepared, oAdapt.SelectCommand);

  with FCommIntf do begin
    Prepare('select * from {id Shippers} order by ShipperID');
    Define(FTab);
    Open;
    Fetch(FTab);
  end;

  if not CheckRowsCount(FTab, oAdapt.DatSTable.Rows.Count) then
    Exit;

  for i := 0 to FTab.Rows.Count - 1 do
   if FTab.Rows[i].CompareRows(oAdapt.DatSTable.Rows[i], rvDefault, []) <> 0 then
     Error(ComparingRowFails('row num = ' + IntToStr(i)));
end;

{-------------------------------------------------------------------------------}
procedure TADQADAptTsHolder.TestUpdateHandler;
var
  i:      Integer;
  V1, V2: Variant;
  oAdapt: IADDAptTableAdapter;
  oTab:   TADDatSTable;
  oMyHandler: TADQAUpdateHandler;
  oCmd: IADPhysCommand;

  procedure PrepareTest;
  begin
    oTab := FDatSManager.Tables.Add;
    with FCommIntf do begin
      Prepare('delete from {id ADQA_map1}');
      Execute;
    end;

    oMyHandler := TADQAUpdateHandler.Create;
    FSchAdapt.UpdateHandler := oMyHandler as IADDAptUpdateHandler;
  end;

begin
  PrepareTest;

  oAdapt := FSchAdapt.TableAdapters.Add('`ADQA_map1`', 'tab');
  with oAdapt do begin
    ColumnMappings.Add('id1', 'num');
    ColumnMappings.Add('name1', 'title');
    FConnIntf.CreateCommand(oCmd);
    SelectCommand := oCmd;
    SelectCommand.Prepare('select * from {id ADQA_map1} order by id1');
    Define;
    Fetch;
    CheckCommandState(csPrepared, SelectCommand);
  end;

  oAdapt.DatSTable.Rows.Add([1, 'somth.']);

  oMyHandler.UpdateAction := eaApplied;
  FSchAdapt.Update;

  with oAdapt do begin
    DatSTable.Rows.Clear;
    SelectCommand.Prepare('select * from {id ADQA_map1} order by id1');
    Define;
    Fetch;
    CheckCommandState(csPrepared, oAdapt.SelectCommand);
    if not CheckRowsCount(DatSTable, 0) then
      Exit;

    for i := 0 to C_ROW_CNT do
      oAdapt.DatSTable.Rows.Add([1, 'something' + IntToStr(i)]);
  end;

  oMyHandler.UpdateAction    := eaDefault;
  oMyHandler.ReconcileAction := raCorrect;
  i := FSchAdapt.Update(C_ROW_CNT);
  if i <> C_ROW_CNT then
    Error(WrongErrCount(i, C_ROW_CNT));
  FSchAdapt.Reconcile;
  FSchAdapt.Update;

  with FCommIntf do begin
    Prepare('select * from {id ADQA_map1} order by id1');
    Define(oTab);
    Open;
    Fetch(oTab);
  end;

  if not CheckRowsCount(oTab, C_ROW_CNT + 1) then
    Exit;

  for i := 0 to C_ROW_CNT do begin
    V1 := oTab.Rows[i].GetData(0);
    V2 := i + 1;
    if V1 <> V2 then
      Error(WrongValueInTable(oTab.Columns[0].Name, i, V1, V2));
  end;

  with FCommIntf do begin
    Prepare('delete from {id ADQA_map1}');
    Execute;

    Prepare('insert into {id ADQA_map1}(id1, name1) values(1, ''somth.'')');
    Execute;
  end;

  i := FSchAdapt.Update;
  if i <> 1 then
    Error(WrongErrCount(i, 1));
end;

{-------------------------------------------------------------------------------}
{ TADQATsThreadWithAdapter                                                      }
{-------------------------------------------------------------------------------}
constructor TADQATsThreadWithAdapter.Create(ARDBMS: TADRDBMSKind; AWait: Boolean; AWhere: Integer;
  AErrHandler: TADQAErrorHandlerForThread = nil);
var
  oCmd: IADPhysCommand;
begin
  ADPhysManager.ConnectionDefs.Storage.FileName := CONN_DEF_STORAGE;
  OpenPhysManager;

  ADPhysManager.CreateConnection(GetConnectionDef(ARDBMS), FConnection);
  FConnection.LoginPrompt := False;
  FConnection.Open;

  ADCreateInterface(IADDAptTableAdapter, FAdapter);
  with FAdapter do begin
    DatSTable := TADDatSTable.Create;
    SourceRecordSetName := EncodeName(ARDBMS, 'ADQA_LockTable');

    ColumnMappings.Add('id',   'id');
    ColumnMappings.Add('name', 'name');

    FConnection.CreateCommand(oCmd);
    SelectCommand := oCmd;
    SelectCommand.Prepare('select * from {id ADQA_LockTable} order by id');
    Define;
    Fetch;
  end;

  if AErrHandler <> nil then
    FAdapter.ErrorHandler := AErrHandler as IADStanErrorHandler;
  FTick1 := 0;
  FTick2 := 0;
  FWhere := AWhere;
  FWait  := AWait;
  FCntErrors := 0;
  FRDBMS := GetConnectionDef(ARDBMS);

  FreeOnTerminate := False;
  inherited Create(True);
end;

{-------------------------------------------------------------------------------}
procedure TADQATsThreadWithAdapter.Execute;
begin
  FTick1 := GetTickCount;
  with FAdapter do begin
    Options.UpdateOptions.LockMode := lmPessimistic;
    Options.UpdateOptions.LockWait := FWait;
    try
      with DatSTable.Rows[FWhere] do begin
        BeginEdit;
        SetValues([1000, 'changed by Adapter']);
        EndEdit;
      end;
      if FOwner <> nil then
        FOwner.Trace('>> FCntErrors := Update: [' + FRDBMS + ']');
      FCntErrors := Update;
      if FOwner <> nil then
        FOwner.Trace('<< FCntErrors := Update: [' + FRDBMS + ']');
    except
    end;
  end;
  FConnection := nil;
  FAdapter := nil;
  FTick2 := GetTickCount;
end;

{-------------------------------------------------------------------------------}
{ TADQAUpdateHandler                                                            }
{-------------------------------------------------------------------------------}
constructor TADQAUpdateHandler.Create;
begin
  FCurrentVal := 1;
end;

{-------------------------------------------------------------------------------}
procedure TADQAUpdateHandler.ReconcileRow(ARow: TADDatSRow;
  var Action: TADDAptReconcileAction);
begin
  Inc(FCurrentVal);
  with ARow do begin
    BeginEdit;
    SetData(0, FCurrentVal);
    EndEdit;
  end;
  Action := FReconcileAction;
end;

{-------------------------------------------------------------------------------}
procedure TADQAUpdateHandler.UpdateRow(ARow: TADDatSRow; ARequest: TADPhysUpdateRequest;
  AUpdOptions: TADPhysUpdateRowOptions; var AAction: TADErrorAction);
begin
  AAction := FUpdateAction;
end;

{-------------------------------------------------------------------------------}
{ TADQAErrorHandlerForThread                                                    }
{-------------------------------------------------------------------------------}
constructor TADQAErrorHandlerForThread.Create;
begin
  FErrCounter := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADQAErrorHandlerForThread.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
begin
  if AException is EADDAptRowUpdateException then begin
    Sleep(1000);
    EADDAptRowUpdateException(AException).Action := FErrorAction;
    Inc(FErrCounter);
  end;
end;

initialization

  ADQAPackManager.RegisterPack('DApt Layer', TADQADAptTsHolder);

end.
