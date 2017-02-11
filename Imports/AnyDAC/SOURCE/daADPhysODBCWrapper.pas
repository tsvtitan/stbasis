{-------------------------------------------------------------------------------}
{ AnyDAC ODBC wrapper classes                                                   }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysODBCWrapper;

interface

uses
  Classes, Windows,
  daADStanIntf,
  daADStanError,
  daADPhysODBCCli;

type
  EODBCNativeException = class;
  TODBCLib = class;
  TODBCHandle = class;
  TODBCEnvironment = class;
  TODBCConnection = class;
  TODBCTransaction = class;
  TODBCSelectItem = class;
  TODBCVariable = class;
  TODBCVariableList = class;
  TODBCPageBuffer = class;
  TODBCPageBufferClass = class of TODBCPageBuffer;
  TODBCPieceList = class;
  TODBCStatementBase = class;
  TODBCCommandStatement = class;
  TODBCMetaInfoStatement = class;

  TODBCBindingKind = (bkColumnWise, bkRowWise);
  TODBCParseErrorEvent = procedure (AHandle: TODBCHandle; ARecNum: SQLSmallint;
    const ASQLState: String; ANativeError: SQLInteger; const ADiagMessage: String;
    const ACommandText: String; var AObj: String; var AKind: TADCommandExceptionKind;
    var ACmdOffset: Integer) of object;
  TODBCGetMaxSizesEvent = procedure (AStrDataType: SQLSmallint; AFixedLen,
    ANumeric: Boolean; out ACharSize: Integer; out AByteSize: Integer) of object;

  EODBCNativeException = class(EADDBEngineException)
  public
    constructor Create(AStatus: SQLReturn; AOwner: TODBCHandle); overload;
  end;

{$IFDEF AnyDAC_MONITOR}
  TODBCTracer = class(TThread)
  private
    FMonitor: IADMoniClient;
    FLib: TODBCLib;
  protected
    procedure Execute; override;
  public
    constructor Create(const AMonitor: IADMoniClient; ALib: TODBCLib);
  end;
{$ENDIF}

  TODBCLib = class(TObject)
  private
    FOwningObj: TObject;
    FODBCDllName: string;
    FODBCHDll: THandle;
{$IFDEF AnyDAC_MONITOR}
    FTracer: TODBCTracer;
    FTracing: Boolean;
{$ENDIF}
    function GetODBCProcAddress(const AProcName: String): Pointer;
    function GetTRACE: Boolean;
    function GetTRACEFILE: string;
    procedure LoadODBCEntries;
    procedure LoadODBCLibrary;
    procedure SetTRACE(AValue: Boolean);
    procedure SetTRACEFILE(const AValue: string);
  public
    SQLAllocHandle: TSQLAllocHandle;
    SQLBindCol: TSQLBindCol;
    SQLBindParameter: TSQLBindParameter;
    SQLCancel: TSQLCancel;
    SQLColAttribute: TSQLColAttribute;
    SQLColAttributeInt: TSQLColAttributeInt;
    SQLColAttributeString: TSQLColAttributeString;
    SQLColumns: TSQLColumns;
    SQLConnect: TSQLConnect;
    SQLDataSources: TSQLDataSources;
    SQLDescribeCol: TSQLDescribeCol;
    SQLDescribeParam: TSQLDescribeParam;
    SQLDisconnect: TSQLDisconnect;
    SQLDriverConnect: TSQLDriverConnect;
    SQLDrivers: TSQLDrivers;
    SQLEndTran: TSQLEndTran;
    SQLExecDirect: TSQLExecDirect;
    SQLExecute: TSQLExecute;
    SQLFetch: TSQLFetch;
    SQLForeignKeys: TSQLForeignKeys;
    SQLFreeHandle: TSQLFreeHandle;
    SQLFreeStmt: TSQLFreeStmt;
    SQLGetConnectAttr: TSQLGetConnectAttr;
    SQLGetCursorName: TSQLGetCursorName;
    SQLGetData: TSQLGetData;
    SQLGetDescField: TSQLGetDescField;
    SQLGetDescRec: TSQLGetDescRec;
    SQLGetDiagRec: TSQLGetDiagRec;
    SQLGetEnvAttr: TSQLGetEnvAttr;
    SQLGetFunctions: TSQLGetFunctions;
    SQLGetInfo: TSQLGetInfo;
    SQLGetInfoInt: TSQLGetInfoInt;
    SQLGetInfoSmallint: TSQLGetInfoSmallint;
    SQLGetInfoString: TSQLGetInfoString;
    SQLGetStmtAttr: TSQLGetStmtAttr;
    SQLGetTypeInfo: TSQLGetTypeInfo;
    SQLMoreResults: TSQLMoreResults;
    SQLNumParams: TSQLNumParams;
    SQLNumResultCols: TSQLNumResultCols;
    SQLParamData: TSQLParamData;
    SQLPrepare: TSQLPrepare;
    SQLPrimaryKeys: TSQLPrimaryKeys;
    SQLProcedureColumns: TSQLProcedureColumns;
    SQLProcedures: TSQLProcedures;
    SQLPutData: TSQLPutData;
    SQLRowCount: TSQLRowCount;
    SQLSetConnectAttr: TSQLSetConnectAttr;
    SQLSetCursorName: TSQLSetCursorName;
    SQLSetDescField: TSQLSetDescField;
    SQLSetDescRec: TSQLSetDescRec;
    SQLSetEnvAttr: TSQLSetEnvAttr;
    SQLSetPos: TSQLSetPos;
    SQLSetStmtAttr: TSQLSetStmtAttr;
    SQLSpecialColumns: TSQLSpecialColumns;
    SQLStatistics: TSQLStatistics;
    SQLTablePrivileges: TSQLTablePrivileges;
    SQLTables: TSQLTables;
    constructor Create(const AHome, ALib: String; AOwningObj: TObject = nil);
    destructor Destroy; override;
    class function Allocate(const AHome, ALib: String; AOwningObj: TObject = nil): TODBCLib;
    class procedure Release(ALib: TODBCLib);
    class function DecorateKeyValue(const AValue: String): String;
    // Properties
    property OwningObj: TObject read FOwningObj;
{$IFDEF AnyDAC_MONITOR}
    property Tracing: Boolean read FTracing;
    procedure ActivateTracing(const AMonitor: IADMoniClient);
{$ENDIF}
    // ODBC
    property TRACE: Boolean read GetTRACE write SetTRACE;
    property TRACEFILE: string read GetTRACEFILE write SetTRACEFILE;
  end;

  TODBCHandle = class(TObject)
  private
    FHandle: SQLHandle;
    FHandleType: SQLSmallint;
    FODBCLib: TODBCLib;
    FOwner: TODBCHandle;
    FOwningObj: TObject;
    function GetConnection: TODBCConnection;
{$IFDEF AnyDAC_MONITOR}
    function GetTracing: Boolean;
{$ENDIF}
  protected
    function GetCharAttribute(AAttr: SQLInteger): string;
    function GetIntAttribute(AAttr: SQLInteger): SQLInteger;
    procedure GetNonStrAttribute(AAttr: SQLInteger; ApValue: SQLPointer); virtual;
    function GetPSQLPAttribute(AAttr: SQLInteger): SQLPointer;
    function GetPUIntAttribute(AAttr: SQLInteger): PSQLUInteger;
    function GetPUSmIntAttribute(AAttr: SQLInteger): PSQLUSmallint;
    procedure GetStrAttribute(AAttr: SQLInteger; out AValue: String); virtual;
    function GetUIntAttribute(AAttr: SQLInteger): SQLUInteger;
    function GetUSmIntAttribute(AAttr: SQLInteger): SQLUSmallint;
    procedure SetAttribute(AAttr: SQLInteger; ApValue: SQLPointer; ACharData: Boolean); virtual;
    procedure SetCharAttribute(AAttr: SQLInteger; AValue: String);
    procedure SetIntAttribute(AAttr: SQLInteger; AValue: SQLInteger);
    procedure SetPUIntAttribute(AAttr: SQLInteger; AValue: PSQLUInteger);
    procedure SetPUSmIntAttribute(AAttr: SQLInteger; AValue: PSQLUSmallint);
    procedure SetUIntAttribute(AAttr: SQLInteger; AValue: SQLUInteger);
    procedure SetUSmIntAttribute(AAttr: SQLInteger; AValue: SQLUSmallint);
    procedure AllocHandle; virtual;
    procedure FreeHandle;
{$IFDEF AnyDAC_MONITOR}
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; AArgs: array of const);
    property Tracing: Boolean read GetTracing;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Check(AStatus: SQLReturn);
    property Handle: SQLHandle read FHandle;
    property HandleType: SQLSmallint read FHandleType;
    property Lib: TODBCLib read FODBCLib;
    property Connection: TODBCConnection read GetConnection;
    property Owner: TODBCHandle read FOwner;
    property OwningObj: TObject read FOwningObj;
  end;

  TODBCEnvironment = class(TODBCHandle)
  private
    function DoDrivers(ADirection: SQLUSmallint; out ADriverDesc: String;
      out ADriverAttr: String): Boolean;
    function DoDSNs(ADirection: SQLUSmallint; out AServerName: String;
      out ADescription: String): Boolean;
  protected
    procedure GetNonStrAttribute(AAttr: SQLInteger; ApValue: SQLPointer); override;
    procedure GetStrAttribute(AAttr: SQLInteger; out AValue: String); override;
    procedure SetAttribute(AAttr: SQLInteger; ApValue: SQLPointer;
      ACharData: Boolean = False); override;
    procedure AllocHandle; override;
  public
    constructor Create(ALib: TODBCLib; AOwningObj: TObject = nil);
    function DriverFirst(out ADriverDesc: String; out ADriverAttr: String): Boolean;
    function DriverNext(out ADriverDesc: String; out ADriverAttr: String): Boolean;
    function DSNFirst(out AServerName: String; out ADescription: String): Boolean;
    function DSNNext(out AServerName: String; out ADescription: String): Boolean;
    // Properties
    // ODBC
    property CONNECTION_POOLING: SQLUInteger index SQL_ATTR_CONNECTION_POOLING read GetUIntAttribute write SetUIntAttribute;
    property CP_MATCH: SQLUInteger index SQL_ATTR_CP_MATCH read GetUIntAttribute write SetUIntAttribute;
    property ODBC_VERSION: SQLInteger index SQL_ATTR_ODBC_VERSION read GetIntAttribute write SetIntAttribute;
    property OUTPUT_NTS: SQLInteger index SQL_ATTR_OUTPUT_NTS read GetIntAttribute write SetIntAttribute;
  end;

  TODBCTransaction = class(TObject)
  private
    FOwner: TODBCConnection;
    FTransID: LongWord;
    procedure EndTran(AType: SQLSmallint; AAll: Boolean = False);
  public
    constructor Create(AOwner: TODBCConnection);
    procedure Commit(AAll: Boolean = False);
    procedure Rollback(AAll: Boolean = False);
    procedure StartTransaction;
    property Owner: TODBCConnection read FOwner;
    property TransID: LongWord read FTransID write FTransID;
  end;

  TODBCConnection = class(TODBCHandle)
  private
    FTransaction: TODBCTransaction;
    FInfo: EODBCNativeException;
    FOnParseError: TODBCParseErrorEvent;
    FOnGetMaxSizes: TODBCGetMaxSizesEvent;
    FRdbmsKind: TADRDBMSKind;
    FConnected: Boolean;
    FDecimalSepPar: Char;
    FDecimalSepCol: Char;
    FLastCommandText: String;
{$IFDEF AnyDAC_MONITOR}
    FTracing: Boolean;
    function GetTracing: Boolean;
{$ENDIF}
    function GetInfoOptionSmInt(AInfoType: Integer): SQLUSmallint;
    function GetInfoOptionUInt(AInfoType: Integer): SQLUInteger;
    function GetInfoOptionStr(AInfoType: Integer): string;
    function GetInfoBase(AInfoType: SQLUSmallint;
      var AInfoValue: String): SQLReturn;
    procedure UpdateRDBMSKind;
  protected
    procedure GetNonStrAttribute(AAttr: SQLInteger; ApValue: SQLPointer); override;
    procedure GetStrAttribute(AAttr: SQLInteger; out AValue: String); override;
    procedure SetAttribute(AAttr: SQLInteger; ApValue: SQLPointer;
      ACharData: Boolean = False); override;
    procedure GetInfo(AInfoType: SQLUSmallint; var AInfoValue: String); overload;
    procedure GetInfo(AInfoType: SQLUSmallint; var AInfoValue: SQLUInteger); overload;
    procedure GetInfo(AInfoType: SQLUSmallint; var AInfoValue: SQLUSmallint); overload;
    procedure ClearInfo;
  public
    constructor Create(AOwner: TODBCEnvironment; AOwningObj: TObject = nil);
    destructor Destroy; override;
    function DriverConnect(const AConnString: String; ADriverCompletion: SQLUSmallint): String;
    function Connect(const AConnString: String; AWithPrompt: Boolean = False): String;
    procedure Disconnect;
    function GetFunctions(AFuncID: SQLUSmallint): SQLUSmallint;
    function EncodeName(const ACat, ASch, AObj: String): String;
    // RW
    property RdbmsKind: TADRDBMSKind read FRdbmsKind write FRdbmsKind;
    property DecimalSepCol: Char read FDecimalSepCol write FDecimalSepCol;
    property DecimalSepPar: Char read FDecimalSepPar write FDecimalSepPar;
{$IFDEF AnyDAC_MONITOR}
    property Tracing: Boolean read GetTracing write FTracing;
{$ENDIF}
    // RO
    property Info: EODBCNativeException read FInfo;
    property Transaction: TODBCTransaction read FTransaction;
    property Connected: Boolean read FConnected;
    property LastCommandText: String read FLastCommandText;
    // ODBC attributes
    property AUTOCOMMIT: SQLUInteger index SQL_ATTR_AUTOCOMMIT read GetUIntAttribute write SetUIntAttribute;
    property CONCURRENCY: SQLInteger index SQL_CONCURRENCY read GetIntAttribute write SetIntAttribute;
    property CURRENT_CATALOG: string index SQL_ATTR_CURRENT_CATALOG read GetCharAttribute write SetCharAttribute;
    property CURSOR_TYPE: SQLInteger index SQL_CURSOR_TYPE read GetIntAttribute write SetIntAttribute;
    property LOGIN_TIMEOUT: SQLUInteger index SQL_ATTR_LOGIN_TIMEOUT read GetUIntAttribute write SetUIntAttribute;
    property LONGDATA_COMPAT: SQLUSmallint index SQL_ATTR_LONGDATA_COMPAT read GetUSmIntAttribute write SetUSmIntAttribute;
    property TXN_ISOLATION: SQLInteger index SQL_ATTR_TXN_ISOLATION read GetIntAttribute write SetIntAttribute;
    // MSSQL
    property SS_PRESERVE_CURSORS: SQLUInteger index SQL_COPT_SS_PRESERVE_CURSORS read GetUIntAttribute write SetUIntAttribute;
    // ODBC info
    property CATALOG_USAGE: SQLUInteger index SQL_CATALOG_USAGE read GetInfoOptionUInt;
    property CATALOG_NAME_SEPARATOR: String index SQL_CATALOG_NAME_SEPARATOR read GetInfoOptionStr;
    property CATALOG_LOCATION: SQLUSmallint index SQL_CATALOG_LOCATION read GetInfoOptionSmInt;
    property CATALOG_TERM: String index SQL_CATALOG_TERM read GetInfoOptionStr;
    property FILE_USAGE: SQLUSmallint index SQL_FILE_USAGE read GetInfoOptionSmInt;
    property GETDATA_EXTENSIONS: SQLUInteger index SQL_GETDATA_EXTENSIONS read GetInfoOptionUInt;
    property IDENTIFIER_CASE: SQLUSmallint index SQL_IDENTIFIER_CASE read GetInfoOptionSmInt;
    property IDENTIFIER_QUOTE_CHAR: string index SQL_IDENTIFIER_QUOTE_CHAR read GetInfoOptionStr;
    property MAX_CATALOG_NAME_LEN: SQLUSmallint index SQL_MAX_CATALOG_NAME_LEN read GetInfoOptionSmInt;
    property MAX_SCHEMA_NAME_LEN: SQLUSmallint index SQL_MAX_SCHEMA_NAME_LEN read GetInfoOptionSmInt;
    property MAX_TABLE_NAME_LEN: SQLUSmallint index SQL_MAX_TABLE_NAME_LEN read GetInfoOptionSmInt;
    property MAX_COLUMN_NAME_LEN: SQLUSmallint index SQL_MAX_COLUMN_NAME_LEN read GetInfoOptionSmInt;
    property MAX_CONCURRENT_ACTIVITIES: SQLUSmallint index SQL_MAX_CONCURRENT_ACTIVITIES read GetInfoOptionSmInt;
    property MAX_IDENTIFIER_LEN: SQLUSmallint index SQL_MAX_IDENTIFIER_LEN read GetInfoOptionSmInt;
    property MAX_ROW_SIZE: SQLUSmallint index SQL_MAX_ROW_SIZE read GetInfoOptionSmInt;
    property MULTIPLE_ACTIVE_TXN: String index SQL_MULTIPLE_ACTIVE_TXN read GetInfoOptionStr;
    property QUOTED_IDENTIFIER_CASE: SQLUSmallint index SQL_QUOTED_IDENTIFIER_CASE read GetInfoOptionSmInt;
    property SCHEMA_USAGE: SQLUInteger index SQL_SCHEMA_USAGE read GetInfoOptionUInt;
    property TXN_CAPABLE: SQLUSmallint index SQL_TXN_CAPABLE read GetInfoOptionSmInt;
    property TXN_ISOLATION_OPTION: SQLUInteger index SQL_TXN_ISOLATION_OPTION read GetInfoOptionUInt;
    property DM_VER: string index SQL_DM_VER read GetInfoOptionStr;
    property DBMS_NAME: string index SQL_DBMS_NAME read GetInfoOptionStr;
    property DBMS_VER: string index SQL_DBMS_VER read GetInfoOptionStr;
    property DRIVER_NAME: string index SQL_DRIVER_NAME read GetInfoOptionStr;
    property DRIVER_VER: string index SQL_DRIVER_VER read GetInfoOptionStr;
    property INTERFACE_CONFORMANCE: SQLUInteger index SQL_ODBC_INTERFACE_CONFORMANCE read GetInfoOptionUInt;
    property PARAM_ARRAY_ROW_COUNTS: SQLUInteger index SQL_PARAM_ARRAY_ROW_COUNTS read GetInfoOptionUInt;
    property PARAM_ARRAY_SELECTS: SQLUInteger index SQL_PARAM_ARRAY_SELECTS read GetInfoOptionUInt;
    // Events
    property OnParseError: TODBCParseErrorEvent read FOnParseError write FOnParseError;
    property OnGetMaxSizes: TODBCGetMaxSizesEvent read FOnGetMaxSizes write FOnGetMaxSizes;
  end;

  TODBCSelectItem = class(TObject)
  private
    FColumnSize: SQLUInteger;
    FName: string;
    FNullable: SQLSmallint;
    FPosition: SQLSmallint;
    FScale: SQLSmallint;
    FSQLDataType: SQLSmallint;
    FStmt: TODBCStatementBase;
    function GetAUTO_UNIQUE_VALUE: SQLInteger;
    function GetFIXED_PREC_SCALE: SQLInteger;
    function GetIsFixedLen: Boolean;
    function GetNULLABLE: SQLSmallint;
    function GetSEARCHABLE: SQLInteger;
    function GetUNSIGNED: SQLInteger;
    function GetUPDATABLE: SQLInteger;
    function GetROWVER: SQLInteger;
  public
    constructor Create(AOwner: TODBCStatementBase; AColNum: SQLSmallint);
    property AUTO_UNIQUE_VALUE: SQLInteger read GetAUTO_UNIQUE_VALUE;
    property ColumnSize: SQLUInteger read FColumnSize;
    property FIXED_PREC_SCALE: SQLInteger read GetFIXED_PREC_SCALE;
    property IsFixedLen: Boolean read GetIsFixedLen;
    property Name: string read FName;
    property NULLABLE: SQLSmallint read GetNULLABLE;
    property Position: SQLSmallint read FPosition;
    property ROWVER: SQLInteger read GetROWVER;
    property Scale: SQLSmallint read FScale;
    property SEARCHABLE: SQLInteger read GetSEARCHABLE;
    property SQLDataType: SQLSmallint read FSQLDataType;
    property UNSIGNED: SQLInteger read GetUNSIGNED;
    property UPDATABLE: SQLInteger read GetUPDATABLE;
  end;

  TODBCVariable = class(TObject)
  private
    FCDataType: SQLSmallint;
    FColumnSize: SQLUInteger;
    FDataSize: SQLUInteger;
    FLocalBuffer: SQLPointer;
    FLocalBufIndicator: PSQLInteger;
    FParamType: SQLSmallint;
    FPosition: SQLSmallint;
    FName: String;
    FScale: SQLSmallint;
    FSQLDataType: SQLSmallint;
    FCVariantSbType: SQLSmallint;
    FList: TODBCVariableList;
    FLongData: Boolean;
    FBinded: Boolean;
    FSizesUpdated: Boolean;
{$IFDEF AnyDAC_MONITOR}
    FDumpLabel: String;
{$ENDIF}
    function GetDumpLabel: String;
    function GetSQLVariant: Boolean;
    function GetIsParameter: Boolean;
    function CalcDataSize(AColumnSize: SQLUInteger): SQLInteger;
    procedure VarTypeUnsup(ACType: SQLSmallint);
    procedure SetCDataType(const AValue: SQLSmallint);
    procedure SetDataSize(const AValue: SQLUInteger);
    procedure SetParamType(const AValue: SQLSmallint);
    procedure SetSQLDataType(const AValue: SQLSmallint);
    procedure UpdateLongData;
    procedure AllocLongData(AIndex, ALSize: SQLUInteger);
    procedure FreeLongData(AIndex: SQLUInteger);
    function GetDecimalSeparator: Char;
    procedure UpdateSizes;
    function GetLongData: Boolean;
    function GetAsString: String;
  protected
    function GetDataPtr(AIndex: SQLUInteger; out ApData: SQLPointer;
      out ASize: SQLInteger; out ApInd: PSQLInteger): PSQLPointer;
    property LocalBuffer: SQLPointer read FLocalBuffer write FLocalBuffer;
    property LocalBufIndicator: PSQLInteger read FLocalBufIndicator
      write FLocalBufIndicator;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Bind;
    function GetData(AIndex: SQLUInteger; var ApData: SQLPointer;
      var ALSize: SQLUInteger; AByRef: Boolean = False): Boolean;
    procedure SetData(AIndex: SQLUInteger; ApData: SQLPointer;
      ALSize: SQLUInteger);
{$IFDEF AnyDAC_MONITOR}
    function DumpValue(AIndex: SQLUInteger; var ASize: SQLUInteger): String;
    function DumpCDataType: String;
    function DumpParamType: String;
{$ENDIF}
    // properties
    // RO
    property Binded: Boolean read FBinded;
    property IsParameter: Boolean read GetIsParameter;
    property LongData: Boolean read GetLongData;
    property SQLVariant: Boolean read GetSQLVariant;
    property DecimalSeparator: Char read GetDecimalSeparator;
    property AsString: String read GetAsString;
    // RW
    property SQLDataType: SQLSmallint read FSQLDataType write SetSQLDataType;
    property CDataType: SQLSmallint read FCDataType write SetCDataType;
    property DataSize: SQLUInteger read FDataSize write SetDataSize;
    property ColumnSize: SQLUInteger read FColumnSize write FColumnSize;
    property Scale: SQLSmallint read FScale write FScale;
    property CVariantSbType: SQLSmallint read FCVariantSbType write FCVariantSbType;
    property ParamType: SQLSmallint read FParamType write SetParamType;
    property Position: SQLSmallint read FPosition write FPosition;
    property Name: String read FName write FName;
{$IFDEF AnyDAC_MONITOR}
    property DumpLabel: String read GetDumpLabel write FDumpLabel;
{$ENDIF}
  end;

  TODBCVariableList = class(TObject)
  private
    FList: TList;
    FOwner: TODBCStatementBase;
    FParameters: Boolean;
    FBuffer: TODBCPageBuffer;
    FHasLongs: Boolean;
    function GetCount: Integer;
    function GetItems(AIndex: Integer): TODBCVariable;
    procedure Rebind(AFixedLenOnly: Boolean = False);
  public
    constructor Create(AOwner: TODBCStatementBase);
    destructor Destroy; override;
    function Add(AVariable: TODBCVariable): TODBCVariable;
    procedure Bind(APageBufferClass: TODBCPageBufferClass; ARowCount: SQLUInteger;
      AFixedLenOnly: Boolean);
    procedure Clear;
    function HasLongVariables: Boolean;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TODBCVariable read GetItems; default;
    property Owner: TODBCStatementBase read FOwner;
    property Parameters: Boolean read FParameters write FParameters;
    property HasLongs: Boolean read FHasLongs;
  end;

  TODBCPageBuffer = class(TObject)
  private
    FIsAllocated: Boolean;
    FRowCount: SQLUInteger;
    FRowsProcessed: SQLUInteger;
    FRowStatusArr: array of SQLUSmallint;
    FVariableList: TODBCVariableList;
    function GetPageSize: SQLUInteger;
    function GetRowSize: SQLUInteger;
    function GetRowStatusArr(AIndex: SQLUInteger): SQLUSmallint;
  protected
    procedure SetStmtAttributes; virtual;
    procedure AllocBuffers; virtual;
    procedure FreeBuffers; virtual;
    procedure GetDataPtr(AVar: TODBCVariable; AIndex: SQLUInteger;
      out ApData: SQLPointer; out ApIndicator: PSQLInteger); virtual;
    procedure ShiftBuffersPtr(ARowCount: SQLUInteger); virtual;
  public
    constructor Create(AVarList: TODBCVariableList);
    destructor Destroy; override;
    property PageSize: SQLUInteger read GetPageSize;
    property RowCount: SQLUInteger read FRowCount;
    property RowSize: SQLUInteger read GetRowSize;
    property RowsProcessed: SQLUInteger read FRowsProcessed;
    property RowStatusArr[AIndex: SQLUInteger]: SQLUSmallint read GetRowStatusArr;
  end;

  TODBCRowWiseBuffer = class(TODBCPageBuffer)
  private
    FCommonBuffer: Pointer;
  protected
    procedure SetStmtAttributes; override;
    procedure AllocBuffers; override;
    procedure FreeBuffers; override;
    procedure GetDataPtr(AVar: TODBCVariable; AIndex: SQLUInteger;
      out ApData: SQLPointer; out ApIndicator: PSQLInteger); override;
    procedure ShiftBuffersPtr(ARowCount: SQLUInteger); override;
  end;

  TODBCColWiseBuffer = class(TODBCPageBuffer)
  protected
    procedure SetStmtAttributes; override;
    procedure AllocBuffers; override;
    procedure FreeBuffers; override;
    procedure GetDataPtr(AVar: TODBCVariable; AIndex: SQLUInteger;
      out ApData: SQLPointer; out ApIndicator: PSQLInteger); override;
    procedure ShiftBuffersPtr(ARowCount: SQLUInteger); override;
  end;

  TODBCPieceList = class(TObject)
  private
    FBuffer: SQLPointer;
    FCDataType: SQLSmallint;
    function GetPiece(AIndex: Integer): SQLPointer;
    function CheckBuffer: Pointer;
  protected
    procedure GetJoinedBufferPtr(var ApBuffer: SQLPointer;
      var ASize: LongInt; APieceCount: Integer; ASizeOfLastPiece: LongInt);
    function GetPieceSize: LongInt;
    property Piece[Index: Integer]: Pointer read GetPiece; default;
  public
    destructor Destroy; override;
  end;

  TODBCStatementBase = class(TODBCHandle)
  private
    FColumnList: TODBCVariableList;
    FPieceList: TODBCPieceList;
    FVarBindingKind: TODBCBindingKind;
    FInrecDataSize: SQLUInteger;
    FStrsTrim: Boolean;
    FStrsEmpty2Null: Boolean;
    FStrsMaxSize: SQLUInteger;
    FIsExecuted: Boolean;
    procedure BindCol(ABoundVariable: TODBCVariable); overload;
    function FetchLongColumn(AVariable: TODBCVariable; AIndex: Integer;
      ASize: SQLInteger): SQLReturn;
    procedure SetPos(ARowNum: SQLUSmallint; AOperation: SQLUSmallint;
      ALocktype: SQLUSmallint);
    procedure FetchLongColumns(AIndex: SQLUSmallint);
    function GetCursorName: String;
    procedure SetCursorName(const AValue: String);
{$IFDEF AnyDAC_MONITOR}
    procedure DumpColumns(ARows: SQLUInteger; AEof: Boolean);
{$ENDIF}
  protected
    procedure ColAttributeInt(AColNum: SQLUSmallint; AFieldId: SQLUSmallint;
      var AAttr: SQLInteger);
    procedure ColAttributeString(AColNum: SQLUSmallint; AFieldId: SQLUSmallint;
      var AAttr: String);
    procedure GetNonStrAttribute(AAttr: SQLInteger; ApValue: SQLPointer); override;
    procedure GetStrAttribute(AAttr: SQLInteger; out AValue: String); override;
    procedure SetAttribute(AAttr: SQLInteger; ApValue: SQLPointer;
      ACharData: Boolean = False); override;
    function GetPageBufferClass: TODBCPageBufferClass;
  public
    constructor Create(AOwner: TODBCConnection; AOwningObj: TObject = nil);
    destructor Destroy; override;
    function NumResultCols: SQLSmallint;
    function ResultColsExists: Boolean;
    procedure DescribeCol(AColNum: SQLSmallint; var AName: String;
      var ADataType: SQLSmallint; var AColSize: SQLUInteger;
      var AScale: SQLSmallint; var ANullable: SQLSmallint); overload;
    procedure BindColumns(ARowCount: SQLUInteger);
    procedure UnbindColumns;
    function AddCol(APos, ASQLType, ACType: SQLSmallint; ALen: SQLUInteger = -1): TODBCVariable;
    function Fetch(ARowCount: SQLUInteger = SQL_NULL_DATA): SQLUSmallint;
    function MoreResults: Boolean;
    procedure SkipEmptyResults;
    procedure Cancel;
    procedure Close;
    procedure Unprepare; virtual;
    // properties
    property ColumnList: TODBCVariableList read FColumnList;
    property IsExecuted: Boolean read FIsExecuted;
    // AnyDAC
    property InrecDataSize: SQLUInteger read FInrecDataSize write FInrecDataSize;
    property StrsTrim: Boolean read FStrsTrim write FStrsTrim;
    property StrsEmpty2Null: Boolean read FStrsEmpty2Null write FStrsEmpty2Null;
    property StrsMaxSize: SQLUInteger read FStrsMaxSize write FStrsMaxSize;
    property VarBindingKind: TODBCBindingKind read FVarBindingKind write FVarBindingKind;
    // ODBC
    property CURSOR_TYPE: SQLUInteger index SQL_ATTR_CURSOR_TYPE read GetUIntAttribute write SetUIntAttribute;
    property CURSOR_NAME: String read GetCursorName write SetCursorName;
    property CONCURRENCY: SQLUInteger index SQL_ATTR_CONCURRENCY read GetUIntAttribute write SetUIntAttribute;
    property IMP_PARAM_DESC: SQLPointer index SQL_ATTR_IMP_PARAM_DESC read GetPSQLPAttribute;
    property MAX_ROWS: SQLUInteger index SQL_ATTR_MAX_ROWS read GetUIntAttribute write SetUIntAttribute;
    property NOSCAN: SQLUInteger index SQL_ATTR_NOSCAN read GetUIntAttribute write SetUIntAttribute;
    property ROWS_FETCHED_PTR: PSQLUInteger index SQL_ATTR_ROWS_FETCHED_PTR read GetPUIntAttribute write SetPUIntAttribute;
    property ROW_ARRAY_SIZE: SQLUInteger index SQL_ATTR_ROW_ARRAY_SIZE read GetUIntAttribute write SetUIntAttribute;
    property ROW_BIND_TYPE: SQLUInteger index SQL_ATTR_ROW_BIND_TYPE read GetUIntAttribute write SetUIntAttribute;
    property ROW_STATUS_PTR: PSQLUSmallint index SQL_ATTR_ROW_STATUS_PTR read GetPUSmIntAttribute write SetPUSmIntAttribute;
    // MSSQL
    property SS_NOCOUNT_STATUS: SQLUInteger index SQL_SOPT_SS_NOCOUNT_STATUS read GetUIntAttribute write SetUIntAttribute;
    property SS_CURSOR_OPTIONS: SQLUInteger index SQL_SOPT_SS_CURSOR_OPTIONS read GetUIntAttribute write SetUIntAttribute;
  end;

  TODBCCommandStatement = class(TODBCStatementBase)
  private
    FParamList: TODBCVariableList;
    FParamSetSupported: Boolean;
    procedure BindParameter(AParam: TODBCVariable);
    procedure DoPutLongData(AIndex: Integer = 0);
    function ParamData(var ApValuePtr: SQLPointer): SQLReturn;
    procedure PutData(ADataPtr: SQLPointer; ASize: SQLInteger);
{$IFDEF AnyDAC_MONITOR}
    procedure DumpParameters(AInput: Boolean);
{$ENDIF}
    function GetPARAMSET_SIZE: SQLUInteger;
    procedure SetPARAMSET_SIZE(const AValue: SQLUInteger);
  public
    constructor Create(AOwner: TODBCConnection; AOwningObj: TObject = nil);
    destructor Destroy; override;
    procedure BindParameters(ARowCount: SQLUInteger; AFixedLenOnly: Boolean);
    procedure UnbindParameters;
    procedure Execute(ARowCount, AOffset: SQLUInteger; var ACount: SQLUInteger;
      AExact: Boolean; const AExecDirectCommand: String);
    procedure Open(ARowCount: SQLUInteger; const AExecDirectCommand: String);
    function NumParams: SQLSmallint;
    procedure Prepare(ACommandText: String);
    procedure Unprepare; override;
    // Properties
    // AnyDAC
    property ParamList: TODBCVariableList read FParamList;
    property ParamSetSupported: Boolean read FParamSetSupported write FParamSetSupported;
    // ODBC
    property PARAMSET_SIZE: SQLUInteger read GetPARAMSET_SIZE write SetPARAMSET_SIZE;
    property PARAMS_PROCESSED_PTR: PSQLUInteger index SQL_ATTR_PARAMS_PROCESSED_PTR read GetPUIntAttribute write SetPUIntAttribute;
    property PARAM_BIND_TYPE: SQLUInteger index SQL_ATTR_PARAM_BIND_TYPE read GetUIntAttribute write SetUIntAttribute;
    property PARAM_STATUS_PTR: PSQLUSmallint index SQL_ATTR_PARAM_STATUS_PTR read GetPUSmIntAttribute write SetPUSmIntAttribute;
  end;

  TODBCMetaInfoStatement = class(TODBCStatementBase)
  private
    FMode: Integer;
    FCatalog, FSchema, FObject: String;
    FColumn: String;
    FFKCatalog, FFKSchema, FFKTable: String;
    FIdentifierType: SQLUSmallint;
    FUnique: SQLUSmallint;
    FTableTypes: String;
  public
    procedure Columns(const ACatalog, ASchema, ATable, AColumn: String);
    procedure ForeignKeys(const APKCatalog, APKSchema, APKTable, AFKCatalog,
      AFKSchema, AFKTable: String);
    procedure PrimaryKeys(const ACatalog, ASchema, ATable: String);
    procedure Procedures(const ACatalog, ASchema, AProc: String);
    procedure ProcedureColumns(const ACatalog, ASchema, AProc, AColumn: String);
    procedure SpecialColumns(const ACatalog, ASchema, ATable: String;
      AIdentifierType: SQLUSmallint);
    procedure Statistics(const ACatalog, ASchema, ATable: String; AUnique: SQLUSmallint);
    procedure Tables(const ACatalog, ASchema, ATable, ATableTypes: String);
    procedure Execute;
  end;

