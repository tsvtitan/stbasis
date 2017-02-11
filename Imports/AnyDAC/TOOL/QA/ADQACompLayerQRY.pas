{-------------------------------------------------------------------------------}
{ AnyDAC Component Layer: TADQuery tests                                        }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQACompLayerQRY;

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
  TADQACompQRYTsHolder = class (TADQACompTsHolderBase)
  private
    procedure RunCompMacros(const ACommText: String; ADataType: TADMacroDataType;
      AIndx: Integer);
    procedure PrepareTestLocking;
  public
    procedure RegisterTests; override;
    procedure TestAsyncCmdExec;
    procedure TestAsyncCmdOpen;
    procedure TestBatchExec;
    procedure TestBatchExecAffect;
//    procedure TestCachedUpdAutoInc;
    procedure TestCurrencyBcdFmtBcd;
    procedure TestInsertNoValues;
    procedure TestInTrans;
    procedure TestMapRules;
    procedure TestMappingStrings;
    procedure TestOptimLocking;
    procedure TestOpenQuery;
    procedure TestPessLocking;
    procedure TestQueryDisconnectable;
    procedure TestReadWriteBlob;
    procedure TestStringsBorderLength;
    procedure TestKillConnection;
{$IFDEF AnyDAC_D6}
    procedure TestMySQLTimestamp;
{$ENDIF}
    procedure TestMacroDB2;
    procedure TestMacroMSAccess;
    procedure TestMacroMSSQL;
    procedure TestMacroASA;
    procedure TestMacroMySQL;
    procedure TestMacroOra;
    procedure TestOpenSameCol;
    procedure TestInsert;
    procedure TestMasterDetail;
  end;

  TADQATsThreadWithQuery = class (TThread)
  private
    FConnection: TADConnection;
    FQuery: TADQuery;
    FTick1, FTick2,
    FWhere, FCntErrors: Integer;
    FWait: Boolean;
  public
    constructor Create(ARDBMS: TADRDBMSKind; AWait: Boolean; AWhere: Integer);
    destructor Destroy; override;
    procedure Execute; override;
    property Tick1: Integer read FTick1 write FTick1;
    property Tick2: Integer read FTick2 write FTick2;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants, FMTBcd, SqlTimSt,
{$ELSE}
  ActiveX, ComObj, 
{$ENDIF}  
  Dialogs, Controls,
  ADQAConst, ADQAUtils, ADQAVarField,
  daADStanUtil, daADStanError,
  daADCompDataSet;

