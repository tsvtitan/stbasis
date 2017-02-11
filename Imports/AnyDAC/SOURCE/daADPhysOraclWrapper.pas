{-------------------------------------------------------------------------------}
{ AnyDAC Oracle Call Interface wrapper classes                                  }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

{$IFNDEF AnyDAC_FPC}
  {$O-} // If optimization is turned off, then pieced fetch
  {$W-} // raise AV at call of OCIStmtExecute
{$ENDIF}

unit daADPhysOraclWrapper;

interface

uses
  Windows, SysUtils, Classes,
{$IFDEF AnyDAC_D6}
  FmtBCD, SQLTimSt,
{$ENDIF}  
  daADStanIntf, daADStanError, daADStanConst,
  daADPhysOraclCli;

type
  TOCILib = class;
  TOCIHandle = class;
  TOCIEnv = class;
  EOCINativeException = class;
  EOCISystemException = class;
  TOCIError = class;
  TOCIService = class;
  TOCISession = class;
  TOCIServer = class;
  TOCIDescriptor = class;
  TOCIXid = class;
  TOCITransaction = class;
  TOCIStatement = class;
  TOCIVariable = class;
  TOCISelectItem = class;
  TOCILobLocator = class;
  TOCITempLocator = class;
  TOCILobLocatorClass = class of TOCILobLocator;
  TOCIIntLocator = class;
  TOCIExtLocator = class;
  TOCIDescribe = class;
  TOCIDirectPath = class;
  TOCIDirectPathColArray = class;
  TOCIDirectPathStream = class;
  TOCIDirectPathColumnParam = class;

// --------------------------------------------------------------------------
// CLI environment
// --------------------------------------------------------------------------

  TOCILib = class(TObject)
  private
    FOwningObj: TObject;
    procedure GetOCIPaths(const AVendorHome, AVendorLib: String);
    procedure GetOCIVersion;
    procedure GetTNSPaths;
    procedure LoadOCIEntrys;
    procedure LoadOCILibrary;
    procedure RaiseOCINotLoaded;
  public
    FOCIKey: String;
    FOCIOracleHome: String;
    FOCIDllName: String;
    FOCITnsNames: String;
    FOCIhDll: Integer;
    FOCIVersion: Integer;
    FOCIBDECompatibility: Boolean;
    FOCIInstantClient: Boolean;

    OCIPasswordChange: TOCIPasswordChange;
    OCIInitialize: TOCIInitialize;
    OCIEnvInit: TOCIEnvInit;
    OCIEnvCreate: TOCIEnvCreate;
    OCIHandleAlloc: TOCIHandleAlloc;
    OCIServerAttach: TOCIServerAttach;
    OCIAttrSet: TOCIAttrSet;
    OCISessionBegin: TOCISessionBegin;
    OCISessionEnd: TOCISessionEnd;
    OCIServerDetach: TOCIServerDetach;
    OCIHandleFree: TOCIHandleFree;
    OCIErrorGet: TOCIErrorGet;
    OCIStmtPrepare: TOCIStmtPrepare;
    OCIStmtExecute: TOCIStmtExecute;
    OCIParamGet: TOCIParamGet;
    OCIAttrGet: TOCIAttrGet;
    OCIStmtFetch: TOCIStmtFetch;
    OCIDefineByPos: TOCIDefineByPos;
    OCIDefineArrayOfStruct: TOCIDefineArrayOfStruct;
    OCIBindByPos: TOCIBindByPos;
    OCIBindByName: TOCIBindByName;
    OCITransStart: TOCITransStart;
    OCITransCommit: TOCITransCommit;
    OCITransRollback: TOCITransRollback;
    OCITransDetach: TOCITransDetach;
    OCITransPrepare: TOCITransPrepare;
    OCITransForget: TOCITransForget;
    OCIDescribeAny: TOCIDescribeAny;
    OCIBreak: TOCIBreak;
    OCIReset: TOCIReset;
    OCIDescriptorAlloc: TOCIDescriptorAlloc;
    OCIDescriptorFree: TOCIDescriptorFree;
    OCIStmtGetPieceInfo: TOCIStmtGetPieceInfo;
    OCIStmtSetPieceInfo: TOCIStmtSetPieceInfo;
    OCIServerVersion: TOCIServerVersion;
    OCIBindDynamic: TOCIBindDynamic;
    OCILobAppend: TOCILobAppend;
    OCILobAssign: TOCILobAssign;
    OCILobClose: TOCILobClose;
    OCILobCopy: TOCILobCopy;
    OCILobEnableBuffering: TOCILobEnableBuffering;
    OCILobDisableBuffering: TOCILobDisableBuffering;
    OCILobErase: TOCILobErase;
    OCILobFileExists: TOCILobFileExists;
    OCILobFileGetName: TOCILobFileGetName;
    OCILobFileSetName: TOCILobFileSetName;
    OCILobFlushBuffer: TOCILobFlushBuffer;
    OCILobGetLength: TOCILobGetLength;
    OCILobIsOpen: TOCILobIsOpen;
    OCILobLoadFromFile: TOCILobLoadFromFile;
    OCILobLocatorIsInit: TOCILobLocatorIsInit;
    OCILobOpen: TOCILobOpen;
    OCILobRead: TOCILobRead;
    OCILobTrim: TOCILobTrim;
    OCILobWrite: TOCILobWrite;
    OCILobCreateTemporary: TOCILobCreateTemporary;
    OCILobFreeTemporary: TOCILobFreeTemporary;
    OCILobIsTemporary: TOCILobIsTemporary;
    OCIResultSetToStmt: TOCIResultSetToStmt;
    OCIDirPathAbort: TOCIDirPathAbort;
    OCIDirPathDataSave: TOCIDirPathDataSave;
    OCIDirPathFinish: TOCIDirPathFinish;
    OCIDirPathFlushRow: TOCIDirPathFlushRow;
    OCIDirPathPrepare: TOCIDirPathPrepare;
    OCIDirPathLoadStream: TOCIDirPathLoadStream;
    OCIDirPathColArrayEntryGet: TOCIDirPathColArrayEntryGet;
    OCIDirPathColArrayEntrySet: TOCIDirPathColArrayEntrySet;
    OCIDirPathColArrayRowGet: TOCIDirPathColArrayRowGet;
    OCIDirPathColArrayReset: TOCIDirPathColArrayReset;
    OCIDirPathColArrayToStream: TOCIDirPathColArrayToStream;
    OCIDirPathStreamReset: TOCIDirPathStreamReset;
    OCIDirPathStreamToStream: TOCIDirPathStreamToStream;

    constructor Create(const AVendorHome, AVendorLib: String;
      AOwningObj: TObject = nil);
    destructor Destroy; override;
    procedure GetTNSServicesList(AList: TStrings);
    property OwningObj: TObject read FOwningObj;
  end;