const
  C_DEF_NUM_PREC = 31;
  C_DEF_NUM_SCALE = 4;

implementation

uses
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  {$IFDEF AnyDAC_D6}
  SqlTimSt, FMTBcd, DateUtils,
  {$ENDIF}
{$ELSE}
  ComObj,
{$ENDIF}
  daADStanConst, daADStanUtil;

resourcestring
  ErrorItemText_fmt = 'SQL state: %s. Native error: %d. Error message: ' + C_AD_EOL + '%s';

const
  C_RETURNED_STRING_MAXLEN = 1024;
  C_DRIVER_DESC_MAXLEN = 255;
  C_STRING_ATTR_MAXLEN = 255;
  C_DRIVER_ATTR_MAXLEN = 4000;
  C_BLOB_PIECE = IDefPieceBuffLen;
  C_BLOB_PIECENUM = 32;
  C_BLOB_BUFSIZE = C_BLOB_PIECE * C_BLOB_PIECENUM;
{$IFDEF AnyDAC_MONITOR}
  C_BuffSize = 4096;
  C_PipeName: String = '\\.\pipe\daadot';
{$ENDIF}

var
  FODBCLib: TODBCLib = nil;
  FODBCLibClients: Integer = 0;
  FGLock: TRTLCriticalSection;