{-------------------------------------------------------------------------------}
{ TADQACompQRYTsHolder                                                          }
{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.RegisterTests;
begin
  RegisterTest('Query;Open;Types;DB2',           TestOpenQuery, mkDB2);
  RegisterTest('Query;Open;Types;MS Access',     TestOpenQuery, mkMSAccess);
  RegisterTest('Query;Open;Types;MSSQL',         TestOpenQuery, mkMSSQL);
  RegisterTest('Query;Open;Types;ASA',           TestOpenQuery, mkASA);
  RegisterTest('Query;Open;Types;MySQL',         TestOpenQuery, mkMySQL);
  RegisterTest('Query;Open;Types;Oracle',        TestOpenQuery, mkOracle);
  RegisterTest('Query;Open;Currency;DB2',        TestCurrencyBcdFmtBcd, mkDB2);
  RegisterTest('Query;Open;Currency;MS Access',  TestCurrencyBcdFmtBcd, mkMSAccess);
  RegisterTest('Query;Open;Currency;MSSQL',      TestCurrencyBcdFmtBcd, mkMSSQL);
  RegisterTest('Query;Open;Currency;ASA',        TestCurrencyBcdFmtBcd, mkASA);
  RegisterTest('Query;Open;Currency;MySQL',      TestCurrencyBcdFmtBcd, mkMySQL);
  RegisterTest('Query;Open;Currency;Oracle',     TestCurrencyBcdFmtBcd, mkOracle);
  RegisterTest('Query;Open;The same col;DB2',    TestOpenSameCol, mkDB2);
  RegisterTest('Query;Open;The same col;MS Access',TestOpenSameCol, mkMSAccess);
  RegisterTest('Query;Open;The same col;MSSQL',  TestOpenSameCol, mkMSSQL);
  RegisterTest('Query;Open;The same col;ASA',    TestOpenSameCol, mkASA);
  RegisterTest('Query;Open;The same col;MySQL',  TestOpenSameCol, mkMySQL);
  RegisterTest('Query;Open;The same col;Oracle', TestOpenSameCol, mkOracle);
  RegisterTest('Query;Macros;DB2',               TestMacroDB2, mkDB2);
  RegisterTest('Query;Macros;MS Access',         TestMacroMSAccess, mkMSAccess);
  RegisterTest('Query;Macros;MSSQL',             TestMacroMSSQL, mkMSSQL);
  RegisterTest('Query;Macros;ASA',               TestMacroASA, mkASA);
  RegisterTest('Query;Macros;MySQL',             TestMacroMySQL, mkMySQL);
  RegisterTest('Query;Macros;Oracle',            TestMacroOra, mkOracle);
  RegisterTest('Query;Blobs;DB2',                TestReadWriteBlob, mkDB2);
  RegisterTest('Query;Blobs;MS Access',          TestReadWriteBlob, mkMSAccess);
  RegisterTest('Query;Blobs;MSSQL',              TestReadWriteBlob, mkMSSQL);
  RegisterTest('Query;Blobs;ASA',                TestReadWriteBlob, mkASA);
  RegisterTest('Query;Blobs;MySQL',              TestReadWriteBlob, mkMySQL);
  RegisterTest('Query;Blobs;Oracle',             TestReadWriteBlob, mkOracle);
  RegisterTest('Query;Params;DB2',               TestStringsBorderLength, mkDB2);
  RegisterTest('Query;Params;MS Access',         TestStringsBorderLength, mkMSAccess);
  RegisterTest('Query;Params;MSSQL',             TestStringsBorderLength, mkMSSQL);
  RegisterTest('Query;Params;ASA',               TestStringsBorderLength, mkASA);
  RegisterTest('Query;Params;MySQL',             TestStringsBorderLength, mkMySQL);
  RegisterTest('Query;Params;Oracle',            TestStringsBorderLength, mkOracle);
  RegisterTest('Query;Batch exec;DB2',           TestBatchExec, mkDB2);
  RegisterTest('Query;Batch exec;MS Access',     TestBatchExec, mkMSAccess);
  RegisterTest('Query;Batch exec;MSSQL',         TestBatchExec, mkMSSQL);
  RegisterTest('Query;Batch exec;ASA',           TestBatchExec, mkASA);
  RegisterTest('Query;Batch exec;MySQL',         TestBatchExec, mkMySQL);
  RegisterTest('Query;Batch exec;Oracle',        TestBatchExec, mkOracle);
  RegisterTest('Query;Batch exec;With affect;DB2',       TestBatchExecAffect, mkDB2);
  RegisterTest('Query;Batch exec;With affect;MS Access', TestBatchExecAffect, mkMSAccess);
  RegisterTest('Query;Batch exec;With affect;MSSQL',     TestBatchExecAffect, mkMSSQL);
  RegisterTest('Query;Batch exec;With affect;ASA',       TestBatchExecAffect, mkASA);
  RegisterTest('Query;Batch exec;With affect;MySQL',     TestBatchExecAffect, mkMySQL);
  RegisterTest('Query;Batch exec;With affect;Oracle',    TestBatchExecAffect, mkOracle);
  RegisterTest('Query;Map rules;DB2',            TestMapRules, mkDB2);
  RegisterTest('Query;Map rules;MS Access',      TestMapRules, mkMSAccess);
  RegisterTest('Query;Map rules;MSSQL',          TestMapRules, mkMSSQL);
  RegisterTest('Query;Map rules;ASA',            TestMapRules, mkASA);
  RegisterTest('Query;Map rules;MySQL',          TestMapRules, mkMySQL);
  RegisterTest('Query;Map rules;Oracle',         TestMapRules, mkOracle);
  RegisterTest('Query;Map rules;Strings;DB2',    TestMappingStrings, mkDB2);
  RegisterTest('Query;Map rules;Strings;MSSQL',  TestMappingStrings, mkMSSQL);
  RegisterTest('Query;Map rules;Strings;Oracle', TestMappingStrings, mkOracle);
  RegisterTest('Query;Async;Exec;DB2',           TestAsyncCmdExec, mkDB2);
  RegisterTest('Query;Async;Exec;MS Access',     TestAsyncCmdExec, mkMSAccess);
  RegisterTest('Query;Async;Exec;MSSQL',         TestAsyncCmdExec, mkMSSQL);
  RegisterTest('Query;Async;Exec;ASA',           TestAsyncCmdExec, mkASA);
  RegisterTest('Query;Async;Exec;Oracle',        TestAsyncCmdExec, mkOracle);
  RegisterTest('Query;Async;Open;DB2',           TestAsyncCmdOpen, mkDB2);
  RegisterTest('Query;Async;Open;MS Access',     TestAsyncCmdOpen, mkMSAccess);
  RegisterTest('Query;Async;Open;MSSQL',         TestAsyncCmdOpen, mkMSSQL);
  RegisterTest('Query;Async;Open;ASA',           TestAsyncCmdOpen, mkASA);
  RegisterTest('Query;Async;Open;Oracle',        TestAsyncCmdOpen, mkOracle);
  RegisterTest('Query;Disconnectable',           TestQueryDisconnectable, mkOracle);
//  RegisterTest('Query;Cach updates. Identity;DB2',       TestCachedUpdAutoInc, mkDB2);
//  RegisterTest('Query;Cach updates. Identity;MS Access', TestCachedUpdAutoInc, mkMSAccess);
//  RegisterTest('Query;Cach updates. Identity;MSSQL',     TestCachedUpdAutoInc, mkMSSQL);
//  RegisterTest('Query;Cach updates. Identity;ASA',       TestCachedUpdAutoInc, mkASA);
//  RegisterTest('Query;Cach updates. Identity;MySQL',     TestCachedUpdAutoInc, mkMySQL);
//  RegisterTest('Query;Cach updates. Identity;Oracle',    TestCachedUpdAutoInc, mkOracle);
  RegisterTest('Query;No values;DB2',            TestInsertNoValues, mkDB2);
  RegisterTest('Query;No values;MS Access',      TestInsertNoValues, mkMSAccess);
  RegisterTest('Query;No values;MSSQL',          TestInsertNoValues, mkMSSQL);
  RegisterTest('Query;No values;ASA',            TestInsertNoValues, mkASA);
  RegisterTest('Query;No values;MySQL',          TestInsertNoValues, mkMySQL);
  RegisterTest('Query;No values;Oracle',         TestInsertNoValues, mkOracle);
  RegisterTest('Query;Locking;Optimistic;DB2',   TestOptimLocking, mkDB2);
  RegisterTest('Query;Locking;Optimistic;MS Access',     TestOptimLocking, mkMSAccess);
  RegisterTest('Query;Locking;Optimistic;MSSQL',         TestOptimLocking, mkMSSQL);
  RegisterTest('Query;Locking;Optimistic;ASA',           TestOptimLocking, mkASA);
  RegisterTest('Query;Locking;Optimistic;MySQL',         TestOptimLocking, mkMySQL);
  RegisterTest('Query;Locking;Optimistic;Oracle',        TestOptimLocking, mkOracle);
  RegisterTest('Query;Locking;Pessimistic;DB2',       TestPessLocking, mkDB2);
  RegisterTest('Query;Locking;Pessimistic;MS Access', TestPessLocking, mkMSAccess);
  RegisterTest('Query;Locking;Pessimistic;MSSQL',     TestPessLocking, mkMSSQL);
  RegisterTest('Query;Locking;Pessimistic;ASA',       TestPessLocking, mkASA);
  RegisterTest('Query;Locking;Pessimistic;MySQL',     TestPessLocking, mkMySQL);
  RegisterTest('Query;Locking;Pessimistic;Oracle',    TestPessLocking, mkOracle);
  RegisterTest('Query;In transaction;DB2',       TestInTrans, mkDB2);
  RegisterTest('Query;In transaction;MS Access', TestInTrans, mkMSAccess);
  RegisterTest('Query;In transaction;MSSQL',     TestInTrans, mkMSSQL);
  RegisterTest('Query;In transaction;ASA',       TestInTrans, mkASA);
  RegisterTest('Query;In transaction;MySQL',     TestInTrans, mkMySQL);
  RegisterTest('Query;In transaction;Oracle',    TestInTrans, mkOracle);
  RegisterTest('Query;Kill Connection;Oracle',   TestKillConnection, mkOracle);
{$IFDEF AnyDAC_D6}
  RegisterTest('Query;TimeStamp;MySQL',          TestMySQLTimestamp, mkMySQL);
{$ENDIF}
  RegisterTest('Query;Insert;MySQL',             TestInsert, mkMySQL);
  RegisterTest('Query;MasterDetail;MySQL',       TestMasterDetail, mkMySQL);
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestKillConnection;
var
  oConn: TADConnection;
  oQry: TADQuery;
begin
  oConn := TADConnection.Create(nil);
  oQry := TADQuery.Create(nil);
  oConn.ConnectionDefName := GetConnectionDef(FRDBMSKind);
  oConn.LoginPrompt := False;
  oConn.Open;
  oQry.Connection := oConn;
  oQry.SQL.Text := 'select * from {id ADQA_NoExists}';
  try
    try
      oQry.Open;
    except
    end;
  finally
    oQry.Free;
    oConn.Free;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
procedure TADQACompQRYTsHolder.TestMySQLTimestamp;
var
  i: Integer;
  S1, S2: Variant;
begin
  with FQuery do begin
    SQL.Text := 'delete from {id ADQA_timestamp}';
    ExecSQL;

    CachedUpdates := True;
    UpdateOptions.RequestLive := True;
    SQL.Text := 'select * from {id ADQA_timestamp}';
    Open;

    if Fields[1].Required then
      Error(WrongTimestampAttr);

    Append;
    Fields[1].Value := Null;
    Post;
    Append;
    Fields[1].AsSQLTimeStamp := TimeStamps[0];
    Post;

    i := ApplyUpdates;
    if i <> 0 then begin
      Error(ErrorOnUpdate(i, 0));
      Exit;
    end;
    CommitUpdates;
    Refresh;

    FTab.Reset;
    with FCommIntf do begin
      Prepare('select distinct curdate() from {id Categories}');
      Define(FTab);
      Open;
      Fetch(FTab);
    end;

    First;
    if Trunc(SQLTimeStampToDateTime(Fields[1].AsSQLTimeStamp)) <>
       VarAsType(FTab.Rows[0].GetData(0), varDate) then
      Error(WrongValueInColumn(Fields[0].FullName, '',
            DateToStr(Trunc(SQLTimeStampToDateTime(Fields[1].AsSQLTimeStamp))),
            VarToStr(FTab.Rows[0].GetData(0))) + '. Inserted null value');

    Next;
    S1 := SQLTimeStampToStr('', Fields[1].AsSQLTimeStamp);
    S2 := SQLTimeStampToStr('', TimeStamps[0]);
    if SQLTimeStampToDateTime(Fields[1].AsSQLTimeStamp) <>
       SQLTimeStampToDateTime(TimeStamps[0]) then
      Error(WrongValueInColumn(Fields[1].FullName, '',
            S1, S2) + '. Inserted non null value');
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestAsyncCmdExec;
var
  lExc: Boolean;

  procedure PrepareTest(AArrSize: LongWord = 0);
  var
    i: Integer;
    iArrSize: LongWord;
  begin
    with FQuery do begin
      ResourceOptions.AsyncCmdMode := amBlocking;
      SQL.Text := 'delete from {id ADQA_ForAsync}';
      try
        ExecSQL;
      except
        on E: Exception do
          Error(E.Message);
      end;

      iArrSize := AArrSize;
      if AArrSize = 0 then
        case FRDBMSKind of
        mkMSAccess: iArrSize := 500;
        mkMSSQL:    iArrSize := 1000;
        mkOracle:   iArrSize := 800;
        mkDB2:      iArrSize := 1000;
        mkASA:      iArrSize := 500;
        end;

      SQL.Text := 'insert into {id ADQA_ForAsync}(id, name) values(:id, :name)';
      Params[0].DataType := ftInteger;
      Params[1].DataType := ftString;
      Params.ArraySize   := iArrSize;

      for i := 0 to iArrSize - 1 do begin
        Params[0].AsIntegers[i] := 0;
        Params[1].AsStrings[i]  := 'str' + IntToStr(i);
      end;
      try
        Execute(iArrSize, 0);
      except
        on E: Exception do
          Error(E.Message);
      end;
    end;
  end;

begin
  // Async mode = amCancelDialog
  PrepareTest;
  try
    with FQuery do begin
      ResourceOptions.AsyncCmdMode := amCancelDialog;
      SQL.Text := 'SELECT Count(*) ' +
                  'FROM {id ADQA_ForAsync} a, {id ADQA_ForAsync} b ' +
                  'GROUP BY a.name, b.name';
      try
        Open;
      except
        on E: Exception do begin
          if not(E is EAbort) then
            Error(E.Message);
        end;
      end;
    end;
    if MessageDlg(DidYouSee('Cancel Dialog'), mtInformation,
                  [mbYes, mbNo], 0) <> Ord(mrYes) then
      Error(CancelDialogFails);

    // Abort
    PrepareTest;
    with FQuery do begin
      ResourceOptions.AsyncCmdMode := amAsync;
      SQL.Text := 'update {id ADQA_ForAsync} set name = ''changed'' where id = 0';
      try
        ExecSQL;
        AbortJob;
      except
        on E: Exception do begin
          if not(E is EAbort) then
            Error(ErrorOnAbortFunction(E.Message));
        end;
      end;
    end;

    // Async mode = amAsync
    PrepareTest(10000);
    with FQuery do begin
      ResourceOptions.AsyncCmdMode := amAsync;
      SQL.Text := 'update {id ADQA_ForAsync} set name = ''changed''';
      try
        ExecSQL;
        try
          lExc := False;
          SQL.Text := 'select * from {id Shippers}';
        except
          lExc := True;
        end;
        if not lExc then
          Error(NoExcWithAsyncMode);
      except
        on E: Exception do
          Error(E.Message);
      end;
    end;
  finally
    while FQuery.Command.State in [csExecuting, csFetching] do
      Sleep(0);
    FQuery.ResourceOptions.AsyncCmdMode := amBlocking;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestAsyncCmdOpen;
var
  lExc:     Boolean;

  procedure PrepareTest;
  var
    i: Integer;
    iArrSize: LongWord;
  begin
    with FQuery do begin
      ResourceOptions.AsyncCmdMode := amBlocking;
      SQL.Text := 'delete from {id ADQA_ForAsync}';
      try
        ExecSQL;
      except
        on E: Exception do
          Error(E.Message);
      end;

      iArrSize := 0;
      case FRDBMSKind of
      mkMSAccess: iArrSize := 1000;
      mkMSSQL:    iArrSize := 1000;
      mkOracle:   iArrSize := 1000;
      mkDB2:      iArrSize := 1000;
      mkASA:      iArrSize := 500;
      end;

      SQL.Text := 'insert into {id ADQA_ForAsync}(id, name) values(:id, :name)';
      Params[0].DataType := ftInteger;
      Params[1].DataType := ftString;
      Params.ArraySize   := iArrSize;

      for i := 0 to iArrSize - 1 do begin
        Params[0].AsIntegers[i] := 0;
        Params[1].AsStrings[i]  := 'str' + IntToStr(i);
      end;
      try
        Execute(iArrSize, 0);
      except
        on E: Exception do
          Error(E.Message);
      end;
    end;
  end;

begin
  try
    // Async mode = amAsync
    PrepareTest;
    with FQuery do begin
      ResourceOptions.AsyncCmdMode := amAsync;
      SQL.Text := 'SELECT Count(*) ' +
                  'FROM {id ADQA_ForAsync} a, {id ADQA_ForAsync} b ' +
                  'GROUP BY a.name, b.name';
      try
        Trace('Command State is ' + CommandState[FQuery.Command.State]);
        Trace('>> Open');
        Open;
        Trace('Command State is ' + CommandState[FQuery.Command.State]);
        Trace('<< Open');
        try
          lExc := False;
          Trace('SQL.Text := ''select * from {id Shippers}''');
          SQL.Text := 'select * from {id Shippers}';
          Trace('Command State is ' + CommandState[FQuery.Command.State]);
          Trace('>> Open');
          Open;
          Trace('Command State is ' + CommandState[FQuery.Command.State]);
          Trace('<< Open');
        except
          Trace('lExc := True');
          lExc := True;
        end;
        if not lExc then
          Error(NoExcWithAsyncMode);
      except
        on E: Exception do
          Error(E.Message);
      end;
    end;
  finally
    while FQuery.Command.State in [csExecuting, csFetching] do
      Sleep(0);
    FQuery.ResourceOptions.AsyncCmdMode := amBlocking;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestBatchExec;
var
  i, j, k: Integer;
  V:       Variant;
{$IFNDEF AnyDAC_D6}
  l:       Integer;
{$ENDIF}
begin
  GetParamsArray;
  with FQuery, FVarFieldList do begin
    SQL.Text := 'delete from {id ADQA_All_types}';
    ExecSQL;

    SQL.Text := GetInsertString;
    k := -1;
    for i := 0 to FVarFieldList.Count - 1 do
      if not IsOfUnknownType(i) then begin
        Inc(k);
        Params[k].DataType := Types[i];
        Params[k].Size     := Sizes[i];
      end;

    Params.ArraySize := 100;

    FConnection.StartTransaction;
    try
      for i := 0 to 100 - 1 do begin
        k := -1;
        for j := 0 to FVarFieldList.Count - 1 do
          if not IsOfUnknownType(j) then begin
            Inc(k);
            V := VarValues[j];
            case Types[j] of
            ftString:     Params[k].AsStrings[i]       := V;
            ftSmallint:   Params[k].AsSmallInts[i]     := V;
            ftInteger:    Params[k].AsIntegers[i]      := V;
            ftBCD:        Params[k].AsBCDs[i]          := V;
{$IFDEF AnyDAC_D6}
            ftFMTBcd:     Params[k].AsFMTBCDs[i]       := VarToBcd(V);
            ftTimeStamp:  Params[k].AsSQLTimeStamps[i] := VarToSQLTimeStamp(V);
{$ENDIF}
            ftDate:       Params[k].AsDates[i]         := V;
            ftTime:       Params[k].AsTimes[i]         := V;
            ftDateTime:   Params[k].AsDateTimes[i]     := V;
            ftMemo:       Params[k].AsMemos[i]         := V;
            ftBoolean:    Params[k].AsBooleans[i]      := V;
            ftCurrency:   Params[k].AsCurrencys[i]     := V;
            ftBlob:       Params[k].AsBlobs[i]         := V;
            ftFloat:      Params[k].AsFloats[i]        := V;
            ftBytes:      Params[k].AsBytes[i]         := V;
            ftVarBytes:   Params[k].AsVarBytes[i]      := V;
            ftFixedChar:  Params[k].AsStrings[i]       := V;
{$IFDEF AnyDAC_D6}
            ftLargeint:   Params[k].AsLargeInts[i]     := V;
{$ELSE}
            ftLargeint:
              if TVarData(V).VType = varInt64 then
                Params[k].AsLargeInts[i] := Decimal(V).Lo64
              else begin
                l := V;
                Params[k].AsLargeInts[i] := l;
              end;
{$ENDIF}
            ftWideString: Params[k].AsWideStrings[i]   := V;
            ftOraBlob:    Params[k].AsBlobs[i]         := V;
            ftOraClob:    Params[k].AsMemos[i]         := V;
            ftGuid:       Params[k].AsStrings[i]       := V;
            ftFmtMemo:    Params[k].AsWideMemos[i]     := V;
            else
              ASSERT(False);
            end;
          end;
      end;
      Execute(100, 0);
      if RowsAffected <> 100 then begin
        Error(WrongBatchInsertCount);
        Exit;
      end;
      FConnection.Commit;
    except
      on E: Exception do begin
        FConnection.Rollback;
        Error(ErrorBatchExec(E.Message));
        Exit;
      end;
    end;
    if FConnection.InTransaction then
      Error(TransIsActive);

    SQL.Text := 'select * from {id ADQA_All_types}';
    Open;
    FetchAll;

    if RecordCount <> 100 then begin
      Error(WrongBatchInsertCount);
      Exit;
    end;
    First;
    i := 0;
    while not Eof do begin
      for j := 0 to Fields.Count - 1 do
        if not IsOfUnknownType(j) then begin
          V := Fields[j].Value;
          if Compare(V, VarValues[j], Types[j]) <> 0 then begin
            if i > 0 then
              Exit;
            Error(WrongBatchInserting(Fields[j].FullName, VarToStr(V),
                  VarToStr(VarValues[j])));
          end;
        end;
      Inc(i);
      Next;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestBatchExecAffect;
var
  i: Integer;
  V: Variant;

  procedure DoError(AMess: String);
  begin
    Error(AMess);
    FConnection.Rollback;
    if FConnection.InTransaction then
      Error(TransIsActive);
  end;

begin
  with FQuery do begin
    SQL.Text := 'delete from {id ADQA_TabWithPK}';
    ExecSQL;

    SQL.Text := 'insert into {id ADQA_TabWithPK}(f1) values(:f1)';
    Params[0].DataType := ftInteger;

    Params.ArraySize := 100;
    Prepare;

    FConnection.StartTransaction;
    try
      for i := 0 to 100 - 1 do
        if i = 50 then
          Params[0].AsIntegers[i] := 50 - 1
        else
          Params[0].AsIntegers[i] := i;
      Execute(100, 0);
      FConnection.Commit;
      if FConnIntf.TxIsActive then
        Error(TransIsActive);
    except
      on E: Exception do begin
        if (FConnection.RDBMSKind = mkMSSQL) and (RowsAffected <> 99) and
          (EADDBEngineException(E).Errors[0].RowIndex <> 50) then begin
          DoError(ErrorBatchAffect(FCommIntf.RowsAffected, 99));
          Exit;
        end
        else if (FConnection.RDBMSKind <> mkMSSQL) and (RowsAffected <> 50) then begin
          DoError(ErrorBatchAffect(FCommIntf.RowsAffected, 50));
          Exit;
        end
        else begin
          try
            if (FConnection.RDBMSKind <> mkMSSQL) then begin
              Params[0].AsIntegers[RowsAffected] := 50;
              Execute(100, RowsAffected);
            end
            else begin
              Disconnect;
              SQL.Text := 'insert into {id ADQA_TabWithPK}(f1) values(:f1)';
              Params.ArraySize := 1;
              Params[0].AsInteger := 50;
              ExecSQL;
            end
          except
            on E: Exception do begin
              Error(E.Message);
              FConnection.Rollback;
              if FConnection.InTransaction then
                Error(TransIsActive);
              Exit;
            end;
          end;
        end;
      end;
    end;

    SQL.Text := 'select * from {id ADQA_TabWithPK}';
    Open;
    FetchAll;

    if RecordCount <> 100 then begin
      Error(WrongBatchInsertCount);
      Exit;
    end;
    First;
    i := 0;
    while not Eof do begin
      V := FQuery.Fields[0].Value;
      if Compare(V, i, ftInteger) <> 0 then begin
        if i > 0 then
          Exit;
        Error(WrongBatchInserting('', VarToStr(V), VarToStr(i)));
      end;
      Inc(i);
      Next;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
(*
procedure TADQACompQRYTsHolder.TestCachedUpdAutoInc;
var
  oMastQry, oDetQry: TADQuery;
  oDataSource: TDataSource;
  i, j, k,
  iLastMastId,
  iLastDetId: Integer;

  procedure PrepareTest;
  begin
    oMastQry := TADQuery.Create(nil);
    with oMastQry do begin
      Connection := FConnection;
      oMastQry.CachedUpdates := True;
    end;
    oDataSource := TDataSource.Create(nil);
    oDataSource.DataSet := oMastQry;
    oDetQry  := TADQuery.Create(nil);
    with oDetQry do begin
      Connection := FConnection;
      CachedUpdates := True;
      MasterSource := oDataSource;
      IndexFieldNames := 'fk_id1';
    end;

    FillTables;
    oMastQry.SQL.Text := 'select * from {id ADQA_master_autoinc} order by id1';
    oMastQry.Open;
    oMastQry.SetFieldAutoGenerateValue(oMastQry.Fields[0], arAutoInc);
    oMastQry.Fields[0].ReadOnly := False;

    oMastQry.Last;
    iLastMastId := oMastQry.FieldByName('id1').Value;
    with FQuery do begin
      SQL.Text := 'select * from {id ADQA_details_autoinc} order by id2';
      Open;

      oDetQry.SQL.Text := 'select * from {id ADQA_details_autoinc} where ' +
                          'fk_id1 = :id1 order by id2';
      oDetQry.Open;
      oDetQry.SetFieldAutoGenerateValue(oDetQry.Fields[0], arAutoInc);
      oDetQry.Fields[0].ReadOnly := False;

      oMastQry.FieldByName('id1').Required := False;
      oDetQry.FieldByName('id2').Required := False;
      oDetQry.FieldByName('fk_id1').Required := False;

      Last;
      iLastDetId := FieldByName('id2').Value;
    end;
  end;

  procedure CheckFilling;
  var
    i, j:   Integer;
    V1, V2: Variant;
  begin
    oMastQry.First;
    i := 0;
    while i < 10 do begin
      oMastQry.Next;
      Inc(i);
    end;
    i := 0;
    while not oMastQry.Eof do begin
      V1 := oMastQry.FieldByName('id1').Value;
      V2 := iLastMastId + i + 1;
      if Compare(V1, V2) <> 0 then
        Error('Master: ' + WrongValueInTable('id1', i, VarToStr(V1),
              VarToStr(V2)));

      oDetQry.First;
      j := 0;
      while not oDetQry.Eof do begin
        V1 := oDetQry.FieldByName('id2').Value;
        V2 := iLastDetId + (i * 3) + j + 1;
        if Compare(V1, V2) <> 0 then
          Error('Details: ' + WrongValueInTable('id2', j, VarToStr(V1),
                VarToStr(V2)));

        V1 := oDetQry.FieldByName('fk_id1').Value;
        V2 := iLastMastId + i + 1;
        if Compare(V1, V2) <> 0 then
          Error('Details: ' + WrongValueInTable('id2', j, VarToStr(V1),
                VarToStr(V2)));
        Inc(j);
        oDetQry.Next;
      end;
      Inc(i);
      oMastQry.Next;
    end;
  end;

begin
  PrepareTest;
  try
    k := -1;
    for i := 0 to 5 do begin
      oMastQry.AppendRecord([-(i + 1), 'third' + IntToStr(i)]);
      for j := 0 to 2 do begin
        oDetQry.AppendRecord([k, oMastQry.FieldByName('id1').Value, 'third' +
                              IntToStr(j)]);
        Inc(k);
      end;
    end;

    i := oMastQry.ApplyUpdates;
    oMastQry.CommitUpdates;
    if i <> 0 then begin
      Error(ErrorOnUpdate(i, 0) + '. [Master Query]');
      Exit;
    end;

    i := oDetQry.ApplyUpdates;
    oDetQry.CommitUpdates;
    if i <> 0 then begin
      Error(ErrorOnUpdate(i, 0) + '. [Details Query]');
      Exit;
    end;
    CheckFilling;

    // check then identity fields when we update another fields
    oMastQry.First;
    while not oMastQry.Eof do
      with oMastQry do begin
        Edit;
        FieldByName('name1').AsString := 'fourth_mast' + IntToStr(i);
        Post;
        Next;
      end;

    oDetQry.First;
    while not oDetQry.Eof do
      with oDetQry do begin
        Edit;
        FieldByName('name2').AsString := 'fourth_det' + IntToStr(i);
        Post;
        Next;
      end;

    i := oMastQry.ApplyUpdates;
    oMastQry.CommitUpdates;
    if i <> 0 then begin
      Error(ErrorOnUpdate(i, 0));
      Exit;
    end;

    i := oDetQry.ApplyUpdates;
    oDetQry.CommitUpdates;
    if i <> 0 then begin
      Error(ErrorOnUpdate(i, 0));
      Exit;
    end;
    CheckFilling;
  finally
    oMastQry.Free;
    oMastQry := nil;
    oDetQry.Free;
    oDetQry := nil;
  end;
end;
*)

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestCurrencyBcdFmtBcd;
var
  sComm: String;
  rCurrency: Currency;
  rBcd: Currency;
  rFmtBCD: TBcd;
  rDelta: Double;
begin
  sComm := 'insert into {id ADQA_Bcd}(ftCurrency, ftBCD, ftFmtBCD) ' +
           'values(:ftCurrency, :ftBCD, :ftFmtBCD)';
  with FQuery do begin
    SQL.Text := 'delete from {id ADQA_Bcd}';
    ExecSQL;

    try
      SQL.Text := sComm;
    except
      on E: Exception do begin
        Error(E.Message);
        Exit;
      end;
    end;

    rCurrency := StrToCurrency_Cast('445315487961234.5999');
    rBcd      := StrToCurrency_Cast('455315487961234.9119');
    rFmtBCD   := StrToBcd_Cast('989455315487961234.9119');

    Params[0].AsCurrency := rCurrency;
    Params[1].AsBCD      := rBcd;
    Params[2].AsFMTBCD   := rFmtBCD;

    try
      ExecSQL;
    except
      on E: Exception do begin
        Error(E.Message);
        Exit;
      end;
    end;

    SQL.Text := 'select * from {id ADQA_Bcd}';
    Open;

    rDelta := Abs(rCurrency - Fields.FieldByName('ftCurrency').AsCurrency);
    Trace(GetConnectionDef(FRDBMSKind));
    Trace('Test  Currency = ' + VarToStr(rCurrency));
    Trace('RDBMS Currency = ' + Fields.FieldByName('ftCurrency').AsString);
    Trace('Delta = ' + FloatToStr(rDelta));
    if rDelta > 0.11 then
      Error(WrongValueInColumn('ftCurrency', '',
            Fields.FieldByName('ftCurrency').AsString, VarToStr(rCurrency)));

    rDelta := Abs(rBcd - Fields.FieldByName('ftBCD').AsCurrency);
    Trace(GetConnectionDef(FRDBMSKind));
    Trace('Test  BCD = ' + VarToStr(rBcd));
    Trace('RDBMS BCD = ' + Fields.FieldByName('ftBCD').AsString);
    Trace('Delta = ' + FloatToStr(rDelta));
    if rDelta > 0.11 then
      Error(WrongValueInColumn('ftBCD', '',
            Fields.FieldByName('ftBCD').AsString, VarToStr(rBcd)));

{$IFDEF AnyDAC_D6}
    if BcdCompare(rFmtBCD, Fields.FieldByName('ftFmtBCD').AsBCD) <> 0 then
      Error(WrongValueInColumn('ftFmtBCD', '',
            Fields.FieldByName('ftFmtBCD').AsString, BcdToStr(rFmtBCD)));
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestInsertNoValues;
var
  i: Integer;
  V: Variant;

  function PrepareTest: Boolean;
  begin
    Result := True;
    with FQuery do begin
      CachedUpdates := True;
      SQL.Text := 'delete from {id ADQA_NoValsTable}';
      ExecSQL;

      SQL.Text := 'select * from {id ADQA_NoValsTable} order by id';
      Open;
    end;
  end;

begin
  if not PrepareTest then
    Exit;
  for i := 0 to 4 do
    FQuery.InsertRecord([]);
  try
    i := FQuery.ApplyUpdates;
    FQuery.CommitUpdates;
    FQuery.Refresh;

    if i <> 0 then
      Error(ErrorOnUpdate(i, 0));
  except
    on E: Exception do
      Error(E.Message);
  end;
  if not CheckRowsCount(nil, 5, FQuery.RecordCount) then
    Exit;
  FQuery.First;
  i := 0;
  while not FQuery.Eof do begin
    V := FQuery.Fields[0].Value;
    if V = Null then
      V := 0;
    if (V <> 2000) then begin
      Error(WrongValueInTable('0', i, V, '2000'));
      Exit;
    end;
    V := FQuery.Fields[1].Value;
    if V = Null then
      V := 0;
    if AnsiCompareText(V, 'hello') <> 0 then begin
      Error(WrongValueInTable('1', i, V, 'hello'));
      Exit;
    end;
    Inc(i);
    FQuery.Next;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestInTrans;
var
  i: Integer;

  procedure PrepareTest;
  var
    i: Integer;
  begin
    PrepareTestLocking;
    with FQuery do begin
      CachedUpdates := True;
      SQL.Text := 'select * from {id ADQA_LockTable} order by id';
      Open;
      i := 0;
      while i < NUM_WHERE do begin
        Next;
        Inc(i);
      end;
      Edit;
      Fields[0].AsInteger := 1000;
      Fields[1].AsString := 'cnanged';
      Post;
    end;
  end;

begin
  PrepareTest;
  // 1.
  with FConnection do begin
    StartTransaction;
    try
      i := FQuery.ApplyUpdates;
      FQuery.CommitUpdates;
      if i <> 0 then
        Error(ErrorOnUpdate(i, 0));
      if not InTransaction then
        Error(TransIsInactive);
    finally
      Rollback;
    end;
  end;

  PrepareTest;
  // 2.
  i := FQuery.ApplyUpdates;
  FQuery.CommitUpdates;
  if i <> 0 then
    Error(ErrorOnUpdate(i, 0));
  if FConnection.InTransaction then
    Error(TransIsActive);
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestMapRules;
var
  i, j: Integer;
  v:    Variant;
  eTarget, eSource: TADDataType;
  eType:   TFieldType;
  sSource,
  sTarget: String;
  oQry: TADQuery;

  procedure SetMapRule(APrecMax, APrecMin, AScaleMax, AScaleMin: Integer;
                       ATargetDataType, ASourceDataType: TADDataType);
  begin
    with FQuery.FormatOptions.MapRules.Add do begin
      PrecMax  := APrecMax;
      PrecMin  := APrecMin;
      ScaleMax := AScaleMax;
      ScaleMin := AScaleMin;
      TargetDataType := ATargetDataType;
      SourceDataType := ASourceDataType;
    end;
  end;

  procedure DeleteFromNumbers;
  begin
    with FCommIntf do begin
      CommandText := 'delete from {id ADQA_Numbers}';
      Execute;
    end;
  end;

begin
  FConnIntf := FConnection.ConnectionIntf;
  FConnIntf.CreateCommand(FCommIntf);
  oQry := TADQuery.Create(nil);
  oQry.Connection := FConnection;
  try
    with FQuery do begin
      FormatOptions.OwnMapRules := True;
      oQry.SQL.Text := 'select * from {id ADQA_Numbers}';
      oQry.Open;

      for i := 0 to Fields.Count - 1 do begin
        if AnsiCompareText(Fields[i].FullName, 'dtBoolean') = 0 then
          continue;
        for eTarget := Low(TADDataType) to High(TADDataType) do
          with FormatOptions do begin
            MapRules.Clear;

            case eTarget of
            dtUnknown,
            dtDateTime..dtObject:
              continue;
            end;

            if (i = 0) and (eTarget = dtBoolean) and (FRDBMSKind in [mkOracle, mkDB2]) then
              for j := 0 to 1 do begin // check mapping FmtBCD (NUMBER(2,0)) to dtBoolean
                DeleteFromNumbers;

                SQL.Text := 'insert into {id ADQA_Numbers}(dtBoolean) ' +
                                 'values(' + IntToStr(j) + ')';
                ExecSQL;

                sSource := 'dtBCD';
                sTarget := 'dtBoolean';

                with FormatOptions.MapRules.Add do begin
                  PrecMax  := 2;
                  PrecMin  := 0;
                  ScaleMax := 0;
                  ScaleMin := 0;
                  TargetDataType := dtBoolean;
                  SourceDataType := dtBCD;
                end;

                SQL.Text := 'select dtBoolean from {id ADQA_Numbers}';
                try
                  Open;
                except
                  on E: Exception do begin
                    Error(ErrorOnMappingInsert(sSource, sTarget, E.Message));
                    continue;
                  end;
                end;

                try
                  if Compare(Boolean(j), Fields[0].AsBoolean) <> 0 then
                    Error(WrongMappingInsert(sSource, sTarget, VarToStr(Boolean(j)),
                          VarToStr(Fields[0].Value)));
                except
                  on E: Exception do begin
                    Error(ErrorOnCompareVal(Fields[0].FullName, E.Message));
                    break;
                  end;
                end;
                FormatOptions.MapRules.Clear;
              end;

            if eTarget = dtBoolean then
              continue;

            eSource := DataTypeByName[oQry.Fields[i].FullName];
            case eSource of  // source type
            dtByte, dtSByte:
              case eTarget of
              dtByte,
              dtSByte:
                continue;
              else
                begin
{$IFDEF AnyDAC_D6}
                  if eTarget = dtFmtBCD then
                    v := VarFMTBcdCreate(111.0)
                  else
{$ENDIF}
                    v := 111;
                  SetMapRule(3, 0, 0, 0, eTarget, eSource);
                end;
              end;
            dtInt16, dtUInt16:
              case eTarget of
              dtByte,
              dtSByte,
              dtInt16,
              dtUInt16:
                continue;
              else
                begin
{$IFDEF AnyDAC_D6}
                  if eTarget = dtFmtBCD then
                    v := VarFMTBcdCreate(6553.0)
                  else
{$ENDIF}
                    v := 6553;
                  SetMapRule(5, 4, 0, 0, eTarget, eSource);
                end;
              end;
            dtInt32, dtUInt32:
              case eTarget of
              dtByte,
              dtSByte,
              dtInt16,
              dtInt32,
              dtUInt16,
              dtUInt32:
                continue;
              else
                begin
{$IFDEF AnyDAC_D6}
                  if eTarget = dtFmtBCD then
                    v := VarFMTBcdCreate(2147489.0)
                  else
{$ENDIF}
                    v := 2147489;
                  SetMapRule(10, 6, 0, 0, eTarget, eSource);
                end;
              end;
            dtInt64, dtUInt64:
              case eTarget of
              dtByte,
              dtSByte,
              dtInt16,
              dtInt32,
              dtInt64,
              dtUInt16,
              dtUInt32,
              dtUInt64:
                continue;
              else
                begin
{$IFDEF AnyDAC_D6}
                  if eTarget = dtFmtBCD then
                    v := VarFMTBcdCreate(2147488.0)
                  else
                    v := Int64(2147488);
{$ELSE}
                  v := 2147488;
{$ENDIF}
                  SetMapRule(19, 6, 0, 0, eTarget, eSource);
                end;
              end;
            dtDouble:
              case eTarget of
              dtByte,
              dtSByte,
              dtInt16,
              dtInt32,
              dtUInt16,
              dtUInt32,
              dtDouble:
                continue;
              dtInt64,  dtUInt64:
                begin
{$IFDEF AnyDAC_D6}
                  if eTarget = dtFmtBCD then
                    v := VarFMTBcdCreate(3456789012.343445)
                  else
                    v := Int64(2348831218);
{$ELSE}
                  TVarData(v).VType := varInt64;
                  Decimal(v).Lo64 := 2348831218;
{$ENDIF}
                  SetMapRule(16, 13, 0, 0, eTarget, eSource);
                end;
              else
                begin
                  SetMapRule(16, 13, 6, 4, eTarget, eSource);
                  v := 3456789012.3434;
                end;
              end;
            dtCurrency:
              case eTarget of
              dtByte,
              dtSByte,
              dtInt16,
              dtInt32,
              dtUInt16,
              dtUInt32,
              dtCurrency:
                continue;
              dtInt64,  dtUInt64:
                begin
                  SetMapRule(20, 19, 4, 4, eTarget, eSource);
{$IFDEF AnyDAC_D6}
                  v := Int64(2348514218);
{$ELSE}
                  TVarData(v).VType := varInt64;
                  Decimal(v).Lo64 := 2348514218;
{$ENDIF}
                end;
              else
                begin
{$IFDEF AnyDAC_D6}
                  if eTarget = dtFmtBCD then
                    v := VarFMTBcdCreate(3456789012.3434)
                  else
{$ENDIF}
                    v := 3456789012.3434;
                  SetMapRule(20, 19, 4, 4, eTarget, eSource);
                end;
              end;
            dtBCD:
              case eTarget of
              dtByte,
              dtSByte,
              dtInt16,
              dtInt32,
              dtUInt16,
              dtUInt32,
              dtBCD:
                continue;
              dtInt64,  dtUInt64:
                begin
                  SetMapRule(20, 19, 4, 4, eTarget, eSource);
{$IFDEF AnyDAC_D6}
                  v := Int64(2348581218);
{$ELSE}
                  TVarData(v).VType := varInt64;
                  Decimal(v).Lo64 := 2348581218;
{$ENDIF}
                end;
              else
                begin
{$IFDEF AnyDAC_D6}
                  if eTarget = dtFmtBCD then
                    v := VarFMTBcdCreate(3456789012.3434)
                  else
{$ENDIF}
                    v := 3456789012.3434;
                  SetMapRule(20, 19, 4, 4, eTarget, eSource);
                end;
              end;
            dtFmtBCD:
              case eTarget of
              dtByte,
              dtSByte,
              dtInt16,
              dtInt32,
              dtUInt16,
              dtUInt32,
              dtFmtBCD:
                continue;
              dtInt64,
              dtUInt64:
                begin
                  SetMapRule(18, 0, 4, 4, eTarget, eSource);
{$IFDEF AnyDAC_D6}
                  v := Int64(2348514831218);
{$ELSE}
                  TVarData(v).VType := varInt64;
                  Decimal(v).Lo64 := 2348514831218;
{$ENDIF}
                end;
              else
                begin
                  SetMapRule(18, 0, 4, 4, eTarget, eSource);
                  v := 3456789012.3434;
                end;
              end;
            end;

            try
              DeleteFromNumbers;
            except
              on E: Exception do
                Error(E.Message);
            end;

            SQL.Text := Format(InsertIntoStmt, ['ADQA_Numbers',
                                    oQry.Fields[i].FullName, oQry.Fields[i].FullName]);
            Params[0].ADDataType := eTarget;
            Params[0].Value := v;

            eType   := Params[0].DataType;
            sTarget := ADDataTypesNames[eTarget];
            sSource := oQry.Fields[i].FullName;
            try
              ExecSQL;
            except
              on E: Exception do begin
                Error(ErrorOnMappingInsert(sSource, sTarget, E.Message));
                continue;
              end;
            end;

            SQL.Text := Format(SelectFieldStmt, [oQry.Fields[i].FullName,
                                    'ADQA_Numbers']);
            Open;

            if Compare(Fields[0].Value, v, eType) <> 0 then
              Error(WrongMappingInsert(sSource, sTarget, VarToStr(v),
                    VarToStr(Fields[0].Value)));
          end;
      end;
    end;
  finally
    oQry.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestMappingStrings;
var
  sTestString:     AnsiString;
  sTestWideString: WideString;
  sTabName, sFldName: String;
  i: Integer;
begin
  sTestString := '';
  for i := 1 to 300 do
    sTestString := sTestString + 'a';
  if FRDBMSKind in [mkOracle, mkDB2] then begin
    sTabName := 'ADQA_WString';
    sFldName := 'widestring';
  end
  else begin
    sTabName := 'ADQA_MaxLengthNVarchar';
    sFldName := 'widestr';
  end;

  with FQuery do begin
    SQL.Text := Format(DeleteFromStmt, [sTabName]);
    ExecSQL;

    FormatOptions.OwnMapRules := True;
    with FormatOptions.MapRules.Add do begin
      SizeMax := 4000;
      SizeMin := 0;
      SourceDataType := dtWideString;
      TargetDataType := dtAnsiString;
    end;

    SQL.Text := Format(InsertIntoStmt, [sTabName, sFldName, sFldName]);
    Params[0].AsString := sTestString;
    try
      ExecSQL;
    except
      on E: Exception do begin
        Error(ErrorOnMappingInsert('dtWideString', 'dtAnsiString', E.Message));
        Exit;
      end;
    end;

    SQL.Text := Format(SelectFieldStmt, [sFldName, sTabName]);
    Open;

    sTestWideString := FQuery.Fields[0].Value;
    if Compare(sTestString, sTestWideString, ftWideString) <> 0 then
      Error(WrongMappingInsert('dtWideString', 'dtAnsiString', sTestString, sTestWideString));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestOptimLocking;
var
  iErrCnt, i, j: Integer;
  oQry: TADQuery;

  procedure PrepareTest;
  begin
    oQry := TADQuery.Create(nil);

    PrepareTestLocking;
    oQry.Connection := FConnection;
    with oQry.UpdateOptions do begin
      LockMode   := lmOptimistic;
      UpdateMode := upWhereAll;
    end;
    oQry.CachedUpdates := True;
    oQry.SQL.Text := 'select * from {id ADQA_LockTable} order by id';
    oQry.Open;
  end;

  procedure ChangeBy(AQuery: TADQuery; const AArray: array of Variant);
  var
    i: Integer;
  begin
    with AQuery do begin
      First;
      i := 0;
      while i < NUM_WHERE do begin
        Next;
        Inc(i);
      end;
      Edit;
      Fields[0].AsInteger := AArray[0];
      Fields[1].AsString := AArray[1];
      Post;
    end;
  end;

begin
  PrepareTest;
  try
    // 1.
    ChangeBy(oQry, [1000, 'changed by oQry']);
    with FQuery do begin
      SQL.Text := 'update {id ADQA_LockTable} set id = 1100, ' +
                  'name = ''changed by FQuery'' where id = ' + IntToStr(NUM_WHERE);
      ExecSQL;

      iErrCnt := oQry.ApplyUpdates;
      oQry.CommitUpdates;
      if iErrCnt <> 1 then
        Error('#1. ' + CntErrOnUpdateIsWrong(iErrCnt, 1));

      SQL.Text := 'select * from {id ADQA_LockTable} order by id';
      Open;
      Last;
      i := Fields[0].Value;
      Prior;
      j := Fields[0].Value;
      if (i = 1000) and (j = 1000) then
        Error(ThereAreTwoUpdRows);
    end;
  finally
    oQry.Free;
  end;

  // 2.
  PrepareTest;
  try
    ChangeBy(oQry, [1000, 'changed by oQry']);
    with FQuery do begin
      SQL.Text := 'delete from {id ADQA_LockTable} where id = ' + IntToStr(NUM_WHERE);
      ExecSQL;

      iErrCnt := oQry.ApplyUpdates;
      oQry.CommitUpdates;
      if iErrCnt <> 1 then
        Error('#2. ' + CntErrOnUpdateIsWrong(iErrCnt, 1));

      SQL.Text := 'select * from {id ADQA_LockTable} order by id';
      Open;
      Last;
      with FTab do
        if Fields[0].Value = 1000 then
          Error(ThereIsUnexpRow);
    end;
  finally
    oQry.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestOpenQuery;
var
  i: Integer;
  V1, V2: Variant;
begin
  GetParamsArray;
  if Insert then begin
    FQuery.FetchOptions.Mode := fmAll;
    try
      if FRDBMSKind = mkMSAccess then
        Sleep(550);
      FQuery.SQL.Text := 'select * from {id ADQA_All_types}';
      try
        FQuery.Open;
        FQuery.Close;
        FQuery.Open;
      except
        on E: Exception do begin
          Error(ErrorOnQueryOpen(E.Message));
          Exit;
        end;
      end;

      if FQuery.Fields.Count <> FTab.Columns.Count then begin
        Error(WrongFieldsCountInQuery(FQuery.Fields.Count, FTab.Columns.Count));
        Exit;
      end;

      for i := 0 to FVarFieldList.Count - 1 do begin
        if FVarFieldList.IsOfUnknownType(i) then
          continue;

        V1 := FQuery.Fields[i].Value;
        V2 := FVarFieldList.VarValues[i];
        if Compare(V1, V2, FVarFieldList.Types[i]) <> 0 then
          Error(WrongValInQryField(FQuery.Fields[i].FullName, VarToStr(V1), VarToStr(V2)));
      end;
    finally
      FQuery.FetchOptions.Mode := fmOnDemand;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestOpenSameCol;
begin
  with FQuery do begin
    SQL.Text := 'select CategoryID, CategoryID as CID from {id Categories}';
    Open;
    if FieldCount <> 2 then begin
      Error(Format('Base field number is [%d], but expected [%d]',
        [FieldCount, 2]));
      Exit;
    end;
    if AnsiCompareText(Fields[0].FieldName, 'CategoryID') <> 0 then
      Error(Format('Field [0] name is [%s], but expected [%s]',
        [Fields[0].FieldName, 'CategoryID']));
    if AnsiCompareText(Fields[1].FieldName, 'CID') <> 0 then
      Error(Format('Field [1] name is [%s], but expected [%s]',
        [Fields[0].FieldName, 'CID']));
    if AnsiCompareText(Fields[0].Origin, 'CategoryID') <> 0 then
      Error(Format('Field [0] origin is [%s], but expected [%s]',
        [Fields[0].Origin, 'CategoryID']));
    if AnsiCompareText(Fields[1].Origin, 'CategoryID') <> 0 then
      Error(Format('Field [1] origin is [%s], but expected [%s]',
        [Fields[1].Origin, 'CategoryID']));

    if FRDBMSKind = mkMySQL then begin
      SQL.Text := 'select host, host h1 from mysql.db';
      Open;
      if FieldCount <> 2 then begin
        Error(Format('Base field number is [%d], but expected [%d]',
          [FieldCount, 2]));
        Exit;
      end;
      if AnsiCompareText(Fields[0].FieldName, 'host') <> 0 then
        Error(Format('Field [0] name is [%s], but expected [%s]',
          [Fields[0].FieldName, 'host']));
      if AnsiCompareText(Fields[1].FieldName, 'h1') <> 0 then
        Error(Format('Field [1] name is [%s], but expected [%s]',
          [Fields[0].FieldName, 'h1']));
      if AnsiCompareText(Fields[0].Origin, 'host') <> 0 then
        Error(Format('Field [0] origin is [%s], but expected [%s]',
          [Fields[0].Origin, 'host']));
      if AnsiCompareText(Fields[1].Origin, 'host') <> 0 then
        Error(Format('Field [1] origin is [%s], but expected [%s]',
          [Fields[1].Origin, 'host']));
    end;

    SQL.Text := 'select count(*), count(*) from {id Categories}';
    Open;
    if FieldCount <> 2 then begin
      Error(Format('Expression field number is [%d], but expected [%d]',
        [FieldCount, 2]));
      Exit;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestPessLocking;
var
  oThread:  TADQATsThreadWithQuery;
  iVal:     Integer;

  procedure Freezer;
  begin
    FConnection.StartTransaction;
    try
      try
        with FQuery do begin
          SQL.Text := 'update {id ADQA_LockTable} set name = ''changed by Freezer''' +
                      ' where id = ' + IntToStr(NUM_WHERE);
          try
            try
              ExecSQL;
            except
              on E: Exception do
                Error(E.Message);
            end;
          finally
            Disconnect;
          end;
        end;
        oThread.Resume;
        Sleep(3000);
      finally
        FConnection.Rollback;
      end;
    except
    end;
  end;

  procedure Wait;
  begin
    oThread.WaitFor;
  end;

begin
  // test - with UpdateOptions.LockWait := False
  PrepareTestLocking;
  oThread := TADQATsThreadWithQuery.Create(FRDBMSKind, False, NUM_WHERE);
  try
    Freezer;
    // waiting
    Wait;
    with oThread do
      if (Tick2 - Tick1) > 2900 then
        Error(UpdateExecTimeBig(Tick2 - Tick1, 2900));

    with FQuery do begin
      SQL.Text := 'select * from {id ADQA_LockTable} order by id';
      Open;
      Last;
      iVal := Fields[0].AsInteger;
      Disconnect;
      if iVal = 1000 then
        Error(UpdateDuringTrans);
    end;
  finally
    oThread.Free;
    oThread := nil;
  end;

  if not (FRDBMSKind in [mkMSAccess, mkASA]) then begin
    // other test - with UpdateOptions.LockWait := True
    PrepareTestLocking;
    oThread := TADQATsThreadWithQuery.Create(FRDBMSKind, True, NUM_WHERE);
    try
      Freezer;
      // waiting
      Wait;
      with oThread do
        if (Tick2 - Tick1) < 2900 then
          Error(UpdateExecTimeSmall(Tick2 - Tick1, 2900));

      with FQuery do begin
        SQL.Text := 'select * from {id ADQA_LockTable} order by id';
        Open;
        Last;
        iVal := Fields[0].AsInteger;
        Disconnect;
        if iVal <> 1000 then
          Error(DontUpdateAfterTrans);
      end;
    finally
      oThread.Free;
      oThread := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.PrepareTestLocking;
var
  i: Integer;
begin
  with FQuery do begin
    SQL.Text := 'delete from {id ADQA_LockTable}';
    ExecSQL;
    for i := 0 to 9 do begin
      SQL.Text := 'insert into {id ADQA_LockTable}(id, name) values(' + IntToStr(i) +
                  ', ''not changed' + IntToStr(i) + ''')';
      ExecSQL;
    end;
    Disconnect;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestQueryDisconnectable;
var
  oQry:   array [0..3] of TADQuery;
  i, j, k: Integer;
begin
  TADTopResourceOptions(FConnection.ResourceOptions).MaxCursors := 2;
  for i := 0 to 3 do begin
    oQry[i] := TADQuery.Create(nil);
    oQry[i].Connection := FConnection;
    oQry[i].ResourceOptions.Disconnectable := True;
    with oQry[i].FetchOptions do begin
      Mode := fmOnDemand;
      RowsetSize := 10;
    end;
  end;
  try
    for i := 0 to 3 do begin
      FConnection.StartTransaction;
      if not FConnection.InTransaction then
        Error(TransIsInactive);
      try
        with oQry[i] do begin
          SQL.Text := 'select * from {id Order Details}';
          Open;
          try
            if i > 1 then
              GetNextPacket;
          except
            on E: Exception do begin
              Error(E.Message);
              Exit;
            end;
          end;
        end;
        FConnection.Commit;
        if FConnection.InTransaction then
          Error(TransIsActive);
      except
        FConnection.Rollback;
        if FConnection.InTransaction then
          Error(TransIsActive);
        for j := 0 to 1 do
          if oQry[j].State <> dsInactive then
            Error(DSStateIsNotWaited('dsInactive') + '. #' + IntToStr(j));
        k := 0;
        for j := 0 to i - 1 do
          if oQry[j].State = dsInactive then
            Inc(k);
        if Abs(k - ((i - 1) * 80) div 100) > 1 then
          Error(WrongCountInactQry(k, ((i - 1) * 80) div 100));
        Exit;
      end;
    end;
  finally
    for i := 0 to 3 do begin
      oQry[i].Free;
      oQry[i] := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.RunCompMacros(const ACommText: String;
  ADataType: TADMacroDataType; AIndx: Integer);
begin
  with FQuery do begin
    if ACommText = '' then
      Exit;
    SQL.Text := ACommText;
    if Macros.Count = 0 then begin
      Error(MacroCountIsZero(MacroTypes[ADataType]));
      Exit;
    end;
    with Macros.Items[0] do begin
      DataType := mdUnknown;
      if AIndx = -1 then
        Value := 'ADQA_All_types'
      else
        try
          Value := FVarFieldList.VarValues[AIndx];
        except
          on E: Exception do
            Error(E.Message);
        end;
      Name := 'MAC';
      DataType := ADataType;
    end;
    try
      Open;
    except
      on E: Exception do begin
        Error(ErrorTableDefine(GetConnectionDef(FRDBMSKind), MacroTypes[ADataType] + ' type. ' + E.Message));
        Exit;
      end
    end;
    if RecordCount <> 1 then begin
      Error(WrongRowCount(1, RecordCount) + '; the tested macro type is ' +
            MacroTypes[ADataType]);
      Exit;
    end;
    if Compare(Fields[0].Value, 1) <> 0 then
      Error(MacroFails(GetConnectionDef(FRDBMSKind), MacroTypes[ADataType]));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestStringsBorderLength;
var
  i, j, iField, iFieldNum: Integer;
  s, sTabName: String;
  w: WideString;
  V1: Variant;

  function GetInsString(AField: Integer): String;
  var
    sFld: String;
  begin
    case AField of
    0: sFld := 'str';
    1: sFld := 'memos';
    2: sFld := 'widestr';
    3: sFld := 'blobs';
    end;
    Result := Format('insert into {id %s}(%s) values(:S)', [sTabName, sFld]);
  end;

  procedure RefetchData;
  begin
    with FQuery do begin
      SQL.Text := Format(SelectFromStmt, [sTabName]);
      Open;
    end;
  end;

  procedure Delete;
  begin
    with FQuery do begin
      SQL.Text := Format(DeleteFromStmt, [sTabName]);
      ExecSQL;
    end;
  end;

begin
  for iField := 0 to 3 do
    for i := Low(BorderLength[FRDBMSKind]) to High(BorderLength[FRDBMSKind]) do begin
      s := '';
      w := '';

      if (iField in [0, 2]) and (i > 1) then
        continue;

      case FRDBMSKind of
      mkMSAccess:
        if iField = 2 then
          if BorderLength[FRDBMSKind, i] > 255 then continue;
      mkMSSQL:
        case iField of
        1: if BorderLength[FRDBMSKind, i] > 8000 then continue;
        2: if BorderLength[FRDBMSKind, i] > 4000 then continue;
        end;
      mkOracle:
        case iField of
        1: if BorderLength[FRDBMSKind, i] > 4001 then continue;
        2: if BorderLength[FRDBMSKind, i] > 2000 then continue;
        end;
      end;

      if FRDBMSKind <> mkMSSQL then begin
        sTabName  := 'ADQA_MaxLength';
        iFieldNum := iField;
      end
      else begin
        iFieldNum := 0;
        case iField of
        0: sTabName := 'ADQA_MaxLength';
        1: sTabName := 'ADQA_MaxLengthVarchar';
        2: sTabName := 'ADQA_MaxLengthNVarchar';
        3:
          begin
            sTabName  := 'ADQA_MaxLength';
            iFieldNum := 1;
          end;
        end;
      end;

      if BorderLength[FRDBMSKind, i] = 0 then
        continue;

      for j := 1 to BorderLength[FRDBMSKind, i] do
        if iField = 2 then
          w := w + 'w'
        else
          s := s + 's';

      Delete;
      with FQuery do begin
        SQL.Text := GetInsString(iField);
        case iField of
        0: Params[0].AsString     := s;
        1: Params[0].AsMemo       := s;
        2: Params[0].AsWideString := w;
        3: Params[0].AsBlob       := s;
        end;
        try
          ExecSQL;
        except
          on E: Exception do begin
            Error(ErrBorderLength(BorderLength[FRDBMSKind, i],
                                  FTab.Columns[iFieldNum].Name, E.Message));
            break;
          end;
        end;
      end;
      RefetchData;
      V1 := FQuery.Fields[iFieldNum].Value;
      if V1 = Null then
        V1 := '';
      if iField = 2 then begin
{$IFDEF AnyDAC_D6}
        if WideCompareStr(V1, w) <> 0 then
{$ELSE}
        if Compare(V1, w) <> 0 then
{$ENDIF}
          Error(WrongWithBorderLength(FTab.Columns[iFieldNum].Name,
                                      BorderLength[FRDBMSKind, i], V1, w));
        continue;
      end;
      if Compare(V1, s) <> 0 then
          Error(WrongWithBorderLength(FQuery.Fields[iFieldNum].FullName,
                                      BorderLength[FRDBMSKind, i], V1, s));
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestMacroDB2;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Dates[0],    ftDate, 5);
      SetField(Floats[0],   ftFloat, 7);
      SetField(Integers[0], ftInteger, 9);
      SetField(Strings[0],  ftString, 16);
      SetField(Times[0],    ftTime, 14);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(TimeStamps[2]),
                            ftTimeStamp, 15);
{$ELSE}
      SetField(ADSQLTimeStampToDateTime(TimeStamps[2]),
                            ftDateTime, 15);
{$ENDIF}
    end;
  end;

  function GetMacrosString(ADataType: TADMacroDataType; var AIndx: Integer): String;
  var
    s: String;
  begin
    s := 'select 1 from {id ADQA_All_types} where ';
    AIndx := -10;
    case ADataType of
    mdString:     AIndx := 16;
    mdIdentifier: AIndx := -1;
    mdInteger:    AIndx := 9;
    mdFloat:      AIndx := 7;
    mdDateTime:   AIndx := 15;
    mdDate:       AIndx := 5;
    mdTime:       AIndx := 14;
    end;
    if AIndx > 0 then begin
      if (ADataType <> mdDate) and (ADataType <> mdTime) then
        s := s + FTab.Columns[AIndx].Name + ' = !MAC'
      else if ADataType = mdDate then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', DATE)}' + ' = !MAC'
      else if ADataType = mdTime then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', TIME)}' + ' = !MAC';
    end
    else
      s := 'select 1 from !MAC';
    if AIndx = -10 then
      s := '';
    Result := s;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then begin
    Sleep(0);
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      s := GetMacrosString(j, iIndx);
      RunCompMacros(s, j, iIndx);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestMacroMSAccess;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Integers[0],  ftInteger, 2);
      SetField(Floats[0],    ftFloat, 3);
      SetField(Strings[0],   ftString, 6);
      SetField(DateTimes[2], ftDateTime, 8);
      SetField(Booleans[0],  ftBoolean, 10);
    end;
  end;

  function GetMacrosString(ADataType: TADMacroDataType; var AIndx: Integer): String;
  var
    s: String;
  begin
    s := 'select 1 from {id ADQA_All_types} where ';
    AIndx := -10;
    case ADataType of
    mdString:     AIndx := 6;
    mdIdentifier: AIndx := -1;
    mdInteger:    AIndx := 2;
    mdBoolean:    AIndx := 10;
    mdFloat:      AIndx := 3;
    mdDateTime:   AIndx := 8;
    end;
    if AIndx > 0 then begin
      if (ADataType <> mdDate) and (ADataType <> mdTime) then
        s := s + FTab.Columns[AIndx].Name + ' = !MAC'
      else if ADataType = mdDate then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', DATE)}' + ' = !MAC'
      else if ADataType = mdTime then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', TIME)}' + ' = !MAC';
    end
    else
      s := 'select 1 from !MAC';
    if AIndx = -10 then
      s := '';
    Result := s;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then begin
    Sleep(550);
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      s := GetMacrosString(j, iIndx);
      RunCompMacros(s, j, iIndx);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestMacroMSSQL;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Booleans[0], ftBoolean, 2);
      SetField(Strings[0],  ftString, 3);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(DateTimes[2]),
                            ftTimeStamp, 4);
{$ELSE}
      SetField(DateTimes[2],ftDateTime, 4);
{$ENDIF}
      SetField(Floats[0],   ftFloat, 5);
      SetField(Integers[0], ftInteger, 7);
    end;
  end;

  function GetMacrosString(ADataType: TADMacroDataType; var AIndx: Integer): String;
  var
    s: String;
  begin
    s := 'select 1 from {id ADQA_All_types} where ';
    AIndx := -10;
    case ADataType of
    mdString:     AIndx := 3;
    mdIdentifier: AIndx := -1;
    mdInteger:    AIndx := 7;
    mdBoolean:    AIndx := 2;
    mdFloat:      AIndx := 5;
    mdDateTime:   AIndx := 4;
    end;
    if AIndx > 0 then begin
      if (ADataType <> mdDate) and (ADataType <> mdTime) then
        s := s + FTab.Columns[AIndx].Name + ' = !MAC'
      else if ADataType = mdDate then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', DATE)}' + ' = !MAC'
      else if ADataType = mdTime then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', TIME)}' + ' = !MAC';
    end
    else
      s := 'select 1 from !MAC';
    if AIndx = -10 then
      s := '';
    Result := s;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      s := GetMacrosString(j, iIndx);
      RunCompMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestMacroASA;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Booleans[0], ftBoolean, 3);
      SetField(Strings[0],  ftString, 4);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(DateTimes[2]),
                            ftTimeStamp, 18);
{$ELSE}
      SetField(DateTimes[2],ftDateTime, 18);
{$ENDIF}
      SetField(Floats[0],   ftFloat, 8);
      SetField(Integers[0], ftInteger, 11);
    end;
  end;

  function GetMacrosString(ADataType: TADMacroDataType; var AIndx: Integer): String;
  var
    s: String;
  begin
    s := 'select 1 from {id ADQA_All_types} where ';
    AIndx := -10;
    case ADataType of
    mdString:     iIndx := 4;
    mdIdentifier: iIndx := -1;
    mdInteger:    iIndx := 11;
    mdBoolean:    iIndx := 3;
    mdFloat:      iIndx := 8;
    mdDateTime:   iIndx := 18;
    end;
    if AIndx > 0 then begin
      if (ADataType <> mdDate) and (ADataType <> mdTime) then
        s := s + FTab.Columns[AIndx].Name + ' = !MAC'
      else if ADataType = mdDate then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', DATE)}' + ' = !MAC'
      else if ADataType = mdTime then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', TIME)}' + ' = !MAC';
    end
    else
      s := 'select 1 from !MAC';
    if AIndx = -10 then
      s := '';
    Result := s;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      s := GetMacrosString(j, iIndx);
      RunCompMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestMacroMySQL;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Booleans[0], ftBoolean, 2);
      SetField(Integers[0], ftInteger, 4);
      SetField(Floats[0],   ftFloat, 8);
      SetField(Strings[0],  ftString, 13);
      SetField(Dates[0],    ftDate, 15);
      SetField(Times[0],    ftTime, 16);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(TimeStamps[0]),
                            ftTimeStamp, 19);
{$ELSE}
      SetField(ADSQLTimeStampToDateTime(TimeStamps[0]),
                            ftDateTime, 19);
{$ENDIF}
    end;
  end;

  function GetMacrosString(ADataType: TADMacroDataType; var AIndx: Integer): String;
  var
    s: String;
  begin
    s := 'select 1 from {id ADQA_All_types} where ';
    AIndx := -10;
    case ADataType of
    mdString:     AIndx := 13;
    mdIdentifier: AIndx := -1;
    mdInteger:    AIndx := 4;
    mdBoolean:    AIndx := 2;
    mdFloat:      AIndx := 8;
    mdDate:       AIndx := 15;
    mdTime:       AIndx := 16;
    mdDateTime:   AIndx := 19;
    end;
    if AIndx > 0 then begin
      if (ADataType <> mdDate) and (ADataType <> mdTime) then
        s := s + FTab.Columns[AIndx].Name + ' = !MAC'
      else if ADataType = mdDate then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', DATE)}' + ' = !MAC'
      else if ADataType = mdTime then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', TIME)}' + ' = !MAC';
    end
    else
      s := 'select 1 from !MAC';
    if AIndx = -10 then
      s := '';
    Result := s;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      s := GetMacrosString(j, iIndx);
      RunCompMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestMacroOra;
var
  iIndx: Integer;
  j:     TADMacroDataType;
  s:     String;

  procedure GetParamsArray;
  begin
    with FVarFieldList do begin
      Clear;
      CreateEmptyList(FTab.Columns.Count);
      SetField(Strings[0],                           ftString, 1);
{$IFDEF AnyDAC_D6}
      SetField(VarFmtBCDCreate(Integers[0]),         ftFMTBcd, 2);
{$ELSE}
      SetField(Integers[0],                          ftBcd, 2); // ????
{$ENDIF}
      SetField(Floats[0],                            ftFloat, 3);
{$IFDEF AnyDAC_D6}
      SetField(VarSQLTimeStampCreate(DateTimes[2]),  ftTimeStamp, 6);
{$ELSE}
      SetField(DateTimes[2],                         ftDateTime, 6);
{$ENDIF}
    end;
  end;

  function GetMacrosString(ADataType: TADMacroDataType; var AIndx: Integer): String;
  var
    s: String;
  begin
    s := 'select 1 from {id ADQA_All_types} where ';
    AIndx := -10;
    case ADataType of
    mdString:     AIndx := 1;
    mdIdentifier: AIndx := -1;
    mdInteger:    AIndx := 2;
    mdFloat:      AIndx := 3;
    mdDate:       AIndx := 6;
    mdTime:       AIndx := 6;
    mdDateTime:   AIndx := 6;
    end;
    if AIndx > 0 then begin
      if (ADataType <> mdDate) and (ADataType <> mdTime) then
        s := s + FTab.Columns[AIndx].Name + ' = !MAC'
      else if ADataType = mdDate then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', DATE)} = !MAC'
      else if ADataType = mdTime then
        s := s + '{fn CONVERT(' + FTab.Columns[AIndx].Name + ', TIME)} = !MAC';
    end
    else
      s := 'select 1 from !MAC';
    if AIndx = -10 then
      s := '';
    Result := s;
  end;

begin
  DeleteFromSource;
  GetParamsArray;
  if Insert then
    for j := Low(TADMacroDataType) to High(TADMacroDataType) do begin
      s := GetMacrosString(j, iIndx);
      RunCompMacros(s, j, iIndx);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestReadWriteBlob;
var
  pInData:  Pointer;
  iCurLen:  Integer;

  procedure AllocMemory;
  begin
    GetMem(pInData, iCurLen);
    FillChar(pInData^, iCurLen, 's');
  end;

  procedure FreeMemory;
  begin
    FreeMem(pInData);
  end;

  procedure DeleteData(const ATab: String);
  begin
    with FQuery do begin
      SQL.Text := 'delete from {id ' + ATab + '}';
      ExecSQL;
    end;
  end;

  function WriteData(const ATab: String; AType: TFieldType): Boolean;
  begin
    Result := True;
    with FQuery do begin
      SQL.Text := 'insert into {id ' + ATab + '}(blobdata) values(:p)';
      with Params[0] do begin
        DataType := AType;
        SetBlobRawData(iCurLen, PChar(pInData));
      end;
      try
        ExecSQL;
      except
        on E: Exception do begin
          Error(ErrorOnWriteBlobData(iCurLen, '{' + ATab + '} ' + E.Message));
          Result := False;
        end;
      end;
    end;
  end;

  function ReadData(const AField, ATab: String): Boolean;
  begin
    with FQuery do begin
      SQL.Text := 'select ' + AField + ' from {id ' + ATab + '} order by id';
      try
        Open;
      except
        on E: Exception do begin
          Error(E.Message);
          Result := False;
          Exit;
        end;
      end;
      Result := CheckRowsCount(nil, 1, FQuery.RecordCount);
    end;
  end;

  function CompareData(const ATab: String; ABlobFieldId: Integer): Boolean;
  var
    S1, S2:     String;
    cWrongChar: Char;
    iPos:       Integer;

    procedure DefineWrongSymbol;
    var
      i: Integer;
    begin
      for i := 1 to iCurLen do
        if S1[i] <> PChar(Integer(pInData) + i)^ then begin
          cWrongChar := S1[i];
          if cWrongChar = #0 then
            cWrongChar := ' ';
          iPos := i;
          Exit;
        end;
    end;

  begin
    Result := True;
    S1 := VarToStr(FQuery.Fields[ABlobFieldId].Value);
    if iCurLen <> Length(S1) then begin
      Error(Format(WrongBlobDataMsg3, [Length(S1), iCurLen]));
      Result := False;
      Exit;
    end;
    SetLength(S2, iCurLen);
    Move(PChar(pInData)^, PChar(S2)^, iCurLen);
    if Compare(S1, S2) <> 0 then begin
      DefineWrongSymbol;
      Error(WrongBlobData(String(cWrongChar), iPos, ATab));
      Result := False;
      Exit;
    end;
  end;

  function DoTestingBlobData(const AField, ATab: String; AType: TFieldType; ABlobFieldId: Integer): Boolean;
  begin
    Result := False;
    AllocMemory;
    try
      DeleteData(ATab);
      if WriteData(ATab, AType) then
        if ReadData(AField, ATab) then
          Result := CompareData(ATab, ABlobFieldId);
    finally
      FreeMemory;
    end;
  end;

begin
  with FQuery.FetchOptions do begin
    Mode := fmAll;
    Items := [fiBlobs];
  end;
  try
    iCurLen := 0;
    DoTestingBlobData('*', 'ADQA_Blob', ftBlob, 1);

    iCurLen := 32769;
    DoTestingBlobData('*', 'ADQA_Blob', ftBlob, 1);

    iCurLen := 4000000;
    DoTestingBlobData('*', 'ADQA_Blob', ftBlob, 1);

    if FRDBMSKind = mkOracle then begin
      iCurLen := 0;
      DoTestingBlobData('*', 'ADQA_LongRaw', ftBlob, 1);

      iCurLen := 32769;
      DoTestingBlobData('*', 'ADQA_LongRaw', ftBlob, 1);

      iCurLen := 4000000;
      DoTestingBlobData('*', 'ADQA_LongRaw', ftBlob, 1);

      for iCurLen := 3900 to 4100 do
        if not DoTestingBlobData('*', 'ADQA_Blob', ftOraBlob, 1) then
          break;

      for iCurLen := 4001 to 4002 do
        if not DoTestingBlobData('*', 'ADQA_Clob', ftOraClob, 1) then
          break;
    end;
  finally
    with FQuery.FetchOptions do begin
      Mode := fmOnDemand;
      Items := [fiBlobs, fiDetails, fiMeta];
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestInsert;
var
  vMasterID, vDetailID: Variant;
  i: Integer;
begin
  try
    FQuery.SQL.Text := 'delete from {id ADQA_master_autoinc}';
    FQuery.ExecSQL;
    FQuery.SQL.Text := 'select * from {id ADQA_master_autoinc}';
    FQuery.Open;
    FQuery.Insert;
    FQuery.Post;
    vMasterID := FQuery['id1'];

    FQuery.SQL.Text := 'delete from {id ADQA_details_autoinc}';
    FQuery.ExecSQL;
    FQuery.SQL.Text := 'select * from {id ADQA_details_autoinc}';
    FQuery.IndexFieldNames := 'fk_id1';
    FQuery.Open;
    for i := 1 to 5 do begin
      FQuery.Insert;
      FQuery['fk_id1'] := vMasterID;
      FQuery['name2'] := IntToStr(i);
      FQuery.Post;
    end;

    if FQuery.RecordCount <> 5 then
      Error('Invalid row count after inserting records');

    FQuery.First;
    while True do begin
      vDetailID := FQuery['id2'];
      FQuery.Next;
      if FQuery.Eof then
        Break;
      if vDetailID + 1 <> FQuery['id2'] then
        Error('Invalid row order after inserting records');
    end;
  finally
    FQuery.IndexFieldNames := '';
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQACompQRYTsHolder.TestMasterDetail;
var
  oMastQry, oDetQry: TADQuery;
  oMastSrc: TDataSource;
  vMasterID: Variant;
  i, j: Integer;

  procedure CheckMatching(const APhase: String);
  begin
    if not oMastQry.Active then
      Error(Format('%s. oMastQry is not active', [APhase]));
    if not oDetQry.Active then
      Error(Format('%s. oDetQry is not active', [APhase]));
    if Compare(oMastQry['id1'], oDetQry['fk_id1']) <> 0 then
      Error(Format('%s. Detail record is not matched. Expect fk_id1=[%s], actual fk_id1=[%s]',
        [APhase, VarToStr(oMastQry['id1']), VarToStr(oDetQry['fk_id1'])]));
  end;

begin
  oMastQry := TADQuery.Create(nil);
  oMastQry.Connection := FConnection;
  oMastSrc := TDataSource.Create(nil);
  oMastSrc.DataSet := oMastQry;

  oDetQry := TADQuery.Create(nil);
  oDetQry.Connection := FConnection;
  oDetQry.MasterSource := oMastSrc;
  try

    oMastQry.SQL.Text := 'delete from {id ADQA_master_autoinc}';
    oMastQry.ExecSQL;
    oDetQry.SQL.Text := 'delete from {id ADQA_details_autoinc}';
    oDetQry.ExecSQL;

    oMastQry.SQL.Text := 'select * from {id ADQA_master_autoinc}';
    oMastQry.Open;
    oDetQry.SQL.Text := 'select * from {id ADQA_details_autoinc} where fk_id1 = :id1';
    oDetQry.Open;

    // 1. Check filling
    for i := 1 to 5 do begin
      oMastQry.Insert;
      oMastQry.Post;
      vMasterID := oMastQry['id1'];
      for j := 1 to 5 do begin
        oDetQry.Insert;
        oDetQry['fk_id1'] := vMasterID;
        oDetQry['name2'] := IntToStr(i) + '/' + IntToStr(j);
        oDetQry.Post;
        CheckMatching('1');
      end;
    end;

    // 2. Opening master then details
    oMastQry.Close;
    oDetQry.Close;
    oMastQry.Open;
    oDetQry.Open;
    CheckMatching('2');

    // 3. Opening details then master
    oMastQry.Close;
    oDetQry.Close;
    oDetQry.Open;
    oMastQry.Open;
    CheckMatching('3');

  finally
    oMastQry.Free;
    oMastSrc.Free;
    oDetQry.Free;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADQATsThreadWithQuery                                                        }
{-------------------------------------------------------------------------------}
constructor TADQATsThreadWithQuery.Create(ARDBMS: TADRDBMSKind; AWait: Boolean;
  AWhere: Integer);
begin
  FConnection := TADConnection.Create(nil);
  FQuery := TADQuery.Create(nil);
  FConnection.ConnectionDefName := GetConnectionDef(ARDBMS);
  FConnection.LoginPrompt := False;
  FQuery.Connection := FConnection;
  FQuery.CachedUpdates := True;

  with FQuery do begin
    SQL.Text := 'select * from {id ADQA_LockTable} order by id';
    Open;
  end;

  FTick1 := 0;
  FTick2 := 0;
  FWhere := AWhere;
  FWait  := AWait;
  FCntErrors := 0;

  FreeOnTerminate := False;
  inherited Create(True);
end;

{-------------------------------------------------------------------------------}
destructor TADQATsThreadWithQuery.Destroy;
begin
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsThreadWithQuery.Execute;
var
  i: Integer;
begin
  FTick1 := GetTickCount;
  with FQuery do
  try
    UpdateOptions.LockMode := lmPessimistic;
    UpdateOptions.LockWait := FWait;
    try
      First;
      i := 0;
      while i < FWhere do begin
        Next;
        Inc(i);
      end;

      Edit;
      Fields[0].AsInteger := 1000;
      Fields[1].AsString := 'changed by Thread';
      Post;

      FCntErrors := ApplyUpdates;
      CommitUpdates;
    except
    end;
  finally
    FConnection.Free;
    FConnection := nil;
    FQuery.Free;
    FQuery := nil;
  end;
  FTick2 := GetTickCount;
end;


initialization

  ADQAPackManager.RegisterPack('Comp Layer', TADQACompQRYTsHolder);

end.