// --------------------------------------------------------------------------
// HANDLE's & DESCRIPTOR's
// --------------------------------------------------------------------------

  TOCIHandle = class
  private
    FHandle: pOCIHandle;
    FType: ub4;
    FOwner: TOCIHandle;
    FError: TOCIError;
    FLib: TOCILib;
    FOwningObj: TObject;
{$IFDEF AnyDAC_MONITOR}
    FMonitor: IADMoniClient;
    function GetTracing: Boolean;
{$ENDIF}
    function Init(AEnv: TOCIHandle; AType: ub4): pOCIHandle;
    function GetError: TOCIError;
    function GetLib: TOCILib;
    procedure Check(ACode: sb4);
  protected
    FOwnHandle: Boolean;
{$IFDEF AnyDAC_MONITOR}
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; AArgs: array of const); overload;
    procedure Trace(AKind: TADMoniEventKind; const AMsg: String;
      AArgs: array of const); overload;
    procedure Trace(const AMsg: String; AArgs: array of const); overload;
    procedure UpdateTracing;
    property Monitor: IADMoniClient read FMonitor;
    property Tracing: Boolean read GetTracing;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetStringAttr(AAtrType: Integer; const AValue: String);
    function GetStringAttr(AAtrType: Integer): String;
    procedure SetHandleAttr(AAtrType: Integer; AValue: pOCIHandle);
    function GetHandleAttr(AAtrType: Integer): pOCIHandle;
    procedure SetUB1Attr(AAtrType: Integer; AValue: ub1);
    function GetUB1Attr(AAtrType: Integer): ub1;
    procedure SetUB2Attr(AAtrType: Integer; AValue: ub2);
    function GetUB2Attr(AAtrType: Integer): ub2;
    procedure SetUB4Attr(AAtrType: Integer; AValue: ub4);
    function GetUB4Attr(AAtrType: Integer): ub4;
    procedure SetSB1Attr(AAtrType: Integer; AValue: sb1);
    function GetSB1Attr(AAtrType: Integer): sb1;
    procedure SetSB4Attr(AAtrType: Integer; AValue: Sb4);
    function GetSB4Attr(AAtrType: Integer): sb4;
    property Value: pOCIHandle read FHandle;
    property Handle: pOCIHandle read FHandle write FHandle;
    property HType: ub4 read FType;
    property Error: TOCIError read GetError;
    property Lib: TOCILib read GetLib;
    property Owner: TOCIHandle read FOwner;
    property OwningObj: TObject read FOwningObj;
  end;

  TOCIEnv = class(TOCIHandle)
  private
    FError: TOCIError;
    FLib: TOCILib;
  public
    constructor Create(ALib: TOCILib; AMode: ub4;
      {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
      AOwningObj: TObject = nil);
    constructor CreateUsingHandle(ALib: TOCILib; AHandle: pOCIHandle; AErrHandle: pOCIHandle;
      {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
      AOwningObj: TObject = nil);
    destructor Destroy; override;
    property CACHE_ARRAYFLUSH: sb4 index OCI_ATTR_CACHE_ARRAYFLUSH read GetSb4Attr write SetSb4Attr;
    property CACHE_MAX_SIZE: ub4 index OCI_ATTR_CACHE_MAX_SIZE read GetUb4Attr write SetUb4Attr;
    property CACHE_OPT_SIZE: ub4 index OCI_ATTR_CACHE_OPT_SIZE read GetUb4Attr write SetUb4Attr;
    property OBJECT_: sb4 index OCI_ATTR_OBJECT read GetSb4Attr;
    property PINOPTION: ub4 index OCI_ATTR_PINOPTION read GetUb4Attr write SetUb4Attr;
    property ALLOC_DURATION: ub2 index OCI_ATTR_ALLOC_DURATION read GetUb2Attr write SetUb2Attr;
    property PIN_DURATION: ub2 index OCI_ATTR_PIN_DURATION read GetUb2Attr write SetUb2Attr;
    property HEAPALLOC: ub4 index OCI_ATTR_HEAPALLOC read GetUb4Attr;
    property OBJECT_NEWNOTNULL: sb4 index OCI_ATTR_OBJECT_NEWNOTNULL read GetSb4Attr write SetSb4Attr;
    property OBJECT_DETECTCHANGE: sb4 index OCI_ATTR_OBJECT_DETECTCHANGE read GetSb4Attr write SetSb4Attr;
    property SHARED_HEAPALLOC: ub4 index OCI_ATTR_SHARED_HEAPALLOC read GetUb4Attr;
    property Lib: TOCILib read FLib;
  end;

  EOCINativeException = class(EADDBEngineException)
  public
    constructor Create(AError: TOCIError);
  end;

  EOCISystemException = class(EADException)
  private
    FErrorCode: sb4;
  public
{$IFDEF AnyDAC_BCB}
    constructor Create(AErrorCode: sb4; Dummy: Cardinal = 0);
{$ELSE}
    constructor Create(AErrorCode: sb4);
{$ENDIF}
    procedure Duplicate(var AValue: EADException); override;
    property ErrorCode: sb4 read FErrorCode;
  end;

  TOCIError = class(TOCIHandle)
  private
    FInfo: EOCINativeException;
  public
    constructor Create(AEnv: TOCIEnv);
    constructor CreateUsingHandle(AEnv: TOCIEnv; AErrHandle: pOCIHandle);
    destructor Destroy; override;
    procedure Check(ACode: sword; AInitiator: TObject = nil);
    procedure ClearInfo;
    property Info: EOCINativeException read FInfo;
    property DML_ROW_OFFSET: ub4 index OCI_ATTR_DML_ROW_OFFSET read GetUb4Attr;
  end;

  TOCIService = class(TOCIHandle)
  private
    FOnYield: TNotifyEvent;
    FNonBlockinMode: Boolean;
    FBytesPerChar: ub1;
    procedure DoYield;
    procedure SetNonblockingMode(const Value: Boolean);
  public
    constructor Create(AEnv: TOCIEnv; AOwningObj: TObject = nil);
    constructor CreateUsingHandle(AEnv: TOCIEnv; AHandle: pOCIHandle;
      AOwningObj: TObject = nil);
    procedure Break(ADoException: Boolean);
    procedure Reset(ADoException: Boolean);
    procedure TurnNONBLOCKING_MODE;
    procedure UpdateNonBlockingMode;
    property OnYield: TNotifyEvent read FOnYield write FOnYield;
    property ENV: pOCIHandle index OCI_ATTR_ENV read GetHandleAttr;
    property SERVER: pOCIHandle index OCI_ATTR_SERVER read GetHandleAttr write SetHandleAttr;
    property SESSION: pOCIHandle index OCI_ATTR_SESSION read GetHandleAttr write SetHandleAttr;
    property TRANS: pOCIHandle index OCI_ATTR_TRANS read GetHandleAttr write SetHandleAttr;
    property IN_V8_MODE: ub1 index OCI_ATTR_IN_V8_MODE read GetUb1Attr;
    property NONBLOCKING_MODE: Boolean read FNonBlockinMode write SetNonblockingMode;
    property BytesPerChar: ub1 read FBytesPerChar write FBytesPerChar;
  end;

  TOCISession = class(TOCIHandle)
  private
    FStarted: Boolean;
  public
    constructor Create(AService: TOCIService);
    constructor CreateUsingHandle(AService: TOCIService; AHandle: pOCIHandle);
    destructor Destroy; override;
    procedure Start(const AUser, APassword: String; AAuthentMode: ub4);
    procedure ChangePassword(const AUser, AOldPassword, ANewPassword: String);
    procedure Stop;
    procedure Select;
    property Started: Boolean read FStarted;
    property USERNAME: String index OCI_ATTR_USERNAME read GetStringAttr write SetStringAttr;
    property PASSWORD: String index OCI_ATTR_PASSWORD read GetStringAttr write SetStringAttr;
    property MIGSESSION: ub1 index OCI_ATTR_MIGSESSION read GetUb1Attr write SetUb1Attr;
  end;

  TOCIServer = class(TOCIHandle)
  private
    FAttached: Boolean;
    function GetServerVersion: String;
  public
    constructor Create(AService: TOCIService);
    constructor CreateUsingHandle(AService: TOCIService; AHandle: pOCIHandle);
    destructor Destroy; override;
    procedure Attach(const AServerName: String);
    procedure Detach;
    procedure Select;
    property ServerVersion: String read GetServerVersion;
    property Attached: Boolean read FAttached;
    property ENV: pOCIHandle index OCI_ATTR_ENV read GetHandleAttr;
    property EXTERNAL_NAME: String index OCI_ATTR_EXTERNAL_NAME read GetStringAttr write SetStringAttr;
    property INTERNAL_NAME: String index OCI_ATTR_INTERNAL_NAME read GetStringAttr write SetStringAttr;
    property IN_V8_MODE: ub1 index OCI_ATTR_IN_V8_MODE read GetUb1Attr;
    property FOCBK: Pointer index OCI_ATTR_FOCBK read GetHandleAttr write SetHandleAttr;
    property SERVER_GROUP: String index OCI_ATTR_SERVER_GROUP read GetStringAttr write SetStringAttr;
  end;

  TOCIXid = class(TPersistent)
  private
    FOnChanging, FOnChanged: TNotifyEvent;
    FName: String;
    procedure SetBQUAL(const AValue: String);
    function GetBQUAL: String;
    procedure SetGTRID(const AValue: String);
    function GetGTRID: String;
    function GetIsNull: Boolean;
    procedure SetName(const AValue: String);
  public
    FXID: TXID;
    constructor Create;
    procedure Assign(AValue: TPersistent); override;
    procedure Clear;
    procedure SetParts(const AGTRID, ABQUAL: String);
    procedure MarkTransaction(ATrans: TOCITransaction);
    property IsNull: Boolean read GetIsNull;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  published
    property GTRID: String read GetGTRID write SetGTRID;
    property BQUAL: String read GetBQUAL write SetBQUAL;
    property Name: String read FName write SetName;
  end;

  TOCITransactionMode = (tmDefault, tmReadWrite, tmSerializable, tmReadOnly, tmDiscrete);
  TOCICoupleMode = (omDefault, omTightly, omLoosely);
  TOCITransaction = class(TOCIHandle)
  public
    constructor Create(AService: TOCIService);
    constructor CreateUsingHandle(AService: TOCIService; AHandle: pOCIHandle);
    procedure Detach;
    procedure StartLocal(AMode: TOCITransactionMode);
    procedure StartGlobal(AMode: TOCITransactionMode; ATimeOut: uword;
      ANew: Boolean; ACoupleMode: TOCICoupleMode);
    procedure Commit;
    procedure RollBack;
    procedure Select;
    procedure Prepare2PC;
    procedure Commit2PC;
    procedure Forget;
    procedure GetXID(var AValue: TXID);
    procedure SetXID(var AValue: TXID);
    property TRANS_NAME: String index OCI_ATTR_TRANS_NAME read GetStringAttr write SetStringAttr;
  end;

  TOCIPieceLoopData = record
    lastPieceVarHndl: pOCIHandle;
    lastPieceVar: TOCIVariable;
    lastPieceSize: ub4;
    lastInd: sb2;
    lastIter: ub4;
    lastPiece: ub1;
    lastRCode: ub2;
    lastInOut: ub1;
    lastBuff: pUb1;
  end;

  TOCIVarDataType = (otUnknown, otInteger, otFloat, otNumber, otString, otChar,
    otNString, otNChar, otRaw, otDateTime, otLong, otNLong, otLongRaw, otROWID,
    otCursor, otNestedDataSet, otCLOB, otNCLOB, otBLOB, otCFile, otBFile {,
    otTimeStamp});
  // otCursor must be first handle based data type
  TOCIVarDataTypes = set of TOCIVarDataType;
  TOCIVarType = (odUnknown, odIn, odOut, odInOut, odRet, odDefine);
  TOCIVarTypes = set of TOCIVarType;

  TOCIStatement = class(TOCIHandle)
  private
    FEof: Boolean;
    FLastRowCount: ub4;
    FPieceBuffOwn: Boolean;
    FPieceBuffLen: ub4;
    FPieceBuff: pUb1;
    FPieceOutVars: TList;
    FVars: TList;
    FService: TOCIService;
    FRef: Boolean;
    FCanceled: Boolean;
    FDecimalSep: Char;
    FInrecDataSize: ub4;
    FStrsTrim: LongBool;
    FStrsEmpty2Null: LongBool;
    FStrsMaxSize: ub4;
    procedure SetPieceBuffOwn(AValue: Boolean);
    procedure SetPieceBuffLen(AValue: ub4);
    procedure AllocPieceBuff;
    procedure FreePieceBuff;
    function Hndl2PieceVar(varHndl: pOCIHandle): TOCIVariable;
    function GetPiecedFetch: Boolean;
    procedure InitPiecedFetch(var pld: TOCIPieceLoopData);
    procedure DoPiecedFetch(var APieceLoopData: TOCIPieceLoopData; ARes: sb4);
{$IFDEF AnyDAC_MONITOR}
    procedure DumpColumns(ARows: ub4; AEof: Boolean);
    procedure DumpParameters(ATypes: TOCIVarTypes);
{$ENDIF}
//    function CallbackDefine(Define: pOCIDefine; Iter: cardinal; var Buf: pointer;
//      var BufLen: pUb4; var PieceStatus: ub1; var Ind: pointer): sb4;
    procedure SetInrecDataSize(const Value: ub4);
  protected
    procedure AddPieceVar(AVar: TOCIVariable);
    procedure RemovePieceVar(AVar: TOCIVariable);
    procedure AddVar(AVar: TOCIVariable); overload;
    procedure RemoveVar(AVar: TOCIVariable);
  public
    constructor Create(AEnv: TOCIEnv; AService: TOCIService;
      AOwningObj: TObject = nil);
    constructor CreateUsingHandle(AEnv: TOCIEnv; AService: TOCIService;
      AHandle: pOCIHandle; AOwningObj: TObject = nil);
    destructor Destroy; override;
    procedure AttachToHandle(AHandle: pOCIHandle);
    procedure Prepare(const AStatement: String);
    procedure Describe;
    procedure Execute(ARows, AOffset: sb4; AExact, ACommit: Boolean);
    procedure CancelCursor;
    procedure Fetch(ANRows: ub4);
    function AddVar(const AName: String; AVarType: TOCIVarType;
      ADataType: TOCIVarDataType; ASize: ub4): TOCIVariable; overload;
    function AddVar(APosition: ub4; AVarType: TOCIVarType;
      ADataType: TOCIVarDataType; ASize: ub4): TOCIVariable; overload;
    property PieceBuffOwn: Boolean read FPieceBuffOwn write SetPieceBuffOwn;
    property PieceBuffLen: ub4 read FPieceBuffLen write SetPieceBuffLen;
    property Eof: Boolean read FEof;
    property LastRowCount: ub4 read FLastRowCount;
    property PiecedFetch: Boolean read GetPiecedFetch;
    property Canceled: Boolean read FCanceled;
    property Ref: Boolean read FRef write FRef;
    //
    property DecimalSep: Char read FDecimalSep write FDecimalSep;
    property InrecDataSize: ub4 read FInrecDataSize write SetInrecDataSize;
    property StrsTrim: LongBool read FStrsTrim write FStrsTrim;
    property StrsEmpty2Null: LongBool read FStrsEmpty2Null write FStrsEmpty2Null;
    property StrsMaxSize: ub4 read FStrsMaxSize write FStrsMaxSize;
    //
    property NUM_DML_ERRORS: ub4 index OCI_ATTR_NUM_DML_ERRORS read GetUb4Attr;
    property ENV: pOCIHandle index OCI_ATTR_ENV read GetHandleAttr;
    property STMT_TYPE: ub2 index OCI_ATTR_STMT_TYPE read GetUB2Attr;
    property ROW_COUNT: ub4 index OCI_ATTR_ROW_COUNT read GetUB4Attr;
    property SQLFNCODE: ub2 index OCI_ATTR_SQLFNCODE read GetUB2Attr;
    property ROWID: pOCIRowid index OCI_ATTR_ROWID read GetHandleAttr;
    property PARAM_COUNT: ub4 index OCI_ATTR_PARAM_COUNT read GetUB4Attr;
    property PREFETCH_ROWS: ub4 index OCI_ATTR_PREFETCH_ROWS read GetUB4Attr write SetUB4Attr;
    property PREFETCH_MEMORY: ub4 index OCI_ATTR_PREFETCH_MEMORY read GetUB4Attr write SetUB4Attr;
    property PARSE_ERROR_OFFSET: ub4 index OCI_ATTR_PARSE_ERROR_OFFSET read GetUB4Attr;
  end;

  TBindData = packed record
    FInd: PSb2Array;
    FALen: PUb2Array;
    FRCode: PUb2Array;
    FBuffer: pUb1;
  end;
  PBindData = ^TBindData;

  TOraLong = record
    FSize: ub4;
    FData: pUb1;
  end;
  POraLong = ^TOraLong;

  TOCIBuffStatus = (bsInt, bsExtUnknown, bsExtInit);
  TOCIDataFormat = (dfOCI, dfDataSet, dfDelphi, dfDelphiOwned);

  TOCIVariable = class(TOCIHandle)
  private
    FPlaceHolder: String;
    FPosition: ub4;
    FBindData: PBindData;
    FValue_byte_sz: ub4;  // value max byte length
    FValue_char_sz: ub4;  // value max char length
    FValue_ty: ub2;       // value type
    FMaxArr_len: ub4;     // maximum number of elements
    FCurEle: ub4;         // actual number of elements
    FDataType: TOCIVarDataType;
    FVarType: TOCIVarType;
    FBuffStatus: TOCIBuffStatus;
    FIsPLSQLTable: Boolean;
    FIsCaseSensitive: Boolean;
    FLongData: LongBool;
    FDumpLabel: String;
    FLastBindedBuffer: pUb1;
    procedure SetArrayLen(const Value: ub4);
    procedure SetDataSize(const Value: ub4);
    procedure SetDataType(const Value: TOCIVarDataType);
    procedure SetVarType(const Value: TOCIVarType);
    function GetBuffer(AIndex: ub4): pUb1;
    procedure FreeBuffer;
    procedure CheckRange(AIndex: ub4);
    procedure CheckBufferAccess;
    procedure SetExternBuffer(AValue: pUb1);
    function GetExternBuffer: pUb1;
    procedure FreeLong(pLong: POraLong);
    procedure InitLong(pLong: POraLong);
    procedure GetLong(pLong: POraLong; var AData: pUb1; var ASize: ub4);
    procedure SetLong(pLong: POraLong; AData: pUb1; ASize: ub4; AOwnBuffer: Boolean);
    procedure AppendLong(pLong: POraLong; AData: pUb1; ASize: ub4; AOwnBuffer: Boolean);
    procedure InitLongData;
    procedure CheckOwner;
    function GetDumpLabel: String;
    function UpdateHBlobNullInd(AIndex: ub4): Boolean;
    function GetBindDataSize: ub4;
    procedure MapBuffer;
    procedure ErrUnsupValueType;
    procedure InitCharSize;
  protected
    property Buffer[AIndex: ub4]: pUb1 read GetBuffer;
  public
    constructor Create(AStmt: TOCIStatement);
    destructor Destroy; override;
    procedure Bind;
    // for TOciParam (parameters)
    procedure BindTo(AStmt: TOCIStatement);
    procedure BindOff;
    // for TOCIDeadCursor (external buffer management)
    procedure ClearBuffer(AIndex: sb4);
    procedure InitBuffer(AIndex: sb4);
    procedure ResetBuffer(AIndex: sb4);
    // Value related
    function GetDataPtr(AIndex: ub4; var ABuff: pUb1; var ASize: ub4;
      AFormat: TOCIDataFormat): Boolean;
    function GetData(AIndex: ub4; ABuff: pUb1; var ASize: ub4;
      AFormat: TOCIDataFormat): Boolean;
{$IFDEF AnyDAC_MONITOR}
    function DumpValue(AIndex: ub4): String;
{$ENDIF}
    procedure SetData(AIndex: ub4; ABuff: pUb1; ASize: ub4; AFormat: TOCIDataFormat);
    procedure AppendData(AIndex: ub4; ABuff: pUb1; ASize: ub4);
    procedure SetIsNull(AIndex: ub4; AIsNull: Boolean); // for LOB fields
    // -----------
    property Name: String read FPlaceHolder write FPlaceHolder;
    property Position: ub4 read FPosition write FPosition;
    property DumpLabel: String read GetDumpLabel write FDumpLabel;
    property IsPLSQLTable: Boolean read FIsPLSQLTable write FIsPLSQLTable;
    property IsCaseSensitive: Boolean read FIsCaseSensitive write FIsCaseSensitive;
    property DataType: TOCIVarDataType read FDataType write SetDataType;
    property DataSize: ub4 read FValue_byte_sz write SetDataSize;
    property CharSize: ub4 read FValue_char_sz write FValue_char_sz;
    property VarType: TOCIVarType read FVarType write SetVarType;
    property ArrayLen: ub4 read FMaxArr_len write SetArrayLen;
    property ArrayCount: ub4 read FCurEle;
    // -----------
    property ExternBuffer: pUb1 read GetExternBuffer write SetExternBuffer;
    property BindDataSize: ub4 read GetBindDataSize;
    property LongData: LongBool read FLongData write FLongData;
    // -----------
    property CHAR_COUNT: ub4 index OCI_ATTR_CHAR_COUNT read GetUb4Attr write SetUb4Attr;
    property CHARSET_ID: ub2 index OCI_ATTR_CHARSET_ID read GetUb2Attr write SetUb2Attr;
    property CHARSET_FORM: ub1 index OCI_ATTR_CHARSET_FORM read GetUb1Attr write SetUb1Attr;
    property PDPRC: ub2 index OCI_ATTR_PDPRC read GetUb2Attr write SetUb2Attr;
    property PDSCL: ub2 index OCI_ATTR_PDSCL read GetUb2Attr write SetUb2Attr;
    property ROWS_RETURNED: ub4 index OCI_ATTR_ROWS_RETURNED read GetUB4Attr;
    property MAXDATA_SIZE: sb4 index OCI_ATTR_MAXDATA_SIZE read GetSb4Attr write SetSb4Attr;
    property MAXCHAR_SIZE: sb4 index OCI_ATTR_MAXCHAR_SIZE read GetSb4Attr write SetSb4Attr;
  end;

  TOCIDescriptor = class(TOCIHandle)
  private
    function Init(AEnv: TOCIHandle; AType: ub4): pOCIDescriptor;
  public
    destructor Destroy; override;
  end;

  TOCISelectItem = class(TOCIDescriptor)
  private
    FPosition: sb4;
    function GetDataType: TOCIVarDataType;
    function GetDataSize: ub4;
    function GetVarType: TOCIVarType;
    function GetIsNull: Boolean;
    function GetDataPrecision: ub4;
    function GetDataScale: ub4;
    function GetBytesPerChar: ub1;
    function GetCharSize: ub2;
    function GetIsUnicode: Boolean;
  public
    constructor Create(AStmt: TOCIStatement);
    destructor Destroy; override;
    procedure Bind;
    property Position: sb4 read FPosition write FPosition;
    property DataType: TOCIVarDataType read GetDataType;
    property DataSize: ub4 read GetDataSize;
    property CharSize: ub2 read GetCharSize;
    property DataPrecision: ub4 read GetDataPrecision;
    property DataScale: ub4 read GetDataScale;
    property VarType: TOCIVarType read GetVarType;
    property IsNull: Boolean read GetIsNull;
    property BytesPerChar: ub1 read GetBytesPerChar;
    property IsUnicode: Boolean read GetIsUnicode;
    property DATA_SIZE: ub4 index OCI_ATTR_DATA_SIZE read GetUb4Attr;
    property DATA_TYPE: ub4 index OCI_ATTR_DATA_TYPE read GetUb4Attr;
    property DISP_SIZE: ub4 index OCI_ATTR_DISP_SIZE read GetUb4Attr;
    property NAME: String index OCI_ATTR_NAME read GetStringAttr;
    property PRECISION: ub4 index OCI_ATTR_PRECISION read GetUb4Attr;
    property SCALE: ub4 index OCI_ATTR_SCALE read GetUb4Attr;
    property IS_NULL: ub4 index OCI_ATTR_IS_NULL read GetUb4Attr;
    property TYPE_NAME: String index OCI_ATTR_TYPE_NAME read GetStringAttr;
    property SUB_NAME: String index OCI_ATTR_SUB_NAME read GetStringAttr;
    property SCHEMA_NAME: String index OCI_ATTR_SCHEMA_NAME read GetStringAttr;
    property IOMODE: ub1 index OCI_ATTR_IOMODE read GetUB1Attr;
    property CHARSET_ID: ub2 index OCI_ATTR_CHARSET_ID read GetUB2Attr;
    property CHARSET_FORM: ub1 index OCI_ATTR_CHARSET_FORM read GetUB1Attr;
    property CHAR_SIZE: ub2 index OCI_ATTR_CHAR_SIZE read GetUB2Attr;
    property CHAR_USED: ub4 index OCI_ATTR_CHAR_USED read GetUB4Attr;
  end;

  TOCILobLocator = class(TOCIDescriptor)
  private
    FOwned: Boolean;
    FNational: Boolean;
    function GetLength: sb4;
    function GetIsOpen: LongBool;
    function GetIsInit: LongBool;
  public
    constructor Create(AService: TOCIService; AType: ub4);
    constructor CreateUseHandle(AService: TOCIService; AHandle: pOCIHandle); virtual;
    destructor Destroy; override;
    procedure Assign(AFrom: TOCILobLocator);
    procedure Close;
    procedure Open(AReadOnly: Boolean);
    procedure Read(ABuff: pUb1; ABuffLen: ub4; var amount: ub4; offset: ub4);
    property Length: sb4 read GetLength;
    property IsOpen: LongBool read GetIsOpen;
    property IsInit: LongBool read GetIsInit;
    property National: Boolean read FNational write FNational;
  end;

  TOCIIntLocator = class(TOCILobLocator)
  private
    FBuffering: Boolean;
    procedure SetBuffering(const Value: Boolean);
    function GetIsTemporary: LongBool;
  public
    constructor CreateUseHandle(AService: TOCIService; AHandle: pOCIHandle); override;
    procedure Append(AFrom: TOCIIntLocator);
    procedure Copy(AFrom: TOCIIntLocator; amount, dst_offset, src_offset: ub4);
    procedure Erase(var amount: ub4; offset: ub4);
    procedure FlushBuffer;
    procedure LoadFromFile(AFrom: TOCIExtLocator; amount, dst_offset, src_offset: ub4);
    procedure Trim(ANewLen: ub4);
    procedure Write(ABuff: pUb1; ABuffLen: ub4; var amount: ub4; offset: ub4);
    property IsTemporary: LongBool read GetIsTemporary;
    property Buffering: Boolean read FBuffering write SetBuffering;
  end;

  TOCITempLocator = class(TOCIIntLocator)
  public
    constructor CreateTemp(AService: TOCIService; ALobType: ub1; ACache: Boolean);
    destructor Destroy; override;
  end;

  TOCIExtLocator = class(TOCILobLocator)
  private
    function GetFileExists: LongBool;
    function GetDirectory: String;
    function GetFileName: String;
    procedure SetDirectory(const Value: String);
    procedure SetFileName(const Value: String);
    procedure GetFileDir(var ADir, AFileName: String);
    procedure SetFileDir(const ADir, AFileName: String);
  public
    constructor CreateUseHandle(AService: TOCIService; AHandle: pOCIHandle); override;
    property FileExists: LongBool read GetFileExists;
    property FileName: String read GetFileName write SetFileName;
    property Directory: String read GetDirectory write SetDirectory;
  end;

  TOCIDescribe = class(TOCIHandle)
  private
    FCurr: TOCIHandle;
    FStack: TList;
    function GetPtr(AIndex: Integer): Pointer;
    function GetSB1(AIndex: Integer): sb1;
    function GetText(AIndex: Integer): String;
    function GetUB1(AIndex: Integer): ub1;
    function GetUB2(AIndex: Integer): ub2;
    function GetUB4(AIndex: Integer): ub4;
    function GetSelectItem(AIndex: Integer): TOCISelectItem;
    function GetIsListOpened: Boolean;
  public
    constructor Create(ASvc: TOCIService);
    destructor Destroy; override;
    procedure DescribeName(const AName: String);
    function OpenList(AAtrType: Integer): ub4;
    procedure CloseList;
    procedure GoToItem(AIndex: Integer);
    property SB1[AIndex: Integer]: sb1 read GetSB1;
    property UB1[AIndex: Integer]: ub1 read GetUB1;
    property UB2[AIndex: Integer]: ub2 read GetUB2;
    property UB4[AIndex: Integer]: ub4 read GetUB4;
    property TEXT[AIndex: Integer]: String read GetText;
    property PTR[AIndex: Integer]: Pointer read GetPtr;
    property SelectItem[AIndex: Integer]: TOCISelectItem read GetSelectItem;
    property IsListOpened: Boolean read GetIsListOpened;
  end;

  TOCIDirectPath = class(TOCIHandle)
  private
    function GetColumns(AIndex: Integer): TOCIDirectPathColumnParam;
  public
    constructor Create(ASvc: TOCIService);
    procedure AbortJob;
    procedure Finish;
    procedure Prepare;
    procedure LoadStream(AStream: TOCIDirectPathStream);
    property BUF_SIZE: ub4 index OCI_ATTR_BUF_SIZE read GetUB4Attr write SetUB4Attr;
    property CHARSET_ID: ub2 index OCI_ATTR_CHARSET_ID read GetUB2Attr write SetUB2Attr;
    property DATEFORMAT: String index OCI_ATTR_DATEFORMAT read GetStringAttr write SetStringAttr;
    property DIRPATH_MODE: ub1 index OCI_ATTR_DIRPATH_MODE read GetUB1Attr write SetUB1Attr;
    property DIRPATH_NOLOG: ub1 index OCI_ATTR_DIRPATH_NOLOG read GetUB1Attr write SetUB1Attr;
    property DIRPATH_PARALLEL: ub1 index OCI_ATTR_DIRPATH_PARALLEL read GetUB1Attr write SetUB1Attr;
    property NUM_COLS: ub2 index OCI_ATTR_NUM_COLS read GetUB2Attr write SetUB2Attr;
    property LIST_COLUMNS: pOCIHandle index OCI_ATTR_LIST_COLUMNS read GetHandleAttr;
    property SCHEMA_NAME: String index OCI_ATTR_SCHEMA_NAME read GetStringAttr write SetStringAttr;
    property NAME: String index OCI_ATTR_NAME read GetStringAttr write SetStringAttr;
    property SUB_NAME: String index OCI_ATTR_SUB_NAME read GetStringAttr write SetStringAttr;
    property Columns[AIndex: Integer]: TOCIDirectPathColumnParam read GetColumns;
  end;

  TOCIDirecPathDataType = (dpUnknown, dpString, dpDateTime, dpInteger,
    dpUInteger, dpFloat, dpRaw);
  TOCIDirecPathDataTypes = set of TOCIDirecPathDataType;
  TOCIDirectPathColArray = class(TOCIHandle)
  public
    constructor Create(ADP: TOCIDirectPath);
    procedure EntryGet(ARowNum: ub4; AColIndex: ub2; var AData: pUb1; var ALen: ub4; var AFlag: ub1);
    procedure EntrySet(ARowNum: ub4; AColIndex: ub2; AData: pUb1; ALen: ub4; AFlag: ub1);
    procedure RowGet(ARowNum: ub4; var ADataArr: ppUb1; var ALenArr: pUb4; var AFlagArr: pUb1);
    procedure Reset;
    function ToStream(AStream: TOCIDirectPathStream; ARowCount, ARowIndex: ub4): sword;
    property NUM_COLS: ub2 index OCI_ATTR_NUM_COLS read GetUB2Attr write SetUB2Attr;
    property NUM_ROWS: ub2 index OCI_ATTR_NUM_ROWS read GetUB2Attr write SetUB2Attr;
    property COL_COUNT: ub2 index OCI_ATTR_COL_COUNT read GetUB2Attr write SetUB2Attr;
    property ROW_COUNT: ub2 index OCI_ATTR_ROW_COUNT read GetUB2Attr write SetUB2Attr;
  end;

  TOCIDirectPathStream = class(TOCIHandle)
  public
    constructor Create(ADP: TOCIDirectPath);
    procedure Reset;
    property BUF_ADDR: Pointer index OCI_ATTR_BUF_ADDR read GetHandleAttr write SetHandleAttr;
    property BUF_SIZE: ub4 index OCI_ATTR_BUF_SIZE read GetUB4Attr write SetUB4Attr;
    property ROW_COUNT: ub4 index OCI_ATTR_ROW_COUNT read GetUB4Attr write SetUB4Attr;
    property STREAM_OFFSET: ub4 index OCI_ATTR_STREAM_OFFSET read GetUB4Attr write SetUB4Attr;
  end;

  TOCIDirectPathColumnParam = class(TOCIDescriptor)
  private
    function GetDataType: TOCIDirecPathDataType;
    procedure SetDataType(AValue: TOCIDirecPathDataType);
  public
    constructor Create(ADP: TOCIDirectPath);
    property CHARSET_ID: ub2 index OCI_ATTR_CHARSET_ID read GetUB2Attr write SetUB2Attr;
    property DATA_SIZE: ub4 index OCI_ATTR_DATA_SIZE read GetUB4Attr write SetUB4Attr;
    property DATA_TYPE: ub2 index OCI_ATTR_DATA_TYPE read GetUB2Attr write SetUB2Attr;
    property DATEFORMAT: String index OCI_ATTR_DATEFORMAT read GetStringAttr write SetStringAttr;
    property NAME: String index OCI_ATTR_NAME read GetStringAttr write SetStringAttr;
    property PRECISION: ub1 index OCI_ATTR_PRECISION read GetUB1Attr write SetUB1Attr;
    property SCALE: sb1 index OCI_ATTR_SCALE read GetSB1Attr write SetSB1Attr;
    property DataType: TOCIDirecPathDataType read GetDataType write SetDataType;
  end;

  TOCIOnDefineParam = procedure (const ANm: String; AVt: TOCIVarType;
    ADt: TOCIVarDataType; ASz, APrec, ASCale: sb4; AIsTable, AIsResult: Boolean) of object;
  TOCIPLSQLDescriber = class(TObject)
  private
    // setup
    FSrvc: TOCIService;
    FOwningObj: TObject;
    FOPackageName, FOProcedureName: String;
    FOverload: Integer;
    FBoolTrue, FBoolFalse: String;
    FBoolType: TOCIVarDataType;
    FBoolSize: sb4;
    // run time
    FDescr: TOCIDescribe;
    FSPName: String;
    FObjType: ub1;
    FNumProcs: ub4;
    FProcIndex: ub4;
    FForProc: Boolean;
  public
    constructor CreateForProc(ASrvc: TOCIService; AOPackageName,
      AOProcedureName: String; AOverload: Integer; AOwningObj: TObject = nil);
    constructor CreateForPack(ASrvc: TOCIService; AOPackageName: String;
      AOwningObj: TObject = nil);
    destructor Destroy; override;
    procedure Describe;
    procedure LocateProc;
    procedure First(var AProcName: String; var AOverload: Integer);
    procedure Next(var AProcName: String; var AOverload: Integer);
    function EOL: Boolean;
    function BuildSQL(AOnDefPar: TOCIOnDefineParam): String;
    procedure CleanUp;
    property Descr: TOCIDescribe read FDescr;
    property ObjType: ub1 read FObjType;
    property BoolFalse: String read FBoolFalse write FBoolFalse;
    property BoolTrue: String read FBoolTrue write FBoolTrue;
    property BoolType: TOCIVarDataType read FBoolType write FBoolType;
    property BoolSize: sb4 read FBoolSize write FBoolSize;
    property OwningObj: TObject read FOwningObj;
  end;

(*
  TOCITimestamp = class(TObject)
    timestamphp: OCIDateTime;
    errhp: OCIError;
    FDataType: Integer;
    HandleOwner: Boolean;
    FSession: TOracleSession;
    FYear: SmallInt;
    FMonth: Byte;
    FDay: Byte;
    FHour: Byte;
    FMinute: Byte;
    FSecond: Byte;
    FNanoSeconds: Cardinal;
    FTZHour: ShortInt;
    FTZMinute: ShortInt;
    FIsNull: Boolean;
    Owner: TOracleObject;
    OwnerAttrName: string;
    NullStruct: Psb2Array;
    procedure OCICall(Err: Integer);
    function  GetDataType: Integer;
    procedure SetDateFields;
    function  GetYear: SmallInt;
    function  GetMonth: Byte;
    function  GetDay: Byte;
    procedure SetTimeFields;
    function  GetHour: Byte;
    function  GetMinute: Byte;
    function  GetSecond: Byte;
    function  GetNanoSeconds: Cardinal;
    function  GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    function  GetAsString: string;
    procedure SetAsString(const Value: string);
    function  GetAsOracleString: string;
    procedure SetAsOracleString(const Value: string);
    procedure SetHandle(hndl: OCIDateTime; Owner: Boolean; ADataType: Integer; AIsNull: Boolean);
    procedure Modified;
    function  GetTZHour: Byte;
    function  GetTZMinute: Byte;
    procedure SetTZFields;
  public
    constructor Create(ASession: TOracleSession; ADataType: Integer);
    destructor Destroy; override;
    procedure SetValues(AYear: SmallInt; AMonth, ADay, AHour, AMinute, ASecond: Byte;
      ANanoSeconds: Cardinal);
    procedure SetValuesTZ(AYear: SmallInt; AMonth, ADay, AHour, AMinute, ASecond: Byte;
      ANanoSeconds: Cardinal; ATZHour, ATZMinute: ShortInt);
    procedure Assign(Source: TOracleTimestamp);
    procedure Clear;
    property Session: TOracleSession read FSession;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsString: string read GetAsString write SetAsString;
    property AsOracleString: string read GetAsOracleString write SetAsOracleString;
    property DataType: Integer read GetDataType;
    property Year: SmallInt read GetYear;
    property Month: Byte read GetMonth;
    property Day: Byte read GetDay;
    property Hour: Byte read GetHour;
    property Minute: Byte read GetMinute;
    property Second: Byte read GetSecond;
    property NanoSeconds: Cardinal read GetNanoSeconds;
    property TZHour: Byte read GetTZHour;
    property TZMinute: Byte read GetTZMinute;
    property IsNull: Boolean read FIsNull;
  end;
*)  

const
  otCrsTypes: TOCIVarDataTypes = [otCursor, otNestedDataSet];
  otHTypes: TOCIVarDataTypes = [otCursor, otNestedDataSet, otCLOB, otNCLOB, otBLOB,
    otCFile, otBFile];
  otHBlobs: TOCIVarDataTypes = [otCLOB, otNCLOB, otBLOB, otCFile, otBFile];
  otVBlobs: TOCIVarDataTypes = [otLong, otNLong, otLongRaw];
  otAllBlobs: TOCIVarDataTypes = [otLong, otNLong, otLongRaw, otCLOB, otNCLOB,
    otBLOB, otCFile, otBFile];

  nc2ociValueType: array[TOCIVarDataType] of ub2 = (0, SQLT_INT, SQLT_FLT, SQLT_CHR,
    SQLT_CHR, SQLT_CHR, SQLT_CHR, SQLT_CHR, SQLT_BIN, SQLT_DAT, SQLT_LNG, SQLT_LNG,
    SQLT_LBI, SQLT_CHR, SQLT_RSET, SQLT_RSET, SQLT_CLOB, SQLT_CLOB, SQLT_BLOB,
    SQLT_CFILEE, SQLT_BFILEE);
  nc2ociValueSize: array[TOCIVarDataType] of sb4 = (0, SizeOf(Integer),
    SizeOf(Double), IMaxNumPrecision + 2, IDefStrSize, IDefStrSize,
    IDefStrSize * SizeOf(WideChar), IDefStrSize * SizeOf(WideChar),
    IDefStrSize, SizeOf(TOraDate), IDefLongSize, IDefLongSize,
    IDefLongSize, IRowIdLen, sizeof(pOCIStmt), sizeof(pOCIStmt),
    sizeof(pOCILobLocator), sizeof(pOCILobLocator), sizeof(pOCILobLocator),
    sizeof(pOCILobLocator), sizeof(pOCILobLocator));

  nc2ociDPDataType: array[TOCIDirecPathDataType] of ub2 = (0, SQLT_CHR, SQLT_DAT,
    SQLT_INT, SQLT_UIN, SQLT_FLT, SQLT_BIN);
  nc2ociDPValueSize: array[TOCIDirecPathDataType] of sb4 = (0, IDefStrSize,
    SizeOf(TOraDate), SizeOf(Integer), SizeOf(Cardinal), SizeOf(Double), IDefStrSize);

  procedure OraDate2DateTime(pIn: pUb1; var D: TDateTime);
  procedure DateTime2OraDate(pOut: pUb1; const D: TDateTime);
  procedure OraDate2SQLTimeStamp(pIn: pUb1; var D: TADSQLTimeStamp);
  procedure SQLTimeStamp2OraDate(pOut: pUb1; const D: TADSQLTimeStamp);

implementation

Uses
  Registry,
  daADStanUtil;

// --------------------------------------------------------------------------
// --------------------------------------------------------------------------

const
  National2SQLCS: array [Boolean] of ub1 = (SQLCS_IMPLICIT, SQLCS_NCHAR);
  National2CSID: array [Boolean] of ub2 = (0, OCI_UTF16ID);

{$IFDEF AnyDAC_MONITOR}
  dataTypeName: array[TOCIVarDataType] of String =
    ('otUnknown', 'otInteger', 'otFloat', 'otNumber', 'otString', 'otChar',
     'otNString', 'otNChar', 'otRaw', 'otDateTime', 'otLong', 'otNLong',
     'otLongRaw', 'otROWID', 'otCursor', 'otDataSet', 'otCLOB', 'otNCLOB',
     'otBLOB', 'otCFile', 'otBFile');

  varTypeName: array[TOCIVarType] of String =
    ('odUnknown', 'odIn', 'odOut', 'odInOut', 'odRet', 'odDefine');

  hndlNames: array[1 .. 74] of String =
  ('OCI_HTYPE_ENV',
   'OCI_HTYPE_ERROR',
   'OCI_HTYPE_SVCCTX',
   'OCI_HTYPE_STMT',
   'OCI_HTYPE_BIND',
   'OCI_HTYPE_DEFINE',
   'OCI_HTYPE_DESCRIBE',
   'OCI_HTYPE_SERVER',
   'OCI_HTYPE_SESSION',
   'OCI_HTYPE_TRANS',
   'OCI_HTYPE_COMPLEXOBJECT',
   'OCI_HTYPE_SECURITY',
   'OCI_HTYPE_SUBSCRIPTION',
   'OCI_HTYPE_DIRPATH_CTX',
   'OCI_HTYPE_DIRPATH_COLUMN_ARRAY',
   'OCI_HTYPE_DIRPATH_STREAM',
   'OCI_HTYPE_PROC',
   '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
   'OCI_DTYPE_LOB',
   'OCI_DTYPE_SNAP',
   'OCI_DTYPE_RSET',
   'OCI_DTYPE_PARAM',
   'OCI_DTYPE_ROWID',
   'OCI_DTYPE_COMPLEXOBJECTCOMP',
   'OCI_DTYPE_FILE',
   'OCI_DTYPE_AQENQ_OPTIONS',
   'OCI_DTYPE_AQDEQ_OPTIONS',
   'OCI_DTYPE_AQMSG_PROPERTIES',
   'OCI_DTYPE_AQAGENT',
   'OCI_DTYPE_LOCATOR',
   'OCI_DTYPE_DATETIME',
   'OCI_DTYPE_INTERVAL',
   'OCI_DTYPE_AQNFY_DESCRIPTOR',
   // post 8.1
   'OCI_DTYPE_DATE',
   'OCI_DTYPE_TIME',
   'OCI_DTYPE_TIME_TZ',
   'OCI_DTYPE_TIMESTAMP',
   'OCI_DTYPE_TIMESTAMP_TZ',
   'OCI_DTYPE_TIMESTAMP_LTZ',
   'OCI_DTYPE_UCB',
   'OCI_DTYPE_SRVDN',
   'OCI_DTYPE_SIGNATURE',
   'OCI_DTYPE_RESERVED_1'
  );

  LobTypeNames: array[1 .. 3] of String =
  ('OCI_TEMP_BLOB',
   'OCI_TEMP_CLOB',
   'OCI_TEMP_NCLOB'
  );
{$ENDIF}

  sOCIEnvCreate: String = 'OCIEnvCreate';
  sOCIInitialize: String = 'OCIInitialize';
  sOCIEnvInit: String = 'OCIEnvInit';

  sOCIHandleAlloc: String = 'OCIHandleAlloc';
  sOCIHandleFree: String = 'OCIHandleFree';
  sOCIAttrSet: String = 'OCIAttrSet';
  sOCIAttrGet: String = 'OCIAttrGet';
  sOCIDescriptorAlloc: String = 'OCIDescriptorAlloc';
  sOCIDescriptorFree: String = 'OCIDescriptorFree';
  sOCIErrorGet: String = 'OCIErrorGet';

  sOCIServerAttach: String = 'OCIServerAttach';
  sOCIServerDetach: String = 'OCIServerDetach';
  sOCIServerVersion: String = 'OCIServerVersion';
  sOCIBreak: String = 'OCIBreak';
  sOCIReset: String = 'OCIReset';

  sOCISessionBegin: String = 'OCISessionBegin';
  sOCISessionEnd: String = 'OCISessionEnd';
  sOCIPasswordChange: String = 'OCIPasswordChange';

  sOCITransStart: String = 'OCITransStart';
  sOCITransCommit: String = 'OCITransCommit';
  sOCITransRollback: String = 'OCITransRollback';
  sOCITransDetach: String = 'OCITransDetach';
  sOCITransPrepare: String = 'OCITransPrepare';
  sOCITransForget: String = 'OCITransForget';

  sOCIStmtPrepare: String = 'OCIStmtPrepare';
  sOCIStmtExecute: String = 'OCIStmtExecute';
  sOCIStmtFetch: String = 'OCIStmtFetch';
  sOCIStmtGetPieceInfo: String = 'OCIStmtGetPieceInfo';
  sOCIStmtSetPieceInfo: String = 'OCIStmtSetPieceInfo';
  sOCIParamGet: String = 'OCIParamGet';
  sOCIResultSetToStmt: String = 'OCIResultSetToStmt';

  sOCIDefineByPos: String = 'OCIDefineByPos';
  sOCIDefineArrayOfStruct: String = 'OCIDefineArrayOfStruct';

  sOCIBindByPos: String = 'OCIBindByPos';
  sOCIBindByName: String = 'OCIBindByName';
  sOCIBindDynamic: String = 'OCIBindDynamic';

  sOCILobAppend: String = 'OCILobAppend';
  sOCILobAssign: String = 'OCILobAssign';
  sOCILobCopy: String = 'OCILobCopy';
  sOCILobEnableBuffering: String = 'OCILobEnableBuffering';
  sOCILobDisableBuffering: String = 'OCILobDisableBuffering';
  sOCILobErase: String = 'OCILobErase';
  sOCILobFileExists: String = 'OCILobFileExists';
  sOCILobFileGetName: String = 'OCILobFileGetName';
  sOCILobFileSetName: String = 'OCILobFileSetName';
  sOCILobFlushBuffer: String = 'OCILobFlushBuffer';
  sOCILobGetLength: String = 'OCILobGetLength';
  sOCILobLoadFromFile: String = 'OCILobLoadFromFile';
  sOCILobLocatorIsInit: String = 'OCILobLocatorIsInit';
  sOCILobRead: String = 'OCILobRead';
  sOCILobTrim: String = 'OCILobTrim';
  sOCILobWrite: String = 'OCILobWrite';

  sOCILobClose: String = 'OCILobClose';
  sOCILobIsOpen: String = 'OCILobIsOpen';
  sOCILobOpen: String = 'OCILobOpen';
  sOCILobCreateTemporary: String = 'OCILobCreateTemporary';
  sOCILobFreeTemporary: String = 'OCILobFreeTemporary';
  sOCILobIsTemporary: String = 'OCILobIsTemporary';
  sOCILobFileClose: String = 'OCILobFileClose';
  sOCILobFileIsOpen: String = 'OCILobFileIsOpen';
  sOCILobFileOpen: String = 'OCILobFileOpen';

  sOCIDescribeAny: String = 'OCIDescribeAny';

  sOCIDirPathAbort: String = 'OCIDirPathAbort';
  sOCIDirPathDataSave: String = 'OCIDirPathDataSave';
  sOCIDirPathFinish: String = 'OCIDirPathFinish';
  sOCIDirPathFlushRow: String = 'OCIDirPathFlushRow';
  sOCIDirPathPrepare: String = 'OCIDirPathPrepare';
  sOCIDirPathLoadStream: String = 'OCIDirPathLoadStream';
  sOCIDirPathColArrayEntryGet: String = 'OCIDirPathColArrayEntryGet';
  sOCIDirPathColArrayEntrySet: String = 'OCIDirPathColArrayEntrySet';
  sOCIDirPathColArrayRowGet: String = 'OCIDirPathColArrayRowGet';
  sOCIDirPathColArrayReset: String = 'OCIDirPathColArrayReset';
  sOCIDirPathColArrayToStream: String = 'OCIDirPathColArrayToStream';
  sOCIDirPathStreamReset: String = 'OCIDirPathStreamReset';
  sOCIDirPathStreamToStream: String = 'OCIDirPathStreamToStream';

{-------------------------------------------------------------------------------}
function NormalizePath(const APath: String): String;
begin
  if (APath <> '') and (APath[Length(APath)] = '\') then
    Result := Copy(APath, 1, Length(APath) - 1)
  else
    Result := APath;
end;

{-------------------------------------------------------------------------------}
function GetRegPathVar(AReg: TRegistry; const AName: String): String;
begin
  Result := NormalizePath(AReg.ReadString(AName));
end;

{-------------------------------------------------------------------------------}
{ TOCILib                                                                       }
{-------------------------------------------------------------------------------}
constructor TOCILib.Create(const AVendorHome, AVendorLib: String;
  AOwningObj: TObject);
begin
  inherited Create;
  FOwningObj := AOwningObj;
  GetOCIPaths(AVendorHome, AVendorLib);
  GetOCIVersion;
  GetTNSPaths;
  LoadOCILibrary;
  LoadOCIEntrys;
end;

{-------------------------------------------------------------------------------}
destructor TOCILib.Destroy;
begin
  FreeLibrary(FOCIhDll);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCILib.GetOCIPaths(const AVendorHome, AVendorLib: String);
var
  s: String;
  sHome: String;
  sLib: String;
  bestInd, i, n: Integer;
  path: String;
  reg: TRegistry;
  oSubKeys: TStringList;

  procedure InitBest;
  begin
    FOCIInstantClient := False;
    bestInd := MAXINT;
    FOCIOracleHome := '';
    path := ADReadEnvValue('PATH');
  end;

  function TestBestHome(const AKey: String): Boolean;
  var
    i: Integer;
    bin, home: String;

    procedure GetHomeVars;
    begin
      FOCIKey := AKey;
      FOCIOracleHome := home;
      FOCIDllName := reg.ReadString('ORAOCI');
      FOCIInstantClient := False;
    end;

{$IFNDEF AnyDAC_D6Base}
    function DirectoryExists(const Directory: string): Boolean;
    var
      Code: Integer;
    begin
      Code := GetFileAttributes(PChar(Directory));
      Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
    end;
{$ENDIF}

  begin
    Result := reg.OpenKeyReadOnly(AKey);
    if Result then begin
      home := GetRegPathVar(reg, 'ORACLE_HOME');
      bin := home + '\bin';
      if sHome <> '' then begin
        if (AnsiCompareText(reg.ReadString('ORACLE_HOME_NAME'), sHome) = 0) or
           (AnsiCompareText(home, NormalizePath(sHome)) = 0) then
          GetHomeVars;
      end
      else begin
        i := 1;
        while i <= Length(path) do begin
          if AnsiCompareText(bin, NormalizePath(ADExtractFieldName(path, i))) = 0 then begin
            if DirectoryExists(bin) and (bestInd > i) then begin
              bestInd := i;
              GetHomeVars;
            end;
            Break;
          end;
        end;
      end;
    end;
  end;

  procedure TestInstantClient;
  var
    i: Integer;
    path, s: String;
{$IFNDEF AnyDAC_D6}
    ModName: array[0..MAX_PATH] of Char;
{$ENDIF}
  begin
{$IFDEF AnyDAC_D6}
    path := GetModuleName(HInstance);
{$ELSE}
    SetString(path, ModName, GetModuleFileName(HInstance, ModName, SizeOf(ModName)));
{$ENDIF}
    path := ExtractFilePath(path);
    path := Copy(path, 1, Length(path) - 1);
    s := path + '\oci.dll';
    if FileExists(s) then begin
      bestInd := 0;
      FOCIKey := '\Software\Oracle';
      FOCIOracleHome := path;
      FOCIDllName := s;
      FOCIInstantClient := True;
      Exit;
    end;
    path := ADReadEnvValue('PATH');
    i := 1;
    while i <= Length(path) do begin
      path := ADExtractFieldName(path, i);
      s := NormalizePath(path) + '\oci.dll';
      if FileExists(s) then begin
        bestInd := i;
        FOCIKey := '\Software\Oracle';
        FOCIOracleHome := path;
        FOCIDllName := s;
        FOCIInstantClient := True;
        Exit;
      end;
    end;
  end;

begin
  if AVendorHome <> '' then
    sHome := AVendorHome
  else
    sHome := ADReadEnvValue('ORACLE_HOME');
  if AVendorLib <> '' then
    sLib := AVendorLib
  else
    sLib := ADReadEnvValue('ORAOCI');

  reg := TRegistry.Create;
  with reg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    InitBest;

    // Check for instant client
    TestInstantClient;

    // Check for regular Oracle homes
    if TestBestHome('\Software\Oracle') then begin
      if OpenKeyReadOnly('\Software\Oracle\All_Homes') then begin
        s := ReadString('HOME_COUNTER');
        if s = '' then
          n := 1
        else
          n := StrToInt(s);
        for i := 0 to n - 1 do
          TestBestHome('\Software\Oracle\Home' + IntToStr(i));
      end;
      // search for ORACLE_HOME in the subkeys of HKLM\Software\Oracle because
      // the 10g client seams to have no ORACLE_HOME in HKLM\Software\Oracle or
      // HKLM\Software\Oracle\All_Homes
      if OpenKeyReadOnly('\Software\Oracle') then begin
        oSubKeys := TStringList.Create;
        try
          GetKeyNames(oSubKeys);
          for i := 0 to oSubKeys.Count - 1 do
            if AnsiStrLIComp(PChar(oSubKeys[i]), 'KEY_', 4) = 0 then
              TestBestHome('\Software\Oracle\' + oSubKeys[i]);
        finally
          oSubKeys.Free;
        end;
      end;
    end;

    if FOCIOracleHome = '' then
      ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraNotInstalled, []);
    if sLib <> '' then
      FOCIDllName := sLib
    else if FOCIDllName = '' then begin
      FOCIDllName := FOCIOracleHome + '\Bin\OCI.DLL';
      // single case, when things differs - 8.0.3
      if not FileExists(FOCIDllName) then
        FOCIDllName := FOCIOracleHome + '\Bin\ORA803.DLL';
    end;
  finally
    Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCILib.GetTNSPaths;
var
  reg: TRegistry;
begin
  FOCITnsNames := ADReadEnvValue('TNS_NAMES');
  if FOCITnsNames <> '' then
    Exit;
  FOCITnsNames := ADReadEnvValue('TNS_ADMIN');
  if FOCITnsNames <> '' then begin
    FOCITnsNames := FOCITnsNames + '\TNSNames.ora';
    Exit;
  end;
  reg := TRegistry.Create;
  with reg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKeyReadOnly(FOCIKey);
    FOCITnsNames := ReadString('TNS_NAMES');
    if FOCITnsNames = '' then begin
      FOCITnsNames := GetRegPathVar(reg, 'TNS_ADMIN');
      if FOCITnsNames = '' then begin
        if FOCIVersion >= cvOracle81000 then
          FOCITnsNames := GetRegPathVar(reg, 'NETWORK')
        else
          FOCITnsNames := GetRegPathVar(reg, 'NET80');
        if FOCIInstantClient then
          FOCITnsNames := FOCIOracleHome
        else begin
          if FOCITnsNames = '' then begin
            if FOCIVersion >= cvOracle81000 then
              FOCITnsNames := FOCIOracleHome + '\Network'
            else
              FOCITnsNames := FOCIOracleHome + '\Net80';
          end;
          FOCITnsNames := FOCITnsNames + '\Admin';
        end;
      end;
      FOCITnsNames := FOCITnsNames + '\TNSNames.ora';
    end;
  finally
    Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCILib.RaiseOCINotLoaded;
begin
  ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_AccCantLoadLibrary,
    [FOCIDllName, ADLastSystemErrorMsg, FOCIDllName]);
end;

{-------------------------------------------------------------------------------}
procedure TOCILib.GetOCIVersion;
const
  undef: String = '<UNDEFINED>';
var
  sProc, sVer, sVerName, sCopyr, sInfo: String;
begin
  FOCIVersion := 0;
  sProc := '';
  sVer := '';
  sVerName := '';
  sCopyr := '';
  sInfo := '';
  if not ADGetVersionInfo(FOCIDllName, sProc, sVer, sVerName, sCopyr, sInfo) then
    RaiseOCINotLoaded;
  if sVer <> '' then
    FOCIVersion := ADVerStr2Int(sVer)
  else
    sVer := undef;
  if FOCIVersion < cvOracle80000 then
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraBadVersion, [sVer]);
end;

{-------------------------------------------------------------------------------}
procedure TOCILib.LoadOCILibrary;
begin
{$IFDEF AnyDAC_FPC}
  FOCIhDll := LoadLibrary(PChar(FOCIDllName));
{$ELSE}
  FOCIhDll := SafeLoadLibrary(PChar(FOCIDllName));
{$ENDIF}
  if FOCIhDll = 0 then
    RaiseOCINotLoaded;
end;

{-------------------------------------------------------------------------------}
procedure TOCILib.LoadOCIEntrys;

  function GetOCIProcAddress(const AProcName: String): Pointer;
  begin
    Result := nil;
    try
      Result := GetProcAddress(FOCIhDll, PChar(AProcName));
      if Result = nil then
        ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_AccCantGetLibraryEntry,
          [AProcName, ADLastSystemErrorMsg]);
    except
      ADHandleException;
    end;
  end;