procedure ODBCSetLength(var AStr: String; ALen: Integer);
begin
  while (ALen > 0) and (AStr[ALen] = #0) do
    Dec(ALen);
  SetLength(AStr, ALen);
end;

{-------------------------------------------------------------------------------}
{ EODBCNativeException                                                          }
{-------------------------------------------------------------------------------}
constructor EODBCNativeException.Create(AStatus: SQLReturn; AOwner: TODBCHandle);
var
  iRecNum: SQLSmallint;
  iDiagMesLen: SQLSmallint;
  iNativeError: SQLInteger;
  sDrv, sSQLState,
  sDiagMessage, sRetCode,
  sResultMes, sObj: string;
  aDiagMesBuffer: array [0 .. SQL_MAX_MESSAGE_LENGTH] of SQLChar;
  eKind: TADCommandExceptionKind;
  iCmdOffset: Integer;
  oHandle: TODBCHandle;
  oConn: TODBCConnection;
begin
  case AStatus of
  SQL_SUCCESS:           sRetCode := 'SQL_SUCCESS';
  SQL_SUCCESS_WITH_INFO: sRetCode := 'SQL_SUCCESS_WITH_INFO';
  SQL_NO_DATA:           begin sRetCode := 'SQL_NO_DATA'; eKind := ekNoDataFound; end;
  SQL_ERROR:             sRetCode := 'SQL_ERROR';
  SQL_INVALID_HANDLE:    sRetCode := 'SQL_INVALID_HANDLE';
  SQL_STILL_EXECUTING:   sRetCode := 'SQL_STILL_EXECUTING';
  SQL_NEED_DATA:         sRetCode := 'SQL_NEED_DATA';
  end;
  oConn := AOwner.Connection;
  if (oConn <> nil) and oConn.Connected then begin
    sDrv := '';
    oConn.GetInfoBase(SQL_DRIVER_NAME, sDrv);
  end
  else
    sDrv := 'CLI';
  oHandle := AOwner;
  while (oHandle <> nil) and (oHandle.Handle = nil) do
    oHandle := oHandle.Owner;
  inherited Create(er_AD_ODBCGeneral,
    ADExceptionLayers([S_AD_LPhys, S_AD_ODBCId, sDrv]) + ' ' + sRetCode);
  SetLength(sSQLState, 5);
  iRecNum := 1;
  with oHandle do
    while True do begin
      iDiagMesLen := 0;
      iNativeError := 0;
      if not (Lib.SQLGetDiagRec(HandleType, Handle, iRecNum, PSQLChar(sSQLState),
                                iNativeError, @aDiagMesBuffer[0], SQL_MAX_MESSAGE_LENGTH,
                                iDiagMesLen) in [SQL_SUCCESS, SQL_SUCCESS_WITH_INFO]) then
        Break;
      SetString(sDiagMessage, PChar(@aDiagMesBuffer[0]), iDiagMesLen);
      sResultMes := Format(ErrorItemText_fmt, [sSQLState, iNativeError, sDiagMessage]);
      if iRecNum = 1 then
        Message := ADExceptionLayers([S_AD_LPhys, S_AD_ODBCId]) + sDiagMessage;
      sObj := '';
      eKind := ekOther;
      iCmdOffset := -1;
      if (oConn <> nil) and Assigned(oConn.OnParseError) then
        oConn.OnParseError(oHandle, iRecNum, sSQLState, iNativeError, sDiagMessage,
          oConn.LastCommandText, sObj, eKind, iCmdOffset);
      Append(TADDBError.Create(iRecNum, iNativeError, sResultMes, sObj, eKind, iCmdOffset));
{$IFDEF AnyDAC_MONITOR}
      AOwner.Trace(ekError, esProgress, sDiagMessage,
        ['SQLState', sSQLState, 'NativeError', iNativeError, 'RecNum', iRecNum]);
{$ENDIF}
      Inc(iRecNum);
    end;
  if iRecNum = 1 then
    Append(TADDBError.Create(iRecNum, AStatus, sRetCode, '', eKind, -1));
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
{ TODBCTracer                                                                   }
{-------------------------------------------------------------------------------}
constructor TODBCTracer.Create(const AMonitor: IADMoniClient; ALib: TODBCLib);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FMonitor := AMonitor;
  FLib := ALib;
  ALib.FTracer := Self;
  Resume;
  Sleep(200);
  ALib.TRACEFILE := C_PipeName;
  ALib.TRACE := True;
  if ALib.TRACE then
    ALib.FTracing := True;
end;

{-------------------------------------------------------------------------------}
procedure TODBCTracer.Execute;
var
  hPipe: THandle;
  dwTotalBytesAvail: DWORD;
  dwBytesRead: DWORD;
  aBuff: array [0 .. C_BuffSize - 1] of Char;
  sMsg: string;
  i: DWORD;

  procedure NotifyError;
  begin
    FMonitor.Notify(ekError, esProgress, FLib.OwningObj,
      'ODBC tracer failed: ' + ADLastSystemErrorMsg, []);
  end;

begin
  hPipe := CreateNamedPipe(PChar(C_PipeName), PIPE_ACCESS_INBOUND,
    PIPE_TYPE_BYTE or PIPE_READMODE_BYTE or PIPE_WAIT, 1,
    C_BuffSize, C_BuffSize, INFINITE, nil);
  if hPipe = INVALID_HANDLE_VALUE then begin
    NotifyError;
    Exit;
  end;
  if not ConnectNamedPipe(hPipe, nil) then begin
    NotifyError;
    CloseHandle(hPipe);
    Exit;
  end;
  try
    while not Terminated and FMonitor.Tracing do begin
      dwTotalBytesAvail := 0;
      dwBytesRead := 0;
      if not PeekNamedPipe(hPipe, nil, 0, nil, @dwTotalBytesAvail, nil) or
         (dwTotalBytesAvail > 0) and
           not ReadFile(hPipe, aBuff, C_BuffSize, dwBytesRead, nil) and
           (GetLastError <> ERROR_MORE_DATA) then begin
        NotifyError;
        Terminate;
      end
      else if (dwTotalBytesAvail > 0) and (dwBytesRead > 0) then begin
        i := 0;
        while (i < dwBytesRead) and ((aBuff[i] = #13) or (aBuff[i] = #10)) do
          Inc(i);
        SetString(sMsg, aBuff + i, dwBytesRead - i);
        FMonitor.Notify(ekVendor, esProgress, FLib.OwningObj, sMsg, []);
      end
      else if dwTotalBytesAvail = 0 then
        Sleep(1);
    end;
  finally
    FMonitor := nil;
    DisconnectNamedPipe(hPipe);
    CloseHandle(hPipe);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TODBCLib                                                                      }
{-------------------------------------------------------------------------------}
constructor TODBCLib.Create(const AHome, ALib: String; AOwningObj: TObject);
begin
  inherited Create;
  FOwningObj := AOwningObj;
  if ALib = '' then
    FODBCDllName := 'odbc32.dll'
  else
    FODBCDllName := ALib;
  if AHome <> '' then
    if AHome[Length(AHome)] <> '\' then
      FODBCDllName := AHome + '\' + FODBCDllName
    else
      FODBCDllName := AHome + FODBCDllName;
  LoadODBCLibrary;
  LoadODBCEntries;
end;

{-------------------------------------------------------------------------------}
destructor TODBCLib.Destroy;
begin
{$IFDEF AnyDAC_MONITOR}
  FreeAndNil(FTracer);
{$ENDIF}
  FreeLibrary(FODBCHDll);
  FODBCHDll := 0;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TODBCLib.Allocate(const AHome, ALib: String; AOwningObj: TObject): TODBCLib;
begin
  EnterCriticalSection(FGLock);
  try
    Inc(FODBCLibClients);
    if FODBCLibClients = 1 then
      FODBCLib := TODBCLib.Create(AHome, ALib, AOwningObj);
    Result := FODBCLib;
  finally
    LeaveCriticalSection(FGLock);
  end;
end;

{-------------------------------------------------------------------------------}
class procedure TODBCLib.Release(ALib: TODBCLib);
begin
  EnterCriticalSection(FGLock);
  try
    if (ALib = FODBCLib) and (FODBCLibClients > 0) then begin
      Dec(FODBCLibClients);
      if FODBCLibClients = 0 then
        FreeAndNil(FODBCLib);
    end;
  finally
    LeaveCriticalSection(FGLock);
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCLib.GetODBCProcAddress(const AProcName: String): Pointer;
begin
  Result := nil;
  try
    Result := GetProcAddress(FODBCHDll, PChar(AProcName));
    if Result = nil then
      ADException(OwningObj, [S_AD_LPhys, S_AD_ODBCId], er_AD_AccCantGetLibraryEntry,
        [AProcName, ADLastSystemErrorMsg]);
  except
    ADHandleException;
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCLib.GetTRACE: Boolean;
var
  iStringLen: SQLInteger;
  iValue: SQLUInteger;
begin
  iStringLen := 0;
  SQLGetConnectAttr(nil, SQL_ATTR_TRACE, @iValue, 0, iStringLen);
  Result := iValue = SQL_TRUE;
end;

{-------------------------------------------------------------------------------}
function TODBCLib.GetTRACEFILE: string;
var
  iStringLen: SQLInteger;
begin
  SetLength(Result, SQL_MAX_MESSAGE_LENGTH);
  iStringLen := 0;
  SQLGetConnectAttr(nil, SQL_ATTR_TRACEFILE, PChar(Result), SQL_MAX_MESSAGE_LENGTH,
    iStringLen);
  SetLength(Result, iStringLen);
end;

{-------------------------------------------------------------------------------}
procedure TODBCLib.LoadODBCEntries;
begin
  @SQLAllocHandle        := GetODBCProcAddress('SQLAllocHandle');
  @SQLBindCol            := GetODBCProcAddress('SQLBindCol');
  @SQLBindParameter      := GetODBCProcAddress('SQLBindParameter');
  @SQLCancel             := GetODBCProcAddress('SQLCancel');
  @SQLColAttribute       := GetODBCProcAddress('SQLColAttribute');
  @SQLColAttributeString := @SQLColAttribute;
  @SQLColAttributeInt    := @SQLColAttribute;
  @SQLColumns            := GetODBCProcAddress('SQLColumns');
  @SQLDataSources        := GetODBCProcAddress('SQLDataSources');
  @SQLDescribeCol        := GetODBCProcAddress('SQLDescribeCol');
  @SQLDisconnect         := GetODBCProcAddress('SQLDisconnect');
  @SQLDescribeParam      := GetODBCProcAddress('SQLDescribeParam');
  @SQLDriverConnect      := GetODBCProcAddress('SQLDriverConnect');
  @SQLDrivers            := GetODBCProcAddress('SQLDrivers');
  @SQLEndTran            := GetODBCProcAddress('SQLEndTran');
  @SQLExecDirect         := GetODBCProcAddress('SQLExecDirect');
  @SQLExecute            := GetODBCProcAddress('SQLExecute');
  @SQLFetch              := GetODBCProcAddress('SQLFetch');
  @SQLForeignKeys        := GetODBCProcAddress('SQLForeignKeys');
  @SQLFreeHandle         := GetODBCProcAddress('SQLFreeHandle');
  @SQLFreeStmt           := GetODBCProcAddress('SQLFreeStmt');
  @SQLGetConnectAttr     := GetODBCProcAddress('SQLGetConnectAttr');
  @SQLGetCursorName      := GetODBCProcAddress('SQLGetCursorName');
  @SQLGetData            := GetODBCProcAddress('SQLGetData');
  @SQLGetDescField       := GetODBCProcAddress('SQLGetDescField');
  @SQLGetDescRec         := GetODBCProcAddress('SQLGetDescRec');
  @SQLGetDiagRec         := GetODBCProcAddress('SQLGetDiagRec');
  @SQLGetEnvAttr         := GetODBCProcAddress('SQLGetEnvAttr');
  @SQLGetFunctions       := GetODBCProcAddress('SQLGetFunctions');
  @SQLGetInfo            := GetODBCProcAddress('SQLGetInfo');
  @SQLGetInfoString      := @SQLGetInfo;
  @SQLGetInfoSmallint    := @SQLGetInfo;
  @SQLGetInfoInt         := @SQLGetInfo;
  @SQLGetStmtAttr        := GetODBCProcAddress('SQLGetStmtAttr');
  @SQLGetTypeInfo        := GetODBCProcAddress('SQLGetTypeInfo');
  @SQLMoreResults        := GetODBCProcAddress('SQLMoreResults');
  @SQLNumParams          := GetODBCProcAddress('SQLNumParams');
  @SQLNumResultCols      := GetODBCProcAddress('SQLNumResultCols');
  @SQLParamData          := GetODBCProcAddress('SQLParamData');
  @SQLPrepare            := GetODBCProcAddress('SQLPrepare');
  @SQLPrimaryKeys        := GetODBCProcAddress('SQLPrimaryKeys');
  @SQLProcedureColumns   := GetODBCProcAddress('SQLProcedureColumns');
  @SQLProcedures         := GetODBCProcAddress('SQLProcedures');
  @SQLPutData            := GetODBCProcAddress('SQLPutData');
  @SQLRowCount           := GetODBCProcAddress('SQLRowCount');
  @SQLSetConnectAttr     := GetODBCProcAddress('SQLSetConnectAttr');
  @SQLSetCursorName      := GetODBCProcAddress('SQLSetCursorName');
  @SQLSetDescField       := GetODBCProcAddress('SQLSetDescField');
  @SQLSetDescRec         := GetODBCProcAddress('SQLSetDescRec');
  @SQLSetEnvAttr         := GetODBCProcAddress('SQLSetEnvAttr');
  @SQLSetPos             := GetODBCProcAddress('SQLSetPos');
  @SQLSetStmtAttr        := GetODBCProcAddress('SQLSetStmtAttr');
  @SQLSpecialColumns     := GetODBCProcAddress('SQLSpecialColumns');
  @SQLStatistics         := GetODBCProcAddress('SQLStatistics');
  @SQLTablePrivileges    := GetODBCProcAddress('SQLTablePrivileges');
  @SQLTables             := GetODBCProcAddress('SQLTables');
end;

{-------------------------------------------------------------------------------}
procedure TODBCLib.LoadODBCLibrary;
begin
{$IFDEF AnyDAC_FPC}
  FODBCHDll := LoadLibrary(PChar(FODBCDllName));
{$ELSE}
  FODBCHDll := SafeLoadLibrary(PChar(FODBCDllName));
{$ENDIF}
  if FODBCHDll = 0 then
    ADException(OwningObj, [S_AD_LPhys, S_AD_ODBCId], er_AD_AccCantLoadLibrary,
      [FODBCDllName, ADLastSystemErrorMsg, FODBCDllName]);
end;

{-------------------------------------------------------------------------------}
procedure TODBCLib.SetTRACE(AValue: Boolean);
begin
  SQLSetConnectAttr(nil, SQL_ATTR_TRACE, SQLPointer(Integer(AValue)), SQL_IS_INTEGER);
end;

{-------------------------------------------------------------------------------}
procedure TODBCLib.SetTRACEFILE(const AValue: string);
begin
  SQLSetConnectAttr(nil, SQL_ATTR_TRACEFILE, PChar(AValue), SQL_NTS);
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TODBCLib.ActivateTracing(const AMonitor: IADMoniClient);
begin
  if FTracer = nil then
    TODBCTracer.Create(AMonitor, Self);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TODBCLib.DecorateKeyValue(const AValue: String): String;
var
  i: Integer;
begin
  Result := AValue;
  for i := 1 to Length(Result) do
    if Pos(Result[i], '[]{}(),;?*=!@') <> 0 then begin
      Result := '{' + Result + '}';
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
{ TODBCHandle                                                                   }
{-------------------------------------------------------------------------------}
constructor TODBCHandle.Create;
begin
  inherited Create;
  FOwner := nil;
  FHandleType := 0;
  FHandle := SQL_NULL_HDBC;
  FODBCLib := nil;
end;

{-------------------------------------------------------------------------------}
destructor TODBCHandle.Destroy;
begin
  if FHandle <> SQL_NULL_HANDLE then
    FreeHandle;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TODBCHandle.GetConnection: TODBCConnection;
var
  oHndl: TODBCHandle;
begin
  oHndl := Self;
  while (oHndl <> nil) and not (oHndl is TODBCConnection) do
    oHndl := oHndl.Owner;
  Result := TODBCConnection(oHndl);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.AllocHandle;
var
  InputHandle: SQLHandle;
begin
  ASSERT(FHandle = nil);
  if FOwner <> nil then
    InputHandle := FOwner.Handle
  else
    InputHandle := SQL_NULL_HANDLE;
  Check(Lib.SQLAllocHandle(FHandleType, InputHandle, FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.Check(AStatus: SQLReturn);
var
  oConn: TODBCConnection;
  oExc: EODBCNativeException;
begin
  if AStatus <> SQL_SUCCESS then
    case AStatus of
    SQL_SUCCESS_WITH_INFO:
      begin
        oConn := Connection;
        if oConn <> nil then begin
          oExc := EODBCNativeException.Create(AStatus, Self);
          // if "The statement has been terminated" and few error items,
          // then most probable batch has been terminated due to errors
          if (oConn.RdbmsKind = mkMSSQL) and (oExc.ErrorCount > 1) and
             (oExc.Errors[oExc.ErrorCount - 1].ErrorCode = 3621) then
            ADException(OwningObj, oExc)
          else begin
            oConn.ClearInfo;
            oConn.FInfo := oExc;
          end;
        end;
      end;
    SQL_NEED_DATA,
    SQL_INVALID_HANDLE,
    SQL_STILL_EXECUTING,
    SQL_ERROR,
    SQL_NO_DATA:
      ADException(OwningObj, EODBCNativeException.Create(AStatus, Self));
    end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.FreeHandle;
begin
  Check(Lib.SQLFreeHandle(FHandleType, FHandle));
  FHandle := SQL_NULL_HANDLE;
end;

{-------------------------------------------------------------------------------}
function TODBCHandle.GetCharAttribute(AAttr: SQLInteger): string;
begin
  GetStrAttribute(AAttr, Result);
end;

{-------------------------------------------------------------------------------}
function TODBCHandle.GetIntAttribute(AAttr: SQLInteger): SQLInteger;
begin
  GetNonStrAttribute(AAttr, @Result);
end;

{-------------------------------------------------------------------------------}
function TODBCHandle.GetPSQLPAttribute(AAttr: SQLInteger): SQLPointer;
begin
  Result := nil;
  GetNonStrAttribute(AAttr, Result);
end;

{-------------------------------------------------------------------------------}
function TODBCHandle.GetPUIntAttribute(AAttr: SQLInteger): PSQLUInteger;
begin
  Result := nil;
  GetNonStrAttribute(AAttr, Result);
end;

{-------------------------------------------------------------------------------}
function TODBCHandle.GetPUSmIntAttribute(AAttr: SQLInteger): PSQLUSmallint;
begin
  Result := nil;
  GetNonStrAttribute(AAttr, Result);
end;

{-------------------------------------------------------------------------------}
function TODBCHandle.GetUIntAttribute(AAttr: SQLInteger): SQLUInteger;
begin
  GetNonStrAttribute(AAttr, @Result);
end;

{-------------------------------------------------------------------------------}
function TODBCHandle.GetUSmIntAttribute(AAttr: SQLInteger): SQLUSmallint;
begin
  GetNonStrAttribute(AAttr, @Result);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.SetCharAttribute(AAttr: SQLInteger; AValue: String);
begin
  SetAttribute(AAttr, PSQLChar(AValue), True);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.SetIntAttribute(AAttr: SQLInteger; AValue: SQLInteger);
begin
  SetAttribute(AAttr, PSQLInteger(AValue), False);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.SetPUIntAttribute(AAttr: SQLInteger; AValue: PSQLUInteger);
begin
  SetAttribute(AAttr, AValue, False);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.SetPUSmIntAttribute(AAttr: SQLInteger; AValue: PSQLUSmallint);
begin
  SetAttribute(AAttr, AValue, False);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.SetUIntAttribute(AAttr: SQLInteger; AValue: SQLUInteger);
begin
  SetAttribute(AAttr, PSQLUInteger(AValue), False);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.SetUSmIntAttribute(AAttr: SQLInteger; AValue: SQLUSmallint);
begin
  SetAttribute(AAttr, PSQLUSmallint(AValue), False);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.GetNonStrAttribute(AAttr: SQLInteger; ApValue: SQLPointer);
begin
  ASSERT(False);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.GetStrAttribute(AAttr: SQLInteger; out AValue: String);
begin
  ASSERT(False);
end;

{-------------------------------------------------------------------------------}
procedure TODBCHandle.SetAttribute(AAttr: SQLInteger; ApValue: SQLPointer; ACharData: Boolean);
begin
  ASSERT(False);
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TODBCHandle.Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
  const AMsg: String; AArgs: array of const);
begin
  if Tracing then
    Lib.FTracer.FMonitor.Notify(AKind, AStep, OwningObj, AMsg, AArgs);
end;

{-------------------------------------------------------------------------------}
function TODBCHandle.GetTracing: Boolean;
begin
  Result := (Self <> nil) and Lib.Tracing and (Lib.FTracer <> nil) and
    (Lib.FTracer.FMonitor <> nil);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TODBCEnvironment                                                              }
{-------------------------------------------------------------------------------}
constructor TODBCEnvironment.Create(ALib: TODBCLib; AOwningObj: TObject);
begin
  inherited Create;
  FOwningObj := AOwningObj;
  FHandleType := SQL_HANDLE_ENV;
  FODBCLib := ALib;
  AllocHandle;
end;

{-------------------------------------------------------------------------------}
procedure TODBCEnvironment.AllocHandle;
begin
  inherited AllocHandle;
  ODBC_VERSION := SQL_OV_ODBC3;
end;

{-------------------------------------------------------------------------------}
procedure TODBCEnvironment.GetNonStrAttribute(AAttr: SQLInteger; ApValue: SQLPointer);
var
  iStringLen: SQLInteger;
begin
  iStringLen := 0;
  Check(Lib.SQLGetEnvAttr(FHandle, AAttr, ApValue, 0, iStringLen));
end;

{-------------------------------------------------------------------------------}
procedure TODBCEnvironment.GetStrAttribute(AAttr: SQLInteger; out AValue: String);
begin
  ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_ODBCId]);
