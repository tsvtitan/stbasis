{-------------------------------------------------------------------------------}
{ AnyDAC Data Adapter Layer implementation                                      }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADDAptManager;

interface

implementation

uses
  SysUtils, Classes, DB,
  daADStanIntf, daADStanOption, daADStanParam, daADStanFactory, daADStanUtil,
    daADStanError, daADStanConst,
  daADGUIxIntf,
  daADDatSManager,
  daADPhysIntf,
  daADDAptIntf, daADDAptColumn;

type
  TADDAptTableAdapter = class;
  TADDAptTableAdapters = class;
  TADDAptSchemaAdapter = class;

  TADDAptUpdatesJournalProcessor = class(TObject)
  private
    FJournal: TADDatSUpdatesJournal;
    FAdapters: TADDAptTableAdapters;
    FAdapter: TADDAptTableAdapter;
    FUpdateHandler: IADDAptUpdateHandler;
    FAutoMergeChangeLog: Boolean;
{$IFDEF AnyDAC_MONITOR}
    FMonitor: IADMoniClient;
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; AArgs: array of const);
{$ENDIF}
    function GetLimitToTable: TADDatSTable;
    function LookupTableAdapter(ATable: TADDatSTable): IADDAptTableAdapter;
  public
    constructor CreateForTableAdapter(ATableAdapter: TADDAptTableAdapter);
    constructor CreateForSchemaAdapter(ASchemaAdapter: TADDAptSchemaAdapter);
    destructor Destroy; override;
    function Process(AMaxErrors: Integer = -1): Integer;
    function Reconcile: Boolean;
    property LimitToTable: TADDatSTable read GetLimitToTable;
{$IFDEF AnyDAC_MONITOR}
    property Monitor: IADMoniClient read FMonitor write FMonitor;
{$ENDIF}
    property Journal: TADDatSUpdatesJournal read FJournal write FJournal;
    property AutoMergeChangeLog: Boolean read FAutoMergeChangeLog write FAutoMergeChangeLog;
    property UpdateHandler: IADDAptUpdateHandler read FUpdateHandler
      write FUpdateHandler;
  end;

  TADDAptTableAdapter = class(TADObject, IUnknown, IADStanObject,
    IADStanErrorHandler, IADPhysMappingHandler, IADDAptTableAdapter)
  private
    FDatSTable: TADDatSTable;
    FDatSTableName: String;
    FSourceRecordSetID: Integer;
    FSourceRecordSetName: String;
    FUpdateTableName: String;
    FColMappings: TADDAptColumnMappings;
    FMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
    FMappings: TADDAptTableAdapters;
    FDatSManager: TADDatSManager;

    FGeneratedCommands: TADPhysRequests;
    FCommands: array of IADPhysCommand;
    FBuffer: TADFormatConversionBuffer;
    FErrorHandler: IADStanErrorHandler;
    FUpdateHandler: IADDAptUpdateHandler;
    FDescribeHandler: IADPhysDescribeHandler;
    FInUpdateRowHandler: Boolean;

    function CompareRows(ABaseRow, ACheckRow: TADDatSRow): Boolean;
    procedure ProcessUpdate(ARow: TADDatSRow; var AAction: TADErrorAction;
      ARequest: TADPhysUpdateRequest; AUpdRowOptions: TADPhysUpdateRowOptions;
      AFillRowOptions: TADPhysFillRowOptions; AColumn: Integer);
    function GetUpdateRowCommand(ARow: TADDatSRow;
      AUpdRowOptions: TADPhysUpdateRowOptions; AUpdateRequest: TADPhysUpdateRequest;
      AFillRowOptions: TADPhysFillRowOptions; AColumn: Integer; ACacheCommand: Boolean;
      var AHasHBlob: Boolean): IADPhysCommand;
    procedure MergeRowFromParams(ABaseRow: TADDatSRow; AFetchedParams: TADParams;
      AClearRow: Boolean);
    procedure MergeRows(ABaseRow, AFetchedRow: TADDatSRow; AClearRow: Boolean);
    procedure ParName2Col(ABaseRow: TADDatSRow; const AName: String;
      var ACol: TADDatSColumn; var ARow: TADDatSRow; var AVersion: Integer);
    procedure ProcessRequest(const ACommand: IADPhysCommand; ARow: TADDatSRow;
      ARequest: TADPhysUpdateRequest; AUpdRowOptions: TADPhysUpdateRowOptions;
      AFillRowOptions: TADPhysFillRowOptions; AWrapByTX: Boolean);
    procedure SetParamsFromRow(AParams: TADParams; ARow: TADDatSRow);
{$IFDEF AnyDAC_MONITOR}
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; AArgs: array of const);
    function GetUpdateRequestName(ARequest: TADPhysUpdateRequest): String;
{$ENDIF}
    procedure SetCommand(AReq: TADPhysRequest; const ACmd: IADPhysCommand);
    function GetCommand(AReq: TADPhysRequest): IADPhysCommand;
    procedure UpdateCommands(AItem: Integer);
    procedure CheckSelectCommand;
    function GetSchemaAdapter: TADDAptSchemaAdapter;
    procedure InternalSetCommand(AReq: TADPhysRequest;
      const ACmd: IADPhysCommand);
    procedure ReleaseDatSTable;
    procedure AttachDatSTable(ATable: TADDatSTable);
    function MatchRecordSet(ATable: Pointer;
      ATabNameKind: TADPhysNameKind): Boolean;
    procedure GetConnection(out AConn: IADPhysConnection);

  protected
    // IUnknown
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);

    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception);

    // IADPhysMappingHandler
    function MapRecordSet(ATable: Pointer; ATabNameKind: TADPhysNameKind;
      var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
      var ADatSTable: TADDatSTable): TADPhysMappingResult;
    function MapRecordSetColumn(ATable: Pointer; ATabNameKind: TADPhysNameKind;
      AColumn: Pointer; AColNameKind: TADPhysNameKind; var ASourceID: Integer;
      var ASourceName, ADatSName, AUpdateName: String;
      var ADatSColumn: TADDatSColumn): TADPhysMappingResult;

    // IADDAptTableAdapter
    function GetSourceRecordSetID: Integer;
    procedure SetSourceRecordSetID(const AValue: Integer);
    function GetSourceRecordSetName: String;
    procedure SetSourceRecordSetName(const AValue: String);
    function GetUpdateTableName: String;
    procedure SetUpdateTableName(const AValue: String);
    function GetDatSTableName: String;
    procedure SetDatSTableName(const AValue: String);
    function GetDatSTable: TADDatSTable;
    procedure SetDatSTable(AValue: TADDatSTable);
    function GetColumnMappings: TADDAptColumnMappings;
    function GetMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
    procedure SetMetaInfoMergeMode(const AValue: TADPhysMetaInfoMergeMode);
    function GetTableMappings: IADDAptTableAdapters;
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(AValue: TADDatSManager);

    function GetSelectCommand: IADPhysCommand;
    procedure SetSelectCommand(const ACmd: IADPhysCommand);
    function GetInsertCommand: IADPhysCommand;
    procedure SetInsertCommand(const ACmd: IADPhysCommand);
    function GetUpdateCommand: IADPhysCommand;
    procedure SetUpdateCommand(const ACmd: IADPhysCommand);
    function GetDeleteCommand: IADPhysCommand;
    procedure SetDeleteCommand(const ACmd: IADPhysCommand);
    function GetLockCommand: IADPhysCommand;
    procedure SetLockCommand(const ACmd: IADPhysCommand);
    function GetUnLockCommand: IADPhysCommand;
    procedure SetUnLockCommand(const ACmd: IADPhysCommand);
    function GetFetchRowCommand: IADPhysCommand;
    procedure SetFetchRowCommand(const ACmd: IADPhysCommand);

    function GetOptions: IADStanOptions;
    function GetErrorHandler: IADStanErrorHandler;
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    function GetUpdateHandler: IADDAptUpdateHandler;
    procedure SetUpdateHandler(const AValue: IADDAptUpdateHandler);
    function GetDescribeHandler: IADPhysDescribeHandler;
    procedure SetDescribeHandler(const AValue: IADPhysDescribeHandler);

    function GetObj: TObject;

    function Define: TADDatSTable;
    procedure Fetch(AAll: Boolean = False); overload;
    function Update(AMaxErrors: Integer = -1): Integer; overload;
    function Reconcile: Boolean;
    procedure Reset;

    procedure Fetch(ARow: TADDatSRow; var AAction: TADErrorAction;
      AColumn: Integer; AFillRowOptions: TADPhysFillRowOptions); overload;
    procedure Update(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADPhysUpdateRowOptions = []; AForceRequest: TADPhysRequest = arFromRow); overload;
    procedure Lock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADPhysUpdateRowOptions = []);
    procedure UnLock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADPhysUpdateRowOptions = []);
  public
    constructor CreateForSchema(AMappings: TADDAptTableAdapters);
    procedure Initialize; override;
    destructor Destroy; override;
  end;

  TADDAptTableAdapters = class(TInterfacedObject, IUnknown,
    IADDAptTableAdapters)
  private
    FItems: TList;
    FSchemaAdapter: TADDAptSchemaAdapter;
    procedure Clear;
    function Find(ATable: Pointer;
      ANameKind: TADPhysNameKind): Integer;
    procedure DatSManagerDetaching;
    procedure DatSManagerAttached;
  protected
    // IUnknown
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    // IADDAptTableAdapters
    function GetCount: Integer;
    function GetItems(AIndex: Integer): IADDAptTableAdapter;
    function Lookup(ATable: Pointer; ANameKind: TADPhysNameKind): IADDAptTableAdapter;
    function Add(const ASourceRecordSetName: String = '';
      const ADatSTableName: String = '';
      const AUpdateTableName: String = ''): IADDAptTableAdapter; overload;
    procedure Add(const AAdapter: IADDAptTableAdapter); overload;
    procedure Remove(ATable: Pointer; ANameKind: TADPhysNameKind); overload;
    procedure Remove(const AAdapter: IADDAptTableAdapter); overload;
  public
    constructor Create(ASchemaAdapter: TADDAptSchemaAdapter);
    destructor Destroy; override;
  end;

  TADDAptSchemaAdapter = class(TADObject, IADStanObject,
    IADPhysMappingHandler, IADDAptSchemaAdapter)
  private
    FDatSManager: TADDatSManager;
    FAdapters: TADDAptTableAdapters;
    FUpdateHandler: IADDAptUpdateHandler;
    FErrorHandler: IADStanErrorHandler;
    procedure AttachDatSManager(AManager: TADDatSManager);
    procedure ReleaseDatSManager;
  protected
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);

    // IADPhysMappingHandler
    function MapRecordSet(ATable: Pointer; ATabNameKind: TADPhysNameKind;
      var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
      var ADatSTable: TADDatSTable): TADPhysMappingResult;
    function MapRecordSetColumn(ATable: Pointer; ATabNameKind: TADPhysNameKind;
      AColumn: Pointer; AColNameKind: TADPhysNameKind; var ASourceID: Integer;
      var ASourceName, ADatSName, AUpdateName: String;
      var ADatSColumn: TADDatSColumn): TADPhysMappingResult;

    // IADDAptSchemaAdapter
    function GetErrorHandler: IADStanErrorHandler;
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    function GetUpdateHandler: IADDAptUpdateHandler;
    procedure SetUpdateHandler(const AValue: IADDAptUpdateHandler);
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(AValue: TADDatSManager);
    function GetTableAdapters: IADDAptTableAdapters;
    function Reconcile: Boolean;
    function Update(AMaxErrors: Integer = -1): Integer;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
{ TADDAptUpdatesJournalProcessor                                                }
{-------------------------------------------------------------------------------}
constructor TADDAptUpdatesJournalProcessor.CreateForSchemaAdapter(
  ASchemaAdapter: TADDAptSchemaAdapter);
