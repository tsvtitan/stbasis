{ ----------------------------------------------------------------------------- }
{ AnyDAC physical layer base classes                                            }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADPhysManager;

interface

uses
  Windows, Classes, SysUtils,
  daADStanIntf, daADStanOption, daADStanParam, daADStanUtil, daADStanError,
    daADStanFactory,
  daADDatSManager,
  daADPhysIntf, daADPhysCmdGenerator,
  daADGUIxIntf;

type
  TADPhysManager = class;
  TADPhysManagerThread = class;
  TADPhysDriverHost = class;
  TADPhysDriver = class;
  TADPhysDriverLinkBase = class;
  TADPhysConnectionHost = class;
  TADPhysConnection = class;
  TADPhysCommand = class;
  TADPhysConnectionClass = class of TADPhysConnection;
  TADPhysDriverClass = class of TADPhysDriver;

  TADPhysFindObjMode = (fomNone, fomMBActive, fomMBNotInactive, fomIfActive);
  TADPhysAutoCommitPhase = (cpBeforeCmd, cpAfterCmdSucc, cpAfterCmdFail);

  TADPhysManager = class(TADObject, IUnknown,
    IADStanObject, IADStanOptions,
    IADPhysManager, IADPhysManagerMetadata)
  private
    FLock: TADMREWSynchronizer;
    FDriverDefs: IADStanDefinitions;
    FDriverHosts: TList;
    FState: TADPhysManagerState;
    FInactiveTimeout: LongWord;
    FManagerThread: TADPhysManagerThread;
    FConnectionDefs: IADStanConnectionDefs;
    FConnHosts: TList;
    FFetchOptions: TADFetchOptions;
    FFormatOptions: TADFormatOptions;
    FUpdateOptions: TADUpdateOptions;
    FResourceOptions: TADTopResourceOptions;
    FInactiveRegistrations: TList;
    FCloseLock: TRTLCriticalSection;
    FDesignTime: Boolean;
    function FindDriverHost(const ADriverID: String;
      AWrite: Boolean): TADPhysDriverHost;
    function DriverHostByID(const ADriverID: String;
      AMode: TADPhysFindObjMode; AWrite: Boolean): TADPhysDriverHost;
    procedure ReleaseDriver(const ADriver: IADPhysDriver);
    procedure CheckActive;
    procedure CheckInactive;
    procedure CheckActiveOrStoping;
    procedure BeginRead;
    procedure EndRead;
    function BeginWrite: Boolean;
    procedure EndWrite;
    procedure Closed;
    function GetConnDefFromConnDefName(const AConnDefName: String): IADStanConnectionDef;
    procedure InternalClose(ATerminate, AWaitForClose: Boolean);
    function IterateDriverHostsByBaseID(const ADriverID: String;
      AMode: TADPhysFindObjMode; var AHost: TADPhysDriverHost;
      AWrite: Boolean): Boolean;
    procedure Shutdown;
  protected
    // IUnknown
    function _Release: Integer; stdcall;
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADStanOptions
    function GetParentOptions(out AOpts: IADStanOptions): Boolean;
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetResourceOptions: TADResourceOptions;
    function GetUpdateOptions: TADUpdateOptions;
    // IADPhysManager
    procedure CreateConnection(const AConnectionDef: IADStanConnectionDef;
      out AConn: IADPhysConnection; AIntfRequired: Boolean = True); overload;
    procedure CreateConnection(const AConDefName: String;
      out AConn: IADPhysConnection; AIntfRequired: Boolean = True); overload;
    procedure CreateDriver(const ADriverID: String;
      out ADrv: IADPhysDriver; AIntfRequired: Boolean = True);
    procedure CreateMetadata(out AMeta: IADPhysManagerMetadata);
    procedure CreateDefaultConnectionMetadata(out AConMeta: IADPhysConnectionMetadata);
    procedure Open;
    procedure Close(AWait: Boolean = False);
    function GetDriverDefs: IADStanDefinitions;
    function GetConnectionDefs: IADStanConnectionDefs;
    function GetOptions: IADStanOptions;
    function GetState: TADPhysManagerState;
    function GetDesignTime: Boolean;
    procedure SetDesignTime(AValue: Boolean);
    // IADPhysManagerMetadata
    function GetDriverCount: Integer;
    function GetDriverID(Index: Integer): String;
    procedure CreateDriverMetadata(const ADriverID: String; out AMeta: IADPhysDriverMetadata);
  public
    procedure Initialize; override;
    destructor Destroy; override;
    procedure RegisterPhysConnectionClass(APhysConnClass: TADPhysConnectionClass);
    procedure UnRegisterPhysConnectionClass(APhysConnClass: TADPhysConnectionClass);
  end;

  TADPhysManagerThread = class(TADThread)
  private
    FManager: TADPhysManager;
    procedure SignalClosed;
  protected
    procedure DoIdle; override;
  public
    constructor Create(AManager: TADPhysManager);
    destructor Destroy; override;
  end;

  TADPhysDriverHost = class(TObject)
  private
    FBaseDriverID: String;
    FDriverID: String;
    FPackage: String;
    FhPackage: THandle;
    FParams: IADStanDefinition;
    FState: TADPhysDriverState;
    FDrvClass: TADPhysDriverClass;
    FConnClass: TADPhysConnectionClass;
    FLock: TADMREWSynchronizer;
    FDriverObj: TADPhysDriver;
    FDriver: IADPhysDriver;
    FInactiveTime: LongWord;
    FManager: TADPhysManager;
    function GetRefCount: Integer;
    procedure CantOperate(const AOper: String);
    procedure LoadDriver;
    procedure UnloadDriver;
    procedure RegisterPhysConnectionClass(APhysConnClass: TADPhysConnectionClass);
    procedure UnRegisterPhysConnectionClass;
    procedure InitializeDriver(AManager: TADPhysManager);
    procedure FinalizeDriver;
    procedure StopDriver;
    procedure CreateDriver(AManager: TADPhysManager; out ADrv: IADPhysDriver);
    procedure BeginRead;
    procedure EndRead;
    procedure BeginWrite;
    procedure EndWrite;
  public
    constructor Create(AManager: TADPhysManager);
    destructor Destroy; override;
    procedure GetVendorParams(var AHome, ALib: String);
    property DriverID: String read FDriverID;
    property State: TADPhysDriverState read FState;
    property RefCount: Integer read GetRefCount;
    property Manager: TADPhysManager read FManager;
    property Driver: TADPhysDriver read FDriverObj;
    property Params: IADStanDefinition read FParams;
  end;

  TADPhysDriver = class(TInterfacedObject, IUnknown,
    IADStanObject,
    IADPhysDriver, IADPhysDriverMetadata)
  private
    FDrvHost: TADPhysDriverHost;
    FConnections: TList;
  protected
    // IUnknown
    function _Release: Integer; stdcall;
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADPhysDriver
    function GetDriverIntfID: String;
    function GetRefCount: Integer;
    procedure ForceDisconnect;
    procedure CreateMetadata(out ADrvMeta: IADPhysDriverMetadata);
    procedure CreateConnectionWizard(out AWizard: IADPhysDriverConnectionWizard);
    function GetConnectionCount: Integer;
    function GetConnections(AIndex: Integer): IADPhysConnection;
    function GetState: TADPhysDriverState;
    // IADPhysDriverMetadata
    function GetConnParamCount(AKeys: TStrings): Integer; virtual;
    procedure GetConnParams(AKeys: TStrings; Index: Integer; var
      AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer); virtual;
    function GetDescription: String; virtual;
  public
    constructor Create(AInfo: TADPhysDriverHost); virtual;
    destructor Destroy; override;
    class function GetDriverID: String; virtual;
  end;

  TADPhysDriverLinkBase = class(TADComponent)
(*
  private
    FVendorHome: String;
    FVendorLib: String;
  protected
    class function GetDriverID: String; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
*)
  end;

  TADPhysConnectionHost = class(TInterfacedObject,
    IUnknown, IADStanObjectHost)
  private
    FManager: TADPhysManager;
    FConnectionDef: IADStanConnectionDef;
    FConnections: Integer;
    FPool: IADStanObjectFactory;
    FPassCode: LongWord;
    procedure InternalCreateConnection(out AConn: IADPhysConnection);
    procedure AddConn;
    procedure RemConn;
  protected
    // IUnknown
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    // IADStanObjectHost
    function GetObjectKindName: TComponentName;
    procedure CreateObject(out AObject: IADStanObject);
    // other
  public
    constructor Create(AManager: TADPhysManager; const AConnectionDef: IADStanConnectionDef);
    destructor Destroy; override;
    procedure CreateConnection(out AConn: IADPhysConnection);
    property Manager: TADPhysManager read FManager;
    property ConnectionDef: IADStanConnectionDef read FConnectionDef;
  end;

  TADPhysConnection = class(TInterfacedObject, IUnknown,
    IADMoniAdapter, IADStanObject, IADStanOptions, IADStanErrorHandler,
    IADPhysConnection)
  private
    FDriver: IADPhysDriver;
    FDriverObj: TADPhysDriver;
    FConnHost: TADPhysConnectionHost;
    FState: TADPhysConnectionState;
    FFetchOptions: TADFetchOptions;
    FFormatOptions: TADFormatOptions;
    FUpdateOptions: TADUpdateOptions;
    FResourceOptions: TADTopResourceOptions;
    FExternalOptions: IADStanOptions;
    FTxOptions,
    FExternalTxOptions: TADTxOptions;
    FSavepoints: TStrings;
    FTxIDAutoCommit: LongWord;
    FTxSerialID: LongWord;
    FLock: TADMREWSynchronizer;
    FErrorHandler: IADStanErrorHandler;
    FMetadata: TObject;
    FLogin: IADGUIxLoginDialog;
    FLoginPrompt: Boolean;
    FPreparedCommands: Integer;
    FInternalConnectionDef: IADStanConnectionDef;
    FPoolManaged: Boolean;
    FMoniAdapterHelper: TADMoniAdapterHelper;
{$IFDEF AnyDAC_MONITOR}
    FMonitor: IADMoniClient;
    FTracing: Boolean;
{$ENDIF}
    procedure CleanoutConnection;
    procedure CheckInactive;
    procedure CheckActive(ADisconnectingAllowed: Boolean = False);
    procedure RemoveCommand(ACommand: TADPhysCommand);
    procedure PerformAutoCommit(APhase: TADPhysAutoCommitPhase);
    procedure IncPrepared(ACommand: TADPhysCommand);
    procedure DecPrepared;
    procedure DoLogin;
  public
    // IUnknown
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  protected
    // IADMoniAdapter
    function GetHandle: LongWord;
    function GetItemCount: Integer; virtual;
    procedure GetItem(AIndex: Integer; var AName: String; var AValue: Variant;
      var AKind: TADDebugMonitorAdapterItemKind); virtual;
    procedure UpdateMonitor;
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADStanOptions
    function GetParentOptions(out AOpts: IADStanOptions): Boolean;
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetResourceOptions: TADResourceOptions;
    function GetUpdateOptions: TADUpdateOptions;
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception);
    // IADPhysConnection
    function GetRefCount: Integer;
    function GetDriver: IADPhysDriver;
    function GetState: TADPhysConnectionState;
    function GetOptions: IADStanOptions;
    function GetTxOptions: TADTxOptions;
    function GetTxIsActive: Boolean;
    function GetTxSerialID: LongWord;
    function GetCommandCount: Integer;
    function GetCommands(AIndex: Integer): IADPhysCommand;
    function GetErrorHandler: IADStanErrorHandler;
    function GetLogin: IADGUIxLoginDialog;
    function GetLoginPrompt: Boolean;
    function GetConnectionDef: IADStanConnectionDef;
    function GetMessages: EADDBEngineException; virtual;
    function GetCliObj: TObject; virtual;
    procedure SetOptions(const AValue: IADStanOptions);
    procedure SetTxOptions(const AValue: TADTxOptions);
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    procedure SetLogin(const AValue: IADGUIxLoginDialog);
    procedure SetLoginPrompt(const AValue: Boolean);
    procedure CreateMetadata(out AConnMeta: IADPhysConnectionMetadata);
    procedure CreateCommandGenerator(out AGen: IADPhysCommandGenerator;
      const ACommand: IADPhysCommand);
    procedure CreateCommand(out ACmd: IADPhysCommand);
    procedure CreateMetaInfoCommand(out AMetaCmd: IADPhysMetaInfoCommand);
    procedure ForceDisconnect;
    procedure Open;
    procedure Close;
    function TxBegin: LongWord;
    procedure TxCommit;
    procedure TxRollback;
    procedure ChangePassword(const ANewPassword: String);
    function GetLastAutoGenValue(const AName: String): Variant; virtual;
{$IFDEF AnyDAC_MONITOR}
    procedure TracingChanged;
    function GetTracing: Boolean;
    procedure SetTracing(AValue: Boolean);
    function GetMonitor: IADMoniClient;
    procedure TraceConnInfo(AKind: TADDebugMonitorAdapterItemKind;
      const AName: String);
{$ENDIF}
  protected
    // overridable be descendants
    class function GetDriverClass: TADPhysDriverClass; virtual;
    procedure InternalConnect; virtual; abstract;
    procedure InternalDisconnect; virtual; abstract;
    function InternalCreateMetadata: TObject; virtual; abstract;
    function InternalCreateCommand: TADPhysCommand; virtual; abstract;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand):
      TADPhysCommandGenerator; virtual; abstract;
    procedure InternalTxBegin(ATxID: LongWord); virtual; abstract;
    procedure InternalTxCommit(ATxID: LongWord); virtual; abstract;
    procedure InternalTxRollback(ATxID: LongWord); virtual; abstract;
    procedure InternalTxSetSavepoint(const AName: String); virtual; abstract;
    procedure InternalTxRollbackToSavepoint(const AName: String); virtual; abstract;
    procedure InternalTxCommitSavepoint(const AName: String); virtual;
    procedure InternalTxChanged; virtual;
    procedure InternalChangePassword(const AUserName, AOldPassword, ANewPassword: String); virtual;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; virtual;
{$ENDIF}
    procedure InternalOverrideNameByCommand(var AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand); virtual;
  protected
    FCommandList: TList;
    // utils
    FDefaultSchemaName,
    FDefaultCatalogName: String;
    FAllowReconnect: Boolean;
{$IFDEF AnyDAC_MONITOR}
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; const AArgs: array of const);
{$ENDIF}
    function GetLastTXID: LongWord;
    function GetUniqueTXID: LongWord;
    procedure UpdateTx;
  public
    constructor Create(ADriverObj: TADPhysDriver; const ADriver: IADPhysDriver;
      AConnHost: TADPhysConnectionHost); virtual;
    destructor Destroy; override;
    property DriverObj: TADPhysDriver read FDriverObj;
    property ConnectionDef: IADStanConnectionDef read GetConnectionDef;
    property DefaultSchemaName: String read FDefaultSchemaName;
    property DefaultCatalogName: String read FDefaultCatalogName;
    property AllowReconnect: Boolean read FAllowReconnect;
  end;

  TADPhysDataTableInfo = record
    FSourceName: String;
    FSourceID: Integer;
    FOriginName: String;
  end;

  TADPhysDataColumnInfo = record
    FParentTableSourceID: Integer;
    FTableSourceID: Integer;
    FSourceName: String;
    FSourceID: Integer;
    FOriginName: String;
    FType: TADDataType;
    FTypeName: String;
    FLen: LongWord;
    FPrec: Integer;
    FScale: Integer;
    FAttrs: TADDataAttributes;
    FForceAddOpts,
    FForceRemOpts: TADDataOptions;
  end;

  TADPhysCommand = class(TInterfacedObject, IUnknown,
    IADMoniAdapter, IADStanObject, IADStanOptions, IADStanErrorHandler,
    IADPhysCommand, IADPhysMetaInfoCommand)
  private
    FBaseObjectName: String;
    FSchemaName: String;
    FCatalogName: string;
    FCommandText: String;
    FCommandKind: TADPhysCommandKind;
    FFixedCommandKind: Boolean;
    FMacros: TADMacros;
    FParams: TADParams;
    FMetaInfoKind: TADPhysMetaInfoKind;
    FObjectScopes: TADPhysObjectScopes;
    FTableKinds: TADPhysTableKinds;
    FWildcard: String;
    FExternalOptions: IADStanOptions;
    FUpdateOptions: TADUpdateOptions;
    FFetchOptions: TADFetchOptions;
    FFormatOptions: TADFormatOptions;
    FResourceOptions: TADResourceOptions;
    FState: TADPhysCommandState;
    FSourceObjectName: String;
    FSourceRecordSetName: String;
    FRecordSetIndex: Integer;
    FOverload: Word;
    FEOF: Boolean;
    FFirstFetch: Boolean;
    FRecordsFetched: Integer;
    FNextRecordSet: Boolean;
    FErrorHandler: IADStanErrorHandler;
    FExecuteCount: Integer;
    FAsyncHandler: IADStanAsyncHandler;
    FRowsAffected: Integer;
    FRowsAffectedReal: Boolean;
    FErrorAction: TADErrorAction;
    FMappingHandler: IADPhysMappingHandler;
    FMoniAdapterHelper: TADMoniAdapterHelper;
    procedure CantChangeState;
    function DoDefineDataTable(ADatSManager: TADDatSManager; ATable: TADDatSTable;
      ARootID: Integer; const ARootName: String; AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
    procedure UpdateMonitor;
    procedure PreprocessCommand(ACreateParams, ACreateMacros,
      AExpandParams, AExpandMacros, AExpandEscapes, AParseSQL: Boolean);
    procedure SetConnectionObj(AConnObj: TADPhysConnection);
    procedure OpenBase;
    procedure OpenMain(AMode: TADStanAsyncMode; ATimeout: LongWord);
    procedure FetchBase(ATable: TADDatSTable; AAll: Boolean;
      var ARowsAffected: Integer);
    procedure FetchMain(ATable: TADDatSTable; AAll: Boolean;
      AMode: TADStanAsyncMode; ATimeout: LongWord);
    procedure ExecuteBase(ATimes, AOffset: LongInt;
      var ARowsAffected: LongInt; var ARowsAffectedReal: Boolean;
      var AAction: TADErrorAction);
    procedure ExecuteMain(ATimes, AOffset: Integer;
      AMode: TADStanAsyncMode; ATimeout: LongWord);
    procedure BeginDefine;
    function GetParamsOwner: TPersistent;
  protected
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception);
    // IADStanOptions
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADUpdateOptions;
    function GetResourceOptions: TADResourceOptions;
    function GetParentOptions(out AOpts: IADStanOptions): Boolean;
    // IADMoniAdapter
    function GetHandle: LongWord;
    function GetItemCount: Integer;
    procedure GetItem(AIndex: Integer; var AName: String; var AValue: Variant;
      var AKind: TADDebugMonitorAdapterItemKind);
    // IADPhysCommand
    function GetSchemaName: String;
    function GetCatalogName: String;
    function GetBaseObjectName: String;
    function GetConnection: IADPhysConnection;
    function GetOptions: IADStanOptions;
    function GetState: TADPhysCommandState;
    function GetCommandText: String;
    function GetCommandKind: TADPhysCommandKind;
    function GetParams: TADParams;
    function GetParamBindMode: TADParamBindMode;
    function GetOverload: Word;
    function GetNextRecordSet: Boolean;
    function GetErrorHandler: IADStanErrorHandler;
    function GetSourceObjectName: String;
    function GetSourceRecordSetName: String;
    function GetMacros: TADMacros;
    function GetAsyncHandler: IADStanAsyncHandler;
    function GetRowsAffected: Integer;
    function GetRowsAffectedReal: Boolean;
    function GetErrorAction: TADErrorAction;
    function GetMappingHandler: IADPhysMappingHandler;
    function GetSQLOrderByPos: Integer;
    function GetCliObj: TObject; virtual;
    procedure SetSchemaName(const AValue: String);
    procedure SetCatalogName(const AValue: String);
    procedure SetBaseObjectName(const AValue: String);
    procedure SetOptions(const AValue: IADStanOptions);
    procedure SetCommandText(const AValue: String);
    procedure SetCommandKind(const AValue: TADPhysCommandKind);
    procedure SetSourceObjectName(const AValue: String);
    procedure SetSourceRecordSetName(const AValue: String);
    procedure SetNextRecordSet(const AValue: Boolean);
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    procedure SetParamBindMode(const AValue: TADParamBindMode);
    procedure SetOverload(const AValue: Word);
    procedure SetAsyncHandler(const AValue: IADStanAsyncHandler);
    procedure SetMappingHandler(const AValue: IADPhysMappingHandler);
    procedure SetState(const AValue: TADPhysCommandState);
    procedure AbortJob(const AWait: Boolean = False);
    function Define(ADatSManager: TADDatSManager; ATable: TADDatSTable = nil;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    function Define(ATable: TADDatSTable;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0);
    procedure Fetch(ATable: TADDatSTable; AAll: Boolean = True); overload;
    procedure Fetch(ADatSManager: TADDatSManager;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset); overload;
    procedure Prepare(const ACommandText: String = '');
    procedure Unprepare;
    procedure Open;
    procedure Close;
    procedure CloseAll;
    procedure Disconnect;
    procedure CheckAsyncProgress;
    // IADPhysMetaInfoCommand
    function GetMetaInfoKind: TADPhysMetaInfoKind;
    procedure SetMetaInfoKind(AValue: TADPhysMetaInfoKind);
    function GetTableKinds: TADPhysTableKinds;
    procedure SetTableKinds(AValue: TADPhysTableKinds);
    function GetWildcard: String;
    procedure SetWildcard(const AValue: String);
    function GetObjectScopes: TADPhysObjectScopes;
    procedure SetObjectScopes(AValue: TADPhysObjectScopes);
  protected
    FConnectionObj: TADPhysConnection;
    FConnection: IADPhysConnection;
    FDbCommandText: String;
    FBuffer: TADFormatConversionBuffer;
    FSQLValuesPos: Integer;
    FSQLOrderByPos: Integer;
    // utils
    function GetTraceCommandText(const ACmd: String = ''): String;
{$IFDEF AnyDAC_MONITOR}
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; const AArgs: array of const);
{$ENDIF}
    function CheckFetchColumn(AColType: TADDataType): Boolean; overload;
    procedure CreateCommandGenerator(out AGen: IADPhysCommandGenerator);
    function OpenBlocked: Boolean;
    procedure FetchBlocked(ATable: TADDatSTable; AAll: Boolean);
    procedure ExecuteBlocked(ATimes: Integer; AOffset: Integer);
    procedure FillStoredProcParams(const ACatalog, ASchema, APackage, ACmd: String);
    procedure ColTypeMapError(AColumn: TADDatSColumn);
    procedure ParTypeMapError(AParam: TADParam);
    procedure ParTypeUnknownError(AParam: TADParam);
    procedure ParDefChangedError(AParam: TADParam);
    procedure CheckMetaInfoParams(const AName: TADPhysParsedName);
    // overridables
    procedure InternalAbort; virtual;
    procedure InternalPrepare; virtual; abstract;
    procedure InternalUnprepare; virtual; abstract;
    function InternalOpen: Boolean; virtual; abstract;
    function InternalNextRecordSet: Boolean; virtual; abstract;
    procedure InternalClose; virtual; abstract;
    procedure InternalExecute(ATimes: LongInt; AOffset: LongInt; var ACount: LongInt); virtual; abstract;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; virtual; abstract;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; virtual; abstract;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  ADPhysManagerObj: TADPhysManager;