end;

{-------------------------------------------------------------------------------}
procedure TODBCEnvironment.SetAttribute(AAttr: SQLInteger; ApValue: SQLPointer;
  ACharData: Boolean = False);
begin
  Check(Lib.SQLSetEnvAttr(FHandle, AAttr, ApValue, 0));
end;

{-------------------------------------------------------------------------------}
function TODBCEnvironment.DoDrivers(ADirection: SQLUSmallint; out ADriverDesc: String;
  out ADriverAttr: String): Boolean;
var
  iDriverDescLen: SQLSmallint;
  iDriverAttrLen: SQLSmallint;
  iRet: SQLReturn;
begin
  SetLength(ADriverDesc, C_DRIVER_DESC_MAXLEN);
  SetLength(ADriverAttr, C_DRIVER_ATTR_MAXLEN);
  iDriverDescLen := 0;
  iDriverAttrLen := 0;
  iRet := Lib.SQLDrivers(FHandle, ADirection, PSQLChar(ADriverDesc),
    C_DRIVER_DESC_MAXLEN, iDriverDescLen, PSQLChar(ADriverAttr),
    C_DRIVER_ATTR_MAXLEN, iDriverAttrLen);
  if iRet = SQL_NO_DATA then
    Result := False
  else begin
    Check(iRet);
    Result := True;
  end;
  SetLength(ADriverDesc, iDriverDescLen);
  SetLength(ADriverAttr, iDriverAttrLen);
end;

{-------------------------------------------------------------------------------}
function TODBCEnvironment.DriverFirst(out ADriverDesc: String;
  out ADriverAttr: String): Boolean;
begin
  Result := DoDrivers(SQL_FETCH_FIRST, ADriverDesc, ADriverAttr);
end;

{-------------------------------------------------------------------------------}
function TODBCEnvironment.DriverNext(out ADriverDesc: String;
  out ADriverAttr: String): Boolean;
begin
  Result := DoDrivers(SQL_FETCH_NEXT, ADriverDesc, ADriverAttr);
end;

{-------------------------------------------------------------------------------}
function TODBCEnvironment.DoDSNs(ADirection: SQLUSmallint; out AServerName,
  ADescription: String): Boolean;
var
  iServerNameLen: SQLSmallint;
  iDescriptionLen: SQLSmallint;
  iRet: SQLReturn;
begin
  SetLength(AServerName, SQL_MAX_DSN_LENGTH);
  SetLength(ADescription, C_DRIVER_DESC_MAXLEN);
  iServerNameLen := 0;
  iDescriptionLen := 0;
  iRet := Lib.SQLDataSources(FHandle, ADirection, PSQLChar(AServerName),
    SQL_MAX_DSN_LENGTH, iServerNameLen, PSQLChar(ADescription),
    C_DRIVER_DESC_MAXLEN, iDescriptionLen);
  if iRet = SQL_NO_DATA then
    Result := False
  else begin
    Check(iRet);
    Result := True;
  end;
  SetLength(AServerName, iServerNameLen);
  SetLength(ADescription, iDescriptionLen);
end;

{-------------------------------------------------------------------------------}
function TODBCEnvironment.DSNFirst(out AServerName, ADescription: String): Boolean;
begin
  Result := DoDSNs(SQL_FETCH_FIRST, AServerName, ADescription);
end;

{-------------------------------------------------------------------------------}
function TODBCEnvironment.DSNNext(out AServerName, ADescription: String): Boolean;
begin
  Result := DoDSNs(SQL_FETCH_NEXT, AServerName, ADescription);
end;

{-------------------------------------------------------------------------------}
{ TODBCTransaction                                                              }
{-------------------------------------------------------------------------------}
constructor TODBCTransaction.Create(AOwner: TODBCConnection);
begin
  ASSERT(AOwner <> nil);
  inherited Create;
  FOwner := AOwner;
end;

{-------------------------------------------------------------------------------}
procedure TODBCTransaction.Commit(AAll: Boolean = False);
begin
  EndTran(SQL_COMMIT, AAll);
end;

{-------------------------------------------------------------------------------}
procedure TODBCTransaction.EndTran(AType: SQLSmallint; AAll: Boolean = False);
var
  oInitiator: TODBCHandle;
begin
  if not AAll then
    oInitiator := FOwner
  else
    oInitiator := FOwner.Owner;
  with oInitiator do
    Check(Lib.SQLEndTran(HandleType, Handle, AType));
end;

{-------------------------------------------------------------------------------}
procedure TODBCTransaction.Rollback(AAll: Boolean = False);
begin
  EndTran(SQL_ROLLBACK, AAll);
end;

{-------------------------------------------------------------------------------}
procedure TODBCTransaction.StartTransaction;
begin
  FOwner.AUTOCOMMIT := SQL_AUTOCOMMIT_OFF;
end;

{-------------------------------------------------------------------------------}
{ TODBCConnection                                                               }
{-------------------------------------------------------------------------------}
constructor TODBCConnection.Create(AOwner: TODBCEnvironment; AOwningObj: TObject);
begin
  ASSERT(AOwner <> nil);
  inherited Create;
  FOwner := AOwner;
  FOwningObj := AOwningObj;
  FHandleType := SQL_HANDLE_DBC;
  FODBCLib := FOwner.Lib;
  FDecimalSepPar := '.';
  FDecimalSepCol := '.';
  FTransaction := TODBCTransaction.Create(Self);
  AllocHandle;
end;

{-------------------------------------------------------------------------------}
destructor TODBCConnection.Destroy;
begin
  ClearInfo;
  FreeAndNil(FTransaction);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TODBCConnection.ClearInfo;
begin
  FreeAndNil(FInfo);
end;

{-------------------------------------------------------------------------------}
procedure TODBCConnection.UpdateRDBMSKind;
var
  s: string;

  function Match(const AName: String): Boolean;
  begin
    Result := Copy(s, 1, Length(AName)) = AName;
  end;

begin
  s := UpperCase(DRIVER_NAME);
  if Match('SQLSRV') or Match('SQLNCLI') or Match('IVSS') or Match('IVMSSS') or
     ((Copy(s, 1, 3) = 'NTL') and (s[5] = 'M')) then
    FRdbmsKind := mkMSSQL
  else if Match('DB2CLI') or Match('LIBDB2') or Match('IVDB2') then
    FRdbmsKind := mkDB2
  else if Match('MYODBC') then
    FRdbmsKind := mkMySQL
  else if Match('SQORA') or Match('MSORCL') or Match('IVOR') then
    FRdbmsKind := mkOracle
  else if Match('ODBCJT') and (DBMS_NAME = 'ACCESS') then
    FRdbmsKind := mkMSAccess
  else
    FRdbmsKind := mkOther;
end;

{-------------------------------------------------------------------------------}
function TODBCConnection.Connect(const AConnString: String; AWithPrompt: Boolean): String;
var
  iCompletion: SQLUSmallInt;
begin
  if AWithPrompt then
    iCompletion := SQL_DRIVER_PROMPT
  else
    iCompletion := SQL_DRIVER_NOPROMPT;
  Result := DriverConnect(AConnString, iCompletion);
end;

{-------------------------------------------------------------------------------}
function TODBCConnection.DriverConnect(const AConnString: String;
  ADriverCompletion: SQLUSmallint): String;
var
  iTotalOutConnStrLen: SQLSmallint;
begin
  SetLength(Result, C_RETURNED_STRING_MAXLEN);
  iTotalOutConnStrLen := 0;
  Check(Lib.SQLDriverConnect(FHandle, GetDesktopWindow, PSQLChar(AConnString), SQL_NTS,
    PSQLChar(Result), C_RETURNED_STRING_MAXLEN, iTotalOutConnStrLen, ADriverCompletion));
  FConnected := True;
  UpdateRDBMSKind;
  ODBCSetLength(Result, iTotalOutConnStrLen);
end;

{-------------------------------------------------------------------------------}
procedure TODBCConnection.Disconnect;
begin
  FConnected := False;
  Check(Lib.SQLDisconnect(FHandle));
end;

{-------------------------------------------------------------------------------}
function TODBCConnection.GetFunctions(AFuncID: SQLUSmallint): SQLUSmallint;
begin
  Result := 0;
  Check(Lib.SQLGetFunctions(FHandle, AFuncID, Result));
end;

{-------------------------------------------------------------------------------}
procedure TODBCConnection.GetInfo(AInfoType: SQLUSmallint; var AInfoValue: String);
begin
  Check(GetInfoBase(AInfoType, AInfoValue));
end;

{-------------------------------------------------------------------------------}
function TODBCConnection.GetInfoBase(AInfoType: SQLUSmallint; var AInfoValue: String): SQLReturn;
var
  iInfoLength: SQLSmallint;
begin
  SetLength(AInfoValue, C_RETURNED_STRING_MAXLEN);
  iInfoLength := 0;
  Result := Lib.SQLGetInfoString(FHandle, AInfoType, PSQLChar(AInfoValue),
    SQLSmallint(Length(AInfoValue)), iInfoLength);
  ODBCSetLength(AInfoValue, iInfoLength);
end;

{-------------------------------------------------------------------------------}
procedure TODBCConnection.GetInfo(AInfoType: SQLUSmallint; var AInfoValue: SQLUInteger);
begin
  AInfoValue := 0;
  Check(Lib.SQLGetInfoInt(FHandle, AInfoType, AInfoValue, SQLSmallint(SizeOf(SQLInteger)), nil));
end;

{-------------------------------------------------------------------------------}
procedure TODBCConnection.GetInfo(AInfoType: SQLUSmallint; var AInfoValue: SQLUSmallint);
begin
  AInfoValue := 0;
  Check(Lib.SQLGetInfoSmallint(FHandle, AInfoType, AInfoValue, SQLSmallint(SizeOf(AInfoValue)), nil));
end;

{-------------------------------------------------------------------------------}
function TODBCConnection.GetInfoOptionSmInt(AInfoType: Integer): SQLUSmallint;
begin
  Result := 0;
  GetInfo(SQLUSmallint(AInfoType), Result);
end;

{-------------------------------------------------------------------------------}
function TODBCConnection.GetInfoOptionUInt(AInfoType: Integer): SQLUInteger;
begin
  Result := 0;
  GetInfo(SQLUSmallint(AInfoType), Result);
end;

{-------------------------------------------------------------------------------}
function TODBCConnection.GetInfoOptionStr(AInfoType: Integer): string;
begin
  Result := '';
  GetInfo(SQLUSmallint(AInfoType), Result);
end;

{-------------------------------------------------------------------------------}
procedure TODBCConnection.GetNonStrAttribute(AAttr: SQLInteger; ApValue: SQLPointer);
var
  iStringLen: SQLInteger;
begin
  iStringLen := 0;
  Check(Lib.SQLGetConnectAttr(FHandle, AAttr, ApValue, 0, iStringLen));
end;

{-------------------------------------------------------------------------------}
procedure TODBCConnection.GetStrAttribute(AAttr: SQLInteger; out AValue: String);
var
  iStringLen: SQLInteger;
begin
  SetLength(AValue, SQL_MAX_MESSAGE_LENGTH);
  iStringLen := 0;
  Check(Lib.SQLGetConnectAttr(FHandle, AAttr, PChar(AValue),
    SQL_MAX_MESSAGE_LENGTH, iStringLen));
  ODBCSetLength(AValue, iStringLen);
end;

{-------------------------------------------------------------------------------}
procedure TODBCConnection.SetAttribute(AAttr: SQLInteger; ApValue: SQLPointer;
  ACharData: Boolean = False);
var
  iStringLen: SQLInteger;
begin
  if ACharData then
    iStringLen := StrLen(PChar(ApValue))
  else
    iStringLen := 0;
  Check(Lib.SQLSetConnectAttr(FHandle, AAttr, ApValue, iStringLen));
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
function TODBCConnection.GetTracing: Boolean;
begin
  Result := FTracing and inherited GetTracing;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TODBCConnection.EncodeName(const ACat, ASch, AObj: String): String;
var
  sQuote: String;
begin
  sQuote := IDENTIFIER_QUOTE_CHAR;
  Result := '';
  if ((CATALOG_USAGE and SQL_CU_DML_STATEMENTS) <> 0) and
     (CATALOG_LOCATION = SQL_CL_START) then
    if ACat <> '' then
      Result := sQuote + ACat + sQuote + CATALOG_NAME_SEPARATOR;
  if (SCHEMA_USAGE and SQL_SU_DML_STATEMENTS) <> 0 then
    if ASch <> '' then
      Result := Result + sQuote + ASch + sQuote + '.';
  Result := Result + sQuote + AObj + sQuote;
  if ((CATALOG_USAGE and SQL_CU_DML_STATEMENTS) <> 0) and
     (CATALOG_LOCATION = SQL_CL_END) then
    if ACat <> '' then
      Result := CATALOG_NAME_SEPARATOR + sQuote + ACat + sQuote;
end;

{-------------------------------------------------------------------------------}
{ TODBCSelectItem                                                               }
{-------------------------------------------------------------------------------}
constructor TODBCSelectItem.Create(AOwner: TODBCStatementBase; AColNum: SQLSmallint);
begin
  inherited Create;
  FStmt := AOwner;
  FPosition := AColNum;
  FStmt.DescribeCol(FPosition, FName, FSQLDataType, FColumnSize, FScale, FNullable);
  if (AOwner.Connection.RdbmsKind = mkMSSQL) and
     (FColumnSize = SQL_SS_LENGTH_UNLIMITED) and
     ((FSQLDataType = SQL_VARCHAR) or (FSQLDataType = SQL_VARBINARY) or
      (FSQLDataType = SQL_WVARCHAR)) then
    FColumnSize := MAXINT;
end;

{-------------------------------------------------------------------------------}
function TODBCSelectItem.GetAUTO_UNIQUE_VALUE: SQLInteger;
begin
  Result := 0;
  FStmt.ColAttributeInt(FPosition, SQL_DESC_AUTO_UNIQUE_VALUE, Result);
end;

{-------------------------------------------------------------------------------}
function TODBCSelectItem.GetFIXED_PREC_SCALE: SQLInteger;
begin
  Result := 0;
  FStmt.ColAttributeInt(FPosition, SQL_DESC_FIXED_PREC_SCALE, Result);
end;

{-------------------------------------------------------------------------------}
function TODBCSelectItem.GetIsFixedLen: Boolean;
begin
  case FSQLDataType of
  SQL_CHAR,
  SQL_WCHAR,
  SQL_GUID,
  SQL_BINARY,
  SQL_INTERVAL_YEAR .. SQL_INTERVAL_MINUTE_TO_SECOND:
    Result := True
  else
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCSelectItem.GetNULLABLE: SQLSmallint;
begin
  Result := FNullable;
end;

{-------------------------------------------------------------------------------}
function TODBCSelectItem.GetROWVER: SQLInteger;
begin
  Result := SQL_FALSE;
  if FStmt.Lib.SQLColAttributeInt(FStmt.FHandle, FPosition, SQL_DESC_ROWVER, nil,
                                  0, nil, Result) <> SQL_SUCCESS then
    Result := SQL_FALSE;
end;

{-------------------------------------------------------------------------------}
function TODBCSelectItem.GetSEARCHABLE: SQLInteger;
begin
  Result := 0;
  FStmt.ColAttributeInt(FPosition, SQL_DESC_SEARCHABLE, Result);
end;

{-------------------------------------------------------------------------------}
function TODBCSelectItem.GetUNSIGNED: SQLInteger;
begin
  Result := 0;
  FStmt.ColAttributeInt(FPosition, SQL_DESC_UNSIGNED, Result);
end;

{-------------------------------------------------------------------------------}
function TODBCSelectItem.GetUPDATABLE: SQLInteger;
begin
  Result := 0;
  FStmt.ColAttributeInt(FPosition, SQL_DESC_UPDATABLE, Result);
end;

{-------------------------------------------------------------------------------}
{ TODBCVariable                                                                 }
{-------------------------------------------------------------------------------}
constructor TODBCVariable.Create;
begin
  inherited Create;
  FSQLDataType := SQL_UNKNOWN_TYPE;
  FCDataType := SQL_UNKNOWN_TYPE;
  FParamType := SQL_PARAM_TYPE_UNKNOWN;
  FPosition := -1;
  FDataSize := SQL_NULL_DATA;
  FBinded := False;
end;

{-------------------------------------------------------------------------------}
destructor TODBCVariable.Destroy;
begin
  FList := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.SetCDataType(const AValue: SQLSmallint);
begin
  if FCDataType <> AValue then begin
    FCDataType := AValue;
    FSizesUpdated := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.SetDataSize(const AValue: SQLUInteger);
begin
  if FDataSize <> AValue then begin
    FDataSize := AValue;
    FSizesUpdated := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.SetParamType(const AValue: SQLSmallint);
begin
  if FParamType <> AValue then begin
    FParamType := AValue;
    FSizesUpdated := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.SetSQLDataType(const AValue: SQLSmallint);
begin
  if FSQLDataType <> AValue then begin
    FSQLDataType := AValue;
    FSizesUpdated := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.GetDataPtr(AIndex: SQLUInteger; out ApData: SQLPointer;
  out ASize: SQLInteger; out ApInd: PSQLInteger): PSQLPointer;
