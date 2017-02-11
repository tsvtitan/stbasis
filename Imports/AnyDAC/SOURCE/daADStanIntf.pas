{-------------------------------------------------------------------------------}
{ AnyDAC standard layer API                                                     }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanIntf;

interface

uses
  SysUtils, Classes, IniFiles
{$IFDEF AnyDAC_D6Base}
  {$IFDEF AnyDAC_D6}
  , SqlTimSt, FmtBcd
  {$ENDIF}
{$ELSE}
  , ActiveX, DB
{$ENDIF}
  ;

type
{$IFNDEF AnyDAC_D6}
  IInterfaceComponentReference = interface;
{$ENDIF}
  IADStanComponentReference = interface;
  TADComponent = class;
  IADStanObject = interface;
  IADStanObjectHost = interface;
  IADStanObjectFactory = interface;
  IADStanErrorHandler = interface;
  IADStanExpressionDataSource = interface;
  IADStanExpressionParser = interface;
  IADStanExpressionEvaluator = interface;
  IADStanDefinitionStorage = interface;
  IADStanDefinition = interface;
  IADStanDefinitions = interface;
  IADStanConnectionDef = interface;
  IADStanConnectionDefs = interface;
  IADStanAsyncOperation = interface;
  IADStanAsyncExecutor = interface;
  TADMoniAdapterHelper = class;
{$IFDEF AnyDAC_MONITOR}
  IADMoniClientOutputHandler = interface;
  IADMoniClient = interface;
  IADMoniRemoteClient = interface;
  IADMoniFlatFileClient = interface;
  IADMoniCustomClient = interface;
{$ENDIF}
  IADMoniAdapter = interface;

  { --------------------------------------------------------------------------}
  { Supported DBMS kinds                                                      }
  { --------------------------------------------------------------------------}
  TADRDBMSKind = (mkUnknown, mkOracle, mkMSSQL, mkMSAccess, mkMySQL,
    mkDB2, mkASA, mkADS, mkOther);

  { --------------------------------------------------------------------------}
  { Data types                                                                }
  { --------------------------------------------------------------------------}
  TADDataType = (dtUnknown,                            // unknown
    dtBoolean,                                         // Boolean
    dtSByte, dtInt16, dtInt32, dtInt64,                // signed int
    dtByte, dtUInt16, dtUInt32, dtUInt64,              // unsinged int
    dtDouble, dtCurrency, dtBCD, dtFmtBCD,             // natural numbers
    dtDateTime, dtTime, dtDate, dtDateTimeStamp,       // date and time
    dtAnsiString, dtWideString, dtByteString,          // string
    dtBlob, dtMemo, dtWideMemo,                        // value blobs
    dtHBlob, dtHMemo, dtWideHMemo,                     // handle blobs
    dtHBFile,                                          // external files
    dtRowSetRef, dtCursorRef, dtRowRef,
      dtArrayRef, dtParentRowRef,                      // adt -> ftDataSet, ftCursor, ftADT, ftArray
    dtGUID, dtObject);                                 // adt -> IADDataStoredObject
  TADDataTypes = set of TADDataType;

  TADDataAttribute = (caSearchable, caAllowNull, caFixedLen,
    caBlobData, caReadOnly, caAutoInc, caROWID, caDefault,
    caRowVersion, caInternal, caCalculated, caVolatile, caUnnamed);
  TADDataAttributes = set of TADDataAttribute;
  TADDataOption = (coAllowNull, coUnique, coReadOnly, coInUpdate,
    coInWhere, coInKey, coAfterInsChanged, coAfterUpdChanged);
  TADDataOptions = set of TADDataOption;

  TADCompareDataOption = (coNoCase, coPartial, coNullLess, coDescending, coCache);
  TADCompareDataOptions = set of TADCompareDataOption;

  PDEDataStoredObject = ^IADDataStoredObject;
  IADDataStoredObject = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2000}']
    function Compare(const AOtherObjInt: IADDataStoredObject;
      AOptions: TADCompareDataOptions): Integer;
  end;

  { --------------------------------------------------------------------------}
  { Other                                                                     }
  { --------------------------------------------------------------------------}
  UInt64 = Int64;
  PUInt64 = ^daADStanIntf.UInt64;
  TADBuffer = PChar;
  TADBytes = PChar;
  PIUnknown = ^IUnknown;
  PLargeInt = ^Int64;
  PULargeInt = ^UInt64;
  TADVariantArray = array of Variant;
{$IFNDEF AnyDAC_D6Base}
  PBoolean = ^Boolean;
  PWordBool = ^WordBool;
  PByte = ^Byte;
  PSmallInt = ^SmallInt;
  PShortInt = ^ShortInt;
  PWord = ^Word;
  PInteger = ^Integer;
  PLongInt = ^LongInt;
  PLongWord = ^LongWord;
  PDouble = ^Double;
  PPointer = ^Pointer;
  PPChar = ^PChar;
{$ENDIF}
  PPByte = ^PByte;
  TChars = set of Char;
{$IFDEF AnyDAC_FPC}
  PDateTime = ^TDateTime;
  PBoolean = ^Boolean;
{$ENDIF}