begin
  inherited Create;
  FAdapters := ASchemaAdapter.FAdapters;
  FJournal := ASchemaAdapter.GetDatSManager.Updates;
  ASSERT(FJournal <> nil);
{$IFDEF AnyDAC_MONITOR}
  if FAdapters.GetCount >= 1 then
    FMonitor := TADDAptTableAdapter(FAdapters.FItems.Items[0]).
      GetSelectCommand.Connection.Monitor;
{$ENDIF}
  FUpdateHandler := ASchemaAdapter.GetUpdateHandler;
end;

{-------------------------------------------------------------------------------}
constructor TADDAptUpdatesJournalProcessor.CreateForTableAdapter(
  ATableAdapter: TADDAptTableAdapter);
var
  oTab: TADDatSTable;
{$IFDEF AnyDAC_MONITOR}
  oConn: IADPhysConnection;
{$ENDIF}
begin
  inherited Create;
  FAdapter := ATableAdapter;
  oTab := ATableAdapter.GetDatSTable;
  if oTab <> nil then
    if oTab.UpdatesRegistry then
      FJournal := oTab.Updates
    else if (oTab.Manager <> nil) and oTab.Manager.UpdatesRegistry then
      FJournal := oTab.Manager.Updates;
  ASSERT(FJournal <> nil);
{$IFDEF AnyDAC_MONITOR}
  ATableAdapter.GetConnection(oConn);
  if oConn <> nil then
    FMonitor := oConn.Monitor;
{$ENDIF}
  FUpdateHandler := ATableAdapter.GetUpdateHandler;
end;

{-------------------------------------------------------------------------------}
destructor TADDAptUpdatesJournalProcessor.Destroy;
begin
  FAdapter := nil;
  FAdapters := nil;
  FJournal := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDAptUpdatesJournalProcessor.GetLimitToTable: TADDatSTable;
begin
  if FAdapter <> nil then
    Result := FAdapter.GetDatSTable
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDAptUpdatesJournalProcessor.LookupTableAdapter(ATable: TADDatSTable): IADDAptTableAdapter;
begin
  if FAdapter <> nil then begin
    ASSERT(FAdapter.GetDatSTable = ATable);
    Result := FAdapter as IADDAptTableAdapter;
  end
  else if FAdapters <> nil then
    Result := FAdapters.Lookup(Pointer(ATable.Name), nkDatS)
  else
    Result := nil;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADDAptUpdatesJournalProcessor.Trace(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; const AMsg: String; AArgs: array of const);