begin
  if (FOCIVersion >= cvOracle81000) and not FOCIBDECompatibility then
    @OCIEnvCreate := GetOCIProcAddress(sOCIEnvCreate)
  else begin
    @OCIInitialize := GetOCIProcAddress(sOCIInitialize);
    @OCIEnvInit := GetOCIProcAddress(sOCIEnvInit);
  end;

  @OCIHandleAlloc := GetOCIProcAddress(sOCIHandleAlloc);
  @OCIHandleFree := GetOCIProcAddress(sOCIHandleFree);
  @OCIAttrSet := GetOCIProcAddress(sOCIAttrSet);
  @OCIAttrGet := GetOCIProcAddress(sOCIAttrGet);
  @OCIDescriptorAlloc := GetOCIProcAddress(sOCIDescriptorAlloc);
  @OCIDescriptorFree := GetOCIProcAddress(sOCIDescriptorFree);
  @OCIErrorGet := GetOCIProcAddress(sOCIErrorGet);

  @OCIServerAttach := GetOCIProcAddress(sOCIServerAttach);
  @OCIServerDetach := GetOCIProcAddress(sOCIServerDetach);
  @OCIServerVersion := GetOCIProcAddress(sOCIServerVersion);
  @OCIBreak := GetOCIProcAddress(sOCIBreak);
  if FOCIVersion >= cvOracle81000 then
    @OCIReset := GetOCIProcAddress(sOCIReset);

  @OCISessionBegin := GetOCIProcAddress(sOCISessionBegin);
  @OCISessionEnd := GetOCIProcAddress(sOCISessionEnd);
  @OCIPasswordChange := GetOCIProcAddress(sOCIPasswordChange);

  @OCITransStart := GetOCIProcAddress(sOCITransStart);
  @OCITransCommit := GetOCIProcAddress(sOCITransCommit);
  @OCITransRollback := GetOCIProcAddress(sOCITransRollback);
  @OCITransDetach := GetOCIProcAddress(sOCITransDetach);
  @OCITransPrepare := GetOCIProcAddress(sOCITransPrepare);
  @OCITransForget := GetOCIProcAddress(sOCITransForget);

  @OCIStmtPrepare := GetOCIProcAddress(sOCIStmtPrepare);
  @OCIStmtExecute := GetOCIProcAddress(sOCIStmtExecute);
  @OCIStmtFetch := GetOCIProcAddress(sOCIStmtFetch);
  @OCIStmtGetPieceInfo := GetOCIProcAddress(sOCIStmtGetPieceInfo);
  @OCIStmtSetPieceInfo := GetOCIProcAddress(sOCIStmtSetPieceInfo);
  @OCIParamGet := GetOCIProcAddress(sOCIParamGet);
  @OCIResultSetToStmt := GetOCIProcAddress(sOCIResultSetToStmt);

  @OCIDefineByPos := GetOCIProcAddress(sOCIDefineByPos);
  @OCIDefineArrayOfStruct := GetOCIProcAddress(sOCIDefineArrayOfStruct);

  @OCIBindByPos := GetOCIProcAddress(sOCIBindByPos);
  @OCIBindByName := GetOCIProcAddress(sOCIBindByName);
  @OCIBindDynamic := GetOCIProcAddress(sOCIBindDynamic);

  @OCILobAppend := GetOCIProcAddress(sOCILobAppend);
  @OCILobAssign := GetOCIProcAddress(sOCILobAssign);
  @OCILobCopy := GetOCIProcAddress(sOCILobCopy);
  @OCILobEnableBuffering := GetOCIProcAddress(sOCILobEnableBuffering);
  @OCILobDisableBuffering := GetOCIProcAddress(sOCILobDisableBuffering);
  @OCILobErase := GetOCIProcAddress(sOCILobErase);
  @OCILobFileExists := GetOCIProcAddress(sOCILobFileExists);
  @OCILobFileGetName := GetOCIProcAddress(sOCILobFileGetName);
  @OCILobFileSetName := GetOCIProcAddress(sOCILobFileSetName);
  @OCILobFlushBuffer := GetOCIProcAddress(sOCILobFlushBuffer);
  @OCILobGetLength := GetOCIProcAddress(sOCILobGetLength);
  @OCILobLoadFromFile := GetOCIProcAddress(sOCILobLoadFromFile);
  @OCILobLocatorIsInit := GetOCIProcAddress(sOCILobLocatorIsInit);
  @OCILobRead := GetOCIProcAddress(sOCILobRead);
  @OCILobTrim := GetOCIProcAddress(sOCILobTrim);
  @OCILobWrite := GetOCIProcAddress(sOCILobWrite);
  if FOCIVersion >= cvOracle81000 then begin
    @OCILobClose := GetOCIProcAddress(sOCILobClose);
    @OCILobIsOpen := GetOCIProcAddress(sOCILobIsOpen);
    @OCILobOpen := GetOCIProcAddress(sOCILobOpen);
    @OCILobCreateTemporary := GetOCIProcAddress(sOCILobCreateTemporary);
    @OCILobFreeTemporary := GetOCIProcAddress(sOCILobFreeTemporary);
    @OCILobIsTemporary := GetOCIProcAddress(sOCILobIsTemporary);
  end
  else begin
    @OCILobClose := GetOCIProcAddress(sOCILobFileClose);
    @OCILobIsOpen := GetOCIProcAddress(sOCILobFileIsOpen);
    @OCILobOpen := GetOCIProcAddress(sOCILobFileOpen);
    OCILobCreateTemporary := nil;
    OCILobFreeTemporary := nil;
    OCILobIsTemporary := nil;
  end;

  @OCIDescribeAny := GetOCIProcAddress(sOCIDescribeAny);

  if FOCIVersion >= cvOracle81000 then begin
    @OCIDirPathAbort := GetOCIProcAddress(sOCIDirPathAbort);
    @OCIDirPathDataSave := GetOCIProcAddress(sOCIDirPathDataSave);
    @OCIDirPathFinish := GetOCIProcAddress(sOCIDirPathFinish);
    @OCIDirPathFlushRow := GetOCIProcAddress(sOCIDirPathFlushRow);
    @OCIDirPathPrepare := GetOCIProcAddress(sOCIDirPathPrepare);
    @OCIDirPathLoadStream := GetOCIProcAddress(sOCIDirPathLoadStream);
    @OCIDirPathColArrayEntryGet := GetOCIProcAddress(sOCIDirPathColArrayEntryGet);
    @OCIDirPathColArrayEntrySet := GetOCIProcAddress(sOCIDirPathColArrayEntrySet);
    @OCIDirPathColArrayRowGet := GetOCIProcAddress(sOCIDirPathColArrayRowGet);
    @OCIDirPathColArrayReset := GetOCIProcAddress(sOCIDirPathColArrayReset);
    @OCIDirPathColArrayToStream := GetOCIProcAddress(sOCIDirPathColArrayToStream);
    @OCIDirPathStreamReset := GetOCIProcAddress(sOCIDirPathStreamReset);
    if FOCIVersion < cvOracle90000 then
      @OCIDirPathStreamToStream := GetOCIProcAddress(sOCIDirPathStreamToStream);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCILib.GetTNSServicesList(AList: TStrings);
var
  InComment, InStr: Boolean;
  pCh, pStParam: PChar;
  s, buff: String;
  BraceLevel: Integer;
  f: TFileStream;