{$IFNDEF AnyDAC_D6}
  TADSQLTimeStamp = packed record
    Year: SmallInt;
    Month: Word;
    Day: Word;
    Hour: Word;
    Minute: Word;
    Second: Word;
    Fractions: LongWord;
  end;
{$ELSE}
  TADSQLTimeStamp = TSQLTimeStamp;
{$ENDIF}
  PADSQLTimeStamp = ^TADSQLTimeStamp;
  
{$IFDEF AnyDAC_FPC}
  TADBcd = packed record
    Precision: Byte;                        { 1..64 }
    SignSpecialPlaces: Byte;                { Sign:1, Special:1, Places:6 }
    Fraction: packed array [0..31] of Byte; { BCD Nibbles, 00..99 per Byte, high Nibble 1st }
  end;
{$ELSE}
  TADBcd = TBcd;
{$ENDIF}
  PADBcd = ^TADBcd;

  TADDateTimeAlias = type TDateTime;
  {$NODEFINE TADDateTimeAlias}
  (*$HPPEMIT 'namespace Daadstanintf'*)
  (*$HPPEMIT '{'*)
  (*$HPPEMIT '    typedef TDateTimeBase TADDateTimeAlias;'*)
  (*$HPPEMIT '}'*)
  TADDateTimeData = record
  case Integer of
    0 {dtDate}: (Date: Longint);
    1 {dtTime}: (Time: Longint);
    2 {dtDateTime}: (DateTime: TADDateTimeAlias);
  end;
  PADDateTimeData = ^TADDateTimeData;

  TADParseFmtSettings = record
    FDelimiter: Char;
    FQuote: Char;
    FQuote1: Char;
    FQuote2: Char;
  end;

  { --------------------------------------------------------------------------}
  { Definition, connection definition                                         }
  { --------------------------------------------------------------------------}
  TADDefinitionState = (asAdded, asModified, asDeleted, asLoading, asLoaded);
  TADDefinitionStyle = (atPersistent, atPrivate, atInternal);

  TADStanDefinitionUpdate = (auModify, auDelete);
  TADStanDefinitionUpdates = set of TADStanDefinitionUpdate;

  IADStanDefinitionStorage = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2012}']
    // private
    function GetFileName: String;
    procedure SetFileName(const AValue: String);
    function GetGlobalFileName: String;
    procedure SetGlobalFileName(const AValue: String);
    function GetDefaultFileName: String;
    procedure SetDefaultFileName(const AValue: String);
    // public
    function CreateIniFile: TCustomIniFile;
    // R/O
    function ActualFileName: String;
    // R/W
    property FileName: String read GetFileName write SetFileName;
    property GlobalFileName: String read GetGlobalFileName write SetGlobalFileName;
    property DefaultFileName: String read GetDefaultFileName write SetDefaultFileName;
  end;

  IADStanDefinition = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2013}']
    // private
    function GetName: String;
    function GetState: TADDefinitionState;
    function GetStyle: TADDefinitionStyle;
    function GetAsBoolean(const AName: String): LongBool;
    function GetAsInteger(const AName: String): LongInt;
    function GetAsString(const AName: String): String;
    function GetParentDefinition: IADStanDefinition;
    function GetParams: TStrings;
    function GetOnChanging: TNotifyEvent;
    function GetOnChanged: TNotifyEvent;
    procedure SetName(const AValue: string);
    procedure SetParams(const AValue: TStrings);
    procedure SetAsBoolean(const AName: String; const AValue: LongBool);
    procedure SetAsYesNo(const AName: String; const AValue: LongBool);
    procedure SetAsInteger(const AName: String; const AValue: LongInt);
    procedure SetAsString(const AName, AValue: String);
    procedure SetParentDefinition(const AValue: IADStanDefinition);
    procedure SetOnChanging(AValue: TNotifyEvent);
    procedure SetOnChanged(AValue: TNotifyEvent);
    // public
    procedure Apply;
    procedure Clear;
    procedure Cancel;
    procedure Delete;
    procedure MarkPersistent;
    procedure OverrideBy(const ADefinition: IADStanDefinition; AAll: Boolean);
    function ParseString(const AStr: String; AKeywords: TStrings = nil): String; overload;
    function ParseString(const AStr: String; AKeywords: TStrings; const AFmt: TADParseFmtSettings): String; overload;
    function BuildString(AKeywords: TStrings = nil): String; overload;
    function BuildString(AKeywords: TStrings; const AFmt: TADParseFmtSettings): String; overload;
    function HasValue(const AName: String): Boolean; overload;
    function HasValue(const AName: String; var ALevel: Integer): Boolean; overload;
    function OwnValue(const AName: String): Boolean;
    procedure ToggleUpdates(APassCode: LongWord; AProtectAgainst: TADStanDefinitionUpdates);
{$IFDEF AnyDAC_MONITOR}
    procedure BaseTrace(const AMonitor: IADMoniClient);
    procedure Trace(const AMonitor: IADMoniClient);
{$ENDIF}
    property State: TADDefinitionState read GetState;
    property Style: TADDefinitionStyle read GetStyle;
    property AsString[const AName: String]: String read GetAsString write SetAsString;
    property AsBoolean[const AName: String]: LongBool read GetAsBoolean write SetAsBoolean;
    property AsYesNo[const AName: String]: LongBool read GetAsBoolean write SetAsYesNo;
    property AsInteger[const AName: String]: LongInt read GetAsInteger write SetAsInteger;
    property ParentDefinition: IADStanDefinition read GetParentDefinition write SetParentDefinition;
    // published
    property Params: TStrings read GetParams write SetParams;
    property Name: String read GetName write SetName;
    property OnChanging: TNotifyEvent read GetOnChanging write SetOnChanging;
    property OnChanged: TNotifyEvent read GetOnChanged write SetOnChanged;
  end;

  IADStanDefinitions = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2014}']
    // private
    function GetCount: Integer;
    function GetItems(AIndex: Integer): IADStanDefinition;
    function GetAutoLoad: Boolean;
    function GetStorage: IADStanDefinitionStorage;
    function GetLoaded: Boolean;
    function GetBeforeLoad: TNotifyEvent;
    function GetAfterLoad: TNotifyEvent;
    procedure SetAutoLoad(AValue: Boolean);
    procedure SetBeforeLoad(AValue: TNotifyEvent);
    procedure SetAfterLoad(AValue: TNotifyEvent);
    // public
    function Add: IADStanDefinition;
    function AddInternal: IADStanDefinition;
    function FindDefinition(const AName: String): IADStanDefinition;
    function DefinitionByName(const AName: String): IADStanDefinition;
    procedure Cancel;
    procedure Save(AIfModified: Boolean = True);
    function Load: Boolean;
    procedure Clear;
    procedure BeginRead;
    procedure EndRead;
    procedure BeginWrite;
    procedure EndWrite;
    property Count: Integer read GetCount;
    property Items[AIndex: Integer]: IADStanDefinition read GetItems; default;
    property Loaded: Boolean read GetLoaded;
    // published
    property AutoLoad: Boolean read GetAutoLoad write SetAutoLoad;
    property Storage: IADStanDefinitionStorage read GetStorage;
    property BeforeLoad: TNotifyEvent read GetBeforeLoad write SetBeforeLoad;
    property AfterLoad: TNotifyEvent read GetAfterLoad write SetAfterLoad;
  end;

  IADStanConnectionDef = interface(IADStanDefinition)
    ['{3E9B315B-F456-4175-A864-B2573C4A2015}']
    // private
    function GetPooled: Boolean;
    function GetDriverID: String;
    function GetPassword: String;
    function GetUserName: String;
    function GetDatabase: String;
    function GetNewPassword: String;
    function GetExpandedDatabase: String;
    function GetMonitorBy: String;
    procedure SetPooled(AValue: Boolean);
    procedure SetDriverID(const AValue: String);
    procedure SetPassword(const AValue: String);
    procedure SetUserName(const AValue: String);
    procedure SetDatabase(const AValue: String);
    procedure SetNewPassword(const AValue: String);
    procedure SetMonitorBy(const AValue: String);
    // public
    procedure WriteOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
    procedure ReadOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
    property UserName: String read GetUserName write SetUserName;
    property Password: String read GetPassword write SetPassword;
    property NewPassword: String read GetNewPassword write SetNewPassword;
    property Database: String read GetDatabase write SetDatabase;
    property ExpandedDatabase: String read GetExpandedDatabase;
    property Pooled: Boolean read GetPooled write SetPooled;
    property DriverID: String read GetDriverID write SetDriverID;
    property MonitorBy: String read GetMonitorBy write SetMonitorBy;
  end;

  IADStanConnectionDefs = interface(IADStanDefinitions)
    ['{3E9B315B-F456-4175-A864-B2573C4A2016}']
    // private
    function GetConnectionDefs(AIndex: Integer): IADStanConnectionDef;
    // public
    function AddConnectionDef: IADStanConnectionDef;
    function FindConnectionDef(const AName: String): IADStanConnectionDef;
    function ConnectionDefByName(const AName: String): IADStanConnectionDef;
    property Items[AIndex: Integer]: IADStanConnectionDef read GetConnectionDefs; default;
  end;

  { --------------------------------------------------------------------------}
  { Objects and factories                                                     }
  { --------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6}
  IInterfaceComponentReference = interface
    ['{E28B1858-EC86-4559-8FCD-6B4F824151ED}']
    function GetComponent: TComponent;
  end;
{$ENDIF}

  IADStanComponentReference = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2029}']
    procedure SetComponentReference(const AValue: IInterfaceComponentReference);
  end;

  TADComponent = class(TComponent
    {$IFNDEF AnyDAC_D6}, IUnknown, IInterfaceComponentReference{$ENDIF})
{$IFNDEF AnyDAC_D6}
  protected
    // IInterfaceComponentReference
    function GetComponent: TComponent;
{$ENDIF}
  end;

  IADStanObject = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2001}']
    // private
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    // public
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    property Name: TComponentName read GetName;
    property Parent: IADStanObject read GetParent;
  end;

  IADStanObjectHost = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2002}']
    // private
    function GetObjectKindName: TComponentName;
    // public
    procedure CreateObject(out AObject: IADStanObject);
    property ObjectKindName: TComponentName read GetObjectKindName;
  end;

  IADStanObjectFactory = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2003}']
    procedure Open(const AHost: IADStanObjectHost; const ADef: IADStanDefinition);
    procedure Close;
    procedure Acquire(out AObject: IADStanObject);
    procedure Release(const AObject: IADStanObject);
  end;

  { --------------------------------------------------------------------------}
  { Error handling interfaces                                                 }
  { --------------------------------------------------------------------------}
  TADErrorAction = (eaFail, eaSkip, eaRetry, eaApplied, eaDefault,
    eaExitSuccess, eaExitFailure);

  IADStanErrorHandler = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2007}']
    procedure HandleException(const AInitiator: IADStanObject; var AException: Exception);
  end;

  { --------------------------------------------------------------------------}
  { Expression evaluation                                                     }
  { --------------------------------------------------------------------------}
  TADParserOption = (poCheck, poAggregate, poDefaultExpr, poFieldNameGiven);
  TADParserOptions = set of TADParserOption;

  TADExpressionOption = (ekNoCase, ekPartial);
  TADExpressionOptions = set of TADExpressionOption;
  TADExpressionScopeKind = (ckUnknown, ckField, ckAgg, ckConst);

  TADAggregateKind = (akSum, akAvg, akCount, akMin, akMax, akFirst, akLast);

  IADStanExpressionDataSource = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2008}']
    // private
    function GetVarIndex(const AName: String): Integer;
    function GetVarType(AIndex: Integer): TADDataType;
    function GetVarScope(AIndex: Integer): TADExpressionScopeKind;
    function GetVarData(AIndex: Integer): Variant;
    procedure SetVarData(AIndex: Integer; const AValue: Variant);
    function GetSubAggregateValue(AIndex: Integer): Variant;
    function GetPosition: Pointer;
    procedure SetPosition(AValue: Pointer);
    function GetRowNum: Integer;
    // public
    property VarIndex[const AName: String]: Integer read GetVarIndex;
    property VarType[AIndex: Integer]: TADDataType read GetVarType;
    property VarScope[AIndex: Integer]: TADExpressionScopeKind read GetVarScope;
    property VarData[AIndex: Integer]: Variant read GetVarData write SetVarData;
    property SubAggregateValue[AIndex: Integer]: Variant read GetSubAggregateValue;
    property Position: Pointer read GetPosition write SetPosition;
    property RowNum: Integer read GetRowNum;
  end;

  IADStanExpressionEvaluator = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2010}']
    // private
    function GetSubAggregateCount: Integer;
    function GetSubAggregateKind(AIndex: Integer): TADAggregateKind;
    function GetDataSource: IADStanExpressionDataSource;
    function GetDataType: TADDataType;
    // public
    function HandleNotification(AKind: Word; AReason: Word;
      AParam1, AParam2: LongWord): Boolean;
    function Evaluate: Variant;
    // support for aggregates
    function EvaluateSubAggregateArg(AIndex: Integer): Variant;
    property SubAggregateCount: Integer read GetSubAggregateCount;
    property SubAggregateKind[AIndex: Integer]: TADAggregateKind read GetSubAggregateKind;
    property DataSource: IADStanExpressionDataSource read GetDataSource;
    property DataType: TADDataType read GetDataType;
  end;

  IADStanExpressionParser = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2009}']
    // private
    function GetDataSource: IADStanExpressionDataSource;
    // public
    function Prepare(const ADataSource: IADStanExpressionDataSource;
      const AExpression: String; AOptions: TADExpressionOptions;
      AParserOptions: TADParserOptions; const AFixedVarName: String): IADStanExpressionEvaluator;
    property DataSource: IADStanExpressionDataSource read GetDataSource;
  end;

  { --------------------------------------------------------------------------}
  { Async execute                                                             }
  { --------------------------------------------------------------------------}
  TADStanAsyncMode = (amBlocking, amNonBlocking, amCancelDialog, amAsync);
  TADStanAsyncState = (asInactive, asExecuting, asFinished, asFailed, asAborted, asExpired);

  IADStanAsyncHandler = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2025}']
    procedure HandleFinished(const AInitiator: IADStanObject;
      AState: TADStanAsyncState; AException: Exception);
  end;

  IADStanAsyncOperation = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2022}']
    procedure Execute;
    procedure AbortJob;
    function AbortSupported: Boolean;
  end;

  IADStanAsyncExecutor = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2023}']
    // private
    function GetState: TADStanAsyncState;
    function GetMode: TADStanAsyncMode;
    function GetTimeout: LongWord;
    function GetOperation: IADStanAsyncOperation;
    function GetHandler: IADStanAsyncHandler;
    // public
    procedure Setup(const AOperation: IADStanAsyncOperation;
      const AMode: TADStanAsyncMode; const ATimeout: LongWord;
      const AHandler: IADStanAsyncHandler);
    procedure Run;
    procedure AbortJob;
    // R/O
    property State: TADStanAsyncState read GetState;
    property Mode: TADStanAsyncMode read GetMode;
    property Timeout: LongWord read GetTimeout;
    property Operation: IADStanAsyncOperation read GetOperation;
    property Handler: IADStanAsyncHandler read GetHandler;
  end;

  { --------------------------------------------------------------------------}
  { Debug monitor interfaces                                                  }
  { --------------------------------------------------------------------------}
  TADMoniEventKind = (ekLiveCycle, ekError,
    ekConnConnect, ekConnTransact, ekConnService,
    ekCmdPrepare, ekCmdExecute, ekCmdDataIn, ekCmdDataOut,
    ekAdaptUpdate,
    ekVendor);
  TADMoniEventKinds = set of TADMoniEventKind;
  PADMoniEventKinds = ^TADMoniEventKinds;
  TADMoniEventStep = (esStart, esProgress, esEnd);
  TADMoniTracing = (eaAuto, eaTrue, eaFalse);