begin
  if (FMonitor <> nil) and FMonitor.Tracing then
    FMonitor.Notify(AKind, AStep, Self, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDAptUpdatesJournalProcessor.Process(AMaxErrors: Integer): Integer;
var
  eAction, eTmpAction, ePrevAction: TADErrorAction;
  iUpdOpts, iLockOpts, iUnlockOpts: TADPhysUpdateRowOptions;
  iReq: TADPhysUpdateRequest;
  oRow, oNextRow: TADDatSRow;
  oTabAdapter: IADDAptTableAdapter;
  oWait: IADGUIxWaitCursor;
begin
{$IFDEF AnyDAC_MONITOR}
  if LimitToTable <> nil then
    Trace(ekAdaptUpdate, esStart, 'Process',
      ['LimitToTable', LimitToTable.SourceName])
  else
    Trace(ekAdaptUpdate, esStart, 'Process', []);
  try
{$ENDIF}
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    try
      Result := 0;
      oRow := Journal.FirstChange(LimitToTable);
      while oRow <> nil do begin
        oNextRow := Journal.NextChange(oRow, LimitToTable);
        oTabAdapter := LookupTableAdapter(oRow.Table);

        if oTabAdapter <> nil then begin
          ePrevAction := eaRetry; // impossible output value
          case oRow.RowState of
          rsInserted:
            begin
              iReq := arInsert;
              iLockOpts := [uoNoSrvRecord, uoDeferedLock];
              iUpdOpts := [uoNoSrvRecord];
              iUnLockOpts := [];
            end;
          rsDeleted:
            begin
              iReq := arDelete;
              iLockOpts := [uoNoSrvRecord, uoDeferedLock];
              iUpdOpts := [];
              iUnLockOpts := [uoNoSrvRecord];
            end;
          rsModified:
            begin
              iReq := arUpdate;
              iLockOpts := [uoDeferedLock];
              iUpdOpts := [];
              iUnLockOpts := [];
            end;
          else
            iReq := arFetchRow;
          end;

          if iReq in [arInsert, arDelete, arUpdate] then begin
            try
              try
                eAction := eaApplied;
                oTabAdapter.Lock(oRow, eAction, iLockOpts);
                if eAction = eaApplied then begin
                  oTabAdapter.Update(oRow, eAction, iUpdOpts);
                  ePrevAction := eAction;
                end;
              finally
                if eAction <> eaApplied then begin
                  iUnlockOpts := iUnlockOpts + [uoCancelUnlock];
                  case iReq of
                  arInsert: iUnlockOpts := iUnlockOpts + [uoNoSrvRecord];
                  arDelete: iUnlockOpts := iUnlockOpts - [uoNoSrvRecord];
                  end;
                  eTmpAction := eaApplied;
                  oTabAdapter.UnLock(oRow, eTmpAction, iUnlockOpts);
                end
                else
                  oTabAdapter.UnLock(oRow, eAction, iUnlockOpts);
                if ePrevAction <> eaRetry then
                  eAction := ePrevAction;
              end;
            except
              eAction := eaFail;
            end;
            if eAction = eaFail then begin
              Inc(Result);
              if (AMaxErrors <> -1) and (Result > AMaxErrors) then
                Exit;
            end;
          end;
        end;

        oRow := oNextRow;
      end;
    finally
      oWait.StopWait;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if LimitToTable <> nil then
      Trace(ekAdaptUpdate, esEnd, 'Process',
        ['LimitToTable', LimitToTable.SourceName])
    else
      Trace(ekAdaptUpdate, esEnd, 'Process', []);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADDAptUpdatesJournalProcessor.Reconcile: Boolean;
var
  oRow, oNextRow: TADDatSRow;
  eAction: TADDAptReconcileAction;
  oTabAdapter: IADDAptTableAdapter;
  eErrAction: TADErrorAction;
  oWait: IADGUIxWaitCursor;
begin
{$IFDEF AnyDAC_MONITOR}
  if LimitToTable <> nil then
    Trace(ekAdaptUpdate, esStart, 'Reconcile',
      ['LimitToTable', LimitToTable.SourceName])
  else
    Trace(ekAdaptUpdate, esStart, 'Reconcile', []);
  try
{$ENDIF}
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    try
      if (Journal = nil) or not Assigned(FUpdateHandler) then begin
        if AutoMergeChangeLog and (Journal <> nil) then
          Journal.AcceptChanges(LimitToTable);
        Result := True;
        Exit;
      end;
      oRow := Journal.FirstChange(LimitToTable);
      if oRow = nil then begin
        if AutoMergeChangeLog then
          Journal.AcceptChanges(LimitToTable);
        Result := True;
        Exit;
      end;
      while oRow <> nil do begin
        oNextRow := Journal.NextChange(oRow, LimitToTable);
        oTabAdapter := LookupTableAdapter(oRow.Table);

        if (oTabAdapter <> nil) and oRow.HasErrors then begin
          oWait.PushWait;
          try
            eAction := raMerge;
            FUpdateHandler.ReconcileRow(oRow, eAction);
          finally
            oWait.PopWait;
          end;
          case eAction of
          raSkip:
            ;
          raAbort:
            Break;
          raMerge:
            begin
              oRow.ClearErrors;
              oRow.AcceptChanges;
            end;
          raCorrect:
            oRow.ClearErrors;
          raCancel:
            begin
              oRow.ClearErrors;
              oRow.RejectChanges;
            end;
          raRefresh:
            begin
              oRow.ClearErrors;
              eErrAction := eaApplied;
              oTabAdapter.Fetch(oRow, eErrAction, -1,
                [foClear] + ADGetFillRowOptions(oTabAdapter.Options.FetchOptions));
            end;
          end;
        end;

        oRow := oNextRow;
      end;
      Result := not Journal.HasChanges(LimitToTable);
    finally
      oWait.StopWait;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if LimitToTable <> nil then
      Trace(ekAdaptUpdate, esEnd, 'Reconcile',
        ['LimitToTable', LimitToTable.SourceName])
    else
      Trace(ekAdaptUpdate, esEnd, 'Reconcile', []);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ TADDAptTableAdapterMappingHandler                                             }
{-------------------------------------------------------------------------------}
type
  TADDAptTableAdapterMappingHandler = class(TInterfacedObject, IADPhysMappingHandler)
  private
    FTableAdapter: TADDAptTableAdapter;
  protected
    // IADPhysMappingHandler
    function MapRecordSet(ATable: Pointer; ATabNameKind: TADPhysNameKind;
      var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
      var ADatSTable: TADDatSTable): TADPhysMappingResult;
    function MapRecordSetColumn(ATable: Pointer; ATabNameKind: TADPhysNameKind;
      AColumn: Pointer; AColNameKind: TADPhysNameKind; var ASourceID: Integer;
      var ASourceName, ADatSName, AUpdateName: String;
      var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
  public
    constructor Create(ATableAdapter: TADDAptTableAdapter);
  end;

{-------------------------------------------------------------------------------}
constructor TADDAptTableAdapterMappingHandler.Create(ATableAdapter: TADDAptTableAdapter);
begin
  inherited Create;
  FTableAdapter := ATableAdapter;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapterMappingHandler.MapRecordSet(ATable: Pointer;
  ATabNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSTable: TADDatSTable): TADPhysMappingResult;
begin
  Result := FTableAdapter.MapRecordSet(ATable, ATabNameKind, ASourceID,
    ASourceName, ADatSName, AUpdateName, ADatSTable);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapterMappingHandler.MapRecordSetColumn(
  ATable: Pointer; ATabNameKind: TADPhysNameKind; AColumn: Pointer;
  AColNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
begin
  Result := FTableAdapter.MapRecordSetColumn(ATable, ATabNameKind, AColumn,
    AColNameKind, ASourceID, ASourceName, ADatSName, AUpdateName, ADatSColumn);
end;

{-------------------------------------------------------------------------------}
{ TADDAptTableAdapter                                                           }
{-------------------------------------------------------------------------------}
constructor TADDAptTableAdapter.CreateForSchema(AMappings: TADDAptTableAdapters);
begin
  inherited Create;
  FMappings := AMappings;
  if FMappings <> nil then
    FMappings.FItems.Add(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Initialize;
begin
  inherited Initialize;
  FBuffer := TADFormatConversionBuffer.Create;
  FColMappings := TADDAptColumnMappings.Create(nil);
  SetLength(FCommands, Integer(arDeleteAll) - Integer(arSelect) + 1);
  FSourceRecordSetID := -1;
  FMappings := nil;
end;

{-------------------------------------------------------------------------------}
destructor TADDAptTableAdapter.Destroy;
begin
  ReleaseDatSTable;
  SetDatSManager(nil);
  FreeAndNil(FBuffer);
  SetLength(FCommands, 0);
  FreeAndNil(FColMappings);
  FErrorHandler := nil;
  FUpdateHandler := nil;
  if FMappings <> nil then begin
    FMappings.FItems.Remove(Self);
    FMappings := nil;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter._AddRef: Integer;
begin
  Result := ADAddRef;
  if FMappings <> nil then
    FMappings._AddRef;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter._Release: Integer;
begin
  Result := ADDecRef;
  if FMappings <> nil then
    Result := FMappings._Release
  else if Result = 0 then
    Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetObj: TObject;
begin
  Result := Self;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetSchemaAdapter: TADDAptSchemaAdapter;
begin
  if FMappings <> nil then
    Result := FMappings.FSchemaAdapter
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetTableMappings: IADDAptTableAdapters;
begin
  if FMappings <> nil then
    Result := FMappings as IADDAptTableAdapters
  else
    Result := nil;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
// Tracing

procedure TADDAptTableAdapter.Trace(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; const AMsg: String; AArgs: array of const);
var
  oConn: IADPhysConnection;
begin
  GetConnection(oConn);
  if (oConn <> nil) and oConn.Tracing then
    oConn.Monitor.Notify(AKind, AStep, Self, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetName: TComponentName;
begin
  Result := GetSourceRecordSetName + ': ' + ClassName + '($' +
    IntToHex(Integer(Self), 8) + ')';
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetParent: IADStanObject;
begin
  if (FMappings = nil) or (FMappings.FSchemaAdapter = nil) then
    Result := nil
  else
    Result := FMappings.FSchemaAdapter as IADStanObject;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
  // ??? Schema adapter should call
end;

{-------------------------------------------------------------------------------}
// Get/Set props

function TADDAptTableAdapter.GetOptions: IADStanOptions;
var
  oCmd: IADPhysCommand;
begin
  oCmd := GetSelectCommand;
  if oCmd = nil then
    Result := nil
  else
    Result := oCmd.Options;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetColumnMappings: TADDAptColumnMappings;
begin
  Result := FColMappings;
  Result.DatSTable := GetDatSTable;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetSourceRecordSetID: Integer;
begin
  Result := FSourceRecordSetID;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetSourceRecordSetID(const AValue: Integer);
begin
  if FSourceRecordSetID <> AValue then begin
    FSourceRecordSetID := AValue;
    if AValue >= 0 then
      FSourceRecordSetName := '';
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetSourceRecordSetName: String;
var
  oCmd: IADPhysCommand;
begin
  Result := FSourceRecordSetName;
  oCmd := GetSelectCommand;
  if (Result = '') and (oCmd <> nil) then
    Result := oCmd.SourceObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetSourceRecordSetName(const AValue: String);
begin
  if FSourceRecordSetName <> AValue then begin
    FSourceRecordSetName := AValue;
    if AValue <> '' then
      FSourceRecordSetID := -1;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateTableName: String;
begin
  Result := FUpdateTableName;
  if Result = '' then
    Result := GetSourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetUpdateTableName(const AValue: String);
begin
  FUpdateTableName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetDatSTableName: String;
begin
  Result := FDatSTableName;
  if Result = '' then
    Result := GetSourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.ReleaseDatSTable;
begin
  if FDatSTable <> nil then begin
    FDatSTable.RemRef;
    FDatSTable := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.AttachDatSTable(ATable: TADDatSTable);
begin
  if FDatSTable <> ATable then begin
    ReleaseDatSTable;
    if ATable <> nil then
      ATable.AddRef;
    FDatSTable := ATable;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetDatSTableName(const AValue: String);
begin
  if FDatSTableName <> AValue then begin
    FDatSTableName := AValue;
    ReleaseDatSTable;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetDatSTable: TADDatSTable;
var
  i: Integer;
  oTabs: TADDatSTableList;
  sName: String;
begin
  if FDatSTable <> nil then
    Result := FDatSTable
  else begin
    sName := GetDatSTableName;
    if (sName <> '') and (GetSchemaAdapter <> nil) then begin
      oTabs := GetSchemaAdapter.GetDatSManager.Tables;
      i := oTabs.IndexOfName(sName);
      if i <> -1 then
        Result := oTabs.ItemsI[i]
      else
        Result := nil;
    end
    else
      Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetDatSTable(AValue: TADDatSTable);
begin
  if FDatSTable <> AValue then begin
    AttachDatSTable(AValue);
    FDatSTableName := '';
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
begin
  Result := FMetaInfoMergeMode;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetMetaInfoMergeMode(const AValue: TADPhysMetaInfoMergeMode);
begin
  FMetaInfoMergeMode := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetDatSManager: TADDatSManager;
begin
  if GetSchemaAdapter <> nil then
    Result := GetSchemaAdapter.GetDatSManager
  else
    Result := FDatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetDatSManager(AValue: TADDatSManager);
begin
  if FDatSManager <> AValue then begin
    SetDatSTable(nil);
    if FDatSManager <> nil then
      FDatSManager.RemRef;
    FDatSManager := AValue;
    if FDatSManager <> nil then
      FDatSManager.AddRef;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetCommand(AReq: TADPhysRequest): IADPhysCommand;
begin
  Result := FCommands[Integer(AReq) - Integer(arSelect)];
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetSelectCommand: IADPhysCommand;
begin
  Result := GetCommand(arSelect);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetDeleteCommand: IADPhysCommand;
begin
  Result := GetCommand(arDelete);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetFetchRowCommand: IADPhysCommand;
begin
  Result := GetCommand(arFetchRow);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetInsertCommand: IADPhysCommand;
begin
  Result := GetCommand(arInsert);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetLockCommand: IADPhysCommand;
begin
  Result := GetCommand(arLock);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUnlockCommand: IADPhysCommand;
begin
  Result := GetCommand(arUnlock);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateCommand: IADPhysCommand;
begin
  Result := GetCommand(arUpdate);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.UpdateCommands(AItem: Integer);
var
  i: Integer;
begin
  for i := 0 to Length(FCommands) - 1 do
    if TADPhysRequest(i + Integer(arSelect)) in FGeneratedCommands then begin
      Exclude(FGeneratedCommands, TADPhysRequest(i + Integer(arSelect)));
      if FCommands[i] <> nil then
        FCommands[i] := nil;
    end
    else begin
      if FCommands[i] <> nil then
        case AItem of
        0: ;
        1: with FCommands[i] do begin
            ErrorHandler := GetErrorHandler;
            MappingHandler := TADDAptTableAdapterMappingHandler.Create(Self) as
              IADPhysMappingHandler;
          end;
        2: ;
        3: FCommands[i].Disconnect;
        end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.InternalSetCommand(AReq: TADPhysRequest; const ACmd: IADPhysCommand);
begin
  if Length(FCommands) <> 0 then
    FCommands[Integer(AReq) - Integer(arSelect)] := ACmd;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetCommand(AReq: TADPhysRequest; const ACmd: IADPhysCommand);
var
  oCmd: IADPhysCommand;
begin
  oCmd := GetCommand(AReq);
  if oCmd <> ACmd then begin
    if oCmd <> nil then begin
      oCmd.ErrorHandler := nil;
      oCmd.MappingHandler := nil;
    end;
    InternalSetCommand(AReq, ACmd);
    if ACmd <> nil then begin
      ACmd.ErrorHandler := GetErrorHandler;
      ACmd.MappingHandler := TADDAptTableAdapterMappingHandler.Create(Self) as
        IADPhysMappingHandler;
      Exclude(FGeneratedCommands, AReq);
    end
    else
      Include(FGeneratedCommands, AReq);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.GetConnection(out AConn: IADPhysConnection);
var
  oCmd: IADPhysCommand;
begin
  oCmd := GetSelectCommand;
  if oCmd <> nil then
    AConn := oCmd.Connection
  else
    AConn := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetSelectCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arSelect, ACmd);
  UpdateCommands(0);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetDeleteCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arDelete, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetFetchRowCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arFetchRow, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetInsertCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arInsert, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetLockCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arLock, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetUnlockCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arUnlock, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetUpdateCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arUpdate, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.CheckSelectCommand;
begin
  if GetSelectCommand = nil then
    ADException(Self, [S_AD_LDApt], er_AD_DAptNoSelectCmd, []);
end;

{-------------------------------------------------------------------------------}
// Exception handling

procedure TADDAptTableAdapter.HandleException(
  const AInitiator: IADStanObject; var AException: Exception);
begin
  if Assigned(GetErrorHandler()) then
    GetErrorHandler().HandleException(AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetErrorHandler: IADStanErrorHandler;
var
  oManAdapt: TADDAptSchemaAdapter;
begin
  if FErrorHandler <> nil then
    Result := FErrorHandler
  else begin
    oManAdapt := GetSchemaAdapter;
    if oManAdapt <> nil then
      Result := oManAdapt.GetErrorHandler
    else
      Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetErrorHandler(const AValue: IADStanErrorHandler);
begin
  FErrorHandler := AValue;
  UpdateCommands(1);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateHandler: IADDAptUpdateHandler;
var
  oManAdapt: TADDAptSchemaAdapter;
begin
  if FUpdateHandler <> nil then
    Result := FUpdateHandler
  else begin
    oManAdapt := GetSchemaAdapter;
    if oManAdapt <> nil then
      Result := oManAdapt.GetUpdateHandler
    else
      Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetUpdateHandler(const AValue: IADDAptUpdateHandler);
begin
  FUpdateHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetDescribeHandler: IADPhysDescribeHandler;
begin
  Result := FDescribeHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetDescribeHandler(const AValue: IADPhysDescribeHandler);
begin
  FDescribeHandler := AValue;
  UpdateCommands(2);
end;

{-------------------------------------------------------------------------------}
// Mapping handling

function TADDAptTableAdapter.MatchRecordSet(ATable: Pointer;
  ATabNameKind: TADPhysNameKind): Boolean;
var
  oTab: TADDatSTable;
begin
  case ATabNameKind of
  nkID:
    Result := GetSourceRecordSetID = Integer(ATable);
  nkSource:
    Result := {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
      (String(ATable), GetSourceRecordSetName) = 0;
  nkDatS:
    Result := {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
      (String(ATable), GetDatSTableName) = 0;
  nkObj:
    begin
      oTab := TADDatSTable(ATable);
      Result :=
        (GetDatSTable <> nil) and (GetDatSTable = oTab) or
        (GetSourceRecordSetID <> -1) and (GetSourceRecordSetID = oTab.SourceID) or
        (GetSourceRecordSetName <> '') and (
          {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
          (GetSourceRecordSetName, oTab.SourceName) = 0) or
        (GetDatSTableName <> '') and (
          {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
          (GetDatSTableName, oTab.Name) = 0);
    end;
  nkDefault:
    Result := True;
  else
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADGetRecordSetInfo(const AAdapter: IADDAptTableAdapter;
  var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
  var ADatSTable: TADDatSTable);
var
  oTab: TADDatSTable;
  sName: String;
begin
  if AAdapter.SourceRecordSetID <> -1 then
    ASourceID := AAdapter.SourceRecordSetID;
  sName := AAdapter.SourceRecordSetName;
  if sName <> '' then
    ASourceName := sName;
  sName := AAdapter.DatSTableName;
  if sName <> '' then
    ADatSName := sName;
  sName := AAdapter.UpdateTableName;
  if sName <> '' then
    AUpdateName := sName;
  oTab := AAdapter.DatSTable;
  if oTab <> nil then
    ADatSTable := oTab;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.MapRecordSet(ATable: Pointer;
  ATabNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSTable: TADDatSTable): TADPhysMappingResult;
begin
  if (GetSchemaAdapter <> nil) and (ATabNameKind <> nkDefault) then
    Result := GetSchemaAdapter.MapRecordSet(ATable, ATabNameKind, ASourceID,
      ASourceName, ADatSName, AUpdateName, ADatSTable)
  else if MatchRecordSet(ATable, ATabNameKind) then begin
    Result := mrMapped;
    ADGetRecordSetInfo(Self as IADDAptTableAdapter, ASourceID,
      ASourceName, ADatSName, AUpdateName, ADatSTable);
  end
  else
    Result := mrNotMapped;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.MapRecordSetColumn(ATable: Pointer;
  ATabNameKind: TADPhysNameKind; AColumn: Pointer; AColNameKind: TADPhysNameKind;
  var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
  var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
var
  oColMap: TADDAptColumnMapping;
begin
  Result := mrNotMapped;
  if GetSchemaAdapter <> nil then
    Result := GetSchemaAdapter.MapRecordSetColumn(ATable, ATabNameKind,
      AColumn, AColNameKind, ASourceID, ASourceName, ADatSName, AUpdateName,
      ADatSColumn)
  else if MatchRecordSet(ATable, ATabNameKind) then
    if (GetColumnMappings = nil) or (GetColumnMappings.Count = 0) then
      Result := mrDefault
    else begin
      oColMap := GetColumnMappings.Lookup(AColumn, AColNameKind);
      if oColMap <> nil then begin
        Result := mrMapped;
        ADGetRecordSetColumnInfo(oColMap, ASourceID, ASourceName, ADatSName,
          AUpdateName, ADatSColumn);
      end;
    end;
end;

{-------------------------------------------------------------------------------}
// Command generation

procedure TADDAptTableAdapter.ParName2Col(ABaseRow: TADDatSRow; const AName: String;
  var ACol: TADDatSColumn; var ARow: TADDatSRow; var AVersion: Integer);
var
  i, i1, iCol, iKind, iUCNameLen: Integer;
  sUCName: String;
begin
  sUCName := UpperCase(AName);
  iUCNameLen := Length(sUCName);
  if StrLIComp(PChar(sUCName), PChar('NEW_P$_'), 7) = 0 then begin
    iKind := 1;
    AVersion := 1;
    i := 6;
  end
  else if StrLComp(PChar(sUCName), PChar('OLD_P$_'), 7) = 0 then begin
    iKind := 1;
    AVersion := -1;
    i := 6;
  end
  else if StrLComp(PChar(sUCName), PChar('NEW_'), 4) = 0 then begin
    iKind := 2;
    AVersion := 1;
    i := 6;
  end
  else if StrLComp(PChar(sUCName), PChar('OLD_'), 4) = 0 then begin
    iKind := 2;
    AVersion := -1;
    i := 6;
  end
  else begin
    iKind := 0;
    AVersion := 1;
    i := 1;
  end;
  ACol := nil;
  ARow := nil;
  if iKind = 1 then begin
    while (i + 2 <= iUCNameLen) and (sUCName[i] <> '#') and (sUCName[i] = '$') and (sUCName[i + 1] = '_') do begin
      Inc(i, 2);
      i1 := i;
      while (i <= iUCNameLen) and (sUCName[i] >= '0') and (sUCName[i] <= '9') do
        Inc(i);
      ADStr2Int(PChar(sUCName) + i1 - 1, i - i1, @iCol, SizeOf(iCol), False);
      if ARow = nil then
        ARow := ABaseRow
      else
        ARow := ARow.NestedRow[ACol.Index];
      ACol := ARow.Table.Columns[iCol];
    end;
  end
  else if iKind = 2 then begin
    ARow := ABaseRow;
    ACol := ARow.Table.Columns.ColumnByName(Copy(sUCName, 5, Length(sUCName)));
  end
  else if iKind = 0 then begin
    ARow := ABaseRow;
    ACol := ARow.Table.Columns.ColumnByName(sUCName);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetParamsFromRow(AParams: TADParams; ARow: TADDatSRow);
var
  i, iVersion: Integer;
  iRowVersion: TADDatSRowVersion;
  oPar: TADParam;
  oCol: TADDatSColumn;
  oRow: TADDatSRow;
  pSrcBuff, pDestBuff: Pointer;
  iLen, iFldSize: LongWord;
  iFldPrec: Integer;
  eFldType: TFieldType;
begin
  for i := 0 to AParams.Count - 1 do begin
    oPar := AParams[I];
    if oPar.ParamType in [ptUnknown, ptInput, ptInputOutput] then begin
      oCol := nil;
      oRow := nil;
      iVersion := -1;
      pSrcBuff := nil;
      pDestBuff := nil;
      iLen := 0;
      ParName2Col(ARow, oPar.Name, oCol, oRow, iVersion);
      if oCol <> nil then begin
        if iVersion = -1 then
          iRowVersion := rvOriginal
        else
          iRowVersion := rvCurrent;
        if oRow.GetData(oCol.Index, iRowVersion, pSrcBuff, 0, iLen, False) then begin
          if oCol.DataType <> oCol.SourceDataType then begin
            FBuffer.Check(oCol.SourceSize);
            pDestBuff := FBuffer.Ptr;
            GetOptions.FormatOptions.ConvertRawData(oCol.DataType, oCol.SourceDataType,
              pSrcBuff, iLen, pDestBuff, FBuffer.Size, iLen);
          end
          else
            pDestBuff := pSrcBuff;
        end;
        eFldType := ftUnknown;
        iFldSize := 0;
        iFldPrec := 0;
        GetOptions.FormatOptions.ColumnDef2FieldDef(oCol.SourceDataType,
          oCol.SourceScale, oCol.SourcePrecision, oCol.SourceSize, oCol.Attributes,
          eFldType, iFldSize, iFldPrec);
        if (oPar.DataType = ftUnknown) or (oPar.DataType <> eFldType) then begin
          oPar.DataType := eFldType;
          if oPar.ADDataType = dtUnknown then
            oPar.ADDataType := oCol.SourceDataType;
          if eFldType in [ftFloat, ftCurrency, ftBCD {$IFDEF AnyDAC_D6Base}, ftFmtBCD {$ENDIF}] then begin
            oPar.Precision := iFldPrec;
            oPar.NumericScale := SmallInt(iFldSize);
          end
          else
            oPar.Size := iFldSize;
        end;
        oPar.SetData(pDestBuff, iLen, -1);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.CompareRows(ABaseRow, ACheckRow: TADDatSRow): Boolean;
var
  oCols1, oCols2: TADDatSColumnSublist;
begin
  oCols1 := TADDatSColumnSublist.Create;
  oCols2 := TADDatSColumnSublist.Create;
  try
    oCols2.Fill(ACheckRow.Table, '*');
    oCols1.Fill(ABaseRow, oCols2.Names);
    { TODO -cADAPT : Check for ADT too ! }
    Result := (ABaseRow.CompareRows(oCols1, nil, nil, -1, ACheckRow,
      oCols2, rvOriginal, [], ADEmptyCC) = 0);
  finally
    oCols1.Free;
    oCols2.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.MergeRows(ABaseRow, AFetchedRow: TADDatSRow;
  AClearRow: Boolean);
var
  i, iBaseCol: Integer;
  oBaseCols, oFetchedCols: TADDatSColumnList;
  pBuff: Pointer;
  iLen: LongWord;
  lRefreshing, lLoadingData, lCtrlEditing: Boolean;
begin
  lRefreshing := (ABaseRow.RowState = rsUnchanged);
  lLoadingData := False;
  lCtrlEditing := not (ABaseRow.RowState in [rsDetached, rsForceWrite]) or AClearRow;
  ABaseRow.Table.BeginLoadData(lmRefreshing);
  try
    try
      oBaseCols := ABaseRow.Table.Columns;
      oFetchedCols := AFetchedRow.Table.Columns;
      for i := 0 to oFetchedCols.Count - 1 do begin
        iBaseCol := oBaseCols.IndexOfSourceName(oFetchedCols[i].SourceName);
        if iBaseCol <> -1 then begin
          if not lLoadingData then begin
            lLoadingData := True;
            if AClearRow then
              ABaseRow.Clear(False);
            if lCtrlEditing then
              ABaseRow.BeginEdit;
          end;
          if oBaseCols.ItemsI[iBaseCol].DataType = oFetchedCols.ItemsI[i].DataType then begin
            pBuff := nil;
            iLen := 0;
            AFetchedRow.GetData(i, rvDefault, pBuff, 0, iLen, False);
            ABaseRow.SetData(iBaseCol, pBuff, iLen);
          end
          else
            ABaseRow.SetData(iBaseCol, AFetchedRow.GetData(i, rvDefault));
        end;
      end;
      if lLoadingData and lCtrlEditing then begin
        ABaseRow.EndEdit;
        if lRefreshing then
          ABaseRow.AcceptChanges(False);
      end;
    except
      if lLoadingData and lCtrlEditing then
        ABaseRow.CancelEdit;
      raise;
    end;
  finally
    ABaseRow.Table.EndLoadData;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.MergeRowFromParams(ABaseRow: TADDatSRow;
  AFetchedParams: TADParams; AClearRow: Boolean);
var
  i: Integer;
  oCol: TADDatSColumn;
  oRow: TADDatSRow;
  iVersion: Integer;
  lRefreshing, lLoadingData, lCtrlEditing: Boolean;
begin
  lRefreshing := (ABaseRow.RowState = rsUnchanged);
  lLoadingData := False;
  lCtrlEditing := not (ABaseRow.RowState in [rsDetached, rsForceWrite]) or AClearRow;
  ABaseRow.Table.BeginLoadData(lmRefreshing);
  try
    try
      for i := 0 to AFetchedParams.Count - 1 do
        if AFetchedParams[i].ParamType in [ptOutput, ptInputOutput] then begin
          oCol := nil;
          oRow := nil;
          iVersion := -1;
          ParName2Col(ABaseRow, AFetchedParams[i].Name, oCol, oRow, iVersion);
          if (oRow <> nil) and (oCol <> nil) and (iVersion = 1) then begin
            if not lLoadingData then begin
              lLoadingData := True;
              if AClearRow then
                ABaseRow.Clear(False);
              if lCtrlEditing then
                ABaseRow.BeginEdit;
            end;
            oRow.SetData(oCol.Index, AFetchedParams[i].Value);
          end;
        end;
      if lLoadingData and lCtrlEditing then begin
        ABaseRow.EndEdit;
        if lRefreshing then
          ABaseRow.AcceptChanges(False);
      end;
    except
      if lLoadingData and lCtrlEditing then
        ABaseRow.CancelEdit;
      raise;
    end;
  finally
    ABaseRow.Table.EndLoadData;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.ProcessRequest(const ACommand: IADPhysCommand;
  ARow: TADDatSRow; ARequest: TADPhysUpdateRequest; AUpdRowOptions: TADPhysUpdateRowOptions;
  AFillRowOptions: TADPhysFillRowOptions; AWrapByTX: Boolean);
var
  oTab: TADDatSTable;
  lOpen, lClearErrorHandler: Boolean;

  procedure ErrorRecordIsDeleted(ARowsCount: Integer);
  const
    SOper: array[TADPhysUpdateRequest] of String = ('Insert', 'Update',
      'Delete', 'Lock', 'Unlock', 'Fetch', '', '');
  var
    s: String;
  begin
    s := LowerCase(SOper[ARequest]);
    if s[Length(s)] = 'e' then
      s := s + 'd'
    else
      s := s + 'ed';
    ADException(Self, [S_AD_LDApt], er_AD_DAptRecordIsDeleted,
      [SOper[ARequest], s, ARowsCount]);
  end;

begin
{$IFDEF AnyDAC_MONITOR}
  if ARow <> nil then
    Trace(ekAdaptUpdate, esStart, 'ProcessRequest',
      ['ARow.Table.Name', ARow.Table.SourceName])
  else
    Trace(ekAdaptUpdate, esStart, 'ProcessRequest', []);
  try
{$ENDIF}
    if ACommand.ErrorHandler = nil then begin
      lClearErrorHandler := True;
      ACommand.ErrorHandler := Self as IADStanErrorHandler;
    end
    else
      lClearErrorHandler := False;
    try
      with ACommand do begin
        CloseAll;
        if CommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
          if State = csInactive then
            Prepare;
          SetParamsFromRow(Params, ARow);
        end
        else begin
          SetParamsFromRow(Params, ARow);
          if State = csInactive then
            Prepare;
        end;
        if GetSelectCommand <> nil then
          SourceRecordSetName := GetSelectCommand.SourceRecordSetName;
        lOpen := (CommandKind in [skSelect, skSelectForUpdate, skStoredProcWithCrs]);
        try
          try
            while True do begin
              if lOpen then begin
                Open;
                if State <> csOpen then
                  Break;
                oTab := TADDatSTable.Create;
                try
                  Define(oTab, mmReset);
                  Fetch(oTab, True);
                  if ARequest = arLock then begin
                    if (oTab.Rows.Count <> 1) or not CompareRows(ARow, oTab.Rows[0]) then
                      if Options.UpdateOptions.CountUpdatedRecords then
                        ErrorRecordIsDeleted(oTab.Rows.Count);
                  end
                  else if ARequest in [arFetchRow, arInsert, arUpdate] then begin
                    if oTab.Rows.Count <> 1 then
                      if Options.UpdateOptions.CountUpdatedRecords then
                        ErrorRecordIsDeleted(oTab.Rows.Count);
                    if oTab.Rows.Count > 0 then
                      MergeRows(ARow, oTab.Rows[0], foClear in AFillRowOptions);
                  end;
                finally
                  oTab.Free;
                end;
              end
              else begin
                Execute;
                if RowsAffectedReal and (RowsAffected <> 1) and
                   Options.UpdateOptions.CountUpdatedRecords then
                  ErrorRecordIsDeleted(RowsAffected);
                if ARequest in [arInsert, arUpdate, arFetchRow, arUpdateHBlobs] then
                  MergeRowFromParams(ARow, Params, foClear in AFillRowOptions);
              end;
              NextRecordSet := True;
              lOpen := True;
            end;
          except
            on E: EADDBEngineException do begin
              if ARequest in [arInsert, arUpdate, arDelete, arLock,
                              arUnlock, arUpdateHBlobs] then begin
                ARow.RowError := E;
                EADDBEngineException(ARow.RowError).MonitorAdapter := nil;
              end;
              if E.Kind = ekRecordLocked then
                ADException(Self, [S_AD_LDApt], er_AD_DAptRecordIsLocked, [])
              else if E.Kind = ekNoDataFound then begin
                if Options.UpdateOptions.CountUpdatedRecords then
                  ErrorRecordIsDeleted(RowsAffected);
              end
              else
                raise;
            end;
          end;
        finally
          CloseAll;
        end;
      end;
    finally
      if lClearErrorHandler then
        ACommand.ErrorHandler := nil;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if ARow <> nil then
      Trace(ekAdaptUpdate, esEnd, 'ProcessRequest',
        ['ARow.Table.Name', ARow.Table.SourceName])
    else
      Trace(ekAdaptUpdate, esEnd, 'ProcessRequest', []);
  end;
{$ENDIF}
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateRequestName(ARequest: TADPhysUpdateRequest): String;
begin
  case ARequest of
  arLock:         Result := 'Lock';
  arUnLock:       Result := 'UnLock';
  arInsert:       Result := 'Insert';
  arDelete:       Result := 'Delete';
  arUpdate:       Result := 'Update';
  arUpdateHBlobs: Result := 'UpdateHBlobs';
  arFetchRow:     Result := 'FetchRow';
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateRowCommand(ARow: TADDatSRow;
  AUpdRowOptions: TADPhysUpdateRowOptions; AUpdateRequest: TADPhysUpdateRequest;
  AFillRowOptions: TADPhysFillRowOptions; AColumn: Integer; ACacheCommand: Boolean;
  var AHasHBlob: Boolean): IADPhysCommand;
var
  oConn: IADPhysConnection;
{$IFDEF AnyDAC_MONITOR}
  oObjIntf: IADStanObject;
{$ENDIF}
  eCommandKind: TADPhysCommandKind;
  oCmdGen: IADPhysCommandGenerator;
  oConnMeta: IADPhysConnectionMetadata;
begin
  if AUpdateRequest = arUnlock then
    Exit;
  GetConnection(oConn);
  oConn.CreateCommand(Result);
{$IFDEF AnyDAC_MONITOR}
  Supports(Result, IADStanObject, oObjIntf);
  oObjIntf.SetOwner(Self, GetUpdateRequestName(AUpdateRequest));
{$ENDIF}
  with Result.Options.ResourceOptions do begin
    ParamCreate := False;
    MacroCreate := False;
  end;
  oConn.CreateCommandGenerator(oCmdGen);
  oCmdGen.Options := GetOptions;
  oCmdGen.Table := ARow.Table;
  oCmdGen.Row := ARow;
  oCmdGen.Params := Result.Params;
  oCmdGen.MappingHandler := TADDAptTableAdapterMappingHandler.Create(Self) as
    IADPhysMappingHandler;
  if AColumn <> -1 then
    try
      oCmdGen.Column := ARow.Table.Columns[AColumn]
    except
    end
  else
    oCmdGen.Column := nil;
  oCmdGen.UpdateRowOptions := AUpdRowOptions;
  oCmdGen.FillRowOptions := AFillRowOptions;
  oCmdGen.DescribeHandler := GetDescribeHandler;
  case AUpdateRequest of
  arInsert:        Result.CommandText := oCmdGen.GenerateInsert;
  arUpdate:        Result.CommandText := oCmdGen.GenerateUpdate;
  arDelete:        Result.CommandText := oCmdGen.GenerateDelete;
  arLock:          Result.CommandText := oCmdGen.GenerateLock;
  arUnlock:        Result.CommandText := oCmdGen.GenerateUnLock;
  arUpdateHBlobs:  Result.CommandText := oCmdGen.GenerateUpdateHBlobs;
  arFetchRow:      Result.CommandText := oCmdGen.GenerateSelect;
  end;
  eCommandKind := oCmdGen.CommandKind;
  AHasHBlob := oCmdGen.HasHBlobs;
  if Result.CommandText = '' then
    Result := nil
  else begin
    Result.CommandKind := eCommandKind;
    Result.ParamBindMode := pbByNumber;
    with Result.Options do begin
      FormatOptions.Assign(GetOptions.FormatOptions);
      FetchOptions.Assign(GetOptions.FetchOptions);
      UpdateOptions.Assign(GetOptions.UpdateOptions);
      ResourceOptions.Assign(GetOptions.ResourceOptions);
      with ResourceOptions do begin
        if AsyncCmdMode = amAsync then
          AsyncCmdMode := amBlocking;
        if (AUpdateRequest = arLock) and
           (UpdateOptions.LockMode = lmPessimistic) and not UpdateOptions.LockWait then begin
          oConn.CreateMetadata(oConnMeta);
          if not oConnMeta.LockNoWait and oConnMeta.AsyncAbortSupported then
            AsyncCmdTimeout := 1000
          else
            AsyncCmdTimeout := $FFFFFFFF;
        end;
        ParamCreate := False;
        MacroCreate := False;
        Disconnectable := True;
        if not ACacheCommand then
          DirectExecute := True;
      end;
      with FetchOptions do begin
        Mode := fmExactRecsMax;
        RecsMax := 1;
        Items := [];
        if foBlobs in AFillRowOptions then
          Items := Items + [fiBlobs];
        if foDetails in AFillRowOptions then
          Items := Items + [fiDetails];
        Cache := [];
        AutoClose := True;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.ProcessUpdate(ARow: TADDatSRow; var AAction: TADErrorAction;
  ARequest: TADPhysUpdateRequest; AUpdRowOptions: TADPhysUpdateRowOptions;
  AFillRowOptions: TADPhysFillRowOptions; AColumn: Integer);
var
  oConn: IADPhysConnection;
  iLockID: LongWord;
  lEndTX: Boolean;
  oCmd: IADPhysCommand;
  oMeta: IADPhysConnectionMetadata;
  iFillOpts: TADPhysFillRowOptions;
  lCacheUpdateCommand, lHasHBLob: Boolean;
  oUpdOpts: TADUpdateOptions;
  oExc: Exception;
{$IFDEF AnyDAC_MONITOR}
  sCaller: String;
{$ENDIF}
begin
  try
    CheckSelectCommand;
  except
    AAction := eaExitFailure;
    raise;
  end;
{$IFDEF AnyDAC_MONITOR}
  sCaller := GetUpdateRequestName(ARequest);
  if ARow <> nil then
    Trace(ekAdaptUpdate, esStart, sCaller,
      ['ARow.Table.Name', ARow.Table.SourceName])
  else
    Trace(ekAdaptUpdate, esStart, sCaller, []);
  try
{$ENDIF}
    AAction := eaApplied;
    oUpdOpts := GetOptions.UpdateOptions;

    if ARequest = arLock then
      case oUpdOpts.LockPoint of
      lpImmediate:
        if (uoDeferedLock in AUpdRowOptions) and
           not (uoOneMomLock in AUpdRowOptions) then
          Exit;
      lpDeferred:
        if not (uoDeferedLock in AUpdRowOptions) and
           not (uoOneMomLock in AUpdRowOptions) then
          Exit;
      end;

    lHasHBLob := False;
    lCacheUpdateCommand := False;
    oCmd := nil;
    iLockID := $FFFFFFFF;
    GetConnection(oConn);
    oConn.CreateMetadata(oMeta);
    AAction := eaDefault;

    // get existing command
    if not (ARequest in FGeneratedCommands) then
      oCmd := GetCommand(ARequest);
    if oCmd = nil then begin
      lCacheUpdateCommand := oUpdOpts.CacheUpdateCommands and
        (oUpdOpts.LockMode = lmRely) and (
          (ARequest = arDelete) and (oUpdOpts.UpdateMode = upWhereKeyOnly) or
          (ARequest = arInsert) and not oUpdOpts.UpdateChangedFields or
          (ARequest = arUpdate) and (oUpdOpts.UpdateMode = upWhereKeyOnly) and
            not oUpdOpts.UpdateChangedFields
         );
      if lCacheUpdateCommand then
        oCmd := GetCommand(ARequest)
      else begin
        InternalSetCommand(ARequest, nil);
        oCmd := nil;
      end;
    end;

    repeat
      try
        if not FInUpdateRowHandler and (GetUpdateHandler <> nil) then begin
          FInUpdateRowHandler := True;
          try
            GetUpdateHandler.UpdateRow(ARow, ARequest, AUpdRowOptions, AAction);
            if AAction <> eaDefault then
              lCacheUpdateCommand := False;
          finally
            FInUpdateRowHandler := False;
          end;
        end;
        if AAction in [eaRetry, eaDefault] then begin
          AAction := eaDefault;

          // build command if required
          if oCmd = nil then
            case ARequest of
            arLock:
              begin
                if oUpdOpts.LockMode <> lmRely then begin
                  if oMeta.TxSupported and
                     (not oConn.TxIsActive or oMeta.TxNested or oMeta.TxSavepoints) then
                    iLockID := oConn.TxBegin;
                  if not (uoNoSrvRecord in AUpdRowOptions) and
                    ((uoNoClntRecord in AUpdRowOptions) or (ARow.DBLockID = 0)) then
                    oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arLock,
                      [foData, foBlobs, foDetails, foForCheck], -1, lCacheUpdateCommand,
                      lHasHBLob);
                end;
              end;
            arUnLock:
              begin
                if (oUpdOpts.LockMode <> lmRely) and not (uoNoSrvRecord in AUpdRowOptions) and
                   ((uoNoClntRecord in AUpdRowOptions) or (ARow.DBLockID <> 0)) then
                  oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arUnLock,
                    [], -1, lCacheUpdateCommand, lHasHBLob);
              end;
            arInsert:
              begin
                if not oUpdOpts.EnableInsert then
                  ADException(Self, [S_AD_LDApt], er_AD_DAptCantInsert, []);
                oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arInsert,
                  [], -1, lCacheUpdateCommand, lHasHBLob);
              end;
            arDelete:
              begin
                if not oUpdOpts.EnableDelete then
                  ADException(Self, [S_AD_LDApt], er_AD_DAptCantDelete, []);
                oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arDelete,
                  [], -1, lCacheUpdateCommand, lHasHBLob);
              end;
            arUpdate:
              begin
                if not oUpdOpts.EnableUpdate then
                  ADException(Self, [S_AD_LDApt], er_AD_DAptCantEdit, []);
                oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arUpdate,
                  [], -1, lCacheUpdateCommand, lHasHBLob);
              end;
            arUpdateHBlobs:
              begin
                if not oUpdOpts.EnableInsert then
                  ADException(Self, [S_AD_LDApt], er_AD_DAptCantInsert, []);
                oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arUpdateHBlobs,
                  [], -1, lCacheUpdateCommand, lHasHBLob);
              end;
            arFetchRow:
              begin
                if ARow.RowState in [rsInserted, rsDeleted, rsModified, rsUnchanged] then
                  oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arFetchRow,
                    AFillRowOptions, AColumn, lCacheUpdateCommand, lHasHBLob);
              end;
            end;
          if (oCmd = nil) and (AAction = eaDefault) then
            if ARequest in [arDelete, arInsert] then
              AAction := eaFail
            else
              AAction := eaApplied;

          // process command if required
          if oCmd <> nil then
            ProcessRequest(oCmd, ARow, ARequest, AUpdRowOptions, AFillRowOptions,
              (ARequest in [arUpdate, arDelete]) and (oUpdOpts.LockMode <> lmRely));
        end;

        // post process
        if ARequest = arLock then begin
          if ((AAction = eaApplied) and (oCmd = nil) or
              (AAction = eaDefault) and (oCmd <> nil)) and
             not (uoNoClntRecord in AUpdRowOptions) and (oUpdOpts.LockMode <> lmRely) and
             (ARow.DBLockID = 0) then
            ARow.DBLock(iLockID);
          AAction := eaApplied;
        end
        else if ARequest = arUnLock then begin
          lEndTX := False;
          if ((AAction = eaApplied) and (oCmd = nil) or
              (AAction = eaDefault) and (oCmd <> nil)) and
             not (uoNoClntRecord in AUpdRowOptions) then begin
            if uoImmediateUpd in AUpdRowOptions then
              if uoCancelUnlock in AUpdRowOptions then
                ARow.RejectChanges
              else
                ARow.AcceptChanges;
            if (oUpdOpts.LockMode <> lmRely) and (ARow.DBLockID <> 0) then begin
              lEndTX := (oConn.TxSerialID = ARow.DBLockID);
              ARow.DBUnlock;
            end;
          end;
          if oUpdOpts.LockMode <> lmRely then begin
            if oMeta.TxSupported and oConn.TxIsActive and lEndTX then
              if uoCancelUnlock in AUpdRowOptions then
                oConn.TxRollback
              else
                oConn.TxCommit;
          end;
          AAction := eaApplied;
        end
        else if (ARequest in [arInsert, arUpdate]) then begin
          if oCmd <> nil then begin
            if (oUpdOpts.RefreshMode <> rmManual) and not oMeta.InlineRefresh then begin
              iFillOpts := ADGetFillRowOptions(GetOptions.FetchOptions);
              if ARequest = arInsert then
                Include(iFillOpts, foAfterIns)
              else if ARequest = arUpdate then
                Include(iFillOpts, foAfterUpd);
              Fetch(ARow, AAction, -1, iFillOpts);
            end;
            if (ARequest = arInsert) and lHasHBLob and
               not oMeta.InsertBlobsAfterReturning then
              ProcessUpdate(ARow, AAction, arUpdateHBlobs,
                AUpdRowOptions - [uoNoSrvRecord, uoNoClntRecord], [], -1)
            else
              AAction := eaApplied;
          end;
        end
        else
          AAction := eaApplied;

      except
        // handle exception
        on E: EADException do begin
          if Assigned(GetErrorHandler()) then begin
            oExc := EADDAptRowUpdateException.Create(ARequest, ARow, AAction, E);
            try
              GetErrorHandler().HandleException(nil, oExc);
              if oExc <> nil then
                AAction := EADDAptRowUpdateException(oExc).Action;
            finally
              oExc.Free;
            end;
          end
          else
            AAction := eaFail;
          if AAction = eaDefault then
            AAction := eaFail;
          if AAction = eaFail then
            raise;
        end;
      end;

    until AAction <> eaRetry;

    if AAction = eaFail then
      ADException(Self, [S_AD_LDApt], er_AD_DAptApplyUpdateFailed, []);
    if lCacheUpdateCommand then begin
      InternalSetCommand(ARequest, oCmd);
      if oCmd <> nil then
        Include(FGeneratedCommands, ARequest)
      else
        Exclude(FGeneratedCommands, ARequest);
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if ARow <> nil then
      Trace(ekAdaptUpdate, esEnd, sCaller,
        ['ARow.Table.Name', ARow.Table.SourceName])
    else
      Trace(ekAdaptUpdate, esEnd, sCaller, []);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Update(ARow: TADDatSRow; var AAction: TADErrorAction;
  AUpdRowOptions: TADPhysUpdateRowOptions; AForceRequest: TADPhysRequest);
var
  iKind: TADPhysUpdateRequest;
begin
  ASSERT((uoNoClntRecord in AUpdRowOptions) or (ARow <> nil));
  if AForceRequest = arNone then
    Exit
  else if AForceRequest = arFromRow then
    case ARow.RowState of
    rsInserted: iKind := arInsert;
    rsDeleted:  iKind := arDelete;
    rsModified: iKind := arUpdate;
    else        Exit;
    end
  else
    iKind := AForceRequest;
  ProcessUpdate(ARow, AAction, iKind, AUpdRowOptions, [], -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Lock(ARow: TADDatSRow; var AAction: TADErrorAction;
  AUpdRowOptions: TADPhysUpdateRowOptions);
begin
  ASSERT((uoNoClntRecord in AUpdRowOptions) or (ARow <> nil));
  ProcessUpdate(ARow, AAction, arLock, AUpdRowOptions, [], -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.UnLock(ARow: TADDatSRow; var AAction: TADErrorAction;
  AUpdRowOptions: TADPhysUpdateRowOptions);
begin
  ASSERT((uoNoClntRecord in AUpdRowOptions) or (ARow <> nil));
  ProcessUpdate(ARow, AAction, arUnlock, AUpdRowOptions, [], -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Fetch(ARow: TADDatSRow; var AAction: TADErrorAction;
  AColumn: Integer; AFillRowOptions: TADPhysFillRowOptions);
begin
  ASSERT(ARow <> nil);
  ProcessUpdate(ARow, AAction, arFetchRow, [], AFillRowOptions, AColumn);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.Define: TADDatSTable;
begin
  CheckSelectCommand;
  if GetDatSManager = nil then
    Result := GetSelectCommand.Define(GetDatSTable, GetMetaInfoMergeMode)
  else
    Result := GetSelectCommand.Define(GetDatSManager, GetDatSTable, GetMetaInfoMergeMode);
  if (Result <> nil) and (GetDatSTable = nil) then
    AttachDatSTable(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Fetch(AAll: Boolean);
begin
  CheckSelectCommand;
  GetSelectCommand.Fetch(GetDatSTable, AAll);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.Reconcile: Boolean;
var
  oPrc: TADDAptUpdatesJournalProcessor;
begin
  CheckSelectCommand;
  oPrc := TADDAptUpdatesJournalProcessor.CreateForTableAdapter(Self);
  try
    Result := oPrc.Reconcile;
  finally
    oPrc.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.Update(AMaxErrors: Integer = -1): Integer;
var
  oPrc: TADDAptUpdatesJournalProcessor;
begin
  CheckSelectCommand;
  oPrc := TADDAptUpdatesJournalProcessor.CreateForTableAdapter(Self);
  try
    Result := oPrc.Process(AMaxErrors);
  finally
    oPrc.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Reset;
begin
  UpdateCommands(3);
  FBuffer.Release;
end;

{-------------------------------------------------------------------------------}
{ TADDAptTableAdapters                                                          }
{-------------------------------------------------------------------------------}
constructor TADDAptTableAdapters.Create(ASchemaAdapter: TADDAptSchemaAdapter);
begin
  inherited Create;
  FSchemaAdapter := ASchemaAdapter;
  FItems := TList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDAptTableAdapters.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  FSchemaAdapter := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters._AddRef: Integer;
begin
  if FSchemaAdapter <> nil then
    Result := FSchemaAdapter._AddRef
  else
    Result := -1;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters._Release: Integer;
begin
  if FSchemaAdapter <> nil then
    Result := FSchemaAdapter._Release
  else
    Result := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.Clear;
var
  i: Integer;
begin
  for i := FItems.Count - 1 downto 0 do
    TADDAptTableAdapter(FItems.Items[i]).Free;
  FItems.Clear;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.GetCount: Integer;
begin
  Result := FItems.Count;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.Find(ATable: Pointer;
  ANameKind: TADPhysNameKind): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FItems.Count - 1 do
    if TADDAptTableAdapter(FItems.Items[i]).MatchRecordSet(ATable, ANameKind) then begin
      Result := i;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.GetItems(AIndex: Integer): IADDAptTableAdapter;
begin
  Result := TADDAptTableAdapter(FItems.Items[AIndex]) as IADDAptTableAdapter;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.Add(const ASourceRecordSetName: String = '';
  const ADatSTableName: String = ''; const AUpdateTableName: String = ''): IADDAptTableAdapter;
begin
  Result := TADDAptTableAdapter.CreateForSchema(Self) as IADDAptTableAdapter;
  with Result do begin
    SourceRecordSetName := ASourceRecordSetName;
    DatSTableName := ADatSTableName;
    UpdateTableName := AUpdateTableName;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.Add(const AAdapter: IADDAptTableAdapter);
var
  oAdapt: TADDAptTableAdapter;
begin
  if AAdapter.TableMappings <> nil then
    AAdapter.TableMappings.Remove(AAdapter);
  oAdapt := AAdapter.GetObj as TADDAptTableAdapter;
  FItems.Add(oAdapt);
  oAdapt.FMappings := Self;
  if (AAdapter.DatSTable <> nil) and (AAdapter.DatSTable.Manager <> FSchemaAdapter.GetDatSManager) then begin
    if AAdapter.DatSTable.Manager <> nil then
      AAdapter.DatSTable.Manager.Tables.Remove(AAdapter.DatSTable, True);
    if FSchemaAdapter.GetDatSManager <> nil then
      FSchemaAdapter.GetDatSManager.Tables.Add(AAdapter.DatSTable);
  end;
  FSchemaAdapter.ADAddRef(oAdapt.RefCount);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.DatSManagerDetaching;
var
  i: Integer;
  oAdapt: TADDAptTableAdapter;
  oTab: TADDatSTable;
begin
  for i := 0 to FItems.Count - 1 do begin
    oAdapt := TADDAptTableAdapter(FItems.Items[i]);
    oTab := oAdapt.GetDatSTable;
    if (oTab <> nil) and (oTab.Manager <> nil) and
       (oTab.Manager = FSchemaAdapter.GetDatSManager) then
      oTab.Manager.Tables.Remove(oTab, True);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.DatSManagerAttached;
var
  i: Integer;
  oAdapt: TADDAptTableAdapter;
  oTab: TADDatSTable;
begin
  for i := 0 to FItems.Count - 1 do begin
    oAdapt := TADDAptTableAdapter(FItems.Items[i]);
    oTab := oAdapt.GetDatSTable;
    if (oTab <> nil) and (oTab.Manager <> FSchemaAdapter.GetDatSManager) then begin
      if oTab.Manager <> nil then
        oTab.Manager.Tables.Remove(oTab, True);
      if FSchemaAdapter.GetDatSManager <> nil then
        FSchemaAdapter.GetDatSManager.Tables.Add(oTab);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.Remove(ATable: Pointer; ANameKind: TADPhysNameKind);
var
  i: Integer;
begin
  i := Find(ATable, ANameKind);
  if i <> -1 then
    Remove(GetItems(i));
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.Remove(const AAdapter: IADDAptTableAdapter);
var
  i: Integer;
  oAdapt: TADDAptTableAdapter;
begin
  oAdapt := AAdapter.GetObj as TADDAptTableAdapter;
  i := FItems.Remove(oAdapt);
  if i >= 0 then begin
    if (AAdapter.DatSTable <> nil) and (AAdapter.DatSTable.Manager = FSchemaAdapter.GetDatSManager) then
      AAdapter.DatSTable.Manager.Tables.Remove(AAdapter.DatSTable, True);
    FSchemaAdapter.ADDecRef(oAdapt.RefCount);
    oAdapt.FMappings := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.Lookup(ATable: Pointer;
  ANameKind: TADPhysNameKind): IADDAptTableAdapter;
var
  i: Integer;
begin
  i := Find(ATable, ANameKind);
  if i <> -1 then
    Result := GetItems(i)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
{ TADDAptSchemaAdapter                                                          }
{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.Initialize;
begin
  inherited Initialize;
  FAdapters := TADDAptTableAdapters.Create(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADDAptSchemaAdapter.Destroy;
begin
  ReleaseDatSManager;
  FreeAndNil(FAdapters);
  FErrorHandler := nil;
  FUpdateHandler := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetName: TComponentName;
begin
  Result := ClassName + '($' + IntToHex(Integer(Self), 8) + ')';
  if FDatSManager <> nil then
    Result := FDatSManager.Name + ': ' + Result;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetParent: IADStanObject;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetErrorHandler: IADStanErrorHandler;
begin
  Result := FErrorHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetErrorHandler(const AValue: IADStanErrorHandler);
var
  i: Integer;
begin
  if FErrorHandler <> AValue then begin
    FErrorHandler := AValue;
    for i := 0 to FAdapters.GetCount - 1 do
      TADDAptTableAdapter(FAdapters.FItems.Items[i]).UpdateCommands(1);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetUpdateHandler: IADDAptUpdateHandler;
begin
  Result := FUpdateHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetUpdateHandler(const AValue: IADDAptUpdateHandler);
begin
  FUpdateHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.MapRecordSet(ATable: Pointer;
  ATabNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSTable: TADDatSTable): TADPhysMappingResult;
var
  oTabAdapt: IADDAptTableAdapter;
begin
  oTabAdapt := GetTableAdapters.Lookup(ATable, ATabNameKind);
  if oTabAdapt = nil then
    Result := mrNotMapped
  else begin
    Result := mrMapped;
    ADGetRecordSetInfo(oTabAdapt, ASourceID, ASourceName, ADatSName,
      AUpdateName, ADatSTable);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.MapRecordSetColumn(ATable: Pointer;
  ATabNameKind: TADPhysNameKind; AColumn: Pointer;
  AColNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
var
  oTabAdapt: IADDAptTableAdapter;
  oColMap: TADDAptColumnMapping;
begin
  Result := mrNotMapped;
  oTabAdapt := GetTableAdapters.Lookup(ATable, ATabNameKind);
  if oTabAdapt <> nil then
    if (oTabAdapt.ColumnMappings = nil) or (oTabAdapt.ColumnMappings.Count = 0) then
      Result := mrDefault
    else begin
      oColMap := oTabAdapt.ColumnMappings.Lookup(AColumn, AColNameKind);
      if oColMap <> nil then begin
        Result := mrMapped;
        ADGetRecordSetColumnInfo(oColMap, ASourceID, ASourceName, ADatSName,
          AUpdateName, ADatSColumn);
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.ReleaseDatSManager;
begin
  if FDatSManager <> nil then begin
    FAdapters.DatSManagerDetaching;
    FDatSManager.RemRef;
    FDatSManager := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.AttachDatSManager(AManager: TADDatSManager);
begin
  if FDatSManager <> AManager then begin
    ReleaseDatSManager;
    FDatSManager := AManager;
    if AManager <> nil then begin
      AManager.AddRef;
      FAdapters.DatSManagerAttached;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetDatSManager: TADDatSManager;
var
  oMgr: TADDatSManager;
begin
  if FDatSManager = nil then begin
    oMgr := TADDatSManager.Create;
    oMgr.CountRef(0);
    oMgr.UpdatesRegistry := True;
    AttachDatSManager(oMgr);
  end;
  Result := FDatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetDatSManager(AValue: TADDatSManager);
begin
  if FDatSManager <> AValue then
    AttachDatSManager(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetTableAdapters: IADDAptTableAdapters;
begin
  Result := FAdapters as IADDAptTableAdapters;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.Reconcile: Boolean;
var
  oPrc: TADDAptUpdatesJournalProcessor;
begin
  oPrc := TADDAptUpdatesJournalProcessor.CreateForSchemaAdapter(Self);
  try
    Result := oPrc.Reconcile;
  finally
    oPrc.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.Update(AMaxErrors: Integer = -1): Integer;
var
  oPrc: TADDAptUpdatesJournalProcessor;
begin
  oPrc := TADDAptUpdatesJournalProcessor.CreateForSchemaAdapter(Self);
  try
    Result := oPrc.Process(AMaxErrors);
  finally
    oPrc.Free;
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  TADMultyInstanceFactory.Create(TADDAptTableAdapter, IADDAptTableAdapter);
  TADMultyInstanceFactory.Create(TADDAptSchemaAdapter, IADDAptSchemaAdapter);

end.