begin
  AList.Clear;
  AList.Add(S_AD_Local);
  try
    f := TFileStream.Create(FOCITnsNames, fmOpenRead or fmShareDenyWrite);
    try
      SetLength(buff, f.Size);
      f.Read(PChar(Buff)^, LongInt(f.Size));
    finally
      f.Free;
    end;
  except
    Exit;
  end;
  InComment := False;
  InStr := False;
  BraceLevel := 0;
  pCh := PChar(Buff) - 1;
  s := '';
  repeat
    Inc(pCh);
    case pCh^ of
    '#':
      if not InComment and not InStr then
        InComment := True;
    '''':
      if not InComment then
        InStr := not InStr;
    '(':
      if not InComment and not InStr then
        Inc(BraceLevel);
    ')':
      if not InComment and not InStr then begin
        Dec(BraceLevel);
        if BraceLevel < 0 then
          ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraDBTNManyClBraces, [s]);
      end;
    #13, #10:
      if InComment then
        InComment := False;
    'a'..'z', 'A'..'Z', '0'..'9':
      if not InComment and not InStr and (BraceLevel = 0) then begin
        pStParam := pCh;
        while pCh^ in ['a'..'z', 'A'..'Z', '0'..'9', '#', '$', '_', '.', '-'] do
          Inc(pCh);
        SetString(s, pStParam, pCh - pStParam);
        AList.Add(s);
        Dec(pCh);
      end;
    end;
  until (pCh^ = #0);
end;

{-------------------------------------------------------------------------------}
{ TOCIHandle                                                                    }
{-------------------------------------------------------------------------------}
constructor TOCIHandle.Create;
begin
  inherited Create;
  FHandle := nil;
  FType := 0;
  FOwner := nil;
end;

{-------------------------------------------------------------------------------}
destructor TOCIHandle.Destroy;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIHandleFree, ['HKind', hndlNames[FType], 'HVal', FHandle]);
  end;
{$ENDIF}
begin
  if (FHandle <> nil) and FOwnHandle then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace;
{$ENDIF}
    Check(Lib.OCIHandleFree(FHandle, FType));
  end;
  inherited Destroy;
  FHandle := nil;
  FType := 0;
  FOwner := nil;
  FError := nil;
  FLib := nil;
  FOwningObj := nil;
{$IFDEF AnyDAC_MONITOR}
  FMonitor := nil;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.Init(AEnv: TOCIHandle; AType: ub4): pOCIHandle;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIHandleAlloc, ['HKind', hndlNames[AType]]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIHandleAlloc(AEnv.FHandle, FHandle, AType, 0, nil));
  FType := AType;
  Result := @FHandle;
  FOwnHandle := True;
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.SetStringAttr(AAtrType: Integer; const AValue: String);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrSet, ['VType', 'str', 'AType', AAtrType, 'Val', AValue]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrSet(FHandle, FType, PChar(AValue), Length(AValue),
    AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.GetStringAttr(AAtrType: Integer): String;
var
  l: Integer;
  p: PChar;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrGet, ['VType', 'str', 'AType', AAtrType]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrGet(FHandle, FType, @p, @l, AAtrType, Error.FHandle));
  SetString(Result, p, l);
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.SetHandleAttr(AAtrType: Integer; AValue: pOCIHandle);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrSet, ['VType', 'hndl', 'AType', AAtrType, 'Val', AValue]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrSet(FHandle, FType, AValue, 0, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.GetHandleAttr(AAtrType: Integer): pOCIHandle;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrGet, ['VType', 'hndl', 'AType', AAtrType]);
  end;
{$ENDIF}
begin
  Result := nil;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrGet(FHandle, FType, @Result, nil, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.SetUB1Attr(AAtrType: Integer; AValue: ub1);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrSet, ['VType', 'ub1', 'AType', AAtrType, 'Val', AValue]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrSet(FHandle, FType, @AValue, 0, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.GetUB1Attr(AAtrType: Integer): ub1;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrGet, ['VType', 'ub1', 'AType', AAtrType]);
  end;
{$ENDIF}
begin
  Result := 0;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrGet(FHandle, FType, @Result, nil, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.SetUB2Attr(AAtrType: Integer; AValue: ub2);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrSet, ['VType', 'ub2', 'AType', AAtrType, 'Val', AValue]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrSet(FHandle, FType, @AValue, 0, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.GetUB2Attr(AAtrType: Integer): ub2;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrGet, ['VType', 'ub2', 'AType', AAtrType]);
  end;
{$ENDIF}
begin
  Result := 0;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrGet(FHandle, FType, @Result, nil, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.SetUB4Attr(AAtrType: Integer; AValue: ub4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrSet, ['VType', 'ub4', 'AType', AAtrType, 'Val', AValue]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrSet(FHandle, FType, @AValue, 0, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.GetUB4Attr(AAtrType: Integer): ub4;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrGet, ['VType', 'ub4', 'AType', AAtrType]);
  end;
{$ENDIF}
begin
  Result := 0;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrGet(FHandle, FType, @Result, nil, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.SetSB1Attr(AAtrType: Integer; AValue: Sb1);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrSet, ['VType', 'sb1', 'AType', AAtrType, 'Val', AValue]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrSet(FHandle, FType, @AValue, 0, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.GetSB1Attr(AAtrType: Integer): sb1;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrGet, ['VType', 'sb1', 'AType', AAtrType]);
  end;
{$ENDIF}
begin
  Result := 0;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrGet(FHandle, FType, @Result, nil, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.SetSB4Attr(AAtrType: Integer; AValue: Sb4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrSet, ['VType', 'sb4', 'AType', AAtrType, 'Val', AValue]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrSet(FHandle, FType, @AValue, 0, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.GetSB4Attr(AAtrType: Integer): sb4;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrGet, ['VType', 'sb4', 'AType', AAtrType]);
  end;
{$ENDIF}
begin
  Result := 0;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrGet(FHandle, FType, @Result, nil, AAtrType, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.GetError: TOCIError;
var
  h: TOCIHandle;
begin
  Result := FError;
  if Result = nil then begin
    h := Self;
    while (h <> nil) and not (h is TOCIEnv) do
      h := h.Owner;
    FError := TOCIEnv(h).FError;
    Result := FError;
  end;
end;

{-------------------------------------------------------------------------------}
function TOCIHandle.GetLib: TOCILib;
var
  h: TOCIHandle;
begin
  Result := FLib;
  if Result = nil then begin
    h := Self;
    while (h <> nil) and not (h is TOCIEnv) do
      h := h.Owner;
    FLib := TOCIEnv(h).FLib;
    Result := FLib;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.Check(ACode: sb4);
begin
  if ACode <> OCI_SUCCESS then
    Error.Check(ACode, OwningObj);
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TOCIHandle.GetTracing: Boolean;
begin
  Result := (FMonitor <> nil) and FMonitor.Tracing;
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.UpdateTracing;
var
  h: TOCIHandle;
begin
  h := Self;
  while (h <> nil) and not (h is TOCIEnv) do
    h := h.Owner;
  if (h = nil) or (h.FMonitor = nil) then
    FMonitor := nil
  else
    FMonitor := h.FMonitor;
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
  const AMsg: String; AArgs: array of const);
begin
  if Tracing then
    Monitor.Notify(AKind, AStep, OwningObj, AMsg, AArgs);
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.Trace(AKind: TADMoniEventKind; const AMsg: String;
  AArgs: array of const);
begin
  if Tracing then
    Monitor.Notify(AKind, esProgress, OwningObj, AMsg, AArgs);
end;

{-------------------------------------------------------------------------------}
procedure TOCIHandle.Trace(const AMsg: String; AArgs: array of const);
begin
  if Tracing then
    Monitor.Notify(ekVendor, esProgress, OwningObj, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TOCIEnv                                                                       }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_DEBUG}
function Malocf(ctxp: Pointer; size: Integer): Pointer; cdecl;
begin
  GetMem(Result, size);
end;

function Ralocf(ctxp: Pointer; memptr: Pointer; newsize: Integer): Pointer; cdecl;
begin
  Result := memptr;
  ReallocMem(Result, newsize);
end;

procedure Mfreef(ctxp: Pointer; memptr: Pointer); cdecl;
begin
  FreeMem(memptr);
end;
{$ENDIF}

constructor TOCIEnv.Create(ALib: TOCILib; AMode: ub4;
  {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
  AOwningObj: TObject);
var
  err1, err2: sword;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace1;
  begin
    Trace(sOCIEnvCreate, ['Mode', AMode]);
  end;
  procedure ProcTrace2;
  begin
    Trace(sOCIInitialize, ['Mode', AMode]);
  end;
  procedure ProcTrace3;
  begin
    Trace(sOCIEnvInit, []);
  end;
{$ENDIF}
begin
  inherited Create;
  FLib := ALib;
  FOwningObj := AOwningObj;
{$IFDEF AnyDAC_MONITOR}
  FMonitor := AMonitor;
{$ENDIF}
  FType := OCI_HTYPE_ENV;
  FOwnHandle := True;
  if ((AMode and OCI_THREADED) = 0) and (Lib.FOCIVersion < cvOracle81000) then
    AMode := AMode or OCI_NO_MUTEX;
  if Lib.FOCIVersion < cvOracle81500 then
    AMode := AMode and not OCI_EVENTS;
  if Lib.FOCIVersion < cvOracle81500 then
    AMode := AMode and not OCI_SHARED;
  if Lib.FOCIVersion >= cvOracle81000 then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace1;
{$ENDIF}
    err1 := Lib.OCIEnvCreate(FHandle, AMode, nil, nil, nil, nil, 0, nil);
    err2 := OCI_SUCCESS;
  end
  else begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace2;
{$ENDIF}
{$IFDEF AnyDAC_DEBUG}
    err1 := Lib.OCIInitialize(AMode, nil, @malocf, @ralocf, @mfreef);
{$ELSE}
    err1 := Lib.OCIInitialize(AMode, nil, nil, nil, nil);
{$ENDIF}
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace3;
{$ENDIF}
    err2 := Lib.OCIEnvInit(FHandle, OCI_DEFAULT, 0, nil);
  end;
  FError := TOCIError.Create(Self);
  if Lib.FOCIVersion >= cvOracle81000 then
    Check(err1)
  else begin
    Check(err1);
    Check(err2);
  end;
end;

{-------------------------------------------------------------------------------}
constructor TOCIEnv.CreateUsingHandle(ALib: TOCILib; AHandle: pOCIHandle;
  AErrHandle: pOCIHandle; {$IFDEF AnyDAC_MONITOR} const AMonitor: IADMoniClient; {$ENDIF}
  AOwningObj: TObject);
begin
  inherited Create;
  FLib := ALib;
  FOwningObj := AOwningObj;
{$IFDEF AnyDAC_MONITOR}
  FMonitor := AMonitor;
{$ENDIF}
  FType := OCI_HTYPE_ENV;
  FHandle := AHandle;
  FOwnHandle := False;
  FError := TOCIError.CreateUsingHandle(Self, AErrHandle);
end;

{-------------------------------------------------------------------------------}
destructor TOCIEnv.Destroy;
begin
  FreeAndNil(FError);
  try
    inherited Destroy;
  except
    // without that QA, Async Exec, 8.1.6.0.0 will raise AV
    // at OCIHandleFree
  end;
end;

{-------------------------------------------------------------------------------}
{ EOCINativeException                                                           }
{-------------------------------------------------------------------------------}
constructor EOCINativeException.Create(AError: TOCIError);
var
  lvl: ub4;
  errCode: sb4;
  errBuf: array[0..511] of Char;
  i1, i2: Integer;
  sMsg, sObj: String;
  eKind: TADCommandExceptionKind;
begin
  inherited Create(er_AD_OraGeneral,
    ADExceptionLayers([S_AD_LPhys, S_AD_OraId, 'OCI']) + ' ');
  lvl := 1;
  while True do begin
    errCode := 0;
    if AError.Lib.OCIErrorGet(AError.FHandle, lvl, nil, errCode, errBuf,
                              SizeOf(errBuf), OCI_HTYPE_ERROR) = OCI_NO_DATA then
      Break;
    sMsg := Trim(errBuf);
    i1 := Pos('#13', sMsg);
    i2 := Pos('#10', sMsg);
    if (i2 <> 0) and (i2 < i1) or (i1 = 0) then
      i1 := i2;
    if i1 = 0 then
      i1 := Length(sMsg) + 1;
    sObj := Copy(sMsg, 1, i1 - 1);
    i1 := Pos('(', sObj);
    i2 := Pos(')', sObj);
    sObj := Copy(sObj, i1 + 1, i2 - i1 - 1);
    case errCode of
      100,
     1403: eKind := ekNoDataFound;
       54: eKind := ekRecordLocked;
        1: eKind := ekUKViolated;
     2291,
     2292: eKind := ekFKViolated;
     4043,
      942: eKind := ekObjNotExists;
     1005,
     1017: eKind := ekUserPwdInvalid;
    28001: eKind := ekUserPwdExpired;
    28002: eKind := ekUserPwdWillExpire;
     1013: eKind := ekCmdAborted;
    else   eKind := ekOther;
    end;
    Append(TADDBError.Create(lvl, errCode, sMsg, sObj, eKind, -1));
{$IFDEF AnyDAC_MONITOR}
    if AError.Tracing then AError.Trace(ekError, sMsg, ['Lvl', lvl, 'ErrCode', errCode]);
{$ENDIF}
    if lvl = 1 then
      Message := Message + sMsg;
    Inc(lvl);
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_BCB}
constructor EOCISystemException.Create(AErrorCode: sb4; Dummy: Cardinal = 0);
{$ELSE}
constructor EOCISystemException.Create(AErrorCode: sb4);
{$ENDIF}
var
  msg: String;
begin
  case AErrorCode of
  OCI_SUCCESS_WITH_INFO: msg := 'OCI_SUCCESS_WITH_INFO';
  OCI_NEED_DATA:         msg := 'OCI_NEED_DATA';
  OCI_NO_DATA:           msg := 'OCI_NO_DATA';
  OCI_INVALID_HANDLE:    msg := 'OCI_INVALID_HANDLE';
  OCI_STILL_EXECUTING:   msg := 'OCI_STILL_EXECUTING';
  OCI_CONTINUE:          msg := 'OCI_CONTINUE';
  end;
  FErrorCode := AErrorCode;
  inherited Create(er_AD_OraGeneral,
    ADExceptionLayers([S_AD_LPhys, S_AD_OraId, 'OCI']) + ' ' + msg);
end;

{-------------------------------------------------------------------------------}
procedure EOCISystemException.Duplicate(var AValue: EADException);
begin
  if AValue = nil then
    AValue := EOCISystemException.Create(FErrorCode);
  inherited Duplicate(AValue);
  EOCISystemException(AValue).FErrorCode := FErrorCode;
end;

{-------------------------------------------------------------------------------}
{ TOCIError                                                                     }
{-------------------------------------------------------------------------------}
constructor TOCIError.Create(AEnv: TOCIEnv);
begin
  inherited Create;
  FOwner := AEnv;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(AEnv, OCI_HTYPE_ERROR);
end;

{-------------------------------------------------------------------------------}
constructor TOCIError.CreateUsingHandle(AEnv: TOCIEnv; AErrHandle: pOCIHandle);
begin
  inherited Create;
  FOwner := AEnv;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  FType := OCI_HTYPE_ERROR;
  FHandle := AErrHandle;
  FOwnHandle := False;
end;

{-------------------------------------------------------------------------------}
destructor TOCIError.Destroy;
begin
  ClearInfo;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCIError.Check(ACode: sword; AInitiator: TObject = nil);
begin
  case ACode of
  OCI_SUCCESS:
    ;
  OCI_NEED_DATA,
  OCI_INVALID_HANDLE,
  OCI_STILL_EXECUTING,
  OCI_CONTINUE:
    ADException(AInitiator, EOCISystemException.Create(ACode));
  OCI_SUCCESS_WITH_INFO:
    begin
      ClearInfo;
      FInfo := EOCINativeException.Create(Self);
    end;
  OCI_NO_DATA,
  OCI_ERROR:
    ADException(AInitiator, EOCINativeException.Create(Self));
  else
    ;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIError.ClearInfo;
begin
  FreeAndNil(FInfo);
end;

{-------------------------------------------------------------------------------}
{ TOCIService                                                                   }
{-------------------------------------------------------------------------------}
constructor TOCIService.Create(AEnv: TOCIEnv; AOwningObj: TObject);
begin
  inherited Create;
  FOwner := AEnv;
  FOwningObj := AOwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(AEnv, OCI_HTYPE_SVCCTX);
  FNonBlockinMode := True;
  FBytesPerChar := 1;
end;

{-------------------------------------------------------------------------------}
constructor TOCIService.CreateUsingHandle(AEnv: TOCIEnv; AHandle: pOCIHandle;
  AOwningObj: TObject);
begin
  inherited Create;
  FOwner := AEnv;
  FOwningObj := AOwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  FType := OCI_HTYPE_SVCCTX;
  FHandle := AHandle;
  FNonBlockinMode := False;
  FOwnHandle := False;
  FBytesPerChar := 1;
end;

{-------------------------------------------------------------------------------}
procedure TOCIService.Break(ADoException: Boolean);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIBreak, []);
  end;
{$ENDIF}
var
  errCode: sb4;
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  errCode := Lib.OCIBreak(FHandle, Error.FHandle);
  if (errCode <> OCI_SUCCESS) and ADoException then
    Check(errCode);
end;

{-------------------------------------------------------------------------------}
procedure TOCIService.Reset(ADoException: Boolean);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIReset, []);
  end;
{$ENDIF}
var
  errCode: sb4;
begin
  if Lib.FOCIVersion >= cvOracle81000 then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace;
{$ENDIF}
    errCode := Lib.OCIReset(FHandle, Error.FHandle);
    if (errCode <> OCI_SUCCESS) and ADoException then
      Check(errCode);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIService.DoYield;
begin
  if Assigned(FOnYield) then
    FOnYield(Self);
end;

{-------------------------------------------------------------------------------}
procedure TOCIService.TurnNONBLOCKING_MODE;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrSet, ['AType', 'OCI_ATTR_NONBLOCKING_MODE']);
  end;
{$ENDIF}
begin
  if Lib.FOCIVersion >= cvOracle80500 then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace;
{$ENDIF}
    Check(Lib.OCIAttrSet(FHandle, FType, nil, 0, OCI_ATTR_NONBLOCKING_MODE,
      Error.FHandle));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIService.SetNonblockingMode(const Value: Boolean);
begin
  if FNonBlockinMode <> Value then begin
    FNonBlockinMode := Value;
    TurnNONBLOCKING_MODE;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIService.UpdateNonBlockingMode;
begin
  if FNonBlockinMode then begin
    TurnNONBLOCKING_MODE;
    TurnNONBLOCKING_MODE;
  end;
end;

{-------------------------------------------------------------------------------}
{ TOCIServer                                                                    }
{-------------------------------------------------------------------------------}
constructor TOCIServer.Create(AService: TOCIService);
begin
  inherited Create;
  FOwner := AService;
  FOwningObj := AService.OwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(AService.FOwner, OCI_HTYPE_SERVER);
end;

{-------------------------------------------------------------------------------}
constructor TOCIServer.CreateUsingHandle(AService: TOCIService; AHandle: pOCIHandle);
begin
  inherited Create;
  FOwner := AService;
  FOwningObj := AService.OwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  FType := OCI_HTYPE_SERVER;
  FHandle := AHandle;
  FOwnHandle := False;
end;

{-------------------------------------------------------------------------------}
destructor TOCIServer.Destroy;
begin
  try
    Detach;
  except
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCIServer.Attach(const AServerName: String);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIServerAttach, ['SrvName', AServerName]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIServerAttach(FHandle, Error.FHandle, PChar(AServerName),
    Length(AServerName), OCI_DEFAULT));
  FAttached := True;
  Select;
end;

{-------------------------------------------------------------------------------}
procedure TOCIServer.Detach;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIServerDetach, []);
  end;
{$ENDIF}
begin
  if (FHandle <> nil) and FAttached then begin
    FAttached := False;
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace;
{$ENDIF}
    Check(Lib.OCIServerDetach(FHandle, Error.FHandle, OCI_DEFAULT));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIServer.Select;
begin
  TOCIService(FOwner).SERVER := FHandle;
end;

{-------------------------------------------------------------------------------}
function TOCIServer.GetServerVersion: String;
const
  OCI_MAX_ATTR_LEN = 1024;
var
  buff: array[0 .. OCI_MAX_ATTR_LEN-1] of char;
begin
  Lib.OCIServerVersion(FHandle, Error.FHandle, @buff, OCI_MAX_ATTR_LEN, OCI_HTYPE_SERVER);
  Result := buff;
end;

{-------------------------------------------------------------------------------}
{ TOCISession                                                                   }
{-------------------------------------------------------------------------------}
constructor TOCISession.Create(AService: TOCIService);
begin
  inherited Create;
  FOwner := AService;
  FOwningObj := AService.OwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(AService.FOwner, OCI_HTYPE_SESSION);
end;

{-------------------------------------------------------------------------------}
constructor TOCISession.CreateUsingHandle(AService: TOCIService; AHandle: pOCIHandle);
begin
  inherited Create;
  FOwner := AService;
  FOwningObj := AService.OwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  FType := OCI_HTYPE_SESSION;
  FHandle := AHandle;
  FOwnHandle := False;
end;

{-------------------------------------------------------------------------------}
destructor TOCISession.Destroy;
begin
  try
    Stop;
  except
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCISession.Start(const AUser, APassword: String; AAuthentMode: ub4);
var
  credt: ub4;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCISessionBegin, ['User', AUser, 'Mode', AAuthentMode]);
  end;
{$ENDIF}
begin
  if (AUser = '') and (APassword = '') then
    credt := OCI_CRED_EXT
  else begin
    USERNAME := AUser;
    PASSWORD := APassword;
    credt := OCI_CRED_RDBMS;
  end;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCISessionBegin(FOwner.FHandle, Error.FHandle, FHandle, credt, AAuthentMode));
  FStarted := True;
  Select;
end;

{-------------------------------------------------------------------------------}
procedure TOCISession.ChangePassword(const AUser, AOldPassword, ANewPassword: String);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIPasswordChange, ['User', AUser]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIPasswordChange(FOwner.FHandle, Error.FHandle, PChar(AUser),
    Length(AUser), PChar(AOldPassword), Length(AOldPassword), PChar(ANewPassword),
    Length(ANewPassword), OCI_DEFAULT));
  FStarted := True;
end;

{-------------------------------------------------------------------------------}
procedure TOCISession.Stop;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCISessionEnd, []);
  end;
{$ENDIF}
begin
  if (FHandle <> nil) and FStarted then begin
    FStarted := False;
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace;
{$ENDIF}
    Check(Lib.OCISessionEnd(FOwner.FHandle, Error.FHandle, FHandle, OCI_DEFAULT));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCISession.Select;
begin
  TOCIService(FOwner).SESSION := FHandle;
end;

{-------------------------------------------------------------------------------}
{ TOCIXid                                                                       }
{-------------------------------------------------------------------------------}
constructor TOCIXid.Create;
begin
  inherited Create;
  Clear;
end;

{-------------------------------------------------------------------------------}
procedure TOCIXid.Assign(AValue: TPersistent);
begin
  if AValue is TOCIXid then begin
    GTRID := TOCIXid(AValue).GTRID;
    BQUAL := TOCIXid(AValue).BQUAL;
    Name := TOCIXid(AValue).Name;
  end
  else
    inherited Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TOCIXid.Clear;
begin
  if IsNull then
    Exit;
  if Assigned(FOnChanging) then
    FOnChanging(Self);
  FXID.formatID := NULLXID_ID;
  FXID.gtrid_length := 0;
  FXID.bqual_length := 0;
  ADFillChar(FXID.data, XIDDATASIZE, #0);
  FName := '';
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

{-------------------------------------------------------------------------------}
function TOCIXid.GetGTRID: String;
begin
  SetString(Result, PChar(@FXID.data), FXID.gtrid_length);
end;

{-------------------------------------------------------------------------------}
procedure TOCIXid.SetParts(const AGTRID, ABQUAL: String);
begin
  if Length(AGTRID) > MAXGTRIDSIZE then
    ADException(nil, [S_AD_LPhys, S_AD_OraId], er_AD_OraTooLongGTRID,
      [MAXGTRIDSIZE, Length(AGTRID)]);
  if Length(ABQUAL) > MAXBQUALSIZE then
    ADException(nil, [S_AD_LPhys, S_AD_OraId], er_AD_OraTooLongBQUAL,
      [MAXBQUALSIZE, Length(ABQUAL)]);
  if Assigned(FOnChanging) then
    FOnChanging(Self);
  FXID.gtrid_length := Length(AGTRID);
  FXID.bqual_length := Length(ABQUAL);
  if (FXID.gtrid_length > 0) and (FXID.bqual_length > 0) then
    FXID.formatID := IXIDFormatID;
  ADMove(PChar(AGTRID)^, FXID.data, FXID.gtrid_length);
  ADMove(PChar(ABQUAL)^, PChar(Integer(@FXID.data) + FXID.gtrid_length)^,
    FXID.bqual_length);
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

{-------------------------------------------------------------------------------}
procedure TOCIXid.SetGTRID(const AValue: String);
begin
  if GTRID <> AValue then
    SetParts(AValue, BQUAL);
end;

{-------------------------------------------------------------------------------}
function TOCIXid.GetBQUAL: String;
begin
  SetString(Result, PChar(Integer(@FXID.data) + FXID.gtrid_length),
    FXID.bqual_length);
end;

{-------------------------------------------------------------------------------}
procedure TOCIXid.SetBQUAL(const AValue: String);
begin
  if BQUAL <> AValue then
    SetParts(GTRID, AValue);
end;

{-------------------------------------------------------------------------------}
function TOCIXid.GetIsNull: Boolean;
begin
  Result := (FXID.formatID = NULLXID_ID);
end;

{-------------------------------------------------------------------------------}
procedure TOCIXid.SetName(const AValue: String);
begin
  if FName <> AValue then begin
    if Length(AValue) > MAXTXNAMELEN then
      ADException(nil, [S_AD_LPhys, S_AD_OraId], er_AD_OraTooLongTXName,
        [MAXTXNAMELEN, Length(AValue)]);
    if Assigned(FOnChanging) then
      FOnChanging(Self);
    FName := AValue;
    if Assigned(FOnChanged) then
      FOnChanged(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIXid.MarkTransaction(ATrans: TOCITransaction);
begin
  if FXID.formatID <> NULLXID_ID then begin
    ATrans.SetXID(FXID);
    if Name <> '' then
      ATrans.TRANS_NAME := Name;
  end;
end;

{-------------------------------------------------------------------------------}
{ TOCITransaction                                                               }
{-------------------------------------------------------------------------------}
const
  nc2OCItm: array[TOCITransactionMode] of ub4 = (OCI_DEFAULT, OCI_TRANS_READWRITE,
    OCI_TRANS_SERIALIZABLE, OCI_TRANS_READONLY, OCI_TRANS_READWRITE);
  nc2OCItn: array[Boolean] of ub4 = (OCI_TRANS_RESUME, OCI_TRANS_NEW);
  nc2OCIcm: array[TOCICoupleMode] of ub4 = (OCI_DEFAULT, OCI_TRANS_LOOSE, OCI_TRANS_TIGHT);

constructor TOCITransaction.Create(AService: TOCIService);
begin
  inherited Create;
  FOwner := AService;
  FOwningObj := AService.OwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(AService.FOwner, OCI_HTYPE_TRANS);
  Select;
end;

{-------------------------------------------------------------------------------}
constructor TOCITransaction.CreateUsingHandle(AService: TOCIService;
  AHandle: pOCIHandle);
begin
  inherited Create;
  FOwner := AService;
  FOwningObj := AService.OwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  FType := OCI_HTYPE_TRANS;
  FHandle := AHandle;
  FOwnHandle := False;
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.StartLocal(AMode: TOCITransactionMode);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCITransStart, ['Kind', 'local', 'Mode', nc2OCItm[AMode]]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCITransStart(FOwner.FHandle, Error.FHandle, 0, nc2OCItm[AMode]));
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.StartGlobal(AMode: TOCITransactionMode; ATimeOut: uword;
  ANew: Boolean; ACoupleMode: TOCICoupleMode);
var
  mode: ub4;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCITransStart, ['Kind', 'global', 'Mode', mode]);
  end;
{$ENDIF}
begin
  mode := nc2OCItn[ANew] or nc2OCIcm[ACoupleMode] or nc2OCItm[AMode];
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCITransStart(FOwner.FHandle, Error.FHandle, ATimeOut, mode));
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.Detach;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCITransDetach, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCITransDetach(FOwner.FHandle, Error.FHandle, OCI_DEFAULT));
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.Commit;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCITransCommit, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCITransCommit(FOwner.FHandle, Error.FHandle, OCI_DEFAULT));
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.Commit2PC;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCITransCommit, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCITransCommit(FOwner.FHandle, Error.FHandle, OCI_TRANS_TWOPHASE));
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.RollBack;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCITransRollback, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCITransRollback(FOwner.FHandle, Error.FHandle, OCI_DEFAULT));
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.Prepare2PC;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCITransPrepare, []);
  end;
{$ENDIF}
var
  res: sb4;
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  res := Lib.OCITransPrepare(FOwner.FHandle, Error.FHandle, OCI_DEFAULT);
  if res = OCI_SUCCESS_WITH_INFO then
    res := OCI_SUCCESS;
  Check(res);
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.Forget;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCITransForget, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCITransForget(FOwner.FHandle, Error.FHandle, OCI_DEFAULT));
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.SetXID(var AValue: TXID);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrSet, ['VType', 'XID', 'AType', 'OCI_ATTR_XID']);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrSet(FHandle, FType, @AValue, SizeOf(TXID), OCI_ATTR_XID,
    Error.FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.GetXID(var AValue: TXID);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrGet, ['VType', 'XID', 'AType', 'OCI_ATTR_XID']);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrGet(FHandle, FType, @AValue, nil, OCI_ATTR_XID, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCITransaction.Select;
begin
  if TOCIService(FOwner).TRANS <> FHandle then
    TOCIService(FOwner).TRANS := FHandle;
end;

{-------------------------------------------------------------------------------}
{ TOCIStatement                                                                 }
{-------------------------------------------------------------------------------}
constructor TOCIStatement.Create(AEnv: TOCIEnv; AService: TOCIService;
  AOwningObj: TObject);
begin
  inherited Create;
  FOwner := AEnv;
  FOwningObj := AOwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(AEnv, OCI_HTYPE_STMT);
  FPieceBuffLen := IDefPieceBuffLen;
  FPieceOutVars := TList.Create;
  FVars := TList.Create;
  FRef := False;
  FCanceled := False;
  FService := AService;
  InrecDataSize := IDefInrecDataSize;
end;

{-------------------------------------------------------------------------------}
constructor TOCIStatement.CreateUsingHandle(AEnv: TOCIEnv;
  AService: TOCIService; AHandle: pOCIHandle; AOwningObj: TObject);
begin
  inherited Create;
  FOwner := AEnv;
  FOwningObj := AOwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  FType := OCI_HTYPE_STMT;
  FPieceBuffLen := IDefPieceBuffLen;
  FPieceOutVars := TList.Create;
  FVars := TList.Create;
  AttachToHandle(AHandle);
  FService := AService;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.AttachToHandle(AHandle: pOCIHandle);
begin
  FHandle := AHandle;
  FRef := True;
  FCanceled := False;
  FEof := False;
  FLastRowCount := ROW_COUNT;
end;

{-------------------------------------------------------------------------------}
destructor TOCIStatement.Destroy;
begin
  FreeAndNil(FPieceOutVars);
  FreeAndNil(FVars);
  FreePieceBuff;
  if FRef then
    FHandle := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.SetInrecDataSize(const Value: ub4);
var
  i: Integer;
begin
  if FInrecDataSize <> Value then begin
    for i := 0 to FVars.Count - 1 do
      TOCIVariable(FVars[i]).FreeBuffer;
    FInrecDataSize := Value;
    for i := 0 to FVars.Count - 1 do
      TOCIVariable(FVars[i]).InitLongData;
  end;
end;

{-------------------------------------------------------------------------------}
// Piece wise operation support

var
  FGlobalPieceBuffSize: ub4;
  FGlobalPieceBuff: pUb1;
  FGlobalPieceBuffUseCnt: ub4;

{-------------------------------------------------------------------------------}
function GetGlobalPieceBuff(ASize: ub4): pUb1;
begin
  if FGlobalPieceBuffUseCnt = 0 then begin
    GetMem(FGlobalPieceBuff, ASize);
    FGlobalPieceBuffSize := ASize;
  end
  else if FGlobalPieceBuffSize < ASize then begin
    ReallocMem(FGlobalPieceBuff, ASize);
    FGlobalPieceBuffSize := ASize;
  end;
  Inc(FGlobalPieceBuffUseCnt);
  Result := FGlobalPieceBuff;
end;

{-------------------------------------------------------------------------------}
procedure FreeGlobalPieceBuff;
begin
  Dec(FGlobalPieceBuffUseCnt);
  if FGlobalPieceBuffUseCnt = 0 then begin
    FreeMem(FGlobalPieceBuff, FGlobalPieceBuffSize);
    FGlobalPieceBuff := nil;
    FGlobalPieceBuffSize := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.AllocPieceBuff;
begin
  if FPieceBuff = nil then
    if FPieceBuffOwn then
      GetMem(FPieceBuff, FPieceBuffLen)
    else
      FPieceBuff := GetGlobalPieceBuff(FPieceBuffLen);
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.FreePieceBuff;
begin
  if FPieceBuff <> nil then
  try
    if FPieceBuffOwn then
      FreeMem(FPieceBuff, FPieceBuffLen)
    else
      FreeGlobalPieceBuff;
  except
    FPieceBuff := nil;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.SetPieceBuffOwn(AValue: Boolean);
begin
  if FPieceBuffOwn <> AValue then begin
    FreePieceBuff;
    FPieceBuffOwn := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.SetPieceBuffLen(AValue: ub4);
begin
  if FPieceBuffLen <> AValue then begin
    FreePieceBuff;
    FPieceBuffLen := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TOCIStatement.Hndl2PieceVar(varHndl: pOCIHandle): TOCIVariable;
var
  i: Integer;
begin
  i := 0;
  while (i < FPieceOutVars.Count) and
        (TOCIVariable(FPieceOutVars[i]).FHandle <> varHndl) do
    Inc(i);
  if i = FPieceOutVars.Count then
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraUndefPWVar, []);
  Result := TOCIVariable(FPieceOutVars[i]);
  if not Result.LongData then
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraBadTypePWVar, []);
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.AddPieceVar(AVar: TOCIVariable);
begin
  if FPieceOutVars.IndexOf(AVar) = -1 then
    FPieceOutVars.Add(AVar);
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.RemovePieceVar(AVar: TOCIVariable);
begin
  FPieceOutVars.Remove(AVar);
end;

{-------------------------------------------------------------------------------}
function TOCIStatement.GetPiecedFetch: Boolean;
begin
  Result := FPieceOutVars.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.InitPiecedFetch(var pld: TOCIPieceLoopData);
begin
  if PiecedFetch then
    ADFillChar(pld, SizeOf(TOCIPieceLoopData), #0);
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.DoPiecedFetch(var APieceLoopData: TOCIPieceLoopData; ARes: sb4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace1;
  begin
    Trace(sOCIStmtGetPieceInfo, []);
  end;
  procedure ProcTrace2;
  begin
    Trace(sOCIStmtSetPieceInfo, []);
  end;
  procedure ProcTrace3;
  begin
    Trace(sOCIStmtSetPieceInfo, []);
  end;
{$ENDIF}
var
  varHndl: pOCIHandle;
  varType: ub4;
  idx: ub4;
  varIter: ub4;
  pLastInd: Pointer;
  pLastRCode: pUb2;
begin
  if PiecedFetch then
  with APieceLoopData do begin
    if (lastPieceVar <> nil) and (lastInOut <> OCI_PARAM_IN) then
      if lastPiece in [OCI_ONE_PIECE, OCI_FIRST_PIECE] then
        if (lastInd = -1) and (lastPieceSize = 0) then
          lastPieceVar.SetData(lastIter, nil, 0, dfOCI)
        else
          lastPieceVar.SetData(lastIter, FPieceBuff, lastPieceSize, dfOCI)
      else
        lastPieceVar.AppendData(lastIter, FPieceBuff, lastPieceSize);
    if ARes = OCI_NEED_DATA then begin
{$IFDEF AnyDAC_MONITOR}
      if Tracing then ProcTrace1;
{$ENDIF}
      varHndl := nil;
      varType := 0;
      lastInOut := 0;
      varIter := 0;
      idx := 0;
      lastPiece := 0;
      Check(Lib.OCIStmtGetPieceInfo(FHandle, Error.FHandle, varHndl,
        varType, lastInOut, varIter, idx, lastPiece));
      if varHndl <> lastPieceVarHndl then begin
        lastPieceVar := Hndl2PieceVar(varHndl);
        lastPieceVarHndl := varHndl;
        lastRCode := OCI_SUCCESS;
        lastInd := -1;
      end;
      if varIter <> lastIter then begin
        lastRCode := OCI_SUCCESS;
        lastIter := varIter;
      end;
      pLastInd := @lastInd;
      pLastRCode := @lastRCode;
      if Lib.FOCIVersion >= cvOracle81600 then begin
        pLastInd := Pointer(ub4(pLastInd) - lastIter * SizeOf(sb2));
        pLastRCode := pUb2(ub4(pLastRCode) - lastIter * SizeOf(ub2));
      end;
      if lastInOut = OCI_PARAM_OUT then begin
        AllocPieceBuff;
        lastPieceSize := FPieceBuffLen;
{$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace2;
{$ENDIF}
        Check(Lib.OCIStmtSetPieceInfo(lastPieceVar.FHandle, varType,
          Error.FHandle, FPieceBuff, lastPieceSize, lastPiece, pLastInd,
          pLastRCode^));
      end
      else begin
        if lastPieceVar.GetDataPtr(lastIter, lastBuff, lastPieceSize, dfOCI) then
          lastInd := 1
        else
          lastInd := -1;
{$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace3;
{$ENDIF}
        Check(Lib.OCIStmtSetPieceInfo(lastPieceVar.FHandle, varType,
          Error.FHandle, lastBuff, lastPieceSize, OCI_LAST_PIECE, pLastInd,
          pLastRCode^));
      end;
    end
    else
      lastPieceVar := nil;
  end;
end;

{-------------------------------------------------------------------------------}
{
var
  tmpLen: ub4;
  tmpInd: sb4;

function TOCIStatement.CallbackDefine(Define: pOCIDefine; Iter: cardinal; var Buf: pointer;
  var BufLen: pUb4; var PieceStatus: ub1; var Ind: pointer): sb4;
var
  oVar: TOCIVariable;
begin
  oVar := Hndl2PieceVar(Define);
  AllocPieceBuff;
  Buf := FPieceBuff;
  BufLen := @tmpLen;
  Ind := @tmpInd;
  PieceStatus := OCI_NEXT_PIECE;
  Result := OCI_CONTINUE;
end;

function OCICallbackDefine(octxp: pointer; defnp: pOCIDefine; iter: ub4; var bufpp: pointer;
   var alenpp: pUb4; var piecep: ub1; var indpp: pointer; var rcodep: pUb2): sb4; cdecl;
begin
  Result := TOCIStatement(octxp).CallbackDefine(defnp, iter, bufpp,
    alenpp, piecep, indpp);
  rcodep := nil;
end;
}

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TOCIStatement.DumpColumns(ARows: ub4; AEof: Boolean);
var
  i, j, n: Integer;
  ok: Boolean;
begin
  if Tracing then begin
    ok := False;
    for i := 0 to FVars.Count - 1 do
      with TOCIVariable(FVars[i]) do
        if VarType = odDefine then begin
          ok := True;
          Break;
        end;
    if ok and (ARows > 0) then begin
      for j := 0 to ARows - 1 do begin
        n := 1;
        Trace(ekCmdDataOut, esStart, 'Fetched', ['Row', j]);
        for i := 0 to FVars.Count - 1 do
          with TOCIVariable(FVars[i]) do
            if VarType = odDefine then begin
              Trace(ekCmdDataOut, 'Column',
                [String('N'), n, '@Type', dataTypeName[DataType],
                 'Size', DataSize, '@Data', DumpValue(j)]);
              Inc(n);
            end;
        Trace(ekCmdDataOut, esEnd, 'Fetched', ['Row', j]);
      end;
      if AEof then
        Trace(ekCmdDataOut, 'EOF', []);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.DumpParameters(ATypes: TOCIVarTypes);
var
  i, j, n: Integer;
begin
  if Tracing then begin
    n := 1;
    for i := 0 to FVars.Count - 1 do
      with TOCIVariable(FVars[i]) do
        if VarType in ATypes then begin
          Trace(ekCmdDataIn, 'Param',
            [String('N'), n, 'Name', DumpLabel, '@Mode', varTypeName[VarType],
             '@Type', dataTypeName[DataType], 'Size', DataSize, '@Data(0)', DumpValue(0)]);
          for j := 1 to ArrayLen - 1 do
            Trace(ekCmdDataIn, '  ... Data', ['I', j, '@V', DumpValue(j)]);
          Inc(n);
        end;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
// Actual operation's

procedure TOCIStatement.AddVar(AVar: TOCIVariable);
begin
  if FVars.IndexOf(AVar) = -1 then
    FVars.Add(AVar);
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.RemoveVar(AVar: TOCIVariable);
begin
  FVars.Remove(AVar);
end;

{-------------------------------------------------------------------------------}
function TOCIStatement.AddVar(const AName: String; AVarType: TOCIVarType;
  ADataType: TOCIVarDataType; ASize: ub4): TOCIVariable;
begin
  Result := TOCIVariable.Create(Self);
  try
    Result.Name := AName;
    Result.VarType := AVarType;
    Result.DataType := ADataType;
    if ASize > 0 then
      Result.DataSize := ASize;
    Result.Bind;
  except
    Result.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TOCIStatement.AddVar(APosition: ub4; AVarType: TOCIVarType;
  ADataType: TOCIVarDataType; ASize: ub4): TOCIVariable;
begin
  Result := TOCIVariable.Create(Self);
  try
    Result.Position := APosition;
    Result.VarType := AVarType;
    Result.DataType := ADataType;
    if ASize > 0 then
      Result.DataSize := ASize;
    Result.Bind;
  except
    Result.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.Prepare(const AStatement: String);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIStmtPrepare, ['Stmt', AStatement]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIStmtPrepare(FHandle, Error.FHandle, PChar(AStatement),
    Length(AStatement), OCI_NTV_SYNTAX, OCI_DEFAULT));
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.Describe;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIStmtExecute, ['ARows', '<describe>']);
  end;
{$ENDIF}
var
  res: sb4;
begin
  FService.UpdateNonBlockingMode;
  try
    repeat
{$IFDEF AnyDAC_MONITOR}
      if Tracing then ProcTrace;
{$ENDIF}
      res := Lib.OCIStmtExecute(FService.FHandle, FHandle, Error.FHandle,
        0, 0, nil, nil, OCI_DESCRIBE_ONLY);
      case res of
        OCI_STILL_EXECUTING:
          FService.DoYield;
        OCI_NO_DATA, OCI_NEED_DATA, OCI_SUCCESS:
          ;
        else
          Check(res);
      end;
    until (res <> OCI_NEED_DATA) and (res <> OCI_STILL_EXECUTING);
  except
    on E: EOCINativeException do begin
      if (Lib.FOCIVersion >= cvOracle81000) and (E.ErrorCount > 0) then
        E.Errors[0].CommandTextOffset := PARSE_ERROR_OFFSET;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.Execute(ARows, AOffset: sb4; AExact, ACommit: Boolean);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace1;
  begin
    Trace(sOCIStmtExecute, ['ARows', ARows, 'AOffset', AOffset]);
  end;
  procedure ProcTrace2;
  begin
    Trace(sOCIStmtFetch, ['ARows', ARows]);
  end;
{$ENDIF}
var
  mode: ub4;
  res: sb4;
  pieceLoopData: TOCIPieceLoopData;
begin
  mode := OCI_DEFAULT;
  if AExact then
    mode := mode or OCI_EXACT_FETCH;
  if ACommit then
    mode := mode or OCI_COMMIT_ON_SUCCESS;
  if ARows <= 0 then begin
    ARows := 1;
    AOffset := 0;
  end;
  if AOffset < 0 then
    AOffset := 0;
  FService.UpdateNonBlockingMode;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then DumpParameters([odIn, odInOut]);
{$ENDIF}
  FLastRowCount := 0;
  FCanceled := False;
  InitPiecedFetch(pieceLoopData);
  Error.ClearInfo;
  try
    try
      repeat
        if not FRef then begin
{$IFDEF AnyDAC_MONITOR}
          if Tracing then ProcTrace1;
{$ENDIF}
          res := Lib.OCIStmtExecute(FService.FHandle, FHandle, Error.FHandle,
            ARows, AOffset, nil, nil, mode);
        end
        else begin
{$IFDEF AnyDAC_MONITOR}
          if Tracing then ProcTrace2;
{$ENDIF}
          res := Lib.OCIStmtFetch(FHandle, Error.FHandle, ARows,
            OCI_FETCH_NEXT, OCI_DEFAULT);
        end;
        case res of
          OCI_STILL_EXECUTING:
            FService.DoYield;
          OCI_NEED_DATA, OCI_NO_DATA, OCI_SUCCESS:
            begin
              if (res = OCI_NO_DATA) and AExact then
                Check(res);
              DoPiecedFetch(pieceLoopData, res);
            end;
          OCI_SUCCESS_WITH_INFO:
            begin
              DoPiecedFetch(pieceLoopData, res);
              Check(res);
            end;
          else
            Check(res);
        end;
      until (res <> OCI_NEED_DATA) and (res <> OCI_STILL_EXECUTING);
    except
      on E: EOCINativeException do begin
        if E.ErrorCount > 0 then begin
          if Lib.FOCIVersion >= cvOracle81000 then
            E.Errors[0].CommandTextOffset := PARSE_ERROR_OFFSET;
          if sb4(ROW_COUNT) <> ARows - AOffset then
            E.Errors[0].RowIndex := AOffset + sb4(ROW_COUNT);
        end;
        raise;
      end;
    end;
  except
    if PiecedFetch then begin
      FService.Break(False);
      FService.Reset(False);
    end;
    raise;
  end;
  FLastRowCount := ROW_COUNT;
  FEof := (FLastRowCount <> ub4(ARows)) and (STMT_TYPE = OCI_STMT_SELECT);
{$IFDEF AnyDAC_MONITOR}
  if Tracing then begin
    DumpParameters([odOut, odInOut, odRet]);
    DumpColumns(FLastRowCount, FEof);
  end;
{$ENDIF}
  if FEof then
    FCanceled := True;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.Fetch(ANRows: ub4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIStmtFetch, ['ARows', ANRows]);
  end;
{$ENDIF}
var
  res: sb4;
  prevRowCount: ub4;
  pieceLoopData: TOCIPieceLoopData;
begin
  if FCanceled then begin
    FLastRowCount := 0;
    FEof := True;
    Exit;
  end;
  prevRowCount := ROW_COUNT;
  InitPiecedFetch(pieceLoopData);
  Error.ClearInfo;
  try
    repeat
{$IFDEF AnyDAC_MONITOR}
      if Tracing then ProcTrace;
{$ENDIF}
      res := Lib.OCIStmtFetch(FHandle, Error.FHandle, ANRows, OCI_FETCH_NEXT, OCI_DEFAULT);
      case res of
        OCI_STILL_EXECUTING:
          FService.DoYield;
        OCI_NO_DATA, OCI_NEED_DATA, OCI_SUCCESS:
          DoPiecedFetch(pieceLoopData, res);
        else
          Check(res);
      end;
    until (res <> OCI_NEED_DATA) and (res <> OCI_STILL_EXECUTING);
  except
    if PiecedFetch then begin
      FService.Break(False);
      FService.Reset(False);
    end;
    raise;
  end;
  FLastRowCount := ROW_COUNT - prevRowCount;
  FEof := FLastRowCount <> ANRows;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then DumpColumns(FLastRowCount, FEof);
{$ENDIF}
  if FEof then
    FCanceled := True;
end;

{-------------------------------------------------------------------------------}
procedure TOCIStatement.CancelCursor;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIStmtFetch, ['ARows', '<cancel>']);
  end;
{$ENDIF}
begin
  if FCanceled then
    Exit;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIStmtFetch(FHandle, Error.FHandle, 0, OCI_FETCH_NEXT, OCI_DEFAULT));
  FCanceled := True;
end;

{-------------------------------------------------------------------------------}
{ TOCIVariable                                                                  }
{-------------------------------------------------------------------------------}
procedure OraDate2DateTime(pIn: pUb1; var D: TDateTime);
begin
  D := 0.0;
  with POraDate(pIn)^ do
    if Century <> 0 then
      D := EncodeDate(Word((Century - 100) * 100 + (Year - 100)), Month, Day) +
         EncodeTime(Word(Hour - 1), Word(Minute - 1), Word(Second - 1), 0);
end;

{-------------------------------------------------------------------------------}
procedure DateTime2OraDate(pOut: pUb1; const D: TDateTime);
var
  tmp, Y, M, D2, H, M2, S: Word;
begin
  with POraDate(pOut)^ do begin
    Y := 0;
    M := 0;
    D2 := 0;
    DecodeDate(D, Y, M, D2);
    Century := ub1(Y div 100 + 100);
    Year := ub1(Y - (Century - 100) * 100 + 100);
    Month := ub1(M);
    Day := ub1(D2);
    H := 0;
    M2 := 0;
    S := 0;
    tmp := 0;
    DecodeTime(D, H, M2, S, tmp);
    Hour := ub1(H + 1);
    Minute := ub1(M2 + 1);
    Second := ub1(S + 1);
  end;
end;

{-------------------------------------------------------------------------------}
procedure OraDate2SQLTimeStamp(pIn: pUb1; var D: TADSQLTimeStamp);
begin
  with POraDate(pIn)^ do
    if Century <> 0 then begin
      D.Year := Smallint((Century - 100) * 100 + (Year - 100));
      D.Month := Month;
      D.Day := Day;
      D.Hour := Word(Hour - 1);
      D.Minute := Word(Minute - 1);
      D.Second := Word(Second - 1);
      D.Fractions := 0;
    end
    else
      ADFillChar(D, SizeOf(TADSQLTimeStamp), #0);
end;

{-------------------------------------------------------------------------------}
procedure SQLTimeStamp2OraDate(pOut: pUb1; const D: TADSQLTimeStamp);
begin
  with POraDate(pOut)^ do begin
    Century := ub1(D.Year div 100 + 100);
    Year := ub1(D.Year - (Century - 100) * 100 + 100);
    Month := ub1(D.Month);
    Day := ub1(D.Day);
    Hour := ub1(D.Hour + 1);
    Minute := ub1(D.Minute + 1);
    Second := ub1(D.Second + 1);
  end;
end;

{-------------------------------------------------------------------------------}
// create & destroy & prop's

constructor TOCIVariable.Create(AStmt: TOCIStatement);
begin
  inherited Create;
  FOwner := AStmt;
  FOwningObj := AStmt.OwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  ArrayLen := 1;
end;

{-------------------------------------------------------------------------------}
destructor TOCIVariable.Destroy;
begin
  FreeBuffer;
  FHandle := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.SetArrayLen(const Value: ub4);
begin
  if FMaxArr_len <> Value then begin
    FreeBuffer;
    FMaxArr_len := Value;
    FCurEle := Value;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.InitCharSize;
begin
  if FDataType in [otNChar, otNString, otNLong] then
    FValue_char_sz := FValue_byte_sz div SizeOf(WideChar)
  else
    FValue_char_sz := FValue_byte_sz;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.SetDataSize(const Value: ub4);
begin
  if FValue_byte_sz <> Value then begin
    FreeBuffer;
    FValue_byte_sz := Value;
    InitCharSize;
    InitLongData;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.SetDataType(const Value: TOCIVarDataType);

  procedure AdjustByteSize(AMax: ub4);
  begin
    if FValue_byte_sz > AMax div TOCIStatement(FOwner).FService.BytesPerChar then
      FValue_byte_sz := AMax div TOCIStatement(FOwner).FService.BytesPerChar;
  end;

var
  lSetMax: Boolean;
begin
  if FDataType <> Value then begin
    FreeBuffer;
    FDataType := Value;
    FValue_ty := nc2ociValueType[Value];
    FValue_byte_sz := nc2ociValueSize[Value];
    if FValue_byte_sz = IDefStrSize then begin
      FValue_byte_sz := TOCIStatement(FOwner).StrsMaxSize;
      lSetMax := True;
    end
    else if (Value in [otNString, otNChar]) and (FValue_byte_sz = IDefStrSize * SizeOf(WideChar)) then begin
      FValue_byte_sz := TOCIStatement(FOwner).StrsMaxSize * SizeOf(WideChar);
      lSetMax := True;
    end
    else
      lSetMax := False;
    if lSetMax then
      case FDataType of
      otString:  AdjustByteSize(4000);
      otChar:    AdjustByteSize(2000);
      otRaw:     AdjustByteSize(2000);
      otNString: AdjustByteSize(4000);
      otNChar:   AdjustByteSize(2000);
      end;
    InitCharSize;
    InitLongData;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.SetVarType(const Value: TOCIVarType);
begin
  if FVarType <> Value then begin
    FreeBuffer;
    FVarType := Value;
    InitCharSize;
    InitLongData;
  end;
end;

{-------------------------------------------------------------------------------}
function TOCIVariable.GetDumpLabel: String;
begin
  if FDumpLabel = '' then
    if Name = '' then
      Result := IntToStr(Position)
    else
      Result := Name
  else
    Result := FDumpLabel;
end;

{-------------------------------------------------------------------------------}
// Bind record's array access

function TOCIVariable.GetBindDataSize: ub4;
var
  L: ub4;
begin
  if LongData then
    L := SizeOf(TOraLong)
  else
    L := FValue_byte_sz;
  Result := Sizeof(TBindData) + (Sizeof(sb2) + Sizeof(ub2) +
    Sizeof(ub2) + L) * FMaxArr_len;
end;

{-------------------------------------------------------------------------------}
function TOCIVariable.GetBuffer(AIndex: ub4): pUb1;
var
  L: ub4;
begin
  if LongData then
    L := SizeOf(TOraLong)
  else
    L := FValue_byte_sz;
  Result := pUb1(ub4(FBindData^.FBuffer) + L * ub4(AIndex));
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.ClearBuffer(AIndex: sb4);
var
  i: Integer;
  dType: ub4;
  lIsTemp: LongBool;
  hErr: pOCIError;

  procedure DoClear(i: Integer);
{$IFDEF AnyDAC_MONITOR}
    procedure ProcTrace1;
    begin
      Trace(sOCIHandleFree, ['HKind', hndlNames[dType], 'HVal', ppOCIHandle(Buffer[i])^]);
    end;
    procedure ProcTrace2;
    begin
      Trace(sOCIDescriptorFree, ['HKind', hndlNames[dType], 'HVal', ppOCIHandle(Buffer[i])^]);
    end;
    procedure ProcTrace3;
    begin
      Trace(sOCILobIsTemporary, ['HVal', ppOCIHandle(Buffer[i])^]);
    end;
    procedure ProcTrace4;
    begin
      Trace(sOCILobFreeTemporary, ['HVal', ppOCIHandle(Buffer[i])^]);
    end;
{$ENDIF}
  begin
    if LongData then
      FreeLong(POraLong(Buffer[i]))
    else if (dType <> 0) and (ppOCIHandle(Buffer[i])^ <> nil) then begin
      CheckOwner;
      if dType = OCI_HTYPE_STMT then begin
{$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace1;
{$ENDIF}
        Check(Lib.OCIHandleFree(ppOCIHandle(Buffer[i])^, dType));
      end
      else begin
        if (Lib.FOCIVersion >= cvOracle81000) and (dType = OCI_DTYPE_LOB) and
           (VarType in [odIn, odInOut]) then begin
          hErr := Error.FHandle;
{$IFDEF AnyDAC_MONITOR}
          if Tracing then ProcTrace3;
{$ENDIF}
          Check(Lib.OCILobIsTemporary(TOCIStatement(FOwner).FService.FOwner.Handle,
            hErr, ppOCIHandle(Buffer[i])^, lIsTemp));
          if lIsTemp then begin
{$IFDEF AnyDAC_MONITOR}
            if Tracing then ProcTrace4;
{$ENDIF}
            Check(Lib.OCILobFreeTemporary(TOCIStatement(FOwner).FService.FHandle,
              hErr, ppOCIHandle(Buffer[i])^));
          end;
        end;
{$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace2;
{$ENDIF}
        Check(Lib.OCIDescriptorFree(ppOCIHandle(Buffer[i])^, dType));
      end;
      ppOCIHandle(Buffer[i])^ := nil;
    end;
  end;

begin
  dType := 0;
  case DataType of
  otCursor, otNestedDataSet:
    dType := OCI_HTYPE_STMT;
  otCLOB, otNCLOB, otBLOB:
    dType := OCI_DTYPE_LOB;
  otCFile, otBFile:
    dType := OCI_DTYPE_FILE;
  end;
  if AIndex = -1 then
    for i := 0 to FMaxArr_len - 1 do
      DoClear(i)
  else
    DoClear(AIndex);
  if FBuffStatus = bsExtInit then
    FBuffStatus := bsExtUnknown;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.FreeBuffer;
begin
  if (FBindData <> nil) and (FBuffStatus in [bsInt, bsExtInit]) then begin
    ClearBuffer(-1);
    if FOwner <> nil then
      TOCIStatement(FOwner).RemovePieceVar(Self);
    if FBuffStatus = bsInt then
      FreeMem(FBindData);
    FBindData := nil;
    FBuffStatus := bsInt;
    FLastBindedBuffer := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.InitBuffer(AIndex: sb4);
var
  i: Integer;
  dType: ub4;
  lobType: ub1;

  procedure DoInit(i: ub4);
{$IFDEF AnyDAC_MONITOR}
    procedure ProcTrace1;
    begin
      Trace(sOCIHandleAlloc, ['HKind', hndlNames[dType]]);
    end;
    procedure ProcTrace2;
    begin
      Trace(sOCIDescriptorAlloc, ['HKind', hndlNames[dType]]);
    end;
    procedure ProcTrace3;
    begin
      Trace(sOCILobCreateTemporary, ['LobType', LobTypeNames[LobType], 'HVal', ppOCIHandle(Buffer[i])^]);
    end;
{$ENDIF}
  begin
    with FBindData^ do begin
      FInd[i] := -1;
      FALen[i] := ub2(FValue_char_sz);
      FRCode[i] := OCI_SUCCESS;
    end;
    if LongData then
      InitLong(POraLong(Buffer[i]))
    else if dType <> 0 then begin
      ppOCIHandle(Buffer[i])^ := nil;
      CheckOwner;
      if dType = OCI_HTYPE_STMT then begin
{$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace1;
{$ENDIF}
        Check(Lib.OCIHandleAlloc(FOwner.FOwner.FHandle, ppOCIHandle(Buffer[i])^,
          OCI_HTYPE_STMT, 0, nil));
        FBindData^.FInd[i] := 0;
      end
      else begin
{$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace2;
{$ENDIF}
        Check(Lib.OCIDescriptorAlloc(FOwner.FOwner.FHandle, ppOCIHandle(Buffer[i])^,
          dType, 0, nil));
        if (Lib.FOCIVersion >= cvOracle81000) and (dType = OCI_DTYPE_LOB) and (VarType in [odIn, odInOut]) then begin
          case DataType of
          otBLOB:  lobType := OCI_TEMP_BLOB;
          otCLOB:  lobType := OCI_TEMP_CLOB;
          otNCLOB: lobType := OCI_TEMP_CLOB;
          end;
{$IFDEF AnyDAC_MONITOR}
          if Tracing then ProcTrace3;
{$ENDIF}
          Check(Lib.OCILobCreateTemporary(TOCIStatement(FOwner).FService.FHandle,
            Error.FHandle, ppOCIHandle(Buffer[i])^, National2CSID[DataType = otNCLOB],
            National2SQLCS[DataType = otNCLOB], lobType, True, OCI_DURATION_SESSION));
          FBindData^.FInd[i] := 0; //TB???
        end;
      end;
    end;
  end;

begin
  if FValue_ty <= 0 then
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraBadValueType,
      [FPlaceHolder, FValue_ty]);
  if not (DataType in [otString, otNString, otChar, otNChar, otLong, otNLong, otLongRaw, otNumber]) and
    ((FValue_byte_sz <= 0) or (FValue_char_sz <= 0)) then
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraBadValueSize, []);
  if FMaxArr_len <= 0 then
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraBadArrayLen, []);
  case DataType of
  otCursor, otNestedDataSet:
    dType := OCI_HTYPE_STMT;
  otCLOB, otNCLOB, otBLOB:
    dType := OCI_DTYPE_LOB;
  otCFile, otBFile:
    dType := OCI_DTYPE_FILE;
  else
    dType := 0;
  end;
  if FBuffStatus = bsExtUnknown then
    FBuffStatus := bsExtInit;
  CheckBufferAccess;
  if AIndex = -1 then
    for i := 0 to FMaxArr_len - 1 do
      DoInit(i)
  else
    DoInit(AIndex);
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.ResetBuffer(AIndex: sb4);
begin
  ClearBuffer(AIndex);
  InitBuffer(AIndex);
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.CheckOwner;
begin
  if (FOwner = nil) then
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraVarWithoutStmt, []);
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.CheckRange(AIndex: ub4);
  procedure Error;
  begin
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraOutOfCount,
      [AIndex, FMaxArr_len]);
  end;
begin
  if AIndex >= FMaxArr_len then
    Error;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.CheckBufferAccess;
begin
  if (FBindData = nil) and (FBuffStatus = bsInt) or
     (FBindData <> nil) and (FBuffStatus = bsExtUnknown) then begin
    if FBuffStatus = bsInt then begin
      GetMem(FBindData, BindDataSize);
      MapBuffer;
    end;
    InitBuffer(-1);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.MapBuffer;
var
  p: pUb1;
begin
  p := pUb1(FBindData);
  with FBindData^ do begin
    Inc(p, Sizeof(TBindData));
    FInd := PSb2Array(p);
    Inc(p, Sizeof(sb2) * FMaxArr_len);
    FALen := PUb2Array(p);
    Inc(p, Sizeof(ub2) * FMaxArr_len);
    FRCode := PUb2Array(p);
    Inc(p, Sizeof(ub2) * FMaxArr_len);
    FBuffer := pUb1(p);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.SetExternBuffer(AValue: pUb1);
begin
  FBindData := PBindData(AValue);
  if FBindData <> nil then
    MapBuffer;
  FBuffStatus := bsExtInit;
end;

{-------------------------------------------------------------------------------}
function TOCIVariable.GetExternBuffer: pUb1;
begin
  Result := pUb1(FBindData);
end;

{-------------------------------------------------------------------------------}
// actual bind

{$IFDEF AnyDAC_OCI_USE_BINDDYNAMIC}
var
  null_ind: sb2;

function InCBFunc(ictxp: Pointer; bindp: pOCIBind; iter: ub4; index: ub4;
  var bufpp: Pointer; var alenp: Ub4; var piecep: Ub1; var indp: pSb2): sword; cdecl;
begin
  bufpp := nil;
  alenp := 0;
  indp := nil;
  null_ind := -1;
  indp := @null_ind;
  piecep := OCI_ONE_PIECE;
  Result := OCI_CONTINUE;
end;

function OutCBFunc(ictxp: Pointer; bindp: pOCIBind; iter: ub4; index: ub4;
  var bufpp: Pointer; var alenpp: pUb4; var piecep: ub1; var indpp: pSb2;
  var rcodepp: pUb2): sword; cdecl;
var
  V: TOCIVariable;
begin
  V := TOCIVariable(ictxp);
  if index = 0 then begin
    // check number of rows returned is valid
    // support ONLY for 1 row per 1 iteration
    if V.ROWS_RETURNED <> 1 then begin
      Result := OCI_ERROR;
      Exit;
    end;
  end;
  V.CheckRange(iter);
  with V.FBindData^ do begin
    bufpp := V.Buffer[iter];
    alenpp := @(FALen[iter]);
    indpp := @(FInd[iter]);
    rcodepp := @(FRCode[iter]);
  end;
  piecep := OCI_ONE_PIECE;
  Result := OCI_CONTINUE;
end;
{$ENDIF}

procedure TOCIVariable.Bind;
var
  v1: ub4;
  v2: pUb4;
  sz: sb4;
  tp: ub2;
  plcHldr: String;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace1;
  begin
    Trace(sOCIDefineByPos, ['Pos', FPosition, 'Mode', 'OCI_DYNAMIC_FETCH']);
  end;
  procedure ProcTrace2;
  begin
    Trace(sOCIDefineByPos, ['Pos', FPosition]);
  end;
  procedure ProcTrace3;
  begin
    Trace(sOCIBindByName, ['Name', FPlaceHolder, 'Mode', 'OCI_DATA_AT_EXEC']);
  end;
  procedure ProcTrace4;
  begin
    Trace(sOCIBindDynamic, []);
  end;
  procedure ProcTrace5;
  begin
    Trace(sOCIBindByPos, ['Pos', FPosition, 'Mode', 'OCI_DATA_AT_EXEC']);
  end;
  procedure ProcTrace6;
  begin
    Trace(sOCIBindByPos, ['Pos', FPosition]);
  end;
  procedure ProcTrace7;
  begin
    Trace(sOCIBindByName, ['Name', plcHldr, 'Mode', 'OCI_DATA_AT_EXEC']);
  end;
  procedure ProcTrace8;
  begin
    Trace(sOCIBindByName, ['Name', plcHldr]);
  end;
{$ENDIF}
begin
  CheckOwner;
  CheckRange(0);
  CheckBufferAccess;
  with FBindData^ do begin
    tp := FValue_ty;
    sz := FValue_byte_sz;
    if DataType in otVBlobs then begin
      // this is special case - if value size <> 0 then
      // there was mapping VARCHAR2/RAW into otLong/otNLong/otLongRaw
      if FValue_char_sz <> 0 then begin
        if DataType = otLong then
          tp := nc2ociValueType[otString]
        else if DataType = otNLong then
          tp := nc2ociValueType[otNString]
        else if DataType = otLongRaw then
          tp := nc2ociValueType[otRaw];
      end
      else
        sz := $7FFFFFFF;
    end;
    if VarType = odDefine then begin
      FType := OCI_HTYPE_DEFINE;
      if LongData then begin
{$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace1;
{$ENDIF}
        Check(Lib.OCIDefineByPos(FOwner.FHandle, FHandle, Error.FHandle,
          FPosition, nil, sz, tp, nil, nil, nil, OCI_DYNAMIC_FETCH));
        TOCIStatement(FOwner).AddPieceVar(Self);
      end
      else begin
{$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace2;
{$ENDIF}
        Check(Lib.OCIDefineByPos(FOwner.FHandle, FHandle, Error.FHandle,
          FPosition, FBuffer, sz, tp, FInd, FALen, FRCode, OCI_DEFAULT));
      end;
    end
{$IFDEF AnyDAC_OCI_USE_BINDDYNAMIC}
    // in 8.0.4 dynamic bind with BLOB's give access violation
    // when i try to use BLOB handle after query was executed
    else if VarType = odRet then begin
      if (FHandle = nil) or (FBuffer <> FLastBindedBuffer) then begin
        FLastBindedBuffer := FBuffer;
        FType := OCI_HTYPE_BIND;
  {$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace3;
  {$ENDIF}
        Check(Lib.OCIBindByName(FOwner.FHandle, FHandle, Error.FHandle,
          PChar(FPlaceHolder), Length(FPlaceHolder), nil, sz, tp, nil, nil,
          nil, 0, nil, OCI_DATA_AT_EXEC));
  {$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace4;
  {$ENDIF}
        Check(Lib.OCIBindDynamic(FHandle, Error.FHandle, Self, @InCBFunc,
          Self, @OutCBFunc));
      end;
    end
{$ENDIF}
    else if VarType in [odRet, odUnknown, odIn, odOut, odInOut] then begin
      if (FHandle = nil) or (FBuffer <> FLastBindedBuffer) then begin
        FLastBindedBuffer := FBuffer;
        FType := OCI_HTYPE_BIND;
        if FIsPLSQLTable and
           (TOCIStatement(FOwner).Stmt_Type in [OCI_STMT_BEGIN, OCI_STMT_DECLARE]) then begin
          v1 := FMaxArr_len;
          v2 := @FCurEle;
        end
        else begin
          v1 := 0;
          v2 := nil;
        end;
        if FPosition <> 0 then
          if LongData then begin
{$IFDEF AnyDAC_MONITOR}
            if Tracing then ProcTrace5;
{$ENDIF}
            Check(Lib.OCIBindByPos(FOwner.FHandle, FHandle, Error.FHandle,
              FPosition, nil, sz, tp, nil, nil, nil, v1, v2, OCI_DATA_AT_EXEC));
            TOCIStatement(FOwner).AddPieceVar(Self);
          end
          else begin
{$IFDEF AnyDAC_MONITOR}
            if Tracing then ProcTrace6;
{$ENDIF}
            Check(Lib.OCIBindByPos(FOwner.FHandle, FHandle, Error.FHandle,
              FPosition, FBuffer, sz, tp, FInd, FALen, FRCode, v1, v2, OCI_DEFAULT))
          end
        else begin
          if FIsCaseSensitive and (Lib.FOCIVersion >= cvOracle81600) then
            plcHldr := ':"' + Copy(FPlaceHolder, 2, Length(FPlaceHolder)) + '"'
          else
            plcHldr := FPlaceHolder;
          if LongData then begin
{$IFDEF AnyDAC_MONITOR}
            if Tracing then ProcTrace7;
{$ENDIF}
            Check(Lib.OCIBindByName(FOwner.FHandle, FHandle, Error.FHandle,
              PChar(plcHldr), Length(plcHldr), nil, sz, tp, nil, nil, nil,
              v1, v2, OCI_DATA_AT_EXEC));
            TOCIStatement(FOwner).AddPieceVar(Self);
          end
          else begin
{$IFDEF AnyDAC_MONITOR}
            if Tracing then ProcTrace8;
{$ENDIF}
            Check(Lib.OCIBindByName(FOwner.FHandle, FHandle, Error.FHandle,
              PChar(plcHldr), Length(plcHldr), FBuffer, sz, tp, FInd, FALen,
              FRCode, v1, v2, OCI_DEFAULT));
          end;
        end;
      end;
    end
    else
      ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraBadVarType, []);
    if DataType in [otNChar, otNString, otNLong] then begin // TB???
      if Lib.FOCIVersion < cvOracle90000 then begin
        CHARSET_FORM := SQLCS_NCHAR;
        CHARSET_ID := OCI_UCS2ID;
        if VarType <> odDefine then
          MAXDATA_SIZE := FValue_byte_sz;
      end
      else begin
        CHARSET_ID := OCI_UTF16ID;
        MAXCHAR_SIZE := FValue_char_sz;
      end;
    end;
  end;
  TOCIStatement(FOwner).AddVar(Self);
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.BindTo(AStmt: TOCIStatement);
begin
  FOwner := AStmt;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Bind;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.BindOff;
begin
  if FOwner <> nil then begin
    ClearBuffer(-1);
    TOCIStatement(FOwner).RemovePieceVar(Self);
    TOCIStatement(FOwner).RemoveVar(Self);
    FOwner := nil;
    FHandle := nil;
    FError := nil;
  end;
end;

{-------------------------------------------------------------------------------}
// long & long raw value

procedure TOCIVariable.InitLongData;
begin
  FLongData := (
    (FDataType in [otString, otNString, otChar, otNChar, otRaw]) and
       (FVarType = odDefine) and (FValue_byte_sz > TOCIStatement(FOwner).InrecDataSize)
    or
    (FDataType in otVBlobs) and (
      (FValue_byte_sz = 0) or (FValue_byte_sz > TOCIStatement(FOwner).InrecDataSize)
    )
  );
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.FreeLong(pLong: POraLong);
begin
  if pLong^.FData <> nil then
    try
      FreeMem(pLong^.FData, pLong^.FSize);
    finally
      InitLong(pLong);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.InitLong(pLong: POraLong);
begin
  pLong^.FData := nil;
  pLong^.FSize := 0;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.GetLong(pLong: POraLong; var AData: pUb1; var ASize: ub4);
begin
  ASize := pLong^.FSize;
  AData := pLong^.FData;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.SetLong(pLong: POraLong; AData: pUb1; ASize: ub4; AOwnBuffer: Boolean);
begin
  FreeLong(pLong);
  if AOwnBuffer then
    pLong^.FData := AData
  else begin
    GetMem(pLong^.FData, ASize);
    ADMove(AData^, pLong^.FData^, ASize);
  end;
  pLong^.FSize := ASize;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.AppendLong(pLong: POraLong; AData: pUb1; ASize: ub4; AOwnBuffer: Boolean);
begin
  if pLong^.FData = nil then
    SetLong(pLong, AData, ASize, AOwnBuffer)
  else begin
    ReallocMem(pLong^.FData, pLong^.FSize + ASize);
    ADMove(AData^, pUb1(ub4(pLong^.FData) + pLong^.FSize)^, ASize);
    Inc(pLong^.FSize, ASize);
    if AOwnBuffer then
      FreeMem(AData);
  end;
end;

{-------------------------------------------------------------------------------}
// get/set value

function TOCIVariable.UpdateHBlobNullInd(AIndex: ub4): Boolean;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobLocatorIsInit, []);
  end;
{$ENDIF}
var
  init: LongBool;
begin
  CheckRange(AIndex);
  with FBindData^ do begin
    if DataType >= otCLOB then begin
      if ppOCIHandle(Buffer[AIndex])^ = nil then
        FInd[AIndex] := -1
      else begin
{$IFDEF AnyDAC_MONITOR}
        if Tracing then ProcTrace;
{$ENDIF}
        init := False;
        Check(Lib.OCILobLocatorIsInit(FOwner.FOwner.FHandle, Error.FHandle,
          ppOCIHandle(Buffer[AIndex])^, init));
        if not init then
          FInd[AIndex] := -1
        else
          FInd[AIndex] := 0;
      end;
    end;
    Result := (FInd[AIndex] = 0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.ErrUnsupValueType;
begin
  ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraUnsupValueType, []);
end;

{-------------------------------------------------------------------------------}
function TOCIVariable.GetDataPtr(AIndex: ub4; var ABuff: pUb1; var ASize: ub4;
  AFormat: TOCIDataFormat): Boolean;
begin
  CheckRange(AIndex);
  CheckBufferAccess;
  with FBindData^ do begin
    if (FInd[AIndex] = -1) and (DataType < otCursor) then begin
      Result := False;
      ABuff := nil;
    end
    else begin
      Result := True;
      ABuff := Buffer[AIndex];
      case DataType of
        otInteger:
          ASize := SizeOf(Integer);
        otFloat:
          ASize := SizeOf(Double);
        otNumber:
          ASize := FALen[AIndex];
        otString, otChar, otRaw, otLong, otLongRaw:
          if LongData then
            GetLong(POraLong(ABuff), ABuff, ASize)
          else
            ASize := FALen[AIndex];
        otNString, otNChar, otNLong:
          begin
            if LongData then begin
              GetLong(POraLong(ABuff), ABuff, ASize);
              if AFormat <> dfOCI then
                ASize := LongWord(ASize) div SizeOf(WideChar);
            end
            else begin
              ASize := FALen[AIndex];
              if AFormat = dfOCI then
                ASize := LongWord(ASize) * SizeOf(WideChar);
            end;
          end;
        otROWID:
          ASize := FALen[AIndex];
        otDateTime:
          ASize := 7;
      else
        if DataType >= otCursor then begin
          ASize := SizeOf(pOCIHandle);
          Result := UpdateHBlobNullInd(AIndex);
        end
        else
          ErrUnsupValueType;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TOCIVariable.GetData(AIndex: ub4; ABuff: pUb1; var ASize: ub4;
  AFormat: TOCIDataFormat): Boolean;
var
  p: pUb1;
begin
  p := nil;
  Result := GetDataPtr(AIndex, p, ASize, dfDataSet);
  if (ABuff <> nil) and
     (Result or (DataType >= otCursor)) then
    case DataType of
      otInteger:
        PInteger(ABuff)^ := PInteger(p)^;
      otFloat:
        PDouble(ABuff)^ := PDouble(p)^;
      otNumber:
        case AFormat of
        dfDelphi,
        dfOCI:
          ADMove(p^, PChar(ABuff)^, ASize);
        dfDataSet:
          begin
            ADStr2BCD(PChar(p), ASize, PADBcd(ABuff)^, TOCIStatement(FOwner).DecimalSep);
            ASize := SizeOf(TADBcd);
          end;
        end;
      otString, otChar, otRaw, otLong, otLongRaw, otROWID:
        begin
          if (DataType = otChar) and TOCIStatement(FOwner).StrsTrim then
            while (ASize > 0) and (PAnsiChar(p)[ASize - 1] <= ' ') do
              Dec(ASize);
          if (ASize = 0) and TOCIStatement(FOwner).StrsEmpty2Null then
            Result := False
          else begin
            ADMove(p^, PAnsiChar(ABuff)^, ASize * SizeOf(AnsiChar));
            if (DataType = otChar) and (ASize < FValue_char_sz) then
              ADFillChar((PAnsiChar(ABuff) + ASize)^, (FValue_char_sz - ASize) * SizeOf(AnsiChar), #0);
          end;
        end;
      otNString, otNChar, otNLong:
        begin
          if (DataType = otNChar) and TOCIStatement(FOwner).StrsTrim then
            while (ASize > 0) and (PWideChar(p)[ASize - 1] = ' ') do
              Dec(ASize);
          if (ASize = 0) and TOCIStatement(FOwner).StrsEmpty2Null then
            Result := False
          else begin
            ADMove(p^, PWideChar(ABuff)^, LongWord(ASize) * SizeOf(WideChar));
            if (DataType = otNChar) and (ASize < FValue_char_sz) then
              ADFillChar((PWideChar(ABuff) + ASize)^, LongWord(FValue_char_sz - ASize) * SizeOf(WideChar), #0);
          end;
          if AFormat = dfOCI then
            ASize := LongWord(ASize) * SizeOf(WideChar);
        end;
      otDateTime:
        case AFormat of
        dfOCI:
          POraDate(ABuff)^ := POraDate(p)^;
        dfDataSet:
          begin
            OraDate2SQLTimeStamp(p, PADSQLTimeStamp(ABuff)^);
            ASize := SizeOf(TADSQLTimeStamp);
          end;
        dfDelphi:
          begin
            OraDate2DateTime(p, PDateTime(ABuff)^);
            ASize := SizeOf(TDateTime);
          end;
        end;
    else
      if DataType >= otCursor then
        ppOCIHandle(ABuff)^ := ppOCIHandle(p)^
      else
        ErrUnsupValueType;
    end;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
function TOCIVariable.DumpValue(AIndex: ub4): String;
var
  p: pUb1;
  buff: array[0..63] of ub1;
  sz: ub4;
  ws: WideString;
begin
  p := nil;
  sz := 0;
  if not GetDataPtr(AIndex, p, sz, dfDataSet) then
    Result := 'NULL'
  else begin
    case DataType of
      otString, otChar, otLong, otROWID:
        if sz > 1024 then begin
          SetString(Result, PChar(p), 1024);
          Result := '(truncated at 1024) ''' + Result + ' ...''';
        end
        else begin
          SetString(Result, PChar(p), sz);
          Result := '''' + Result + '''';
        end;
      otNString, otNChar, otNLong:
        if sz > 1024 then begin
          SetString(ws, PWideChar(p), 1024);
          Result := '(truncated at 1024) ''' + ws + ' ...''';
        end
        else begin
          SetString(ws, PWideChar(p), sz);
          Result := '''' + ws + '''';
        end;
      otNumber:
        SetString(Result, PChar(p), sz);
      otRaw, otLongRaw:
        if sz > 512 then begin
          SetLength(Result, 1024);
          BinToHex(PChar(p), PChar(Result), 512);
          Result := '(truncated at 512) ' + Result + ' ...';
        end
        else begin
          SetLength(Result, sz * 2);
          BinToHex(PChar(p), PChar(Result), sz);
        end;
      else begin
        GetData(AIndex, @buff, sz, dfDelphi);
        case DataType of
          otInteger:
            Result := IntToStr(PInteger(@buff)^);
          otFloat:
            Result := FloatToStr(PDouble(@buff)^);
          otDateTime:
            Result := DateTimeToStr(PDateTime(@buff)^);
        else
          if DataType >= otCursor then
            Result := '<HANDLE>' + IntToHex(PInteger(@buff)^, 8)
          else
            ErrUnsupValueType;
        end;
      end;
    end;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TOCIVariable.SetIsNull(AIndex: ub4; AIsNull: Boolean);
