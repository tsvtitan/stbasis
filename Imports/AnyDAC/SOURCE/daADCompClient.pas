{-------------------------------------------------------------------------------}
{ AnyDAC high-level components                                                  }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADCompClient;

interface

uses
  Classes, SysUtils, DB,
  daADStanIntf, daADStanOption, daADStanParam, daADStanUtil,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf, daADPhysScript,
  daADDAptColumn, daADDAptIntf,
  daADCompDataSet;

type
  TADCustomManager = class;
  TADCustomConnection = class;
  TADCustomCommand = class;
  TADCustomTableAdapter = class;
  TADCustomSchemaAdapter = class;
  TADCustomUpdateObject = class;
  TADAdaptedDataSet = class;
  TADCustomClientDataSet = class;
  TADRdbmsDataSet = class;
  TADCustomQuery = class;
  TADCustomStoredProc = class;

  TADManager = class;
  TADConnection = class;
  TADCommand = class;
  TADTableAdapter = class;
  TADSchemaAdapter = class;
  TADMetaInfoCommand = class;
  TADClientDataSet = class;
  TADQuery = class;
  TADTable = class;
  TADStoredProc = class;
  TADMetaInfoQuery = class;
  TADUpdateSQL = class;

  TADErrorEvent = procedure (ASender: TObject; const AInitiator: IADStanObject;
    var AException: Exception) of object;
  TADConnectionLoginEvent = procedure (AConnection: TADCustomConnection;
    const AConnectionDef: IADStanConnectionDef) of object;
  TADReconcileRowEvent = procedure (ASender: TObject; ARow: TADDatSRow;
    var Action: TADDAptReconcileAction) of object;
  TADUpdateRowEvent = procedure (ASender: TObject; ARow: TADDatSRow;
    ARequest: TADPhysUpdateRequest; AUpdRowOptions: TADPhysUpdateRowOptions;
    var AAction: TADErrorAction) of object;
  TADExecuteErrorEvent = procedure (ASender: TObject; ATimes, AOffset: LongInt;
    AException: Exception; var AAction: TADErrorAction) of object;
  TADDescribeColumnEvent = procedure (ASender: TObject; AColumn: TADDatSColumn;
    var AAttrs: TADDataAttributes; var AOptions: TADDataOptions; var AObjName: String) of object;
  TADDescribeTableEvent = procedure (ASender: TObject; ATable: TADDatSTable;
    var AObjName: String) of object;

  TADChangingKind = (ckMacros, ckLockParse);
  TADChangingKinds = set of TADChangingKind;
  TADBindedBy = (bbNone, bbName, bbObject);

  TADCustomManager = class(TComponent, {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADStanOptions)
  private
    FAutoCreated: Boolean;
    FStreamedActive: Boolean;
    FConnections: TList;
    FOnStartup: TNotifyEvent;
    FOnShutdown: TNotifyEvent;
    FKeepConnections: Boolean;
    FLock: TADMREWSynchronizer;
    FFormatOptions: TADFormatOptions;
    FFetchOptions: TADFetchOptions;
    FUpdateOptions: TADUpdateOptions;
    FResourceOptions: TADResourceOptions;
    FActiveAtRunTime: TADActiveAtRunTime;
    function GetActive: Boolean;
    function GetConnectionDefFileName: String;
    function GetConnection(AIndex: Integer): TADCustomConnection;
    function GetConnectionCount: Integer;
    function GetSilentMode: Boolean;
    function GetWaitCursor: TADGUIxScreenCursor;
    procedure SetActive(const AValue: Boolean);
    procedure SetConnectionDefFileName(const AValue: String);
    procedure SetSilentMode(const AValue: Boolean);
    procedure SetWaitCursor(const AValue: TADGUIxScreenCursor);
    procedure AddConnection(AConn: TADCustomConnection);
    procedure RemoveConnection(AConn: TADCustomConnection);
    procedure SetFetchOptions(const AValue: TADFetchOptions);
    procedure SetFormatOptions(const AValue: TADFormatOptions);
    procedure SetUpdateOptions(const AValue: TADUpdateOptions);
    procedure SetResourceOptions(const AValue: TADResourceOptions);
    function InternalOpenConnection(AConnection: TADCustomConnection;
      const AConnectionName: string): TADCustomConnection;
    function GetConnectionDefs: IADStanConnectionDefs;
    function GetState: TADPhysManagerState;
    function GetAfterLoadConnectionDefFile: TNotifyEvent;
    function GetBeforeLoadConnectionDefFile: TNotifyEvent;
    function GetConnectionDefAutoLoad: Boolean;
    function GetConnectionDefsLoaded: Boolean;
    procedure SetAfterLoadConnectionDefFile(const AValue: TNotifyEvent);
    procedure SetBeforeLoadConnectionDefFile(const AValue: TNotifyEvent);
    procedure SetConnectionDefAutoLoad(const AValue: Boolean);
    function IsCDFNS: Boolean;
  protected
    { IADStanOptions }
    function GetParentOptions(out AOpts: IADStanOptions): Boolean;
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADUpdateOptions;
    function GetResourceOptions: TADResourceOptions;
    // other
    procedure Loaded; override;
    procedure CheckActive;
    procedure CheckInactive;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    function OpenConnection(const AConnectionName: string): TADCustomConnection; overload;
    function OpenConnection(AConnection: TADCustomConnection): TADCustomConnection; overload;
    procedure CloseConnection(var AConnection: TADCustomConnection);
    procedure DropConnections;
    function FindConnection(const AConnectionName: string): TADCustomConnection;
    procedure GetConnectionNames(AList: TStrings);
    procedure GetConnectionDefNames(AList: TStrings);
    procedure GetDriverNames(AList: TStrings);
    procedure GetTableNames(const AConnectionName, ACatalogName, ASchemaName,
      APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes = [osMy]);
    procedure GetFieldNames(const AConnectionName, ACatalogName, ASchemaName,
      ATableName, APattern: string; AList: TStrings);
    procedure GetKeyFieldNames(const AConnectionName, ACatalogName, ASchemaName,
      ATableName, APattern: string; AList: TStrings);
    procedure GetPackageNames(const AConnectionName, ACatalogName, ASchemaName,
      APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes = [osMy]);
    procedure GetStoredProcNames(const AConnectionName, ACatalogName, ASchemaName,
      APackage, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes = [osMy]);
    function IsConnectionDef(const AName: String): Boolean;
    procedure AddConnectionDef(const AName, ADriver: string; AList: TStrings);
    procedure DeleteConnectionDef(const AName: string);
    procedure ModifyConnectionDef(const AName: string; AList: TStrings);
    procedure GetConnectionDefParams(const AName: string; AList: TStrings);
    procedure SaveConnectionDefFile;
    procedure LoadConnectionDefFile;
    // RO
    property State: TADPhysManagerState read GetState;
    property AutoCreated: Boolean read FAutoCreated;
    property ConnectionCount: Integer read GetConnectionCount;
    property Connections[Index: Integer]: TADCustomConnection read GetConnection;
    property ConnectionDefs: IADStanConnectionDefs read GetConnectionDefs;
    property ConnectionDefFileLoaded: Boolean read GetConnectionDefsLoaded;
    // RW
    property ConnectionDefFileAutoLoad: Boolean read GetConnectionDefAutoLoad write SetConnectionDefAutoLoad default True;
    property ConnectionDefFileName: String read GetConnectionDefFileName write SetConnectionDefFileName stored IsCDFNS;
    property WaitCursor: TADGUIxScreenCursor read GetWaitCursor write SetWaitCursor default gcrSQLWait;
    property SilentMode: Boolean read GetSilentMode write SetSilentMode default False;
    property KeepConnections: Boolean read FKeepConnections write FKeepConnections default True;
    property FetchOptions: TADFetchOptions read FFetchOptions write SetFetchOptions;
    property FormatOptions: TADFormatOptions read FFormatOptions write SetFormatOptions;
    property UpdateOptions: TADUpdateOptions read FUpdateOptions write SetUpdateOptions;
    property ResourceOptions: TADResourceOptions read FResourceOptions write SetResourceOptions;
    property ActiveAtRunTime: TADActiveAtRunTime read FActiveAtRunTime write FActiveAtRunTime default arStandard;
    property Active: Boolean read GetActive write SetActive default False;
    property OnStartup: TNotifyEvent read FOnStartup write FOnStartup;
    property OnShutdown: TNotifyEvent read FOnShutdown write FOnShutdown;
    property BeforeLoadConnectionDefFile: TNotifyEvent read GetBeforeLoadConnectionDefFile write SetBeforeLoadConnectionDefFile;
    property AfterLoadConnectionDefFile: TNotifyEvent read GetAfterLoadConnectionDefFile write SetAfterLoadConnectionDefFile;
  end;

  TADManager = class(TADCustomManager)
  published
    property ConnectionDefFileAutoLoad;
    property ConnectionDefFileName;
    property WaitCursor;
    property SilentMode;
    property KeepConnections;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property ActiveAtRunTime;
    property Active;
    property OnStartup;
    property OnShutdown;
    property BeforeLoadConnectionDefFile;
    property AfterLoadConnectionDefFile;
  end;

  TADCustomConnection = class(TCustomConnection, {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADStanOptions, IADStanErrorHandler, IADStanObject)
  private
    FConnectionIntf: IADPhysConnection;
    FConnectionName: String;
    FParams: IADStanConnectionDef;
    FRefCount: Integer;
    FKeepConnection: Boolean;
    FTemporary: Boolean;
    FOnLogin: TADConnectionLoginEvent;
    FFormatOptions: TADFormatOptions;
    FFetchOptions: TADFetchOptions;
    FUpdateOptions: TADUpdateOptions;
    FResourceOptions: TADResourceOptions;
    FTxOptions: TADTxOptions;
    FCommandList: TList;
    FOptionsIntf: IADStanOptions;
    FOnError: TADErrorEvent;
    FActiveAtRunTime: TADActiveAtRunTime;
    FLoginDialog: IADGUIxLoginDialog;
    function GetParams: TStrings;
    procedure SetConnectionName(const AValue: String);
    procedure SetParams(const AValue: TStrings);
    procedure SetKeepConnection(const AValue: Boolean);
    procedure ParamsChanging(ASender: TObject);
    function GetConnectionDefName: string;
    procedure SetConnectionDefName(const AValue: string);
    function GetDriverName: string;
    procedure SetDriverName(const AValue: string);
    procedure CheckActive;
    procedure CheckInactive;
    function GetInTransaction: Boolean;
    function GetSQLBased: Boolean;
    procedure AttachClient(AObj: TObject);
    procedure DetachClient(AObj: TObject);
    function GetCommandCount: Integer;
    function GetCommands(AIndex: Integer): TADCustomCommand;
    procedure SetFetchOptions(const AValue: TADFetchOptions);
    procedure SetFormatOptions(const AValue: TADFormatOptions);
    procedure SetTxOptions(const AValue: TADTxOptions);
    procedure SetUpdateOptions(const AValue: TADUpdateOptions);
    function GetRDBMSKind: TADRDBMSKind;
    function CnvNull(const AStr: Variant): String;
    procedure DoInternalLogin;
    function GetConnectionMetadata(AOpen: Boolean = False): IADPhysConnectionMetadata;
    procedure SetResourceOptions(const AValue: TADResourceOptions);
    procedure CheckSession(ARequired: Boolean);
    procedure SetLoginDialog(const AValue: IADGUIxLoginDialog);
  protected
    { IADStanObject }
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    { IADStanOptions }
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADUpdateOptions;
    function GetResourceOptions: TADResourceOptions;
    function GetParentOptions(out AOpts: IADStanOptions): Boolean;
    { IADStanErrorHandler }
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    // other
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    function GetConnected: Boolean; override;
    procedure DoLogin(const AConnectionDef: IADStanConnectionDef); virtual;
    function GetDataSet(AIndex: Integer): TADDataSet; reintroduce;
    procedure SetConnected(AValue: Boolean); {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Commit;
    procedure Rollback;
    function StartTransaction: LongWord;
    procedure CloseClients;
    procedure ValidateName(const AName: string);
    procedure GetTableNames(const ACatalogName, ASchemaName, APattern: string;
      AList: TStrings; AScopes: TADPhysObjectScopes = [osMy];
      AKinds: TADPhysTableKinds = [tkSynonym, tkTable, tkView]);
    procedure GetFieldNames(const ACatalogName, ASchemaName, ATableName, APattern: string;
      AList: TStrings);
    procedure GetKeyFieldNames(const ACatalogName, ASchemaName, ATableName, APattern: string;
      AList: TStrings);
    procedure GetPackageNames(const ACatalogName, ASchemaName, APattern: string;
      AList: TStrings; AScopes: TADPhysObjectScopes = [osMy]);
    procedure GetStoredProcNames(const ACatalogName, ASchemaName, APackage, APattern: string;
      AList: TStrings; AScopes: TADPhysObjectScopes = [osMy]);
    procedure ApplyUpdates(const ADataSets: array of TADDataSet);
    function EncodeObjectName(const ACatalogName, ASchemaName, ABaseObjectName,
      AObjectName: String): String;
    procedure DecodeObjectName(const AFullName: String; var ACatalogName,
      ASchemaName, ABaseObjectName, AObjectName: String);
    function GetLastAutoGenValue(const AName: String): Variant;
    procedure CheckConnectionDef;
{
    function Execute(const SQL: string; Params: TADParams = nil;
      Cache: Boolean = False; Cursor: PDataSet = nil): Integer;
    procedure FlushSchemaCache(const TableName: string);
}
    property IsSQLBased: Boolean read GetSQLBased;
    property RDBMSKind: TADRDBMSKind read GetRDBMSKind;
    property InTransaction: Boolean read GetInTransaction;
    property DataSets[AIndex: Integer]: TADDataSet read GetDataSet;
    property CommandCount: Integer read GetCommandCount;
    property Commands[AIndex: Integer]: TADCustomCommand read GetCommands;
    property ConnectionIntf: IADPhysConnection read FConnectionIntf;
    property OptionsIntf: IADStanOptions read FOptionsIntf;
    property ConnectionDefName: string read GetConnectionDefName write SetConnectionDefName stored False;
    property DriverName: string read GetDriverName write SetDriverName stored False;
    property ConnectionName: String read FConnectionName write SetConnectionName;
    property Params: TStrings read GetParams write SetParams;
    property FetchOptions: TADFetchOptions read FFetchOptions write SetFetchOptions;
    property FormatOptions: TADFormatOptions read FFormatOptions write SetFormatOptions;
    property UpdateOptions: TADUpdateOptions read FUpdateOptions write SetUpdateOptions;
    property ResourceOptions: TADResourceOptions read FResourceOptions write SetResourceOptions;
    property TxOptions: TADTxOptions read FTxOptions write SetTxOptions;
    property Temporary: Boolean read FTemporary write FTemporary default False;
    property ConnectedAtRunTime: TADActiveAtRunTime read FActiveAtRuntime write FActiveAtRuntime default arStandard;
    property Connected: Boolean read GetConnected write SetConnected default False;
    property KeepConnection: Boolean read FKeepConnection write SetKeepConnection default True;
    property LoginPrompt default True;
    property ResultConnectionDef: IADStanConnectionDef read FParams;
    property LoginDialog: IADGUIxLoginDialog read FLoginDialog write SetLoginDialog;
    property OnLogin: TADConnectionLoginEvent read FOnLogin write FOnLogin;
    property OnError: TADErrorEvent read FOnError write FOnError;
    // property TraceFlags: TTraceFlags read GetTraceFlags write SetTraceFlags;
  end;

  TADConnection = class(TADCustomConnection)
  published
    property ConnectionDefName;
    property DriverName;
    property ConnectionName;
    property Params;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property TxOptions;
    property ConnectedAtRunTime;
    property Connected;
    property KeepConnection;
    property LoginDialog;
    property LoginPrompt;
    property OnLogin;
    property OnError;
    property AfterConnect;
    property BeforeConnect;
    property AfterDisconnect;
    property BeforeDisconnect;
  end;

  TADOperationFinishedEvent = procedure (ASander: TObject; AState: TADStanAsyncState;
    AException: Exception) of object;
  TADCustomCommand = class(TComponent, {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADStanOptions, IADStanErrorHandler, IADStanObject, IADStanAsyncHandler)
  private
    FCommandIntf: IADPhysCommand;
    FCommandText: TStrings;
    FConnectionName: String;
    FConnection: TADCustomConnection;
    FFetchOptions: TADFetchOptions;
    FFormatOptions: TADFormatOptions;
    FUpdateOptions: TADTableUpdateOptions;
    FResourceOptions: TADResourceOptions;
    FParams: TADParams;
    FMacros: TADMacros;
    FStreamedActive, FStreamedPrepared: Boolean;
    FSelfChanging: TADChangingKinds;
    FOwner: TADDataSet;
    FRowsAffected: LongInt;
    FOverload: Word;
    FBeforeUnprepare, FBeforePrepare, FAfterUnprepare, FAfterPrepare: TNotifyEvent;
    FBeforeClose, FBeforeOpen, FAfterClose, FAfterOpen: TNotifyEvent;
    FBeforeExecute, FAfterExecute: TNotifyEvent;
    FFixedCommandKind: Boolean;
    FCommandKind: TADPhysCommandKind;
    FBaseObjectName: String;
    FSchemaName: String;
    FCatalogName: String;
    FBindedBy: TADBindedBy;
    FOnError: TADErrorEvent;
    FActiveAtRunTime: TADActiveAtRunTime;
    FCreateIntfDontPrepare: Boolean;
    FOnCommandChanged: TNotifyEvent;
    FOperationFinished: TADOperationFinishedEvent;
    FAfterFetch: TNotifyEvent;
    FBeforeFetch: TNotifyEvent;
    FTableAdapter: TADCustomTableAdapter;
    function GetCommandKind: TADPhysCommandKind;
    function GetState: TADPhysCommandState;
    procedure SetConnection(const AValue: TADCustomConnection);
    procedure SetConnectionName(const AValue: String);
    function GetActive: Boolean;
    procedure SetActive(const AValue: Boolean);
    function IsPS: Boolean;
    function GetPrepared: Boolean;
    procedure SetPrepared(const AValue: Boolean);
    procedure CheckInactive;
    procedure CheckActive;
    procedure SetFetchOptions(const AValue: TADFetchOptions);
    procedure SetFormatOptions(const AValue: TADFormatOptions);
    procedure SetUpdateOptions(const AValue: TADTableUpdateOptions);
    procedure DoSQLChange(ASender: TObject);
    procedure PreprocessSQL(const AQuery: String; AParams: TADParams;
      AMacrosUpd, AMacrosRead: TADMacros; ACreateParams, ACreateMacros,
      AExpandMacros: Boolean; var ACommandKind: TADPhysCommandKind);
    procedure SetCommandText(const AValue: TStrings);
    procedure SetMacros(const AValue: TADMacros);
    procedure SetParams(const AValue: TADParams);
    function IsCNNS: Boolean;
    function IsCNS: Boolean;
    procedure SetOverload(const AValue: Word);
    procedure CheckUnprepared;
    procedure CheckAsyncProgress;
    procedure CheckPrepared;
    procedure SetCommandKind(const AValue: TADPhysCommandKind);
    procedure SetBaseObjectName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
    function CheckComponentState(AState: TComponentState): Boolean;
    procedure SetCatalogName(const AValue: String);
    procedure MacrosChanged(ASender: TObject);
    procedure PropertyChange;
    procedure SetParamBindMode(const AValue: TADParamBindMode);
    procedure InternalCloseConnection;
    procedure InternalOpenConnectionAndLock;
    function GetConnectionMetadata: IADPhysConnectionMetadata;
    procedure SetResourceOptions(const AValue: TADResourceOptions);
    procedure FetchFinished(ASender: TObject; AState: TADStanAsyncState;
      AException: Exception);
    procedure ReadMacros(Reader: TReader);
    procedure ReadParams(Reader: TReader);
    procedure WriteMacros(Writer: TWriter);
    procedure WriteParams(Writer: TWriter);
    function GetParamBindMode: TADParamBindMode;
    function IsCKS: Boolean;
    function GetParamsOwner: TPersistent;
  protected
    { IADStanObject }
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    { IADStanOptions }
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADUpdateOptions;
    function GetResourceOptions: TADResourceOptions;
    function GetParentOptions(out AOpts: IADStanOptions): Boolean;
    { IADStanErrorHandler }
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    { IADStanAsyncHandler }
    procedure HandleFinished(const AInitiator: IADStanObject;
      AState: TADStanAsyncState; AException: Exception); virtual;
    // other
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure DefineProperties(AFiler: TFiler); override;
    // own
    function InternalCreateCommandIntf: IADPhysCommand; virtual;
    procedure InternalPrepare; virtual;
    procedure InternalUnprepare; virtual;
    procedure InternalOpen; virtual;
    procedure InternalOpenFinished(ASender: TObject; AState: TADStanAsyncState;
      AException: Exception); virtual;
    procedure InternalClose(AAll: Boolean); virtual;
    procedure InternalExecute(ATimes: Integer; AOffset: Integer); virtual;
    procedure InternalExecuteFinished(ASender: TObject; AState: TADStanAsyncState;
      AException: Exception); virtual;
    procedure DoBeforePrepare; virtual;
    procedure DoBeforeUnprepare; virtual;
    procedure DoAfterPrepare; virtual;
    procedure DoAfterUnprepare; virtual;
    procedure DoBeforeOpen; virtual;
    procedure DoBeforeClose; virtual;
    procedure DoAfterOpen; virtual;
    procedure DoAfterClose; virtual;
    procedure DoAfterExecute; virtual;
    procedure DoBeforeExecute; virtual;
    procedure DoAfterFetch; virtual;
    procedure DoBeforeFetch; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetConnection(ACheck: Boolean): TADCustomConnection;
    function OpenConnection: TADCustomConnection;
    procedure CloseConnection(var AConnection: TADCustomConnection);
    procedure FillParams(AParams: TADParams; const ASQL: String);
    function FindParam(const AValue: string): TADParam;
    function ParamByName(const AValue: string): TADParam;
    function FindMacro(const AValue: string): TADMacro;
    function MacroByName(const AValue: string): TADMacro;

    procedure AbortJob(AWait: Boolean = False);
    procedure Disconnect(AAbortJob: Boolean = False);
    procedure Prepare(const ACommandText: String = '');
    procedure Unprepare;
    procedure Open;
    procedure Close;
    procedure CloseAll;
    procedure NextRecordSet;
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0);
    function Define(ASchema: TADDatSManager; ATable: TADDatSTable = nil;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    function Define(ATable: TADDatSTable;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    procedure Fetch(ATable: TADDatSTable; AAll: Boolean); overload;

    property BindedBy: TADBindedBy read FBindedBy;
    property CommandIntf: IADPhysCommand read FCommandIntf;
    property RowsAffected: LongInt read FRowsAffected;
    property State: TADPhysCommandState read GetState;

    property FormatOptions: TADFormatOptions read FFormatOptions write SetFormatOptions;
    property FetchOptions: TADFetchOptions read FFetchOptions write SetFetchOptions;
    property ResourceOptions: TADResourceOptions read FResourceOptions write SetResourceOptions;
    property UpdateOptions: TADTableUpdateOptions read FUpdateOptions write SetUpdateOptions;

    property Connection: TADCustomConnection read FConnection write SetConnection stored IsCNS;
    property ConnectionName: String read FConnectionName write SetConnectionName stored IsCNNS;
    property CatalogName: String read FCatalogName write SetCatalogName;
    property SchemaName: String read FSchemaName write SetSchemaName;
    property BaseObjectName: String read FBaseObjectName write SetBaseObjectName;
    property Overload: Word read FOverload write SetOverload default 0;
    property Macros: TADMacros read FMacros write SetMacros stored False;
    property Params: TADParams read FParams write SetParams stored False;
    property ParamBindMode: TADParamBindMode read GetParamBindMode
      write SetParamBindMode default pbByName;
    property FixedCommandKind: Boolean read FFixedCommandKind write FFixedCommandKind;
    property CommandKind: TADPhysCommandKind read GetCommandKind write SetCommandKind
      stored IsCKS default skUnknown;
    property CommandText: TStrings read FCommandText write SetCommandText;

    property ActiveAtRunTime: TADActiveAtRunTime read FActiveAtRunTime write FActiveAtRunTime default arStandard;
    property Prepared: Boolean read GetPrepared write SetPrepared stored IsPS default False;
    property Active: Boolean read GetActive write SetActive default False;

    property BeforePrepare: TNotifyEvent read FBeforePrepare write FBeforePrepare;
    property AfterPrepare: TNotifyEvent read FAfterPrepare write FAfterPrepare;
    property AfterUnprepare: TNotifyEvent read FAfterUnprepare write FAfterUnprepare;
    property BeforeUnprepare: TNotifyEvent read FBeforeUnprepare write FBeforeUnprepare;
    property BeforeExecute: TNotifyEvent read FBeforeExecute write FBeforeExecute;
    property AfterExecute: TNotifyEvent read FAfterExecute write FAfterExecute;
    property BeforeClose: TNotifyEvent read FBeforeClose write FBeforeClose;
    property AfterClose: TNotifyEvent read FAfterClose write FAfterClose;
    property BeforeOpen: TNotifyEvent read FBeforeOpen write FBeforeOpen;
    property AfterOpen: TNotifyEvent read FAfterOpen write FAfterOpen;
    property BeforeFetch: TNotifyEvent read FBeforeFetch write FBeforeFetch;
    property AfterFetch: TNotifyEvent read FAfterFetch write FAfterFetch;
    property OnError: TADErrorEvent read FOnError write FOnError;
    property OnCommandChanged: TNotifyEvent read FOnCommandChanged write FOnCommandChanged;
  end;

  TADCommand = class(TADCustomCommand)
  published
    property ConnectionName;
    property Connection;
    property CatalogName;
    property SchemaName;
    property BaseObjectName;
    property Overload;
    property Params;
    property Macros;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property CommandKind;
    property CommandText;
    property ActiveAtRunTime;
    property Prepared;
    property Active;
    property BeforeClose;
    property BeforeOpen;
    property AfterClose;
    property AfterOpen;
    property BeforeUnprepare;
    property BeforePrepare;
    property AfterUnprepare;
    property AfterPrepare;
    property BeforeExecute;
    property AfterExecute;
    property OnError;
    property OnCommandChanged;
  end;

  TADMetaInfoCommand = class(TADCustomCommand)
  private
    FWildcard: String;
    FMetaInfoKind: TADPhysMetaInfoKind;
    FTableKinds: TADPhysTableKinds;
    FObjectScopes: TADPhysObjectScopes;
    procedure SetMetaInfoKind(const AValue: TADPhysMetaInfoKind);
    procedure SetTableKinds(const AValue: TADPhysTableKinds);
    procedure SetWildcard(const AValue: String);
    function GetObjectName: String;
    procedure SetObjectName(const AValue: String);
    procedure SetObjectScopes(const AValue: TADPhysObjectScopes);
  protected
    function InternalCreateCommandIntf: IADPhysCommand; override;
    procedure InternalPrepare; override;
    procedure DoAfterClose; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ActiveAtRunTime;
    property Active;
    property ConnectionName;
    property Connection;
    property FormatOptions;
    property Overload;
    property ObjectName: String read GetObjectName write SetObjectName;
    property MetaInfoKind: TADPhysMetaInfoKind read FMetaInfoKind
      write SetMetaInfoKind default mkTables;
    property TableKinds: TADPhysTableKinds read FTableKinds
      write SetTableKinds default [tkSynonym, tkTable, tkView];
    property Wildcard: String read FWildcard write SetWildcard;
    property ObjectScopes: TADPhysObjectScopes read FObjectScopes
      write SetObjectScopes default [osMy];
    property CatalogName;
    property SchemaName;
    property BaseObjectName;
    property BeforeClose;
    property BeforeOpen;
    property AfterClose;
    property AfterOpen;
    property OnError;
    property OnCommandChanged;
  end;

  TADCustomTableAdapter = class(TComponent, {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADStanErrorHandler, IADDAptUpdateHandler, IADPhysDescribeHandler)
  private
    FTableAdapterIntf: IADDAptTableAdapter;
    FTableAdapterOwned: Boolean;
    FSelectCommand: TADCustomCommand;
    FInsertCommand: TADCustomCommand;
    FUpdateCommand: TADCustomCommand;
    FDeleteCommand: TADCustomCommand;
    FLockCommand: TADCustomCommand;
    FUnLockCommand: TADCustomCommand;
    FFetchRowCommand: TADCustomCommand;
    FOnError: TADErrorEvent;
    FOnReconcileRow: TADReconcileRowEvent;
    FOnUpdateRow: TADUpdateRowEvent;
    FSchemaAdapter: TADCustomSchemaAdapter;
    FOnDescribeColumn: TADDescribeColumnEvent;
    FOnDescribeTable: TADDescribeTableEvent;
    FAdaptedDataSet: TADAdaptedDataSet;

    procedure SetDeleteCommand(const AValue: TADCustomCommand);
    procedure SetFetchRowCommand(const AValue: TADCustomCommand);
    procedure SetInsertCommand(const AValue: TADCustomCommand);
    procedure SetLockCommand(const AValue: TADCustomCommand);
    procedure SetSelectCommand(const AValue: TADCustomCommand);
    procedure SetUnLockCommand(const AValue: TADCustomCommand);
    procedure SetUpdateCommand(const AValue: TADCustomCommand);
    procedure UpdateAdapterCmds(ACmds: TADPhysRequests);
    procedure SetAdapterCmd(const ACmd: IADPhysCommand;
      ACmdKind: TADPhysRequest);
    procedure SetCommand(var AVar: TADCustomCommand;
      const AValue: TADCustomCommand; ACmdKind: TADPhysRequest);
    function GetDatSTable: TADDatSTable;
    function GetDatSTableName: String;
    function GetMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
    function GetSourceRecordSetID: Integer;
    function GetSourceRecordSetName: String;
    function GetUpdateTableName: String;
    procedure SetDatSTable(const AValue: TADDatSTable);
    procedure SetDatSTableName(const AValue: String);
    procedure SetMetaInfoMergeMode(const AValue: TADPhysMetaInfoMergeMode);
    procedure SetSourceRecordSetID(const AValue: Integer);
    procedure SetSourceRecordSetName(const AValue: String);
    procedure SetUpdateTableName(const AValue: String);
    function GetColumnMappings: TADDAptColumnMappings;
    procedure SetSchemaAdapter(const AValue: TADCustomSchemaAdapter);
    function IsSRSNS: Boolean;
    function GetCommand(ACmdKind: TADPhysRequest): TADCustomCommand;
    procedure SetTableAdapterIntf(const AAdapter: IADDAptTableAdapter;
      AOwned: Boolean);
    procedure SetColumnMappings(const AValue: TADDAptColumnMappings);
    function IsDTNS: Boolean;
    function IsUTNS: Boolean;
    function IsCMS: Boolean;
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(AValue: TADDatSManager);

  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    // IADDAptUpdateHandler
    procedure ReconcileRow(ARow: TADDatSRow; var AAction: TADDAptReconcileAction); virtual;
    procedure UpdateRow(ARow: TADDatSRow; ARequest: TADPhysUpdateRequest;
      AUpdRowOptions: TADPhysUpdateRowOptions; var AAction: TADErrorAction); virtual;
    // IADPhysDescribeHandler
    procedure DescribeColumn(AColumn: TADDatSColumn; var AAttrs: TADDataAttributes;
      var AOptions: TADDataOptions; var AObjName: String);
    procedure DescribeTable(ATable: TADDatSTable; var AObjName: String);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Define: TADDatSTable;
    procedure Fetch(AAll: Boolean = False); overload;
    function Update(AMaxErrors: Integer = -1): Integer; overload;
    function Reconcile: Boolean;
    procedure Reset;

    procedure Fetch(ARow: TADDatSRow; var AAction: TADErrorAction;
      AColumn: Integer; ARowOptions: TADPhysFillRowOptions); overload;
    procedure Update(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADPhysUpdateRowOptions = []; AForceRequest: TADPhysRequest = arFromRow); overload;
    procedure Lock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADPhysUpdateRowOptions = []);
    procedure UnLock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADPhysUpdateRowOptions = []);

    property SchemaAdapter: TADCustomSchemaAdapter read FSchemaAdapter
      write SetSchemaAdapter;

    property SourceRecordSetName: String read GetSourceRecordSetName
      write SetSourceRecordSetName stored IsSRSNS;
    property SourceRecordSetID: Integer read GetSourceRecordSetID
      write SetSourceRecordSetID default -1;
    property UpdateTableName: String read GetUpdateTableName write SetUpdateTableName
      stored IsUTNS;
    property DatSTableName: String read GetDatSTableName write SetDatSTableName
      stored IsDTNS;
    property DatSTable: TADDatSTable read GetDatSTable write SetDatSTable;
    property MetaInfoMergeMode: TADPhysMetaInfoMergeMode read GetMetaInfoMergeMode
      write SetMetaInfoMergeMode default mmReset;
    property DatSManager: TADDatSManager read GetDatSManager write SetDatSManager;

    property TableAdapterIntf: IADDAptTableAdapter read FTableAdapterIntf;
    property ColumnMappings: TADDAptColumnMappings read GetColumnMappings
      write SetColumnMappings stored IsCMS;

    property SelectCommand: TADCustomCommand read FSelectCommand
      write SetSelectCommand;
    property InsertCommand: TADCustomCommand read FInsertCommand
      write SetInsertCommand;
    property UpdateCommand: TADCustomCommand read FUpdateCommand
      write SetUpdateCommand;
    property DeleteCommand: TADCustomCommand read FDeleteCommand
      write SetDeleteCommand;
    property LockCommand: TADCustomCommand read FLockCommand
      write SetLockCommand;
    property UnLockCommand: TADCustomCommand read FUnLockCommand
      write SetUnLockCommand;
    property FetchRowCommand: TADCustomCommand read FFetchRowCommand
      write SetFetchRowCommand;

    property OnError: TADErrorEvent read FOnError write FOnError;
    property OnReconcileRow: TADReconcileRowEvent read FOnReconcileRow
      write FOnReconcileRow;
    property OnUpdateRow: TADUpdateRowEvent read FOnUpdateRow
      write FOnUpdateRow;
    property OnDescribeColumn: TADDescribeColumnEvent read FOnDescribeColumn
      write FOnDescribeColumn;
    property OnDescribeTable: TADDescribeTableEvent read FOnDescribeTable
      write FOnDescribeTable;
  end;

  TADTableAdapter = class(TADCustomTableAdapter)
  published
    property SchemaAdapter;
    property SourceRecordSetName;
    property SourceRecordSetID;
    property UpdateTableName;
    property DatSTableName;
    property MetaInfoMergeMode;
    property SelectCommand;
    property InsertCommand;
    property UpdateCommand;
    property DeleteCommand;
    property LockCommand;
    property UnLockCommand;
    property FetchRowCommand;
    property ColumnMappings;
    property OnError;
    property OnReconcileRow;
    property OnUpdateRow;
    property OnDescribeColumn;
    property OnDescribeTable;
  end;

  TADCustomSchemaAdapter = class(TComponent, IUnknown,
    IADStanErrorHandler, IADDAptUpdateHandler)
  private
    FDAptSchemaAdapter: IADDAptSchemaAdapter;
    FOnError: TADErrorEvent;
    FOnReconcileRow: TADReconcileRowEvent;
    FOnUpdateRow: TADUpdateRowEvent;
    function GetTableAdaptersIntf: IADDAptTableAdapters;
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(const AValue: TADDatSManager);
  protected
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    // IADDAptUpdateHandler
    procedure ReconcileRow(ARow: TADDatSRow; var AAction: TADDAptReconcileAction); virtual;
    procedure UpdateRow(ARow: TADDatSRow; ARequest: TADPhysUpdateRequest;
      AUpdRowOptions: TADPhysUpdateRowOptions; var AAction: TADErrorAction); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Update(AMaxErrors: Integer = -1): Integer;
    function Reconcile: Boolean;

    property DatSManager: TADDatSManager read GetDatSManager write SetDatSManager;
    property TableAdaptersIntf: IADDAptTableAdapters read GetTableAdaptersIntf;

    property OnError: TADErrorEvent read FOnError write FOnError;
    property OnReconcileRow: TADReconcileRowEvent read FOnReconcileRow
      write FOnReconcileRow;
    property OnUpdateRow: TADUpdateRowEvent read FOnUpdateRow
      write FOnUpdateRow;
  end;

  TADSchemaAdapter = class(TADCustomSchemaAdapter)
  published
    property OnError;
    property OnReconcileRow;
    property OnUpdateRow;
  end;

  TADCustomUpdateObject = class(TADComponent)
  private
    FDataSet: TADAdaptedDataSet;
    procedure SetDataSet(const AValue: TADAdaptedDataSet);
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure AttachToAdapter; virtual; abstract;
    procedure DetachFromAdapter; virtual; abstract;
  public
    procedure Apply(ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction;
      AOptions: TADPhysUpdateRowOptions); virtual; abstract;
    property DataSet: TADAdaptedDataSet read FDataSet write SetDataSet;
  end;

  TADAdaptedDataSet = class(TADDataSet)
  private
    FAdapter: TADCustomTableAdapter;
    FDatSManager: TADDatSManager;
    FUpdateObject: TADCustomUpdateObject;
    FServerEditRow: TADDatSRow;
    FServerEditRequest: TADPhysRequest;
    FVclParams: TParams;
    FOnExecuteError: TADExecuteErrorEvent;
    FOnError: TADErrorEvent;
    FUnpreparing: Boolean;
    FForcePropertyChange: Boolean;
    procedure SetUpdateObject(const AValue: TADCustomUpdateObject);
    procedure InternalServerEdit(AServerEditRequest: TADPhysUpdateRequest);
    function GetConnection(ACheck: Boolean): TADCustomConnection;
    function GetPointedConnection: TADCustomConnection;
    procedure InternalUpdateErrorHandler(ASender: TObject;
      const AInitiator: IADStanObject; var AException: Exception);
    procedure InternalReconcileErrorHandler(ASender: TObject; ARow: TADDatSRow;
      var AAction: TADDAptReconcileAction);
    function GetCommand: TADCustomCommand;
    procedure InternalDescribeColumn(ASender: TObject; AColumn: TADDatSColumn;
      var AAttrs: TADDataAttributes; var AOptions: TADDataOptions; var AObjName: String);
    procedure InternalDescribeTable(ASender: TObject; ATable: TADDatSTable;
      var AObjName: String);
    procedure InternalUpdateRecordHandler(ASender: TObject;
      ARow: TADDatSRow; ARequest: TADPhysUpdateRequest;
      AOptions: TADPhysUpdateRowOptions; var AAction: TADErrorAction);
    procedure SetDatSManager(AManager: TADDatSManager);
  protected
    // TComponent
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    // TDataSet
    procedure InternalClose; override;
    // TADDataSet
    procedure DoDefineDatSManager; override;
    procedure DoOpenSource(AAsyncQuery, AInfoQuery, AStructQuery: Boolean); override;
    function DoIsSourceOpen: Boolean; override;
    procedure DoPrepareSource; override;
    procedure DoUnprepareSource; override;
    function DoApplyUpdates(ATable: TADDatSTable; AMaxErrors: Integer): Integer; override;
    function DoFetch(ATable: TADDatSTable; AAll: Boolean): Integer; overload; override;
    function DoFetch(ARow: TADDatSRow; AColumn: Integer;
      ARowOptions: TADPhysFillRowOptions): Boolean; overload; override;
    procedure DoMasterDefined; override;
    procedure DoMasterSetValues(AMasterFieldList: TList); override;
    function DoMasterDependent(AMasterFieldList: TList): Boolean; override;
    procedure DoCloseSource; override;
    procedure DoResetDatSManager; override;
    function DoGetDatSManager: TADDatSManager; override;
    procedure DoProcessUpdateRequest(ARequest: TADPhysUpdateRequest;
      AOptions: TADPhysUpdateRowOptions); override;
    procedure DoExecuteSource(ATimes, AOffset: Integer); override;
    procedure DoCloneCursor(AReset, AKeepSettings: Boolean); override;
    function GetParams: TADParams; override;
    function GetFetchOptions: TADFetchOptions; override;
    function GetFormatOptions: TADFormatOptions; override;
    function GetUpdateOptions: TADUpdateOptions; override;
    function GetResourceOptions: TADResourceOptions; override;
    property UpdateObject: TADCustomUpdateObject read FUpdateObject
      write SetUpdateObject;
    // IProviderSupport
    function PSInTransaction: Boolean; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    procedure PSStartTransaction; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    procedure PSEndTransaction(Commit: Boolean); {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSIsSQLBased: Boolean; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSIsSQLSupported: Boolean; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSGetQuoteChar: string; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSGetParams: TParams; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    procedure PSSetParams(AParams: TParams); {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    procedure PSSetCommandText(const CommandText: string); {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function PSExecuteStatement(const ASQL: string; AParams: TParams;
      ResultSet: Pointer = nil): Integer; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    procedure PSGetAttributes(List: TList); {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    // own
    procedure SetAdapter(AAdapter: TADCustomTableAdapter); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure NextRecordSet;
    procedure AbortJob(AWait: Boolean = False);
    procedure Disconnect(AAbortJob: Boolean = False); override;
    procedure ServerAppend;
    procedure ServerEdit;
    procedure ServerDelete;
    procedure ServerPerform;
    procedure ServerCancel;
    procedure ServerDeleteAll(ANoUndo: Boolean = False);
    procedure ServerSetKey;
    function ServerGotoKey: Boolean;
    property Adapter: TADCustomTableAdapter read FAdapter;
    property DatSManager write SetDatSManager;
    property Command: TADCustomCommand read GetCommand;
    property PointedConnection: TADCustomConnection read GetPointedConnection;
    property ServerEditRequest: TADPhysRequest read FServerEditRequest;
    property OnExecuteError: TADExecuteErrorEvent read FOnExecuteError
      write FOnExecuteError;
    property OnError: TADErrorEvent read FOnError write FOnError;
  end;

  TADCustomClientDataSet = class(TADAdaptedDataSet, IADStanOptions)
  private
    FFetchOptions: TADFetchOptions;
    FFormatOptions: TADFormatOptions;
    FUpdateOptions: TADTableUpdateOptions;
    FResourceOptions: TADResourceOptions;
    procedure CreateOptions;
    procedure FreeOptions;
    procedure CheckCreateOptions;
  protected
    FStoreDefs: Boolean;
    procedure SetAdapter(AValue: TADCustomTableAdapter); override;
    property StoreDefs: Boolean read FStoreDefs write FStoreDefs default False;
    // IADStanOptions
    function GetFetchOptions: TADFetchOptions; override;
    function GetFormatOptions: TADFormatOptions; override;
    function GetUpdateOptions: TADUpdateOptions; override;
    function GetResourceOptions: TADResourceOptions; override;
    function GetParentOptions(out AOpts: IADStanOptions): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Adapter write SetAdapter;
  end;

  TADClientDataSet = class(TADCustomClientDataSet)
  published
    property ActiveAtRunTime;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
{$IFNDEF AnyDAC_FPC}
    property ObjectView default True;
{$ENDIF}
    property Constraints;
    property DataSetField;
    property FieldDefs stored FStoreDefs;
    { TADDataSet }
    property CachedUpdates;
    property IndexDefs stored FStoreDefs;
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property ConstraintsEnabled;
    property MasterSource;
    property MasterFields;
    property OnUpdateRecord;
    property OnUpdateError;
    property OnReconcileError;
    property Unidirectional;
    property BeforeApplyUpdates;
    property AfterApplyUpdates;
    property BeforeGetRecords;
    property AfterGetRecords;
    property BeforeRowRequest;
    property AfterRowRequest;
    property BeforeExecute;
    property AfterExecute;
    property BeforeGetParams;
    property AfterGetParams;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property UpdateRecordTypes;
    { TADCustomClientDataSet }
    property Adapter;
    property StoreDefs;
  end;

  TADRdbmsDataSet = class(TADAdaptedDataSet)
  private
    FStreamedPrepared: Boolean;
    function GetConnection: TADCustomConnection;
    function GetConnectionName: String;
    procedure SetConnection(const AValue: TADCustomConnection);
    procedure SetConnectionName(const AValue: String);
    function GetPrepared: Boolean;
    procedure SetPrepared(const AValue: Boolean);
    function IsCNNS: Boolean;
    function IsCNS: Boolean;
    function GetOnError: TADErrorEvent;
    procedure SetOnError(const AValue: TADErrorEvent);
    function GetParamBindMode: TADParamBindMode;
    procedure SetParamBindMode(const AValue: TADParamBindMode);
    function GetOnCommandChanged: TNotifyEvent;
    procedure SetOnCommandChanged(const AValue: TNotifyEvent);
    function GetMacrosCount: Word;
    function GetMacros: TADMacros;
    procedure SetMacros(const AValue: TADMacros);
    function IsPS: Boolean;
    function GetRowsAffected: Integer;
  protected
    procedure Loaded; override;
    procedure DefineProperties(AFiler: TFiler); override;
    // TDataSet
    procedure InternalClose; override;
    procedure OpenCursor(InfoQuery: Boolean); override;
    // other
    procedure CheckCachedUpdatesMode; override;
    function InternalCreateAdapter: TADCustomTableAdapter; virtual;
    // props
    property ParamBindMode: TADParamBindMode read GetParamBindMode write SetParamBindMode default pbByName;
    property Macros: TADMacros read GetMacros write SetMacros stored False;
    property MacroCount: Word read GetMacrosCount;
    property RowsAffected: Integer read GetRowsAffected;
    property Prepared: Boolean read GetPrepared write SetPrepared stored IsPS default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Disconnect(AAbortJob: Boolean = False); override;
    procedure Prepare;
    procedure Unprepare;
    function MacroByName(const AValue: string): TADMacro;
    function FindMacro(const AValue: string): TADMacro;
    property ConnectionName: String read GetConnectionName write SetConnectionName stored IsCNNS;
    property Connection: TADCustomConnection read GetConnection write SetConnection stored IsCNS;
    property OnError: TADErrorEvent read GetOnError write SetOnError;
    property OnCommandChanged: TNotifyEvent read GetOnCommandChanged write SetOnCommandChanged;
  end;

  TADUpdateSQL = class(TADCustomUpdateObject)
  private
    FCommands: array [0 .. 5] of TADCustomCommand;
    FConnectionName: String;
    FConnection: TADCustomConnection;
    function GetSQL(const AIndex: Integer): TStrings;
    procedure SetSQL(const AIndex: Integer; const AValue: TStrings);
    function GetCommand(ARequest: TADPhysUpdateRequest): TADCustomCommand;
    function GetURSQL(ARequest: TADPhysUpdateRequest): TStrings;
    procedure SetURSQL(ARequest: TADPhysUpdateRequest; const Value: TStrings);
    procedure SetConnection(const Value: TADCustomConnection);
    procedure SetConnectionName(const Value: String);
    procedure UpdateAdapter;
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure AttachToAdapter; override;
    procedure DetachFromAdapter; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Apply(ARequest: TADPhysUpdateRequest; var AAction: TADErrorAction;
      AOptions: TADPhysUpdateRowOptions); override;
    property Commands[ARequest: TADPhysUpdateRequest]: TADCustomCommand read GetCommand;
    property SQL[ARequest: TADPhysUpdateRequest]: TStrings read GetURSQL write SetURSQL;
  published
    property Connection: TADCustomConnection read FConnection write SetConnection;
    property ConnectionName: String read FConnectionName write SetConnectionName;
    property InsertSQL: TStrings index 0 read GetSQL write SetSQL;
    property ModifySQL: TStrings index 1 read GetSQL write SetSQL;
    property DeleteSQL: TStrings index 2 read GetSQL write SetSQL;
    property LockSQL: TStrings index 3 read GetSQL write SetSQL;
    property UnlockSQL: TStrings index 4 read GetSQL write SetSQL;
    property FetchRowSQL: TStrings index 5 read GetSQL write SetSQL;
  end;

  TADCustomQuery = class(TADRdbmsDataSet)
  private
    procedure SetSQL(const AValue: TStrings);
    function GetSQL: TStrings;
    function GetText: String;
    function GetDS: TDataSource;
    procedure SetDS(const AValue: TDataSource);
  protected
    procedure UpdateRecordCount; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExecSQL;
    property SQL: TStrings read GetSQL write SetSQL;
    property Text: String read GetText;
    property DataSource: TDataSource read GetDS write SetDS;
    property ParamCount;
  end;

  TADQuery = class(TADCustomQuery)
  public
    property RowsAffected;
    property MacroCount;
  published
    property ActiveAtRunTime;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
{$IFNDEF AnyDAC_FPC}
    property ObjectView default True;
{$ENDIF}
    property Constraints;
    { TADDataSet }
    property CachedUpdates;
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property UpdateRecordTypes;
    property ConstraintsEnabled;
    property OnUpdateRecord;
    property OnUpdateError;
    property OnReconcileError;
    property Unidirectional;
    { TADRdbmsDataSet }
    property ConnectionName;
    property Connection;
    property Params;
    property Prepared;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property UpdateObject;
    property OnError;
    property OnCommandChanged;
    // -- Constrained
    { TADCustomQuery }
    property SQL;
    property Macros;
    property DataSource;
  end;

  TADTable = class(TADCustomQuery)
  private
    FTableName: String;
    FExclusive: Boolean;
    FCatalogName: String;
    FSchemaName: String;
    procedure SetTableName(const AValue: String);
    procedure GenerateSQL;
    procedure RefireSQL;
    procedure SetCatalogName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
    procedure AfterUnprepare(ASender: TObject);
  protected
    procedure DoOnNewRecord; override;
    procedure DoMasterReset; override;
    procedure DoMasterSetValues(AMasterFieldList: TList); override;
    procedure MasterChanged(Sender: TObject); override;
    procedure DoSortOrderChanged; override;
    procedure OpenCursor(AInfoQuery: Boolean); override;
    // IProviderSupport
    function PSGetTableName: string; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    procedure PSSetCommandText(const ACommandText: string); {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ActiveAtRunTime;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
{$IFNDEF AnyDAC_FPC}
    property ObjectView default True;
{$ENDIF}
    property Constraints;
    { TADDataSet }
    property CachedUpdates;
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property MasterSource;
    property MasterFields;
    property Aggregates;
    property AggregatesActive;
    property UpdateRecordTypes;
    property ConstraintsEnabled;
    property Unidirectional;
    property OnUpdateRecord;
    property OnUpdateError;
    property OnReconcileError;
    { TADRdbmsDataSet }
    property ConnectionName;
    property Connection;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property UpdateObject;
    property OnError;
    property OnCommandChanged;
    { TADTable }
    property Exclusive: Boolean read FExclusive write FExclusive default False;
    property CatalogName: String read FCatalogName write SetCatalogName;
    property SchemaName: String read FSchemaName write SetSchemaName;
    property TableName: String read FTableName write SetTableName;
  end;

  TADCustomStoredProc = class(TADRdbmsDataSet)
  private
    procedure SetOverload(const AValue: Word);
    procedure SetProcName(const AValue: string);
    function GetOverload: Word;
    function GetProcName: string;
    function GetPackageName: String;
    function GetSchemaName: String;
    procedure SetPackageName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
    procedure ProcNameChanged;
    function GetCatalogName: String;
    procedure SetCatalogName(const AValue: String);
  protected
    function InternalCreateAdapter: TADCustomTableAdapter; override;
  public
    function DescriptionsAvailable: Boolean;
    procedure ExecProc;
    procedure GetResults;
    property CatalogName: String read GetCatalogName write SetCatalogName;
    property SchemaName: String read GetSchemaName write SetSchemaName;
    property PackageName: String read GetPackageName write SetPackageName;
    property StoredProcName: string read GetProcName write SetProcName;
    property Overload: Word read GetOverload write SetOverload default 0;
    property ParamCount;
    property RowsAffected;
  end;

  TADStoredProc = class(TADCustomStoredProc)
  published
    property ActiveAtRunTime;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
{$IFNDEF AnyDAC_FPC}
    property ObjectView default True;
{$ENDIF}
    property Constraints;
    { TADDataSet }
    property CachedUpdates;
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property UpdateRecordTypes;
    property ConstraintsEnabled;
    property OnUpdateRecord;
    property OnUpdateError;
    property OnReconcileError;
    { TADRdbmsDataSet }
    property ConnectionName;
    property Connection;
    property Params;
    property Prepared;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property UpdateObject;
    property Unidirectional;
    property OnError;
    property OnCommandChanged;
    property ParamBindMode;
    // -- Constrained
    { TADCustomStoredProc }
    property CatalogName;
    property SchemaName;
    property PackageName;
    property StoredProcName;
    property Overload;
  end;

  TADMetaInfoQuery = class(TADRdbmsDataSet)
  private
    function GetMetaInfoKind: TADPhysMetaInfoKind;
    function GetObjectName: String;
    function GetTableKinds: TADPhysTableKinds;
    function GetWildcard: String;
    procedure SetMetaInfoKind(const AValue: TADPhysMetaInfoKind);
    procedure SetObjectName(const AValue: String);
    procedure SetTableKinds(const AValue: TADPhysTableKinds);
    procedure SetWildcard(const AValue: String);
    function GetOverload: Word;
    procedure SetOverload(const AValue: Word);
    procedure SetObjectScopes(const AValue: TADPhysObjectScopes);
    function GetObjectScopes: TADPhysObjectScopes;
    function GetBaseObjectName: String;
    function GetSchemaName: String;
    procedure SetBaseObjectName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
    function GetCatalogName: String;
    procedure SetCatalogName(const AValue: String);
  protected
    function InternalCreateAdapter: TADCustomTableAdapter; override;
  published
    property ActiveAtRunTime;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
    { TADDataSet }
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property Unidirectional;
    { TADRdbmsDataSet }
    property ConnectionName;
    property Connection;
    property FetchOptions;
    property FormatOptions;
    property OnError;
    property OnCommandChanged;
    { Introduced }
    property MetaInfoKind: TADPhysMetaInfoKind read GetMetaInfoKind
      write SetMetaInfoKind default mkTables;
    property TableKinds: TADPhysTableKinds read GetTableKinds
      write SetTableKinds default [tkSynonym, tkTable, tkView];
    property Wildcard: String read GetWildcard write SetWildcard;
    property ObjectScopes: TADPhysObjectScopes read GetObjectScopes
      write SetObjectScopes default [osMy];
    property CatalogName: String read GetCatalogName write SetCatalogName;
    property SchemaName: String read GetSchemaName write SetSchemaName;
    property BaseObjectName: String read GetBaseObjectName write SetBaseObjectName;
    property Overload: Word read GetOverload write SetOverload default 0;
    property ObjectName: String read GetObjectName write SetObjectName;
  end;

{$IFDEF AnyDAC_Script}
  TADScript = class (TADCustomScriptEngine, {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADStanOptions, IADStanErrorHandler, IADStanObject, IADStanAsyncHandler)
  private
    FSQLScriptFileName: String;
    FSQLScript: TStrings;
    FConnection: TADCustomConnection;
    FFetchOptions: TADFetchOptions;
    FFormatOptions: TADFormatOptions;
    FResourceOptions: TADResourceOptions;
    FOnError: TADErrorEvent;
    FSpool: TStream;
    procedure SetConnection(const AValue: TADCustomConnection);
    procedure SetSQLScript(const AValue: TStrings);
    procedure SetFetchOptions(const Value: TADFetchOptions);
    procedure SetFormatOptions(const Value: TADFormatOptions);
    procedure SetResourceOptions(const Value: TADResourceOptions);
  protected
    { IADStanObject }
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    { IADStanOptions }
    function GetParentOptions(out AOpts: IADStanOptions): Boolean;
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADUpdateOptions;
    function GetResourceOptions: TADResourceOptions;
    { IADStanErrorHandler }
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    { IADStanAsyncHandler }
    procedure HandleFinished(const AInitiator: IADStanObject;
      AState: TADStanAsyncState; AException: Exception); virtual;
    // other
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure ExecuteBase(ARealExecute, AAll: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetStream(const AFileName: String; AOutput: Boolean; var AStream: TStream); override;
    procedure ExecuteAll;
    procedure ExecuteStep;
    procedure Validate;
  published
    property Connection: TADCustomConnection read FConnection write SetConnection;

    property SQLScriptFileName: String read FSQLScriptFileName write FSQLScriptFileName;
    property SQLScript: TStrings read FSQLScript write SetSQLScript;
    property ScriptOptions;

    property FormatOptions: TADFormatOptions read FFormatOptions write SetFormatOptions;
    property FetchOptions: TADFetchOptions read FFetchOptions write SetFetchOptions;
    property ResourceOptions: TADResourceOptions read FResourceOptions write SetResourceOptions;

    property OnHostCommand;
    property OnConsolePut;
    property OnConsoleGet;
    property OnSpoolPut;
    property OnGetStream;
    property OnPause;
    property OnProgress;
    property OnError: TADErrorEvent read FOnError write FOnError;
  end;
{$ENDIF}

function ADManager: TADCustomManager;

implementation

uses
{$IFDEF AnyDAC_D9}
  Windows,
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
  daADStanConst, daADStanError, daADStanDef, daADStanAsync,
    daADStanPool, daADStanExpr, daADStanFactory, daADStanResStrs,         // links Stan layer
{$IFDEF AnyDAC_MONITOR}
  {$IFNDEF AnyDAC_FPC}
  daADMoniIndyClient,
  {$ENDIF}
  daADMoniFlatFile,                                                       // links Moni layer
{$ENDIF}  
  daADDAptManager,                                                        // links DApt layer
  daADPhysManager,                                                        // links Phys layer
    daADPhysCmdPreprocessor, daADPhysScriptCommands;

var
  FManagerSingleton: TADCustomManager = nil;
  FManagerOptsIntf: IADStanOptions = nil;

{-------------------------------------------------------------------------------}
function ADManager: TADCustomManager;
begin
  if FManagerSingleton = nil then begin
    FManagerSingleton := TADManager.Create(nil);
    FManagerSingleton.FAutoCreated := True;
  end;
  Result := FManagerSingleton;
end;

{-------------------------------------------------------------------------------}
{ TADCustomManager                                                              }
{-------------------------------------------------------------------------------}
constructor TADCustomManager.Create(AOwner: TComponent);
var
  oPrevMgr: TADCustomManager;
{$IFNDEF AnyDAC_D6}
  i: Integer;
{$ENDIF}
begin
  if (FManagerSingleton <> nil) and not FManagerSingleton.FAutoCreated then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntSessMBSingle, []);
  FLock := TADMREWSynchronizer.Create;
  FLock.BeginWrite;
  try
    inherited Create(AOwner);
    FConnections := TList.Create;
    FKeepConnections := True;
    FFetchOptions := TADFetchOptions.Create(Self);
    FFormatOptions := TADFormatOptions.Create(Self);
    FFormatOptions.OwnMapRules := True;
    FUpdateOptions := TADUpdateOptions.Create(Self);
    FResourceOptions := TADTopResourceOptions.Create(Self);
    oPrevMgr := FManagerSingleton;
    FManagerSingleton := Self;
    QueryInterface(IADStanOptions, FManagerOptsIntf);
    if oPrevMgr <> nil then begin
{$IFDEF AnyDAC_D6}
      FConnections.Assign(oPrevMgr.FConnections);
{$ELSE}
      FConnections.Clear;
      for i := 0 to oPrevMgr.FConnections.Count - 1 do
        FConnections.Add(oPrevMgr.FConnections[i]);
{$ENDIF}
      oPrevMgr.FConnections.Clear;
      oPrevMgr.Free;
    end;
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
destructor TADCustomManager.Destroy;
begin
  if FLock <> nil then
    FLock.BeginWrite;
  Destroying;
  if FManagerSingleton = Self then begin
    Close;
    FManagerOptsIntf := nil;
    FManagerSingleton := nil;
  end;
  inherited Destroy;
  FreeAndNil(FConnections);
  FreeAndNil(FFetchOptions);
  FreeAndNil(FFormatOptions);
  FreeAndNil(FUpdateOptions);
  FreeAndNil(FResourceOptions);
  FreeAndNil(FLock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.Loaded;
begin
  inherited Loaded;
  try
    if FStreamedActive or (FActiveAtRunTime = arActive) then
      SetActive(True);
  except
    if csDesigning in ComponentState then
      ADHandleException
    else
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.CheckInactive;
begin
  if Active then
    if csDesigning in ComponentState then
      Close
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntSessMBInactive, []);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.CheckActive;
begin
  if not Active then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntSessMBActive, []);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetSilentMode: Boolean;
begin
  Result := FADGUIxSilentMode;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetSilentMode(const AValue: Boolean);
begin
  FADGUIxSilentMode := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetWaitCursor: TADGUIxScreenCursor;
var
  oWait: IADGUIxWaitCursor;
begin
  ADCreateInterface(IADGUIxWaitCursor, oWait);
  Result := oWait.WaitCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetWaitCursor(const AValue: TADGUIxScreenCursor);
var
  oWait: IADGUIxWaitCursor;
begin
  ADCreateInterface(IADGUIxWaitCursor, oWait);
  oWait.WaitCursor := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetFetchOptions: TADFetchOptions;
begin
  Result := FFetchOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetFetchOptions(const AValue: TADFetchOptions);
begin
  FFetchOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetFormatOptions: TADFormatOptions;
begin
  Result := FFormatOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetFormatOptions(const AValue: TADFormatOptions);
begin
  FFormatOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetUpdateOptions: TADUpdateOptions;
begin
  Result := FUpdateOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetUpdateOptions(const AValue: TADUpdateOptions);
begin
  FUpdateOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetResourceOptions: TADResourceOptions;
begin
  Result := FResourceOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetResourceOptions(const AValue: TADResourceOptions);
begin
  FResourceOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetParentOptions(out AOpts: IADStanOptions): Boolean;
begin
  // nothing
  AOpts := nil;
  Result := False;
end;

{-------------------------------------------------------------------------------}
// Phys Manager control

function TADCustomManager.GetActive: Boolean;
begin
  Result := (ADPhysManager <> nil) and (ADPhysManager.State = dmsActive);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetState: TADPhysManagerState;
begin
  if ADPhysManager <> nil then
    Result := ADPhysManager.State
  else
    Result := dmsInactive;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetActive(const AValue: Boolean);
var
  i, iAct: Integer;
begin
  if (csReading in ComponentState) and not (csDesigning in ComponentState) and
     (FActiveAtRunTime <> arStandard) then
    Exit;
  if csReading in ComponentState then
    FStreamedActive := AValue
  else begin
    iAct := 0;
    FLock.BeginRead;
    try
      if Active <> AValue then
        if AValue then begin
          FLock.BeginWrite;
          try;
            CheckInactive;
            if ADPhysManager = nil then
              ADManagerRequired(Self, [S_AD_LComp, S_AD_LComp_PClnt], S_AD_LPhys);
          finally
            FLock.EndWrite;
          end;
          iAct := 1;
        end
        else begin
          FLock.BeginWrite;
          try;
            CheckActive;
            for i := FConnections.Count - 1 downto 0 do
              with TADCustomConnection(FConnections[i]) do
                if Temporary then
                  Free
                else
                  Close;
          finally
            FLock.EndWrite;
          end;
          iAct := -1;
        end;
    finally
      FLock.EndRead;
    end;
    if iAct = 1 then begin
      ADPhysManager.Open;
      if Assigned(FOnStartup) then
        FOnStartup(Self);
    end
    else if iAct = -1 then begin
      ADPhysManager.Close(True);
      if Assigned(FOnShutdown) then
        FOnShutdown(Self);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.Open;
begin
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.Close;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
// Connection management

procedure TADCustomManager.AddConnection(AConn: TADCustomConnection);
begin
  FLock.BeginWrite;
  try
    if FConnections.IndexOf(AConn) = -1 then begin
      FConnections.Add(AConn);
      FreeNotification(AConn);
    end;
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.RemoveConnection(AConn: TADCustomConnection);
begin
  FLock.BeginWrite;
  try
    FConnections.Remove(AConn);
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnectionCount: Integer;
begin
  FLock.BeginRead;
  try;
    Result := FConnections.Count;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnection(AIndex: Integer): TADCustomConnection;
begin
  FLock.BeginRead;
  try;
    Result := FConnections[AIndex];
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.InternalOpenConnection(AConnection: TADCustomConnection;
  const AConnectionName: string): TADCustomConnection;
begin
  if (AConnection = nil) and (AConnectionName = '') then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbNotDefined, []);
  FLock.BeginWrite;
  try
    if AConnection <> nil then
      Result := AConnection
    else begin
      Result := FindConnection(AConnectionName);
      if Result = nil then begin
        Result := TADCustomConnection.Create(Self);
        try
          with Result do begin
            ConnectionName := AConnectionName;
            KeepConnection := FKeepConnections;
            Temporary := True;
          end;
        except
          Result.Free;
          raise;
        end;
      end;
    end;
    if not Result.Connected then
      Result.Open;
    Inc(Result.FRefCount);
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.OpenConnection(const AConnectionName: string): TADCustomConnection;
begin
  Result := InternalOpenConnection(nil, AConnectionName);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.OpenConnection(AConnection: TADCustomConnection): TADCustomConnection;
begin
  Result := InternalOpenConnection(AConnection, '');
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.CloseConnection(var AConnection: TADCustomConnection);
begin
  if AConnection = nil then
    Exit;
  FLock.BeginWrite;
  try
    with AConnection do begin
      if FRefCount > 0 then
        Dec(FRefCount);
      if (FRefCount = 0) and not KeepConnection then
        if not Temporary then
          Close
        else if not (csDestroying in ComponentState) then begin
          Free;
          AConnection := nil;
        end;
    end;
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.DropConnections;
var
  i: Integer;
begin
  FLock.BeginWrite;
  try
    for i := FConnections.Count - 1 downto 0 do
      with TADCustomConnection(FConnections[i]) do
        if Temporary and (FRefCount = 0) then
          Free;
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.FindConnection(const AConnectionName: string): TADCustomConnection;
var
  i: Integer;
  oConn: TADCustomConnection;
begin
  Result := nil;
  for i := 0 to FConnections.Count - 1 do begin
    oConn := FConnections[i];
    if ((oConn.ConnectionName <> '') or oConn.Temporary) and
        ({$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
         (oConn.ConnectionName, AConnectionName) = 0) then begin
      Result := oConn;
      Break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
// Get XXX names

procedure TADCustomManager.GetConnectionNames(AList: TStrings);
var
  i: Integer;
  oNames: TStringList;
begin
  Active := True;
  oNames := TStringList.Create;
  try
    oNames.Sorted := True;
    oNames.Duplicates := dupIgnore;
    oNames.BeginUpdate;
    for i := 0 to ConnectionDefs.Count - 1 do
      oNames.Add(ConnectionDefs[i].Name);
    for i := 0 to FConnections.Count - 1 do
      with TADCustomConnection(FConnections[I]) do
        oNames.Add(ConnectionName);
    AList.Assign(oNames);
  finally
    oNames.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetConnectionDefNames(AList: TStrings);
var
  i: Integer;
  oNames: TStringList;
begin
  Active := True;
  oNames := TStringList.Create;
  try
    oNames.Sorted := True;
    oNames.Duplicates := dupIgnore;
    oNames.BeginUpdate;
    for i := 0 to ConnectionDefs.Count - 1 do
      oNames.Add(ConnectionDefs[i].Name);
    AList.Assign(oNames);
  finally
    oNames.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetDriverNames(AList: TStrings);
var
  oNames: TStringList;
  i: Integer;
  oManMeta: IADPhysManagerMetadata;
begin
  Active := True;
  oNames := TStringList.Create;
  try
    oNames.Sorted := True;
    oNames.Duplicates := dupIgnore;
    oNames.BeginUpdate;
    ADPhysManager.CreateMetadata(oManMeta);
    for i := 0 to oManMeta.DriverCount - 1 do
      oNames.Add(oManMeta.DriverID[i]);
    AList.Assign(oNames);
  finally
    oNames.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetTableNames(const AConnectionName, ACatalogName,
  ASchemaName, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes);
var
  oConn: TADCustomConnection;
begin
  oConn := OpenConnection(AConnectionName);
  try
    oConn.GetTableNames(ACatalogName, ASchemaName, APattern, AList, AScopes);
  finally
    CloseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetFieldNames(const AConnectionName, ACatalogName,
  ASchemaName, ATableName, APattern: string; AList: TStrings);
var
  oConn: TADCustomConnection;
begin
  oConn := OpenConnection(AConnectionName);
  try
    oConn.GetFieldNames(ACatalogName, ASchemaName, ATableName, APattern, AList);
  finally
    CloseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetKeyFieldNames(const AConnectionName, ACatalogName,
  ASchemaName, ATableName, APattern: string; AList: TStrings);
var
  oConn: TADCustomConnection;
begin
  oConn := OpenConnection(AConnectionName);
  try
    oConn.GetKeyFieldNames(ACatalogName, ASchemaName, ATableName, APattern, AList);
  finally
    CloseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetPackageNames(const AConnectionName, ACatalogName,
  ASchemaName, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes);
var
  oConn: TADCustomConnection;
begin
  oConn := OpenConnection(AConnectionName);
  try
    oConn.GetPackageNames(ACatalogName, ASchemaName, APattern, AList, AScopes);
  finally
    CloseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetStoredProcNames(const AConnectionName, ACatalogName,
  ASchemaName, APackage, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes);
var
  oConn: TADCustomConnection;
begin
  oConn := OpenConnection(AConnectionName);
  try
    oConn.GetStoredProcNames(ACatalogName, ASchemaName, APackage, APattern,
      AList, AScopes);
  finally
    CloseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
// Connection definitions

function TADCustomManager.GetConnectionDefs: IADStanConnectionDefs;
begin
  Result := ADPhysManager.ConnectionDefs;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnectionDefFileName: String;
begin
  Result := ConnectionDefs.Storage.ActualFileName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetConnectionDefFileName(const AValue: String);
begin
  ConnectionDefs.Storage.FileName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.IsCDFNS: Boolean;
begin
  Result := (ConnectionDefs.Storage.FileName <> '');
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetAfterLoadConnectionDefFile: TNotifyEvent;
begin
  Result := ConnectionDefs.AfterLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetAfterLoadConnectionDefFile(const AValue: TNotifyEvent);
begin
  ConnectionDefs.AfterLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetBeforeLoadConnectionDefFile: TNotifyEvent;
begin
  Result := ConnectionDefs.BeforeLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetBeforeLoadConnectionDefFile(const AValue: TNotifyEvent);
begin
  ConnectionDefs.BeforeLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnectionDefAutoLoad: Boolean;
begin
  Result := ConnectionDefs.AutoLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetConnectionDefAutoLoad(const AValue: Boolean);
begin
  ConnectionDefs.AutoLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnectionDefsLoaded: Boolean;
begin
  Result := ConnectionDefs.Loaded;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.IsConnectionDef(const AName: String): Boolean;
begin
  Result := (AName <> '') and (ConnectionDefs.FindConnectionDef(AName) <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.AddConnectionDef(const AName, ADriver: string; AList: TStrings);
begin
  with ConnectionDefs.AddConnectionDef do begin
    Params.Assign(AList);
    Name := AName;
    DriverID := ADriver;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.DeleteConnectionDef(const AName: string);
begin
  ConnectionDefs.ConnectionDefByName(AName).Delete;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.ModifyConnectionDef(const AName: string; AList: TStrings);
var
  i: Integer;
  sName, sValue: String;
begin
  with ConnectionDefs.ConnectionDefByName(AName) do
    for i := 0 to AList.Count - 1 do begin
      sName := AList.Names[i];
      sValue := AList.Values[sName];
      AsString[sName] := sValue;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetConnectionDefParams(const AName: string; AList: TStrings);
begin
  AList.Assign(ConnectionDefs.ConnectionDefByName(AName).Params);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SaveConnectionDefFile;
begin
  ConnectionDefs.Save;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.LoadConnectionDefFile;
begin
  ConnectionDefs.Load;
end;

{-------------------------------------------------------------------------------}
{ TADCustomConnection                                                           }
{-------------------------------------------------------------------------------}
constructor TADCustomConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ADCreateInterface(IADStanConnectionDef, FParams);
  FParams.OnChanging := ParamsChanging;
  FFormatOptions := TADFormatOptions.Create(Self);
  FFetchOptions := TADFetchOptions.Create(Self);
  FUpdateOptions := TADUpdateOptions.Create(Self);
  FResourceOptions := TADTopResourceOptions.Create(Self);
  FTxOptions := TADTxOptions.Create;
  FCommandList := TList.Create;
  LoginPrompt := True;
  FKeepConnection := True;
  FOptionsIntf := Self;
  FActiveAtRuntime := arStandard;
  ADManager.AddConnection(Self);
  if csDesigning in ComponentState then
    ADPhysManager.DesignTime := True;
end;

{-------------------------------------------------------------------------------}
destructor TADCustomConnection.Destroy;
begin
  Destroying;
  Close;
  ADManager.RemoveConnection(Self);
  inherited Destroy;
  SetLoginDialog(nil);
  FParams := nil;
  FreeAndNil(FFormatOptions);
  FreeAndNil(FFetchOptions);
  FreeAndNil(FUpdateOptions);
  FreeAndNil(FResourceOptions);
  FreeAndNil(FCommandList);
  FreeAndNil(FTxOptions);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Loaded;
begin
  FTxOptions.ClearChanged;
  inherited Loaded;
  if FActiveAtRunTime = arActive then
    SetConnected(True);
  try
{$IFNDEF AnyDAC_FPC}
    if not StreamedConnected then
{$ENDIF}
      CheckSession(False);
  except
    if csDesigning in ComponentState then
      ADHandleException
    else
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Notification(AComponent: TComponent;
  AOperation: TOperation);
var
  oObj: IInterfaceComponentReference;
begin
  if AOperation = opRemove then
    if (FLoginDialog <> nil) and Supports(FLoginDialog, IInterfaceComponentReference, oObj) and
       (oObj.GetComponent = AComponent) then
      SetLoginDialog(nil);
  inherited Notification(AComponent, AOperation);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CheckActive;
begin
  if not Connected then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbMBActive, [GetName]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CheckInactive;
begin
  if Connected then
    if csDesigning in ComponentState then
      Close
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbMBInactive, [GetName]);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetFetchOptions: TADFetchOptions;
begin
  Result := FFetchOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetFetchOptions(const AValue: TADFetchOptions);
begin
  FFetchOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetFormatOptions: TADFormatOptions;
begin
  Result := FFormatOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetFormatOptions(const AValue: TADFormatOptions);
begin
  FFormatOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetUpdateOptions: TADUpdateOptions;
begin
  Result := FUpdateOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetUpdateOptions(const AValue: TADUpdateOptions);
begin
  FUpdateOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetResourceOptions: TADResourceOptions;
begin
  Result := FResourceOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetResourceOptions(const AValue: TADResourceOptions);
begin
  FResourceOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetTxOptions(const AValue: TADTxOptions);
begin
  FTxOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetParentOptions(out AOpts: IADStanOptions): Boolean;
begin
  if FManagerOptsIntf = nil then
    ADManager();
  AOpts := FManagerOptsIntf;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
begin
  if Assigned(FOnError) then
    if AInitiator = nil then
      FOnError(Self, Self as IADStanObject, AException)
    else
      FOnError(Self, AInitiator, AException)
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetSQLBased: Boolean;
begin
  Result := RDBMSKind in [mkOracle, mkMSSQL, mkMSAccess, mkMySQL, mkDB2, mkASA,
    mkADS, mkOther];
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetRDBMSKind: TADRDBMSKind;
var
  oConMeta: IADPhysConnectionMetadata;
begin
  if ConnectionIntf <> nil then begin
    ConnectionIntf.CreateMetadata(oConMeta);
    Result := oConMeta.Kind;
  end
  else
    Result := mkUnknown;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetParams: TStrings;
begin
  Result := FParams.Params;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.ParamsChanging(ASender: TObject);
begin
  CheckInactive;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetParams(const AValue: TStrings);
begin
  CheckInactive;
  FParams.Params := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetKeepConnection(const AValue: Boolean);
begin
  if FKeepConnection <> AValue then begin
    FKeepConnection := AValue;
    if not AValue and (FRefCount = 0) then
      Close;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetConnectionDefName: string;
begin
  Result := FParams.AsString[S_AD_DefinitionParam_Common_ConnectionDef];
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetConnectionDefName(const AValue: string);
begin
  if GetConnectionDefName <> AValue then begin
    FParams.DriverID := '';
    FParams.AsString[S_AD_DefinitionParam_Common_ConnectionDef] := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetDriverName: string;
begin
  Result := FParams.DriverID;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetDriverName(const AValue: string);
begin
  if GetDriverName <> AValue then begin
    FParams.AsString[S_AD_DefinitionParam_Common_ConnectionDef] := '';
    FParams.DriverID := AValue;
 end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.ValidateName(const AName: string);
var
  oConn: TADCustomConnection;
begin
  if AName <> '' then begin
    oConn := ADManager.FindConnection(Name);
    if (oConn <> nil) and (oConn <> Self) then begin
      if not oConn.Temporary or (oConn.FRefCount <> 0) then
        ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbDupName, [AName]);
      oConn.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetConnectionName(const AValue: String);
begin
  if csReading in ComponentState then
    FConnectionName := AValue
  else if FConnectionName <> AValue then begin
    CheckInactive;
    ValidateName(AValue);
    FConnectionName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetConnected: Boolean;
begin
  Result := (ConnectionIntf <> nil) and (ConnectionIntf.State = csConnected);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetConnected(AValue: Boolean);
begin
  if not (csReading in ComponentState) or (csDesigning in ComponentState) or
     (FActiveAtRunTime = arStandard) then
{$IFNDEF AnyDAC_FPC}
    inherited SetConnected(AValue);
{$ELSE}
    inherited Connected := AValue;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetLoginDialog(const AValue: IADGUIxLoginDialog);
var
  oObj: IInterfaceComponentReference;
begin
  if FLoginDialog <> nil then begin
    if Supports(FLoginDialog, IInterfaceComponentReference, oObj) then
      oObj.GetComponent.RemoveFreeNotification(Self);
    FLoginDialog.ConnectionDef := nil;
  end;
  FLoginDialog := AValue;
  if FLoginDialog <> nil then begin
    if Supports(FLoginDialog, IInterfaceComponentReference, oObj) then
      oObj.GetComponent.FreeNotification(Self);
    FLoginDialog.ConnectionDef := ResultConnectionDef;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoInternalLogin;
begin
  ConnectionIntf.LoginPrompt := False;
  ConnectionIntf.Open;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoLogin(const AConnectionDef: IADStanConnectionDef);
  procedure ErrorLoginAborted;
  var
    s: String;
  begin
    s := ConnectionName;
    if s = '' then
      s := ConnectionDefName;
    if s = '' then
      s := S_AD_Unnamed;
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbLoginAborted, [s]);
  end;
var
  oDefDlg: IADGUIxDefaultLoginDialog;
  oDlg: IADGUIxLoginDialog;
  lSharedDlg: Boolean;
begin
  if Assigned(FOnLogin) then
    FOnLogin(Self, AConnectionDef)
  else begin
    lSharedDlg := not Assigned(FLoginDialog);
    if lSharedDlg then begin
      ADCreateInterface(IADGUIxDefaultLoginDialog, oDefDlg, False);
      if (oDefDlg = nil) or (oDefDlg.LoginDialog = nil) then begin
        DoInternalLogin;
        Exit;
      end;
      oDlg := oDefDlg.LoginDialog;
      oDlg.ConnectionDef := ResultConnectionDef;
    end
    else
      oDlg := FLoginDialog;
    try
      if not oDlg.Execute(DoInternalLogin) then
        ErrorLoginAborted;
    finally
      if lSharedDlg then
        oDlg.ConnectionDef := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CheckSession(ARequired: Boolean);
begin
  if ADPhysManager = nil then
    ADManagerRequired(Self, [S_AD_LComp, S_AD_LComp_PClnt], S_AD_LPhys);
  if ARequired and (ADPhysManager.State = dmsInactive) then
    ADPhysManager.Open;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CheckConnectionDef;
begin
  try
    with ADManager.ConnectionDefs do
      if DriverName <> '' then
        // nothing
      else if ConnectionDefName <> '' then
        FParams.ParentDefinition := ConnectionDefByName(ConnectionDefName)
      else if ConnectionName <> '' then
        FParams.ParentDefinition := FindConnectionDef(ConnectionName);
    if FParams.Pooled and
       not ((FParams.Params.Count = 0) or
            (FParams.Params.Count = 1) and
              (FParams.Params.Names[0] = S_AD_DefinitionParam_Common_ConnectionDef)) then
        ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbCantConnPooled, []);
    if FParams.DriverID = '' then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_AccSrvNotDefined, []);
  except
    FParams.ParentDefinition := nil;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetConnectionMetadata(AOpen: Boolean): IADPhysConnectionMetadata;
begin
  if AOpen then
    ADManager.OpenConnection(Self);
  if ConnectionIntf <> nil then
    ConnectionIntf.CreateMetadata(Result)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoConnect;
var
  lErasePassword: Boolean;
  oObjIntf: IADStanObject;
begin
  if Connected then
    Exit;
  try
    inherited DoConnect;
    CheckSession(True);
    CheckConnectionDef;
    lErasePassword := not FParams.HasValue(S_AD_ConnParam_Common_Password);
    try
      if FParams.Pooled then
        ADPhysManager.CreateConnection(
          FParams.ParentDefinition as IADStanConnectionDef, FConnectionIntf)
      else
        ADPhysManager.CreateConnection(FParams, FConnectionIntf);
      if Supports(ConnectionIntf, IADStanObject, oObjIntf) then begin
        oObjIntf.SetOwner(Self, '');
        oObjIntf := nil;
      end;
      ConnectionIntf.ErrorHandler := Self;
      ConnectionIntf.Options := Self;
      FParams.ReadOptions(FormatOptions, UpdateOptions, FetchOptions, ResourceOptions);
      ConnectionIntf.TxOptions := FTxOptions;
      if LoginPrompt and not FParams.Pooled and not ADGUIxSilent() then
        DoLogin(FParams);
      if ConnectionIntf.State = csDisconnected then
        DoInternalLogin;
    finally
      if lErasePassword then begin
        FParams.OnChanging := nil;
        FParams.Password := '';
        FParams.OnChanging := ParamsChanging;
      end;
    end;
  except
    FConnectionIntf := nil;
    FParams.ParentDefinition := nil;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoDisconnect;
begin
  if not Connected then
    Exit;
  if ConnectionIntf <> nil then begin
    CloseClients;
    FConnectionIntf := nil;
    FRefCount := 0;
  end;
  FParams.ParentDefinition := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetInTransaction: Boolean;
begin
  if Connected then
    Result := ConnectionIntf.TxIsActive
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.StartTransaction: LongWord;
begin
  CheckActive;
  Result := ConnectionIntf.TxBegin;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Commit;
begin
  CheckActive;
  ConnectionIntf.TxCommit;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Rollback;
begin
  CheckActive;
  ConnectionIntf.TxRollback;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CloseClients;
begin
  while DataSetCount <> 0 do
    DataSets[DataSetCount - 1].Disconnect(True);
  while CommandCount <> 0 do
    Commands[CommandCount - 1].Disconnect(True);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetDataSet(AIndex: Integer): TADDataSet;
begin
  Result := inherited DataSets[AIndex] as TADDataSet;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetCommandCount: Integer;
begin
  Result := FCommandList.Count;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetCommands(AIndex: Integer): TADCustomCommand;
begin
  Result := TADCustomCommand(FCommandList[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.AttachClient(AObj: TObject);
begin
{$IFDEF AnyDAC_FPC}
  if AObj is TADDataSet then
    TADDataSet(AObj).DataBase := Self
  else
{$ELSE}
  RegisterClient(AObj);
{$ENDIF}
  if AObj is TADCustomCommand then
    FCommandList.Add(AObj);
  if FRefCount = 0 then
    Open
  else
    Inc(FRefCount);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DetachClient(AObj: TObject);
begin
{$IFDEF AnyDAC_FPC}
  if AObj is TADDataSet then
    TADDataSet(AObj).DataBase := nil
  else
{$ELSE}
  UnRegisterClient(AObj);
{$ENDIF}
  if AObj is TADCustomCommand then
    FCommandList.Remove(AObj);
  if FRefCount = 1 then begin
    if not FKeepConnection then
      Close;
  end
  else
    Dec(FRefCount);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetFieldNames(const ACatalogName, ASchemaName,
  ATableName, APattern: String; AList: TStrings);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
begin
  oConnMeta := GetConnectionMetadata(True);
  try
    oView := oConnMeta.GetTableFields(ACatalogName, ASchemaName, ATableName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        AList.Add(CnvNull(oView.Rows[i].GetData('COLUMN_NAME')));
    finally
      AList.EndUpdate;
      oView.Free;
    end;
  finally
    ADManager.CloseConnection(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetKeyFieldNames(const ACatalogName,
  ASchemaName, ATableName, APattern: string; AList: TStrings);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
begin
  oConnMeta := GetConnectionMetadata(True);
  try
    oView := oConnMeta.GetTablePrimaryKeyFields(ACatalogName, ASchemaName, ATableName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        AList.Add(CnvNull(oView.Rows[i].GetData('COLUMN_NAME')));
    finally
      AList.EndUpdate;
      oView.Free;
    end;
  finally
    ADManager.CloseConnection(Self);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.EncodeObjectName(const ACatalogName, ASchemaName,
  ABaseObjectName, AObjectName: String): String;
var
  oConMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
begin
  CheckActive;
  rName.FCatalog := CnvNull(ACatalogName);
  rName.FSchema := CnvNull(ASchemaName);
  rName.FBaseObject := CnvNull(ABaseObjectName);
  rName.FObject := CnvNull(AObjectName);
  ConnectionIntf.CreateMetadata(oConMeta);
  Result := oConMeta.EncodeObjName(rName, nil, [eoBeatify]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DecodeObjectName(const AFullName: String;
  var ACatalogName, ASchemaName, ABaseObjectName, AObjectName: String);
var
  oConMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
begin
  CheckActive;
  ConnectionIntf.CreateMetadata(oConMeta);
  oConMeta.DecodeObjName(AFullName, rName, nil, [doUnquote, doNormalize]);
  ACatalogName := rName.FCatalog;
  ASchemaName := rName.FSchema;
  ABaseObjectName := rName.FBaseObject;
  AObjectName := rName.FObject;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.CnvNull(const AStr: Variant): String;
begin
{$IFDEF AnyDAC_D6Base}
  Result := VarToStrDef(AStr, '');
{$ELSE}
  Result := VarToStr(AStr);
{$ENDIF}
  if ADCompareText(Result, '<NULL>') = 0 then
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetTableNames(const ACatalogName, ASchemaName,
  APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes;
  AKinds: TADPhysTableKinds);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
begin
  oConnMeta := GetConnectionMetadata(True);
  try
    oView := oConnMeta.GetTables(AScopes, AKinds, ACatalogName, ASchemaName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        with oView.Rows[i] do
          AList.Add(EncodeObjectName(CnvNull(GetData('CATALOG_NAME')),
            CnvNull(GetData('SCHEMA_NAME')), '', CnvNull(GetData('TABLE_NAME'))));
    finally
      AList.EndUpdate;
      oView.Table.Free;
    end;
  finally
    ADManager.CloseConnection(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetPackageNames(const ACatalogName, ASchemaName,
  APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
begin
  oConnMeta := GetConnectionMetadata(True);
  try
    oView := oConnMeta.GetPackages(AScopes, ACatalogName, ASchemaName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        with oView.Rows[i] do
          AList.Add(EncodeObjectName(CnvNull(GetData('CATALOG_NAME')),
            CnvNull(GetData('SCHEMA_NAME')), CnvNull(GetData('PACKAGE_NAME')), ''));
    finally
      AList.EndUpdate;
      oView.Table.Free;
    end;
  finally
    ADManager.CloseConnection(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetStoredProcNames(const ACatalogName, ASchemaName,
  APackage, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
  s: String;
begin
  oConnMeta := GetConnectionMetadata(True);
  try
    if APackage = '' then
      oView := oConnMeta.GetProcs(AScopes, ACatalogName, ASchemaName, APattern)
    else
      oView := oConnMeta.GetPackageProcs(ACatalogName, ASchemaName, APackage, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do begin
        with oView.Rows[i] do
          if APackage <> '' then
            s := CnvNull(GetData('PROC_NAME'))
          else
            s := EncodeObjectName(CnvNull(GetData('CATALOG_NAME')),
              CnvNull(GetData('SCHEMA_NAME')), '', CnvNull(GetData('PROC_NAME')));
        AList.Add(s);
      end;
    finally
      AList.EndUpdate;
      if APackage = '' then
        oView.Table.Free
      else
        oView.Free;
    end;
  finally
    ADManager.CloseConnection(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.ApplyUpdates(const ADataSets: array of TADDataSet);
var
  I: Integer;
  oDS: TADDataSet;
begin
  StartTransaction;
  try
    for I := 0 to High(ADataSets) do begin
      oDS := ADataSets[I];
      if (oDS is TADRdbmsDataSet) and (TADRdbmsDataSet(oDS).Connection <> Self) then
        raise Exception.Create('Wrong connection'); // ???
      oDS.ApplyUpdates;
    end;
    Commit;
  except
    Rollback;
    raise;
  end;
  for I := 0 to High(ADataSets) do
    ADataSets[I].CommitUpdates;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetName: TComponentName;
begin
  if Name = '' then
    Result := '$' + IntToHex(Integer(Self), 8)
  else
    Result := Name;
  Result := Result + ': ' + ClassName;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetParent: IADStanObject;
begin
  Result := ADManager as IADStanObject;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetLastAutoGenValue(const AName: String): Variant;
begin
  CheckActive;
  Result := ConnectionIntf.GetLastAutoGenValue(AName);
end;

{-------------------------------------------------------------------------------}
function FindDefaultConnection(AComp: TComponent): TADCustomConnection;
var
  oRoot: TComponent;
  i: Integer;
begin
  Result := nil;
  oRoot := AComp;
  while (oRoot.Owner <> nil) and (Result = nil) do begin
    oRoot := oRoot.Owner;
    for i := 0 to oRoot.ComponentCount - 1 do
      if oRoot.Components[i] is TADCustomConnection then begin
        Result := TADCustomConnection(oRoot.Components[i]);
        Break;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADCustomCommand                                                              }
{-------------------------------------------------------------------------------}
constructor TADCustomCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFormatOptions := TADFormatOptions.Create(Self);
  FFetchOptions := TADFetchOptions.Create(Self);
  FUpdateOptions := TADTableUpdateOptions.Create(Self);
  FResourceOptions := TADResourceOptions.Create(Self);
  FCommandText := TADStringList.Create;
  TADStringList(FCommandText).OnChange := DoSQLChange;
  FMacros := TADMacros.Create(GetParamsOwner);
  FMacros.OnChanged := MacrosChanged;
  FParams := TADParams.Create(GetParamsOwner);
  FRowsAffected := -1;
  FActiveAtRunTime := arStandard;
  if csDesigning in ComponentState then begin
    ADPhysManager.DesignTime := True;
    Connection := FindDefaultConnection(Self);
  end;
end;

{-------------------------------------------------------------------------------}
destructor TADCustomCommand.Destroy;
begin
  Destroying;
  Disconnect(True);
  inherited Destroy;
  FreeAndNil(FParams);
  FreeAndNil(FMacros);
  FreeAndNil(FFormatOptions);
  FreeAndNil(FFetchOptions);
  FreeAndNil(FUpdateOptions);
  FreeAndNil(FResourceOptions);
  FreeAndNil(FCommandText);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetParamsOwner: TPersistent;
begin
  if FOwner <> nil then
    Result := FOwner
  else
    Result := Self;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.PropertyChange;
begin
  if (FOwner <> nil) and (FOwner is TADAdaptedDataSet) and
     not (csDestroying in FOwner.ComponentState) then
    TADAdaptedDataSet(FOwner).DataEvent(dePropertyChange, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Loaded;
begin
  inherited Loaded;
  try
    if FStreamedPrepared or (FActiveAtRunTime = arActive) then
      SetPrepared(True);
    if FStreamedActive or (FActiveAtRunTime = arActive) then
      SetActive(True);
  except
    if csDesigning in ComponentState then
      ADHandleException
    else
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if AOperation = opRemove then
    if AComponent = FConnection then
      SetConnection(nil);
  inherited Notification(AComponent, AOperation);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.CheckComponentState(AState: TComponentState): Boolean;
begin
  Result := (AState * ComponentState <> []) or
    (FOwner <> nil) and (AState * FOwner.ComponentState <> []);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckInactive;
begin
  if Active then
    if CheckComponentState([csDesigning]) then
      CloseAll
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntAdaptMBInactive, []);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckActive;
begin
  if not Active then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntAdaptMBActive, []);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckUnprepared;
begin
  CheckInactive;
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckAsyncProgress;
begin
  CommandIntf.CheckAsyncProgress;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckPrepared;
begin
  Prepared := True;
  CheckAsyncProgress;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetConnection(ACheck: Boolean): TADCustomConnection;
begin
  if FConnection <> nil then
    Result := FConnection
  else begin
    Result := ADManager.FindConnection(ConnectionName);
    if (Result = nil) and ACheck then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDBNotFound,
        [ConnectionName]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetConnection(const AValue: TADCustomConnection);
begin
  if FConnection <> AValue then begin
    CheckUnprepared;
    FConnection := AValue;
    if FConnection <> nil then begin
      FConnection.FreeNotification(Self);
      FConnectionName := FConnection.ConnectionName;
      FBindedBy := bbObject;
    end
    else begin
      FConnectionName := '';
      FBindedBy := bbNone;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetConnectionName(const AValue: String);
begin
  if FConnectionName <> AValue then begin
    CheckUnprepared;
    FConnectionName := AValue;
    FConnection := nil;
    FBindedBy := bbName;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.IsCNNS: Boolean;
begin
  Result := (FBindedBy = bbName);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.IsCNS: Boolean;
begin
  Result := (FBindedBy = bbObject);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.OpenConnection: TADCustomConnection;
begin
  if FBindedBy = bbObject then
    Result := ADManager.OpenConnection(FConnection)
  else
    Result := ADManager.OpenConnection(ConnectionName);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CloseConnection(var AConnection: TADCustomConnection);
begin
  ADManager.CloseConnection(AConnection);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.InternalCreateCommandIntf: IADPhysCommand;
begin
  FConnection.ConnectionIntf.CreateCommand(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterPrepare;
begin
  if Assigned(FAfterPrepare) then
    FAfterPrepare(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterUnprepare;
begin
  if Assigned(FAfterUnprepare) then
    FAfterUnprepare(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforePrepare;
begin
  if Assigned(FBeforePrepare) then
    FBeforePrepare(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeUnprepare;
begin
  if Assigned(FBeforeUnprepare) then
    FBeforeUnprepare(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalPrepare;
begin
  with CommandIntf do begin
    AsyncHandler := Self as IADStanAsyncHandler;
    ErrorHandler := Self as IADStanErrorHandler;
    Options := Self as IADStanOptions;
    if FFixedCommandKind then
      CommandKind := FCommandKind;
    CatalogName := FCatalogName;
    SchemaName := FSchemaName;
    BaseObjectName := FBaseObjectName;
    Macros.Assign(FMacros);
    CommandText := FCommandText.Text;
    Overload := FOverload;
    Params.BindMode := FParams.BindMode;
    if (FCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs]) and
       (fiMeta in Options.FetchOptions.Items) then begin
      if not FCreateIntfDontPrepare then begin
        Prepare;
        Params.AssignValues(FParams);
      end;
    end
    else begin
      Params.Assign(FParams);
      if not FCreateIntfDontPrepare then
        Prepare;
    end;
    if FParams <> Params then
      if not CheckComponentState([csDesigning]) then begin
        FParams.Free;
        FParams := Params;
      end
      else
        FParams.Assign(Params);
  end;
  FRowsAffected := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalUnprepare;
begin
  with CommandIntf do begin
    if not CheckComponentState([csDesigning]) then begin
      FParams := TADParams.Create(GetParamsOwner);
      FParams.Assign(Params);
    end;
    if State = csOpen then
      CloseAll;
    if State = csPrepared then
      Unprepare;
    AsyncHandler := nil;
    ErrorHandler := nil;
    Options := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalOpenConnectionAndLock;
begin
  FConnection := OpenConnection;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalCloseConnection;
var
  oConn: TADCustomConnection;
begin
  oConn := FConnection;
  if FBindedBy <> bbObject then
    FConnection := nil;
  CloseConnection(oConn);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetPrepared: Boolean;
begin
  Result := (CommandIntf <> nil) and (CommandIntf.State <> csInactive);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetPrepared(const AValue: Boolean);
var
  oObjIntf: IADStanObject;
  oConn: TADCustomConnection;
begin
  if (csReading in ComponentState) and not (csDesigning in ComponentState) and
     (FActiveAtRunTime <> arStandard) then
    Exit;
  if csReading in ComponentState then
    FStreamedPrepared := AValue
  else if (Prepared <> AValue) or not AValue and (CommandIntf <> nil) then begin
    if AValue then begin
      DoBeforePrepare;
      InternalOpenConnectionAndLock;
      oConn := FConnection;
      try
        FCommandIntf := InternalCreateCommandIntf;
        try
          if Supports(CommandIntf, IADStanObject, oObjIntf) then begin
            if FOwner <> nil then
              oObjIntf.SetOwner(FOwner, '')
            else
              oObjIntf.SetOwner(Self, '');
            oObjIntf := nil;
          end;
          InternalPrepare;
        except
          InternalUnprepare;
          FCommandIntf := nil;
          raise;
        end;
      except
        InternalCloseConnection;
        raise;
      end;
      oConn.AttachClient(Self);
      DoAfterPrepare;
    end
    else begin
      CheckAsyncProgress;
      DoBeforeUnprepare;
      oConn := FConnection;
      oConn.DetachClient(Self);
      try
        InternalUnprepare;
        if FOwner <> nil then
          FOwner.Disconnect;
        if Assigned(FOnCommandChanged) then
          FOnCommandChanged(Self);
      finally
        InternalCloseConnection;
        FCommandIntf := nil;
        if (FTableAdapter <> nil) and (FTableAdapter.SelectCommand = Self) then
          FTableAdapter.Reset;
      end;
      DoAfterUnprepare;
    end;
    PropertyChange;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.IsPS: Boolean;
begin
  Result := Prepared and not Active;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Prepare;
begin
  Prepared := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Unprepare;
begin
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterClose;
begin
  if Assigned(FAfterClose) then
    FAfterClose(self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterOpen;
begin
  if Assigned(FAfterOpen) then
    FAfterOpen(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeClose;
begin
  if Assigned(FBeforeClose) then
    FBeforeClose(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeOpen;
begin
  if Assigned(FBeforeOpen) then
    FBeforeOpen(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalClose(AAll: Boolean);
begin
  if Active then
    if AAll then
      CommandIntf.CloseAll
    else
      CommandIntf.Close;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalOpenFinished(ASender: TObject;
  AState: TADStanAsyncState; AException: Exception);
begin
  if AState = asFinished then begin
    with CommandIntf do begin
      if CheckComponentState([csDesigning]) then
        FParams.AssignValues(Params);
    end;
    DoAfterOpen;
  end;
end;

procedure TADCustomCommand.InternalOpen;
begin
  if Active then
    Exit;
  with CommandIntf do begin
    if CheckComponentState([csDesigning]) then
      Params.AssignValues(FParams);
    FOperationFinished := InternalOpenFinished;
    Open;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetActive: Boolean;
begin
  Result := Prepared and (CommandIntf.State = csOpen);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetActive(const AValue: Boolean);
begin
  if (csReading in ComponentState) and not (csDesigning in ComponentState) and
     (FActiveAtRunTime <> arStandard) then
    Exit;
  if csReading in ComponentState then
    FStreamedActive := AValue
  else if Active <> AValue then
    if AValue then begin
      CheckPrepared;
      DoBeforeOpen;
      InternalOpen;
    end
    else begin
      CheckAsyncProgress;
      DoBeforeClose;
      InternalClose(False);
      DoAfterClose;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Open;
begin
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Close;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CloseAll;
begin
  if Active then begin
    CheckAsyncProgress;
    DoBeforeClose;
    InternalClose(True);
    DoAfterClose;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.AbortJob(AWait: Boolean = False);
begin
  if GetState in [csExecuting, csFetching] then
    CommandIntf.AbortJob(AWait);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Disconnect(AAbortJob: Boolean = False);
begin
  if AAbortJob then
    AbortJob(True);
  Active := False;
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeExecute;
begin
  if Assigned(FBeforeExecute) then
    FBeforeExecute(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterExecute;
begin
  if Assigned(FAfterExecute) then
    FAfterExecute(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.HandleFinished(const AInitiator: IADStanObject;
  AState: TADStanAsyncState; AException: Exception);
begin
  if Assigned(FOperationFinished) then
    try
      FOperationFinished(Self, AState, AException);
    finally
      FOperationFinished := nil;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalExecuteFinished(ASender: TObject;
  AState: TADStanAsyncState; AException: Exception);
begin
  FRowsAffected := CommandIntf.RowsAffected;
  if AState = asFinished then
    if CheckComponentState([csDesigning]) then
      FParams.AssignValues(CommandIntf.Params);
  if CommandKind in [skCreate, skAlter, skDrop] then
    Unprepare;
  if AState = asFinished then
    DoAfterExecute;
end;

procedure TADCustomCommand.InternalExecute(ATimes: Integer; AOffset: Integer);
begin
  FRowsAffected := -1;
  if CheckComponentState([csDesigning]) then
    CommandIntf.Params.AssignValues(FParams);
  FOperationFinished := InternalExecuteFinished;
  CommandIntf.Execute(ATimes, AOffset);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Execute(ATimes: Integer; AOffset: Integer);
begin
  CheckPrepared;
  DoBeforeExecute;
  InternalExecute(ATimes, AOffset);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.NextRecordSet;
begin
  CheckPrepared;
  CommandIntf.NextRecordSet := True;
  try
    Close;
    PropertyChange;
    Open;
  finally
    CommandIntf.NextRecordSet := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetCommandKind: TADPhysCommandKind;
begin
  if (CommandIntf <> nil) and not FFixedCommandKind then
    Result := CommandIntf.CommandKind
  else
    Result := FCommandKind;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetCommandKind(const AValue: TADPhysCommandKind);
begin
  if FCommandKind <> AValue then begin
    CheckUnprepared;
    FCommandKind := AValue;
    FFixedCommandKind := (AValue <> skUnknown);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.IsCKS: Boolean;
begin
  Result := FFixedCommandKind and (CommandKind <> skUnknown);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetState: TADPhysCommandState;
begin
  if CommandIntf <> nil then
    Result := CommandIntf.State
  else
    Result := csInactive;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetFetchOptions: TADFetchOptions;
begin
  Result := FFetchOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetFetchOptions(const AValue: TADFetchOptions);
begin
  CheckUnprepared;
  FFetchOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetFormatOptions: TADFormatOptions;
begin
  Result := FFormatOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetFormatOptions(const AValue: TADFormatOptions);
begin
  CheckUnprepared;
  FFormatOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetUpdateOptions: TADUpdateOptions;
begin
  Result := FUpdateOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetUpdateOptions(const AValue: TADTableUpdateOptions);
begin
  CheckUnprepared;
  FUpdateOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetResourceOptions: TADResourceOptions;
begin
  Result := FResourceOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetResourceOptions(const AValue: TADResourceOptions);
begin
  CheckUnprepared;
  FResourceOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetOverload(const AValue: Word);
begin
  if FOverload <> AValue then begin
    CheckUnprepared;
    FOverload := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetBaseObjectName(const AValue: String);
begin
  if FBaseObjectName <> AValue then begin
    CheckUnprepared;
    FBaseObjectName := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetSchemaName(const AValue: String);
begin
  if FSchemaName <> AValue then begin
    CheckUnprepared;
    FSchemaName := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetCatalogName(const AValue: String);
begin
  if FCatalogName <> AValue then begin
    CheckUnprepared;
    FCatalogName := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetParamBindMode(const AValue: TADParamBindMode);
begin
  if FParams.BindMode <> AValue then begin
    CheckUnprepared;
    FParams.BindMode := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetParamBindMode: TADParamBindMode;
begin
  Result := FParams.BindMode;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetParentOptions(out AOpts: IADStanOptions): Boolean;
var
  oConn: TADCustomConnection;
begin
  if FConnection <> nil then
    AOpts := FConnection.OptionsIntf
  else begin
    oConn := GetConnection(False);
    if oConn <> nil then
      AOpts := oConn.OptionsIntf;
  end;
  Result := (AOpts <> nil);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.Define(ATable: TADDatSTable;
  AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
begin
  CheckPrepared;
  Result := CommandIntf.Define(ATable, AMetaInfoMergeMode);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.Define(ASchema: TADDatSManager;
  ATable: TADDatSTable; AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
begin
  CheckPrepared;
  if CommandKind = skStoredProc then begin
    FCommandKind := skStoredProcWithCrs;
    CommandIntf.CommandKind := skStoredProcWithCrs;
  end;
  if CheckComponentState([csDesigning]) then
    CommandIntf.Params.AssignValues(FParams);
  Result := CommandIntf.Define(ASchema, ATable, AMetaInfoMergeMode);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeFetch;
begin
  if Assigned(FBeforeFetch) then
    FBeforeFetch(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterFetch;
begin
  if Assigned(FAfterFetch) then
    FAfterFetch(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.FetchFinished(ASender: TObject;
  AState: TADStanAsyncState; AException: Exception);
begin
  FRowsAffected := CommandIntf.RowsAffected;
  if AState = asFinished then
    DoAfterFetch;
end;

procedure TADCustomCommand.Fetch(ATable: TADDatSTable; AAll: Boolean);
begin
  CheckActive;
  DoBeforeFetch;
  FRowsAffected := 0;
  FOperationFinished := FetchFinished;
  CommandIntf.Fetch(ATable, AAll);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetCommandText(const AValue: TStrings);
begin
  if FCommandText <> AValue then
    FCommandText.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetMacros(const AValue: TADMacros);
begin
  if AValue <> FMacros then
    FMacros.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetParams(const AValue: TADParams);
begin
  if AValue <> FParams then
    FParams.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.PreprocessSQL(const AQuery: String; AParams: TADParams;
  AMacrosUpd, AMacrosRead: TADMacros; ACreateParams, ACreateMacros, AExpandMacros: Boolean;
  var ACommandKind: TADPhysCommandKind);
var
  oConMeta: IADPhysConnectionMetadata;
  oPrep: TADPhysPreprocessor;
begin
  if not ACreateParams and not ACreateMacros then
    Exit;
  oPrep := TADPhysPreprocessor.Create;
  try
    oPrep.Params := AParams;
    oPrep.MacrosUpd := AMacrosUpd;
    oPrep.MacrosRead := AMacrosRead;
    oPrep.Source := AQuery;
    oPrep.DesignMode := CheckComponentState([csDesigning]);
    oPrep.Instrs := [];
    oPrep.ConnMetadata := GetConnectionMetadata;
    if oPrep.ConnMetadata = nil then begin
      ADPhysManager.CreateDefaultConnectionMetadata(oConMeta);
      oPrep.ConnMetadata := oConMeta;
    end;
    if ACreateParams then
      oPrep.Instrs := oPrep.Instrs + [piCreateParams];
    if ACreateMacros then
      oPrep.Instrs := oPrep.Instrs + [piCreateMacros];
    if AExpandMacros then
      oPrep.Instrs := oPrep.Instrs + [piExpandMacros];
    oPrep.Execute;
    ACommandKind := oPrep.SQLCommandKind;
  finally
    oPrep.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.FillParams(AParams: TADParams; const ASQL: String);
var
  eCmdKind: TADPhysCommandKind;
begin
  eCmdKind := skUnknown;
  with ResourceOptions do
    PreprocessSQL(ASQL, AParams, nil, nil, True, False, MacroExpand, eCmdKind);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoSQLChange(ASender: TObject);
var
  oPList: TADParams;
  oMList: TADMacros;
  eCmdKind: TADPhysCommandKind;
  lPCreate, lMCreate, lMExpand: Boolean;
begin
  if CheckComponentState([csReading]) or (TADStringList(CommandText).UpdateCount > 0) or
     (ckLockParse in FSelfChanging) then
    Exit;
  Disconnect;
  with GetResourceOptions do begin
    lPCreate := ParamCreate;
    lMCreate := MacroCreate and not (ckMacros in FSelfChanging);
    lMExpand := MacroExpand;
  end;
  if lPCreate or lMCreate or CheckComponentState([csDesigning]) then begin
    oPList := nil;
    if lPCreate then begin
      oPList := TADParams.Create(GetParamsOwner);
      oPList.BindMode := FParams.BindMode;
    end;
    oMList := nil;
    if lMCreate then
      oMList := TADMacros.Create(GetParamsOwner);
    Include(FSelfChanging, ckLockParse);
    try
      try
        eCmdKind := skUnknown;
        PreprocessSQL(FCommandText.Text, oPList, oMList, FMacros, lPCreate,
          lMCreate, lMExpand, eCmdKind);
        if not FFixedCommandKind then
          FCommandKind := eCmdKind;
        if lPCreate then begin
          oPList.AssignValues(FParams);
          FParams.Clear;
          FParams.Assign(oPList);
        end;
        if lMCreate then begin
          oMList.AssignValues(FMacros);
          FMacros.Clear;
          FMacros.Assign(oMList);
        end;
      finally
        if lPCreate then
          oPList.Free;
        if lMCreate then
          oMList.Free;
      end;
      if Assigned(FOnCommandChanged) then
        FOnCommandChanged(Self);
    finally
      Exclude(FSelfChanging, ckLockParse);
    end;
  end;
  Include(FSelfChanging, ckLockParse);
  try
    if Assigned(FOnCommandChanged) then
      FOnCommandChanged(Self);
  finally
    Exclude(FSelfChanging, ckLockParse);
  end;
  PropertyChange;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.MacrosChanged(ASender: TObject);
begin
  if FCommandText.Count > 0 then
    try
      Include(FSelfChanging, ckMacros);
      DoSQLChange(nil);
    finally
      Exclude(FSelfChanging, ckMacros);
    end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.FindParam(const AValue: string): TADParam;
begin
  Result := FParams.FindParam(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.ParamByName(const AValue: string): TADParam;
begin
  Result := FParams.ParamByName(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.FindMacro(const AValue: string): TADMacro;
begin
  Result := FMacros.FindMacro(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.MacroByName(const AValue: string): TADMacro;
begin
  Result := FMacros.MacroByName(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
var
  oInit: IADStanObject;
begin
  if AInitiator = nil then begin
    if (FOwner = nil) or not Supports(TObject(FOwner), IADStanObject, oInit) then
      Supports(TObject(Self), IADStanObject, oInit);
  end
  else
    oInit := AInitiator;
  if Assigned(FOnError) then
    FOnError(Self, oInit, AException)
  else if Connection <> nil then
    Connection.HandleException(oInit, AException);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetConnectionMetadata: IADPhysConnectionMetadata;
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  if oConn <> nil then
    Result := oConn.GetConnectionMetadata
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetName: TComponentName;
begin
  if Name = '' then
    Result := '$' + IntToHex(Integer(Self), 8)
  else
    Result := Name;
  Result := Result + ': ' + ClassName;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetParent: IADStanObject;
begin
  Result := GetConnection(False) as IADStanObject;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
  // ??? Data adapters should call this method
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DefineProperties(AFiler: TFiler);

  function AreParamsStorable: Boolean;
  begin
    Result := Params.Count > 0;
    if AFiler.Ancestor <> nil then
      if AFiler.Ancestor is TADCustomCommand then
        Result := not Params.IsEqual(TADCustomCommand(AFiler.Ancestor).Params)
      else if AFiler.Ancestor is TADRdbmsDataSet then
        Result := not Params.IsEqual(TADRdbmsDataSet(AFiler.Ancestor).Params);
  end;

  function AreMacrosStorable: Boolean;
  begin
    Result := Macros.Count > 0;
    if AFiler.Ancestor <> nil then
      if AFiler.Ancestor is TADCustomCommand then
        Result := not Macros.IsEqual(TADCustomCommand(AFiler.Ancestor).Macros)
      else if AFiler.Ancestor is TADRdbmsDataSet then
        Result := not Macros.IsEqual(TADRdbmsDataSet(AFiler.Ancestor).Macros);
  end;

begin
  AFiler.DefineProperty('ParamData', ReadParams, WriteParams, AreParamsStorable);
  AFiler.DefineProperty('MacroData', ReadMacros, WriteMacros, AreMacrosStorable);
  if FOwner = nil then
    inherited DefineProperties(AFiler);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.ReadParams(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(Params);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.WriteParams(Writer: TWriter);
begin
  Writer.WriteCollection(Params);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.ReadMacros(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(Macros);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.WriteMacros(Writer: TWriter);
begin
  Writer.WriteCollection(Macros);
end;

{-------------------------------------------------------------------------------}
{ TADMetaInfoCommand                                                            }
{-------------------------------------------------------------------------------}
constructor TADMetaInfoCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMetaInfoKind := mkTables;
  FTableKinds := [tkSynonym, tkTable, tkView];
  FObjectScopes := [osMy];
  UpdateOptions.EnableDelete := False;
  UpdateOptions.EnableInsert := False;
  UpdateOptions.EnableUpdate := False;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoCommand.InternalCreateCommandIntf: IADPhysCommand;
var
  oMetaInfoCmd: IADPhysMetaInfoCommand;
begin
  FConnection.ConnectionIntf.CreateMetaInfoCommand(oMetaInfoCmd);
  Result := oMetaInfoCmd as IADPhysCommand;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.InternalPrepare;
begin
  with CommandIntf as IADPhysMetaInfoCommand do begin
    MetaInfoKind := FMetaInfoKind;
    TableKinds := FTableKinds;
    Wildcard := FWildcard;
    ObjectScopes := FObjectScopes;
  end;
  inherited InternalPrepare;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.DoAfterClose;
begin
  try
    inherited DoAfterClose;
  finally
    Prepared := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoCommand.GetObjectName: String;
begin
  Result := Trim(CommandText.Text);
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetObjectName(const AValue: String);
begin
  CommandText.Text := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetMetaInfoKind(const AValue: TADPhysMetaInfoKind);
begin
  CheckUnprepared;
  FMetaInfoKind := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetTableKinds(const AValue: TADPhysTableKinds);
begin
  CheckUnprepared;
  FTableKinds := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetWildcard(const AValue: String);
begin
  CheckUnprepared;
  FWildcard := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetObjectScopes(const AValue: TADPhysObjectScopes);
begin
  CheckUnprepared;
  FObjectScopes := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADCustomTableAdapter                                                         }
{-------------------------------------------------------------------------------}
constructor TADCustomTableAdapter.Create(AOwner: TComponent);
var
  oAdapt: IADDAptTableAdapter;
begin
  inherited Create(AOwner);
  ADCreateInterface(IADDAptTableAdapter, oAdapt);
  SetTableAdapterIntf(oAdapt, True);
end;

{-------------------------------------------------------------------------------}
destructor TADCustomTableAdapter.Destroy;
begin
  Destroying;
  SelectCommand := nil;
  InsertCommand := nil;
  UpdateCommand := nil;
  DeleteCommand := nil;
  LockCommand := nil;
  UnLockCommand := nil;
  FetchRowCommand := nil;
  SchemaAdapter := nil;
  FTableAdapterIntf.DatSTable := nil;
  SetTableAdapterIntf(nil, True);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetTableAdapterIntf(const AAdapter: IADDAptTableAdapter;
  AOwned: Boolean);
begin
  if FTableAdapterIntf <> nil then begin
    FTableAdapterIntf.ErrorHandler := nil;
    FTableAdapterIntf.UpdateHandler := nil;
    FTableAdapterIntf.DescribeHandler := nil;
    FTableAdapterIntf.ColumnMappings.SetOwner(nil);
  end;
  FTableAdapterIntf := AAdapter;
  FTableAdapterOwned := AOwned;
  if FTableAdapterIntf <> nil then begin
    FTableAdapterIntf.ErrorHandler := Self as IADStanErrorHandler;
    FTableAdapterIntf.UpdateHandler := Self as IADDAptUpdateHandler;
    FTableAdapterIntf.DescribeHandler := Self as IADPhysDescribeHandler;
    FTableAdapterIntf.ColumnMappings.SetOwner(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if AOperation = opRemove then
    if SelectCommand = AComponent then
      SelectCommand := nil
    else if InsertCommand = AComponent then
      InsertCommand := nil
    else if UpdateCommand = AComponent then
      UpdateCommand := nil
    else if DeleteCommand = AComponent then
      DeleteCommand := nil
    else if LockCommand = AComponent then
      LockCommand := nil
    else if UnLockCommand = AComponent then
      UnLockCommand := nil
    else if FetchRowCommand = AComponent then
      FetchRowCommand := nil
    else if SchemaAdapter = AComponent then
      SchemaAdapter := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.HandleException(
  const AInitiator: IADStanObject; var AException: Exception);
begin
  if Assigned(FAdaptedDataSet) then
    FAdaptedDataSet.InternalUpdateErrorHandler(Self, AInitiator, AException);
  if (AException <> nil) and Assigned(FOnError) then
    FOnError(Self, AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.ReconcileRow(ARow: TADDatSRow;
  var AAction: TADDAptReconcileAction);
begin
  if Assigned(FAdaptedDataSet) then
    FAdaptedDataSet.InternalReconcileErrorHandler(Self, ARow, AAction);
  if Assigned(FOnReconcileRow) then
    FOnReconcileRow(Self, ARow, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.UpdateRow(ARow: TADDatSRow;
  ARequest: TADPhysUpdateRequest; AUpdRowOptions: TADPhysUpdateRowOptions;
  var AAction: TADErrorAction);
begin
  if Assigned(FAdaptedDataSet) then
    FAdaptedDataSet.InternalUpdateRecordHandler(Self, ARow, ARequest, AUpdRowOptions, AAction);
  if Assigned(FOnUpdateRow) then
    FOnUpdateRow(Self, ARow, ARequest, AUpdRowOptions, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.DescribeColumn(AColumn: TADDatSColumn;
  var AAttrs: TADDataAttributes; var AOptions: TADDataOptions; var AObjName: String);
begin
  if Assigned(FAdaptedDataSet) then
    FAdaptedDataSet.InternalDescribeColumn(Self, AColumn, AAttrs, AOptions, AObjName);
  if Assigned(FOnDescribeColumn) then
    FOnDescribeColumn(Self, AColumn, AAttrs, AOptions, AObjName);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.DescribeTable(ATable: TADDatSTable;
  var AObjName: String);
begin
  if Assigned(FAdaptedDataSet) then
    FAdaptedDataSet.InternalDescribeTable(Self, ATable, AObjName);
  if Assigned(FOnDescribeTable) then
    FOnDescribeTable(Self, ATable, AObjName);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.UpdateAdapterCmds(ACmds: TADPhysRequests);
var
  i: TADPhysRequest;
  oCmd: TADCustomCommand;
begin
  for i := arSelect to arFetchRow do
    if i in ACmds then begin
      oCmd := GetCommand(i);
      if oCmd <> nil then begin
        if (oCmd.CommandText.Count > 0) and (oCmd.CommandIntf = nil) then begin
          oCmd.FCreateIntfDontPrepare := True;
          try
            oCmd.Prepare;
          finally
            oCmd.FCreateIntfDontPrepare := False;
          end;
        end;
        if oCmd.CommandIntf <> nil then
          SetAdapterCmd(oCmd.CommandIntf, i);
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetAdapterCmd(const ACmd: IADPhysCommand;
  ACmdKind: TADPhysRequest);
begin
  case ACmdKind of
  arSelect:   FTableAdapterIntf.SelectCommand := ACmd;
  arInsert:   FTableAdapterIntf.InsertCommand := ACmd;
  arUpdate:   FTableAdapterIntf.UpdateCommand := ACmd;
  arDelete:   FTableAdapterIntf.DeleteCommand := ACmd;
  arLock:     FTableAdapterIntf.LockCommand := ACmd;
  arUnlock:   FTableAdapterIntf.UnLockCommand := ACmd;
  arFetchRow: FTableAdapterIntf.FetchRowCommand := ACmd;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetCommand(ACmdKind: TADPhysRequest): TADCustomCommand;
begin
  case ACmdKind of
  arSelect:   Result := SelectCommand;
  arInsert:   Result := InsertCommand;
  arUpdate:   Result := UpdateCommand;
  arDelete:   Result := DeleteCommand;
  arLock:     Result := LockCommand;
  arUnlock:   Result := UnLockCommand;
  arFetchRow: Result := FetchRowCommand;
  else        Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetCommand(var AVar: TADCustomCommand;
  const AValue: TADCustomCommand; ACmdKind: TADPhysRequest);
begin
  if AVar <> nil then begin
    AVar.FTableAdapter := nil;
    AVar.RemoveFreeNotification(Self);
    SetAdapterCmd(nil, ACmdKind);
  end;
  AVar := AValue;
  if AVar <> nil then begin
    AVar.FTableAdapter := Self;
    AVar.FreeNotification(Self);
    if AVar.CommandIntf <> nil then
      SetAdapterCmd(AVar.CommandIntf, ACmdKind);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.Define: TADDatSTable;
begin
  UpdateAdapterCmds([arSelect]);
  Result := FTableAdapterIntf.Define;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Fetch(AAll: Boolean);
begin
  UpdateAdapterCmds([arSelect]);
  FSelectCommand.FRowsAffected := 0;
  FTableAdapterIntf.Fetch(AAll);
  FSelectCommand.FRowsAffected := FTableAdapterIntf.SelectCommand.RowsAffected; // N???
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.Update(AMaxErrors: Integer): Integer;
begin
  UpdateAdapterCmds([arInsert, arUpdate, arDelete, arLock, arUnlock, arFetchRow]);
  Result := FTableAdapterIntf.Update(AMaxErrors);
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.Reconcile: Boolean;
begin
  Result := FTableAdapterIntf.Reconcile;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Fetch(ARow: TADDatSRow;
  var AAction: TADErrorAction; AColumn: Integer;
  ARowOptions: TADPhysFillRowOptions);
begin
  UpdateAdapterCmds([arFetchRow]);
  FTableAdapterIntf.Fetch(ARow, AAction, AColumn, ARowOptions);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Update(ARow: TADDatSRow;
  var AAction: TADErrorAction; AUpdRowOptions: TADPhysUpdateRowOptions;
  AForceRequest: TADPhysRequest);
begin
  if AForceRequest = arFromRow then
    UpdateAdapterCmds([arInsert, arUpdate, arDelete, arLock, arUnlock, arFetchRow])
  else
    UpdateAdapterCmds([AForceRequest]);
  FTableAdapterIntf.Update(ARow, AAction, AUpdRowOptions, AForceRequest);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Lock(ARow: TADDatSRow;
  var AAction: TADErrorAction; AUpdRowOptions: TADPhysUpdateRowOptions);
begin
  UpdateAdapterCmds([arLock]);
  FTableAdapterIntf.Update(ARow, AAction, AUpdRowOptions, arLock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.UnLock(ARow: TADDatSRow;
  var AAction: TADErrorAction; AUpdRowOptions: TADPhysUpdateRowOptions);
begin
  UpdateAdapterCmds([arUnLock]);
  FTableAdapterIntf.Update(ARow, AAction, AUpdRowOptions, arUnlock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetDeleteCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FDeleteCommand, AValue, arDelete);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetFetchRowCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FFetchRowCommand, AValue, arFetchRow);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetInsertCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FInsertCommand, AValue, arInsert);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetLockCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FLockCommand, AValue, arLock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetSelectCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FSelectCommand, AValue, arSelect);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetUnLockCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FUnLockCommand, AValue, arUnLock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetUpdateCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FUpdateCommand, AValue, arUpdate);
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetColumnMappings: TADDAptColumnMappings;
begin
  Result := FTableAdapterIntf.ColumnMappings;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetColumnMappings(const AValue: TADDAptColumnMappings);
begin
  FTableAdapterIntf.ColumnMappings.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.IsCMS: Boolean;
begin
  Result := ColumnMappings.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetSchemaAdapter(const AValue: TADCustomSchemaAdapter);
var
  oAdapt: IADDAptTableAdapter;
begin
  if FSchemaAdapter <> AValue then begin
    if FSchemaAdapter <> nil then begin
      FSchemaAdapter.RemoveFreeNotification(Self);
      if FAdaptedDataSet <> nil then
        FAdaptedDataSet.DatSManager := nil;
      if FTableAdapterOwned then
        FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Remove(FTableAdapterIntf)
      else begin
        ADCreateInterface(IADDAptTableAdapter, oAdapt);
        SetTableAdapterIntf(oAdapt, True);
      end;
    end;
    FSchemaAdapter := AValue;
    if FSchemaAdapter <> nil then begin
      FSchemaAdapter.FreeNotification(Self);
      if FTableAdapterOwned then
        FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Add(FTableAdapterIntf);
      if FAdaptedDataSet <> nil then
        FAdaptedDataSet.DatSManager := FSchemaAdapter.DatSManager;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetDatSTable: TADDatSTable;
begin
  Result := FTableAdapterIntf.DatSTable;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetDatSTable(const AValue: TADDatSTable);
begin
  FTableAdapterIntf.DatSTable := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetDatSTableName: String;
begin
  Result := FTableAdapterIntf.DatSTableName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetDatSTableName(const AValue: String);
begin
  FTableAdapterIntf.DatSTableName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.IsDTNS: Boolean;
begin
  Result := DatSTableName <> SourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
begin
  Result := FTableAdapterIntf.MetaInfoMergeMode;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetMetaInfoMergeMode(const AValue: TADPhysMetaInfoMergeMode);
begin
  FTableAdapterIntf.MetaInfoMergeMode := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetSourceRecordSetID: Integer;
begin
  Result := FTableAdapterIntf.SourceRecordSetID;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetSourceRecordSetID(const AValue: Integer);
begin
  if FSchemaAdapter <> nil then begin
    if FTableAdapterOwned then
      FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Remove(FTableAdapterIntf);
    SetTableAdapterIntf(FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Lookup(Pointer(AValue), nkID), False);
    if FTableAdapterIntf = nil then begin
      SetTableAdapterIntf(FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Add('', '', ''), True);
      FTableAdapterIntf.SourceRecordSetID := AValue;
    end;
  end
  else
    FTableAdapterIntf.SourceRecordSetID := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetSourceRecordSetName: String;
begin
  Result := FTableAdapterIntf.SourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetSourceRecordSetName(const AValue: String);
begin
  if FSchemaAdapter <> nil then begin
    if FTableAdapterOwned then
      FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Remove(FTableAdapterIntf);
    SetTableAdapterIntf(FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Lookup(Pointer(AValue), nkSource), False);
    if FTableAdapterIntf = nil then begin
      SetTableAdapterIntf(FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Add(AValue, '', ''), True);
      FTableAdapterIntf.SourceRecordSetName := AValue;
    end;
  end
  else
    FTableAdapterIntf.SourceRecordSetName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.IsSRSNS: Boolean;
begin
  if (SelectCommand <> nil) and (SelectCommand.CommandIntf <> nil) then
    Result := SourceRecordSetName <> SelectCommand.CommandIntf.SourceObjectName
  else
    Result := True;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetUpdateTableName: String;
begin
  Result := FTableAdapterIntf.UpdateTableName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetUpdateTableName(const AValue: String);
begin
  FTableAdapterIntf.UpdateTableName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.IsUTNS: Boolean;
begin
  Result := UpdateTableName <> SourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetDatSManager: TADDatSManager;
begin
  Result := FTableAdapterIntf.DatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetDatSManager(AValue: TADDatSManager);
begin
  ASSERT((csDestroying in ComponentState) or (FTableAdapterIntf <> nil));
  if FTableAdapterIntf <> nil then
    FTableAdapterIntf.DatSManager := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Reset;
var
  i: TADPhysRequest;
  oCmd: TADCustomCommand;
begin
  for i := Low(TADPhysRequest) to High(TADPhysRequest) do begin
    oCmd := GetCommand(i);
    if oCmd <> nil then begin
      SetAdapterCmd(nil, i);
      oCmd.Prepared := False;
    end;
  end;
  FTableAdapterIntf.Reset;
end;

{-------------------------------------------------------------------------------}
{ TADCustomSchemaAdapter                                                        }
{-------------------------------------------------------------------------------}
constructor TADCustomSchemaAdapter.Create(AOwner: TComponent);
var
  oMgr: TADDatSManager;
begin
  inherited Create(AOwner);
  ADCreateInterface(IADDAptSchemaAdapter, FDAptSchemaAdapter);
  oMgr := TADDatSManager.Create;
  oMgr.UpdatesRegistry := True;
  oMgr.CountRef(0);
  FDAptSchemaAdapter.DatSManager := oMgr;
  FDAptSchemaAdapter.ErrorHandler := Self as IADStanErrorHandler;
  FDAptSchemaAdapter.UpdateHandler := Self as IADDAptUpdateHandler;
end;

{-------------------------------------------------------------------------------}
destructor TADCustomSchemaAdapter.Destroy;
begin
  inherited Destroy;
  FDAptSchemaAdapter.DatSManager := nil;
  FDAptSchemaAdapter.ErrorHandler := nil;
  FDAptSchemaAdapter.UpdateHandler := nil;
  FDAptSchemaAdapter := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.GetTableAdaptersIntf: IADDAptTableAdapters;
begin
  Result := FDAptSchemaAdapter.TableAdapters;
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.GetDatSManager: TADDatSManager;
begin
  Result := FDAptSchemaAdapter.DatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.SetDatSManager(const AValue: TADDatSManager);
begin
  FDAptSchemaAdapter.DatSManager := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.HandleException(
  const AInitiator: IADStanObject; var AException: Exception);
begin
  if Assigned(FOnError) then
    FOnError(Self, AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.ReconcileRow(ARow: TADDatSRow;
  var AAction: TADDAptReconcileAction);
begin
  if Assigned(FOnReconcileRow) then
    FOnReconcileRow(Self, ARow, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.UpdateRow(ARow: TADDatSRow;
  ARequest: TADPhysUpdateRequest; AUpdRowOptions: TADPhysUpdateRowOptions;
  var AAction: TADErrorAction);
begin
  if Assigned(FOnUpdateRow) then
    FOnUpdateRow(Self, ARow, ARequest, AUpdRowOptions, AAction);
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.Reconcile: Boolean;
begin
  Result := FDAptSchemaAdapter.Reconcile;
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.Update(AMaxErrors: Integer): Integer;
begin
  Result := FDAptSchemaAdapter.Update(AMaxErrors);
end;

{-------------------------------------------------------------------------------}
{ TADCustomUpdateObject                                                         }
{-------------------------------------------------------------------------------}
procedure TADCustomUpdateObject.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FDataSet) then
    DataSet := nil;
  inherited Notification(AComponent, AOperation);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomUpdateObject.SetDataSet(const AValue: TADAdaptedDataSet);
begin
  if FDataSet <> AValue then begin
    if FDataSet <> nil then
      FDataSet.UpdateObject := nil;
    FDataSet := AValue;
    if FDataSet <> nil then
      FDataSet.UpdateObject := Self;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADAdaptedDataSet                                                             }
{-------------------------------------------------------------------------------}
constructor TADAdaptedDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFNDEF AnyDAC_FPC}
  NestedDataSetClass := TADCustomClientDataSet;
{$ENDIF}
  FDatSManager := TADDatSManager.Create;
  FDatSManager.UpdatesRegistry := True;
  FDatSManager.CountRef;
  if csDesigning in ComponentState then
    ADPhysManager.DesignTime := True;
end;

{-------------------------------------------------------------------------------}
destructor TADAdaptedDataSet.Destroy;
begin
  FreeAndNil(FVclParams);
  SetDatSManager(nil);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if AOperation = opRemove then
    if AComponent = UpdateObject then
      UpdateObject := nil
    else if AComponent = Adapter then begin
      Disconnect(True);
      SetAdapter(nil);
    end
    else if AComponent = Command then
      Disconnect(True);
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetCommand: TADCustomCommand;
begin
  if Adapter <> nil then
    Result := Adapter.SelectCommand
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetParams: TADParams;
begin
  Result := Command.Params;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalUpdateErrorHandler(ASender: TObject;
  const AInitiator: IADStanObject; var AException: Exception);
var
  eAction: TADErrorAction;
begin
  if AException is EADDAptRowUpdateException then
    with EADDAptRowUpdateException(AException) do begin
      eAction := Action;
      DoUpdateErrorHandler(Row, Exception, Request, eAction);
      Action := eAction;
    end
  else if AException is EADPhysArrayExecuteError then begin
    if Assigned(FOnExecuteError) then
      with EADPhysArrayExecuteError(AException) do begin
        eAction := Action;
        FOnExecuteError(Self, Times, Offset, Exception, eAction);
        Action := eAction;
      end;
  end
  else if Assigned(FOnError) then
    FOnError(Self, AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalUpdateRecordHandler(ASender: TObject;
  ARow: TADDatSRow; ARequest: TADPhysUpdateRequest; AOptions: TADPhysUpdateRowOptions;
  var AAction: TADErrorAction);
begin
  DoUpdateRecordHandler(ARow, ARequest, AOptions, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalReconcileErrorHandler(ASender: TObject;
  ARow: TADDatSRow; var AAction: TADDAptReconcileAction);
begin
  DoReconcileErrorHandler(ARow, ARow.RowError, ARow.RowState, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalDescribeColumn(ASender: TObject;
  AColumn: TADDatSColumn; var AAttrs: TADDataAttributes;
  var AOptions: TADDataOptions; var AObjName: String);
var
  oFld: TField;
begin
  oFld := GetColumnField(AColumn);
  if oFld <> nil then begin
    if UpdateOptions.UseProviderFlags then begin
      if pfInUpdate in oFld.ProviderFlags then
        Include(AOptions, coInUpdate)
      else
        Exclude(AOptions, coInUpdate);
      if pfInWhere in oFld.ProviderFlags then
        Include(AOptions, coInWhere)
      else
        Exclude(AOptions, coInWhere);
      if pfInKey in oFld.ProviderFlags then
        Include(AOptions, coInKey)
      else
        Exclude(AOptions, coInKey);
{$IFNDEF AnyDAC_FPC}
      if oFld.AutoGenerateValue <> DB.arNone then begin
        Include(AOptions, coAfterInsChanged);
        case oFld.AutoGenerateValue of
        DB.arAutoInc: Include(AAttrs, caAutoInc);
        DB.arDefault: Include(AAttrs, caDefault);
        end;
      end
      else
{$ENDIF}
      begin
        Exclude(AOptions, coAfterInsChanged);
        Exclude(AAttrs, caAutoInc);
        Exclude(AAttrs, caDefault);
      end;
    end;
    if oFld.Origin <> '' then
      AObjName := oFld.Origin;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalDescribeTable(ASender: TObject;
  ATable: TADDatSTable; var AObjName: String);
begin
  if UpdateOptions.UpdateTableName <> '' then
    AObjName := UpdateOptions.UpdateTableName;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.SetAdapter(AAdapter: TADCustomTableAdapter);
begin
  if FAdapter <> AAdapter then begin
    if FAdapter <> nil then begin
      FAdapter.RemoveFreeNotification(Self);
      if (FAdapter.SchemaAdapter <> nil) and
         (FAdapter.SchemaAdapter.DatSManager = DatSManager) then
        DatSManager := nil
      else
        FAdapter.DatSManager := nil;
      if FAdapter.SelectCommand <> nil then
        FAdapter.SelectCommand.RemoveFreeNotification(Self);
      FAdapter.FAdaptedDataSet := nil;
      if FUpdateObject <> nil then
        FUpdateObject.DetachFromAdapter;
    end;
    FAdapter := AAdapter;
    if FAdapter <> nil then begin
      FAdapter.FreeNotification(Self);
      if FAdapter.SchemaAdapter <> nil then
        DatSManager := FAdapter.SchemaAdapter.DatSManager
      else
        FAdapter.DatSManager := DatSManager;
      if FAdapter.SelectCommand <> nil then
        FAdapter.SelectCommand.FreeNotification(Self);
      FAdapter.FAdaptedDataSet := Self;
      if FUpdateObject <> nil then
        FUpdateObject.AttachToAdapter;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.SetDatSManager(AManager: TADDatSManager);
begin
  if FDatSManager <> AManager then begin
    if (AManager = nil) or
       (Table <> nil) and (AManager.Tables.IndexOf(Table) = -1) or
       (View <> nil) and (AManager.Tables.IndexOf(View.Table) = -1) then
      AttachTable(nil, nil);
    if FDatSManager <> nil then begin
      FDatSManager.RemRef;
      FDatSManager := nil;
    end;
    FDatSManager := AManager;
    if FDatSManager <> nil then
      FDatSManager.AddRef;
    if Adapter <> nil then
      Adapter.DatSManager := AManager;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoCloneCursor(AReset, AKeepSettings: Boolean);
begin
  DatSManager := CloneSource.DatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.SetUpdateObject(const AValue: TADCustomUpdateObject);
begin
  if FUpdateObject <> AValue then begin
    if (AValue <> nil) and (AValue.DataSet <> nil) then
      AValue.DataSet.UpdateObject := nil;
    if (FUpdateObject <> nil) and (FUpdateObject.DataSet = Self) then begin
      FUpdateObject.RemoveFreeNotification(Self);
      if Adapter <> nil then
        FUpdateObject.DetachFromAdapter;
      FUpdateObject.FDataSet := nil;
    end;
    FUpdateObject := AValue;
    if FUpdateObject <> nil then begin
      FUpdateObject.FDataSet := Self;
      if Adapter <> nil then
        FUpdateObject.AttachToAdapter;
      FUpdateObject.FreeNotification(Self);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.NextRecordSet;
begin
  if Command <> nil then begin
    DoPrepareSource;
    DisableControls;
    Command.CommandIntf.NextRecordSet := True;
    try
      Close;
      Command.PropertyChange;
      DoOpenSource(False, False, False);
      if Command.Active then begin
        Open;
        FForcePropertyChange := True;
      end
      else
        FForcePropertyChange := False;
    finally
      Command.CommandIntf.NextRecordSet := False;
      EnableControls;
    end;
  end
  else
    Close;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.AbortJob(AWait: Boolean = False);
begin
  if Command <> nil then
    Command.AbortJob(AWait);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalClose;
begin
  ServerCancel;
  inherited InternalClose;
  if FForcePropertyChange then begin
    FForcePropertyChange := False;
    if Command <> nil then
      Command.PropertyChange;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.Disconnect(AAbortJob: Boolean = False);
begin
  if AAbortJob then
    AbortJob(True);
  inherited Disconnect(AAbortJob);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalServerEdit(AServerEditRequest: TADPhysUpdateRequest);
begin
  if (Adapter = nil) or (FServerEditRequest <> arNone) then
    Exit;
  CheckBrowseMode;
  FServerEditRow := Table.NewRow(False);
  FServerEditRequest := AServerEditRequest;
  BeginForceRow(FServerEditRow, True, False);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerAppend;
begin
  InternalServerEdit(arInsert);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerDelete;
begin
  InternalServerEdit(arDelete);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerEdit;
begin
  InternalServerEdit(arUpdate);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerPerform;
var
  eAction: TADErrorAction;
begin
  CheckBrowseMode;
  if FServerEditRequest <> arNone then begin
    StartWait;
    try
      if Adapter <> nil then begin
        eAction := eaApplied;
        Adapter.Update(FServerEditRow, eAction, [], FServerEditRequest);
      end;
    finally
      StopWait;
      ServerCancel;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerCancel;
begin
  if FServerEditRequest <> arNone then begin
    EndForceRow;
    FreeAndNil(FServerEditRow);
    FServerEditRequest := arNone;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerDeleteAll(ANoUndo: Boolean);
var
  oGen: IADPhysCommandGenerator;
  oCmd: IADPhysCommand;
  oConn: TADCustomConnection;
begin
  CheckBrowseMode;
  if Adapter <> nil then begin
    StartWait;
    try
      oConn := PointedConnection;
      if ANoUndo then
        while oConn.InTransaction do
          oConn.Commit;
      oConn.ConnectionIntf.CreateCommandGenerator(oGen);
      oGen.MappingHandler := Adapter.TableAdapterIntf as IADPhysMappingHandler;
      oConn.ConnectionIntf.CreateCommand(oCmd);
      oCmd.CommandText := oGen.GenerateDeleteAll(ANoUndo);
      oCmd.CommandKind := oGen.CommandKind;
      oCmd.Prepare;
      oCmd.Execute;
    finally
      StopWait;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerSetKey;
begin
  { TODO -cCLNT : To implement ServerSetKey }
  raise Exception.Create('Not implemented');
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.ServerGotoKey: Boolean;
begin
  { TODO -cCLNT : To implement ServerGotoKey }
  raise Exception.Create('Not implemented');
  Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoMasterDefined;
begin
  if Command <> nil then
    inherited DoMasterDefined; 
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoMasterSetValues(AMasterFieldList: TList);
begin
  if Command <> nil then
    inherited DoMasterSetValues(AMasterFieldList);
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoMasterDependent(AMasterFieldList: TList): Boolean;
begin
  if Command <> nil then
    Result := inherited DoMasterDependent(AMasterFieldList)
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoPrepareSource;
begin
  if Command <> nil then begin
    if Command.State = csInactive then begin
      FieldDefs.Updated := False;
      IndexDefs.Updated := False;
      Command.Prepare;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoUnprepareSource;
begin
  if FUnpreparing then
    Exit;
  FUnpreparing := True;
  try
    if Command <> nil then begin
      if Command.State <> csInactive then begin
        FieldDefs.Updated := False;
        IndexDefs.Updated := False;
        Command.Unprepare;
      end;
    end;
    if Adapter <> nil then
      Adapter.Reset;
  finally
    FUnpreparing := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoDefineDatSManager;
var
  oTab: TADDatSTable;
begin
  if Command <> nil then begin
    oTab := Adapter.Define;
    AttachTable(oTab, nil);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoOpenSource(AAsyncQuery, AInfoQuery, AStructQuery: Boolean);
begin
  if Command <> nil then begin
    if Command.State = csPrepared then
      Command.Open;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoIsSourceOpen: Boolean;
begin
  Result := (Command <> nil) and (Command.State = csOpen);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoCloseSource;
begin
  if Command <> nil then begin
    if Command.State = csOpen then
      Command.Close;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoResetDatSManager;
begin
  AttachTable(nil, nil);
  if DatSManager <> nil then begin
    if (Adapter <> nil) and (Adapter.DatSTable <> nil) and
       (Adapter.DatSTable.Manager = DatSManager) then
      Adapter.DatSTable := nil;
    if (Adapter <> nil) and (Adapter.DatSManager = DatSManager) and (DatSManager.Refs > 2) or // ????
       (Adapter = nil) and (DatSManager.Refs > 1) then begin                                  //
      DatSManager := TADDatSManager.Create;                                                   //
      DatSManager.UpdatesRegistry := True;                                                    //
      DatSManager.CountRef;                                                                   //
    end                                                                                       //
    else                                                                                      //
      DatSManager.Reset;
  end;
  ASSERT(Table = nil); // else we need Table.Reset;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoGetDatSManager: TADDatSManager;
begin
  Result := FDatSManager;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoFetch(ATable: TADDatSTable; AAll: Boolean): Integer;
begin
  if (Command <> nil) and (Command.State = csOpen) then begin
    ASSERT(Adapter.DatSTable = ATable); // N???
    Adapter.Fetch(AAll);
    Result := Command.RowsAffected;
  end
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoFetch(ARow: TADDatSRow; AColumn: Integer;
  ARowOptions: TADPhysFillRowOptions): Boolean;
var
  eAction: TADErrorAction;
begin
  eAction := eaDefault;
  if Adapter <> nil then
    Adapter.Fetch(ARow, eAction, AColumn, ARowOptions);
  Result := eAction in [eaApplied, eaExitSuccess];
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoExecuteSource(ATimes, AOffset: Integer);
begin
  if Command <> nil then begin
    FAdapter.UpdateAdapterCmds([arSelect]);
    Command.Execute(ATimes, AOffset);
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoApplyUpdates(ATable: TADDatSTable; AMaxErrors: Integer): Integer;
begin
  if Adapter <> nil then begin
    ASSERT(Adapter.DatSTable = ATable);
    Result := Adapter.Update(AMaxErrors);
  end
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoProcessUpdateRequest(ARequest: TADPhysUpdateRequest;
  AOptions: TADPhysUpdateRowOptions);
var
  oRow: TADDatSRow;
  eAction: TADErrorAction;
begin
  if ParentDataSet <> nil then
    TADAdaptedDataSet(ParentDataSet).DoProcessUpdateRequest(ARequest, AOptions)
  else if Adapter <> nil then begin
    if CachedUpdates and (uoImmediateUpd in AOptions) and
       ((ARequest <> arLock) or (uoDeferedLock in AOptions)) then
      Exit;
    oRow := GetRow(ActiveBuffer);
    eAction := eaApplied;
    case ARequest of
    arLock:   Adapter.Lock(oRow, eAction, AOptions);
    arUnLock: Adapter.UnLock(oRow, eAction, AOptions);
    arInsert: Adapter.Update(oRow, eAction, AOptions, arInsert);
    arUpdate: Adapter.Update(oRow, eAction, AOptions, arUpdate);
    arDelete: Adapter.Update(oRow, eAction, AOptions, arDelete);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetFetchOptions: TADFetchOptions;
begin
  Result := Command.FetchOptions;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetFormatOptions: TADFormatOptions;
begin
  Result := Command.FormatOptions;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetUpdateOptions: TADUpdateOptions;
begin
  Result := Command.UpdateOptions;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetResourceOptions: TADResourceOptions;
begin
  Result := Command.ResourceOptions;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetConnection(ACheck: Boolean): TADCustomConnection;
begin
  if Command <> nil then
    Result := Command.GetConnection(ACheck)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetPointedConnection: TADCustomConnection;
begin
  Result := GetConnection(False);
end;

{-------------------------------------------------------------------------------}
{ IProviderSupport }

function TADAdaptedDataSet.PSInTransaction: Boolean;
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  Result := (oConn <> nil) and oConn.InTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSStartTransaction;
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  if oConn <> nil then
    oConn.StartTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSEndTransaction(Commit: Boolean);
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  if oConn <> nil then
    if Commit then
      oConn.Commit
    else
      oConn.Rollback;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSIsSQLBased: Boolean;
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  Result := (oConn <> nil) and oConn.IsSQLBased;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSIsSQLSupported: Boolean;
begin
  Result := PSIsSQLBased;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSGetQuoteChar: string;
var
  oConn: TADCustomConnection;
  oConnMeta: IADPhysConnectionMetadata;
begin
{$IFNDEF AnyDAC_FPC}
  Result := inherited PSGetQuoteChar;
{$ELSE}
  Result := '';
{$ENDIF}
  oConn := GetConnection(False);
  if oConn <> nil then begin
    oConnMeta := oConn.GetConnectionMetadata;
    if oConnMeta <> nil then
      Result := oConnMeta.NameQuotaChar1;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSGetParams: TParams;
begin
  if Command <> nil then begin
    if FVclParams = nil then
      FVclParams := TParams.Create;
    FVclParams.Assign(Params);
    Result := FVclParams;
  end
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSSetParams(AParams: TParams);
begin
  if Command <> nil then begin
    if AParams.Count <> 0 then
      Params.Assign(AParams);
    Close;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSSetCommandText(const CommandText: string);
begin
  if Command <> nil then
    Command.CommandText.Text := CommandText;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSExecuteStatement(const ASQL: string;
  AParams: TParams; ResultSet: Pointer): Integer;
var
  oQry: TADQuery;
begin
  if Adapter = nil then
    raise Exception.Create('Cant execute statement. No adapter assigned'); // ???
  if Assigned(ResultSet) then begin
    TADQuery(ResultSet^) := TADQuery.Create(nil);
    with TADQuery(ResultSet^) do begin
      Connection := Self.GetConnection(True);
      SQL.Text := ASQL;
      Params.Assign(AParams);
      Open;
      Result := -1;
    end;
  end
  else begin
    oQry := TADQuery.Create(nil);
    with oQry do
      try
        Connection := Self.GetConnection(True);
        SQL.Text := ASQL;
        Params.Assign(AParams);
        ExecSQL;
        Result := RowsAffected;
      finally
        Free;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSGetAttributes(List: TList);
begin
{$IFNDEF AnyDAC_FPC}
  inherited PSGetAttributes(List);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ TADCustomClientDataSet                                                        }
{-------------------------------------------------------------------------------}
constructor TADCustomClientDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateOptions;
  FetchOptions.Mode := fmAll;
end;

{-------------------------------------------------------------------------------}
destructor TADCustomClientDataSet.Destroy;
begin
  Close;
  Destroying;
  inherited Destroy;
  Adapter := nil;
  FreeOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomClientDataSet.CreateOptions;
begin
  FFetchOptions := TADFetchOptions.Create(Self);
  FFormatOptions := TADFormatOptions.Create(Self);
  FUpdateOptions := TADTableUpdateOptions.Create(Self);
  FResourceOptions := TADResourceOptions.Create(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomClientDataSet.FreeOptions;
begin
  FreeAndNil(FFetchOptions);
  FreeAndNil(FFormatOptions);
  FreeAndNil(FUpdateOptions);
  FreeAndNil(FResourceOptions);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomClientDataSet.CheckCreateOptions;
begin
  if (Command = nil) and (FFetchOptions = nil) then
    CreateOptions;
end;

{-------------------------------------------------------------------------------}
function TADCustomClientDataSet.GetFetchOptions: TADFetchOptions;
begin
  if Command = nil then begin
    CheckCreateOptions;
    Result := FFetchOptions;
  end
  else
    Result := Command.FetchOptions;
end;

{-------------------------------------------------------------------------------}
function TADCustomClientDataSet.GetFormatOptions: TADFormatOptions;
begin
  if Command = nil then begin
    CheckCreateOptions;
    Result := FFormatOptions;
  end
  else
    Result := Command.FormatOptions;
end;

{-------------------------------------------------------------------------------}
function TADCustomClientDataSet.GetUpdateOptions: TADUpdateOptions;
begin
  if Command = nil then begin
    CheckCreateOptions;
    Result := FUpdateOptions;
  end
  else
    Result := Command.UpdateOptions;
end;

{-------------------------------------------------------------------------------}
function TADCustomClientDataSet.GetResourceOptions: TADResourceOptions;
begin
  if Command = nil then begin
    CheckCreateOptions;
    Result := FResourceOptions;
  end
  else
    Result := Command.ResourceOptions;
end;

{-------------------------------------------------------------------------------}
function TADCustomClientDataSet.GetParentOptions(out AOpts: IADStanOptions): Boolean;
begin
  if Command <> nil then
    Result := Command.GetParentOptions(AOpts)
  else begin
    AOpts := nil;
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomClientDataSet.SetAdapter(AValue: TADCustomTableAdapter);
begin
  if Adapter <> AValue then begin
    CheckInactive;
    inherited SetAdapter(AValue);
    if Command <> nil then begin
      Command.FetchOptions := FetchOptions;
      Command.FormatOptions := FormatOptions;
      Command.UpdateOptions := UpdateOptions;
      Command.ResourceOptions := ResourceOptions;
      FreeOptions;
    end
    else if not (csDestroying in ComponentState) then
      CreateOptions;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADRdbmsDataSet                                                               }
{-------------------------------------------------------------------------------}
constructor TADRdbmsDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetAdapter(InternalCreateAdapter);
  Command.FOwner := Self;
  FAutoCommitUpdates := False;
  if csDesigning in ComponentState then
    Connection := FindDefaultConnection(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADRdbmsDataSet.Destroy;
begin
  Destroying;
  Disconnect(True);
  inherited Destroy;
  if Command <> nil then
    Command.FOwner := nil;
  FreeAndNil(FAdapter);
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Loaded;
begin
  inherited Loaded;
  try
    if FStreamedPrepared or (ActiveAtRunTime = arActive) then
      SetPrepared(True);
  except
    if csDesigning in ComponentState then
      InternalHandleException
    else
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.DefineProperties(AFiler: TFiler);
begin
  inherited DefineProperties(AFiler);
  Command.DefineProperties(AFiler);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.InternalCreateAdapter: TADCustomTableAdapter;
begin
  Result := TADTableAdapter.Create(nil);
  Result.SelectCommand := TADCommand.Create(Result);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetConnection: TADCustomConnection;
begin
  Result := Command.Connection;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetConnection(const AValue: TADCustomConnection);
begin
  Command.Connection := AValue;
  // N??? what about other commands
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetConnectionName: String;
begin
  Result := Command.ConnectionName;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetConnectionName(const AValue: String);
begin
  Command.ConnectionName := AValue;
  // N??? what about other commands
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.IsCNNS: Boolean;
begin
  Result := not IsCNS;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.IsCNS: Boolean;
begin
  Result := (Connection <> nil) and
    (Connection.Name <> '') and (Connection.Owner <> nil) and
    (Connection.ConnectionName = ConnectionName);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetPrepared: Boolean;
begin
  Result := Command.Prepared;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetPrepared(const AValue: Boolean);
begin
  if (csReading in ComponentState) and not (csDesigning in ComponentState) and
     (ActiveAtRunTime <> arStandard) then
    Exit;
  if csReading in ComponentState then
    FStreamedPrepared := AValue
  else if (Command <> nil) and (Command.Prepared <> AValue) then begin
    if AValue then
      DoPrepareSource
    else
      DoUnprepareSource;
  end;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.IsPS: Boolean;
begin
  Result := Prepared and not Active;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.CheckCachedUpdatesMode;
begin
  if not CachedUpdates then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntNotCachedUpdates, []);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.FindMacro(const AValue: string): TADMacro;
begin
  Result := Command.Macros.FindMacro(AValue);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.MacroByName(const AValue: string): TADMacro;
begin
  Result := Command.Macros.MacroByName(AValue);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetMacrosCount: Word;
begin
  Result := Word(Command.Macros.Count);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetMacros: TADMacros;
begin
  Result := Command.Macros;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetMacros(const AValue: TADMacros);
begin
  Command.Macros := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.OpenCursor(InfoQuery: Boolean);
var
  oConn: TADCustomConnection;
begin
  oConn := Command.OpenConnection;
  try
    oConn.AttachClient(Self);
    try
      inherited OpenCursor(InfoQuery);
    except
      oConn.DetachClient(Self);
      raise;
    end;
  finally
    Command.CloseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.InternalClose;
var
  oConn: TADCustomConnection;
begin
  oConn := Command.Connection;
  try
    inherited InternalClose;
  finally
    if oConn <> nil then
      oConn.DetachClient(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Disconnect(AAbortJob: Boolean = False);
begin
  inherited Disconnect(AAbortJob);
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Prepare;
begin
  Prepared := True;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Unprepare;
begin
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetOnError: TADErrorEvent;
begin
  Result := FAdapter.OnError;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetOnError(const AValue: TADErrorEvent);
begin
  FAdapter.OnError := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetOnCommandChanged: TNotifyEvent;
begin
  Result := Command.OnCommandChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetOnCommandChanged(const AValue: TNotifyEvent);
begin
  Command.OnCommandChanged := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetParamBindMode: TADParamBindMode;
begin
  Result := Command.ParamBindMode;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetParamBindMode(const AValue: TADParamBindMode);
begin
  Command.ParamBindMode := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetRowsAffected: Integer;
begin
  Result := Command.RowsAffected;
end;

{-------------------------------------------------------------------------------}
{ TADUpdateSQL                                                                  }
{-------------------------------------------------------------------------------}
constructor TADUpdateSQL.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  for i := 0 to 5 do
    FCommands[i] := TADCustomCommand.Create(nil);
  if csDesigning in ComponentState then
    Connection := FindDefaultConnection(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADUpdateSQL.Destroy;
var
  i: Integer;
begin
  for i := 0 to 5 do begin
    FCommands[i].Free;
    FCommands[i] := nil;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = Connection) then
    Connection := nil;
  inherited Notification(AComponent, AOperation);
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.AttachToAdapter;
begin
  with FDataSet.Adapter do begin
    InsertCommand := Self.GetCommand(arInsert);
    UpdateCommand := Self.GetCommand(arUpdate);
    DeleteCommand := Self.GetCommand(arDelete);
    LockCommand := Self.GetCommand(arLock);
    UnLockCommand := Self.GetCommand(arUnlock);
    FetchRowCommand := Self.GetCommand(arFetchRow);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.DetachFromAdapter;
begin
  with FDataSet.Adapter do begin
    InsertCommand := nil;
    UpdateCommand := nil;
    DeleteCommand := nil;
    LockCommand := nil;
    UnLockCommand := nil;
    FetchRowCommand := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQL.GetCommand(ARequest: TADPhysUpdateRequest): TADCustomCommand;
var
  sConnName: String;
  oConn: TADCustomConnection;
  oFtchOpts: TADFetchOptions;
  oFmtOpts: TADFormatOptions;
  oUpdOpts: TADTableUpdateOptions;
  oResOpts: TADResourceOptions;
  onErr: TADErrorEvent;
begin
  Result := FCommands[Integer(ARequest) - Integer(Low(TADPhysUpdateRequest))];
  sConnName := ConnectionName;
  oConn := Connection;
  if DataSet is TADRdbmsDataSet then begin
    if (sConnName = '') and (oConn = nil) then begin
      oConn := TADRdbmsDataSet(DataSet).Connection;
      sConnName := TADRdbmsDataSet(DataSet).ConnectionName;
    end;
    oFtchOpts := TADRdbmsDataSet(DataSet).FetchOptions;
    oFmtOpts := TADRdbmsDataSet(DataSet).FormatOptions;
    oUpdOpts := TADRdbmsDataSet(DataSet).UpdateOptions;
    oResOpts := TADRdbmsDataSet(DataSet).ResourceOptions;
    onErr := TADRdbmsDataSet(DataSet).OnError;
  end
  else begin
    oFtchOpts := nil;
    oFmtOpts := nil;
    oUpdOpts := nil;
    oResOpts := nil;
    onErr := nil;
  end;
  if (Result.ConnectionName <> sConnName) or (Result.Connection <> oConn) or
     not Result.Prepared then begin
    Result.Disconnect;
    Result.ConnectionName := sConnName;
    Result.Connection := oConn;
    if oFtchOpts <> nil then
      Result.FetchOptions := oFtchOpts;
    with Result.FetchOptions do begin
      Mode := fmExactRecsMax;
      RecsMax := 1;
      Items := Items - [fiMeta];
      Cache := [];
      AutoClose := True;
    end;
    if oFmtOpts <> nil then
      Result.FormatOptions := oFmtOpts;
    if oUpdOpts <> nil then
      Result.UpdateOptions := oUpdOpts;
    if oResOpts <> nil then
      Result.ResourceOptions := oResOpts;
    with Result.ResourceOptions do begin
      if AsyncCmdMode = amAsync then
        AsyncCmdMode := amBlocking;
      Disconnectable := True;
    end;
    Result.OnError := onErr;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQL.GetSQL(const AIndex: Integer): TStrings;
begin
  Result := FCommands[AIndex].CommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.SetSQL(const AIndex: Integer; const AValue: TStrings);
begin
  FCommands[AIndex].CommandText := AValue;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQL.GetURSQL(ARequest: TADPhysUpdateRequest): TStrings;
begin
  Result := FCommands[Integer(ARequest) - Integer(Low(TADPhysUpdateRequest))].CommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.SetURSQL(ARequest: TADPhysUpdateRequest;
  const Value: TStrings);
begin
  FCommands[Integer(ARequest) - Integer(Low(TADPhysUpdateRequest))].CommandText := Value;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.UpdateAdapter;
begin
  if (FDataSet <> nil) and (FDataSet.Adapter <> nil) then begin
    DetachFromAdapter;
    AttachToAdapter;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.SetConnection(const Value: TADCustomConnection);
begin
  if FConnection <> Value then begin
    FConnection := Value;
    if FConnection <> nil then
      FConnection.FreeNotification(Self);
    UpdateAdapter;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.SetConnectionName(const Value: String);
begin
  if FConnectionName <> Value then begin
    FConnectionName := Value;
    UpdateAdapter;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.Apply(ARequest: TADPhysUpdateRequest;
  var AAction: TADErrorAction; AOptions: TADPhysUpdateRowOptions);
var
  oCmd: TADCustomCommand;
begin
  oCmd := Commands[ARequest];
  if (oCmd.CommandText.Count > 0) and (DataSet <> nil) and (DataSet.Adapter <> nil) then
    DataSet.Adapter.Update(DataSet.GetRow(), AAction, AOptions, ARequest);
end;

{-------------------------------------------------------------------------------}
{ TADCustomQuery                                                                }
{-------------------------------------------------------------------------------}
constructor TADCustomQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // FetchOptions.Items := FetchOptions.Items - [fiMeta];
end;

{-------------------------------------------------------------------------------}
function TADCustomQuery.GetSQL: TStrings;
begin
  Result := Command.CommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomQuery.SetSQL(const AValue: TStrings);
begin
  Command.CommandText := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomQuery.GetText: String;
begin
  Result := Command.CommandText.Text; // N??? FAdapter.PreprocessedCommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomQuery.ExecSQL;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
function TADCustomQuery.GetDS: TDataSource;
begin
  Result := MasterSource;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomQuery.SetDS(const AValue: TDataSource);
begin
  if MasterSource <> AValue then begin
    MasterSource := AValue;
    MasterFields := '';
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomQuery.UpdateRecordCount;
var
  iPos: Integer;
begin
  FRecordCount := 0;
  Prepared := True;
  with TADQuery.Create(nil) do
  try
    ConnectionName := Self.ConnectionName;
    Connection := Self.Connection;
    with FetchOptions do begin
      Mode := fmExactRecsMax;
      Items := [];
      RecsMax := 1;
      RecordCountMode := cmVisible;
    end;
    SQL.BeginUpdate;
    try
      Params.Assign(Self.Params);
      Macros.Assign(Self.Macros);
      SQL.Add('SELECT COUNT(*) FROM (');
      iPos := Self.Command.CommandIntf.SQLOrderByPos;
      if iPos <> 0 then
        SQL.Add(Copy(Self.SQL.Text, 1, iPos - 1))
      else
        SQL.AddStrings(Self.SQL);
      SQL.Add(') A');
    finally
      SQL.EndUpdate;
    end;
    Open;
    Self.FRecordCount := Fields[0].AsInteger;
  finally
    Free;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADTable                                                                      }
{-------------------------------------------------------------------------------}
constructor TADTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UpdateOptions.RequestLive := True;
  Command.AfterUnprepare := AfterUnprepare;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.AfterUnprepare(ASender: TObject);
begin
  if Command <> nil then
    SQL.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.GenerateSQL;
var
  sCat, sSch, sBObj, sObj, sOrdFields, sDescFields, sField, sMasterField,
    sSQLSelect, sSQLOrderBy, sSQLWhere: String;
  oIndDef: TIndexDef;
  i1, i2: Integer;
  oConn: TADCustomConnection;
begin
  SQL.BeginUpdate;
  Command.Unprepare;
  oConn := Command.OpenConnection;
  try
    SQL.Clear;
    if Pos('.', FTableName) <> 0 then begin
      sCat := '';
      sSch := '';
      sBObj := '';
      sObj := '';
      oConn.DecodeObjectName(FTableName, sCat, sSch, sBObj, sObj);
      if sCat = '' then
        sCat := FCatalogName;
      if sSch = '' then
        sSch := FSchemaName;
    end
    else begin
      sCat := FCatalogName;
      sSch := FSchemaName;
      sBObj := '';
      sObj := FTableName;
    end;
    sSQLSelect := 'SELECT T.*';
    if PointedConnection.RDBMSKind = mkOracle then
      sSQLSelect := sSQLSelect + ', T.ROWID';
    SQL.Add(sSQLSelect + ' FROM ' + oConn.EncodeObjectName(sCat, sSch, sBObj, sObj) + ' T');
    sOrdFields := '';
    sDescFields := '';
    if IndexFieldNames <> '' then
      sOrdFields := IndexFieldNames
    else if IndexName <> '' then begin
      IndexDefs.Update;
      oIndDef := IndexDefs.Find(sOrdFields);
      if (oIndDef <> nil) and (oIndDef.Expression = '') and
{$IFNDEF AnyDAC_FPC}
         (oIndDef.CaseInsFields = '') and
{$ENDIF}
         (oIndDef.Options * [ixCaseInsensitive, ixExpression, ixNonMaintained] = []) then begin
        sOrdFields := oIndDef.Fields;
{$IFNDEF AnyDAC_FPC}
        sDescFields := oIndDef.DescFields;
{$ENDIF}
      end;
    end;
    if sOrdFields <> '' then begin
      sSQLWhere := '';
      sSQLOrderBy := '';
      sDescFields := ';' + sDescFields + ';';
      i1 := 1;
      i2 := 1;
      while i1 <= Length(sOrdFields) do begin
        sField := ADExtractFieldName(sOrdFields, i1);
        if sField <> '' then begin
          if MasterLink.Active and (MasterLink.Fields.Count > 0) and (i2 <= Length(MasterFields)) then begin
            sMasterField := ADExtractFieldName(MasterFields, i2);
            if sSQLWhere = '' then
              sSQLWhere := 'WHERE '
            else
              sSQLWhere := sSQLWhere + ' AND ';
            sSQLWhere := sSQLWhere + 'T.' + sField + ' = :' + sMasterField;
          end;
          if sSQLOrderBy = '' then
            sSQLOrderBy := 'ORDER BY '
          else
            sSQLOrderBy := sSQLOrderBy + ', ';
          sSQLOrderBy := sSQLOrderBy + 'T.' + sField;
          if Pos(';' + sField + ';', sDescFields) <> 0 then
            sSQLOrderBy := sSQLOrderBy + ' DESC';
        end;
      end;
      if sSQLWhere <> '' then
        SQL.Add(sSQLWhere);
      if sSQLOrderBy <> '' then
        SQL.Add(sSQLOrderBy);
    end;
  finally
    Command.CloseConnection(oConn);
    SQL.EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.RefireSQL;
begin
  if Active then begin
    DisableControls;
    try
      Disconnect;
      Open;
    finally
      EnableControls;
    end;
  end
  else
    SQL.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoMasterReset;
begin
  RefireSQL;
  inherited DoMasterReset;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoMasterSetValues(AMasterFieldList: TList);
begin
  if (Params.Count <> AMasterFieldList.Count) and
     ((IndexFieldNames <> '') or (IndexName <> '')) then
    RefireSQL
  else
    inherited DoMasterSetValues(AMasterFieldList);
end;

{-------------------------------------------------------------------------------}
procedure TADTable.MasterChanged(Sender: TObject);
begin
  if (IndexFieldNames <> '') or (IndexName <> '') then
    inherited MasterChanged(Sender);
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoSortOrderChanged;
begin
  RefireSQL;
  inherited DoSortOrderChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.OpenCursor(AInfoQuery: Boolean);
begin
  if (SQL.Count = 0) or
     (Params.Count <> MasterLink.Fields.Count) and
     ((IndexFieldNames <> '') or (IndexName <> '')) then begin
    GenerateSQL;
    DoMasterSetValues(MasterLink.Fields);
  end;
  inherited OpenCursor(AInfoQuery);
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoOnNewRecord;
var
  i: Integer;
begin
  if MasterLink.Active and (MasterLink.Fields.Count > 0) then
    for i := 0 to MasterLink.Fields.Count - 1 do
      IndexFields[i].Assign(TField(MasterLink.Fields[i]));
  inherited DoOnNewRecord;
end;

{-------------------------------------------------------------------------------}
function TADTable.PSGetTableName: string;
begin
  Result := TableName;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.PSSetCommandText(const ACommandText: string);
begin
  TableName := ACommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.SetTableName(const AValue: String);
begin
  CheckInactive;
  if FTableName <> AValue then begin
    Unprepare;
    FTableName := AValue;
    UpdateOptions.UpdateTableName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.SetSchemaName(const AValue: String);
begin
  CheckInactive;
  if FSchemaName <> AValue then begin
    Unprepare;
    FSchemaName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.SetCatalogName(const AValue: String);
begin
  CheckInactive;
  if FCatalogName <> AValue then begin
    Unprepare;
    FCatalogName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADCustomStoredProc                                                           }
{-------------------------------------------------------------------------------}
function TADCustomStoredProc.InternalCreateAdapter: TADCustomTableAdapter;
begin
  Result := inherited InternalCreateAdapter;
  with Result.SelectCommand do
    CommandKind := skStoredProc;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.DescriptionsAvailable: Boolean;
var
  oConn: TADCustomConnection;
  oList: TStrings;
begin
  oConn := Command.OpenConnection;
  oList := TStringList.Create;
  try
    oConn.GetStoredProcNames(CatalogName, SchemaName, PackageName, StoredProcName, oList);
    Result := (oList.Count > 0);
  finally
    oList.Free;
    Command.CloseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.ProcNameChanged;
begin
  Command.CommandKind := skStoredProc;
  if not (csReading in ComponentState) and (csDesigning in ComponentState) and
     (StoredProcName <> '') then
    Prepare;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.ExecProc;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.GetResults;
begin
  { TODO -cDATASET : We dont need that ? }
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetOverload: Word;
begin
  Result := Command.Overload;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetOverload(const AValue: Word);
begin
  if Command.Overload <> AValue then begin
    Command.Overload := AValue;
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetProcName: string;
begin
  Result := Trim(Command.CommandText.Text);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetProcName(const AValue: string);
var
  s: String;
begin
  s := Trim(AValue);
  if Trim(Command.CommandText.Text) <> s then begin
    Command.CommandText.Text := s;
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetPackageName: String;
begin
  Result := Command.BaseObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetPackageName(const AValue: String);
begin
  if Command.BaseObjectName <> AValue then begin
    Command.BaseObjectName := AValue;
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetSchemaName: String;
begin
  Result := Command.SchemaName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetSchemaName(const AValue: String);
begin
  if Command.SchemaName <> AValue then begin
    Command.SchemaName := AValue;
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetCatalogName: String;
begin
  Result := Command.CatalogName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetCatalogName(const AValue: String);
begin
  if Command.CatalogName <> AValue then begin
    Command.CatalogName := AValue;
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMetaInfoQuery                                                              }
{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.InternalCreateAdapter: TADCustomTableAdapter;
begin
  Result := TADTableAdapter.Create(nil);
  Result.SelectCommand := TADMetaInfoCommand.Create(Result);
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetMetaInfoKind: TADPhysMetaInfoKind;
begin
  Result := TADMetaInfoCommand(Command).MetaInfoKind;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetMetaInfoKind(
  const AValue: TADPhysMetaInfoKind);
begin
  TADMetaInfoCommand(Command).MetaInfoKind := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetObjectName: String;
begin
  Result := TADMetaInfoCommand(Command).ObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetObjectName(const AValue: String);
begin
  TADMetaInfoCommand(Command).ObjectName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetTableKinds: TADPhysTableKinds;
begin
  Result := TADMetaInfoCommand(Command).TableKinds;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetTableKinds(const AValue: TADPhysTableKinds);
begin
  TADMetaInfoCommand(Command).TableKinds := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetWildcard: String;
begin
  Result := TADMetaInfoCommand(Command).Wildcard;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetWildcard(const AValue: String);
begin
  TADMetaInfoCommand(Command).Wildcard := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetOverload: Word;
begin
  Result := TADMetaInfoCommand(Command).Overload;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetOverload(const AValue: Word);
begin
  TADMetaInfoCommand(Command).Overload := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetObjectScopes: TADPhysObjectScopes;
begin
  Result := TADMetaInfoCommand(Command).ObjectScopes;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetObjectScopes(const AValue: TADPhysObjectScopes);
begin
  TADMetaInfoCommand(Command).ObjectScopes := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetBaseObjectName: String;
begin
  Result := TADMetaInfoCommand(Command).BaseObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetBaseObjectName(const AValue: String);
begin
  TADMetaInfoCommand(Command).BaseObjectName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetSchemaName: String;
begin
  Result := TADMetaInfoCommand(Command).SchemaName;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetSchemaName(const AValue: String);
begin
  TADMetaInfoCommand(Command).SchemaName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetCatalogName: String;
begin
  Result := TADMetaInfoCommand(Command).CatalogName;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetCatalogName(const AValue: String);
begin
  TADMetaInfoCommand(Command).CatalogName := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADScriptEngine                                                               }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_Script}
constructor TADScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSQLScript := TStringList.Create;
  FFormatOptions := TADFormatOptions.Create(Self);
  FFetchOptions := TADFetchOptions.Create(Self);
  FResourceOptions := TADResourceOptions.Create(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADScript.Destroy;
begin
  FreeAndNil(FFormatOptions);
  FreeAndNil(FFetchOptions);
  FreeAndNil(FResourceOptions);
  FreeAndNil(FSQLScript);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if AOperation = opRemove then
    if AComponent = FConnection then
      Connection := nil;
end;

{-------------------------------------------------------------------------------}
// IADStanObject
function TADScript.GetName: TComponentName;
begin
  if Name = '' then
    Result := '$' + IntToHex(Integer(Self), 8)
  else
    Result := Name;
  Result := Result + ': ' + ClassName;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetParent: IADStanObject;
begin
  if FConnection = nil then
    Result := nil
  else
    Result := FConnection as IADStanObject;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADScript.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
// IADStanOptions
function TADScript.GetParentOptions(out AOpts: IADStanOptions): Boolean;
begin
  if FConnection <> nil then
    AOpts := FConnection.OptionsIntf;
  Result := (AOpts <> nil);
end;

{-------------------------------------------------------------------------------}
function TADScript.GetFetchOptions: TADFetchOptions;
begin
  Result := FFetchOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetFetchOptions(const Value: TADFetchOptions);
begin
  FFetchOptions.Assign(Value);
end;

{-------------------------------------------------------------------------------}
function TADScript.GetFormatOptions: TADFormatOptions;
begin
  Result := FFormatOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetFormatOptions(const Value: TADFormatOptions);
begin
  FFormatOptions.Assign(Value);
end;

{-------------------------------------------------------------------------------}
function TADScript.GetResourceOptions: TADResourceOptions;
begin
  Result := FResourceOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetResourceOptions(const Value: TADResourceOptions);
begin
  FResourceOptions.Assign(Value);
end;

{-------------------------------------------------------------------------------}
function TADScript.GetUpdateOptions: TADUpdateOptions;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
// IADStanErrorHandler
procedure TADScript.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
var
  oInit: IADStanObject;
begin
  if Assigned(FOnError) then
    if AInitiator = nil then
      FOnError(Self, Self as IADStanObject, AException)
    else
      FOnError(Self, AInitiator, AException)
  else if Connection <> nil then
    Connection.HandleException(oInit, AException);
end;

{-------------------------------------------------------------------------------}
// IADStanAsyncHandler
procedure TADScript.HandleFinished(const AInitiator: IADStanObject;
  AState: TADStanAsyncState; AException: Exception);
begin
  { TODO :  }
end;

{-------------------------------------------------------------------------------}
// etc
procedure TADScript.SetConnection(const AValue: TADCustomConnection);
begin
  FConnection := AValue;
  if FConnection <> nil then
    FConnection.FreeNotification(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetSQLScript(const AValue: TStrings);
begin
  FSQLScript.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.GetStream(const AFileName: String; AOutput: Boolean;
  var AStream: TStream);
var
  s: String;
begin
  inherited GetStream(AFileName, AOutput, AStream);
  if AStream = nil then begin
    s := ADExpandStr(AFileName);
    if AOutput then begin
      if ExtractFileExt(s) = '' then
        s := s + '.log';
      if not FileExists(s) then
        FileClose(FileCreate(s));
      AStream := TADFileStream.Create(s, fmOpenWrite or fmShareDenyWrite);
      AStream.Position := AStream.Seek(0, soFromEnd);
    end
    else begin
      s := ADExpandStr(AFileName);
      if not FileExists(s) and (ExtractFileExt(s) = '') then
        s := s + '.sql';
      AStream := TADFileStream.Create(s, fmOpenRead or fmShareDenyWrite);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ExecuteBase(ARealExecute: Boolean; AAll: Boolean);
var
  oCmd: IADPhysCommand;
  oStream: TStream;
  oParser: TADCustomScriptParser;
  oWait: IADGUIxWaitCursor;
  oObjIntf: IADStanObject;
  sName: String;
begin
  if not ADGUIxSilent then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
  end;
  try
    ADManager.OpenConnection(FConnection);
    try
      ConnectionIntf := FConnection.ConnectionIntf;
      ConnectionIntf.CreateCommand(oCmd);
      CommandIntf := oCmd;
      CommandIntf.AsyncHandler := Self as IADStanAsyncHandler;
      CommandIntf.ErrorHandler := Self as IADStanErrorHandler;
      CommandIntf.Options := Self as IADStanOptions;
      if Supports(CommandIntf, IADStanObject, oObjIntf) then begin
        oObjIntf.SetOwner(Self, '');
        oObjIntf := nil;
      end;
      try
        if SQLScriptFileName <> '' then begin
          sName := SQLScriptFileName;
          GetStream(SQLScriptFileName, False, oStream);
        end
        else begin
          sName := '<unnamed>';
          oStream := TStringStream.Create(SQLScript.Text);
        end;
        try
          oParser := TADStreamScriptParser.Create(sName, nil, oStream);
          try
            inherited ExecuteBase(oParser, ARealExecute, AAll);
          finally
            oParser.Free;
          end;
        finally
          oStream.Free;
        end;
      finally
        CommandIntf.AsyncHandler := nil;
        CommandIntf.ErrorHandler := nil;
        CommandIntf.Options := nil;
        oObjIntf := nil;
        oCmd := nil;
        CommandIntf := nil;
      end;
    finally
      ADManager.CloseConnection(FConnection);
    end;
  finally
    if not ADGUIxSilent then
      oWait.StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ExecuteAll;
begin
  ExecuteBase(True, True);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ExecuteStep;
begin
  ExecuteBase(True, False);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.Validate;
begin
  ExecuteBase(False, True);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
initialization

finalization

  if (FManagerSingleton <> nil) and FManagerSingleton.FAutoCreated then begin
    FManagerSingleton.Free;
    FManagerSingleton := nil;
  end;

end.