{$IFDEF AnyDAC_MONITOR}
  IADMoniClientOutputHandler = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2028}']
    procedure HandleOutput(const AClassName, AObjName, AMessage: String);
  end;

  IADMoniClient = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2005}']
    // private
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    function GetName: TComponentName;
    procedure SetName(const AValue: TComponentName);
    function GetEventKinds: TADMoniEventKinds;
    procedure SetEventKinds(const AValue: TADMoniEventKinds);
    function GetOutputHandler: IADMoniClientOutputHandler;
    procedure SetOutputHandler(const AValue: IADMoniClientOutputHandler);
    // public
    procedure SetupFromDefinition(const AParams: IADStanDefinition);
    procedure ResetFailure;
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const);
    function RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord;
    procedure UnregisterAdapter(const AAdapter: IADMoniAdapter);
    procedure AdapterChanged(const AAdapter: IADMoniAdapter);
    property Tracing: Boolean read GetTracing write SetTracing;
    property Name: TComponentName read GetName write SetName;
    property EventKinds: TADMoniEventKinds read GetEventKinds write SetEventKinds;
    property OutputHandler: IADMoniClientOutputHandler read GetOutputHandler
      write SetOutputHandler;
  end;

  IADMoniRemoteClient = interface (IADMoniClient)
    ['{3E9B315B-F456-4175-A864-B2573C4A2026}']
    // private
    function GetHost: String;
    procedure SetHost(const AValue: String);
    function GetPort: Integer;
    procedure SetPort(const AValue: Integer);
    function GetTimeout: Integer;
    procedure SetTimeout(const AValue: Integer);
    // public
    property Host: String read GetHost write SetHost;
    property Port: Integer read GetPort write SetPort;
    property Timeout: Integer read GetTimeout write SetTimeout;
  end;

  IADMoniCustomClient = interface (IADMoniClient)
    ['{3E9B315B-F456-4175-A864-B2573C4A2030}']
  end;

  IADMoniFlatFileClient = interface (IADMoniCustomClient)
    ['{3E9B315B-F456-4175-A864-B2573C4A2027}']
    // private
    function GetFileName: String;
    procedure SetFileName(const Value: String);
    function GetFileAppend: Boolean;
    procedure SetFileAppend(const Value: Boolean);
    // public
    property FileName: String read GetFileName write SetFileName;
    property FileAppend: Boolean read GetFileAppend write SetFileAppend;
  end;
{$ENDIF}

  TADDebugMonitorAdapterItemKind = (ikSQL, ikParam, ikStat,
    ikClientInfo, ikSessionInfo);

  TADMoniAdapterHelper = class(TObject)
  private
    FProxy: IADStanObject;
    FRole: TComponentName;
    FHandle: LongWord;
    FAdaptedObj: TObject;
    FParentObj: TObject;
{$IFDEF AnyDAC_MONITOR}
    FMoniClient: IADMoniClient;
{$ENDIF}
    function GetIsRegistered: Boolean;
    function GetName: TComponentName;
    function GetParent: IADStanObject;
  public
    constructor Create(const AAdapterObj, AParentObj: TObject);
    destructor Destroy; override;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
{$IFDEF AnyDAC_MONITOR}
    procedure RegisterClient(const AMoniClient: IADMoniClient);
    procedure UnRegisterClient;
{$ENDIF}
    property IsRegistered: Boolean read GetIsRegistered;
    property Name: TComponentName read GetName;
    property Parent: IADStanObject read GetParent;
    property Handle: LongWord read FHandle;
  end;

  IADMoniAdapter = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2006}']
    // private
    function GetHandle: LongWord;
    function GetItemCount: Integer;
    // public
    procedure GetItem(AIndex: Integer; var AName: String; var AValue: Variant;
      var AKind: TADDebugMonitorAdapterItemKind);
    property Handle: LongWord read GetHandle;
    property ItemCount: Integer read GetItemCount;
  end;

  // next GUID -> xxx031