{$IFDEF AnyDAC_MONITOR}
procedure ADPhysCreateMoniClient(const AParams: IADStanDefinition;
  out AMonitor: IADMoniClient);
{$ENDIF}  

implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
  DB,
  daADStanConst, daADStanResStrs,
  daADPhysCmdPreprocessor, daADPhysConnMeta;

var
  GClosedEvent: THandle = 0;

{ ----------------------------------------------------------------------------- }
{ AnyDAC_FPC specific                                                                  }
{ ----------------------------------------------------------------------------- }
{$IFDEF AnyDAC_FPC}
function ModuleIsPackage: Boolean;
begin
  Result := False;
end;

{ ----------------------------------------------------------------------------- }
function LoadPackage(const Name: string): HMODULE;
begin
  Result := 0;
  ADCapabilityNotSupported(nil, [S_AD_LPhys]);
end;

{ ----------------------------------------------------------------------------- }
procedure UnloadPackage(Module: HMODULE);
begin
  ADCapabilityNotSupported(nil, [S_AD_LPhys]);
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
{ TADPhysManager                                                                }
{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.Initialize;
begin
  inherited Initialize;
  FLock := TADMREWSynchronizer.Create;
  BeginWrite;
  try
    ADPhysManagerObj := Self;
    FFetchOptions := TADFetchOptions.Create(Self);
    FFormatOptions := TADFormatOptions.Create(Self);
    FUpdateOptions := TADUpdateOptions.Create(Self);
    FResourceOptions := TADTopResourceOptions.Create(Self);
    FDriverHosts := TList.Create;
    FConnHosts := TList.Create;
    FInactiveRegistrations := TList.Create;
    FInactiveTimeout := 20000;
    InitializeCriticalSection(FCloseLock);
  finally
    EndWrite;
  end;
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysManager.Destroy;
begin
  BeginWrite;
  try
    Closed;
    FDriverDefs := nil;
    FConnectionDefs := nil;
    FreeAndNil(FDriverHosts);
    FreeAndNil(FConnHosts);
    FreeAndNil(FInactiveRegistrations);
    _AddRef;
    FreeAndNil(FFetchOptions);
    FreeAndNil(FFormatOptions);
    FreeAndNil(FUpdateOptions);
    FreeAndNil(FResourceOptions);
    DeleteCriticalSection(FCloseLock);
    inherited Destroy;
  finally
    ADPhysManagerObj := nil;
    EndWrite;
    FreeAndNil(FLock);
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager._Release: Integer;
begin
  Result := ADDecRef;
  if Result = 0 then
    Shutdown;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetFetchOptions: TADFetchOptions;
begin
  Result := FFetchOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetFormatOptions: TADFormatOptions;
begin
  Result := FFormatOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetResourceOptions: TADResourceOptions;
begin
  Result := FResourceOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetUpdateOptions: TADUpdateOptions;
begin
  Result := FUpdateOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetParentOptions(out AOpts: IADStanOptions): Boolean;
begin
  AOpts := nil;
  Result := False;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetOptions: IADStanOptions;
begin
  Result := Self;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CheckInactive;
begin
  if FState <> dmsInactive then
    ADException(Self, [S_AD_LPhys], er_AD_AccDrvMngrMB, ['Inactive']);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CheckActive;
begin
  if FState <> dmsActive then
    ADException(Self, [S_AD_LPhys], er_AD_AccDrvMngrMB, ['Active']);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CheckActiveOrStoping;
begin
  if not (FState in [dmsActive, dmsStoping, dmsTerminating]) then
    ADException(Self, [S_AD_LPhys], er_AD_AccDrvMngrMB, ['Active or Stoping']);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.BeginRead;
begin
  if FLock <> nil then
    FLock.BeginRead;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.EndRead;
begin
  if FLock <> nil then
    FLock.EndRead;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.BeginWrite: Boolean;
begin
{$IFDEF AnyDAC_D6Base}
  if FLock <> nil then
    Result := FLock.BeginWrite
  else
    Result := True;
{$ELSE}
  if FLock <> nil then
    FLock.BeginWrite;
  Result := True;
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.EndWrite;
begin
  if FLock <> nil then
    FLock.EndWrite;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.Open;
var
  oParentDef, oDef: IADStanDefinition;
  oDrvHost: TADPhysDriverHost;
  i: Integer;
  oWait: IADGUIxWaitCursor;
  sTool, sPack, sExt: String;
begin
  CheckInactive;
  ADCreateInterface(IADGUIxWaitCursor, oWait);
  oWait.StartWait;
  BeginWrite;
  try
    for i := 0 to GetDriverDefs.Count - 1 do begin
      oDef := GetDriverDefs.Items[i];
      oDrvHost := TADPhysDriverHost.Create(Self);
      oDrvHost.FDriverID := oDef.Name;
      oDrvHost.FBaseDriverID := oDef.AsString[C_AD_DrvBaseId];
      if oDrvHost.FBaseDriverID <> '' then begin
        if oDef.ParentDefinition = nil then begin
          oParentDef := GetDriverDefs.FindDefinition(oDrvHost.FBaseDriverID);
          if oParentDef <> nil then
            oDef.ParentDefinition := oParentDef;
        end;
      end
      else
        oDrvHost.FBaseDriverID := oDrvHost.FDriverID;
      sTool :=
{$IFDEF AnyDAC_FPC}
          'FPC'
{$ELSE}
  {$IFDEF AnyDAC_Delphi}
    {$IFDEF AnyDAC_D10}
          'D10'
    {$ELSE}
      {$IFDEF AnyDAC_D9}
          'D9'
      {$ELSE}
        {$IFDEF AnyDAC_D7}
          'D7'
        {$ELSE}
          {$IFDEF AnyDAC_D6}
          'D6'
          {$ELSE}
            {$IFDEF AnyDAC_D5}
          'D5'
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ELSE}
    {$IFDEF AnyDAC_D6}
          'Bcb5'
    {$ELSE}
      {$IFDEF AnyDAC_D5}
          'Bcb6'
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
      ;
      oDrvHost.FPackage := oDef.AsString[C_AD_DrvPackage + sTool];
      if oDrvHost.FPackage = '' then begin
        sPack := oDrvHost.FBaseDriverID;
        if sPack = S_AD_DBXId then
          sPack := S_AD_DBExpPack
        else if sPack = S_AD_OraId then
          sPack := S_AD_OraclPack;
        sExt :=
{$IFDEF AnyDAC_FPC}
          '.???' // ???FPC
{$ENDIF}
{$IFDEF AnyDAC_DELPHI}
          '.bpl'
{$ENDIF}
{$IFDEF AnyDAC_BCB}
          '.bpl'
{$ENDIF}
        ;
        oDrvHost.FPackage := S_AD_PhysPack + sPack + sTool + sExt;
      end;
      oDrvHost.FParams := oDef;
      if ModuleIsPackage then
        oDrvHost.FState := drsUnloaded
      else
        oDrvHost.FState := drsLoaded;
      FDriverHosts.Add(oDrvHost);
    end;
    FState := dmsActive;
    for i := 0 to FInactiveRegistrations.Count - 1 do
      RegisterPhysConnectionClass(TADPhysConnectionClass(FInactiveRegistrations.Items[i]));
  finally
    FInactiveRegistrations.Clear;
    EndWrite;
    oWait.StopWait;
  end;
  if FManagerThread = nil then begin
    FManagerThread := TADPhysManagerThread.Create(Self);
    FManagerThread.Timeout := 1000;
    FManagerThread.Active := True;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.InternalClose(ATerminate, AWaitForClose: Boolean);
var
  oDrvHost: TADPhysDriverHost;
  oConnHost: TADPhysConnectionHost;
  i: Integer;
  oWait: IADGUIxWaitCursor;
  lStop, lTimeOut, lFree: Boolean;
begin
  lStop := False;
  lFree := False;
  lTimeOut := False;
  if AWaitForClose then begin
    GClosedEvent := CreateEvent(nil, False, False, nil);
    ADCreateInterface(IADGUIxWaitCursor, oWait, False);
    if oWait <> nil then
      oWait.StartWait;
  end;
  try
    EnterCriticalSection(FCloseLock);
    BeginRead;
    try
      BeginWrite;
      try
        if ATerminate and (FState in [dmsStoping, dmsInactive]) then begin
          lFree := (FState = dmsInactive) and (FManagerThread = nil) and (RefCount = 0);
          FState := dmsTerminating;
        end
        else begin
          if FState <> dmsInactive then begin
            CheckActive;
            lStop := True;
          end;
          if ATerminate then
            FState := dmsTerminating
          else
            FState := dmsStoping;
        end;
      finally
        EndWrite;
      end;
      if lStop then begin
        for i := 0 to FConnHosts.Count - 1 do begin
          oConnHost := TADPhysConnectionHost(FConnHosts.Items[i]);
          if oConnHost.FPool <> nil then
            oConnHost.FPool.Close;
        end;
        if FState <> dmsTerminating then
          FInactiveRegistrations.Clear;
        for i := 0 to FDriverHosts.Count - 1 do begin
          oDrvHost := TADPhysDriverHost(FDriverHosts.Items[i]);
          if (FState <> dmsTerminating) and (oDrvHost.FConnClass <> nil) then
            FInactiveRegistrations.Add(oDrvHost.FConnClass);
          if oDrvHost.FState = drsActive then
            oDrvHost.StopDriver;
        end;
      end;
      if FManagerThread <> nil then
        FManagerThread.Ping
      else
        AWaitForClose := False;
    finally
      EndRead;
      LeaveCriticalSection(FCloseLock);
    end;
  finally
    if AWaitForClose then begin
      lTimeOut := WaitForSingleObject(GClosedEvent, C_AD_PhysManagerShutdownTimeout) = WAIT_TIMEOUT;
      CloseHandle(GClosedEvent);
      GClosedEvent := 0;
    end;
    if oWait <> nil then
      oWait.StopWait;
    if lTimeOut then
      ADException(nil, [S_AD_LPhys], er_AD_AccShutdownTO, []);
    if lFree then
      Destroy;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.Close(AWait: Boolean);
begin
  InternalClose(False, AWait);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.Shutdown;
begin
  InternalClose(True, True);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.Closed;
var
  i: Integer;
begin
  BeginWrite;
  try
    for i := 0 to FConnHosts.Count - 1 do
      TADPhysConnectionHost(FConnHosts.Items[i]).Free;
    FConnHosts.Clear;
    if FDriverDefs <> nil then
      FDriverDefs.Clear;
    if FConnectionDefs <> nil then
      FConnectionDefs.Clear;
    FState := dmsInactive;
  finally
    EndWrite;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.FindDriverHost(const ADriverID: String;
  AWrite: Boolean): TADPhysDriverHost;
var
  i: Integer;
begin
  BeginRead;
  try
    Result := nil;
    for i := 0 to FDriverHosts.Count - 1 do
      if ADCompareText(TADPhysDriverHost(FDriverHosts.Items[i]).FDriverID, ADriverID) = 0 then begin
        Result := TADPhysDriverHost(FDriverHosts.Items[i]);
        Break;
      end;
    if Result <> nil then
      if AWrite then
        Result.BeginWrite
      else
        Result.BeginRead;
  finally
    EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.DriverHostByID(const ADriverID: String;
  AMode: TADPhysFindObjMode; AWrite: Boolean): TADPhysDriverHost;
begin
  if ADriverID = '' then
    ADException(Self, [S_AD_LPhys], er_AD_AccSrvNotDefined, []);
  BeginRead;
  try
    case AMode of
    fomNone:
      ;
    fomMBActive:
      CheckActive;
    fomMBNotInactive:
      CheckActiveOrStoping;
    fomIfActive:
      if FState <> dmsActive then begin
        Result := nil;
        Exit;
      end;
    end;
    Result := FindDriverHost(ADriverID, AWrite);
    if Result = nil then
      ADException(Self, [S_AD_LPhys], er_AD_AccSrvNotFound, [ADriverID, ADriverID]);
  finally
    EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.IterateDriverHostsByBaseID(const ADriverID: String;
  AMode: TADPhysFindObjMode; var AHost: TADPhysDriverHost; AWrite: Boolean): Boolean;
var
  i: Integer;
begin
  BeginRead;
  try
    case AMode of
    fomNone:
      ;
    fomMBActive:
      CheckActive;
    fomMBNotInactive:
      CheckActiveOrStoping;
    fomIfActive:
      if FState <> dmsActive then begin
        Result := False;
        AHost := nil;
        Exit;
      end;
    end;
    Result := False;
    for i := FDriverHosts.IndexOf(AHost) + 1 to FDriverHosts.Count - 1 do
      if ADCompareText(TADPhysDriverHost(FDriverHosts.Items[i]).FBaseDriverID, ADriverID) = 0 then begin
        AHost := TADPhysDriverHost(FDriverHosts.Items[i]);
        Result := True;
        Break;
      end;
    if Result then
      if AWrite then
        AHost.BeginWrite
      else
        AHost.BeginRead
    else
      AHost := nil;
  finally
    EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.RegisterPhysConnectionClass(
  APhysConnClass: TADPhysConnectionClass);
var
  oDrvHost: TADPhysDriverHost;
  lFound: Boolean;
begin
  ASSERT(APhysConnClass <> nil);
  if FState <> dmsActive then begin
    FInactiveRegistrations.Add(APhysConnClass);
    Exit;
  end;
  lFound := False;
  oDrvHost := nil;
  while IterateDriverHostsByBaseID(APhysConnClass.GetDriverClass.GetDriverID,
                                   fomMBActive, oDrvHost, True) do
    try
      lFound := True;
      oDrvHost.RegisterPhysConnectionClass(APhysConnClass);
    finally
      oDrvHost.EndWrite;
    end;
  if not lFound then begin
    BeginWrite;
    try
      oDrvHost := TADPhysDriverHost.Create(Self);
      oDrvHost.FDriverID := APhysConnClass.GetDriverClass.GetDriverID;
      oDrvHost.FBaseDriverID := oDrvHost.FDriverID;
      oDrvHost.FState := drsLoaded;
      FDriverHosts.Add(oDrvHost);
      oDrvHost.RegisterPhysConnectionClass(APhysConnClass);
    finally
      EndWrite;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.UnRegisterPhysConnectionClass(
  APhysConnClass: TADPhysConnectionClass);