begin
  CheckRange(AIndex);
  CheckBufferAccess;
  with FBindData^ do
    if AIsNull then
      FInd[AIndex] := -1
    else
      FInd[AIndex] := 0;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.AppendData(AIndex: ub4; ABuff: pUb1; ASize: ub4);
begin
  if not LongData then
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraUnsupValueType, []);
  CheckRange(AIndex);
  CheckBufferAccess;
  AppendLong(POraLong(Buffer[AIndex]), ABuff, ASize, False);
  with FBindData^ do begin
    FInd[AIndex] := 0;
    FALen[AIndex] := ub2(SizeOf(TOraLong));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIVariable.SetData(AIndex: ub4; ABuff: pUb1; ASize: ub4; AFormat: TOCIDataFormat);
var
  buff: array[0..66] of Char;
  p: PChar;
  i: ub4;

  procedure ErrorDataTooLarge;
  begin
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraDataToLarge,
      [ASize, DumpLabel]);
  end;

begin
  CheckRange(AIndex);
  CheckBufferAccess;
  with FBindData^ do begin
    if LongData then
      FreeLong(POraLong(Buffer[AIndex]));
    if ABuff = nil then
      FInd[AIndex] := -1
    else begin
      FInd[AIndex] := 0;
      case DataType of
        otInteger:
          begin
            PInteger(Buffer[AIndex])^ := PInteger(ABuff)^;
            FALen[AIndex] := ub2(SizeOf(Integer));
          end;
        otFloat:
          begin
            PDouble(Buffer[AIndex])^ := PDouble(ABuff)^;
            FALen[AIndex] := ub2(Sizeof(Double));
          end;
        otNumber:
          begin
            if AFormat = dfDataSet then begin
              ADBCD2Str(buff, Integer(ASize), PADBcd(ABuff)^, TOCIStatement(FOwner).DecimalSep);
              ABuff := @buff;
            end
            else begin
              if ASize = $FFFFFFFF then
                ASize := StrLen(PChar(ABuff));
            end;
            if ASize > FValue_char_sz then
              ErrorDataTooLarge;
            FALen[AIndex] := ub2(ASize);
            ADMove(PChar(ABuff)^, Buffer[AIndex]^, ASize);
          end;
        otString, otChar, otRaw, otLong, otLongRaw, otROWID:
          begin
            if ASize = $FFFFFFFF then
              ASize := StrLen(PChar(ABuff));
            if (DataType = otChar) and TOCIStatement(FOwner).StrsTrim then
              while (ASize > 0) and (PChar(ABuff)[ASize - 1] <= ' ') do
                Dec(ASize);
            if TOCIStatement(FOwner).StrsEmpty2Null and (ASize = 0) then
              FInd[AIndex] := -1
            else begin
              if (ASize > FValue_char_sz) and (
                (DataType in [otString, otChar, otRaw, otROWID]) or
                (DataType in otVBlobs) and (FValue_char_sz <> 0)
                 ) then
                ErrorDataTooLarge;
              if LongData then begin
                SetLong(POraLong(Buffer[AIndex]), ABuff, ASize, AFormat = dfDelphiOwned);
                FALen[AIndex] := ub2(SizeOf(TOraLong));
              end
              else begin
                ADMove(PChar(ABuff)^, Buffer[AIndex]^, ASize);
                if (DataType = otChar) and (ASize < FValue_char_sz) then begin
                  ADFillChar((PChar(Buffer[AIndex]) + ASize)^, (FValue_char_sz - ASize) * SizeOf(AnsiChar), ' ');
                  FALen[AIndex] := ub2(FValue_char_sz);
                end
                else
                  FALen[AIndex] := ub2(ASize);
              end;
            end;
          end;
        otNString, otNChar, otNLong:
          begin
            if ASize = $FFFFFFFF then
              ASize := ADWideStrLen(PWideChar(ABuff))
            else if AFormat = dfOCI then
              ASize := ASize div SizeOf(WideChar);
            if (DataType = otNChar) and TOCIStatement(FOwner).StrsTrim then
              while (ASize > 0) and (PWideChar(ABuff)[ASize - 1] = ' ') do
                Dec(ASize);
            if TOCIStatement(FOwner).StrsEmpty2Null and (ASize = 0) then
              FInd[AIndex] := -1
            else begin
              if (ASize > FValue_char_sz) and (
                (DataType in [otNString, otNChar]) or
                (DataType = otNLong) and (FValue_char_sz <> 0)
                 ) then
                ErrorDataTooLarge;
              if LongData then begin
                SetLong(POraLong(Buffer[AIndex]), ABuff, ASize * SizeOf(WideChar), AFormat = dfDelphiOwned);
                FALen[AIndex] := ub2(SizeOf(TOraLong));
              end
              else begin
                ADMove(PWideChar(ABuff)^, Buffer[AIndex]^, ASize * SizeOf(WideChar));
                if (DataType = otNChar) and (ASize < FValue_char_sz) then begin
                  p := PChar(Buffer[AIndex]) + ASize * SizeOf(WideChar);
                  for i := ASize to FValue_char_sz do begin
                    p^ := #0;
                    Inc(p);
                    p^ := ' ';
                    Inc(p);
                  end;
                  FALen[AIndex] := ub2(FValue_char_sz);
                end
                else
                  FALen[AIndex] := ub2(ASize);
              end;
            end;
          end;
        otDateTime:
          begin
            case AFormat of
            dfOCI:
              POraDate(Buffer[AIndex])^ := POraDate(ABuff)^;
            dfDataSet:
              SQLTimeStamp2OraDate(Buffer[AIndex], PADSQLTimeStamp(ABuff)^);
            dfDelphi:
              DateTime2OraDate(Buffer[AIndex], PDateTime(ABuff)^);
            end;
            FALen[AIndex] := 7;
          end;
      else
        if DataType >= otCursor then begin
          if ppOCIHandle(ABuff)^ <> nil then begin
            ppOCIHandle(Buffer[AIndex])^ := ppOCIHandle(ABuff)^;
            FALen[AIndex] := ub2(SizeOf(pOCIHandle));
            UpdateHBlobNullInd(AIndex);
          end;
        end
        else
          ErrUnsupValueType;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TOCIDescriptor                                                                }
{-------------------------------------------------------------------------------}
function TOCIDescriptor.Init(AEnv: TOCIHandle; AType: ub4): pOCIDescriptor;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDescriptorAlloc, ['HKind', hndlNames[AType]]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDescriptorAlloc(AEnv.FHandle, FHandle, AType, 0, nil));
  FType := AType;
  Result := @FHandle;