{$IFNDEF AnyDAC_D6Base}
const
  varInt64 = VT_DECIMAL;
{$ENDIF}

implementation

{ ----------------------------------------------------------------------------- }
{ TADComponent                                                                  }
{ ----------------------------------------------------------------------------- }
{$IFNDEF AnyDAC_D6}
function TADComponent.GetComponent: TComponent;
begin
  Result := Self;
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
{ TADPhysMoniAdapterComponentProxy                                              }
{ ----------------------------------------------------------------------------- }
type
  TADMoniAdapterComponentProxy = class(TInterfacedObject, IADStanObject)
  private
    FComp: TComponent;
  protected
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
  public
    constructor Create(AComp: TComponent);
    destructor Destroy; override;
  end;

{ ----------------------------------------------------------------------------- }
constructor TADMoniAdapterComponentProxy.Create(AComp: TComponent);
begin
  inherited Create;
  FComp := AComp;
end;

{ ----------------------------------------------------------------------------- }
destructor TADMoniAdapterComponentProxy.Destroy;
begin
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniAdapterComponentProxy.GetName: TComponentName;
begin
  if FComp.GetNamePath = '' then
    Result := FComp.ClassName + '($' + IntToHex(Integer(FComp), 8) + ')'
  else
    Result := FComp.GetNamePath;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniAdapterComponentProxy.GetParent: IADStanObject;

  function IsApp(AComp: TComponent): Boolean;
  var
    oClass: TClass;
  begin
    oClass := AComp.ClassType;
    while (oClass <> nil) and not oClass.ClassNameIs('TApplication') do
      oClass := oClass.ClassParent;
    Result := (oClass <> nil);
  end;