var
  oDrvHost: TADPhysDriverHost;
  lFound: Boolean;
begin
  ASSERT(APhysConnClass <> nil);
  if FState <> dmsActive then begin
    FInactiveRegistrations.Add(APhysConnClass);
    Exit;
  end;
  lFound := False;
  oDrvHost := nil;
  while IterateDriverHostsByBaseID(APhysConnClass.GetDriverClass.GetDriverID,
                                   fomMBNotInactive, oDrvHost, True) do
    try
      lFound := True;
      oDrvHost.UnRegisterPhysConnectionClass;
    finally
      oDrvHost.EndWrite;
    end;
  if not lFound then
    ADException(Self, [S_AD_LPhys], er_AD_AccSrvNotFound,
      [APhysConnClass.GetDriverClass.GetDriverID,
       APhysConnClass.GetDriverClass.GetDriverID]);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateDriver(const ADriverID: String;
  out ADrv: IADPhysDriver; AIntfRequired: Boolean);
const
  CFOMs: array[Boolean] of TADPhysFindObjMode = (fomIfActive, fomMBActive);
var
  oDrvHost: TADPhysDriverHost;
  lNeedWrite: Boolean;
begin
  oDrvHost := DriverHostByID(ADriverID, CFOMs[AIntfRequired], False);
  try
    if oDrvHost = nil then
      ADrv := nil
    else begin
      lNeedWrite := (oDrvHost.FState <> drsActive);
      if lNeedWrite then
        oDrvHost.BeginWrite;
      try
        oDrvHost.CreateDriver(Self, ADrv)
      finally
        if lNeedWrite then
          oDrvHost.EndWrite;
      end;
    end;
  finally
    oDrvHost.EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.ReleaseDriver(const ADriver: IADPhysDriver);
var
  oDrvHost: TADPhysDriverHost;
  lPing: Boolean;
begin
  ASSERT(ADriver <> nil);
  oDrvHost := DriverHostByID(ADriver.DriverID, fomMBNotInactive, True);
  try
    oDrvHost.FState := drsInactive;
    lPing := FState <> dmsActive;
    if not lPing then
      oDrvHost.FInactiveTime := GetTickCount();
  finally
    oDrvHost.EndWrite;
  end;
  if lPing then
    FManagerThread.Ping;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateConnection(const AConnectionDef: IADStanConnectionDef;
  out AConn: IADPhysConnection; AIntfRequired: Boolean);
var
  oConnHost: TADPhysConnectionHost;
  lSafe: Boolean;

  function FindConnHost(const AConnectionDef: IADStanConnectionDef): TADPhysConnectionHost;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to FConnHosts.Count - 1 do
      if TADPhysConnectionHost(FConnHosts.Items[i]).FConnectionDef = AConnectionDef then begin
        Result := TADPhysConnectionHost(FConnHosts.Items[i]);
        Break;
      end;
  end;

begin
  ASSERT(AConnectionDef <> nil);
  BeginRead;
  try
    if AIntfRequired then
      CheckActive
    else if FState <> dmsActive then begin
      AConn := nil;
      Exit;
    end;
    GetConnectionDefs.BeginRead;
    try
      oConnHost := FindConnHost(AConnectionDef);
      if oConnHost = nil then begin
        lSafe := BeginWrite;
        try
          if not lSafe then
            oConnHost := FindConnHost(AConnectionDef);
          if oConnHost = nil then begin
            oConnHost := TADPhysConnectionHost.Create(Self, AConnectionDef);
            FConnHosts.Add(oConnHost);
          end;
        finally
          EndWrite;
        end;
      end;
      oConnHost.CreateConnection(AConn);
    finally
      GetConnectionDefs.EndRead;
    end;
  finally
    EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysManager.GetConnDefFromConnDefName(
  const AConnDefName: String): IADStanConnectionDef;
begin
  if Pos('=', AConnDefName) <> 0 then begin
    Result := GetConnectionDefs.AddInternal as IADStanConnectionDef;
    Result.ParseString(AConnDefName);
  end
  else
    Result := GetConnectionDefs.ConnectionDefByName(AConnDefName);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateConnection(const AConDefName: String;
  out AConn: IADPhysConnection; AIntfRequired: Boolean);
begin
  BeginRead;
  try
    if AIntfRequired then
      CheckActive
    else if FState <> dmsActive then begin
      AConn := nil;
      Exit;
    end;
    CreateConnection(GetConnDefFromConnDefName(AConDefName), AConn, AIntfRequired);
  finally
    EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateMetadata(out AMeta: IADPhysManagerMetadata);
begin
  Supports(TObject(Self), IADPhysManagerMetadata, AMeta);
  ASSERT(Assigned(AMeta));
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateDefaultConnectionMetadata(
  out AConMeta: IADPhysConnectionMetadata);
begin
  AConMeta := TADPhysConnectionMetadata.Create(
    {$IFDEF AnyDAC_MONITOR} nil, {$ENDIF} nil) as IADPhysConnectionMetadata;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetDriverCount: Integer;
begin
  CheckActive;
  Result := FDriverHosts.Count;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetDriverID(Index: Integer): String;
begin
  CheckActive;
  Result := TADPhysDriverHost(FDriverHosts.Items[Index]).DriverID;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateDriverMetadata(const ADriverID: String;
  out AMeta: IADPhysDriverMetadata);
var
  oDrv: IADPhysDriver;
begin
  CreateDriver(ADriverID, oDrv);
  oDrv.CreateMetadata(AMeta);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetConnectionDefs: IADStanConnectionDefs;
begin
  if FConnectionDefs = nil then
    ADCreateInterface(IADStanConnectionDefs, FConnectionDefs);
  Result := FConnectionDefs;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetDriverDefs: IADStanDefinitions;
begin
  if FDriverDefs = nil then begin
    ADCreateInterface(IADStanDefinitions, FDriverDefs);
    FDriverDefs.Storage.DefaultFileName := S_AD_DefDrvFileName;
    FDriverDefs.Storage.GlobalFileName := ADReadRegValue(S_AD_DrvValName);
  end;
  Result := FDriverDefs;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetState: TADPhysManagerState;
begin
  Result := FState;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetDesignTime: Boolean;
begin
  Result := FDesignTime;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.SetDesignTime(AValue: Boolean);
begin
  FDesignTime := AValue;
end;

{ ----------------------------------------------------------------------------- }
// IADStanObject

function TADPhysManager.GetName: TComponentName;
begin
  Result := ClassName;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetParent: IADStanObject;
begin
  Result := nil;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.AfterReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.BeforeReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysManagerThread                                                          }
{ ----------------------------------------------------------------------------- }
constructor TADPhysManagerThread.Create(AManager: TADPhysManager);
begin
  inherited Create;
  FManager := AManager;
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysManagerThread.Destroy;
begin
  FManager := nil;
  inherited Destroy;
  SignalClosed;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManagerThread.SignalClosed;
begin
  if GClosedEvent <> 0 then
    SetEvent(GClosedEvent);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManagerThread.DoIdle;
var
  i: Integer;
  oDrvHost: TADPhysDriverHost;
begin
  if FManager = nil then
    Exit;
  EnterCriticalSection(FManager.FCloseLock);
  FManager.BeginRead;
  try
    for i := FManager.FDriverHosts.Count - 1 downto 0 do begin
      oDrvHost := TADPhysDriverHost(FManager.FDriverHosts.Items[i]);
      if (oDrvHost.FState in [drsUnloaded, drsInactive, drsRegistered, drsLoaded]) and
           (FManager.FState in [dmsStoping, dmsTerminating]) or
         (oDrvHost.FState = drsInactive) and
           ADTimeout(oDrvHost.FInactiveTime, FManager.FInactiveTimeout) then begin
        oDrvHost.BeginWrite;
        try
          if oDrvHost.FState = drsInactive then
            oDrvHost.FinalizeDriver;
          if FManager.FState in [dmsStoping, dmsTerminating] then begin
            if oDrvHost.FState = drsRegistered then
              oDrvHost.UnRegisterPhysConnectionClass;
            if ModuleIsPackage and (oDrvHost.FState = drsLoaded) then
              oDrvHost.UnloadDriver;
          end;
        finally
          if FManager.FState in [dmsStoping, dmsTerminating] then begin
            FManager.FDriverHosts.Remove(oDrvHost);
            oDrvHost.Free;
          end
          else
            oDrvHost.EndWrite;
        end;
      end;
    end;
    if (FManager.FState in [dmsStoping, dmsTerminating]) and
       (FManager.FDriverHosts.Count = 0) then begin
      if FManager.FState = dmsTerminating then begin
        FManager.FManagerThread := nil;
        FManager.Free;
        FManager := nil;
        Terminate;
      end
      else begin
        FManager.Closed;
        SignalClosed;
      end;
    end;
  finally
    if FManager <> nil then begin
      FManager.EndRead;
      LeaveCriticalSection(FManager.FCloseLock);
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysDriverHost                                                             }
{ ----------------------------------------------------------------------------- }
constructor TADPhysDriverHost.Create(AManager: TADPhysManager);
begin
  inherited Create;
  FManager := AManager;
  FLock := TADMREWSynchronizer.Create;
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysDriverHost.Destroy;
begin
  FreeAndNil(FLock);
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverHost.GetRefCount: Integer;
begin
  BeginRead;
  try
    if FDriver <> nil then
      Result := FDriver.RefCount
    else
      Result := 0;
  finally
    EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.BeginRead;
begin
  FLock.BeginRead;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.BeginWrite;
begin
  FLock.BeginWrite;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.EndRead;
begin
  if FLock <> nil then
    FLock.EndRead;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.EndWrite;
begin
  if FLock <> nil then
    FLock.EndWrite;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.CantOperate(const AOper: String);
begin
  ADException(FManager, [S_AD_LPhys], er_AD_AccCantOperDrv, [AOper]);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.UnloadDriver;
begin
  if not ModuleIsPackage or (FState <> drsLoaded) then
    CantOperate('unload driver');
  try
    if FhPackage <> 0 then
      try
        UnloadPackage(FhPackage);
      except
        // no exceptions visible
      end;
  finally
    FhPackage := 0;
    FState := drsUnloaded;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.LoadDriver;
begin
  if FState <> drsUnloaded then
    CantOperate('load driver');
  if FPackage = '' then
    ADException(FManager, [S_AD_LPhys], er_AD_AccDrvPackEmpty, []);
  FhPackage := LoadPackage(FPackage);
  if FState = drsUnloaded then
    FState := drsLoaded;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.RegisterPhysConnectionClass(
  APhysConnClass: TADPhysConnectionClass);
begin
  if not (FState in [drsUnloaded, drsLoaded]) then
    CantOperate('register driver');
  FDrvClass := APhysConnClass.GetDriverClass;
  FConnClass := APhysConnClass;
  FState := drsRegistered;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.UnRegisterPhysConnectionClass;
begin
  if FState = drsInactive then
    FinalizeDriver;
  if FState <> drsRegistered then
    CantOperate('unregister driver');
  FDrvClass := nil;
  FConnClass := nil;
  FState := drsLoaded;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.StopDriver;
begin
  if FState <> drsActive then
    CantOperate('stop driver');
  FState := drsStoping;
  FDriver.ForceDisconnect;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.InitializeDriver(AManager: TADPhysManager);
begin
  if FState <> drsRegistered then
    CantOperate('initialize driver');
  FState := drsInitializing;
  try
    FDriverObj := FDrvClass.Create(Self);
    FDriver := FDriverObj as IADPhysDriver;
    FState := drsActive;
  except
    FDriverObj := nil;
    FDriver := nil;
    FState := drsRegistered;
    raise;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.FinalizeDriver;
begin
  if FState <> drsInactive then
    CantOperate('finalize driver');
  FState := drsFinalizing;
  try
    try
      FDriverObj := nil;
      FDriver := nil;
    except
      // no exceptions visible
    end;
  finally
    FState := drsRegistered;
    FInactiveTime := 0;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.CreateDriver(AManager: TADPhysManager;
  out ADrv: IADPhysDriver);

  procedure BadState;
  var
    s: String;
  begin
    if FState = drsLoaded then begin
      if ModuleIsPackage then
        s := S_AD_PhysPackNotLoaded
      else
        s := S_AD_PhysNotLinked;
      ADException(Self, [S_AD_LPhys], er_AD_AccDrvIsNotReg,
        [FDriverID, Format(s, [FBaseDriverID])]);
    end
    else
      CantOperate('create driver interface');
  end;

begin
  if FState = drsUnloaded then
    LoadDriver;
  if not (FState in [drsRegistered, drsActive, drsInactive]) then
    BadState;
  if FState = drsRegistered then
    InitializeDriver(AManager);
  if FState = drsActive then
    ADrv := FDriver
  else if FState = drsInactive then begin
    FState := drsActive;
    ADrv := FDriver;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverHost.GetVendorParams(var AHome, ALib: String);
begin
  if Params <> nil then begin
    AHome := Params.AsString[S_AD_ConnParam_Common_VendorHome];
    ALib := Params.AsString[S_AD_ConnParam_Common_VendorLib];
  end
  else begin
    AHome := '';
    ALib := '';
  end;
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysDriver                                                                 }
{ ----------------------------------------------------------------------------- }
constructor TADPhysDriver.Create(AInfo: TADPhysDriverHost);
begin
  inherited Create;
  FDrvHost := AInfo;
  FConnections := TList.Create;
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysDriver.Destroy;
begin
  FreeAndNil(FConnections);
  FDrvHost := nil;
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
class function TADPhysDriver.GetDriverID: String;
begin
  ASSERT(False);
  Result := '';
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetDriverIntfID: String;
begin
  Result := FDrvHost.DriverID;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetDescription: String;
begin
  Result := '';
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetRefCount: Integer;
begin
  Result := FRefCount;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetState: TADPhysDriverState;
begin
  Result := FDrvHost.FState;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result <= 1 then
    if Result = 1 then
      FDrvHost.FManager.ReleaseDriver(Self)
    else if Result = 0 then
      Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetConnectionCount: Integer;
begin
  FDrvHost.BeginRead;
  try
    Result := FConnections.Count;
  finally
    FDrvHost.EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetConnections(AIndex: Integer): IADPhysConnection;
begin
  FDrvHost.BeginRead;
  try
    Result := TADPhysConnection(FConnections.Items[AIndex]) as IADPhysConnection;
  finally
    FDrvHost.EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.ForceDisconnect;
var
  i: Integer;
begin
  FDrvHost.BeginRead;
  try
    for i := FConnections.Count - 1 downto 0 do
      TADPhysConnection(FConnections.Items[i]).ForceDisconnect;
  finally
    FDrvHost.EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.CreateMetadata(out ADrvMeta: IADPhysDriverMetadata);
begin
  Supports(TObject(Self), IADPhysDriverMetadata, ADrvMeta);
  ASSERT(Assigned(ADrvMeta));
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.CreateConnectionWizard(
  out AWizard: IADPhysDriverConnectionWizard);
begin
  Supports(TObject(Self), IADPhysDriverConnectionWizard, AWizard);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := 7;
  if (AKeys <> nil) and
     (ADCompareText(AKeys.Values[S_AD_ConnParam_Common_Pooled], S_AD_True) = 0) then
    Result := Result + 6;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.GetConnParams(AKeys: TStrings; Index: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  i: Integer;
begin
  ALoginIndex := -1;
  ADefVal := '';
  case Index of
  0:
    begin
      AName := S_AD_ConnParam_Common_DriverID;
      AType := '';
      for i := 0 to FDrvHost.FManager.FDriverHosts.Count - 1 do begin
        if AType <> '' then
          AType := AType + ';';
        AType := AType + TADPhysDriverHost(FDrvHost.FManager.FDriverHosts.Items[i]).DriverID;
      end;
      ADefVal := GetDriverIntfID;
      ACaption := AName;
    end;
  1:
    begin
      AName := S_AD_ConnParam_Common_Pooled;
      AType := '@L';
      ADefVal := S_AD_False;
      ACaption := AName;
    end;
  2:
    begin
      AName := S_AD_ConnParam_Common_Database;
      AType := '@S';
      ACaption := AName;
    end;
  3:
    begin
      AName := S_AD_ConnParam_Common_UserName;
      AType := '@S';
      ALoginIndex := 0;
      ACaption := S_AD_ConnParam_Common_BDEStyleUserName;
    end;
  4:
    begin
      AName := S_AD_ConnParam_Common_Password;
      AType := '@S';
      ALoginIndex := 1;
      ACaption := AName;
    end;
  5:
    begin
      AName := S_AD_ConnParam_Common_MonitorBy;
      AType := S_AD_MoniFlatFile + ';' + S_AD_MoniIndy + ';' + S_AD_MoniCustom;
      ADefVal := '';
      ACaption := AName;
    end;
  6:
    begin
      AName := S_AD_ConnParam_Common_AllowReconnect;
      AType := '@L';
      ADefVal := S_AD_False;
    end;
  else
    if (AKeys <> nil) and
       (ADCompareText(AKeys.Values[S_AD_ConnParam_Common_Pooled], S_AD_True) = 0) then begin
      AType := '@I';
      case Index of
      7:
        begin
          AName := S_AD_PoolParam_WorkerTimeout;
          ADefVal := IntToStr(C_AD_WorkerTimeout);
        end;
      8:
        begin
          AName := S_AD_PoolParam_MaxWaitForItemTime;
          ADefVal := IntToStr(C_AD_MaxWaitForItemTime);
        end;
      9:
        begin
          AName := S_AD_PoolParam_GCLatencyPeriod;
          ADefVal := IntToStr(C_AD_GCLatencyPeriod);
        end;
      10:
        begin
          AName := S_AD_PoolParam_MaximumItems;
          ADefVal := IntToStr(C_AD_MaximumItems);
        end;
      11:
        begin
          AName := S_AD_PoolParam_OptimalItems;
          ADefVal := IntToStr(C_AD_OptimalItems);
        end;
      12:
        begin
          AName := S_AD_PoolParam_PoolGrowDelta;
          ADefVal := IntToStr(C_AD_PoolGrowDelta);
        end;
      end;
      ACaption := AName;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
// IADStanObject

function TADPhysDriver.GetName: TComponentName;
begin
  Result := GetDriverID;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetParent: IADStanObject;
begin
  Supports(ADPhysManager, IADStanObject, Result);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.AfterReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.BeforeReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

(*
{ ----------------------------------------------------------------------------- }
{ TADPhysDriverLinkBase                                                         }
{ ----------------------------------------------------------------------------- }
class function TADPhysDriverLinkBase.GetDriverID: String;
begin
  Result := '';
end;
*)
{ ----------------------------------------------------------------------------- }
{ TADPhysConnectionHost                                                         }
{ ----------------------------------------------------------------------------- }
constructor TADPhysConnectionHost.Create(AManager: TADPhysManager;
  const AConnectionDef: IADStanConnectionDef);
begin
  inherited Create;
  FManager := AManager;
  FPassCode := Random($7FFFFFFF);
  FConnectionDef := AConnectionDef;
  if FConnectionDef.Pooled and not FManager.GetDesignTime then begin
    if FConnectionDef.Style <> atInternal then
      FConnectionDef.ToggleUpdates(FPassCode, [auModify, auDelete]);
    ADCreateInterface(IADStanObjectFactory, FPool);
    FPool.Open(Self, FConnectionDef);
  end
  else
    if FConnectionDef.Style <> atInternal then
      FConnectionDef.ToggleUpdates(FPassCode, [auDelete]);
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysConnectionHost.Destroy;
begin
  ASSERT(FConnections = 0);
  if FConnectionDef.Style = atInternal then begin
    if FConnectionDef.ParentDefinition <> nil then
      FConnectionDef.ParentDefinition := nil;
  end
  else
    FConnectionDef.ToggleUpdates(FPassCode, []);
  FPassCode := 0;
  FManager := nil;
  FConnectionDef := nil;
  FPool := nil;
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnectionHost._AddRef: Integer;
begin
  Result := -1;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnectionHost._Release: Integer;
begin
  Result := -1;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnectionHost.AddConn;
begin
  if InterlockedIncrement(FConnections) = 1 then
    if FConnectionDef.Style <> atInternal then
      FConnectionDef.ToggleUpdates(FPassCode, [auModify, auDelete]);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnectionHost.RemConn;
begin
  if InterlockedDecrement(FConnections) = 0 then
    if FConnectionDef.Style <> atInternal then
      FConnectionDef.ToggleUpdates(FPassCode, [auDelete]);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnectionHost.InternalCreateConnection(out AConn: IADPhysConnection);
var
  oDrvHost: TADPhysDriverHost;
  oDriver: IADPhysDriver;
  lNeedWrite: Boolean;
begin
  oDrvHost := FManager.DriverHostByID(FConnectionDef.DriverID, fomMBActive, False);
  try
    lNeedWrite := (oDrvHost.FState <> drsActive);
    if lNeedWrite then
      oDrvHost.BeginWrite;
    try
      oDrvHost.CreateDriver(FManager, oDriver);
    finally
      if lNeedWrite then
        oDrvHost.EndWrite;
    end;
    AConn := oDrvHost.FConnClass.Create(oDrvHost.FDriverObj, oDriver, Self) as IADPhysConnection;
  finally
    oDrvHost.EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnectionHost.GetObjectKindName: TComponentName;
begin
  Result := 'connection';
  if (FConnectionDef <> nil) and (FConnectionDef.Name <> '') then
    Result := Result + ' ' + FConnectionDef.Name;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnectionHost.CreateObject(out AObject: IADStanObject);
var
  oConn: IADPhysConnection;
begin
  if FManager.FState <> dmsActive then begin
    AObject := nil;
    Exit;
  end;
  try
    InternalCreateConnection(oConn);
  except
    AObject := nil;
    Exit;
  end;
  AObject := oConn as IADStanObject;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnectionHost.CreateConnection(out AConn: IADPhysConnection);
var
  oObj: IADStanObject;
begin
  if FConnectionDef.Pooled and not FManager.GetDesignTime then begin
    FPool.Acquire(oObj);
    Supports(oObj, IADPhysConnection, AConn);
  end
  else
    InternalCreateConnection(AConn);
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysConnection                                                             }
{ ----------------------------------------------------------------------------- }
constructor TADPhysConnection.Create(ADriverObj: TADPhysDriver;
  const ADriver: IADPhysDriver; AConnHost: TADPhysConnectionHost);