end;

{-------------------------------------------------------------------------------}
destructor TOCIDescriptor.Destroy;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDescriptorFree, ['HKind', hndlNames[FType], 'HVal', FHandle]);
  end;
{$ENDIF}
begin
  if FHandle <> nil then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace;
{$ENDIF}
    Check(Lib.OCIDescriptorFree(FHandle, FType));
  end;
end;

{-------------------------------------------------------------------------------}
{ TOCISelectItem                                                                }
{-------------------------------------------------------------------------------}
constructor TOCISelectItem.Create(AStmt: TOCIStatement);
begin
  inherited Create;
  FOwner := AStmt;
  FOwningObj := AStmt.OwningObj;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  FType := OCI_DTYPE_PARAM;
end;

{-------------------------------------------------------------------------------}
destructor TOCISelectItem.Destroy;
begin
  FHandle := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCISelectItem.Bind;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIParamGet, ['Pos', FPosition]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIParamGet(FOwner.FHandle, OCI_HTYPE_STMT, Error.FHandle,
    FHandle, FPosition));
end;

{-------------------------------------------------------------------------------}
function TOCISelectItem.GetIsUnicode: Boolean;
begin
  Result := (CHARSET_FORM in [SQLCS_NCHAR, SQLCS_EXPLICIT]) or (BytesPerChar > 1);