begin
  Result := nil;
  if (FComp.Owner <> nil) and not IsApp(FComp.Owner) and
     not Supports(FComp.Owner, IADStanObject, Result) then
    Result := TADMoniAdapterComponentProxy.Create(FComp.Owner) as IADStanObject;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterComponentProxy.BeforeReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterComponentProxy.AfterReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterComponentProxy.SetOwner(
  const AOwner: TObject; const ARole: TComponentName);
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
{ TADMoniAdapterHelper                                                          }
{ ----------------------------------------------------------------------------- }
constructor TADMoniAdapterHelper.Create(const AAdapterObj, AParentObj: TObject);
begin
  inherited Create;
  FAdaptedObj := AAdapterObj;
  FParentObj := AParentObj;
end;

{ ----------------------------------------------------------------------------- }
destructor TADMoniAdapterHelper.Destroy;
{$IFDEF AnyDAC_MONITOR}
var
  oIntf: IADMoniAdapter;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if (FMoniClient <> nil) and (FHandle <> 0) then begin
    if Supports(FAdaptedObj, IADMoniAdapter, oIntf) then
      FMoniClient.UnregisterAdapter(oIntf);
  end;
  FProxy := nil;
{$ENDIF}
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterHelper.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  if AOwner is TComponent then begin
    FProxy := TADMoniAdapterComponentProxy.Create(TComponent(AOwner));
    FParentObj := nil;
  end
  else begin
    FProxy := nil;
    FParentObj := AOwner;
  end;
  FRole := ARole;