begin
  ASSERT((FList <> nil) and (FList.FBuffer <> nil));
  FList.FBuffer.GetDataPtr(Self, AIndex, SQLPointer(Result), ApInd);
  if PSQLUInteger(ApInd)^ = SQL_NULL_DATA then
    ASize := 0
  else
    ASize := PSQLUInteger(ApInd)^;
  if LongData then begin
    ASSERT((ASize < SQL_LEN_DATA_AT_EXEC_OFFSET) or (ASize >= 0));
    ApData := Result^;
    if ApData = nil then
      ASize := 0
    else if ASize < SQL_LEN_DATA_AT_EXEC_OFFSET then
      ASize := SQL_LEN_DATA_AT_EXEC_OFFSET - ASize;
  end
  else
    ApData := Result;
  ASSERT((Result <> nil) and (ASize >= 0));
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.Bind;
begin
  ASSERT((FList <> nil) and (FList.FBuffer <> nil) and FList.FBuffer.FIsAllocated);
  if not FSizesUpdated then
    UpdateSizes;
  if IsParameter then
    TODBCCommandStatement(FList.Owner).BindParameter(Self)
  else if not LongData then
    FList.Owner.BindCol(Self);
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.VarTypeUnsup(ACType: SQLSmallint);
begin
  ADException(FList.FOwner.OwningObj, [S_AD_LPhys, S_AD_ODBCId],
    er_AD_OdbcVarDataTypeUnsup, [GetDumpLabel, ACType]);
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.GetDecimalSeparator: Char;
begin
  with TODBCConnection(FList.FOwner.FOwner) do
    if IsParameter then
      Result := DecimalSepPar
    else
      Result := DecimalSepCol;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.GetData(AIndex: SQLUInteger; var ApData: SQLPointer;
  var ALSize: SQLUInteger; AByRef: Boolean = False): Boolean;
var
  pData: SQLPointer;
  pInd: PSQLInteger;