var
  oDrvHost: TADPhysDriverHost;
begin
  FDriverObj := ADriverObj;
  oDrvHost := ADriverObj.FDrvHost;
  oDrvHost.BeginRead;
  try
    FMoniAdapterHelper := TADMoniAdapterHelper.Create(Self, FDriverObj);
{$IFDEF AnyDAC_MONITOR}
    if AConnHost.ConnectionDef.MonitorBy <> '' then begin
      ADPhysCreateMoniClient(AConnHost.ConnectionDef, FMonitor);
      if FMonitor <> nil then begin
        FMonitor.Tracing := True;
        FTracing := FMonitor.Tracing;
        TracingChanged;
      end;
    end;
    if GetTracing then
      FMonitor.Notify(ekLiveCycle, esStart, Self, 'Create',
        ['ConnectionDef', AConnHost.ConnectionDef.Name]);
    try
{$ENDIF}
      inherited Create;
      FState := csDisconnected;
      FPoolManaged := (AConnHost.FPool <> nil);
      FLoginPrompt := (AConnHost.FPool = nil);
      oDrvHost.BeginWrite;
      try
        FDriverObj.FConnections.Add(Self);
      finally
        oDrvHost.EndWrite;
      end;
      FDriver := ADriver;
      FConnHost := AConnHost;
      FConnHost.AddConn;
      if FConnHost.FConnectionDef.Style <> atInternal then begin
        ADCreateInterface(IADStanConnectionDef, FInternalConnectionDef);
        FInternalConnectionDef.ParentDefinition := FConnHost.ConnectionDef;
      end;
      FLock := TADMREWSynchronizer.Create;
      FCommandList := TList.Create;
      FSavepoints := TStringList.Create;
      SetTxOptions(nil);
      SetOptions(nil);
      GetConnectionDef.ReadOptions(FFormatOptions, FUpdateOptions,
        FFetchOptions, FResourceOptions);
{$IFDEF AnyDAC_MONITOR}
    finally
      if GetTracing then
        FMonitor.Notify(ekLiveCycle, esEnd, Self, 'Create',
          ['ConnectionDef', AConnHost.ConnectionDef.Name]);
    end;
{$ENDIF}
  finally
    oDrvHost.EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysConnection.Destroy;
var
  oDrvHost: TADPhysDriverHost;
begin
  FRefCount := $3FFFFFFF;
  oDrvHost := FDriverObj.FDrvHost;
  oDrvHost.BeginRead;
  try
{$IFDEF AnyDAC_MONITOR}
    if GetTracing then
      FMonitor.Notify(ekLiveCycle, esStart, Self, 'Destroy',
        ['ConnectionDef', GetConnectionDef.Name]);
{$ENDIF}
    try
      if FCommandList <> nil then
        ForceDisconnect;
      oDrvHost.BeginWrite;
      try
        FDriverObj.FConnections.Remove(Self);
      finally
        oDrvHost.EndWrite;
      end;
      SetErrorHandler(nil);
      SetLogin(nil);
      FreeAndNil(FMetadata);
      FreeAndNil(FSavepoints);
      FreeAndNil(FCommandList);
      FExternalTxOptions := nil;
      FreeAndNil(FTxOptions);
      FExternalOptions := nil;
      FreeAndNil(FFetchOptions);
      FreeAndNil(FFormatOptions);
      FreeAndNil(FUpdateOptions);
      FreeAndNil(FResourceOptions);
      FreeAndNil(FLock);
      inherited Destroy;
    finally
{$IFDEF AnyDAC_MONITOR}
      if GetTracing then
        FMonitor.Notify(ekLiveCycle, esEnd, Self, 'Destroy',
          ['ConDef', GetConnectionDef.Name]);
{$ENDIF}
      FMoniAdapterHelper.Free;
      FMoniAdapterHelper := nil;
{$IFDEF AnyDAC_MONITOR}
      SetTracing(False);
      FMonitor := nil;
{$ENDIF}
    end;
  finally
    oDrvHost.EndRead;
    if FConnHost <> nil then
      FConnHost.RemConn;
    FConnHost := nil;
    FInternalConnectionDef := nil;
    FDriverObj := nil;
    FDriver := nil;
    FRefCount := 0;
  end;
end;

{ ----------------------------------------------------------------------------- }
class function TADPhysConnection.GetDriverClass: TADPhysDriverClass;
begin
  ASSERT(False);
  Result := nil;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection._AddRef: Integer;
begin
  Result := inherited _AddRef;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection._Release: Integer;
var
  oPoolItem: IADStanObject;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result <= 1 then begin
    if (Result = 1) and (FConnHost <> nil) and (FConnHost.FPool <> nil) then begin
      FLock.BeginWrite;
      try
        if not FPoolManaged then begin
          Supports(TObject(Self), IADStanObject, oPoolItem);
          FConnHost.FPool.Release(oPoolItem);
          InterlockedDecrement(FRefCount);
          Pointer(oPoolItem) := nil;
        end;
      finally
        FLock.EndWrite;
      end;
    end
    else if Result = 0 then
      Destroy;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetState: TADPhysConnectionState;
begin
  Result := FState;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
// Tracing

procedure ADPhysCreateMoniClient(const AParams: IADStanDefinition;
  out AMonitor: IADMoniClient);
var
  s: String;
  oRemClnt: IADMoniRemoteClient;
  oFFClnt: IADMoniFlatFileClient;
  oCClnt: IADMoniCustomClient;
begin
  ASSERT(AParams <> nil);
  AMonitor := nil;
  if not FADMoniEnabled or
     AParams.HasValue(S_AD_MoniInIDE) and not AParams.AsBoolean[S_AD_MoniInIDE] and
      ADIsDesignTime then
    Exit;
  s := AParams.AsString[S_AD_ConnParam_Common_MonitorBy];
  if s = '' then
    Exit
  else if CompareText(s, S_AD_MoniIndy) = 0 then begin
    ADCreateInterface(IADMoniRemoteClient, oRemClnt);
    AMonitor := oRemClnt as IADMoniClient;
  end
  else if CompareText(s, S_AD_MoniFlatFile) = 0 then begin
    ADCreateInterface(IADMoniFlatFileClient, oFFClnt);
    AMonitor := oFFClnt as IADMoniClient;
  end
  else if CompareText(s, S_AD_MoniCustom) = 0 then begin
    ADCreateInterface(IADMoniCustomClient, oCClnt);
    AMonitor := oCClnt as IADMoniClient;
  end
  else
    ASSERT(False);
  if (AMonitor <> nil) and not AMonitor.Tracing and (AParams <> nil) then
    AMonitor.SetupFromDefinition(AParams);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.Trace(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; const AMsg: String; const AArgs: array of const);
begin
  if GetTracing then
    FMonitor.Notify(AKind, AStep, Self, AMsg, AArgs);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetTracing: Boolean;
begin
  Result := FTracing and (FMonitor <> nil) and FMonitor.Tracing;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SetTracing(AValue: Boolean);
var
  lPrevTracing: Boolean;
begin
  lPrevTracing := GetTracing;
  if AValue <> FTracing then begin
    FTracing := AValue;
    if lPrevTracing <> GetTracing then
      TracingChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.TracingChanged;
begin
  InternalTracingChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.InternalTracingChanged;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetMonitor: IADMoniClient;
begin
  Result := FMonitor;
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
// Get interfaces

function TADPhysConnection.GetRefCount: Integer;
begin
  Result := FRefCount;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetDriver: IADPhysDriver;
begin
  Result := FDriver;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CreateCommandGenerator(out AGen: IADPhysCommandGenerator;
  const ACommand: IADPhysCommand);
begin
  AGen := InternalCreateCommandGenerator(ACommand) as IADPhysCommandGenerator;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CreateMetadata(out AConnMeta: IADPhysConnectionMetadata);
begin
  if FMetadata = nil then
    FMetadata := InternalCreateMetadata;
  Supports(FMetadata, IADPhysConnectionMetadata, AConnMeta);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetCliObj: TObject;
begin
  Result := nil;
end;

{ ----------------------------------------------------------------------------- }
// Options interface

function TADPhysConnection.GetFetchOptions: TADFetchOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.FetchOptions
  else
    Result := FFetchOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetFormatOptions: TADFormatOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.FormatOptions
  else
    Result := FFormatOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetUpdateOptions: TADUpdateOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.UpdateOptions
  else
    Result := FUpdateOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetResourceOptions: TADResourceOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.ResourceOptions
  else
    Result := FResourceOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetParentOptions(out AOpts: IADStanOptions): Boolean;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.GetParentOptions(AOpts)
  else if FConnHost.Manager <> nil then begin
    AOpts := FConnHost.Manager.GetOptions;
    Result := (AOpts <> nil);
  end
  else begin
    AOpts := nil;
    Result := False;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetOptions: IADStanOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions
  else
    Result := Self;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.SetOptions(const AValue: IADStanOptions);
begin
  if (FExternalOptions <> AValue) or (FMetadata = nil) then begin
    FExternalOptions := AValue;
    if FExternalOptions = nil then begin
      FFetchOptions := TADFetchOptions.Create(Self);
      FFormatOptions := TADFormatOptions.Create(Self);
      FUpdateOptions := TADUpdateOptions.Create(Self);
      FResourceOptions := TADTopResourceOptions.Create(Self);
    end
    else begin
      FreeAndNil(FFetchOptions);
      FreeAndNil(FFormatOptions);
      FreeAndNil(FUpdateOptions);
      FreeAndNil(FResourceOptions);
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetConnectionDef: IADStanConnectionDef;
begin
  if FInternalConnectionDef <> nil then
    Result := FInternalConnectionDef
  else
    Result := FConnHost.ConnectionDef;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetMessages: EADDBEngineException;
begin
  Result := nil;
end;

{ ----------------------------------------------------------------------------- }
// Transactions

function TADPhysConnection.GetTxIsActive: Boolean;
begin
  Result := FSavepoints.Count > 0;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetTxSerialID: LongWord;
begin
  Result := FTxSerialID;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetTxOptions: TADTxOptions;
begin
  if FExternalTxOptions <> nil then
    Result := FExternalTxOptions
  else
    Result := FTxOptions;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.SetTxOptions(const AValue: TADTxOptions);
begin
  if (FExternalTxOptions <> AValue) or (FMetadata = nil) then begin;
    FExternalTxOptions := AValue;
    if FExternalTxOptions = nil then
      FTxOptions := TADTxOptions.Create
    else
      FreeAndNil(FTxOptions);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetUniqueTXID: LongWord;
begin
  Result := Random(MAXINT);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetLastTXID: LongWord;
var
  i: Integer;
begin
  Result := 0;
  if FSavepoints.Count > 0 then
    for i := FSavepoints.Count - 1 downto 0 do
      if FSavepoints[i][1] in ['0' .. '9'] then begin
        Result := StrToInt(FSavepoints[i]);
        Break;
      end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.TxBegin: LongWord;
var
  s: String;
  iTxID: LongWord;
  oMeta: IADPhysConnectionMetadata;
  oWait: IADGUIxWaitCursor;