end;

{-------------------------------------------------------------------------------}
function TADMoniAdapterHelper.GetIsRegistered: Boolean;
begin
{$IFDEF AnyDAC_MONITOR}
  Result := FHandle <> 0;
{$ELSE}
  Result := False;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TADMoniAdapterHelper.RegisterClient(const AMoniClient: IADMoniClient);
var
  oIntf: IADMoniAdapter;
begin
  if not IsRegistered and (AMoniClient <> nil) and AMoniClient.Tracing then begin
    FMoniClient := AMoniClient;
    if Supports(FAdaptedObj, IADMoniAdapter, oIntf) then begin
      FHandle := FMoniClient.RegisterAdapter(oIntf);
      FMoniClient.AdapterChanged(oIntf);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniAdapterHelper.UnRegisterClient;
var
  oIntf: IADMoniAdapter;
begin
  if IsRegistered and (FMoniClient <> nil) then
    try
      if Supports(FAdaptedObj, IADMoniAdapter, oIntf) then
        FMoniClient.UnregisterAdapter(oIntf);
    finally
      FHandle := 0;
    end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADMoniAdapterHelper.GetName: TComponentName;
begin
  if FProxy <> nil then
    Result := FProxy.Name
  else
    Result := FAdaptedObj.ClassName + '($' + IntToHex(Integer(FAdaptedObj), 8) + ')';
  if FRole <> '' then
    Result := FRole + ': ' + Result;
end;

{-------------------------------------------------------------------------------}
function TADMoniAdapterHelper.GetParent: IADStanObject;
begin
  if FProxy <> nil then
    Result := FProxy.Parent
  else
    Supports(FParentObj, IADStanObject, Result);
end;

end.