end;

{-------------------------------------------------------------------------------}
function TOCISelectItem.GetDataType: TOCIVarDataType;
begin
  case DATA_TYPE of
  SQLT_CHR,
  SQLT_VCS:
    if IsUnicode then
      if CharSize <= C_AD_MaxDlp4StrSize then
        Result := otNString
      else
        Result := otNLong
    else
      if CharSize <= C_AD_MaxDlp4StrSize then
        Result := otString
      else
        Result := otLong;
  SQLT_NUM:
    if ShortInt(SCALE) = -127 then
      Result := otFloat
    else
      Result := otNumber;
  SQLT_INT,
  _SQLT_PLI:
    Result := otInteger;
  SQLT_LNG:
    Result := otLong;
  SQLT_RID,
  SQLT_RDD:
    Result := otROWID;
  SQLT_DAT:
    Result := otDateTime;
  SQLT_BIN:
    Result := otRaw;
  SQLT_LBI:
    Result := otLongRaw;
  SQLT_AFC:
    if IsUnicode then
      if CharSize <= C_AD_MaxDlp4StrSize then
        Result := otNChar
      else
        Result := otNLong
    else
      if CharSize <= C_AD_MaxDlp4StrSize then
        Result := otChar
      else
        Result := otLong;
  SQLT_CLOB:
    if IsUnicode then
      Result := otNCLOB
    else
      Result := otCLOB;
  SQLT_BLOB:
    Result := otBLOB;
  SQLT_BFILEE:
    Result := otBFile;
  SQLT_CFILEE:
    Result := otCFile;
  SQLT_CUR:
    Result := otCursor;          // used in PL/SQL. maps to REF CURSOR
  SQLT_RSET:
    Result := otNestedDataSet;   // used in objects. maps to select ... cursor(select ...) ...
  else
    Result := otUnknown;
  end;
end;

{-------------------------------------------------------------------------------}
function TOCISelectItem.GetBytesPerChar: ub1;
var
  iCharSz: ub2;
begin
  Result := $FF;
  if Lib.FOCIVersion >= cvOracle90000 then begin
    iCharSz := GetUB2Attr(OCI_ATTR_CHAR_SIZE);
    if iCharSz <> 0 then
      Result := ub1(DATA_SIZE div iCharSz);
  end;
  if Result = $FF then
    if FOwner is TOCIStatement then
      Result := TOCIStatement(FOwner).FService.BytesPerChar
    else if FOwner is TOCIService then
      Result := TOCIService(FOwner).BytesPerChar;
  if (Result = 0) or (Result = $FF) then
    Result := 1;
end;

{-------------------------------------------------------------------------------}
function TOCISelectItem.GetCharSize: ub2;
begin
  if Lib.FOCIVersion >= cvOracle90000 then
    Result := GetUB2Attr(OCI_ATTR_CHAR_SIZE)
  else
    Result := ub2(DATA_SIZE div BytesPerChar);
end;

{-------------------------------------------------------------------------------}
function TOCISelectItem.GetDataSize: ub4;
var
  dt: TOCIVarDataType;
begin
  dt := DataType;
  if dt in [otString, otChar, otNString, otNChar, otRaw, otLong, otNLong, otLongRaw] then
    Result := DATA_SIZE
  else
    Result := nc2ociValueSize[dt];
end;

{-------------------------------------------------------------------------------}
function TOCISelectItem.GetDataPrecision: ub4;
begin
  if DATA_TYPE = SQLT_NUM then begin
    Result := PRECISION;
    if Result = 0 then
      Result := 38;
  end
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TOCISelectItem.GetDataScale: ub4;
begin
  if DATA_TYPE = SQLT_NUM then begin
    Result := SCALE;
    if ShortInt(Result) = -127 then
      Result := 0;
  end
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TOCISelectItem.GetVarType: TOCIVarType;
begin
  Result := odUnknown;
  case IOMODE of
  OCI_TYPEPARAM_OUT: Result := odOut;
  OCI_TYPEPARAM_IN: Result := odIn;
  OCI_TYPEPARAM_INOUT: Result := odInOut;
  end;
end;

{-------------------------------------------------------------------------------}
function TOCISelectItem.GetIsNull: Boolean;
begin
  Result := (IS_NULL <> 0);
end;

{-------------------------------------------------------------------------------}
{ TOCILobLocator                                                                }
{-------------------------------------------------------------------------------}
constructor TOCILobLocator.Create(AService: TOCIService; AType: ub4);
begin
  inherited Create;
  FOwner := AService;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(AService.FOwner, AType);
  FOwned := True;
end;

{-------------------------------------------------------------------------------}
constructor TOCILobLocator.CreateUseHandle(AService: TOCIService; AHandle: pOCIHandle);
begin
  FOwner := AService;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  FHandle := AHandle;
  FOwned := False;
end;

{-------------------------------------------------------------------------------}
destructor TOCILobLocator.Destroy;
begin
  if not FOwned then
    FHandle := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCILobLocator.Assign(AFrom: TOCILobLocator);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobAssign, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobAssign(FOwner.FOwner.FHandle, Error.FHandle,
    AFrom.FHandle, FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCILobLocator.Close;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace1;
  begin
    Trace(sOCILobClose, []);
  end;
  procedure ProcTrace2;
  begin
    Trace(sOCILobFileClose, []);
  end;
{$ENDIF}
begin
  if Lib.FOCIVersion >= cvOracle81000 then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace1;
{$ENDIF}
    Check(Lib.OCILobClose(FOwner.FHandle, Error.FHandle, FHandle));
  end
  else if FType = OCI_DTYPE_FILE then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace2;
{$ENDIF}
    Check(Lib.OCILobClose(FOwner.FHandle, Error.FHandle, FHandle));
  end;
end;

{-------------------------------------------------------------------------------}
function TOCILobLocator.GetLength: sb4;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobGetLength, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Result := 0;
  Check(Lib.OCILobGetLength(FOwner.FHandle, Error.FHandle, FHandle, ub4(Result)));
end;

{-------------------------------------------------------------------------------}
function TOCILobLocator.GetIsOpen: LongBool;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace1;
  begin
    Trace(sOCILobIsOpen, []);
  end;
  procedure ProcTrace2;
  begin
    Trace(sOCILobFileIsOpen, []);
  end;
{$ENDIF}
begin
  Result := False;
  if Lib.FOCIVersion >= cvOracle81000 then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace1;
{$ENDIF}
    Check(Lib.OCILobIsOpen(FOwner.FHandle, Error.FHandle, FHandle, Result));
  end
  else if FType = OCI_DTYPE_FILE then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace2;
{$ENDIF}
    Check(Lib.OCILobIsOpen(FOwner.FHandle, Error.FHandle, FHandle, Result));
  end
  else
    Result := True;
end;

{-------------------------------------------------------------------------------}
function TOCILobLocator.GetIsInit: LongBool;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobLocatorIsInit, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Result := False;
  Check(Lib.OCILobLocatorIsInit(FOwner.FOwner.FHandle, Error.FHandle,
    FHandle, Result));
end;

{-------------------------------------------------------------------------------}
procedure TOCILobLocator.Read(ABuff: pUb1; ABuffLen: ub4; var amount: ub4; offset: ub4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobRead, []);
  end;
{$ENDIF}
begin
  if FNational then
    ABuffLen := ABuffLen * SizeOf(WideChar);
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobRead(FOwner.FHandle, Error.FHandle, FHandle, amount, offset,
    ABuff, ABuffLen, nil, nil, National2CSID[National], National2SQLCS[National]));
end;

{-------------------------------------------------------------------------------}
procedure TOCILobLocator.Open(AReadOnly: Boolean);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace1;
  begin
    Trace(sOCILobOpen, []);
  end;
  procedure ProcTrace2;
  begin
    Trace(sOCILobFileOpen, []);
  end;
{$ENDIF}
const
  bool2mode: array[Boolean] of ub1 = (OCI_LOB_READWRITE, OCI_LOB_READONLY);
begin
  if Lib.FOCIVersion >= cvOracle81000 then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace1;
{$ENDIF}
    Check(Lib.OCILobOpen(FOwner.FHandle, Error.FHandle, FHandle,
      bool2mode[AReadOnly]));
  end
  else if FType = OCI_DTYPE_FILE then begin
{$IFDEF AnyDAC_MONITOR}
    if Tracing then ProcTrace2;
{$ENDIF}
    Check(Lib.OCILobOpen(FOwner.FHandle, Error.FHandle, FHandle,
      OCI_LOB_READONLY));
  end;
end;

{-------------------------------------------------------------------------------}
constructor TOCIIntLocator.CreateUseHandle(AService: TOCIService; AHandle: pOCIHandle);
begin
  inherited CreateUseHandle(AService, AHandle);
  FType := OCI_DTYPE_LOB;
end;

{-------------------------------------------------------------------------------}
procedure TOCIIntLocator.Append(AFrom: TOCIIntLocator);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobAppend, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobAppend(FOwner.FHandle, Error.FHandle, FHandle, AFrom.FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIIntLocator.Copy(AFrom: TOCIIntLocator; amount, dst_offset, src_offset: ub4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobCopy, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobCopy(FOwner.FHandle, Error.FHandle, FHandle, AFrom.FHandle,
    amount, dst_offset, src_offset));
end;

{-------------------------------------------------------------------------------}
procedure TOCIIntLocator.SetBuffering(const Value: Boolean);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace1;
  begin
    Trace(sOCILobEnableBuffering, []);
  end;
  procedure ProcTrace2;
  begin
    Trace(sOCILobDisableBuffering, []);
  end;
{$ENDIF}
begin
  if FBuffering <> Value then begin
    FBuffering := Value;
    if FBuffering then begin
{$IFDEF AnyDAC_MONITOR}
      if Tracing then ProcTrace1;
{$ENDIF}
      Check(Lib.OCILobEnableBuffering(FOwner.FHandle, Error.FHandle, FHandle));
    end
    else begin
{$IFDEF AnyDAC_MONITOR}
      if Tracing then ProcTrace2;
{$ENDIF}
      Check(Lib.OCILobDisableBuffering(FOwner.FHandle, Error.FHandle, FHandle));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIIntLocator.Erase(var amount: ub4; offset: ub4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobErase, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobErase(FOwner.FHandle, Error.FHandle, FHandle, amount, offset));
end;

{-------------------------------------------------------------------------------}
procedure TOCIIntLocator.FlushBuffer;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobFlushBuffer, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobFlushBuffer(FOwner.FHandle, Error.FHandle, FHandle,
    OCI_LOB_BUFFER_NOFREE));
end;

{-------------------------------------------------------------------------------}
procedure TOCIIntLocator.LoadFromFile(AFrom: TOCIExtLocator; amount, dst_offset, src_offset: ub4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobLoadFromFile, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobLoadFromFile(FOwner.FHandle, Error.FHandle, FHandle,
    AFrom.FHandle, amount, dst_offset, src_offset));
end;

{-------------------------------------------------------------------------------}
procedure TOCIIntLocator.Trim(ANewLen: ub4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobTrim, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobTrim(FOwner.FHandle, Error.FHandle, FHandle, ANewLen));
end;

{-------------------------------------------------------------------------------}
procedure TOCIIntLocator.Write(ABuff: pUb1; ABuffLen: ub4; var amount: ub4; offset: ub4);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobWrite, []);
  end;
{$ENDIF}
begin
  if FNational then
    ABuffLen := ABuffLen * SizeOf(WideChar);
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobWrite(FOwner.FHandle, Error.FHandle, FHandle, amount,
    offset, ABuff, ABuffLen, OCI_ONE_PIECE, nil, nil, National2CSID[National],
    National2SQLCS[National]));
end;

{-------------------------------------------------------------------------------}
function TOCIIntLocator.GetIsTemporary: LongBool;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobIsTemporary, []);
  end;
{$ENDIF}
begin
  if Lib.FOCIVersion < cvOracle81000 then begin
    Result := False;
    Exit;
  end;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobIsTemporary(FOwner.FHandle, Error.FHandle,
    FHandle, Result));
end;

{-------------------------------------------------------------------------------}
constructor TOCITempLocator.CreateTemp(AService: TOCIService; ALobType: ub1; ACache: Boolean);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobCreateTemporary, []);
  end;
{$ENDIF}
begin
  if Lib.FOCIVersion < cvOracle81000 then
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_OraId]);
  inherited Create(AService, OCI_DTYPE_LOB);
  FNational := (ALobType = OCI_TEMP_NCLOB);
  FBuffering := ACache;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobCreateTemporary(FOwner.FHandle, Error.FHandle,
    FHandle, National2CSID[FNational], National2SQLCS[FNational], ALobType,
    ACache, OCI_DURATION_SESSION));
end;