begin
  GetDataPtr(AIndex, pData, ALSize, pInd);
  if (PSQLUInteger(pInd)^ = SQL_NULL_DATA) or (pData = nil) then begin
    Result := False;
    ALSize := 0;
    if AByRef then
      ApData := nil;
  end
  else begin
    Result := True;
    case CDataType of
    SQL_C_STINYINT,
    SQL_C_UTINYINT,
    SQL_C_TINYINT:
      if AByRef then
        ApData := pData
      else if ApData <> nil then
        PSQLChar(ApData)^ := PSQLChar(pData)^;
    SQL_C_SSHORT,
    SQL_C_USHORT,
    SQL_C_SHORT:
      if AByRef then
        ApData := pData
      else if ApData <> nil then
        PSQLSmallint(ApData)^ := PSQLSmallint(pData)^;
    SQL_C_SLONG,
    SQL_C_ULONG,
    SQL_C_LONG:
      if AByRef then
        ApData := pData
      else if ApData <> nil then
        PSQLInteger(ApData)^ := PSQLInteger(pData)^;
    SQL_C_SBIGINT,
    SQL_C_UBIGINT:
      if AByRef then
        ApData := pData
      else if ApData <> nil then
        PSQLBigInt(ApData)^ := PSQLBigInt(pData)^;
    SQL_C_BIT:
      if AByRef then
        ApData := pData
      else begin
        ALSize := SizeOf(WordBool);
        if not AByRef and (ApData <> nil) then
          PWordBool(ApData)^ := (PSQLByte(pData)^ <> 0);
      end;
    SQL_C_FLOAT:
      if AByRef then
        ApData := pData
      else if ApData <> nil then
        PSQLReal(ApData)^ := PSQLReal(pData)^;
    SQL_C_DOUBLE:
      if AByRef then
        ApData := pData
      else if ApData <> nil then
        PSQLDouble(ApData)^ := PSQLDouble(pData)^;
    SQL_C_BINARY:
      if AByRef then
        ApData := pData
      else if ApData <> nil then
        ADMove(PSQLChar(pData)^, PSQLChar(ApData)^, ALSize);
    SQL_C_CHAR:
      begin
        if ALSize = SQL_NTS then
          ALSize := StrLen(PChar(pData));
        case SQLDataType of
        SQL_NUMERIC,
        SQL_DECIMAL:
          if AByRef then
            ApData := pData
          else if ApData <> nil then begin
            ADStr2BCD(PChar(pData), ALSize, PADBcd(ApData)^, DecimalSeparator);
            ALSize := SizeOf(TADBcd);
          end;
        else
          begin
            if (SQLDataType = SQL_CHAR) and FList.FOwner.StrsTrim then
              while (ALSize > 0) and (PAnsiChar(pData)[ALSize - 1] <= ' ') do
                Dec(ALSize);
            if (ALSize = 0) and FList.FOwner.StrsEmpty2Null then begin
              Result := False;
              ALSize := 0;
              if AByRef then
                ApData := nil;
            end
            else if AByRef then
              ApData := pData
            else if ApData <> nil then begin
              ADMove(PSQLChar(pData)^, PSQLChar(ApData)^, ALSize * SizeOf(AnsiChar));
              if (SQLDataType = SQL_CHAR) and (ALSize < DataSize) then
                ADFillChar((PAnsiChar(ApData) + ALSize)^, (DataSize - ALSize) * SizeOf(AnsiChar), #0);
            end;
          end;
        end;
      end;
    SQL_C_WCHAR:
      begin
        if ALSize = SQL_NTS then
          ALSize := ADWideStrLen(PWideChar(pData))
        else
          ALSize := ALSize div SizeOf(WideChar);
        if (SQLDataType = SQL_WCHAR) and FList.FOwner.StrsTrim then
          while (ALSize > 0) and (PWideChar(pData)[ALSize - 1] = ' ') do
            Dec(ALSize);
        if (ALSize = 0) and FList.FOwner.StrsEmpty2Null then begin
          Result := False;
          ALSize := 0;
          if AByRef then
            ApData := nil;
        end
        else if AByRef then
          ApData := pData
        else if ApData <> nil then begin
          ADMove(PSQLWChar(pData)^, PSQLWChar(ApData)^, ALSize * SizeOf(WideChar));
          if (SQLDataType = SQL_WCHAR) and (ALSize < DataSize) then
            ADFillChar((PWideChar(ApData) + ALSize)^, (DataSize - ALSize) * SizeOf(WideChar), #0);
        end;
      end;
    SQL_C_TYPE_DATE,
    SQL_C_DATE:
      begin
        ALSize := SizeOf(LongWord);
        if AByRef then
          ApData := pData
        else if ApData <> nil then
          with PSQLDateStruct(pData)^ do
            PLongWord(ApData)^ := LongWord(Trunc(EncodeDate(Year, Month, Day) + DateDelta));
      end;
    SQL_C_TYPE_TIME,
    SQL_C_TIME:
      begin
        ALSize := SizeOf(LongWord);
        if AByRef then
          ApData := pData
        else if ApData <> nil then
          with PSQLTimeStruct(pData)^ do
            PLongWord(ApData)^ := (Second + Minute * 60 + Hour * 3600) * 1000;
      end;
    SQL_C_TYPE_TIMESTAMP,
    SQL_C_TIMESTAMP:
      if AByRef then
        ApData := pData
      else if ApData <> nil then
        with PODBCTimeStamp(pData)^ do begin
          PADSQLTimeStamp(ApData)^.Year := Year;
          PADSQLTimeStamp(ApData)^.Month := Month;
          PADSQLTimeStamp(ApData)^.Day := Day;
          PADSQLTimeStamp(ApData)^.Hour := Hour;
          PADSQLTimeStamp(ApData)^.Minute := Minute;
          PADSQLTimeStamp(ApData)^.Second := Second;
          PADSQLTimeStamp(ApData)^.Fractions := Fraction div 1000000;
        end;
    SQL_C_GUID:
      if AByRef then
        ApData := pData
      else if ApData <> nil then
        PGUID(ApData)^ := PGUID(pData)^;
    else
      // SQL_C_NUMERIC (output only), interval C data types
      VarTypeUnsup(CDataType);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.GetAsString: String;
var
  pVal: SQLPointer;
  iSz: SQLUInteger;
begin
  pVal := nil;
  iSz := 0;
  if GetData(0, pVal, iSz, True) then
    SetString(Result, PChar(pVal), iSz)
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.SetData(AIndex: SQLUInteger; ApData: SQLPointer; ALSize: SQLUInteger);
var
  pData: SQLPointer;
  pInd: PSQLInteger;
  iSize: SQLUInteger;
  iYear, iMonth, iDay: Word;
  iSeconds: LongWord;
  lIsNull: WordBool;
  p: PChar;
  i: SQLUInteger;

  procedure ErrorDataTooLarge(AMax, AActual: Integer);
  begin
    ADException(FList.FOwner.OwningObj, [S_AD_LPhys, S_AD_ODBCId],
      er_AD_OdbcDataToLarge, [GetDumpLabel, AMax, AActual]);
  end;

begin
  if LongData and IsParameter then
    if (ParamType in [SQL_PARAM_INPUT_OUTPUT, SQL_PARAM_OUTPUT]) and (ALSize < DataSize) then
      AllocLongData(AIndex, DataSize)
    else
      AllocLongData(AIndex, ALSize);

  GetDataPtr(AIndex, pData, iSize, pInd);
  if ApData = nil then begin
    lIsNull := True;
    iSize := SQL_NULL_DATA;
  end
  else
    lIsNull := False;
  case CDataType of
  SQL_C_STINYINT,
  SQL_C_UTINYINT,
  SQL_C_TINYINT:
    if lIsNull then
      PSQLChar(pData)^ := #0
    else begin
      PSQLChar(pData)^ := PSQLChar(ApData)^;
      iSize := SizeOf(SQLChar);
    end;
  SQL_C_SSHORT,
  SQL_C_USHORT,
  SQL_C_SHORT:
    if lIsNull then
      PSQLSmallint(pData)^ := 0
    else begin
      PSQLSmallint(pData)^ := PSQLSmallint(ApData)^;
      iSize := SizeOf(SQLSmallint);
    end;
  SQL_C_SLONG,
  SQL_C_ULONG,
  SQL_C_LONG:
    if lIsNull then
      PSQLInteger(pData)^ := 0
    else begin
      PSQLInteger(pData)^ := PSQLInteger(ApData)^;
      iSize := SizeOf(SQLInteger);
    end;
  SQL_C_SBIGINT,
  SQL_C_UBIGINT:
    if lIsNull then
      PSQLBigInt(pData)^ := 0
    else begin
      PSQLBigInt(pData)^ := PSQLBigInt(ApData)^;
      iSize := SizeOf(SQLBigInt);
    end;
  SQL_C_BIT:
    if lIsNull then
      PSQLByte(pData)^ := 0
    else begin
      PSQLByte(pData)^ := SQLByte(PWordBool(ApData)^ = True);
      iSize := SizeOf(SQLByte);
    end;
  SQL_C_FLOAT:
    if lIsNull then
      PSQLReal(pData)^ := 0.0
    else begin
      PSQLReal(pData)^ := PSQLReal(ApData)^;
      iSize := SizeOf(SQLReal);
    end;
  SQL_C_DOUBLE:
    if lIsNull then
      PSQLDouble(pData)^ := 0.0
    else begin
      PSQLDouble(pData)^ := PSQLDouble(ApData)^;
      iSize := SizeOf(SQLDouble);
    end;
  SQL_C_BINARY:
    if lIsNull then
      ADFillChar(PSQLChar(pData)^, DataSize, #0)
    else begin
      ADMove(PSQLChar(ApData)^, PSQLChar(pData)^, ALSize);
      iSize := ALSize;
      if not LongData and (SQLDataType = SQL_BINARY) and (iSize < DataSize) then begin
        ADFillChar((PChar(pData) + iSize)^, DataSize - iSize, #0);
        iSize := DataSize;
      end;
    end;
  SQL_C_CHAR:
    case SQLDataType of
    SQL_NUMERIC,
    SQL_DECIMAL:
      begin
        if lIsNull then begin
          if iSize > 0 then PChar(pData)[0] := '0';
          if iSize > 1 then PChar(pData)[1] := DecimalSeparator;
          if iSize > 2 then PChar(pData)[2] := '0';
          if iSize > 3 then PChar(pData)[3] := #0;
        end
        else
          ADBCD2Str(PChar(pData), iSize, PADBcd(ApData)^, DecimalSeparator);
        if iSize > DataSize then
          ErrorDataTooLarge(DataSize, iSize);
      end;
    else
      if lIsNull then
        ADFillChar(PChar(pData)^, DataSize, #0)
      else begin
        if ALSize = SQL_NTS then
          iSize := StrLen(PChar(ApData))
        else
          iSize := ALSize;
        if (iSize > DataSize) and not LongData then
          ErrorDataTooLarge(DataSize, iSize);
        if (SQLDataType = SQL_CHAR) and FList.FOwner.StrsTrim then
          while (iSize > 0) and (PChar(ApData)[iSize - 1] <= ' ') do
            Dec(iSize);
        ADMove(PChar(ApData)^, PChar(pData)^, iSize);
        if not LongData and (SQLDataType = SQL_CHAR) and (iSize < DataSize) then begin
          ADFillChar((PChar(pData) + iSize)^, DataSize - iSize, ' ');
          iSize := DataSize;
        end;
        if FList.FOwner.StrsEmpty2Null and (iSize = 0) then
          iSize := SQL_NULL_DATA;
      end;
    end;
  SQL_C_WCHAR:
    if lIsNull then
      ADFillChar(PWideChar(pData)^, DataSize, #0)
    else begin
      if ALSize = SQL_NTS then
        iSize := ADWideStrLen(PWideChar(ApData))
      else
        iSize := ALSize;
      if (iSize * SizeOf(WideChar) > DataSize) and not LongData then
        ErrorDataTooLarge(DataSize, iSize * SizeOf(WideChar));
      if (SQLDataType = SQL_WCHAR) and FList.FOwner.StrsTrim then
        while (iSize > 0) and (PWideChar(ApData)[iSize - 1] = ' ') do
          Dec(iSize);
      ADMove(PWideChar(ApData)^, PWideChar(pData)^, iSize * SizeOf(WideChar));
      if not LongData and (SQLDataType = SQL_WCHAR) and (iSize < DataSize div SizeOf(WideChar)) then begin
        p := PChar(pData) + iSize * SizeOf(WideChar);
        for i := ALSize to DataSize div SizeOf(WideChar) do begin
          p^ := #0;
          Inc(p);
          p^ := ' ';
          Inc(p);
        end;
        iSize := DataSize div SizeOf(WideChar);
      end;
      if FList.FOwner.StrsEmpty2Null and (iSize = 0) then
        iSize := SQL_NULL_DATA
      else
        iSize := iSize * SizeOf(WideChar);
    end;
  SQL_C_TYPE_DATE,
  SQL_C_DATE:
    if lIsNull then
      ADFillChar(PSQLDateStruct(pData)^, SizeOf(TSQLDateStruct), #0)
    else begin
      iYear := 0;
      iMonth := 0;
      iDay := 0;
      DecodeDate(PSQLInteger(ApData)^ - DateDelta, iYear, iMonth, iDay);
      with PSQLDateStruct(pData)^ do begin
        Year  := iYear;
        Month := iMonth;
        Day   := iDay;
      end;
      iSize := SizeOf(TSQLDateStruct);
    end;
  SQL_C_TYPE_TIME,
  SQL_C_TIME:
    if lIsNull then
      ADFillChar(PSQLTimeStruct(pData)^, SizeOf(TSQLTimeStruct), #0)
    else begin
      iSeconds := LongWord(ApData^) div 1000;
      with PSQLTimeStruct(pData)^ do begin
        Hour   := SQLUSmallint(iSeconds div 3600);
        Minute := SQLUSmallint((iSeconds div 60) mod 60);
        Second := SQLUSmallint(iSeconds mod 60);
      end;
      iSize := SizeOf(TSQLTimeStruct);
    end;
  SQL_C_TYPE_TIMESTAMP,
  SQL_C_TIMESTAMP:
    if lIsNull then
      ADFillChar(PODBCTimeStamp(pData)^, SizeOf(TADSQLTimeStamp), #0)
    else begin
      with PODBCTimeStamp(pData)^ do begin
        Year     := PADSQLTimeStamp(ApData)^.Year;
        Month    := PADSQLTimeStamp(ApData)^.Month;
        Day      := PADSQLTimeStamp(ApData)^.Day;
        Hour     := PADSQLTimeStamp(ApData)^.Hour;
        Minute   := PADSQLTimeStamp(ApData)^.Minute;
        Second   := PADSQLTimeStamp(ApData)^.Second;
        Fraction := PADSQLTimeStamp(ApData)^.Fractions * 1000000;
      end;
      iSize := SizeOf(TODBCTimeStamp);
    end;
  SQL_C_GUID:
    if lIsNull then
      ADFillChar(PSQLGUID(pData)^, SizeOf(TSQLGUID), #0)
    else begin
      PGUID(pData)^ := PGUID(ApData)^;
      iSize := SizeOf(TSQLGUID);
    end;
  else
    // SQL_C_NUMERIC (output only), interval C data types
    VarTypeUnsup(CDataType);
  end;
  if not LongData or (IsParameter and (ParamType in [SQL_PARAM_INPUT_OUTPUT, SQL_PARAM_OUTPUT])) then
    PSQLInteger(pInd)^ := iSize
  else if iSize <> SQL_NULL_DATA then
    PSQLInteger(pInd)^ := SQL_LEN_DATA_AT_EXEC(iSize)
  else
    PSQLInteger(pInd)^ := SQL_NULL_DATA;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.UpdateLongData;
begin
  FLongData := False;
  case FCDataType of
  SQL_C_CHAR,
  SQL_C_WCHAR,
  SQL_C_BINARY:
    case FSQLDataType of
    SQL_LONGVARCHAR,
    SQL_WLONGVARCHAR,
    SQL_LONGVARBINARY,
    SQL_DB2DBCLOB,
    SQL_DB2BLOB,
    SQL_DB2CLOB,
    SQL_SS_VARIANT:
      FLongData := True;
    SQL_CHAR,
    SQL_VARCHAR,
    SQL_BINARY,
    SQL_VARBINARY,
    SQL_WCHAR,
    SQL_WVARCHAR:
      begin
        ASSERT(FList <> nil);
        FLongData := not IsParameter and (DataSize > FList.FOwner.InrecDataSize);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.AllocLongData(AIndex, ALSize: SQLUInteger);
var
  pBuffer: SQLPointer;
  ppBuffer: PSQLPointer;
  pInd: PSQLInteger;
  iPrevSize: SQLInteger;
begin
  ASSERT(LongData);
  if CDataType = SQL_C_WCHAR then
    ALSize := ALSize * SizeOf(WideChar);
  ppBuffer := GetDataPtr(AIndex, pBuffer, iPrevSize, pInd);
  if pBuffer = nil then
    GetMem(ppBuffer^, ALSize)
  else
    ReallocMem(ppBuffer^, ALSize);
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.FreeLongData(AIndex: SQLUInteger);
var
  pBuffer: SQLPointer;
  ppBuffer: PSQLPointer;
  pInd: PSQLInteger;
  iPrevSize: SQLInteger;
begin
  ASSERT(LongData);
  ppBuffer := GetDataPtr(AIndex, pBuffer, iPrevSize, pInd);
  if pBuffer <> nil then begin
    FreeMem(pBuffer);
    ppBuffer^ := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.GetIsParameter: Boolean;
begin
  Result := FParamType <> SQL_RESULT_COL;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.GetSQLVariant: Boolean;
begin
  Result := FSQLDataType = SQL_SS_VARIANT;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.GetLongData: Boolean;
begin
  if not FSizesUpdated then
    UpdateSizes;
  Result := FLongData;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.CalcDataSize(AColumnSize: SQLUInteger): SQLInteger;
begin
  case CDataType of
  SQL_C_SLONG,
  SQL_C_ULONG,
  SQL_C_LONG:
    Result := SizeOf(SQLInteger);
  SQL_C_SBIGINT,
  SQL_C_UBIGINT:
    Result := SizeOf(SQLBigInt);
  SQL_C_BIT,
  SQL_C_TINYINT,
  SQL_C_STINYINT,
  SQL_C_UTINYINT:
    Result := SizeOf(SQLByte);
  SQL_C_SHORT,
  SQL_C_SSHORT,
  SQL_C_USHORT:
    Result := SizeOf(SQLSmallint);
  SQL_C_CHAR:
    begin
      case SQLDataType of
      SQL_DECIMAL,
      SQL_NUMERIC:
        if AColumnSize = 0 then
          Result := IDefNumericSize
        else
          Result := AColumnSize + 2;
      SQL_CHAR,
      SQL_VARCHAR:
        if AColumnSize = 0 then
          Result := IDefStrSize
        else
          Result := AColumnSize;
      else
        if ParamType = SQL_PARAM_INPUT then
          Result := IDefLongSize
        else
          Result := IDefStrSize;
      end;
      if Result <> MAXINT then
        if Result <> IDefLongSize then
          Inc(Result, SizeOf(AnsiChar));
    end;
  SQL_C_WCHAR:
    begin
      case SQLDataType of
      SQL_WCHAR,
      SQL_WVARCHAR:
        if AColumnSize = 0 then
          Result := IDefStrSize
        else
          Result := AColumnSize;
      else
        if ParamType = SQL_PARAM_INPUT then
          Result := IDefLongSize
        else
          Result := IDefStrSize;
      end;
      if Result <> MAXINT then begin
        Result := Result * SizeOf(SQLWChar);
        if Result <> IDefLongSize * SizeOf(SQLWChar) then
          Inc(Result, SizeOf(WideChar));
      end;
    end;
  SQL_C_FLOAT,
  SQL_C_DOUBLE:
    Result := SizeOf(SQLDouble);
  SQL_C_GUID:
    Result := SizeOf(SQLGUID);
  SQL_C_BINARY:
    case FSQLDataType of
    SQL_BINARY,
    SQL_VARBINARY:
      if AColumnSize = 0 then
        Result := IDefStrSize
      else
        Result := AColumnSize;
    else
      if ParamType = SQL_PARAM_INPUT then
        Result := IDefLongSize
      else
        Result := IDefStrSize;
    end;
  SQL_C_DATE,
  SQL_C_TYPE_DATE:
    Result := SizeOf(SQL_DATE_STRUCT);
  SQL_C_TIME,
  SQL_C_TYPE_TIME:
    Result := SizeOf(SQL_TIME_STRUCT);
  SQL_C_TYPE_TIMESTAMP,
  SQL_C_TIMESTAMP:
    Result := SizeOf(SQL_TIMESTAMP_STRUCT);
  SQL_C_INTERVAL_YEAR..
  SQL_C_INTERVAL_MINUTE_TO_SECOND:
    Result := SQL_INTERVAL_COLSIZE;
  else
    Result := 0;
    VarTypeUnsup(CDataType);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariable.UpdateSizes;
var
  iMaxCharSize, iMaxByteSize: Integer;
begin
  if FSizesUpdated then
    Exit;

  if (FSQLDataType = SQL_CHAR) or (FSQLDataType = SQL_VARCHAR) or
     (FSQLDataType = SQL_BINARY) or (FSQLDataType = SQL_VARBINARY) or
     (FSQLDataType = SQL_WVARCHAR) or (FSQLDataType = SQL_WCHAR) then begin
    ASSERT((FList <> nil) and (FList.Owner <> nil));
    if FColumnSize = 0 then
      FColumnSize := FList.Owner.FStrsMaxSize;
    FDataSize := CalcDataSize(FColumnSize);
    with TODBCConnection(FList.Owner.Owner) do
      if Assigned(OnGetMaxSizes) then begin
        iMaxCharSize := 0;
        iMaxByteSize := 0;
        OnGetMaxSizes(FCDataType,
          (FSQLDataType = SQL_CHAR) or (FSQLDataType = SQL_WCHAR) or (FSQLDataType = SQL_BINARY),
          (FSQLDataType = SQL_NUMERIC) or (FSQLDataType = SQL_DECIMAL),
          iMaxCharSize, iMaxByteSize);
        if (iMaxCharSize > 0) and ((FColumnSize = 0) or (FColumnSize > iMaxCharSize)) then
          FColumnSize := iMaxCharSize;
        if (iMaxByteSize > 0) and ((FDataSize = 0) or (FDataSize > iMaxByteSize)) then
          if FCDataType = SQL_C_CHAR then
            FDataSize := iMaxByteSize + SizeOf(SQLChar)
          else if FCDataType = SQL_C_WCHAR then
            FDataSize := iMaxByteSize + SizeOf(SQLWChar)
          else
            FDataSize := iMaxByteSize;
      end;
  end

  else if (FCDataType = SQL_C_TYPE_TIMESTAMP) or (FCDataType = SQL_C_TIMESTAMP) then begin
    FColumnSize := 23;
    FScale := 3;
    FDataSize := CalcDataSize(FColumnSize);
  end

  else if (FSQLDataType = SQL_NUMERIC) or (FSQLDataType = SQL_DECIMAL) then begin
    if FColumnSize = 0 then
      FColumnSize := IDefNumericSize;
    if FScale = 0 then
      if FColumnSize > C_DEF_NUM_SCALE then
        FScale := C_DEF_NUM_SCALE
      else
        FScale := SQLSmallint(FColumnSize);
    FDataSize := CalcDataSize(FColumnSize);
  end

  else if (ParamType = SQL_PARAM_OUTPUT) and (
      (FSQLDataType = SQL_LONGVARCHAR) or (FSQLDataType = SQL_WLONGVARCHAR) or
      (FSQLDataType = SQL_LONGVARBINARY)) then begin
    FDataSize := 8000;
    FColumnSize := FDataSize;
    if FSQLDataType = SQL_WLONGVARCHAR then
      FColumnSize := FColumnSize div SizeOf(SQLWChar);
  end

  else
    FDataSize := CalcDataSize(FColumnSize);

  UpdateLongData;
  FSizesUpdated := True;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.GetDumpLabel: string;
begin
{$IFDEF AnyDAC_MONITOR}
  if FDumpLabel <> '' then
    Result := FDumpLabel
  else
{$ENDIF}  
  if Name <> '' then
    Result := Name
  else
    Result := '#' + IntToStr(Position);
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
function TODBCVariable.DumpValue(AIndex: SQLUInteger; var ASize: SQLUInteger): String;
var
  pData: SQLPointer;
  ws: WideString;
begin
  pData := nil;
  if not GetData(AIndex, pData, ASize, True) then
    Result := 'NULL'
  else begin
    case CDataType of
    SQL_C_UTINYINT:
      Result := Format('%u', [UChar(pData^)]);
    SQL_C_STINYINT,
    SQL_C_TINYINT:
      Result := Format('%d', [SChar(pData^)]);
    SQL_C_USHORT:
      Result := Format('%u', [UShort(pData^)]);
    SQL_C_SSHORT,
    SQL_C_SHORT:
      Result := Format('%d', [SShort(pData^)]);
    SQL_C_ULONG:
      Result := Format('%u', [ULong(pData^)]);
    SQL_C_SLONG,
    SQL_C_LONG:
      Result := Format('%d', [SLong(pData^)]);
    SQL_C_UBIGINT:
      Result := Format('%u', [SQLUBigInt(pData^)]);
    SQL_C_SBIGINT:
      Result := Format('%d', [SQLBigInt(pData^)]);
    SQL_C_BIT:
      if PSQLByte(pData)^ <> 0 then
        Result := S_AD_True
      else
        Result := S_AD_False;
    SQL_C_FLOAT:
      Result := Format('%f', [SFloat(pData^)]);
    SQL_C_DOUBLE:
      Result := Format('%f', [SDouble(pData^)]);
    SQL_C_BINARY:
      if ASize > 512 then begin
        SetLength(Result, 1024);
        BinToHex(PChar(pData), PChar(Result), 512);
        Result := '(truncated at 512) ' + Result + ' ...';
      end
      else begin
        SetLength(Result, ASize * 2);
        BinToHex(PChar(pData), PChar(Result), ASize);
      end;
    SQL_C_CHAR:
      if ASize > 1024 then begin
        SetString(Result, PChar(pData), 1024);
        Result := '(truncated at 1024) ''' + Result + ' ...''';
      end
      else begin
        SetString(Result, PChar(pData), ASize);
        Result := '''' + Result + '''';
      end;
    SQL_C_WCHAR:
      if ASize > 1024 then begin
        SetString(ws, PWideChar(pData), 1024);
        Result := '(truncated at 1024) ''' + ws + ' ...''';
      end
      else begin
        SetString(ws, PWideChar(pData), ASize);
        Result := '''' + ws + '''';
      end;
    SQL_C_TYPE_DATE,
    SQL_C_DATE:
      with PSQLDateStruct(pData)^ do
        Result := Format('%d-%d-%d', [Year, Month, Day]);
    SQL_C_TYPE_TIME,
    SQL_C_TIME:
      with PSQLTimeStruct(pData)^ do
        Result := Format('%d:%d:%d', [Hour, Minute, Second]);
    SQL_C_TYPE_TIMESTAMP,
    SQL_C_TIMESTAMP:
      with PODBCTimeStamp(pData)^ do
        Result := Format('%d-%d-%d %d:%d:%d (%d)', [Year, Month, Day, Hour, Minute, Second, Fraction]);
    SQL_C_GUID:
        Result := GUIDToString(PGUID(pData)^);
    else
      // SQL_C_NUMERIC (output only), interval C data types
      VarTypeUnsup(CDataType);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.DumpCDataType: String;
begin
  case CDataType of
  SQL_C_STINYINT:       Result := 'STINYINT';
  SQL_C_UTINYINT:       Result := 'UTINYINT';
  SQL_C_TINYINT:        Result := 'TINYINT';
  SQL_C_SSHORT:         Result := 'SSHORT';
  SQL_C_USHORT:         Result := 'USHORT';
  SQL_C_SHORT:          Result := 'SHORT';
  SQL_C_SLONG:          Result := 'SLONG';
  SQL_C_ULONG:          Result := 'ULONG';
  SQL_C_LONG:           Result := 'LONG';
  SQL_C_SBIGINT:        Result := 'SBIGINT';
  SQL_C_UBIGINT:        Result := 'UBIGINT';
  SQL_C_BIT:            Result := 'BIT';
  SQL_C_FLOAT:          Result := 'FLOAT';
  SQL_C_DOUBLE:         Result := 'DOUBLE';
  SQL_C_BINARY:         Result := 'BINARY';
  SQL_C_CHAR:           Result := 'CHAR';
  SQL_C_WCHAR:          Result := 'WCHAR';
  SQL_C_TYPE_DATE:      Result := 'TYPE_DATE';
  SQL_C_DATE:           Result := 'DATE';
  SQL_C_TYPE_TIME:      Result := 'TYPE_TIME';
  SQL_C_TIME:           Result := 'TIME';
  SQL_C_TYPE_TIMESTAMP: Result := 'TYPE_TIMESTAMP';
  SQL_C_TIMESTAMP:      Result := 'TIMESTAMP';
  SQL_C_GUID:           Result := 'GUID';
  else                  Result := '#' + IntToStr(CDataType);
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCVariable.DumpParamType: String;
begin
  case ParamType of
  SQL_PARAM_TYPE_UNKNOWN: Result := 'UNKNOWN';
  SQL_PARAM_INPUT:        Result := 'INPUT';
  SQL_PARAM_INPUT_OUTPUT: Result := 'INPUT_OUTPUT';
  SQL_RESULT_COL:         Result := 'RESULT_COL';
  SQL_PARAM_OUTPUT:       Result := 'OUTPUT';
  SQL_RETURN_VALUE:       Result := 'RETURN_VALUE';
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TODBCVariableList                                                             }
{-------------------------------------------------------------------------------}
constructor TODBCVariableList.Create(AOwner: TODBCStatementBase);
begin
  ASSERT(AOwner <> nil);
  inherited Create;
  FList := TList.Create;
  FOwner := AOwner;
  FParameters := False;
end;

{-------------------------------------------------------------------------------}
destructor TODBCVariableList.Destroy;
begin
  Clear;
  FreeAndNil(FList);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariableList.Bind(APageBufferClass: TODBCPageBufferClass;
  ARowCount: SQLUInteger; AFixedLenOnly: Boolean);
begin
  ASSERT(Count > 0);
  if FBuffer = nil then
    FBuffer := APageBufferClass.Create(Self);
  if (FBuffer.RowCount <> ARowCount) or not FBuffer.FIsAllocated then begin
    if FBuffer.FIsAllocated then
      FBuffer.FreeBuffers;
    FBuffer.FRowCount := ARowCount;
    FBuffer.AllocBuffers;
    Rebind(AFixedLenOnly);
  end;
  FHasLongs := HasLongVariables;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariableList.Rebind(AFixedLenOnly: Boolean = False);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    with Items[i] do
      if not (AFixedLenOnly and ((CDataType = SQL_C_CHAR) or
         (CDataType = SQL_C_WCHAR) or (CDataType = SQL_C_BINARY))) or
         (ParamType in [SQL_PARAM_INPUT, SQL_PARAM_INPUT_OUTPUT]) then
        Bind
end;

{-------------------------------------------------------------------------------}
function TODBCVariableList.Add(AVariable: TODBCVariable): TODBCVariable;
begin
  Result := AVariable;
  FList.Add(AVariable);
  AVariable.FList := Self;
  if not Parameters then
    AVariable.ParamType := SQL_RESULT_COL
  else
    AVariable.ParamType := SQL_PARAM_INPUT;
end;

{-------------------------------------------------------------------------------}
procedure TODBCVariableList.Clear;
var
  i: Integer;
begin
  // do not use FreeAndNill here, because destructor will call methods
  // checking FBuffer reference is not nil
  if FBuffer <> nil then begin
    FBuffer.Free;
    FBuffer := nil;
  end;
  for i := 0 to FList.Count - 1 do
    TODBCVariable(FList[i]).Free;
  FList.Clear;
end;

{-------------------------------------------------------------------------------}
function TODBCVariableList.GetCount: Integer;
begin
  Result := FList.Count;
end;

{-------------------------------------------------------------------------------}
function TODBCVariableList.GetItems(AIndex: Integer): TODBCVariable;
begin
  Result := TODBCVariable(FList[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TODBCVariableList.HasLongVariables: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Count - 1 do
    if Items[i].LongData then begin
      Result := True;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
{ TODBCPageBuffer                                                               }
{-------------------------------------------------------------------------------}
constructor TODBCPageBuffer.Create(AVarList: TODBCVariableList);
begin
  ASSERT(AVarList <> nil);
  inherited Create;
  FVariableList := AVarList;
  AVarList.FBuffer := Self;
  FRowCount := 1;
end;

{-------------------------------------------------------------------------------}
destructor TODBCPageBuffer.Destroy;
begin
  FreeBuffers;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TODBCPageBuffer.AllocBuffers;
begin
  ASSERT(not FIsAllocated);
  FIsAllocated := True;
  SetStmtAttributes;
end;

{-------------------------------------------------------------------------------}
procedure TODBCPageBuffer.FreeBuffers;
var
  i, j: Integer;
  oVar: TODBCVariable;
begin
  ASSERT(FIsAllocated and (FVariableList.FBuffer = Self));
  FIsAllocated := False;
  for i := 0 to FVariableList.Count - 1 do begin
    oVar := FVariableList[i];
    if oVar.LongData then
      for j := 0 to FRowCount - 1 do
        oVar.FreeLongData(j);
  end;
  FRowCount := 1;
  { TODO : remove next line ? }
  FVariableList.FBuffer := nil;
end;

{-------------------------------------------------------------------------------}
function TODBCPageBuffer.GetPageSize: SQLUInteger;
begin
  Result := RowSize * RowCount;
end;

{-------------------------------------------------------------------------------}
function TODBCPageBuffer.GetRowSize: SQLUInteger;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FVariableList.Count - 1 do
    with FVariableList[i] do
      if not LongData then
        Inc(Result, DataSize + SizeOf(SQLInteger))
      else
        Inc(Result, SizeOf(Pointer) + SizeOf(SQLInteger));
end;

{-------------------------------------------------------------------------------}
function TODBCPageBuffer.GetRowStatusArr(AIndex: SQLUInteger): SQLUSmallint;
begin
  ASSERT(AIndex < FRowCount);
  Result := FRowStatusArr[AIndex];
end;

{-------------------------------------------------------------------------------}
procedure TODBCPageBuffer.SetStmtAttributes;
begin
  if FVariableList.Parameters then
    with TODBCCommandStatement(FVariableList.Owner) do begin
      if FParamSetSupported then begin
        PARAMSET_SIZE := FRowCount;
        SetLength(FRowStatusArr, FRowCount);
        PARAM_STATUS_PTR := @FRowStatusArr[0];
      end;
      PARAMS_PROCESSED_PTR := @FRowsProcessed;
    end
  else
    with FVariableList.Owner do begin
      ROW_ARRAY_SIZE := FRowCount;
      SetLength(FRowStatusArr, FRowCount);
      ROW_STATUS_PTR := @FRowStatusArr[0];
      ROWS_FETCHED_PTR := @FRowsProcessed;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCPageBuffer.GetDataPtr(AVar: TODBCVariable; AIndex: SQLUInteger;
  out ApData: SQLPointer; out ApIndicator: PSQLInteger);
begin
  ASSERT(False);
end;

{-------------------------------------------------------------------------------}
procedure TODBCPageBuffer.ShiftBuffersPtr(ARowCount: SQLUInteger);
begin
  ASSERT(False);
end;

{-------------------------------------------------------------------------------}
{ TODBCRowWiseBuffer                                                            }
{-------------------------------------------------------------------------------}
procedure TODBCRowWiseBuffer.AllocBuffers;
var
  i, j: Integer;
  pBuffer: SQLPointer;
  pInd: PSQLInteger;
  iPrevSize: SQLInteger;
begin
  inherited AllocBuffers;
  GetMem(FCommonBuffer, PageSize);
  for i := 0 to FVariableList.Count - 1 do begin
    for j := 0 to FRowCount - 1 do begin
      GetDataPtr(FVariableList[i], j, pBuffer, pInd);
      pInd^ := SQL_NULL_DATA;
    end;
    with FVariableList[i] do begin
      LocalBuffer := GetDataPtr(0, pBuffer, iPrevSize, pInd);
      LocalBufIndicator := pInd;
      if LongData then
        for j := 0 to FRowCount - 1 do
          GetDataPtr(j, pBuffer, iPrevSize, pInd)^ := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCRowWiseBuffer.FreeBuffers;
var
  i: Integer;
begin
  inherited FreeBuffers;
  FreeMem(FCommonBuffer);
  FCommonBuffer := nil;
  for i := 0 to FVariableList.Count - 1 do
    with FVariableList[i] do begin
      LocalBuffer := nil;
      LocalBufIndicator := nil;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCRowWiseBuffer.GetDataPtr(AVar: TODBCVariable;
  AIndex: SQLUInteger; out ApData: SQLPointer; out ApIndicator: PSQLInteger);
var
  i: Integer;
  iOffset: LongWord;
  oVarCur: TODBCVariable;
begin
  ASSERT((FCommonBuffer <> nil) and (AIndex < FRowCount));
  { TODO : replace next with a map }
  iOffset := RowSize * AIndex;
  for i := 0 to FVariableList.Count - 1 do begin
    oVarCur := FVariableList[i];
    if oVarCur = AVar then
      Break;
    with oVarCur do
      if not LongData then
        Inc(iOffset, DataSize + SQLUInteger(SizeOf(SQLInteger)))
      else
        Inc(iOffset, SQLUInteger(SizeOf(Pointer)) + SQLUInteger(SizeOf(SQLInteger)));
  end;

  with AVar do begin
    ApData := ADAddOffset(FCommonBuffer, iOffset);
    if not LongData then
      ApIndicator := ADAddOffset(ApData, DataSize)
    else
      ApIndicator := ADAddOffset(ApData, SizeOf(Pointer));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCRowWiseBuffer.SetStmtAttributes;
begin
  with FVariableList do
    if Parameters then begin
      if TODBCCommandStatement(FVariableList.Owner).FParamSetSupported then
        TODBCCommandStatement(Owner).PARAM_BIND_TYPE := RowSize;
    end
    else
      Owner.ROW_BIND_TYPE := RowSize;
  inherited SetStmtAttributes;
end;

{-------------------------------------------------------------------------------}
procedure TODBCRowWiseBuffer.ShiftBuffersPtr(ARowCount: SQLUInteger);
var
  iOffset: SQLUInteger;
  i: Integer;
begin
  iOffset := ARowCount * RowSize;
  for i := 0 to FVariableList.Count - 1 do
    with FVariableList[i] do begin
      LocalBuffer := ADAddOffset(LocalBuffer, iOffset);
      LocalBufIndicator := ADAddOffset(LocalBufIndicator, iOffset);
    end;
end;

{-------------------------------------------------------------------------------}
{ TODBCColWiseBuffer                                                            }
{-------------------------------------------------------------------------------}
procedure TODBCColWiseBuffer.AllocBuffers;
var
  i: Integer;
  pLocal: Pointer;
begin
  inherited AllocBuffers;
  for i := 0 to FVariableList.Count - 1 do
    with FVariableList[i] do begin
      if LongData then begin
        GetMem(pLocal, SizeOf(Pointer) * RowCount);
        ADFillChar(pLocal^, SizeOf(Pointer) * RowCount, #0);
      end
      else
        GetMem(pLocal, DataSize * RowCount);
      LocalBuffer := pLocal;
      GetMem(pLocal, SizeOf(SQLInteger) * RowCount);
      ADFillChar(pLocal^, SizeOf(SQLInteger) * RowCount, #$FF);
      LocalBufIndicator := pLocal;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCColWiseBuffer.FreeBuffers;
var
  i: Integer;
begin
  inherited FreeBuffers;
  for i := 0 to FVariableList.Count - 1 do
    with FVariableList[i] do begin
      if LocalBuffer <> nil then begin
        FreeMem(LocalBuffer);
        LocalBuffer := nil;
      end;
      if LocalBufIndicator <> nil then begin
        FreeMem(LocalBufIndicator);
        LocalBufIndicator := nil;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCColWiseBuffer.GetDataPtr(AVar: TODBCVariable;
  AIndex: SQLUInteger; out ApData: SQLPointer; out ApIndicator: PSQLInteger);
begin
  with AVar do begin
    ASSERT((LocalBuffer <> nil) and (AIndex < FRowCount));
    if LongData then
      ApData := ADAddOffset(LocalBuffer, AIndex * SizeOf(Pointer))
    else
      ApData := ADAddOffset(LocalBuffer, AIndex * DataSize);
    ApIndicator := ADAddOffset(LocalBufIndicator, AIndex * SizeOf(SQLInteger));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCColWiseBuffer.SetStmtAttributes;
begin
  FVariableList.Owner.ROW_BIND_TYPE := SQL_BIND_BY_COLUMN;
  inherited SetStmtAttributes;
end;

{-------------------------------------------------------------------------------}
procedure TODBCColWiseBuffer.ShiftBuffersPtr(ARowCount: SQLUInteger);
var
  i: Integer;
begin
  for i := 0 to FVariableList.Count - 1 do
    with FVariableList[i] do begin
      if not LongData then
        LocalBuffer := ADAddOffset(LocalBuffer, DataSize * ARowCount)
      else
        LocalBuffer := ADAddOffset(LocalBuffer, SizeOf(SQLPointer) * ARowCount);
      LocalBufIndicator := ADAddOffset(LocalBufIndicator, SizeOf(SQLInteger) * ARowCount);
    end;
end;

{-------------------------------------------------------------------------------}
{ TODBCPieceList                                                                }
{-------------------------------------------------------------------------------}
destructor TODBCPieceList.Destroy;
begin
  if FBuffer <> nil then begin
    FreeMem(FBuffer);
    FBuffer := nil;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TODBCPieceList.CheckBuffer: Pointer;
begin
  if FBuffer = nil then
    GetMem(FBuffer, C_BLOB_BUFSIZE);
  Result := FBuffer;
end;

{-------------------------------------------------------------------------------}
procedure TODBCPieceList.GetJoinedBufferPtr(var ApBuffer: SQLPointer;
  var ASize: LongInt; APieceCount: Integer; ASizeOfLastPiece: LongInt);
var
  iSize: LongInt;
  pData: Pointer;
begin
  ASSERT(APieceCount <= C_BLOB_PIECENUM);
  if (APieceCount > 0) or (ASizeOfLastPiece > 0) then begin
    // remove terminated null
    if ASize > 0 then
      if FCDataType = SQL_C_CHAR then
        Dec(ASize, SizeOf(SQLChar))
      else if FCDataType = SQL_C_WCHAR then
        Dec(ASize, SizeOf(SQLWChar));

    iSize := ASize + APieceCount * GetPieceSize + ASizeOfLastPiece;
    if ApBuffer = nil then
      GetMem(ApBuffer, iSize)
    else
      ReallocMem(ApBuffer, iSize);
    if ASize > 0 then
      pData := ADAddOffset(ApBuffer, ASize)
    else
      pData := ApBuffer;
    ADMove(CheckBuffer()^, pData^, iSize - ASize);
    ASize := iSize;
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCPieceList.GetPiece(AIndex: Integer): SQLPointer;
begin
  ASSERT((AIndex < C_BLOB_PIECENUM) and (AIndex >= 0));
  Result := ADAddOffset(CheckBuffer(), AIndex * GetPieceSize);
end;

{-------------------------------------------------------------------------------}
function TODBCPieceList.GetPieceSize: LongInt;
begin
  case FCDataType of
  SQL_C_BINARY: Result := C_BLOB_PIECE;
  SQL_C_CHAR:   Result := C_BLOB_PIECE - SizeOf(SQLChar);
  else          Result := C_BLOB_PIECE - SizeOf(SQLWChar);
  end;
end;

{-------------------------------------------------------------------------------}
{ TODBCStatementBase                                                            }
{-------------------------------------------------------------------------------}
constructor TODBCStatementBase.Create(AOwner: TODBCConnection; AOwningObj: TObject);
begin
  inherited Create;
  FOwner := AOwner;
  FOwningObj := AOwningObj;
  FHandleType := SQL_HANDLE_STMT;
  FODBCLib := FOwner.Lib;
  AllocHandle;
  FColumnList := TODBCVariableList.Create(Self);
  FPieceList := TODBCPieceList.Create;
  FInrecDataSize := IDefInrecDataSize;
  FStrsTrim := False;
  FStrsEmpty2Null := True;
  FStrsMaxSize := C_AD_MaxDlp4StrSize;
end;

{-------------------------------------------------------------------------------}
destructor TODBCStatementBase.Destroy;
begin
  Unprepare;
  FreeAndNil(FColumnList);
  FreeAndNil(FPieceList);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TODBCStatementBase.GetPageBufferClass: TODBCPageBufferClass;
begin
  if FVarBindingKind = bkRowWise then
    Result := TODBCRowWiseBuffer
  else
    Result := TODBCColWiseBuffer;
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.ColAttributeInt(AColNum: SQLUSmallint;
  AFieldId: SQLUSmallint; var AAttr: SQLInteger);
begin
  Check(Lib.SQLColAttributeInt(FHandle, AColNum, AFieldId, nil, 0, nil, AAttr));
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.ColAttributeString(AColNum: SQLUSmallint;
  AFieldId: SQLUSmallint; var AAttr: String);
var
  iBufferLen: SQLSmallint;
  iStringLen: SQLSmallint;
begin
  iBufferLen := C_STRING_ATTR_MAXLEN;
  SetLength(AAttr, iBufferLen);
  iStringLen := 0;
  Check(Lib.SQLColAttributeString(FHandle, AColNum, AFieldId, SQLPointer(AAttr),
    iBufferLen, iStringLen, nil));
  ODBCSetLength(AAttr, iStringLen);
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.GetNonStrAttribute(AAttr: SQLInteger; ApValue: SQLPointer);
var
  iStringLen: SQLInteger;
begin
  iStringLen := 0;
  Check(Lib.SQLGetStmtAttr(FHandle, AAttr, ApValue, 0, iStringLen));
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.GetStrAttribute(AAttr: SQLInteger; out AValue: String);
var
  iBufferLen: SQLInteger;
  iStringLen: SQLInteger;
begin
  SetLength(AValue, SQL_MAX_MESSAGE_LENGTH);
  iBufferLen := SQL_MAX_MESSAGE_LENGTH;
  iStringLen := 0;
  Check(Lib.SQLGetStmtAttr(FHandle, AAttr, PChar(AValue), iBufferLen, iStringLen));
  ODBCSetLength(AValue, iStringLen);
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.SetAttribute(AAttr: SQLInteger; ApValue: SQLPointer;
  ACharData: Boolean = False);
var
  iStringLen: SQLInteger;
begin
  iStringLen := 0;
  if ACharData then
    iStringLen := Length(PChar(ApValue));
  Check(Lib.SQLSetStmtAttr(FHandle, AAttr, ApValue, iStringLen));
end;

{-------------------------------------------------------------------------------}
function TODBCStatementBase.GetCursorName: String;
var
  iBufferLen: SQLSmallint;
  iStringLen: SQLSmallint;
begin
  iBufferLen := Connection.GetInfoOptionSmInt(SQL_MAX_CURSOR_NAME_LEN);
  if iBufferLen = 0 then
    iBufferLen := 128; // FIPS Intermediate level–conformant value
  SetLength(Result, iBufferLen);
  iStringLen := 0;
  if Lib.SQLGetCursorName(FHandle, PSQLChar(Result), iBufferLen, iStringLen) = SQL_SUCCESS then
    ODBCSetLength(Result, iStringLen)
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.SetCursorName(const AValue: String);
begin
  Check(Lib.SQLSetCursorName(FHandle, PSQLChar(AValue), SQLSmallint(Length(AValue))));
end;

{-------------------------------------------------------------------------------}
function TODBCStatementBase.NumResultCols: SQLSmallint;
begin
  Result := 0;
  Check(Lib.SQLNumResultCols(FHandle, Result));
end;

{-------------------------------------------------------------------------------}
function TODBCStatementBase.ResultColsExists: Boolean;
var
  iCnt: SQLSmallint;
begin
  iCnt := 0;
  Result := (Lib.SQLNumResultCols(FHandle, iCnt) = SQL_SUCCESS) and (iCnt > 0);
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.DescribeCol(AColNum: SQLSmallint; var AName: String;
  var ADataType: SQLSmallint; var AColSize: SQLUInteger; var AScale: SQLSmallint;
  var ANullable: SQLSmallint);
var
  iNameLen: SQLSmallint;
  iColMaxLen: SQLUSmallint;
begin
  iColMaxLen := TODBCConnection(FOwner).MAX_COLUMN_NAME_LEN;
  if iColMaxLen < 128 then // FIPS Intermediate level–conformant value
    iColMaxLen := 128;
  SetLength(AName, iColMaxLen);
  iNameLen := 0;
  Check(Lib.SQLDescribeCol(FHandle, AColNum, PSQLChar(AName), iColMaxLen,
    iNameLen, ADataType, AColSize, AScale, ANullable));
  ODBCSetLength(AName, iNameLen);
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.BindCol(ABoundVariable: TODBCVariable);
begin
  with ABoundVariable do begin
    Check(Lib.SQLBindCol(FHandle, Position, CDataType, LocalBuffer, DataSize,
      LocalBufIndicator));
    FBinded := True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.BindColumns(ARowCount: SQLUInteger);
begin
  FColumnList.Bind(GetPageBufferClass, ARowCount, False);
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.UnbindColumns;
begin
  Check(Lib.SQLFreeStmt(FHandle, SQL_UNBIND));
  FColumnList.Clear;
end;

{-------------------------------------------------------------------------------}
function TODBCStatementBase.AddCol(APos, ASQLType, ACType: SQLSmallint;
  ALen: SQLUInteger): TODBCVariable;
begin
  Result := ColumnList.Add(TODBCVariable.Create);
  if ALen <> -1 then
    Result.ColumnSize := ALen;
  Result.SQLDataType := ASQLType;
  Result.CDataType := ACType;
  Result.Position := APos;
end;

{-------------------------------------------------------------------------------}
function TODBCStatementBase.FetchLongColumn(AVariable: TODBCVariable; AIndex: Integer;
  ASize: SQLInteger): SQLReturn;
var
  pBuffer: SQLPointer;
  pInd: PSQLInteger;
  iPrevSize: SQLInteger;
begin
  AVariable.GetDataPtr(AIndex, pBuffer, iPrevSize, pInd);
  with AVariable do
    Result := Lib.SQLGetData(FHandle, Position, CDataType, pBuffer, ASize, pInd);
  if (Result <> SQL_NO_DATA) and (Result <> SQL_SUCCESS_WITH_INFO) then
    Check(Result);
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.SetPos(ARowNum: SQLUSmallint; AOperation: SQLUSmallint;
  ALocktype: SQLUSmallint);
begin
  Check(Lib.SQLSetPos(FHandle, ARowNum, AOperation, ALockType));
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.FetchLongColumns(AIndex: SQLUSmallint);
var
  iPieceCount, i: Integer;
  lGetAll: Boolean;
  pBuffer: SQLPointer;
  ppBuffer: PSQLPointer;
  pInd: PSQLInteger;
  iLastSize, iCurSize, iFetchSize: LongInt;
  iSbType: SQLInteger;
  iDummy: Word;
  oVar: TODBCVariable;
  oBuffer: TODBCPageBuffer;
  iRet: SQLReturn;
begin
  oBuffer := FColumnList.FBuffer;
  for i := 0 to FColumnList.Count - 1 do begin
    oVar := FColumnList[i];
    with oVar do
      if LongData then begin
        if oBuffer.RowsProcessed > 1 then
          SetPos(SQLUSmallint(AIndex + 1), SQL_POSITION, SQL_LOCK_NO_CHANGE);
        if not SQLVariant then begin
          lGetAll := False;
          iPieceCount := -1;
          FPieceList.FCDataType := CDataType;
          ppBuffer := GetDataPtr(AIndex, pBuffer, iCurSize, pInd);
          if pBuffer <> nil then
            iFetchSize := iCurSize
          else
            iFetchSize := FPieceList.GetPieceSize;

          try

            repeat
              Inc(iPieceCount);
              if (iPieceCount > 0) or (pBuffer <> nil) then begin
                iRet := FetchLongColumn(oVar, AIndex, iFetchSize);
                lGetAll := (iRet = SQL_NO_DATA) or (PSQLUInteger(pInd)^ = SQL_NULL_DATA) or
                  ((pInd^ <= iFetchSize) and (pInd^ >= 0) and (iRet <> SQL_SUCCESS_WITH_INFO));
              end;

              if not lGetAll then begin
                if iPieceCount = C_BLOB_PIECENUM then begin
                  FPieceList.GetJoinedBufferPtr(pBuffer, iCurSize, iPieceCount, 0);
                  iPieceCount := 0;
                end;
                ppBuffer^ := FPieceList[iPieceCount];
              end;
              if iFetchSize <> C_BLOB_PIECE then
                iFetchSize := C_BLOB_PIECE;
            until lGetAll;

            if pInd^ > 0 then
              iLastSize := pInd^
            else
              iLastSize := 0;
            if iPieceCount >= 1 then begin
              FPieceList.GetJoinedBufferPtr(pBuffer, iCurSize, iPieceCount - 1, iLastSize);
              pInd^ := iCurSize;
              ppBuffer^ := pBuffer;
            end;

          except
            on E: EODBCNativeException do begin
              ppBuffer^ := nil;
              pInd^ := -1;
              raise
            end;
          end;

        end
        else begin
          ppBuffer := GetDataPtr(AIndex, pBuffer, iCurSize, pInd);
          ppBuffer^ := @iDummy;
          FetchLongColumn(oVar, AIndex, 0);
          ppBuffer^ := pBuffer;
          if pInd^ <> SQL_NULL_DATA then begin
            iSbType := 0;
            ColAttributeInt(Position, SQL_CA_SS_VARIANT_TYPE, iSbType);
            CVariantSbType := SQLSmallint(iSbType);

            if iCurSize < pInd^ then
              oVar.AllocLongData(AIndex, pInd^);
            FetchLongColumn(oVar, AIndex, pInd^);
          end;
        end;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TODBCStatementBase.Fetch(ARowCount: SQLUInteger = SQL_NULL_DATA): SQLUSmallint;
var
  iRet: SQLReturn;
  iLastFetched, iShifted: SQLUInteger;
  iRow: SQLUSmallint;
  oBuffer: TODBCPageBuffer;
begin
  ASSERT(ARowCount <= $FFFF);
  TODBCConnection(Owner).ClearInfo;
  if (ColumnList.FBuffer = nil) and (ColumnList.Count > 0) then
    BindColumns(ARowCount);
  oBuffer := FColumnList.FBuffer;

  Result := 0;
  iLastFetched := 0;
  iShifted := 0;
  iRow := 0;

  repeat
    if iLastFetched > 0 then begin
      oBuffer.ShiftBuffersPtr(iLastFetched);
      Inc(iShifted, iLastFetched);
      FColumnList.Rebind;
    end;
    iRet := Lib.SQLFetch(FHandle);
    if iRet = SQL_NO_DATA then
      iLastFetched := 0
    else begin
      Check(iRet);
      // RowsProcessed = 0 - this is a MySQL driver bug
      // RowsProcessed = 1 - 1 row fetched only - immediatelly FetchLongColumns,
      // if RDBMS table contains only 1 row - we will exit from the cycle in the next
      // iteration after iRet = SQL_NO_DATA
      if (oBuffer.RowsProcessed in [0, 1]) or
         (oBuffer.RowCount = 1) then begin
        iLastFetched := 1;
        FetchLongColumns(iRow);
      end
      else
        iLastFetched := oBuffer.RowsProcessed;
    end;
    Inc(Result, iLastFetched);
    Inc(iRow);
  until (ARowCount = SQL_NULL_DATA) or (Result = ARowCount) or (iLastFetched = 0) or
    (oBuffer.RowsProcessed > 1) or (oBuffer.RowCount = Result);

  if iShifted > 0 then begin
    oBuffer.ShiftBuffersPtr(-iShifted);
    FColumnList.Rebind;
  end;
  if oBuffer.RowsProcessed in [0, 1] then begin
    if Result > 0 then
      oBuffer.FRowsProcessed := Result
  end
  else if (Result > 0) and FColumnList.HasLongs then
    for iRow := 0 to SQLUSmallint(Result - 1) do
      FetchLongColumns(iRow);
{$IFDEF AnyDAC_MONITOR}
  DumpColumns(Result, ARowCount <> Result);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TODBCStatementBase.MoreResults: Boolean;
var
  iRes: SQLReturn;
begin
  iRes := Lib.SQLMoreResults(FHandle);
  Result := False;
  case iRes of
  SQL_SUCCESS:
    Result := True;
  SQL_SUCCESS_WITH_INFO:
    begin
      Result := True;
      Check(iRes);
    end;
  SQL_NO_DATA,
  SQL_ERROR,
  // SQLMoreResults cannot return SQL_NEED_DATA;
  // this line was added due to SyBase driver bug
  SQL_NEED_DATA:
    ;
  else
    Check(iRes);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.SkipEmptyResults;
var
  iRes: SQLReturn;
begin
  while NumResultCols = 0 do begin
    iRes := Lib.SQLMoreResults(FHandle);
    if (iRes <> SQL_SUCCESS) and (iRes <> SQL_SUCCESS_WITH_INFO) then
      Break;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.Cancel;
begin
  Check(Lib.SQLCancel(FHandle));
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.Close;
begin
  Check(Lib.SQLFreeStmt(FHandle, SQL_CLOSE));
  FIsExecuted := False;
end;

{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.Unprepare;
begin
  TODBCConnection(Owner).ClearInfo;
  Close;
  UnbindColumns;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TODBCStatementBase.DumpColumns(ARows: SQLUInteger; AEof: Boolean);
var
  i, j, n: Integer;
  iLen: SQLUInteger;
  sVal: String;
begin
  if Tracing and (ARows > 0) then begin
    for j := 0 to ARows - 1 do begin
      n := 1;
      Trace(ekCmdDataOut, esStart, 'Fetched', ['Row', j]);
      for i := 0 to FColumnList.Count - 1 do
        with FColumnList.Items[i] do begin
          iLen := 0;
          sVal := DumpValue(j, iLen);
          Trace(ekCmdDataOut, esProgress, 'Column',
            [String('N'), n, '@Type', DumpCDataType,
             'Size', ColumnSize, 'Len', iLen, '@Data', sVal]);
          Inc(n);
        end;
      Trace(ekCmdDataOut, esEnd, 'Fetched', ['Row', j]);
    end;
    if AEof then
      Trace(ekCmdDataOut, esProgress, 'EOF', []);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TODBCCommandStatement                                                         }
{-------------------------------------------------------------------------------}
constructor TODBCCommandStatement.Create(AOwner: TODBCConnection; AOwningObj: TObject);
begin
  inherited Create(AOwner, AOwningObj);
  FParamList := TODBCVariableList.Create(Self);
  FParamList.Parameters := True;
end;

{-------------------------------------------------------------------------------}
destructor TODBCCommandStatement.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FParamList);
end;

{-------------------------------------------------------------------------------}
function TODBCCommandStatement.GetPARAMSET_SIZE: SQLUInteger;
var
  iLen: SQLInteger;
begin
  iLen := 0;
  if Lib.SQLGetStmtAttr(FHandle, SQL_ATTR_PARAMSET_SIZE, @Result, 0, iLen) <> SQL_SUCCESS then
    Result := 1;
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.SetPARAMSET_SIZE(const AValue: SQLUInteger);
begin
  Lib.SQLSetStmtAttr(FHandle, SQL_ATTR_PARAMSET_SIZE, PSQLUInteger(AValue), 0);
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.BindParameter(AParam: TODBCVariable);
var
  hIpd: SQLHDesc;
begin
  with AParam do begin
    if SQLDataType = SQL_REFCURSOR then
      Exit;
    FBinded := False;
    if not LongData then begin
      FBinded := True;
      Check(Lib.SQLBindParameter(FHandle, Position, ParamType, CDataType, SQLDataType,
        ColumnSize, Scale, LocalBuffer, DataSize, LocalBufIndicator));
    end
    else if ParamType = SQL_PARAM_INPUT then begin
      FBinded := True;
      Check(Lib.SQLBindParameter(FHandle, Position, ParamType, CDataType, SQLDataType,
        High(SQLUInteger) div 2, 0, SQLPointer(Position), 0, LocalBufIndicator));
    end
    else if PSQLPointer(LocalBuffer)^ <> nil then begin
      FBinded := True;
      Check(Lib.SQLBindParameter(FHandle, Position, ParamType, CDataType, SQLDataType,
        High(SQLUInteger) div 2, 0, PSQLPointer(LocalBuffer)^, 0, LocalBufIndicator));
    end;
    if FBinded and (Name <> '') then begin
      Check(Lib.SQLGetStmtAttr(Handle, SQL_ATTR_IMP_PARAM_DESC, @hIpd, 0, Integer(nil^)));
      // do not check result code
      Lib.SQLSetDescField(hIpd, Position, SQL_DESC_NAME, PSQLChar(Name), SQL_NTS);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.BindParameters(ARowCount: Integer; AFixedLenOnly: Boolean);
begin
  FParamList.Bind(GetPageBufferClass, ARowCount, AFixedLenOnly);
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.UnbindParameters;
begin
  Check(Lib.SQLFreeStmt(Handle, SQL_RESET_PARAMS));
  FParamList.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.DoPutLongData(AIndex: Integer);
var
  iRet: SQLReturn;
  pParamNum: SQLPointer;
  iCurNum: SQLSmallint;
  pData: SQLPointer;
  iSize: SQLUInteger;
  pInd: PSQLInteger;
begin
  pParamNum := nil;
  iCurNum := SQLSmallint(pParamNum);
  iRet := SQL_SUCCESS;
  repeat
    if iCurNum = SQLSmallint(pParamNum) then
      iRet := ParamData(pParamNum);
    iCurNum := SQLSmallint(pParamNum);
    if iRet = SQL_NEED_DATA then begin
      FParamList[iCurNum - 1].GetDataPtr(AIndex, pData, iSize, pInd);
      PutData(pData, iSize);
      iRet := ParamData(pParamNum);
    end;
  until iRet <> SQL_NEED_DATA;
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.Execute(ARowCount, AOffset: SQLUInteger;
  var ACount: SQLUInteger; AExact: Boolean; const AExecDirectCommand: String);
var
  iCurRow, iShifted, iTimes: SQLUInteger;
  iRet: SQLReturn;
  oBuffer: TODBCPageBuffer;

  function DoExec: SQLReturn;
  begin
    if AExecDirectCommand = '' then
      Result := Lib.SQLExecute(FHandle)
    else
      Result := Lib.SQLExecDirect(FHandle, PSQLChar(AExecDirectCommand), SQL_NTS);
  end;

  function GetRowsAffected: SQLInteger;
  begin
    try
      Result := 0;
      Check(Lib.SQLRowCount(FHandle, SQLInteger(Result)));
    except
      on E: EODBCNativeException do begin
        // if SQLExecute was successful,
        // but SQLRowCount return "Function sequence error"
        // then most probable, there was SQLCancel call
        if (TODBCConnection(Owner).RdbmsKind = mkMSAccess) and
           (Pos('HY010.', E.Errors[0].Message) <> 0) then
          E.Errors[0].Kind := ekCmdAborted;
        raise;
      end;
    end;
    if (Result = -1) and (oBuffer <> nil) and (oBuffer.RowsProcessed > 0) then
      Result := oBuffer.RowsProcessed;
  end;

  procedure CheckRetCode(ARet: SQLReturn; AExact: Boolean);
  var
    i, j: Integer;
  begin
    try
      if (ARet <> SQL_NO_DATA) or AExact then
        Check(ARet);
    except
      on E: EODBCNativeException do begin
        if (TODBCConnection(Owner).RdbmsKind = mkMSSQL) and
           (ARet = SQL_SUCCESS_WITH_INFO) and (PARAMSET_SIZE > 1) then begin
          j := -1;
          for i := Low(oBuffer.FRowStatusArr) to High(oBuffer.FRowStatusArr) do
            if oBuffer.FRowStatusArr[i] in [SQL_PARAM_ERROR, SQL_PARAM_SUCCESS_WITH_INFO] then
              while j < E.ErrorCount do begin
                Inc(j);
                if (E[j].ErrorCode = 3621) and (j > 0) then begin // found message: The stmt has been term.
                  E[j - 1].RowIndex := i;                         // set row index to previous error
                  E[j].RowIndex := i;
                  break;
                end;
              end;
          Inc(ACount, GetRowsAffected);
        end;
        raise;
      end;
    end;
  end;

begin
  TODBCConnection(Owner).ClearInfo;
  if (ParamList.FBuffer = nil) and (ParamList.Count > 0) then
    BindParameters(ARowCount, True);
  oBuffer := FParamList.FBuffer;

  iTimes := ARowCount - AOffset;
  if (oBuffer <> nil) and (iTimes < oBuffer.RowCount) then
    PARAMSET_SIZE := iTimes;
{$IFDEF AnyDAC_MONITOR}
  DumpParameters(True);
{$ENDIF}

  ACount := 0;
  iCurRow := 0;
  iShifted := 0;
  if AOffset > 0 then begin
    oBuffer.ShiftBuffersPtr(AOffset);
    iShifted := AOffset;
  end;

  repeat
    if iCurRow > 0 then begin
      oBuffer.ShiftBuffersPtr(1);
      Inc(iShifted);
      FParamList.Rebind;
    end;

    iRet := DoExec;
    if iRet = SQL_NEED_DATA then
      if VarBindingKind = bkColumnWise then
        DoPutLongData
      else
        DoPutLongData(iCurRow)
    else
      CheckRetCode(iRet, AExact);

    Inc(ACount, GetRowsAffected);
    Inc(iCurRow);

  until (oBuffer = nil) or
        (ARowCount = oBuffer.RowsProcessed) or (ARowCount = 1) or
        (ARowCount = iCurRow + AOffset);

  if iShifted > 0 then begin
    oBuffer.ShiftBuffersPtr(-iShifted);
    FParamList.Rebind;
  end;
  FIsExecuted := True;
{$IFDEF AnyDAC_MONITOR}
  DumpParameters(False);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.Open(ARowCount: SQLUInteger; const AExecDirectCommand: String);
var
  iCnt: SQLUInteger;
begin
  iCnt := 0;
  Execute(ARowCount, 0, iCnt, False, AExecDirectCommand);
end;

{-------------------------------------------------------------------------------}
function TODBCCommandStatement.NumParams: SQLSmallint;
begin
  Result := 0;
  Check(Lib.SQLNumParams(FHandle, Result));
end;

{-------------------------------------------------------------------------------}
function TODBCCommandStatement.ParamData(var ApValuePtr: SQLPointer): SQLReturn;
begin
  Result := Lib.SQLParamData(FHandle, ApValuePtr);
  if Result <> SQL_NEED_DATA then
    Check(Result);
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.Prepare(ACommandText: String);
begin
  with TODBCConnection(Owner) do begin
    ClearInfo;
    FLastCommandText := ACommandText;
  end;
  Check(Lib.SQLPrepare(FHandle, PSQLChar(ACommandText), SQL_NTS));
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.PutData(ADataPtr: SQLPointer; ASize: SQLInteger);
begin
  Check(Lib.SQLPutData(FHandle, ADataPtr, ASize));
end;

{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.Unprepare;
begin
  inherited Unprepare;
  UnbindParameters;
  with TODBCConnection(Owner) do
    FLastCommandText := '';
  FIsExecuted := False;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TODBCCommandStatement.DumpParameters(AInput: Boolean);
var
  i, j, n: Integer;
  sVal: String;
  iLen: SQLUInteger;
begin
  if Tracing then begin
    n := 1;
    for i := 0 to FParamList.Count - 1 do
      with FParamList.Items[i] do
        if AInput and ((ParamType = SQL_PARAM_INPUT) or (ParamType = SQL_PARAM_INPUT_OUTPUT)) or
           not AInput and ((ParamType = SQL_PARAM_INPUT_OUTPUT) or (ParamType = SQL_PARAM_OUTPUT) or
                           (ParamType = SQL_RETURN_VALUE)) then begin
          iLen := 0;
          sVal := DumpValue(0, iLen);
          Trace(ekCmdDataIn, esProgress, 'Param',
            [String('N'), n, 'Name', DumpLabel, '@Mode', DumpParamType,
             '@Type', DumpCDataType, 'Size', ColumnSize, 'Len', iLen,
             '@Data(0)', sVal]);
          for j := 1 to PARAMSET_SIZE - 1 do begin
            sVal := DumpValue(j, iLen);
            Trace(ekCmdDataIn, esProgress, '  ... Data', ['I', j, 'L', iLen, '@V', sVal]);
          end;
          Inc(n);
        end;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TODBCMetaInfoStatement                                                        }
{-------------------------------------------------------------------------------}
procedure TODBCMetaInfoStatement.Columns(const ACatalog, ASchema, ATable, AColumn: String);
begin
  FMode := 0;
  FIsExecuted := False;
  FCatalog := ACatalog;
  FSchema := ASchema;
  FObject := ATable;
  FColumn := AColumn;
end;

{-------------------------------------------------------------------------------}
procedure TODBCMetaInfoStatement.ForeignKeys(const APKCatalog, APKSchema, APKTable,
  AFKCatalog, AFKSchema, AFKTable: String);
begin
  FMode := 1;
  FIsExecuted := False;
  FCatalog := APKCatalog;
  FSchema := APKSchema;
  FObject := APKTable;
  FFKCatalog := AFKCatalog;
  FFKSchema := AFKSchema;
  FFKTable := AFKTable;
end;

{-------------------------------------------------------------------------------}
procedure TODBCMetaInfoStatement.PrimaryKeys(const ACatalog, ASchema, ATable: String);
begin
  FMode := 2;
  FIsExecuted := False;
  FCatalog := ACatalog;
  FSchema := ASchema;
  FObject := ATable;
end;

{-------------------------------------------------------------------------------}
procedure TODBCMetaInfoStatement.Procedures(const ACatalog, ASchema, AProc: String);
begin
  FMode := 3;
  FIsExecuted := False;
  FCatalog := ACatalog;
  FSchema := ASchema;
  FObject := AProc;
end;

{-------------------------------------------------------------------------------}
procedure TODBCMetaInfoStatement.ProcedureColumns(const ACatalog, ASchema,
  AProc, AColumn: String);
begin
  FMode := 4;
  FIsExecuted := False;
  FCatalog := ACatalog;
  FSchema := ASchema;
  FObject := AProc;
  FColumn := AColumn;
end;

{-------------------------------------------------------------------------------}
procedure TODBCMetaInfoStatement.SpecialColumns(const ACatalog, ASchema,
  ATable: String; AIdentifierType: SQLUSmallint);
begin
  FMode := 5;
  FIsExecuted := False;
  FCatalog := ACatalog;
  FSchema := ASchema;
  FObject := ATable;
  FIdentifierType := AIdentifierType;
end;

{-------------------------------------------------------------------------------}
procedure TODBCMetaInfoStatement.Statistics(const ACatalog, ASchema, ATable: String;
  AUnique: SQLUSmallint);
begin
  FMode := 6;
  FIsExecuted := False;
  FCatalog := ACatalog;
  FSchema := ASchema;
  FObject := ATable;
  FUnique := AUnique;
end;

{-------------------------------------------------------------------------------}
procedure TODBCMetaInfoStatement.Tables(const ACatalog, ASchema, ATable,
  ATableTypes: String);
begin
  FMode := 7;
  FIsExecuted := False;
  FCatalog := ACatalog;
  FSchema := ASchema;
  FObject := ATable;
  FTableTypes := ATableTypes;
end;

{-------------------------------------------------------------------------------}
procedure TODBCMetaInfoStatement.Execute;
begin
  TODBCConnection(Owner).ClearInfo;
  case FMode of
  0: Check(Lib.SQLColumns(FHandle, PSQLChar(FCatalog), SQLSmallint(Length(FCatalog)),
           PSQLChar(FSchema), SQLSmallint(Length(FSchema)), PSQLChar(FObject),
           SQLSmallint(Length(FObject)), PSQLChar(FColumn), SQLSmallint(Length(FColumn))));
  1: Check(Lib.SQLForeignKeys(FHandle, PSQLChar(FCatalog), SQLSmallint(Length(FCatalog)),
           PSQLChar(FSchema), SQLSmallint(Length(FSchema)), PSQLChar(FObject),
           SQLSmallint(Length(FObject)), PSQLChar(FFKCatalog), SQLSmallint(Length(FFKCatalog)),
           PSQLChar(FFKSchema), SQLSmallint(Length(FFKSchema)), PSQLChar(FFKTable),
           SQLSmallint(Length(FFKTable))));
  2: Check(Lib.SQLPrimaryKeys(FHandle, PSQLChar(FCatalog), SQLSmallint(Length(FCatalog)),
           PSQLChar(FSchema), SQLSmallint(Length(FSchema)), PSQLChar(FObject),
           SQLSmallint(Length(FObject))));
  3: Check(Lib.SQLProcedures(FHandle, PSQLChar(FCatalog), SQLSmallint(Length(FCatalog)),
           PSQLChar(FSchema), SQLSmallint(Length(FSchema)), PSQLChar(FObject),
           SQLSmallint(Length(FObject))));
  4: Check(Lib.SQLProcedureColumns(FHandle, PSQLChar(FCatalog), SQLSmallint(Length(FCatalog)),
           PSQLChar(FSchema), SQLSmallint(Length(FSchema)), PSQLChar(FObject),
           SQLSmallint(Length(FObject)), PSQLChar(FColumn), SQLSmallint(Length(FColumn))));
  5: Check(Lib.SQLSpecialColumns(FHandle, FIdentifierType, PSQLChar(FCatalog),
           SQLSmallint(Length(FCatalog)), PSQLChar(FSchema), SQLSmallint(Length(FSchema)),
           PSQLChar(FObject), SQLSmallint(Length(FObject)), SQL_SCOPE_CURROW, SQL_NO_NULLS));
  6: Check(Lib.SQLStatistics(FHandle, PSQLChar(FCatalog), SQLSmallint(Length(FCatalog)),
           PSQLChar(FSchema), SQLSmallint(Length(FSchema)), PSQLChar(FObject),
           SQLSmallint(Length(FObject)), FUnique, SQL_QUICK));
  7: Check(Lib.SQLTables(FHandle, PSQLChar(FCatalog), SQLSmallint(Length(FCatalog)),
           PSQLChar(FSchema), SQLSmallint(Length(FSchema)), PSQLChar(FObject),
           SQLSmallint(Length(FObject)), PSQLChar(FTableTypes), SQLSmallint(Length(FTableTypes))));
  end;
  FIsExecuted := True;
end;

{-------------------------------------------------------------------------------}
initialization
  InitializeCriticalSection(FGLock);

finalization
  // If uncomment next line, then TODBCLib.Release may raise AV
  // at application exiting.
  // DeleteCriticalSection(FGLock);

end.