begin
{$IFDEF AnyDAC_MONITOR}
  Trace(ekConnTransact, esStart, 'TxBegin', ['ConnectionDef', GetConnectionDef.Name]);
  try
{$ENDIF}
    CheckActive;
    CreateMetadata(oMeta);
    if not oMeta.TxSupported then
      ADCapabilityNotSupported(Self, [S_AD_LPhys]);
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    FLock.BeginWrite;
    try
      if (FSavepoints.Count = 0) or oMeta.TxNested then begin
        UpdateTx;
        iTxID := GetUniqueTXID;
        s := IntToStr(iTxID);
        InternalTxBegin(iTxID);
      end
      else begin
        if not oMeta.TxSavepoints then
          ADCapabilityNotSupported(Self, [S_AD_LPhys]);
        s := C_AD_SysSavepointPrefix + IntToStr(FSavepoints.Count);
        InternalTxSetSavepoint(s);
      end;
      Inc(FTxSerialID);
      Result := FTxSerialID;
      FSavepoints.Add(s);
    finally
      FLock.EndWrite;
      oWait.StopWait;
    end;
{$IFDEF AnyDAC_MONITOR}
    UpdateMonitor;
  finally
    Trace(ekConnTransact, esEnd, 'TxBegin', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.InternalTxCommitSavepoint(const AName: String);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.TxCommit;
var
  oMeta: IADPhysConnectionMetadata;
  oWait: IADGUIxWaitCursor;
  s: String;
begin
{$IFDEF AnyDAC_MONITOR}
  Trace(ekConnTransact, esStart, 'TxCommit', ['ConnectionDef', GetConnectionDef.Name]);
  try
{$ENDIF}
    CheckActive(True);
    CreateMetadata(oMeta);
    if not oMeta.TxSupported then
      ADCapabilityNotSupported(Self, [S_AD_LPhys]);
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    FLock.BeginWrite;
    try
      if not GetTxIsActive then
        ADException(Self, [S_AD_LPhys], er_AD_AccTxMBActive, []);
      try
        if (FSavepoints.Count = 1) or (FSavepoints.Count > 1) and oMeta.TxNested then
          InternalTxCommit(GetLastTXID)
        else begin
          s := C_AD_SysSavepointPrefix + IntToStr(FSavepoints.Count - 1);
          InternalTxCommitSavepoint(s);
        end;
      finally
        FSavepoints.Delete(FSavepoints.Count - 1);
      end;
    finally
      FLock.EndWrite;
      oWait.StopWait;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekConnTransact, esEnd, 'TxCommit', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.TxRollback;
var
  oMeta: IADPhysConnectionMetadata;
  oWait: IADGUIxWaitCursor;
begin
{$IFDEF AnyDAC_MONITOR}
  Trace(ekConnTransact, esStart, 'TxRollback', ['ConnectionDef', GetConnectionDef.Name]);
  try
{$ENDIF}
    CheckActive(True);
    CreateMetadata(oMeta);
    if not oMeta.TxSupported then
      ADCapabilityNotSupported(Self, [S_AD_LPhys]);
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    FLock.BeginWrite;
    try
      if not GetTxIsActive then
        ADException(Self, [S_AD_LPhys], er_AD_AccTxMBActive, []);
      try
        if (FSavepoints.Count = 1) or (FSavepoints.Count > 1) and oMeta.TxNested then
          InternalTxRollback(GetLastTXID)
        else
          InternalTxRollbackToSavepoint(FSavepoints[FSavepoints.Count - 1]);
      finally
        FSavepoints.Delete(FSavepoints.Count - 1);
      end;
    finally
      FLock.EndWrite;
      oWait.StopWait;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekConnTransact, esEnd, 'TxRollback', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.PerformAutoCommit(APhase: TADPhysAutoCommitPhase);
var
  oMeta: IADPhysConnectionMetadata;
begin
  CreateMetadata(oMeta);
  if oMeta.TxSupported then
    if oMeta.TxAutoCommit then begin
      if (APhase = cpBeforeCmd) and not GetTxIsActive then
        UpdateTx;
    end
    else begin
      if GetTxOptions.AutoCommit then begin
        FLock.BeginWrite;
        try
          case APhase of
          cpBeforeCmd:
            if not GetTxIsActive then begin
              TxBegin;
              FTxIDAutoCommit := GetLastTXID;
            end
            else
              FTxIDAutoCommit := 0;
          cpAfterCmdSucc:
            if FTxIDAutoCommit = GetLastTXID then
              TxCommit;
          cpAfterCmdFail:
            if FTxIDAutoCommit = GetLastTXID then
              TxRollback;
          end;
        finally
          FLock.EndWrite;
        end;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.InternalTxChanged;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.UpdateTx;
var
  oWait: IADGUIxWaitCursor;
begin
  if GetTxOptions.Changed <> [] then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    FLock.BeginWrite;
    try
      InternalTxChanged;
      GetTxOptions.ClearChanged;
    finally
      FLock.EndWrite;
      oWait.StopWait;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
// Commands

function TADPhysConnection.GetCommandCount: Integer;
begin
  FLock.BeginRead;
  try
    Result := FCommandList.Count;
  finally
    FLock.EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetCommands(AIndex: Integer): IADPhysCommand;
begin
  FLock.BeginRead;
  try
    Result := TADPhysCommand(FCommandList[AIndex]) as IADPhysCommand;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.CreateCommand(out ACmd: IADPhysCommand);
var
  oCmd: TADPhysCommand;
begin
{$IFDEF AnyDAC_MONITOR}
  Trace(ekLiveCycle, esStart, 'CreateCommand', ['ConnectionDef', GetConnectionDef.Name]);
  try
{$ENDIF}
    oCmd := InternalCreateCommand;
    oCmd.SetConnectionObj(Self);
    FLock.BeginWrite;
    try
      FCommandList.Add(oCmd);
    finally
      FLock.EndWrite;
    end;
    ACmd := oCmd as IADPhysCommand;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekLiveCycle, esEnd, 'CreateCommand', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.CreateMetaInfoCommand(out AMetaCmd: IADPhysMetaInfoCommand);
var
  oIntf: IADPhysCommand;
begin
  CreateCommand(oIntf);
  AMetaCmd := oIntf as IADPhysMetaInfoCommand;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.RemoveCommand(ACommand: TADPhysCommand);
begin
  try
    FLock.BeginWrite;
    try
      ACommand.Disconnect;
      FCommandList.Remove(ACommand);
    finally
      FLock.EndWrite;
    end;
  finally
    ACommand.FConnectionObj := nil;
    ACommand.FConnection := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.InternalOverrideNameByCommand(
  var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand);
var
  oMetaInfo: IADPhysMetaInfoCommand;
  oConnMeta: IADPhysConnectionMetadata;
  lMetaInfo: Boolean;
begin
  with AParsedName, ACommand do begin
    lMetaInfo := Supports(ACommand, IADPhysMetaInfoCommand, oMetaInfo)
      and (oMetaInfo.MetaInfoKind <> daADPhysIntf.mkNone);
    CreateMetadata(oConnMeta);
    if (FCatalog = '') and (npCatalog in oConnMeta.NameParts) then begin
      FCatalog := FDefaultCatalogName;
      if (FCatalog = '') and lMetaInfo then
        FCatalog := GetConnectionDef.ExpandedDatabase;
    end;
    if (FSchema = '') and (npSchema in oConnMeta.NameParts) then begin
      FSchema := FDefaultSchemaName;
      if (FSchema = '') and lMetaInfo then begin
        if (oMetaInfo.ObjectScopes = [osMy]) and (oConnMeta.Kind <> mkMSSQL) then
          FSchema := GetConnectionDef.AsString[S_AD_ConnParam_Common_UserName];
      end;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
// Exception handling

function TADPhysConnection.GetErrorHandler: IADStanErrorHandler;
begin
  Result := FErrorHandler;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.SetErrorHandler(const AValue: IADStanErrorHandler);
begin
  FErrorHandler := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
begin
  if Assigned(GetErrorHandler()) then
    GetErrorHandler().HandleException(AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
// Connection management

procedure TADPhysConnection.CheckActive(ADisconnectingAllowed: Boolean = False);
begin
  if not ADisconnectingAllowed and (FState <> csConnected) or
     ADisconnectingAllowed and not (FState in [csConnected, csDisconnecting]) then
    ADException(Self, [S_AD_LPhys], er_AD_AccSrvMBConnected, []);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CheckInactive;
begin
  if FState <> csDisconnected then
    ADException(Self, [S_AD_LPhys], er_AD_AccSrvMBDisConnected, []);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetLogin: IADGUIxLoginDialog;
begin
  Result := FLogin;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SetLogin(const AValue: IADGUIxLoginDialog);
begin
  if FLogin <> nil then
    FLogin.ConnectionDef := nil;
  FLogin := AValue;
  if FLogin <> nil then
    FLogin.ConnectionDef := GetConnectionDef;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetLoginPrompt: Boolean;
begin
  Result := FLoginPrompt;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.SetLoginPrompt(const AValue: Boolean);
begin
  FLoginPrompt := AValue;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CleanoutConnection;
var
  i: Integer;
begin
  try
    for i := 0 to FCommandList.Count - 1 do
      TADPhysCommand(FCommandList[i]).Disconnect;
    while GetTxIsActive do
      case GetTxOptions.DisconnectAction of
      xdCommmit:  TxCommit;
      xdRollback: TxRollback;
      xdNone:     Break;
      end;
  except
    ADHandleException;
  end;
  FSavepoints.Clear;
  FTxIDAutoCommit := 0;
  FPreparedCommands := 0;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.BeforeReuse;
begin
{$IFDEF AnyDAC_MONITOR}
  Trace(ekLiveCycle, esStart, 'BeforeReuse', ['ConnectionDef', GetConnectionDef.Name]);
  try
{$ENDIF}
    if FState = csDisconnected then
      Open;
    FPoolManaged := False;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekLiveCycle, esEnd, 'BeforeReuse', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.AfterReuse;
begin
{$IFDEF AnyDAC_MONITOR}
  Trace(ekLiveCycle, esStart, 'AfterReuse', ['ConnectionDef', GetConnectionDef.Name]);
  try
{$ENDIF}
    FPoolManaged := True;
    CleanoutConnection;
    SetTxOptions(nil);
    SetOptions(nil);
    SetErrorHandler(nil);
{$IFDEF AnyDAC_MONITOR}
    SetOwner(nil, '');
  finally
    Trace(ekLiveCycle, esEnd, 'AfterReuse', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.ForceDisconnect;
var
  i: Integer;
  oCmd: TADPhysCommand;
begin
  FLock.BeginRead;
  try
    for i := 0 to FCommandList.Count - 1 do begin
      oCmd := TADPhysCommand(FCommandList[i]);
      if oCmd.GetState in [csExecuting, csFetching] then
        oCmd.AbortJob(True);
      oCmd.Disconnect;
    end;
    if FState = csConnected then
      Close;
  finally
    FLock.EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.DoLogin;
  procedure LoginAborted;
  var
    s: String;
  begin
    s := GetConnectionDef.Name;
    if s = '' then
      s := S_AD_Unnamed;
    ADException(Self, [S_AD_LPhys], er_AD_ClntDbLoginAborted, [s]);
  end;
var
  oDefDlg: IADGUIxDefaultLoginDialog;
  oDlg: IADGUIxLoginDialog;
  lSharedDlg: Boolean;
begin
  lSharedDlg := not Assigned(FLogin);
  if lSharedDlg then begin
    ADCreateInterface(IADGUIxDefaultLoginDialog, oDefDlg, False);
    if (oDefDlg = nil) or (oDefDlg.LoginDialog = nil) then begin
      InternalConnect;
      Exit;
    end;
    oDlg := oDefDlg.LoginDialog;
    oDlg.ConnectionDef := GetConnectionDef;
  end
  else
    oDlg := FLogin;
  try
    if not oDlg.Execute(InternalConnect) then
      LoginAborted;
  finally
    if lSharedDlg then
      oDlg.ConnectionDef := nil;
  end;
end;

{ ----------------------------------------------------------------------------- }
{$IFDEF AnyDAC_MONITOR}
procedure TADPhysConnection.TraceConnInfo(AKind: TADDebugMonitorAdapterItemKind;
  const AName: String);
var
  i: Integer;
  sName: String;
  vVal: Variant;
  eKind: TADDebugMonitorAdapterItemKind;
  lWasInfo: Boolean;
begin
  lWasInfo := False;
  for i := 0 to GetItemCount - 1 do begin
    sName := '';
    vVal := Unassigned;
    eKind := ikStat;
    GetItem(i, sName, vVal, eKind);
    if eKind = AKind then begin
      if not lWasInfo then begin
        lWasInfo := True;
        Trace(ekConnConnect, esStart, AName, ['DrvID', FDriverObj.GetDriverID]);
      end;
      Trace(ekConnConnect, esProgress, sName + '=' + VarToStr(vVal), []);
    end;
  end;
  if lWasInfo then
    Trace(ekConnConnect, esEnd, AName, ['DrvID', FDriverObj.GetDriverID]);
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.Open;
var
  oWait: IADGUIxWaitCursor;
  oConnDef: IADStanConnectionDef;
begin
  oConnDef := GetConnectionDef;
{$IFDEF AnyDAC_MONITOR}
  if not FMoniAdapterHelper.IsRegistered then
    FMoniAdapterHelper.RegisterClient(GetMonitor);
  if GetTracing then begin
    Trace(ekConnConnect, esStart, 'Open', ['ConnectionDef', oConnDef.Name]);
    oConnDef.Trace(FMonitor);
    TraceConnInfo(ikClientInfo, 'Client info');
  end;
  try
{$ENDIF}
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
    FLock.BeginRead;
    try
      CheckInactive;
      FLock.BeginWrite;
      try
        FState := csConnecting;
        try
{$IFDEF AnyDAC_MONITOR}
          SetTracing(oConnDef.MonitorBy <> '');
{$ENDIF}
          if not oConnDef.Pooled and GetLoginPrompt then
            DoLogin
          else
            InternalConnect;
          // get user specified default schema and catalog names
          FDefaultSchemaName := oConnDef.AsString[S_AD_ConnParam_Common_MetaDefSchema];
          FDefaultCatalogName := oConnDef.AsString[S_AD_ConnParam_Common_MetaDefCatalog];
          // following is required to "refresh" metadata after connecting server
          FreeAndNil(FMetadata);
          FTxSerialID := 0;
          FState := csConnected;
        except
          FState := csDisconnected;
          raise;
        end;
      finally
        FLock.EndWrite;
      end;
    finally
      FLock.EndRead;
      oWait.StopWait;
    end;
{$IFDEF AnyDAC_MONITOR}
    UpdateMonitor;
    if GetTracing then
      TraceConnInfo(ikSessionInfo, 'Session info');
  finally
    Trace(ekConnConnect, esEnd, 'Open', ['ConnectionDef', oConnDef.Name]);
  end;
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.Close;
var
  oWait: IADGUIxWaitCursor;
  oConnDef: IADStanConnectionDef;
begin
  oConnDef := GetConnectionDef;
{$IFDEF AnyDAC_MONITOR}
  Trace(ekConnConnect, esStart, 'Close', ['ConnectionDef', oConnDef.Name]);
  if GetTracing then
    oConnDef.Trace(FMonitor);
  try
{$ENDIF}
    ADCreateInterface(IADGUIxWaitCursor, oWait, False);
    if oWait <> nil then
      oWait.StartWait;
    FLock.BeginRead;
    try
      CheckActive;
      FLock.BeginWrite;
      try
        FState := csDisconnecting;
        CleanoutConnection;
        InternalDisconnect;
        FreeAndNil(FMetadata);
      finally
        FState := csDisconnected;
        FLock.EndWrite;
      end;
    finally
      FLock.EndRead;
      if oWait <> nil then
        oWait.StopWait;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekConnConnect, esEnd, 'Close', ['ConnectionDef', oConnDef.Name]);
  end;
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.ChangePassword(const ANewPassword: String);
var
  oWait: IADGUIxWaitCursor;
begin
  ADCreateInterface(IADGUIxWaitCursor, oWait);
  oWait.PushWait;
  try
    InternalChangePassword(GetConnectionDef.UserName, GetConnectionDef.Password, ANewPassword);
  finally
    oWait.PopWait;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.InternalChangePassword(const AUserName,
  AOldPassword, ANewPassword: String);
begin
  ADCapabilityNotSupported(Self, [S_AD_LPhys]);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.DecPrepared;
begin
  FLock.BeginWrite;
  try
    Dec(FPreparedCommands);
  finally
    FLock.EndWrite;
  end;
end;

{ ----------------------------------------------------------------------------- }
function SortOnUsage(Item1, Item2: Pointer): Integer;
var
  oCmdObj1, oCmdObj2: TADPhysCommand;
begin
  oCmdObj1 := TADPhysCommand(Item1);
  oCmdObj2 := TADPhysCommand(Item2);
  if oCmdObj1.GetResourceOptions.Disconnectable and
     not oCmdObj2.GetResourceOptions.Disconnectable then
    Result := -1
  else if not oCmdObj1.GetResourceOptions.Disconnectable and
          oCmdObj2.GetResourceOptions.Disconnectable then
    Result := 1
  else if oCmdObj1.FExecuteCount > oCmdObj2.FExecuteCount then
    Result := -1
  else if oCmdObj1.FExecuteCount < oCmdObj2.FExecuteCount then
    Result := 1
  else
    Result := 0;
end;

procedure TADPhysConnection.IncPrepared(ACommand: TADPhysCommand);
var
  j, i, n: Integer;
  oCmdObj: TADPhysCommand;
  oResOpts: TADTopResourceOptions;
begin
  FLock.BeginWrite;
  try
    oResOpts := GetResourceOptions as TADTopResourceOptions;
    if (oResOpts.MaxCursors > 0) and
       (FPreparedCommands + 1 > oResOpts.MaxCursors) then begin
      FCommandList.Sort(SortOnUsage);
      n := MulDiv(oResOpts.MaxCursors, C_AD_CrsPctClose, 100);
      i := 0;
      for j := FCommandList.Count - 1 downto 0 do begin
        oCmdObj := TADPhysCommand(FCommandList.Items[j]);
        if oCmdObj.GetResourceOptions.Disconnectable and (oCmdObj <> ACommand) then begin
          oCmdObj.Disconnect;
          Inc(i);
          if i >= n then
            Break;
        end;
      end;
    end;
    Inc(FPreparedCommands);
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetLastAutoGenValue(const AName: String): Variant;
var
  oCmd: IADPhysCommand;
  oGen: IADPhysCommandGenerator;
  oTab: TADDatSTable;
begin
  CreateCommand(oCmd);
  CreateCommandGenerator(oGen, nil);
  oCmd.CommandText := oGen.GenerateGetLastAutoGenValue(AName);
  oCmd.CommandKind := oGen.CommandKind;
  oTab := TADDatSTable.Create;
  try
    oCmd.Define(oTab);
    oCmd.Open;
    oCmd.Fetch(oTab);
    Result := oTab.Rows[0].GetData(0);
  finally
    oTab.Free;
  end;
end;

{-------------------------------------------------------------------------------}
// IADStanObject

function TADPhysConnection.GetName: TComponentName;
begin
  Result := FMoniAdapterHelper.Name;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetParent: IADStanObject;
begin
  Result := FMoniAdapterHelper.Parent;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  FMoniAdapterHelper.SetOwner(AOwner, ARole);
{$IFDEF AnyDAC_MONITOR}
  FMoniAdapterHelper.UnRegisterClient;
  FMoniAdapterHelper.RegisterClient(GetMonitor);
{$ENDIF}  
end;

{-------------------------------------------------------------------------------}
// IADMoniAdapter

function TADPhysConnection.GetHandle: LongWord;
begin
  Result := FMoniAdapterHelper.Handle;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetItemCount: Integer;
begin
  Result := 2;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.GetItem(AIndex: Integer; var AName: String;
  var AValue: Variant; var AKind: TADDebugMonitorAdapterItemKind);
begin
  case AIndex of
  0:
    begin
      AName := 'Commands';
      AValue := FCommandList.Count;
      AKind := ikStat;
    end;
  1:
    begin
      AName := 'Transactions';
{$IFDEF AnyDAC_D6Base}
      AValue := FTxSerialID;
{$ELSE}
      AValue := Integer(FTxSerialID);
{$ENDIF}
      AKind := ikStat;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.UpdateMonitor;
begin
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then
    FMonitor.AdapterChanged(Self as IADMoniAdapter);
{$ENDIF}    
end;

{-------------------------------------------------------------------------------}
{ TADPhysCommandAsyncOperation                                                  }
{-------------------------------------------------------------------------------}
type
  TADPhysCommandAsyncOperation = class(TInterfacedObject, IADStanAsyncOperation)
  protected
    FCommand: TADPhysCommand;
    // IADStanAsyncOperation
    procedure Execute; virtual; abstract;
    procedure AbortJob;
    function AbortSupported: Boolean;
  public
    constructor Create(ACmd: TADPhysCommand);
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysCommandAsyncOperation.Create(ACmd: TADPhysCommand);
begin
  inherited Create;
  FCommand := ACmd;
  FCommand._AddRef;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysCommandAsyncOperation.Destroy;
begin
  FCommand._Release;
  FCommand := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandAsyncOperation.AbortJob;
begin
  FCommand.AbortJob;
  while FCommand.GetState = csAborting do
    Sleep(0);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandAsyncOperation.AbortSupported: Boolean;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  FCommand.GetConnection.CreateMetadata(oConnMeta);
  Result := oConnMeta.AsyncAbortSupported;
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysCommand                                                                }
{ ----------------------------------------------------------------------------- }
// Constructors

constructor TADPhysCommand.Create;
begin
  inherited Create;
  FParams := TADParams.Create(GetParamsOwner);
  FMacros := TADMacros.Create(GetParamsOwner);
  SetOptions(nil);
  FObjectScopes := [osMy];
  FTableKinds := [tkSynonym, tkTable, tkView];
  FBuffer := TADFormatConversionBuffer.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysCommand.Destroy;
var
  oConnObj: TADPhysConnection;
{$IFDEF AnyDAC_MONITOR}
  oConn: IADPhysConnection;
{$ENDIF}
begin
  Disconnect;
  oConnObj := FConnectionObj;
{$IFDEF AnyDAC_MONITOR}
  oConn := FConnection;
  if oConnObj.GetTracing then
    oConnObj.FMonitor.Notify(ekLiveCycle, esStart, Self, 'Destroy',
      ['Command', GetTraceCommandText]);
{$ENDIF}
  try
    oConnObj.RemoveCommand(Self);
    FreeAndNil(FParams);
    FreeAndNil(FMacros);
    _AddRef;
    FreeAndNil(FFetchOptions);
    FreeAndNil(FFormatOptions);
    FreeAndNil(FUpdateOptions);
    FreeAndNil(FResourceOptions);
    FreeAndNil(FBuffer);
    inherited Destroy;
  finally
{$IFDEF AnyDAC_MONITOR}
    if oConnObj.GetTracing then
      oConnObj.FMonitor.Notify(ekLiveCycle, esEnd, Self, 'Destroy',
        ['Command', GetTraceCommandText]);
{$ENDIF}
    FMoniAdapterHelper.Free;
    FMoniAdapterHelper := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetConnectionObj(AConnObj: TADPhysConnection);
begin
  FConnectionObj := AConnObj;
  FConnection := AConnObj as IADPhysConnection;
  FMoniAdapterHelper := TADMoniAdapterHelper.Create(Self, FConnectionObj);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CreateCommandGenerator(out AGen: IADPhysCommandGenerator);
begin
  FConnection.CreateCommandGenerator(AGen, Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetParamsOwner: TPersistent;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
// Tracing

function TADPhysCommand.GetTraceCommandText(const ACmd: String): String;

  function GetLoc: String;
  begin
    Result := '';
    if FCatalogName <> '' then
      Result := Result + FCatalogName + '.';
    if FSchemaName <> '' then
      Result := Result + FSchemaName + '.';
  end;

var
  sCmd: String;
begin
  if ACmd <> '' then
    sCmd := ACmd
  else
    sCmd := FCommandText;
  if FMetaInfoKind = mkNone then begin
    if FCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
      Result := GetLoc + sCmd;
      if FOverload <> 0 then
        Result := Result + ';' + IntTostr(FOverload);
    end
    else
      Result := sCmd;
  end
  else begin
    sCmd := TrimRight(sCmd);
    case FMetaInfoKind of
    mkTables:           Result := 'Table List';
    mkTableFields:      Result := 'Table Fields (' + GetLoc + sCmd + ')';
    mkIndexes:          Result := 'Table Indexes (' + GetLoc + sCmd + ')';
    mkIndexFields:      Result := 'Table Index Fields (' + GetLoc + FBaseObjectName + ', ' + sCmd + ')';
    mkPrimaryKey:       Result := 'Table PKeys (' + GetLoc + sCmd + ')';
    mkPrimaryKeyFields: Result := 'Table PKey Fields (' + GetLoc + FBaseObjectName + ')';
    mkForeignKeys:      Result := 'Table FKeys (' + GetLoc + sCmd + ')';
    mkForeignKeyFields: Result := 'Table FKey Fields (' + GetLoc + FBaseObjectName + ', ' + sCmd + ')';
    mkPackages:         Result := 'Packages(' + GetLoc + ')';
    mkProcs:            Result := 'Procedures (' + GetLoc + FBaseObjectName  + ')';
    mkProcArgs:         Result := 'Procedure Args (' + GetLoc + FBaseObjectName + ', ' + sCmd + ')';
    end;
  end;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Trace(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; const AMsg: String; const AArgs: array of const);
begin
  if FConnectionObj.GetTracing then
    FConnectionObj.FMonitor.Notify(AKind, AStep, Self, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
// Options

function TADPhysCommand.GetFetchOptions: TADFetchOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.FetchOptions
  else
    Result := FFetchOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetFormatOptions: TADFormatOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.FormatOptions
  else
    Result := FFormatOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetUpdateOptions: TADUpdateOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.UpdateOptions
  else
    Result := FUpdateOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetResourceOptions: TADResourceOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.ResourceOptions
  else
    Result := FResourceOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetOptions: IADStanOptions;
begin
  if Assigned(FExternalOptions) then
    Result := FExternalOptions
  else
    Result := Self;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetOptions(const AValue: IADStanOptions);
begin
  if (FExternalOptions <> AValue) or (FBuffer = nil) then begin
    FExternalOptions := AValue;
    if FExternalOptions = nil then begin
      FFetchOptions := TADFetchOptions.Create(Self);
      FFormatOptions := TADFormatOptions.Create(Self);
      FUpdateOptions := TADUpdateOptions.Create(Self);
      FResourceOptions := TADResourceOptions.Create(Self);
    end
    else begin
      FreeAndNil(FFetchOptions);
      FreeAndNil(FFormatOptions);
      FreeAndNil(FUpdateOptions);
      FreeAndNil(FResourceOptions);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetParentOptions(out AOpts: IADStanOptions): Boolean;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions.GetParentOptions(AOpts)
  else if FConnectionObj <> nil then begin
    AOpts := FConnectionObj as IADStanOptions;
    Result := True;
  end
  else begin
    AOpts := nil;
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
// Exception handling

function TADPhysCommand.GetErrorHandler: IADStanErrorHandler;
begin
  Result := FErrorHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetErrorHandler(const AValue: IADStanErrorHandler);
begin
  FErrorHandler := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
begin
  if Assigned(GetErrorHandler()) then
    GetErrorHandler().HandleException(AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ParTypeUnknownError(AParam: TADParam);
begin
  ADException(Self, [S_AD_LPhys], er_AD_AccParTypeUnknown, [AParam.Name]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ParTypeMapError(AParam: TADParam);
begin
  ADException(Self, [S_AD_LPhys], er_AD_AccParDataMapNotSup, [AParam.Name]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ParDefChangedError(AParam: TADParam);
begin
  ADException(Self, [S_AD_LPhys], er_AD_AccParDefChanged, [AParam.Name]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ColTypeMapError(AColumn: TADDatSColumn);
begin
  ADException(Self, [S_AD_LPhys], er_AD_AccColDataMapNotSup, [AColumn.SourceName]);
end;

{-------------------------------------------------------------------------------}
// Get/set props

function TADPhysCommand.GetState: TADPhysCommandState;
begin
  Result := FState;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetState(const AValue: TADPhysCommandState);
begin
  FState := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetConnection: IADPhysConnection;
begin
  Result := FConnection;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetCommandText: String;
begin
  Result := FCommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.PreprocessCommand(ACreateParams, ACreateMacros,
  AExpandParams, AExpandMacros, AExpandEscapes, AParseSQL: Boolean);
var
  oPP: TADPhysPreprocessor;
  oPList: TADParams;
  oMList: TADMacros;
  oConnMeta: IADPhysConnectionMetadata;
begin
  if not (ACreateParams or ACreateMacros or AExpandParams or AExpandMacros or
          AExpandEscapes or AParseSQL) then
    Exit;
  oPList := nil;
  oMList := nil;
  oPP := TADPhysPreprocessor.Create;
  oPP.Instrs := [];
  if AExpandParams then begin
    oPP.Instrs := oPP.Instrs + [piExpandParams];
    oPList := GetParams;
  end;
  if AExpandMacros then begin
    oPP.Instrs := oPP.Instrs + [piExpandMacros];
    oMList := GetMacros;
  end;
  if AExpandEscapes then
    oPP.Instrs := oPP.Instrs + [piExpandEscapes];
  if AParseSQL then
    oPP.Instrs := oPP.Instrs + [piParseSQL];
  if ACreateParams then begin
    oPList := TADParams.Create(GetParamsOwner);
    oPList.BindMode := GetParamBindMode;
    oPP.Instrs := oPP.Instrs + [piCreateParams];
  end;
  if ACreateMacros then begin
    oMList := TADMacros.Create(GetParamsOwner);
    oPP.Instrs := oPP.Instrs + [piCreateMacros];
  end;
  try
    FConnection.CreateMetadata(oConnMeta);
    oPP.ConnMetadata := oConnMeta;
    oPP.Source := FCommandText;
    oPP.Params := oPList;
    oPP.MacrosRead := GetMacros;
    oPP.MacrosUpd := oMList;
    oPP.Execute;
    if AParseSQL then begin
      FDbCommandText := oPP.Destination;
{$IFDEF AnyDAC_MONITOR}
      Trace(ekCmdPrepare, esProgress, 'Prepare', ['DbCmd', FDbCommandText]);
{$ENDIF}
      if not FFixedCommandKind and (GetCommandKind = skUnknown) then begin
        SetCommandKind(oPP.SQLCommandKind);
        FFixedCommandKind := False;
      end;
      SetSourceObjectName(oPP.SQLFromValue);
      FSQLValuesPos := oPP.SQLValuesPos;
      FSQLOrderByPos := oPP.SQLOrderByPos;
    end;
    if ACreateParams then begin
      oPList.AssignValues(GetParams);
      GetParams.Clear;
      GetParams.Assign(oPList);
    end;
    if ACreateMacros then begin
      oMList.AssignValues(GetMacros);
      GetMacros.Clear;
      GetMacros.Assign(oMList);
    end;
  finally
    if ACreateParams then
      oPList.Free;
    if ACreateMacros then
      oMList.Free;
    oPP.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetCommandText(const AValue: String);
begin
  if FCommandText <> AValue then begin
    Disconnect;
    FCommandText := AValue;
    if not (GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs]) then
      with GetResourceOptions do
        PreprocessCommand(ParamCreate, MacroCreate, False, False, False, False);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetParams: TADParams;
begin
  Result := FParams;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetMacros: TADMacros;
begin
  Result := FMacros;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetCommandKind: TADPhysCommandKind;
begin
  Result := FCommandKind;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetCommandKind(const AValue: TADPhysCommandKind);
begin
  FCommandKind := AValue;
  FFixedCommandKind := (AValue <> skUnknown);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSourceObjectName: String;
begin
  Result := FSourceObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetSourceObjectName(const AValue: String);
begin
  FSourceObjectName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSourceRecordSetName: String;
begin
  Result := FSourceRecordSetName;
  if Result = '' then
    Result := GetSourceObjectName
  else if FRecordSetIndex > 0 then
    Result := Result + '#' + IntToStr(FRecordSetIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetSourceRecordSetName(const AValue: String);
begin
  FSourceRecordSetName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetOverload: Word;
begin
  Result := FOverload;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetOverload(const AValue: Word);
begin
  if AValue <> FOverload then begin
    Disconnect;
    FOverload := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetBaseObjectName: String;
begin
  Result := FBaseObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetBaseObjectName(const AValue: String);
begin
  if AValue <> FBaseObjectName then begin
    Disconnect;
    FBaseObjectName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSchemaName: String;
begin
  Result := FSchemaName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetSchemaName(const AValue: String);
begin
  if AValue <> FSchemaName then begin
    Disconnect;
    FSchemaName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetCatalogName: String;
begin
  Result := FCatalogName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetCatalogName(const AValue: String);
begin
  if AValue <> FCatalogName then begin
    Disconnect;
    FCatalogName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetParamBindMode: TADParamBindMode;
begin
  Result := GetParams.BindMode;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetParamBindMode(const AValue: TADParamBindMode);
begin
  if AValue <> GetParams.BindMode then begin
    Disconnect;
    GetParams.BindMode := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetNextRecordSet: Boolean;
begin
  Result := FNextRecordSet;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetNextRecordSet(const AValue: Boolean);
begin
  FNextRecordSet := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetAsyncHandler: IADStanAsyncHandler;
begin
  Result := FAsyncHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetAsyncHandler(const AValue: IADStanAsyncHandler);
begin
  FAsyncHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetMappingHandler: IADPhysMappingHandler;
begin
  Result := FMappingHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetMappingHandler(const AValue: IADPhysMappingHandler);
begin
  FMappingHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSQLOrderByPos: Integer;
begin
  Result := FSQLOrderByPos;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysCommand.GetCliObj: TObject;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
// Metainfo get/set

function TADPhysCommand.GetMetaInfoKind: TADPhysMetaInfoKind;
begin
  Result := FMetaInfoKind;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetMetaInfoKind(AValue: TADPhysMetaInfoKind);
begin
  if AValue <> FMetaInfoKind then begin
    Disconnect;
    FMetaInfoKind := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetTableKinds: TADPhysTableKinds;
begin
  Result := FTableKinds;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetTableKinds(AValue: TADPhysTableKinds);
begin
  if AValue <> FTableKinds then begin
    Disconnect;
    FTableKinds := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetWildcard: String;
begin
  Result := FWildcard;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetWildcard(const AValue: String);
begin
  if AValue <> FWildcard then begin
    Disconnect;
    FWildcard := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetObjectScopes: TADPhysObjectScopes;
begin
  Result := FObjectScopes;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetObjectScopes(AValue: TADPhysObjectScopes);
begin
  if AValue <> FObjectScopes then begin
    Disconnect;
    FObjectScopes := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
// Runtime cycle

procedure TADPhysCommand.Disconnect;
begin
  CheckAsyncProgress;
  if GetState = csOpen then
    CloseAll;
  if GetState = csPrepared then
    Unprepare;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CheckAsyncProgress;
begin
  if GetState in [csExecuting, csFetching] then
    ADException(Self, [S_AD_LPhys], er_AD_AccAsyncOperInProgress, []);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CantChangeState;
begin
  ADException(Self, [S_AD_LPhys], er_AD_AccCantChngCommandState, []);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.AbortJob(const AWait: Boolean = False);
begin
  if GetState in [csExecuting, csFetching] then begin
    FState := csAborting;
    InternalAbort;
    if AWait then
      while not (GetState in [csPrepared, csInactive]) do
        Sleep(0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.InternalAbort;
begin
  ADCapabilityNotSupported(Self, [S_AD_LPhys]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Prepare(const ACommandText: String = '');
begin
{$IFDEF AnyDAC_MONITOR}
  if not FMoniAdapterHelper.IsRegistered then
    FMoniAdapterHelper.RegisterClient(FConnectionObj.GetMonitor);
  Trace(ekCmdPrepare, esStart, 'Prepare', ['Command', GetTraceCommandText(ACommandText)]);
  try
{$ENDIF}
    Disconnect;
    if GetState <> csInactive then
      CantChangeState;
    if FConnection = nil then
      ADException(Self, [S_AD_LPhys], er_AD_AccSrvrIntfMBAssignedS, []);
    FConnectionObj.CheckActive;
    if ACommandText <> '' then
      FCommandText := ACommandText;
    if (GetMetaInfoKind = mkNone) and (GetCommandText = '') then
      ADException(Self, [S_AD_LPhys], er_AD_AccCommandMBFilled, []);
    if not (GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs]) then
      with GetResourceOptions do
        PreprocessCommand(ParamCreate, MacroCreate, ParamExpand, MacroExpand, EscapeExpand, True);
    GetParams.Prepare(GetOptions.FormatOptions.DefaultParamDataType);
    FBuffer.Release;
    FRecordSetIndex := -1;
    FConnectionObj.IncPrepared(Self);
    try
      InternalPrepare;
    except
      InternalUnprepare;
      FConnectionObj.DecPrepared;
      raise;
    end;
    FState := csPrepared;
    UpdateMonitor;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekCmdPrepare, esEnd, 'Prepare', ['Command', GetTraceCommandText]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Unprepare;
begin
  if GetState = csInactive then
    Exit;
{$IFDEF AnyDAC_MONITOR}
  Trace(ekCmdPrepare, esStart, 'Unprepare', ['Command', GetTraceCommandText]);
  try
{$ENDIF}
    CheckAsyncProgress;
    if GetState = csOpen then
      CloseAll;
    if GetState <> csPrepared then
      CantChangeState;
    try
      FBuffer.Release;
      InternalUnprepare;
      FConnectionObj.DecPrepared;
      FExecuteCount := 0;
      FRecordsFetched := 0;
    finally
      if not FFixedCommandKind then
        SetCommandKind(skUnknown);
      SetSourceObjectName('');
      FState := csInactive;
    end;
    UpdateMonitor;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekCmdPrepare, esEnd, 'Unprepare', ['Command', GetTraceCommandText]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.FillStoredProcParams(const ACatalog, ASchema,
  APackage, ACmd: String);
const
  ResultParam = 'Result';
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i, j: Integer;
  oPar: TADParam;
  V: Variant;
  iDestDataType: TFieldType;
  iSrcSize, iDestSize: LongWord;
  iSrcPrec, iSrcScale, iDestPrec: Integer;
  iSrcADDataType, iDestADDataType: TADDataType;
  iSrcAttrs: TADDataAttributes;
  lHasCursors: Boolean;
begin
  GetParams.Clear;
  GetConnection.CreateMetadata(oConnMeta);
  oView := oConnMeta.GetProcArgs(ACatalog, ASchema, APackage, ACmd, '', 0);
  try
    lHasCursors := False;
    for i := 0 to oView.Rows.Count - 1 do
      with oView.Rows[i] do begin
        oPar := GetParams.Add;

        V := GetData(7, rvDefault);
        if not VarIsNull(V) then
          oPar.Position := V
        else
          oPar.Position := 0;

        V := GetData(8, rvDefault);
        if not VarIsNull(V) then
          oPar.ParamType := V;

        V := GetData(6, rvDefault);
        if VarIsNull(V) then
          oPar.Name := ResultParam
        else
          oPar.Name := V;

        V := GetData(9, rvDefault);
        if not VarIsNull(V) then
          iSrcADDataType := TADDataType(Integer(V))
        else
          iSrcADDataType := dtUnknown;

        V := GetData(11, rvDefault);
        if not VarIsNull(V) then begin
          j := Integer(V);
          iSrcAttrs := TADDataAttributes(Pointer(@j)^);
        end
        else
          iSrcAttrs := [];

        V := GetData(14, rvDefault);
        if not VarIsNull(V) then
          iSrcSize := V
        else
          iSrcSize := 0;

        V := GetData(12, rvDefault);
        if not VarIsNull(V) then
          iSrcPrec := V
        else
          iSrcPrec := 0;

        V := GetData(13, rvDefault);
        if not VarIsNull(V) then
          iSrcScale := V
        else
          iSrcScale := 0;

        with GetFormatOptions do begin
          iDestADDataType := dtUnknown;
          iDestDataType := ftUnknown;
          iDestSize := 0;
          iDestPrec := 0;
          ResolveDataType(iSrcADDataType, iSrcSize, iSrcPrec, iSrcScale,
            iDestADDataType, True);
          ColumnDef2FieldDef(iDestADDataType, iSrcScale, iSrcPrec, iSrcSize,
            iSrcAttrs, iDestDataType, iDestSize, iDestPrec);
        end;

        oPar.DataType := iDestDataType;
        oPar.Size := iDestSize;
        oPar.Precision := iDestPrec;
        if iDestDataType in [ftFloat, ftCurrency, ftBCD {$IFDEF AnyDAC_D6Base}, ftFMTBcd {$ENDIF}] then
          oPar.NumericScale := iSrcScale;

        lHasCursors := lHasCursors or (iDestDataType in [ftCursor, ftDataSet]);
      end;
    if (GetCommandKind = skStoredProc) and lHasCursors then
      SetCommandKind(skStoredProcWithCrs);
  finally
    oView.Free;
  end;
end;

{-------------------------------------------------------------------------------}
// Query open / close

type
  TADPhysCommandAsyncOpen = class(TADPhysCommandAsyncOperation)
  protected
    procedure Execute; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandAsyncOpen.Execute;
begin
  FCommand.OpenBase;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CheckMetaInfoParams(const AName: TADPhysParsedName);

  procedure CheckRequired(const AValue, ASubMsg: String);
  begin
    if AValue = '' then
      ADException(Self, [S_AD_LPhys], er_AD_AccMetaInfoNotDefined, [ASubMsg]);
  end;

const
  STabName: String = 'table name';
  SProcName: String = 'procedure name';
  SIndexName: String = 'index name';
  SFKName: String = 'foreign key name';
begin
  case GetMetaInfoKind of
  mkTables:
    ;
  mkTableFields:
    CheckRequired(AName.FObject, STabName);
  mkIndexes:
    CheckRequired(AName.FObject, STabName);
  mkIndexFields:
    begin
      CheckRequired(AName.FBaseObject, STabName);
      CheckRequired(AName.FObject, SIndexName);
    end;
  mkPrimaryKey:
    CheckRequired(AName.FObject, STabName);
  mkPrimaryKeyFields:
    CheckRequired(AName.FBaseObject, STabName);
  mkForeignKeys:
    CheckRequired(AName.FObject, STabName);
  mkForeignKeyFields:
    begin
      CheckRequired(AName.FBaseObject, STabName);
      CheckRequired(AName.FObject, SFKName);
    end;
  mkPackages:
    ;
  mkProcs:
    ;
  mkProcArgs:
    CheckRequired(AName.FObject, SProcName);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.OpenBase;
var
  lOpened: Boolean;
begin
  if FState = csAborting then
    FState := csPrepared
  else begin
    lOpened := False;
    try
      if not GetNextRecordSet then
        lOpened := InternalOpen
      else
        lOpened := InternalNextRecordSet;
    finally
      if lOpened then begin
        FState := csOpen;
        FBuffer.Check;
        FEOF := False;
        FFirstFetch := True;
        FRecordsFetched := 0;
        Inc(FExecuteCount);
        Inc(FRecordSetIndex);
      end
      else
        FState := csPrepared;
    end;
    UpdateMonitor;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.OpenMain(AMode: TADStanAsyncMode; ATimeout: LongWord);
var
  oExec: IADStanAsyncExecutor;
begin
  if GetState = csOpen then
    Exit;
{$IFDEF AnyDAC_MONITOR}
  Trace(ekCmdExecute, esStart, 'Open', ['Command', GetTraceCommandText]);
  try
{$ENDIF}
    CheckAsyncProgress;
    if GetState = csInactive then
      Prepare;
    if GetState <> csPrepared then
      CantChangeState;
    FState := csExecuting;
    try
      ADCreateInterface(IADStanAsyncExecutor, oExec);
      oExec.Setup(TADPhysCommandAsyncOpen.Create(Self), AMode, ATimeout, GetAsyncHandler);
      oExec.Run;
    except
      FState := csPrepared;
      raise;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekCmdExecute, esEnd, 'Open', ['Command', GetTraceCommandText]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.OpenBlocked: Boolean;
var
  eMode: TADStanAsyncMode;
begin
  if GetState <> csOpen then
    with GetResourceOptions do begin
      eMode := AsyncCmdMode;
      if eMode = amAsync then
        eMode := amBlocking;
      OpenMain(eMode, AsyncCmdTimeout);
    end;
  Result := (GetState = csOpen);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Open;
begin
  with GetResourceOptions do
    OpenMain(AsyncCmdMode, AsyncCmdTimeout);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Close;
begin
  if GetState in [csInactive, csPrepared] then
    Exit;
{$IFDEF AnyDAC_MONITOR}
  Trace(ekCmdExecute, esStart, 'Close', ['Command', GetTraceCommandText]);
  try
{$ENDIF}
    CheckAsyncProgress;
    if GetState = csOpen then begin
      try
        InternalClose;
      finally
        FState := csPrepared;
        FRecordSetIndex := -1;
      end;
      UpdateMonitor;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekCmdExecute, esEnd, 'Close', ['Command', GetTraceCommandText]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CloseAll;
begin
  SetNextRecordSet(False);
  Close;
end;

{-------------------------------------------------------------------------------}
// Defining

function TADPhysCommand.DoDefineDataTable(ADatSManager: TADDatSManager;
  ATable: TADDatSTable; ARootID: Integer; const ARootName: String;
  AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
var
  i, j: Integer;
  oTabInfo: TADPhysDataTableInfo;
  oColInfo: TADPhysDataColumnInfo;
  oChildTab: TADDatSTable;
  oCol, oChildTabRelCol, oROWIDCol: TADDatSColumn;
  oRel: TADDatSRelation;
  lTabCreated, lColCreated: Boolean;
  oCreatedList: TList;
  iDataType: TADDataType;
  sName, sTabName: String;
  lDefPK, lPKDefined, lNoRowSet: Boolean;
  oConnMeta: IADPhysConnectionMetadata;
  oPKFieldsView: TADDatSView;
  pMappedTabId: Pointer;
  eMappedTabKind: TADPhysNameKind;
  eLocalMetaInfoMergeMode: TADPhysMetaInfoMergeMode;

  function EnsureTabExistance(ADatSManager: TADDatSManager; var ASourceID: Integer;
    var ASourceName, ADatSName: String; var ATabCreated: Boolean): TADDatSTable;
  var
    i: Integer;
    eMapResult: TADPhysMappingResult;
    sTmp: String;
    oTab: TADDatSTable;
  begin
    if ATable <> nil then
      Result := ATable
    else
      Result := nil;
    ATabCreated := False;
    ADatSName := '';
    eMapResult := mrDefault;
    sTmp := '';
    oTab := nil;
    pMappedTabId := nil;
    eMappedTabKind := nkDefault;
    if GetMappingHandler <> nil then begin
      if ASourceID >= 0 then
        eMapResult := GetMappingHandler.MapRecordSet(Pointer(ASourceID), nkID,
          ASourceID, ASourceName, ADatSName, sTmp, oTab);
      if eMapResult = mrMapped then begin
        pMappedTabId := Pointer(ASourceID);
        eMappedTabKind := nkId;
      end
      else begin
        eMapResult := GetMappingHandler.MapRecordSet(Pointer(ASourceName), nkSource,
          ASourceID, ASourceName, ADatSName, sTmp, oTab);
        if eMapResult = mrMapped then begin
          pMappedTabId := Pointer(ASourceName);
          eMappedTabKind := nkSource;
        end;
      end;
      if (eMapResult = mrMapped) and (ATable = nil) then
        Result := oTab
    end;
    if eMapResult = mrDefault then
      if (ADatSManager <> nil) and (ATable = nil) then begin
        if eLocalMetaInfoMergeMode <> mmReset then begin
          if ASourceName <> '' then
            i := ADatSManager.Tables.IndexOfSourceName(ASourceName)
          else
            i := -1;
          if (i = -1) and (ASourceID >= 0) then
            i := ADatSManager.Tables.IndexOfSourceID(ASourceID);
          if i <> -1 then
            Result := ADatSManager.Tables[i];
        end;
      end;
    if Result = nil then begin
      if (eLocalMetaInfoMergeMode <> mmRely) and ((ARootID <> -1) or (eMapResult <> mrNotMapped)) then begin
        Result := TADDatSTable.Create;
        Result.CountRef(0);
        oCreatedList.Add(Result);
        ATabCreated := True;
      end;
    end
    else
      if (eLocalMetaInfoMergeMode = mmRely) and (ATable <> Result) then
        ADException(Self, [S_AD_LPhys], er_AD_AccMetaInfoMismatch, []);
  end;

  function EnsureColExistance(ATable: TADDatSTable; var ASourceID: Integer;
    var ASourceName, ADatSName: String; var AColCreated: Boolean): TADDatSColumn;
  var
    i: Integer;
    eMapResult: TADPhysMappingResult;
    sTmp: String;
    oCol: TADDatSColumn;
  begin
    Result := nil;
    AColCreated := False;
    ADatSName := '';
    sTmp := '';
    oCol := nil;
    eMapResult := mrDefault;
    if (GetMappingHandler <> nil) and (eMappedTabKind <> nkDefault) then begin
      if ASourceID >= 0 then
        eMapResult := GetMappingHandler.MapRecordSetColumn(pMappedTabId, eMappedTabKind,
          Pointer(ASourceID), nkID, ASourceID, ASourceName, ADatSName, sTmp, oCol);
      if eMapResult <> mrMapped then
        eMapResult := GetMappingHandler.MapRecordSetColumn(pMappedTabId, eMappedTabKind,
          Pointer(ASourceName), nkSource, ASourceID, ASourceName, ADatSName, sTmp, oCol);
      if (oCol <> nil) and (oCol.Table = ATable) and (eMapResult = mrMapped) then
        Result := oCol;
    end;
    if eMapResult = mrDefault then
      if eLocalMetaInfoMergeMode <> mmReset then begin
        if ASourceName <> '' then
          i := ATable.Columns.IndexOfSourceName(ASourceName)
        else
          i := -1;
        if (i = -1) and (ASourceID >= 0) then
          i := ATable.Columns.IndexOfSourceID(ASourceID);
        if i <> -1 then
          Result := ATable.Columns[i];
      end;
    if Result = nil then
      if (eLocalMetaInfoMergeMode <> mmRely) and (eMapResult <> mrNotMapped) then begin
        Result := TADDatSColumn.Create;
        oCreatedList.Add(Result);
        AColCreated := True;
      end;
  end;

  procedure CheckColMatching(AColumn: TADDatSColumn; const AInfo: TADPhysDataColumnInfo);
  begin
    if not ((AColumn.SourceDataType = AInfo.FType) and
            (AnsiCompareText(AColumn.SourceName, AInfo.FSourceName) = 0) and
            (AColumn.SourceID = AInfo.FSourceID)) then
      ADException(Self, [S_AD_LPhys], er_AD_AccMetaInfoMismatch, []);
  end;

  function GetDatSManager: TADDatSManager;
  begin
    if ADatSManager <> nil then
      Result := ADatSManager
    else if ATable <> nil then
      Result := ATable.Manager
    else
      Result := nil;
  end;

begin
  eLocalMetaInfoMergeMode := AMetaInfoMergeMode;
  if GetMetaInfoKind <> mkNone then begin
    if eLocalMetaInfoMergeMode <> mmReset then
      ADException(Self, [S_AD_LPhys], er_AD_AccMetaInfoReset, []);
    FConnection.CreateMetadata(oConnMeta);
    Result := ATable;
    if Result = nil then begin
      Result := TADDatSTable.Create;
      Result.CountRef(0);
      Result.Name := oConnMeta.DefineMetadataTableName(GetMetaInfoKind);
      if GetDatSManager <> nil then
        GetDatSManager.Tables.Add(Result);
    end
    else
      Result.Reset;
    oConnMeta.DefineMetadataStructure(Result, GetMetaInfoKind);
    Exit;
  end;

  sTabName := GetSourceObjectName;
  oROWIDCol := nil;
  oPKFieldsView := nil;
  lDefPK := (ARootID = -1) and (fiMeta in GetFetchOptions.Items) and (sTabName <> '') and
    not ((sTabName[1] = '(') and (sTabName[Length(sTabName)] = ')')) and
    (Pos('''', sTabName) = 0);
  lPKDefined := False;
  lNoRowSet := False;
  lTabCreated := False;
  sName := '';
  oCreatedList := TList.Create;
  try
    try
      if lDefPK then begin
        FConnection.CreateMetadata(oConnMeta);
        oPKFieldsView := oConnMeta.GetTablePrimaryKeyFields(GetCatalogName,
          GetSchemaName, sTabName, '');
      end;
      oTabInfo.FSourceID := ARootID;
      if not InternalColInfoStart(oTabInfo) then begin
        lNoRowSet := True;
        ATable := nil;
      end
      else begin
        if ARootID = -1 then
          oTabInfo.FSourceName := GetSourceRecordSetName
        else
          oTabInfo.FSourceName := ARootName + '.' + oTabInfo.FOriginName;
        ATable := EnsureTabExistance(ADatSManager, oTabInfo.FSourceID,
          oTabInfo.FSourceName, sName, lTabCreated);
        if ATable <> nil then begin
          if (eLocalMetaInfoMergeMode = mmOverride) and lTabCreated then
            eLocalMetaInfoMergeMode := mmReset
          else if (eLocalMetaInfoMergeMode = mmReset) and not lTabCreated then
            ATable.Reset;
          if (eLocalMetaInfoMergeMode <> mmRely) or lTabCreated then begin
            if sName <> '' then
              ATable.Name := sName
            else if GetDatSManager <> nil then
              ATable.Name := GetDatSManager.Tables.BuildUniqueName(oTabInfo.FSourceName)
            else
              ATable.Name := oTabInfo.FSourceName;
            ATable.SourceName := oTabInfo.FSourceName;
            ATable.SourceID := oTabInfo.FSourceID;
            ATable.MinimumCapacity := GetFetchOptions.RowsetSize;
            if (GetDatSManager <> nil) and (ATable.Manager <> GetDatSManager) then begin
              if ATable.Manager <> nil then
                ATable.Manager.Tables.Remove(ATable, True);
              GetDatSManager.Tables.Add(ATable);
            end;
          end;
        end;
      end;
      if ATable <> nil then begin
        oColInfo.FParentTableSourceID := ARootID;
        oColInfo.FTableSourceID := oTabInfo.FSourceID;
        while InternalColInfoGet(oColInfo) do begin
          if oColInfo.FSourceName = '' then begin
            Include(oColInfo.FAttrs, caUnnamed);
            oColInfo.FSourceName := S_AD_Unnamed + IntToStr(oColInfo.FSourceID);
          end;

          lColCreated := False;
          if oColInfo.FType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then begin
            if GetDatSManager <> nil then begin
              oChildTab := DoDefineDataTable(GetDatSManager, nil, oColInfo.FSourceID,
                oTabInfo.FSourceName, AMetaInfoMergeMode);
              if oChildTab <> nil then begin
                oCol := EnsureColExistance(ATable, oColInfo.FSourceID,
                  oColInfo.FSourceName, sName, lColCreated);
                if (oCol <> nil) and (eLocalMetaInfoMergeMode <> mmRely) or lColCreated then begin
                  if lColCreated or (oCol.Name = '') then
                    if sName <> '' then
                      oCol.Name := sName
                    else
                      oCol.Name := ATable.Columns.BuildUniqueName(oColInfo.FSourceName);
                  oCol.DataType := oColInfo.FType;
                  oCol.SourceName := oColInfo.FSourceName;
                  oCol.SourceID := oColInfo.FSourceID;
                  oCol.SourceDataType := oColInfo.FType;
                  oCol.SourceDataTypeName := oColInfo.FTypeName;
                  oCol.OriginName := oColInfo.FOriginName;
                  oCol.Attributes := oColInfo.FAttrs - [caSearchable];
                  oCol.Options := oCol.Options + oColInfo.FForceAddOpts -
                    oColInfo.FForceRemOpts;
                  if lColCreated then
                    ATable.Columns.Add(oCol);
{$IFDEF AnyDAC_MONITOR}
                  Trace(ekCmdPrepare, esProgress, 'Col add (ref)',
                    ['Index', ATable.Columns.Count, 'Name', oCol.SourceName,
                     'Type', C_AD_DataTypeNames[oCol.SourceDataType], 'TypeName',
                     oCol.SourceDataTypeName]);
{$ENDIF}

                  if lColCreated then begin
                    oChildTabRelCol := TADDatSColumn.Create;
                    oCreatedList.Add(oChildTabRelCol);
                    oChildTabRelCol.Name := oChildTab.Columns.BuildUniqueName(
                      C_AD_SysNamePrefix + '#' + ATable.Name);
                    oChildTabRelCol.DataType := dtParentRowRef;
                    oChildTabRelCol.SourceDataType := dtUnknown;
                    oChildTabRelCol.SourceID := -1;
                    oChildTabRelCol.Attributes := oCol.Attributes + [caInternal] - [caSearchable];
                    oChildTab.Columns.Add(oChildTabRelCol);

                    oRel := TADDatSRelation.Create;
                    oCreatedList.Add(oRel);
                    oRel.Nested := True;
                    oRel.Name := GetDatSManager.Relations.BuildUniqueName(
                      C_AD_SysNamePrefix + '#' + ATable.Name + '#' + oChildTab.Name);
                    oRel.ParentTable := ATable;
                    oRel.ParentColumnNames := oCol.Name;
                    oRel.ChildTable := oChildTab;
                    oRel.ChildColumnNames := oChildTabRelCol.Name;
                    GetDatSManager.Relations.Add(oRel);
                  end;
                end;
              end;
            end;
          end

          else begin
            oCol := EnsureColExistance(ATable, oColInfo.FSourceID,
              oColInfo.FSourceName, sName, lColCreated);
            if (oCol <> nil) and (eLocalMetaInfoMergeMode <> mmRely) or lColCreated then begin
              if lColCreated or (oCol.Name = '') then
                if sName <> '' then
                  oCol.Name := sName
                else
                  oCol.Name := ATable.Columns.BuildUniqueName(oColInfo.FSourceName);
              oCol.SourceName := oColInfo.FSourceName;
              oCol.SourceID := oColInfo.FSourceID;
              oCol.SourceDataType := oColInfo.FType;
              oCol.SourcePrecision := oColInfo.FPrec;
              oCol.SourceScale := oColInfo.FScale;
              oCol.SourceSize := oColInfo.FLen;
              oCol.OriginName := oColInfo.FOriginName;
              iDataType := dtUnknown;
              GetFormatOptions.ResolveDataType(oColInfo.FType, oColInfo.FLen,
                oColInfo.FPrec, oColInfo.FScale, iDataType, True);
              oCol.Attributes := oColInfo.FAttrs;
              if caROWID in oCol.Attributes then
                oROWIDCol := oCol;
              oCol.DataType := iDataType;
              if oCol.DataType in [dtAnsiString, dtWideString, dtByteString] then
                if oColInfo.FLen <> LongWord(-1) then
                  oCol.Size := oColInfo.FLen;
              if oCol.DataType in [dtDouble, dtCurrency, dtBCD, dtFmtBCD] then begin
                oCol.Precision := oColInfo.FPrec;
                oCol.Scale := oColInfo.FScale;
              end;
              oCol.Options := oCol.Options + oColInfo.FForceAddOpts -
                oColInfo.FForceRemOpts;
              if lColCreated then
                ATable.Columns.Add(oCol);
{$IFDEF AnyDAC_MONITOR}
              Trace(ekCmdPrepare, esProgress, 'Col add',
                ['Index', ATable.Columns.Count, 'SrcName', oCol.SourceName,
                 'SrcType', C_AD_DataTypeNames[oCol.SourceDataType],
                 'SrcSize', oCol.SourceSize, 'SrcPrec', oCol.SourcePrecision,
                 'SrcScale', oCol.SourceScale, 'Type', C_AD_DataTypeNames[oCol.DataType],
                 'Size', oCol.Size, 'Prec', oCol.Precision, 'Scale', oCol.Scale,
                 'OrigName', oCol.OriginName]);
{$ENDIF}
            end;
          end;
        end;
        if lDefPK then begin
{$IFDEF AnyDAC_MONITOR}
          Trace(ekCmdPrepare, esProgress, 'Primary key',
            ['Cols', oPKFieldsView.Rows.GetValuesList('COLUMN_NAME', ';', '')]);
{$ENDIF}
          for i := 0 to oPKFieldsView.Rows.Count - 1 do begin
            j := ATable.Columns.IndexOfName(oPKFieldsView.Rows.ItemsI[i].GetData('COLUMN_NAME'));
            if j <> -1 then begin
              with ATable.Columns.ItemsI[j] do
                Options := Options + [coInKey];
              lPKDefined := True;
            end;
          end;
        end;
        if not lPKDefined and (oROWIDCol <> nil) then
          with oROWIDCol do
            Options := Options + [coInKey];
      end;
    except
      for i := oCreatedList.Count - 1 downto 0 do
        TObject(oCreatedList[i]).Free;
      raise;
    end;
  finally
    if oPKFieldsView <> nil then begin
      if lDefPK and not (fiMeta in GetFetchOptions.Cache) then
        oPKFieldsView.DeleteAll;
      oPKFieldsView.Free;
    end;
    oCreatedList.Free;
  end;
  Result := ATable;
  if lNoRowSet then
    ADException(Self, [S_AD_LPhys], er_AD_AccCmdMHRowSet, []);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.BeginDefine;
begin
  CheckAsyncProgress;
  if GetState = csInactive then
    Prepare;
  if GetState = csInactive then
    ADException(Self, [S_AD_LPhys], er_AD_AccCmdMBPrepared, []);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.Define(ADatSManager: TADDatSManager;
  ATable: TADDatSTable; AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
{$IFDEF AnyDAC_MONITOR}
var
  sTabName: String;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if ATable <> nil then
    sTabName := ATable.Name
  else
    sTabName := '<nil>';
  Trace(ekCmdPrepare, esStart, 'Define(TADDatSManager)',
    ['ADatSManager', ADatSManager.Name, 'ATable', sTabName, 'Command', GetTraceCommandText]);
  try
{$ENDIF}
    BeginDefine;
    if AMetaInfoMergeMode = mmReset then begin
      if GetMetaInfoKind = mkNone then begin
        if ATable <> nil then
          ATable.Reset;
        AMetaInfoMergeMode := mmOverride;
      end
      else if ADatSManager <> nil then
        ADatSManager.Reset;
    end;
    Result := DoDefineDataTable(ADatSManager, ATable, -1, '', AMetaInfoMergeMode);
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekCmdPrepare, esEnd, 'Define(TADDatSManager)',
      ['ADatSManager', ADatSManager.Name, 'ATable', sTabName, 'Command', GetTraceCommandText]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.Define(ATable: TADDatSTable;
  AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
{$IFDEF AnyDAC_MONITOR}
var
  sTabName: String;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if ATable <> nil then
    sTabName := ATable.Name
  else
    sTabName := '<nil>';
  Trace(ekCmdPrepare, esStart, 'Define(TADDatSTable)',
    ['ATable', sTabName, 'Command', GetTraceCommandText]);
  try
{$ENDIF}
    BeginDefine;
    Result := DoDefineDataTable(nil, ATable, -1, '', AMetaInfoMergeMode);
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekCmdPrepare, esEnd, 'Define(TADDatSTable)',
      ['ATable', sTabName, 'Command', GetTraceCommandText]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
// Executing

type
  PDEErrorAction = ^TADErrorAction;

  TADPhysCommandAsyncExecute = class(TADPhysCommandAsyncOperation)
  private
    FTimes: Integer;
    FOffset: Integer;
    FpRowsAffected: PInteger;
    FpRowsAffectedReal: PBoolean;
    FpAction: PDEErrorAction;
  protected
    // IADStanAsyncOperation
    procedure Execute; override;
  public
    constructor Create(ACmd: TADPhysCommand; ATimes: Integer; AOffset: Integer;
      var ARowsAffected: Integer; var ARowsAffectedReal: Boolean;
      var AAction: TADErrorAction);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysCommandAsyncExecute.Create(ACmd: TADPhysCommand;
  ATimes: Integer; AOffset: Integer; var ARowsAffected: Integer;
  var ARowsAffectedReal: Boolean; var AAction: TADErrorAction);
begin
  inherited Create(ACmd);
  FTimes := ATimes;
  FOffset := AOffset;
  FpRowsAffected := @ARowsAffected;
  FpRowsAffectedReal := @ARowsAffectedReal;
  FpAction := @AAction;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandAsyncExecute.Execute;
begin
  FCommand.ExecuteBase(FTimes, FOffset, FpRowsAffected^, FpRowsAffectedReal^,
    FpAction^);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ExecuteBase(ATimes, AOffset: LongInt;
  var ARowsAffected: LongInt; var ARowsAffectedReal: Boolean;
  var AAction: TADErrorAction);

  procedure UpdRes(AValue: Integer);
  begin
    if AValue = -1 then begin
      AValue := 0;
      ARowsAffectedReal := False;
    end;
    if ARowsAffected = -1 then
      ARowsAffected := AValue
    else
      Inc(ARowsAffected, AValue);
    Inc(FExecuteCount, AValue);
  end;

var
  iCount: LongInt;
  oExc: Exception;
begin
  ARowsAffected := -1;
  ARowsAffectedReal := True;
  AAction := eaExitSuccess;
  if FState = csAborting then
    FState := csPrepared
  else begin
    FConnectionObj.PerformAutoCommit(cpBeforeCmd);
    try
      repeat
        AAction := eaExitSuccess;
        iCount := 0;
        try
          InternalExecute(ATimes, AOffset, iCount);
          UpdRes(iCount);
        except
          on E: EADException do begin
            UpdRes(iCount);
            AAction := eaFail;
            AOffset := AOffset + Integer(iCount);
            if Assigned(GetErrorHandler()) then begin
              oExc := EADPhysArrayExecuteError.Create(ATimes, AOffset, E);
              try
                GetErrorHandler().HandleException(nil, oExc);
                if oExc <> nil then
                  AAction := EADPhysArrayExecuteError(oExc).Action;
              finally
                oExc.Free;
              end;
            end;
            case AAction of
            eaApplied:
              begin
                Inc(AOffset);
                Inc(ARowsAffected);
              end;
            eaSkip:
              Inc(AOffset);
            eaRetry:
              ;
            eaFail,
            eaDefault:
              raise;
            end;
          end;
        end;
        if AOffset >= ATimes then
          AAction := eaExitSuccess;
      until AAction in [eaExitSuccess, eaExitFailure];
      if AAction = eaExitSuccess then
        FConnectionObj.PerformAutoCommit(cpAfterCmdSucc)
      else
        FConnectionObj.PerformAutoCommit(cpAfterCmdFail);
      FState := csPrepared;
    except
      FState := csPrepared;
      FConnectionObj.PerformAutoCommit(cpAfterCmdFail);
      raise;
    end;
  end;
  if ARowsAffected = -1 then
    ARowsAffected := 0;
  UpdateMonitor;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ExecuteMain(ATimes: Integer; AOffset: Integer;
  AMode: TADStanAsyncMode; ATimeout: LongWord);
var
  i: Integer;
  oExec: IADStanAsyncExecutor;
  procedure MBPrepared;
  begin
    ADException(Self, [S_AD_LPhys], er_AD_AccCmdMBPrepared, []);
  end;
  procedure CantExec;
  begin
    ADException(Self, [S_AD_LPhys], er_AD_AccCantExecCmdWithRowSet, []);
  end;
  procedure ParamArrMismatch(AParam: TADParam);
  begin
    ADException(Self, [S_AD_LPhys], er_AD_AccParamArrayMismatch, [AParam.Name]);
  end;
begin
{$IFDEF AnyDAC_MONITOR}
  Trace(ekCmdExecute, esStart, 'Execute', ['Command', GetTraceCommandText,
    'ATimes', ATimes, 'AOffset', AOffset]);
  try
{$ENDIF}
    FRowsAffected := -1;
    FRowsAffectedReal := True;
    FErrorAction := eaExitSuccess;
    CheckAsyncProgress;
    if GetState = csInactive then
      Prepare;
    if GetState <> csPrepared then
      MBPrepared;
    FState := csExecuting;
    try
      if (GetCommandKind in [skSelect, skSelectForUpdate, skStoredProcWithCrs]) or
         (GetMetaInfoKind <> mkNone) then
        CantExec;
      for i := 0 to GetParams.Count - 1 do
        if GetParams[i].ArraySize < ATimes then
          ParamArrMismatch(GetParams[i]);
      if ATimes <= 0 then
        ATimes := 1;
      if AOffset < 0 then
        AOffset := 0;
      if AOffset >= ATimes then begin
        FRowsAffected := 0;
        FErrorAction := eaExitSuccess;
      end
      else begin
        ADCreateInterface(IADStanAsyncExecutor, oExec);
        oExec.Setup(TADPhysCommandAsyncExecute.Create(Self, ATimes, AOffset,
          FRowsAffected, FRowsAffectedReal, FErrorAction), AMode, ATimeout,
          GetAsyncHandler);
        oExec.Run;
      end;
    except
      FState := csPrepared;
      raise;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekCmdExecute, esEnd, 'Execute', ['Command', GetTraceCommandText,
      'ATimes', ATimes, 'AOffset', AOffset, 'RowsAffected', FRowsAffected,
      'RowsAffectedReal', FRowsAffectedReal, 'ErrorAction', Integer(FErrorAction)]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ExecuteBlocked(ATimes, AOffset: Integer);
var
  eMode: TADStanAsyncMode;
begin
  with GetResourceOptions do begin
    eMode := AsyncCmdMode;
    if eMode = amAsync then
      eMode := amBlocking;
    ExecuteMain(ATimes, AOffset, eMode, AsyncCmdTimeout);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Execute(ATimes: Integer; AOffset: Integer);
begin
  with GetResourceOptions do
    ExecuteMain(ATimes, AOffset, AsyncCmdMode, AsyncCmdTimeout);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetErrorAction: TADErrorAction;
begin
  Result := FErrorAction;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetRowsAffected: Integer;
begin
  Result := FRowsAffected;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetRowsAffectedReal: Boolean;
begin
  Result := FRowsAffectedReal;
end;

{-------------------------------------------------------------------------------}
// Fetching

type
  TADPhysCommandAsyncFetch = class(TADPhysCommandAsyncOperation)
  private
    FTable: TADDatSTable;
    FAll: Boolean;
    FpResult: PInteger;
  protected
    // IADStanAsyncOperation
    procedure Execute; override;
  public
    constructor Create(ACmd: TADPhysCommand; ATable: TADDatSTable;
      AAll: Boolean; var AResult: Integer);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysCommandAsyncFetch.Create(ACmd: TADPhysCommand;
  ATable: TADDatSTable; AAll: Boolean; var AResult: Integer);
begin
  inherited Create(ACmd);
  FTable := ATable;
  FAll := AAll;
  FpResult := @AResult;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandAsyncFetch.Execute;
begin
  FCommand.FetchBase(FTable, FAll, FpResult^);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.FetchBase(ATable: TADDatSTable; AAll: Boolean;
  var ARowsAffected: Integer);

  function DoFetch(ARowCount: Integer): Integer;
  var
    iRowsetSize, iLastFetch, iRecsMax: Integer;
  begin
    iRecsMax := GetFetchOptions.RecsMax;
    if (iRecsMax <> -1) and (FRecordsFetched + ARowCount > iRecsMax) then
      ARowCount := GetFetchOptions.RecsMax - FRecordsFetched;
    iRowsetSize := GetFetchOptions.RowsetSize;
    if ARowCount < iRowsetSize then
      iRowsetSize := ARowCount;
    Result := 0;
    repeat
      iLastFetch := InternalFetchRowSet(ATable, nil, iRowsetSize);
      Inc(FRecordsFetched, iLastFetch);
      Inc(Result, iLastFetch);
    until (FState <> csFetching) or (iLastFetch <> iRowsetSize) or (Result >= ARowCount);
    FEOF := (iLastFetch <> iRowsetSize) or
      (iRecsMax <> -1) and (FRecordsFetched >= iRecsMax);
  end;

var
  iMode: TADFetchMode;
begin
  ARowsAffected := 0;
  if FState = csAborting then
    FState := csOpen
  else
    try
      if not FFirstFetch and not AAll then
        iMode := fmOnDemand
      else if AAll then
        iMode := fmAll
      else
        iMode := GetFetchOptions.Mode;
      if iMode in [fmAll, fmExactRecsMax] then
        ATable.BeginLoadData(lmHavyFetching)
      else
        ATable.BeginLoadData(lmFetching);
      try
        case iMode of
        fmAll:
          ARowsAffected := DoFetch(MAXINT);
        fmExactRecsMax:
          begin
            ARowsAffected := DoFetch(GetFetchOptions.RecsMax + 1);
            if ARowsAffected <> GetFetchOptions.RecsMax then
              ADException(Self, [S_AD_LPhys], er_AD_AccExactFetchMismatch, []);
          end;
        fmManual, fmOnDemand:
          ARowsAffected := DoFetch(GetFetchOptions.RowsetSize);
        end;
      finally
        FFirstFetch := False;
        ATable.EndLoadData;
      end;
    finally
      case FState of
      csFetching:
        FState := csOpen;
      csAborting:
        begin
          FState := csOpen;
          FEOF := True;
        end;
      end;
    end;
  UpdateMonitor;
  if FEOF then begin
{$IFDEF AnyDAC_MONITOR}
    Trace(ekCmdExecute, esProgress, 'EOF reached',
      ['ATable', ATable.SourceName, 'Command', GetTraceCommandText]);
{$ENDIF}
    if GetFetchOptions.AutoClose then
      Close;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.FetchMain(ATable: TADDatSTable; AAll: Boolean;
  AMode: TADStanAsyncMode; ATimeout: LongWord);
var
  oExec: IADStanAsyncExecutor;
begin
  ASSERT(ATable <> nil);
  FRowsAffected := 0;
{$IFDEF AnyDAC_MONITOR}
  Trace(ekCmdExecute, esStart, 'Fetch',
    ['ATable', ATable.SourceName, 'Command', GetTraceCommandText]);
  try
{$ENDIF}
    CheckAsyncProgress;
    if GetState <> csOpen then
      ADException(Self, [S_AD_LPhys], er_AD_AccCmdMBOpen4Fetch, []);
    if not FEOF then begin
      FState := csFetching;
      try
        ADCreateInterface(IADStanAsyncExecutor, oExec);
        oExec.Setup(TADPhysCommandAsyncFetch.Create(Self, ATable, AAll,
          FRowsAffected), AMode, ATimeout, GetAsyncHandler);
        oExec.Run;
      except
        if FState = csFetching then
          FState := csOpen;
        raise;
      end;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    Trace(ekCmdExecute, esEnd, 'Fetch',
      ['ATable', ATable.SourceName, 'Command', GetTraceCommandText,
       'RowsAffected', FRowsAffected]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.FetchBlocked(ATable: TADDatSTable; AAll: Boolean);
var
  eMode: TADStanAsyncMode;
begin
  with GetResourceOptions do begin
    eMode := AsyncCmdMode;
    if eMode = amAsync then
      eMode := amBlocking;
    FetchMain(ATable, AAll, eMode, AsyncCmdTimeout);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Fetch(ATable: TADDatSTable; AAll: Boolean);
begin
  with GetResourceOptions do
    FetchMain(ATable, AAll, AsyncCmdMode, AsyncCmdTimeout);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Fetch(ADatSManager: TADDatSManager;
  AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset);
var
  eMode: TADPhysMetaInfoMergeMode;
  oTab: TADDatSTable;
  iRows: Integer;
begin
  iRows := 0;
  try
    CheckAsyncProgress;
    if GetState = csInactive then
      Prepare;
    eMode := AMetaInfoMergeMode;
    if eMode = mmReset then begin
      ADatSManager.Reset;
      eMode := mmOverride;
    end;
    while True do begin
      if GetState = csPrepared then
        OpenBlocked;
      if GetState <> csOpen then
        Break;
      oTab := Define(ADatSManager, nil, eMode);
      FetchBlocked(oTab, True);
      Inc(iRows, FRowsAffected);
      SetNextRecordSet(True);
    end;
    if (GetState = csOpen) and GetFetchOptions.AutoClose then
      Close;
  finally
    FRowsAffected := iRows;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.CheckFetchColumn(AColType: TADDataType): Boolean;
begin
  Result := not (
   (AColType in [dtRowSetRef, dtCursorRef]) and
    not (fiDetails in GetFetchOptions.Items) or
   (AColType in [dtBlob, dtMemo, dtWideMemo, dtHBlob, dtHBFile, dtHMemo, dtWideHMemo]) and
    not (fiBlobs in GetFetchOptions.Items)
  );
end;

{-------------------------------------------------------------------------------}
// IADStanObject

function TADPhysCommand.GetName: TComponentName;
begin
  Result := FMoniAdapterHelper.Name;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetParent: IADStanObject;
begin
  Result := FMoniAdapterHelper.Parent;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  FMoniAdapterHelper.SetOwner(AOwner, ARole);
{$IFDEF AnyDAC_MONITOR}
  FMoniAdapterHelper.UnRegisterClient;
  FMoniAdapterHelper.RegisterClient(FConnectionObj.GetMonitor);
{$ENDIF}  
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
// IADMoniAdapter

function TADPhysCommand.GetHandle: LongWord;
begin
  Result := FMoniAdapterHelper.Handle;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetItemCount: Integer;
begin
  Result := 5 + FParams.Count + FMacros.Count;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.GetItem(AIndex: Integer; var AName: String;
  var AValue: Variant; var AKind: TADDebugMonitorAdapterItemKind);
begin
  case AIndex of
  0:
    begin
      AName := 'ExecuteCount';
      AValue := FExecuteCount;
      AKind := ikStat;
    end;
  1:
    begin
      AName := 'RowsAffected';
      AValue := FRowsAffected;
      AKind := ikStat;
    end;
  2:
    begin
      AName := 'RecordsFetched';
      AValue := FRecordsFetched;
      AKind := ikStat;
    end;
  3:
    begin
      AName := 'Status';
      if FState = csPrepared then
        AValue := 'Prepared'
      else if FState = csOpen then
        if FEOF then
          AValue := 'Active, EOF'
        else
          AValue := 'Active';
      AKind := ikStat;
    end;
  4:
    begin
      AName := '@CommandText';
      AValue := GetTraceCommandText;
      AKind := ikSQL;
    end;
  else
    if AIndex - 5 < FParams.Count then
      with FParams[AIndex - 5] do begin
        AName := Name;
        if (ArrayType <> atScalar) then
          AValue := '<array>'
        else
          AValue := Value;
        AKind := ikParam;
      end
    else
      with FMacros[AIndex - 5 - FParams.Count] do begin
        AName := Name;
        AValue := Value;
        AKind := ikParam;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.UpdateMonitor;
begin
{$IFDEF AnyDAC_MONITOR}
  if FConnection.Tracing then
    FConnection.Monitor.AdapterChanged(Self);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
initialization
  TADSingletonFactory.Create(TADPhysManager, IADPhysManager);

end.