{-------------------------------------------------------------------------------}
destructor TOCITempLocator.Destroy;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobFreeTemporary, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobFreeTemporary(FOwner.FHandle, Error.FHandle, FHandle));
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
constructor TOCIExtLocator.CreateUseHandle(AService: TOCIService; AHandle: pOCIHandle);
begin
  inherited CreateUseHandle(AService, AHandle);
  FType := OCI_DTYPE_FILE;
end;

{-------------------------------------------------------------------------------}
function TOCIExtLocator.GetFileExists: LongBool;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobFileExists, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Result := False;
  Check(Lib.OCILobFileExists(FOwner.FHandle, Error.FHandle, FHandle, Result));
end;

{-------------------------------------------------------------------------------}
procedure TOCIExtLocator.GetFileDir(var ADir, AFileName: String);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobFileGetName, []);
  end;
{$ENDIF}
var
  dirBuff: array[0..29] of char;
  fileBuff: array[0..255] of char;
  dirLen, fileLen: ub2;
begin
  dirLen := 30;
  fileLen := 255;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobFileGetName(FOwner.FOwner.FHandle, Error.FHandle, FHandle,
    @dirBuff, dirLen, @fileBuff, fileLen));
  SetString(ADir, dirBuff, dirLen);
  SetString(AFileName, fileBuff, fileLen);
end;

{-------------------------------------------------------------------------------}
procedure TOCIExtLocator.SetFileDir(const ADir, AFileName: String);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCILobFileSetName, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCILobFileSetName(FOwner.FOwner.FHandle, Error.FHandle, FHandle,
    PChar(ADir), ub2(System.Length(ADir)), PChar(AFileName), ub2(System.Length(AFileName))));
end;

{-------------------------------------------------------------------------------}
function TOCIExtLocator.GetDirectory: String;
var
  AFileName: String;
begin
  AFileName := '';
  Result := '';
  GetFileDir(Result, AFileName);
end;

{-------------------------------------------------------------------------------}
function TOCIExtLocator.GetFileName: String;
var
  sDir: String;
begin
  sDir  := '';
  Result := '';
  GetFileDir(sDir, Result);
end;

{-------------------------------------------------------------------------------}
procedure TOCIExtLocator.SetDirectory(const Value: String);
begin
  SetFileDir(Value, FileName);
end;

{-------------------------------------------------------------------------------}
procedure TOCIExtLocator.SetFileName(const Value: String);
begin
  SetFileDir(Directory, Value);
end;

{-------------------------------------------------------------------------------}
{ TOCIDescribe                                                                  }
{-------------------------------------------------------------------------------}
constructor TOCIDescribe.Create(ASvc: TOCIService);
begin
  inherited Create;
  FOwner := ASvc;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(ASvc.FOwner, OCI_HTYPE_DESCRIBE);
  FStack := TList.Create;
  FCurr := TOCIHandle.Create;
  FCurr.FOwner := FOwner;
  FCurr.FType := OCI_DTYPE_PARAM;
end;

{-------------------------------------------------------------------------------}
destructor TOCIDescribe.Destroy;
begin
  FreeAndNil(FStack);
  FCurr.FHandle := nil;
  FreeAndNil(FCurr);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCIDescribe.DescribeName(const AName: String);

  procedure InternalDescribeName(const AName: String; ACanAddPublic: Boolean);
{$IFDEF AnyDAC_MONITOR}
    procedure ProcTrace;
    begin
      Trace(sOCIDescribeAny, ['Name', AName]);
    end;
{$ENDIF}
  var
    res: sb4;
  begin
    repeat
{$IFDEF AnyDAC_MONITOR}
      if Tracing then ProcTrace;
{$ENDIF}
      res := Lib.OCIDescribeAny(FOwner.FHandle, Error.FHandle, PChar(AName),
        Length(AName), OCI_OTYPE_NAME, 0, OCI_PTYPE_UNK, FHandle);
      if res = OCI_STILL_EXECUTING then
        TOCIService(FOwner).DoYield
      else if (res = OCI_ERROR) and ACanAddPublic then begin
        InternalDescribeName('"PUBLIC".' + AName, False);
        res := OCI_SUCCESS;
      end
      else
        Check(res);
    until res <> OCI_STILL_EXECUTING;
    FCurr.FHandle := GetHandleAttr(OCI_ATTR_PARAM);
  end;
begin
  InternalDescribeName(AName, True);
end;

{-------------------------------------------------------------------------------}
function TOCIDescribe.OpenList(AAtrType: Integer): ub4;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIAttrGet, ['VType', 'ub4', 'AType', 'OCI_ATTR_NUM_PARAMS']);
  end;
{$ENDIF}
begin
  FStack.Add(FCurr.FHandle);
  FStack.Add(FCurr.GetHandleAttr(AAtrType));
  Result := 0;
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIAttrGet(FStack.Last, OCI_DTYPE_PARAM, @Result, nil,
    OCI_ATTR_NUM_PARAMS, Error.FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIDescribe.CloseList;
begin
  FCurr.FHandle := FStack.Items[FStack.Count - 2];
  FStack.Delete(FStack.Count - 1);
  FStack.Delete(FStack.Count - 1);
end;

{-------------------------------------------------------------------------------}
function TOCIDescribe.GetIsListOpened: Boolean;
begin
  Result := FStack.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TOCIDescribe.GoToItem(AIndex: Integer);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIParamGet, ['Index', AIndex]);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIParamGet(FStack.Last, OCI_DTYPE_PARAM, Error.FHandle,
    FCurr.FHandle, AIndex));
end;

{-------------------------------------------------------------------------------}
function TOCIDescribe.GetSelectItem(AIndex: Integer): TOCISelectItem;
begin
  try
    GoToItem(AIndex);
  except on E: EOCINativeException do
    if (E.ErrorCount > 0) and (E.Errors[0].ErrorCode = 24334) then begin
      Result := nil;
      Exit;
    end
    else
      raise;
  end;
  Result := TOCISelectItem.Create(TOCIStatement(FOwner));
  Result.FHandle := FCurr.FHandle;
end;

{-------------------------------------------------------------------------------}
function TOCIDescribe.GetPtr(AIndex: Integer): Pointer;
begin
  Result := FCurr.GetHandleAttr(AIndex);
end;

{-------------------------------------------------------------------------------}
function TOCIDescribe.GetSB1(AIndex: Integer): sb1;
begin
  Result := FCurr.GetSB1Attr(AIndex);
end;

{-------------------------------------------------------------------------------}
function TOCIDescribe.GetText(AIndex: Integer): String;
begin
  Result := FCurr.GetStringAttr(AIndex);
end;

{-------------------------------------------------------------------------------}
function TOCIDescribe.GetUB1(AIndex: Integer): ub1;
begin
  Result := FCurr.GetUB1Attr(AIndex);
end;

{-------------------------------------------------------------------------------}
function TOCIDescribe.GetUB2(AIndex: Integer): ub2;
begin
  Result := FCurr.GetUB2Attr(AIndex);
end;

{-------------------------------------------------------------------------------}
function TOCIDescribe.GetUB4(AIndex: Integer): ub4;
begin
  Result := FCurr.GetUB4Attr(AIndex);
end;

{-------------------------------------------------------------------------------}
{ TOCIDirectPath                                                                }
{-------------------------------------------------------------------------------}
constructor TOCIDirectPath.Create(ASvc: TOCIService);
begin
  inherited Create;
  FOwner := ASvc;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(ASvc.FOwner, OCI_HTYPE_DIRPATH_CTX);
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPath.AbortJob;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathAbort, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDirPathAbort(Handle, Error.Handle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPath.Finish;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathFinish, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDirPathFinish(Handle, Error.Handle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPath.Prepare;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathPrepare, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDirPathPrepare(Handle, FOwner.Handle, Error.Handle));
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPath.LoadStream(AStream: TOCIDirectPathStream);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathLoadStream, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDirPathLoadStream(Handle, AStream.Handle, Error.Handle));
end;

{-------------------------------------------------------------------------------}
function TOCIDirectPath.GetColumns(AIndex: Integer): TOCIDirectPathColumnParam;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIParamGet, []);
  end;
{$ENDIF}
begin
  Result := TOCIDirectPathColumnParam.Create(Self);
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIParamGet(LIST_COLUMNS, OCI_DTYPE_PARAM, Error.FHandle,
    Result.FHandle, AIndex));
end;

{-------------------------------------------------------------------------------}
constructor TOCIDirectPathColArray.Create(ADP: TOCIDirectPath);
begin
  inherited Create;
  FOwner := ADP;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(ADP, OCI_HTYPE_DIRPATH_COLUMN_ARRAY);
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPathColArray.EntryGet(ARowNum: ub4; AColIndex: ub2; var AData: pUb1;
  var ALen: ub4; var AFlag: ub1);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathColArrayEntryGet, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDirPathColArrayEntryGet(Handle, Error.Handle, ARowNum,
    AColIndex, AData, ALen, AFlag));
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPathColArray.EntrySet(ARowNum: ub4; AColIndex: ub2; AData: pUb1;
  ALen: ub4; AFlag: ub1);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathColArrayEntrySet, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDirPathColArrayEntrySet(Handle, Error.Handle, ARowNum,
    AColIndex, AData, ALen, AFlag));
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPathColArray.RowGet(ARowNum: ub4; var ADataArr: ppUb1;
  var ALenArr: pUb4; var AFlagArr: pUb1);
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathColArrayRowGet, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDirPathColArrayRowGet(Handle, Error.Handle, ARowNum,
    ADataArr, ALenArr, AFlagArr));
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPathColArray.Reset;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathColArrayReset, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDirPathColArrayReset(Handle, Error.Handle));
end;

{-------------------------------------------------------------------------------}
function TOCIDirectPathColArray.ToStream(AStream: TOCIDirectPathStream;
  ARowCount, ARowIndex: ub4): sword;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathColArrayToStream, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Result := Lib.OCIDirPathColArrayToStream(Handle, FOwner.Handle,
    AStream.Handle, Error.Handle, ARowCount, ARowIndex);
  if not ((Result = OCI_SUCCESS) or (Result = OCI_CONTINUE) or (Result = OCI_NEED_DATA)) then
    Check(Result);
end;

{-------------------------------------------------------------------------------}
constructor TOCIDirectPathStream.Create(ADP: TOCIDirectPath);
begin
  inherited Create;
  FOwner := ADP;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  Init(ADP, OCI_HTYPE_DIRPATH_STREAM);
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPathStream.Reset;
{$IFDEF AnyDAC_MONITOR}
  procedure ProcTrace;
  begin
    Trace(sOCIDirPathStreamReset, []);
  end;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if Tracing then ProcTrace;
{$ENDIF}
  Check(Lib.OCIDirPathStreamReset(Handle, Error.Handle));
end;

{-------------------------------------------------------------------------------}
constructor TOCIDirectPathColumnParam.Create(ADP: TOCIDirectPath);
begin
  inherited Create;
  FOwner := ADP;
{$IFDEF AnyDAC_MONITOR}
  UpdateTracing;
{$ENDIF}
  FType := OCI_DTYPE_PARAM;
end;

{-------------------------------------------------------------------------------}
function TOCIDirectPathColumnParam.GetDataType: TOCIDirecPathDataType;
begin
  case DATA_TYPE of
  SQLT_CHR: Result := dpString;
  SQLT_DAT: Result := dpDateTime;
  SQLT_INT: Result := dpInteger;
  SQLT_UIN: Result := dpUInteger;
  SQLT_FLT: Result := dpFloat;
  SQLT_BIN: Result := dpRaw;
  else Result := dpUnknown;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIDirectPathColumnParam.SetDataType(AValue: TOCIDirecPathDataType);
begin
  DATA_TYPE := nc2ociDPDataType[AValue];
  DATA_SIZE := nc2ociDPValueSize[AValue];
  if AValue in [dpString, dpDateTime, dpRaw, dpUnknown] then begin
    PRECISION := 0;
    SCALE := 0;
  end
  else if AValue in [dpInteger, dpUInteger] then
    SCALE := 0;
end;

{-------------------------------------------------------------------------------}
{ TOCIPLSQLDescriber                                                            }
{-------------------------------------------------------------------------------}
function NormOraName(const AName: String): String;
var
  i: Integer;
begin
  Result := AName;
  for i := 1 to Length(AName) do
    if (i = 1) and not (AName[1] in ['a' .. 'z', 'A' .. 'Z']) or
       (i > 1) and not (AName[i] in ['a' .. 'z', 'A' .. 'Z',
                                     '0' .. '9', '#', '$', '_']) then begin
      Result := '"' + AName + '"';
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function UCOraName(const AName: String): String;
begin
  Result := TrimLeft(TrimRight(AName));
  if Result <> '' then
    if (Result[1] = '"') and (Result[Length(Result)] = '"') then
      Result := Copy(Result, 2, Length(Result) - 2)
    else
      Result := AnsiUpperCase(Result);
end;

{-------------------------------------------------------------------------------}
constructor TOCIPLSQLDescriber.CreateForProc(ASrvc: TOCIService;
  AOPackageName, AOProcedureName: String; AOverload: Integer;
  AOwningObj: TObject);
begin
  inherited Create;
  FSrvc := ASrvc;
  FOwningObj := AOwningObj;
  FOPackageName := AOPackageName;
  FOProcedureName := AOProcedureName;
  FOverload := AOverload;
  FForProc := True;
end;

{-------------------------------------------------------------------------------}
constructor TOCIPLSQLDescriber.CreateForPack(ASrvc: TOCIService;
  AOPackageName: String; AOwningObj: TObject);
begin
  inherited Create;
  FSrvc := ASrvc;
  FOwningObj := AOwningObj;
  FOPackageName := AOPackageName;
  FOProcedureName := '';
  FOverload := 0;
  FForProc := False;
end;

{-------------------------------------------------------------------------------}
destructor TOCIPLSQLDescriber.Destroy;
begin
  CleanUp;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TOCIPLSQLDescriber.Describe;
begin
  // build obj name
  FSPName := FOPackageName;
  if FOProcedureName <> '' then begin
    if FSPName <> '' then
      FSPName := FSPName + '.';
    FSPName := FSPName + FOProcedureName;
  end;
  if FSPName = '' then
    ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraPLSQLObjNameEmpty, []);

  // Describe object and verify object type
  FDescr := TOCIDescribe.Create(FSrvc);
  if FOPackageName <> '' then
    FDescr.DescribeName(FOPackageName)
  else
    FDescr.DescribeName(FOProcedureName);
  FObjType := FDescr.UB1[OCI_ATTR_PTYPE];

  if not (FObjType in [OCI_PTYPE_PKG, OCI_PTYPE_FUNC, OCI_PTYPE_PROC]) or
     (FObjType = OCI_PTYPE_PKG) and (FOProcedureName = '') or
     (FObjType = OCI_PTYPE_PKG) and (FOPackageName = '') then begin
    if FObjType = OCI_PTYPE_SYN then begin
      if FOPackageName <> '' then begin
        FOPackageName := NormOraName(FDescr.TEXT[OCI_ATTR_SCHEMA_NAME]) + '.' +
          NormOraName(FDescr.TEXT[OCI_ATTR_NAME]);
        CleanUp;
        Describe;
      end
      else begin
        FOPackageName := '';
        FOProcedureName := NormOraName(FDescr.TEXT[OCI_ATTR_SCHEMA_NAME]) + '.' +
          NormOraName(FDescr.TEXT[OCI_ATTR_NAME]);
        CleanUp;
        Describe;
      end;
    end
    else if FForProc then
      ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraNotPLSQLObj, [FSPName]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIPLSQLDescriber.LocateProc;
begin
  // If object is package then locate procedure in it
  if FObjType = OCI_PTYPE_PKG then begin
    FNumProcs := FDescr.OpenList(OCI_ATTR_LIST_SUBPROGRAMS);
    FProcIndex := 0;
    while FProcIndex < FNumProcs do begin
      FDescr.GoToItem(FProcIndex);
      if (FDescr.Text[OCI_ATTR_NAME] = UCOraName(FOProcedureName)) and
         (FDescr.UB2[OCI_ATTR_OVERLOAD_ID] = FOverload) then
        Break;
      Inc(FProcIndex);
    end;
    if FProcIndex = FNumProcs then
      ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraNotPackageProc,
        [FOProcedureName, FOPackageName]);
    FObjType := FDescr.UB1[OCI_ATTR_PTYPE];
  end
  else begin
    FNumProcs := 1;
    FProcIndex := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIPLSQLDescriber.First(var AProcName: String; var AOverload: Integer);
begin
  if FObjType = OCI_PTYPE_PKG then begin
    FNumProcs := FDescr.OpenList(OCI_ATTR_LIST_SUBPROGRAMS);
    FProcIndex := 0;
    if FProcIndex < FNumProcs then begin
      FDescr.GoToItem(FProcIndex);
      FObjType := FDescr.UB1[OCI_ATTR_PTYPE];
      AProcName := FDescr.Text[OCI_ATTR_NAME];
      AOverload := FDescr.UB2[OCI_ATTR_OVERLOAD_ID];
      if not FForProc then
        FSPName := FOPackageName + '.' + NormOraName(AProcName);
    end;
  end
  else begin
    FNumProcs := 1;
    FProcIndex := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TOCIPLSQLDescriber.EOL: Boolean;
begin
  Result := FProcIndex >= FNumProcs;
end;

{-------------------------------------------------------------------------------}
procedure TOCIPLSQLDescriber.Next(var AProcName: String; var AOverload: Integer);
begin
  if FProcIndex < FNumProcs then begin
    Inc(FProcIndex);
    if FProcIndex < FNumProcs then begin
      FDescr.GoToItem(FProcIndex);
      FObjType := FDescr.UB1[OCI_ATTR_PTYPE];
      AProcName := FDescr.Text[OCI_ATTR_NAME];
      AOverload := FDescr.UB2[OCI_ATTR_OVERLOAD_ID];
      if not FForProc then
        FSPName := FOPackageName + '.' + NormOraName(AProcName);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TOCIPLSQLDescriber.BuildSQL(AOnDefPar: TOCIOnDefineParam): String;
const
  CRLF: String = #10;
var
  sBody, sDecl, sIn, sOut: String;
  i, j: Integer;
  numArgs: ub4;
  item: TOCISelectItem;

  function CreateParam(const APrefix, AVar: String; AItem: TOCISelectItem;
    AIsResult, AExclFromBody, AIsTable: Boolean): Boolean;
  var
    nm: String;
    vt: TOCIVarType;
    dt: TOCIVarDataType;
    sz, prc, scl: sb4;
    i, k: Integer;
    varTp: TOCIVarType;
    typeNm, varNm, memberName: String;
    rawTp: ub4;

    function TmpName(const APrefix: String): String;
    begin
      Result := APrefix + 'v' + IntToStr(j);
      Inc(j);
    end;

    function GetItemName(AItem: TOCISelectItem): String;
    begin
      Result := AItem.NAME;
      if (Result = '') and AIsResult and not AIsTable then
        Result := SDefParRESULT;
      Result := APrefix + Result;
    end;

    procedure BodyVar(const AName: String);
    begin
      if not AExclFromBody then
        if AIsResult then
          sBody := AName + ' := ' + sBody
        else
          sBody := sBody + AName;
    end;

    procedure AddParam;
    begin
      AOnDefPar(nm, vt, dt, sz, prc, scl, AIsTable, AIsResult);
{ ???     with TOciParam(AParams.Add) do begin
        OName := ':' + nm;
        OParamType := vt;
        ODataType := dt;
        if sz <> 0 then
          ODataSize := sz;
        IsPLSQLTable := AIsTable;
      end;
}
    end;

    procedure CheckTypeSupported(ADataType: ub4);
    begin
      if AIsTable and (ADataType in [_SQLT_REC, _SQLT_BOL]) then
        ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraBadTableType, []);
    end;

    function OBool2ValuePLSQL(const ALeft, ARight: String): String;
    begin
      Result := 'IF ' + ARight + ' IS NULL THEN ' + ALeft + ' := NULL; ' +
                'ELSIF ' + ARight + ' THEN ' + ALeft + ' := ' + BoolTrue + '; ' +
                'ELSE ' + ALeft + ' := ' + BoolFalse + '; END IF;';
    end;

    function Value2OBoolPLSQL(const ALeft, ARight: String): String;
    begin
      Result := 'IF ' + ARight + ' IS NULL THEN ' + ALeft + ' := NULL; ' +
                'ELSE ' + ALeft + ' := (' + ARight + ' = ' + BoolTrue + '); END IF;';
    end;

  begin
// ???    FDataFormat.TuneSelItem(AItem);
    nm := GetItemName(AItem);
    vt := AItem.VarType;
    dt := AItem.DataType;
    sz := AItem.DataSize;
    prc := AItem.DataPrecision;
    scl := AItem.DataScale;

    Result := True;
    rawTp := AItem.DATA_TYPE;
    CheckTypeSupported(rawTp);
    case rawTp of
    _SQLT_REC:
      begin
        nm := TmpName(APrefix);
        BodyVar(nm);
        typeNm := AItem.TYPE_NAME + '.' + AItem.SUB_NAME;
        if typeNm = '.' then
          ADException(OwningObj, [S_AD_LPhys, S_AD_OraId], er_AD_OraUnNamedRecParam, []);
        sDecl := sDecl + nm + ' ' + typeNm + ';' + CRLF;
        varTp := AItem.VarType;
        varNm := GetItemName(AItem);
        k := FDescr.OpenList(OCI_ATTR_LIST_ARGUMENTS);
        try
          for i := 1 to k do begin
            AItem := FDescr.SelectItem[i];
            if AItem = nil then
              Break;
            memberName := nm + '.' + AItem.name;
            try
              if CreateParam(varNm + SDefParMembDelim, memberName, AItem, AIsResult, True, False) then begin
                if varTp in [odIn, odInOut] then
                  sIn := sIn + memberName + ' := :' + varNm + SDefParMembDelim + AItem.name + ';' + CRLF;
                if varTp in [odOut, odInOut] then
                  sOut := sOut + ':' + varNm + SDefParMembDelim + AItem.name + ' := ' + memberName + ';' + CRLF;
              end;
            finally
              AItem.Free;
            end;
          end;
        finally
          FDescr.CloseList;
        end;
        Result := False;
      end;
    _SQLT_TAB:
      begin
        FDescr.OpenList(OCI_ATTR_LIST_ARGUMENTS);
        try
          AItem := FDescr.SelectItem[1];
          try
            Result := CreateParam(nm, AVar, AItem, AIsResult, AExclFromBody, True);
          finally
            AItem.Free;
          end;
        finally
          FDescr.CloseList;
        end;
      end;
    _SQLT_BOL:
      begin
        if AVar = '' then begin
          varNm := TmpName(APrefix);
          sDecl := sDecl + varNm + ' BOOLEAN;' + CRLF;
        end
        else
          varNm := AVar;
        if AItem.VarType in [odIn, odInOut] then
          sIn := sIn + Value2OBoolPLSQL(varNm, ':' + nm) + CRLF;
        if AItem.VarType in [odOut, odInOut] then
          sOut := sOut + OBool2ValuePLSQL(':' + nm, varNm) + CRLF;
        dt := BoolType;
        sz := BoolSize;
        BodyVar(varNm);
        AddParam;
        Result := False;
      end;
    else
      BodyVar(':' + nm);
      AddParam;
    end;
  end;

  procedure AppendLine(const AStr: String);
  begin
    if Result <> '' then
      Result := Result + CRLF + AStr
    else
      Result := AStr;
  end;

begin
  // Now start form a SQL and Params
  sDecl := '';
  sIn := '';
  sOut := '';
  sBody := '';
  j := 0;
  numArgs := FDescr.OpenList(OCI_ATTR_LIST_ARGUMENTS);
  try
    // If this is function then form :Result parameter
    if FObjType = OCI_PTYPE_FUNC then begin
      item := FDescr.SelectItem[0];
      try
        CreateParam('', '', item, True, False, False);
      finally
        item.Free;
      end;
      Dec(numArgs);
    end;
    // Now for each parameter do ...
    sBody := sBody + FSPName;
    if numArgs > 0 then
      sBody := sBody + '(';
    for i := 1 to numArgs do begin
      if i > 1 then
        sBody := sBody + ', ';
      item := FDescr.SelectItem[i];
      if item = nil then
        Break;
      try
        CreateParam('', '', item, False, False, False);
      finally
        item.Free;
      end;
    end;
    if numArgs > 0 then
      sBody := sBody + ')';
    // Time to form anonymous PL/SQL block
    if sDecl <> '' then begin
      AppendLine('DECLARE');
      AppendLine(sDecl);
    end;
    AppendLine('BEGIN');
    if sIn <> '' then
      AppendLine(sIn);
    AppendLine(sBody + ';');
    if sOut <> '' then
      AppendLine(sOut);
    AppendLine('END;');
  finally
    FDescr.CloseList;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TOCIPLSQLDescriber.CleanUp;
begin
  if FDescr <> nil then begin
    if (FOPackageName <> '') and FDescr.IsListOpened then
      FDescr.CloseList;
    FreeAndNil(FDescr);
  end;
end;

{-------------------------------------------------------------------------------}
initialization

  FGlobalPieceBuffUseCnt := 0;

end.

