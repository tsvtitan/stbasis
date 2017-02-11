{ ----------------------------------------------------------------------------- }
{ AnyDAC ODBC driver base classes                                               }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{ ----------------------------------------------------------------------------- }
{$I daAD.inc}

unit daADPhysODBCBase;

interface

uses
  SysUtils, Classes, DB,
  daADStanIntf, daADStanError, daADStanOption, daADStanParam,
  daADDatSManager,
  daADPhysIntf, daADPhysManager, daADPhysODBCCli, daADPhysODBCWrapper;

type
  TADPhysODBCDriverBase = class;
  TADPhysODBCConnectionBase = class;
  TADPhysODBCCommand = class;

  TADPhysODBCDriverBase = class(TADPhysDriver, IADPhysDriverConnectionWizard)
  private
    FLib: TODBCLib;
    FODBCEnvironment: TODBCEnvironment;
    FKeywords: TStringList;
  protected
    // TADPhysDriver
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; Index: Integer; var AName,
      AType, ADefVal, ACaption: String; var ALoginIndex: Integer); override;
    // IADPhysDriverConnectionWizard
    function RunConnectionWizard(AConnectionDef: IADStanConnectionDef): Boolean;
      function IADPhysDriverConnectionWizard.Run = RunConnectionWizard;
    // introduced
    procedure GetODBCConnectStringKeywords(AKeywords: TStrings); virtual;
    function BuildODBCConnectString(AConnectionDef: IADStanConnectionDef): string;
    function GetODBCFixedPart: String; virtual; abstract;
  public
    constructor Create(ADrvHost: TADPhysDriverHost); override;
    destructor Destroy; override;
    property ODBCEnvironment: TODBCEnvironment read FODBCEnvironment;
  end;

  TADPhysODBCConnectionBase = class(TADPhysConnection)
  private
    FODBCConnection: TODBCConnection;
    FConnected: Boolean;
    FGetDataWithBlock: Boolean;
    FPKFunction: Boolean;
    FTxnIsolations: array[TADTxIsolation] of SQLUInteger;
    procedure DirectExec(const ASQL: String);
    procedure MapTXIsolations;
    function Execute(AStmt: TADPhysODBCCommand; ARowCount, AOffset: SQLUInteger;
      var ACount: SQLUInteger; AExact: Boolean; const AExecDirectCommand: String): Boolean;
  protected
    procedure InternalConnect; override;
    function InternalCreateCommand: TADPhysCommand; override;
    procedure InternalDisconnect; override;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; override;
{$ENDIF}
    procedure InternalTxBegin(ATxID: LongWord); override;
    procedure InternalTxChanged; override;
    procedure InternalTxCommit(ATxID: LongWord); override;
    procedure InternalTxCommitSavepoint(const AName: String); override;
    procedure InternalTxRollback(ATxID: LongWord); override;
    procedure InternalTxRollbackToSavepoint(const AName: String); override;
    procedure InternalTxSetSavepoint(const AName: String); override;
    procedure GetItem(AIndex: Integer; var AName: String; var AValue: Variant;
      var AKind: TADDebugMonitorAdapterItemKind); override;
    function GetItemCount: Integer; override;
    procedure ParseError(AHandle: TODBCHandle; ARecNum: SQLSmallint;
      const ASQLState: String; ANativeError: SQLInteger; const ADiagMessage: String;
      const ACommandText: String; var AObj: String; var AKind: TADCommandExceptionKind;
      var ACmdOffset: Integer); virtual;
    function GetMessages: EADDBEngineException; override;
    function GetCliObj: TObject; override;
    procedure GetStrsMaxSizes(AStrDataType: SQLSmallint; AFixedLen, ANumeric: Boolean;
      out ACharSize: Integer; out AByteSize: Integer); virtual; abstract;
    procedure UpdateDecimalSep; virtual;
  public
    constructor Create(ADriverObj: TADPhysDriver; const ADriver: IADPhysDriver;
      AConnHost: TADPhysConnectionHost); override;
    destructor Destroy; override;
    property ODBCConnection: TODBCConnection read FODBCConnection;
    property Connected: Boolean read FConnected;
  end;

  TADODBCVarInfoRec = record
    FName: String;
    FPos: SQLSmallInt;
    FColSize: SQLInteger;
    FScale: SQLSmallInt;
    FSrcSQLDataType,
    FOutSQLDataType: SQLSmallInt;
    FSrcDataType,
    FOutDataType,
    FDestDataType: TADDataType;
    FVar: TODBCVariable;
    case Boolean of
    True: (
      FAttrs: TADDataAttributes;
      FADLen: LongWord;
    );
    False: (
      FIsNull: Boolean;
      FParamType: SQLSmallInt;
      FDataType: TFieldType;
    );
  end;
  PDEODBCColInfoRec = ^TADODBCVarInfoRec;
  PDEODBCParInfoRec = ^TADODBCVarInfoRec;

  TADPhysODBCStatementProp = (cpParamSetSupports, cpRowSetSupports, cpLongData,
    cpParamsNotSet, cpCursorClosed, cpDefaultCrs, cpForceNonDefaultCrs);
  TADPhysODBCStatementProps = set of TADPhysODBCStatementProp;

  TADPhysODBCCommand = class(TADPhysCommand)
  private
    FColumnsInfo: TList;
    FParamsInfo: TList;
    FColumnIndex: Integer;
    FStatement: TODBCStatementBase;
    FCommandStatement: TODBCCommandStatement;
    FMetainfoStatement: TODBCMetaInfoStatement;
    FMetainfoAddonView: TADDatSView;
    FStatementProps: TADPhysODBCStatementProps;
    FOnNextResult: Boolean;
    FOnNextResultValue: Boolean;
    procedure CreateDescribeInfo;
    procedure DestroyDescribeInfo;
    procedure CreateParamsInfo;
    procedure DestroyParamsInfo;
    procedure CheckParamMatching(APar: TADParam; AParInfo: PDEODBCParInfoRec);
    function FetchMetaRow(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowIndex: SQLUInteger): Boolean;
    procedure FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow; ARowIndex: SQLUInteger);
    function GenerateSPSQL(const ACatalog, ASchema, APackage, ACmd: String): String;
    procedure GetParamValues(AFromParIndex: Integer);
    function GetConnection: TADPhysODBCConnectionBase;
    function OpenMetaInfo: Boolean;
    procedure SetParamValues(AFromParIndex: Integer);
    procedure SQL2ADColInfo(ASQLDataType: SQLSmallint; ASQLSize: SQLInteger;
      ASQLDecimals: SQLSmallint; var AType: TADDataType; var AAtrs: TADDataAttributes;
      var ALen: LongWord; var APrec, AScale: Integer; const AConnMeta: IADPhysConnectionMetadata);
    procedure SetupStatementBeforePrepare(AStmt: TODBCStatementBase);
    function GetRowsetSize(ARowsetSize: Integer): Integer;
    function GetParamsetSize(AParamsetSize: Integer): Integer;
    function MatchParamsetSize(AParamsetSize1, AParamsetSize2: Integer): Boolean;
    function UseExecDirect: Boolean;
    function AD2SQLDataType(AType: TADDataType): SQLSmallint;
    procedure CheckParamArraySizesMatching;
    procedure CloseStatement(AIndex: Integer; AForceClose: Boolean);
    function GetCursor: Boolean;
  protected
    function CheckFetchColumn(AColType: TADDataType;
      ASQLDataType: Smallint): Boolean; overload;
    procedure InternalAbort; override;
    procedure InternalClose; override;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; override;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; override;
    procedure InternalExecute(ATimes: LongInt; AOffset: LongInt; var ACount: LongInt); override;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; override;
    function InternalNextRecordSet: Boolean; override;
    function InternalOpen: Boolean; override;
    procedure InternalPrepare; override;
    procedure InternalUnprepare; override;
    function GetCliObj: TObject; override;
  public
    constructor Create;
    destructor Destroy; override;
    property ODBCStatement: TODBCStatementBase read FStatement;
  end;

implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
  {$IFDEF AnyDAC_D6}
  FmtBcd,  Windows,
  {$ENDIF}
{$ENDIF}
  daADStanConst, daADStanFactory;

const
  C_AD_TxI2ODBCTxI: array[TADTxIsolation] of SQLUInteger = (
    SQL_TXN_READ_UNCOMMITTED, SQL_TXN_READ_COMMITTED, SQL_TXN_REPEATABLE_READ,
    SQL_TXN_SERIALIZABLE);

  C_AD_Type2SQLDataType: array [TADDataType] of SQLSmallint =
    (
     SQL_UNKNOWN_TYPE,
     SQL_BIT,
     SQL_TINYINT, SQL_SMALLINT, SQL_INTEGER, SQL_BIGINT,
     SQL_SMALLINT, SQL_SMALLINT, SQL_INTEGER, SQL_BIGINT,
     SQL_DOUBLE, SQL_DECIMAL, SQL_DECIMAL, SQL_DECIMAL,
     SQL_TIMESTAMP, SQL_TYPE_TIME, SQL_TYPE_DATE, SQL_TIMESTAMP,
     SQL_VARCHAR, SQL_WVARCHAR, SQL_VARBINARY,
     SQL_LONGVARBINARY, SQL_LONGVARCHAR, SQL_WLONGVARCHAR,
     SQL_LONGVARBINARY, SQL_LONGVARCHAR, SQL_WLONGVARCHAR,
     SQL_LONGVARBINARY,
     SQL_UNKNOWN_TYPE, SQL_REFCURSOR, SQL_UNKNOWN_TYPE,
     SQL_UNKNOWN_TYPE, SQL_UNKNOWN_TYPE,
     SQL_GUID, SQL_UNKNOWN_TYPE
    );

  C_AD_Type2CDataType: array [TADDataType] of SQLSmallint =
    (
     SQL_TYPE_NULL,
     SQL_C_BIT,
     { TODO : if driver is ODBC2 then on next line
              SQL_C_SHORT, SQL_C_LONG, and SQL_C_TINYINT ? }
     SQL_C_STINYINT, SQL_C_SSHORT, SQL_C_SLONG, SQL_C_SBIGINT,
     SQL_C_UTINYINT, SQL_C_USHORT, SQL_C_ULONG, SQL_C_UBIGINT,
     SQL_C_DOUBLE, SQL_C_CHAR, SQL_C_CHAR, SQL_C_CHAR,
     SQL_C_TIMESTAMP, SQL_C_TYPE_TIME, SQL_C_TYPE_DATE, SQL_C_TIMESTAMP,
     SQL_C_CHAR, SQL_C_WCHAR, SQL_C_BINARY,
     SQL_C_BINARY, SQL_C_CHAR, SQL_C_WCHAR,
     SQL_C_BINARY, SQL_C_CHAR, SQL_C_WCHAR,
     SQL_C_BINARY,
     SQL_TYPE_NULL, SQL_TYPE_NULL, SQL_TYPE_NULL,
     SQL_TYPE_NULL, SQL_TYPE_NULL,
     SQL_C_GUID, SQL_TYPE_NULL
    );

  C_AD_ParType2SQLParType: array [TParamType] of Smallint =
    (
     SQL_PARAM_INPUT,
     SQL_PARAM_INPUT,
     SQL_PARAM_OUTPUT,
     SQL_PARAM_INPUT_OUTPUT,
     SQL_PARAM_OUTPUT
    );

  C_AD_BestRowID: String = 'SQL_BEST_ROWID';

{-------------------------------------------------------------------------------}
{ TADPhysODBCDriverBase                                                         }
{-------------------------------------------------------------------------------}
constructor TADPhysODBCDriverBase.Create(ADrvHost: TADPhysDriverHost);
var
  sHome, sLib: String;
begin
  inherited Create(ADrvHost);
  sHome := '';
  sLib := '';
  ADrvHost.GetVendorParams(sHome, sLib);
  FLib := TODBCLib.Allocate(sHome, sLib, ADPhysManagerObj);
  FODBCEnvironment := TODBCEnvironment.Create(FLib, ADPhysManagerObj);
  FKeywords := TStringList.Create;
  GetODBCConnectStringKeywords(FKeywords);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysODBCDriverBase.Destroy;
begin
  FreeAndNil(FKeywords);
  FreeAndNil(FODBCEnvironment);
  TODBCLib.Release(FLib);
  FLib := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDriverBase.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 2;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDriverBase.GetConnParams(AKeys: TStrings; Index: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
  ADefVal := '';
  if Index < inherited GetConnParamCount(AKeys) then
    inherited GetConnParams(AKeys, Index, AName, AType, ADefVal, ACaption, ALoginIndex)
  else begin
    case Index - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_ODBC_Advanced;
        AType := '@S';
      end;
    1:
      begin
        AName := S_AD_ConnParam_Common_LoginTimeout;
        AType := '@I';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDriverBase.GetODBCConnectStringKeywords(AKeywords: TStrings);
begin
  with AKeywords do begin
    Add(S_AD_ConnParam_Common_UserName + '=UID');
    Add(S_AD_ConnParam_Common_Password + '=PWD');
    Add('DSN');
    Add('FIL');
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDriverBase.BuildODBCConnectString(AConnectionDef: IADStanConnectionDef): string;
var
  sDB, sAdv, sFP: String;
  oTmpDef: IADStanConnectionDef;
  lHasDSN: Boolean;
  i: Integer;
begin
  sDB := Trim(AConnectionDef.ExpandedDatabase);
  if Pos('=', sDB) <> 0 then begin
    ADCreateInterface(IADStanConnectionDef, oTmpDef);
    oTmpDef.Params.Assign(AConnectionDef.Params);
    i := oTmpDef.Params.IndexOfName(S_AD_ConnParam_Common_Database);
    if i >= 0 then
      oTmpDef.Params.Delete(i);
    oTmpDef.ParseString(oTmpDef.BuildString(FKeywords));
    oTmpDef.ParseString(sDB);
    Result := oTmpDef.BuildString(FKeywords);
    lHasDSN := oTmpDef.HasValue('DSN') or oTmpDef.HasValue('FIL');
  end
  else begin
    Result := AConnectionDef.BuildString(FKeywords);
    lHasDSN := AConnectionDef.HasValue('DSN') or AConnectionDef.HasValue('FIL');
  end;
  sFP := GetODBCFixedPart;
  if sFP <> '' then begin
    if Result <> '' then
      Result := ';' + Result;
    Result := sFP + Result;
  end;
  sAdv := AConnectionDef.AsString[S_AD_ConnParam_ODBC_Advanced];
  if sAdv <> '' then begin
    if Result <> '' then
      Result := Result + ';';
    Result := Result + sAdv;
  end;
  if lHasDSN then begin
    ADCreateInterface(IADStanConnectionDef, oTmpDef);
    oTmpDef.ParseString(Result);
    i := oTmpDef.Params.IndexOfName('DRIVER');
    if i >= 0 then
      oTmpDef.Params.Delete(i);
    Result := oTmpDef.BuildString();
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDriverBase.RunConnectionWizard(AConnectionDef: IADStanConnectionDef): Boolean;
var
  oODBCConn: TODBCConnection;
  sConn: String;
begin
  Result := False;
  oODBCConn := TODBCConnection.Create(FODBCEnvironment, Self);
  try
    try
      sConn := oODBCConn.Connect(BuildODBCConnectString(AConnectionDef), True);
      oODBCConn.Disconnect;
      AConnectionDef.AsString[S_AD_ConnParam_ODBC_Advanced] :=
        AConnectionDef.ParseString(sConn, FKeywords);
      Result := True;
    except
      on E: EODBCNativeException do
        if E.Kind <> ekNoDataFound then
          raise;
    end;
  finally
    oODBCConn.Free;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCConnectionBase                                                     }
{-------------------------------------------------------------------------------}
constructor TADPhysODBCConnectionBase.Create(ADriverObj: TADPhysDriver;
  const ADriver: IADPhysDriver; AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, ADriver, AConnHost);
  FODBCConnection := TODBCConnection.Create(
    TADPhysODBCDriverBase(ADriverObj).FODBCEnvironment, Self);
  FODBCConnection.OnParseError := ParseError;
  FODBCConnection.OnGetMaxSizes := GetStrsMaxSizes;
{$IFDEF AnyDAC_MONITOR}
  FODBCConnection.Tracing := GetTracing;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
destructor TADPhysODBCConnectionBase.Destroy;
begin
  FRefCount := $3FFFFFFF;
  ForceDisconnect;
  FreeAndNil(FODBCConnection);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCConnectionBase.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysODBCCommand.Create;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalTracingChanged;
begin
  if (DriverObj <> nil) and GetTracing then
    TADPhysODBCDriverBase(DriverObj).FLib.ActivateTracing(GetMonitor);
  if ODBCConnection <> nil then
    ODBCConnection.Tracing := GetTracing;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADPhysODBCConnectionBase.Execute(AStmt: TADPhysODBCCommand;
  ARowCount, AOffset: SQLUInteger; var ACount: SQLUInteger; AExact: Boolean;
  const AExecDirectCommand: String): Boolean;
var
  lExecuted: Boolean;
  iTrials: Integer;
  i: Integer;
begin
  Result := True;
  lExecuted := False;
  iTrials := 0;
  repeat
    try
      Inc(iTrials);
      if AStmt.GetMetaInfoKind = mkNone then
        AStmt.FCommandStatement.Execute(ARowCount, AOffset, ACount, AExact,
          AExecDirectCommand)
      else
        Result := AStmt.OpenMetaInfo;
      lExecuted := True;
    except
      on E: EODBCNativeException do begin
        if AllowReconnect and (E.Kind = ekServerGone) and (iTrials = 1) then begin
          for i := 0 to FCommandList.Count - 1 do
            if TADPhysODBCCommand(FCommandList[i]).GetState = csPrepared then
              TADPhysODBCCommand(FCommandList[i]).InternalUnprepare;
          InternalDisconnect;
          InternalConnect;
          for i := 0 to FCommandList.Count - 1 do
            if TADPhysODBCCommand(FCommandList[i]).GetState = csPrepared then
              TADPhysODBCCommand(FCommandList[i]).InternalPrepare;
        end
        else
          raise;
      end;
    end;
  until lExecuted;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.DirectExec(const ASQL: String);
var
  oStmt: TODBCCommandStatement;
  iTmpCount: Integer;
begin
  oStmt := TODBCCommandStatement.Create(ODBCConnection, Self);
  try
    iTmpCount := 0;
    oStmt.Execute(1, 0, iTmpCount, False, ASQL);
    oStmt.Close;
  finally
    oStmt.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.MapTXIsolations;
var
  iSuppIsol: SQLUInteger;
  eIsol: TADTxIsolation;
  iIsol: SQLUInteger;
begin
  iSuppIsol := ODBCConnection.TXN_ISOLATION_OPTION;
  for eIsol := Low(TADTxIsolation) to High(TADTxIsolation) do begin
    iIsol := C_AD_TxI2ODBCTxI[eIsol];
    while ((iSuppIsol and iIsol) = 0) and (iIsol <> 0) do
      iIsol := iIsol shr 1;
    if iIsol = 0 then begin
      iIsol := C_AD_TxI2ODBCTxI[eIsol];
      while ((iSuppIsol and iIsol) = 0) and (iIsol <> 0) do
        iIsol := iIsol shl 1;
    end;
    FTxnIsolations[eIsol] := iIsol;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalConnect;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  FAllowReconnect := GetConnectionDef.AsBoolean[S_AD_ConnParam_Common_AllowReconnect];
  try
    { TODO : To use other connection attributes ? }
    if GetConnectionDef.HasValue(S_AD_ConnParam_Common_LoginTimeout) then
      ODBCConnection.LOGIN_TIMEOUT := GetConnectionDef.AsInteger[S_AD_ConnParam_Common_LoginTimeout];
    ODBCConnection.Connect(TADPhysODBCDriverBase(DriverObj).BuildODBCConnectString(ConnectionDef), False);
    FConnected := True;
    CreateMetadata(oConnMeta);
    ODBCConnection.RdbmsKind := oConnMeta.Kind;
    if oConnMeta.Kind = mkDB2 then
      ODBCConnection.LONGDATA_COMPAT := SQL_LD_COMPAT_YES;
    FGetDataWithBlock := (ODBCConnection.GETDATA_EXTENSIONS and SQL_GD_BLOCK) = SQL_GD_BLOCK;
    FPKFunction := ODBCConnection.GetFunctions(SQL_API_SQLPRIMARYKEYS) = SQL_TRUE;
    if ODBCConnection.TXN_CAPABLE <> SQL_TC_NONE then
      MapTXIsolations;
    UpdateDecimalSep;
  except
    InternalDisconnect;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.UpdateDecimalSep;
begin
  FODBCConnection.DecimalSepCol := '.';
  FODBCConnection.DecimalSepPar := '.';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalDisconnect;
begin
  if FConnected then begin
    if ODBCConnection <> nil then
      ODBCConnection.Disconnect;
    FConnected := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalTxChanged;
begin
 if xoAutoCommit in GetTxOptions.Changed then
    if GetTxOptions.AutoCommit then
      ODBCConnection.AUTOCOMMIT := SQL_AUTOCOMMIT_ON
    else
      ODBCConnection.AUTOCOMMIT := SQL_AUTOCOMMIT_OFF;
  if xoIsolation in GetTxOptions.Changed then
    ODBCConnection.TXN_ISOLATION := FTxnIsolations[GetTxOptions.Isolation];
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalTxBegin(ATxID: LongWord);
begin
  with ODBCConnection do begin
    Transaction.TransID := ATxID;
    Transaction.StartTransaction;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalTxCommit(ATxID: LongWord);
begin
  ODBCConnection.Transaction.Commit;
  if GetTxOptions.AutoCommit then
    ODBCConnection.AUTOCOMMIT := SQL_AUTOCOMMIT_ON;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalTxRollback(ATxID: LongWord);
begin
  ODBCConnection.Transaction.Rollback;
  if GetTxOptions.AutoCommit then
    ODBCConnection.AUTOCOMMIT := SQL_AUTOCOMMIT_ON;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalTxSetSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: string;
begin
  CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateSavepoint(AName);
  if s <> '' then
    DirectExec(s);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalTxCommitSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: string;
begin
  CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateCommitSavepoint(AName);
  if s <> '' then
    DirectExec(s);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.InternalTxRollbackToSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: string;
begin
  CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateRollbackToSavepoint(AName);
  if s <> '' then
    DirectExec(s);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCConnectionBase.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  Inc(Result, 1);
  if FConnected then
    Inc(Result, 5);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.GetItem(AIndex: Integer; var AName: String;
  var AValue: Variant; var AKind: TADDebugMonitorAdapterItemKind);
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else begin
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'Driver Manager version';
        AValue := ODBCConnection.DM_VER;
        AKind := ikClientInfo;
      end;
    1:
      begin
        AName := 'Driver name';
        AValue := ODBCConnection.DRIVER_NAME;
        AKind := ikSessionInfo;
      end;
    2:
      begin
        AName := 'Driver version';
        AValue := ODBCConnection.DRIVER_VER;
        AKind := ikSessionInfo;
      end;
    3:
      begin
        AName := 'Driver conformance';
        AValue := IntToStr(ODBCConnection.INTERFACE_CONFORMANCE);
        AKind := ikSessionInfo;
      end;
    4:
      begin
        AName := 'DBMS name';
        AValue := ODBCConnection.DBMS_NAME;
        AKind := ikSessionInfo;
      end;
    5:
      begin
        AName := 'DBMS version';
        AValue := ODBCConnection.DBMS_VER;
        AKind := ikSessionInfo;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnectionBase.ParseError(AHandle: TODBCHandle;
  ARecNum: SQLSmallint; const ASQLState: String; ANativeError: SQLInteger;
  const ADiagMessage: String; const ACommandText: String; var AObj: String;
  var AKind: TADCommandExceptionKind; var ACmdOffset: Integer);
begin
  if ASQLState = 'HY008' then
    AKind := ekCmdAborted
  else if ASQLState = '08S01' then
    AKind := ekServerGone
  else
    AKind := ekOther;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysODBCConnectionBase.GetMessages: EADDBEngineException;
begin
  Result := ODBCConnection.Info;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCConnectionBase.GetCliObj: TObject;
begin
  Result := ODBCConnection;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCCommand                                                            }
{-------------------------------------------------------------------------------}
constructor TADPhysODBCCommand.Create;
begin
  inherited Create;
  FColumnsInfo := TList.Create;
  FParamsInfo := TList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysODBCCommand.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FColumnsInfo);
  FreeAndNil(FParamsInfo);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.GetConnection: TADPhysODBCConnectionBase;
begin
  Result := TADPhysODBCConnectionBase(FConnectionObj);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.GetCliObj: TObject;
begin
  Result := ODBCStatement;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.AD2SQLDataType(AType: TADDataType): SQLSmallint;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  Result := C_AD_Type2SQLDataType[AType];
  GetConnection.CreateMetadata(oConnMeta);
  case oConnMeta.Kind of
  mkMSAccess:
    if Result = SQL_DECIMAL then
      Result := SQL_NUMERIC
    else if Result = SQL_BIGINT then
      Result := SQL_NUMERIC;
  mkDB2:
    if Result = SQL_BIT then
      Result := SQL_DECIMAL;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.SQL2ADColInfo(ASQLDataType: SQLSmallint;
  ASQLSize: SQLInteger; ASQLDecimals: SQLSmallint; var AType: TADDataType;
  var AAtrs: TADDataAttributes; var ALen: LongWord; var APrec, AScale: Integer;
  const AConnMeta: IADPhysConnectionMetadata);
begin
  AType := dtUnknown;
  ALen := 0;
  APrec := 0;
  AScale := 0;
  Exclude(AAtrs, caFixedLen);
  Exclude(AAtrs, caBlobData);
  Include(AAtrs, caSearchable);
  case ASQLDataType of
  SQL_TINYINT:
    AType := dtSByte;
  SQL_SMALLINT:
    AType := dtInt16;
  SQL_INTEGER:
    AType := dtInt32;
  SQL_BIGINT:
    AType := dtInt64;
  SQL_NUMERIC,
  SQL_DECIMAL:
    begin
      APrec := ASQLSize;
      AScale := ASQLDecimals;
      with GetFormatOptions do
        if (ASQLSize <= MaxBcdPrecision) and (ASQLDecimals <= MaxBcdScale) then
          AType := dtBCD
        else
          AType := dtFmtBCD;
    end;
  SQL_DOUBLE,
  SQL_FLOAT,
  SQL_REAL:
    begin
      if ASQLSize = 53 then
        APrec := 16
      else if ASQLSize = 24 then
        APrec := 8
      else
        APrec := ASQLSize;
      AType := dtDouble;
    end;
  SQL_GUID:
    AType := dtGUID;
  SQL_CHAR, SQL_VARCHAR:
    begin
      if (ASQLSize > C_AD_MaxDlp4StrSize) or (ASQLSize < 0) then begin
        AType := dtMemo;
        Include(AAtrs, caBlobData);
      end
      else begin
        AType := dtAnsiString;
        ALen := ASQLSize;
        if ASQLDataType = SQL_CHAR then
          Include(AAtrs, caFixedLen);
      end;
    end;
  SQL_WCHAR, SQL_WVARCHAR:
    begin
      if (ASQLSize > C_AD_MaxDlp4StrSize) or (ASQLSize < 0) then begin
        AType := dtWideMemo;
        Include(AAtrs, caBlobData);
      end
      else begin
        AType := dtWideString;
        ALen := ASQLSize;
        if ASQLDataType = SQL_WCHAR then
          Include(AAtrs, caFixedLen);
      end;
    end;
  SQL_BINARY,
  SQL_VARBINARY,
  SQL_SS_VARIANT:
    begin
      if (ASQLSize > C_AD_MaxDlp4StrSize) or (ASQLSize < 0) then begin
        AType := dtBlob;
        Include(AAtrs, caBlobData);
      end
      else begin
        AType := dtByteString;
        ALen := ASQLSize;
        if ASQLDataType = SQL_BINARY then
          Include(AAtrs, caFixedLen);
      end;
    end;
  SQL_TYPE_DATE:
    AType := dtDate;
  SQL_TYPE_TIME,
  SQL_TIME:
    AType := dtTime;
  SQL_DATETIME:
    AType := dtDateTime;
  SQL_TYPE_TIMESTAMP,
  SQL_TIMESTAMP:
    AType := dtDateTimeStamp;
  SQL_BIT:
    AType := dtBoolean;
  SQL_DB2CLOB,
  SQL_LONGVARCHAR:
    begin
      AType := dtMemo;
      Include(AAtrs, caBlobData);
      Exclude(AAtrs, caSearchable);
    end;
  SQL_WLONGVARCHAR,
  SQL_DB2DBCLOB:
    begin
      AType := dtWideMemo;
      ALen := ASQLSize;
      Include(AAtrs, caBlobData);
      Exclude(AAtrs, caSearchable);
    end;
  SQL_DB2BLOB,
  SQL_LONGVARBINARY:
    begin
      AType := dtBlob;
      ALen := ASQLSize;
      Include(AAtrs, caBlobData);
      Exclude(AAtrs, caSearchable);
    end;
  SQL_INTERVAL_YEAR .. SQL_INTERVAL_MINUTE_TO_SECOND:
    begin
      AType := dtAnsiString;
      ALen := ASQLSize;
    end;
  SQL_REFCURSOR:
    AType := dtCursorRef;
  else
    AType := dtUnknown;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.CheckFetchColumn(AColType: TADDataType;
  ASQLDataType: Smallint): Boolean;
begin
  Result := inherited CheckFetchColumn(AColType);
  if Result then
    Result := (ASQLDataType <> SQL_SS_VARIANT) or (fiBlobs in GetFetchOptions.Items);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.CreateDescribeInfo;
var
  oFmtOpts: TADFormatOptions;
  i, iNumCols: SQLSmallint;
  oSelItem: TODBCSelectItem;
  pColInfo: PDEODBCColInfoRec;
  iLen: LongWord;
  iPrec, iScale: Integer;
  oConnMeta: IADPhysConnectionMetadata;
  lBlobsStarted: Boolean;
begin
  oFmtOpts := GetFormatOptions;
  GetConnection.CreateMetadata(oConnMeta);
  Exclude(FStatementProps, cpLongData);
  lBlobsStarted := False;
  iNumCols := FStatement.NumResultCols;
  if GetMetaInfoKind = mkProcArgs then
    iNumCols := 13;
  for i := 1 to iNumCols do begin
    oSelItem := TODBCSelectItem.Create(FStatement, i);
    try
      New(pColInfo);
      FillChar(pColInfo^, SizeOf(TADODBCVarInfoRec), 0);
      FColumnsInfo.Add(pColInfo);

      with pColInfo^ do begin
        FName := oSelItem.Name;
        FPos := oSelItem.Position;
        FColSize := oSelItem.ColumnSize;
        FScale := oSelItem.Scale;
        FSrcSQLDataType := oSelItem.SQLDataType;

        FAttrs := [];
        if oSelItem.NULLABLE = SQL_NULLABLE then
          Include(FAttrs, caAllowNull);
        if oSelItem.AUTO_UNIQUE_VALUE = SQL_TRUE then begin
          Include(FAttrs, caAutoInc);
          Include(FAttrs, caAllowNull);
        end;
        if oSelItem.UPDATABLE = SQL_ATTR_READONLY then
          Include(FAttrs, caReadOnly);
        if oSelItem.IsFixedLen then
          Include(FAttrs, caFixedLen);
        if oSelItem.SEARCHABLE <> SQL_PRED_NONE then
          Include(FAttrs, caSearchable);
        if oSelItem.ROWVER = SQL_TRUE then
          Include(FAttrs, caRowVersion);

        iLen := 0;
        iPrec := 0;
        iScale := 0;
        SQL2ADColInfo(FSrcSQLDataType, FColSize, FScale, FSrcDataType, FAttrs,
          iLen, iPrec, iScale, oConnMeta);

        if ((FSrcDataType = dtBCD) or (FSrcDataType = dtFmtBCD)) and
           (oSelItem.FIXED_PREC_SCALE = SQL_TRUE) then
          FSrcDataType := dtCurrency;

        if oSelItem.UNSIGNED = SQL_TRUE then
          case FSrcDataType of
          dtSByte: FSrcDataType := dtByte;
          dtInt16: FSrcDataType := dtUInt16;
          dtInt32: FSrcDataType := dtUInt32;
          dtInt64: FSrcDataType := dtUInt64;
          end;

        // mapping data types
        if GetMetaInfoKind = mkNone then
          oFmtOpts.ResolveDataType(FSrcDataType, iLen, iPrec, iScale, FDestDataType, True)
        else begin
          // many ODBC drivers returns textual metadata columns as SQL_WCHAR
          // but AnyDAC expects Ansi string
          if FSrcDataType = dtWideString then
            FDestDataType := dtAnsiString
          else
            FDestDataType := FSrcDataType;
        end;
        // ODBC does not support Delphi Currency data type,
        // so map it to BCD
        if FSrcDataType = dtCurrency then
          FSrcDataType := dtBCD;

        FOutSQLDataType := AD2SQLDataType(FDestDataType);
        if FOutSQLDataType <> SQL_UNKNOWN_TYPE then begin
          SQL2ADColInfo(FOutSQLDataType, FColSize, FScale, FOutDataType, FAttrs,
            iLen, iPrec, iScale, oConnMeta);
          if FDestDataType = FSrcDataType then
            FOutSQLDataType := FSrcSQLDataType;
        end
        else begin
          SQL2ADColInfo(FSrcSQLDataType, FColSize, FScale, FOutDataType, FAttrs,
            iLen, iPrec, iScale, oConnMeta);
          FOutSQLDataType := FSrcSQLDataType;
        end;
        FADLen := iLen;

        if (FSrcDataType = dtBCD) and (FOutDataType = dtFmtBCD) then
          FOutDataType := dtBCD;

        if CheckFetchColumn(FDestDataType, FOutSQLDataType) then begin
          if (oConnMeta.Kind = mkMSSQL) and not (cpForceNonDefaultCrs in FStatementProps) then
            if (FOutSQLDataType = SQL_LONGVARCHAR) or
               (FOutSQLDataType = SQL_WLONGVARCHAR) or
               (FOutSQLDataType = SQL_LONGVARBINARY) then
              lBlobsStarted := True
            else if lBlobsStarted then
              Include(FStatementProps, cpForceNonDefaultCrs);

          FVar := TODBCVariable.Create;
          FStatement.ColumnList.Add(FVar);
          with FVar do begin
            ParamType := SQL_RESULT_COL;
            Position := FPos;
            ColumnSize := FColSize;
            Scale := FScale;
            SQLDataType := FOutSQLDataType;
            CDataType := C_AD_Type2CDataType[FOutDataType];
            if LongData then
              Include(FStatementProps, cpLongData);
          end;
        end
        else
          FVar := nil;
      end;
    finally
      oSelItem.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.DestroyDescribeInfo;
var
  i: Integer;
  pColInfo: PDEODBCColInfoRec;
begin
  for i := 0 to FColumnsInfo.Count - 1 do begin
    pColInfo := PDEODBCColInfoRec(FColumnsInfo[i]);
    Dispose(pColInfo);
  end;
  FColumnsInfo.Clear;
  if FStatement <> nil then
    FStatement.UnbindColumns;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.CreateParamsInfo;
var
  i: Integer;
  iActive: Smallint;
  oParam: TADParam;
  oParams: TADParams;
  pParInfo: PDEODBCParInfoRec;
  eDestFldType: TFieldType;
  iDestPrec, iScale: Integer;
  iLen: LongWord;
  eAttrs: TADDataAttributes;
  oFmtOpts: TADFormatOptions;
  oResOpts: TADResourceOptions;
  oConnMeta: IADPhysConnectionMetadata;
begin
  oParams := GetParams;
  if (oParams.Count = 0) or (FCommandStatement = nil) then
    Exit;

  iActive := 0;
  oFmtOpts := GetFormatOptions;
  oResOpts := GetResourceOptions;
  GetConnection.CreateMetadata(oConnMeta);

  for i := 0 to oParams.Count - 1 do begin
    oParam := oParams[i];
    if not oParam.Active then
      Continue;

    New(pParInfo);
    FillChar(pParInfo^, SizeOf(TADODBCVarInfoRec), 0);
    FParamsInfo.Add(pParInfo);

    with pParInfo^ do begin
      FPos := iActive;

      // MSSQL ODBC driver has a bug, so dont set parameter names
      if oConnMeta.Kind <> mkMSSQL then
        case GetParamBindMode of
        pbByName:
          begin
            FName := oParam.Name;
            if Length(FName) > oConnMeta.ParamNameMaxLength then
              FName := Copy(FName, 1, oConnMeta.ParamNameMaxLength -
                1 - Length(IntToStr(i + 1))) + '_' + IntToStr(i + 1);
          end;
        pbByNumber:
          FName := '';
        end;

      if oParam.ParamType = ptUnknown then
        oParam.ParamType := oResOpts.DefaultParamType;
      FParamType := C_AD_ParType2SQLParType[oParam.ParamType];
      FDataType := oParam.DataType;
      if oParam.DataType = ftUnknown then
        ParTypeUnknownError(oParam);
      with oParam do begin
        iDestPrec := 0;
        eDestFldType := ftUnknown;
        oFmtOpts.ResolveFieldType(DataType, ADDataType, Size, Precision, eDestFldType,
          LongWord(FColSize), iDestPrec, FSrcDataType, FDestDataType, False);
      end;

      // ASA cannot correctly return blob out parameters, so map them to
      // appropriate types
      if (oConnMeta.Kind = mkASA) and (oParam.ParamType in [ptOutput, ptInputOutput]) then
         case FDestDataType of
         dtBlob: FDestDataType := dtByteString;
         dtMemo: FDestDataType := dtAnsiString;
         end;

      // ODBC does not support Delphi Currency data type,
      // so map it to BCD
      if FDestDataType = dtCurrency then
        FDestDataType := dtBCD;

      FSrcSQLDataType := AD2SQLDataType(FSrcDataType);
      FOutSQLDataType := AD2SQLDataType(FDestDataType);
      if FOutSQLDataType = SQL_UNKNOWN_TYPE then
        ParTypeMapError(oParam);

      iLen := 0;
      iDestPrec := 0;
      iScale := 0;
      eAttrs := [];
      SQL2ADColInfo(FOutSQLDataType, FColSize, FScale, FOutDataType, eAttrs,
        iLen, iDestPrec, iScale, oConnMeta);

      if (FDestDataType = dtBCD) and (FOutDataType = dtFmtBCD) then
        FOutDataType := dtBCD;
      if (FOutDataType = dtBCD) or (FOutDataType = dtFmtBCD) then begin
        if oParam.Precision <> 0 then
          FColSize := oParam.Precision
        else
          FColSize := oParam.Size;
        FScale := SQLSmallInt(oParam.NumericScale);
      end;

      FVar := TODBCVariable.Create;
      FCommandStatement.ParamList.Add(FVar);
      with FVar do begin
        ParamType := FParamType;
        Position := SQLSmallint(FPos + 1);
        Name := FName;
        ColumnSize := FColSize;
        Scale := FScale;
        SQLDataType := FOutSQLDataType;
        CDataType := C_AD_Type2CDataType[FOutDataType];
      end;
    end;
    Inc(iActive);
  end;

  if FCommandStatement.ParamList.HasLongVariables then begin
    FCommandStatement.PARAMSET_SIZE := 1;
    Exclude(FStatementProps, cpParamSetSupports);
    FCommandStatement.ParamSetSupported := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.DestroyParamsInfo;
var
  i: Integer;
  pParInfo: PDEODBCParInfoRec;
begin
  if GetMetaInfoKind = mkNone then begin
    for i := 0 to FParamsInfo.Count - 1 do begin
      pParInfo := PDEODBCParInfoRec(FParamsInfo[i]);
      Dispose(pParInfo);
    end;
    FParamsInfo.Clear;
    if FCommandStatement <> nil then
      FCommandStatement.UnbindParameters;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.SetupStatementBeforePrepare(AStmt: TODBCStatementBase);
var
  oFmtOpts: TADFormatOptions;
  oFtchOpts: TADFetchOptions;
  oResOpts: TADResourceOptions;
  oConnMeta: IADPhysConnectionMetadata;
  lForceNonDefaultCrs: Boolean;
  iTestSize: Integer;
begin
  oFmtOpts := GetFormatOptions;
  oFtchOpts := GetFetchOptions;
  oResOpts := GetResourceOptions;
  GetConnection.CreateMetadata(oConnMeta);
  lForceNonDefaultCrs := cpForceNonDefaultCrs in FStatementProps;
  FStatementProps := [];

  if fiBlobs in oFtchOpts.Items then
    Include(FStatementProps, cpLongData);
  if oFmtOpts.InlineDataSize <= 0 then
    AStmt.InrecDataSize := IDefInrecDataSize
  else
    AStmt.InrecDataSize := oFmtOpts.InlineDataSize;
  AStmt.StrsTrim := oFmtOpts.StrsTrim;
  AStmt.StrsEmpty2Null := oFmtOpts.StrsEmpty2Null;
  AStmt.StrsMaxSize := oFmtOpts.MaxStringSize;

  if (AStmt is TODBCCommandStatement) and (GetParams.Count > 0) then
    with TODBCCommandStatement(AStmt) do begin
      iTestSize := GetParams.ArraySize;
      if (oConnMeta.Kind <> mkMSAccess) and (iTestSize > 1) then begin
        PARAMSET_SIZE := iTestSize;
        if PARAMSET_SIZE = iTestSize then
          Include(FStatementProps, cpParamSetSupports);
      end;
      ParamSetSupported := (cpParamSetSupports in FStatementProps);
    end;

  if oFtchOpts.RecsMax <> -1 then
    AStmt.MAX_ROWS := oFtchOpts.RecsMax
  else
    AStmt.MAX_ROWS := 0;

  if not UseExecDirect then
    if (oConnMeta.Kind <> mkMSSQL) or not (oFtchOpts.Mode in [fmExactRecsMax, fmAll]) or
       lForceNonDefaultCrs then begin
      if TADPhysODBCConnectionBase(FConnectionObj).FGetDataWithBlock and
         ((oConnMeta.Kind <> mkDb2) or not (cpLongData in FStatementProps)) then begin
        AStmt.ROW_ARRAY_SIZE := oFtchOpts.ActualRowsetSize;
        if AStmt.ROW_ARRAY_SIZE = oFtchOpts.ActualRowsetSize then
          Include(FStatementProps, cpRowSetSupports);
      end;
      if (oConnMeta.Kind = mkMSSQL) and not (cpLongData in FStatementProps) then
        if oFtchOpts.Mode = fmExactRecsMax then
          AStmt.SS_CURSOR_OPTIONS := SQL_CO_FFO_AF
        else
          AStmt.SS_CURSOR_OPTIONS := SQL_CO_FFO
      else if (GetMetainfoKind = mkNone) and (oConnMeta.Kind <> mkDB2) then
        AStmt.CURSOR_TYPE := SQL_CURSOR_STATIC;
      if GetCommandKind <> skSelectForUpdate then
        AStmt.CONCURRENCY := SQL_CONCUR_READ_ONLY;
    end
    else begin
      AStmt.SS_CURSOR_OPTIONS := SQL_CO_DEFAULT;
      Include(FStatementProps, cpDefaultCrs);
    end;

  if (oConnMeta.Kind in [mkDB2, mkMSSQL]) and
     not (GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs]) and
     (GetParams.Count = 0) and
     oResOpts.MacroExpand and oResOpts.EscapeExpand then
    AStmt.NOSCAN := SQL_NOSCAN_ON;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.GetRowsetSize(ARowsetSize: Integer): Integer;
begin
  if [cpRowSetSupports, cpDefaultCrs] * FStatementProps = [cpRowSetSupports] then
    Result := ARowsetSize
  else
    Result := 1;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.GetParamsetSize(AParamsetSize: Integer): Integer;
begin
  if cpParamSetSupports in FStatementProps then
    Result := AParamsetSize
  else
    Result := 1;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.MatchParamsetSize(AParamsetSize1, AParamsetSize2: Integer): Boolean;
begin
  if cpParamSetSupports in FStatementProps then
    Result := AParamsetSize1 = AParamsetSize2
  else
    Result := ((AParamsetSize1 = 0) or (AParamsetSize1 = 1)) and
              ((AParamsetSize2 = 0) or (AParamsetSize2 = 1));
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.UseExecDirect: Boolean;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  Result := GetResourceOptions.DirectExecute;
  if not Result then begin
    Result := (GetCommandKind in [skStoredProc, skStoredProcNoCrs]) or
      (GetCommandKind = skStoredProcWithCrs) and not (cpLongData in FStatementProps);
    if Result then begin
      GetConnection.CreateMetadata(oConnMeta);
      Result := (oConnMeta.Kind in [mkMSSQL, mkASA]);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.GenerateSPSQL(const ACatalog, ASchema,
  APackage, ACmd: String): String;
var
  i: Integer;
  oParams: TADParams;
  oParam: TADParam;
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
  lWasParam: Boolean;
begin
  oParams := GetParams;
  Result := '{';
  for i := 0 to oParams.Count - 1 do
    if oParams[i].ParamType = ptResult then begin
      Result := Result + '? = ';
      Break;
    end;
  Result := Result + 'CALL ';

  GetConnection.CreateMetadata(oConnMeta);
  rName.FCatalog := ACatalog;
  rName.FSchema := ASchema;
  rName.FBaseObject := APackage;
  rName.FObject := ACmd;
  Result := Result + oConnMeta.EncodeObjName(rName, Self, [eoQuote, eoNormalize]);

  lWasParam := False;
  for i := 0 to oParams.Count - 1 do begin
    oParam := oParams[i];
    if oParam.ParamType <> ptResult then begin
      if lWasParam then
        Result := Result + ', '
      else begin
        Result := Result + '(';
        lWasParam := True;
      end;
      if oParam.ArrayType = atPLSQLTable then
        Result := Result + '{RESULTSET ' + IntToStr(oParam.ArraySize) + ', ' + oParam.Name + '}'
      else
        Result := Result + '?';
    end;
  end;

  if lWasParam then
    Result := Result + ')';
  Result := Result + '}';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.InternalPrepare;
var
  rName: TADPhysParsedName;
  oConnMeta: IADPhysConnectionMetadata;
begin
  try
    if GetMetaInfoKind = mkNone then begin
      GetConnection.CreateMetadata(oConnMeta);
      if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
        oConnMeta.DecodeObjName(Trim(GetCommandText()), rName, Self, [doNormalize, doUnquote]);
        with rName do begin
          if fiMeta in GetFetchOptions.Items then
            FillStoredProcParams(FCatalog, FSchema, FBaseObject, FObject);
          FDbCommandText := GenerateSPSQL(FCatalog, FSchema, FBaseObject, FObject);
        end;
      end
      else begin
        if GetCommandKind = skUnknown then
          SetCommandKind(skSelect);
      end;

      FCommandStatement := TODBCCommandStatement.Create(GetConnection.ODBCConnection, Self);
      FStatement := FCommandStatement;
      SetupStatementBeforePrepare(FStatement);

      Include(FStatementProps, cpParamsNotSet);
      if not UseExecDirect then
        FCommandStatement.Prepare(FDbCommandText);
      if GetParams.ActiveCount > 0 then begin
        CreateParamsInfo;
        FCommandStatement.BindParameters(GetParamsetSize(GetParams.ArraySize), True);
      end;
    end
    else begin
      if GetCommandKind = skUnknown then
        SetCommandKind(skSelect);
      FMetainfoStatement := TODBCMetaInfoStatement.Create(GetConnection.ODBCConnection, Self);
      FStatement := FMetainfoStatement;
      SetupStatementBeforePrepare(FStatement);
    end;
  except
    InternalUnprepare;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.InternalUnprepare;
begin
  CloseStatement(-1, True);
  DestroyParamsInfo;
  DestroyDescribeInfo;
  FCommandStatement := nil;
  FMetainfoStatement := nil;
  FMetainfoAddonView := nil;
  FreeAndNil(FStatement);
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean;
begin
  Result := OpenBlocked;
  if Result and (ATabInfo.FSourceID = -1) then begin
    { TODO : Use on next line GetCommandText ? }
    ATabInfo.FSourceName := FStatement.CURSOR_NAME;
    ATabInfo.FSourceID := 1;
    ATabInfo.FOriginName := '';
    FColumnIndex := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  pColInfo: PDEODBCColInfoRec;
begin
  with AColInfo do
    if FColumnIndex < FColumnsInfo.Count then begin
      pColInfo := PDEODBCColInfoRec(FColumnsInfo[FColumnIndex]);

      FSourceName := pColInfo^.FName;
      FSourceID := FColumnIndex + 1;
      FOriginName := FSourceName;
      FType := pColInfo^.FDestDataType;
      FTypeName := '';
      FLen := pColInfo^.FADLen;
      if FType in [dtDouble, dtCurrency, dtBCD, dtFmtBCD] then begin
        FPrec := pColInfo^.FColSize;
        FScale := pColInfo^.FScale;
      end
      else begin
        FPrec := 0;
        FScale := 0;
      end;

      FForceAddOpts := [];
      FAttrs := pColInfo^.FAttrs;
      if caAutoInc in FAttrs then
        Include(FForceAddOpts, coAfterInsChanged);
      Inc(FColumnIndex);
      Result := True;
    end
    else
      Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.CheckParamMatching(APar: TADParam; AParInfo: PDEODBCParInfoRec);
begin
  if (AParInfo^.FParamType <> C_AD_ParType2SQLParType[APar.ParamType]) or
     (AParInfo^.FDataType <> APar.DataType) then
    ParDefChangedError(APar);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.CheckParamArraySizesMatching;
var
  i: Integer;
  oParams: TADParams;
  oParam0: TADParam;
begin
  oParams := GetParams;
  if oParams.Count > 1 then begin
    oParam0 := oParams[0];
    for i := 1 to oParams.Count - 1 do
      if oParam0.ArraySize <> oParams[i].ArraySize then
        ADException(Self, [S_AD_LPhys, S_AD_ODBCId], er_AD_OdbcParamArrMismatch,
          [oParams[i].Name]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.SetParamValues(AFromParIndex: Integer);
var
  oParams: TADParams;
  oFmtOpts: TADFormatOptions;
  oParam: TADParam;
  iArraySize, i, j, iActive: Integer;
  iMaxNumBefDot, iMaxNumScale: SQLSmallint;
  iMaxStrSize: SQLUInteger;
  pParInfo: PDEODBCParInfoRec;
  lRebind: Boolean;

  procedure ProcessArrayItem(AParam: TADParam; ApInfo: PDEODBCParInfoRec;
    AVarNum: Integer; AVarIndex, AParIndex: Integer);
  var
    pBuffer: PChar;
    iDataSize, iSrcSize: LongWord;
  begin
    iDataSize := 0;
    iSrcSize := 0;
    pBuffer := nil;
    with ApInfo^ do begin
      if AParam.IsNulls[AParIndex] then
        FVar.SetData(AVarIndex, nil, 0)
      else begin
        if FSrcDataType = FOutDataType then begin
          if FOutDataType in [dtAnsiString, dtMemo,
                              dtWideString, dtWideMemo,
                              dtBlob] then begin
            AParam.GetBlobRawData(iDataSize, pBuffer, AParIndex);
            FVar.SetData(AVarIndex, pBuffer, iDataSize);
          end
          else begin
            iSrcSize := AParam.GetDataSize(AParIndex);
            FBuffer.Check(iSrcSize);
            AParam.GetData(FBuffer.Ptr, AParIndex);
            FVar.SetData(AVarIndex, FBuffer.Ptr, iSrcSize);
          end;
        end
        else begin
          iSrcSize := AParam.GetDataSize(AParIndex);
          FBuffer.Extend(iSrcSize, iDataSize, FSrcDataType, FOutDataType);

          AParam.GetData(FBuffer.Ptr, AParIndex);
          oFmtOpts.ConvertRawData(FSrcDataType, FOutDataType, FBuffer.Ptr, iSrcSize,
            FBuffer.FBuffer, FBuffer.Size, iDataSize);
          FVar.SetData(AVarIndex, FBuffer.Ptr, iDataSize);
        end;
        if (FOutDataType = dtBCD) or (FOutDataType = dtFmtBCD) then begin
          if iMaxNumScale < PADBcd(FBuffer.Ptr)^.SignSpecialPlaces AND $3F then
            iMaxNumScale := SQLSmallint(PADBcd(FBuffer.Ptr)^.SignSpecialPlaces AND $3F);
          if iMaxNumBefDot < (PADBcd(FBuffer.Ptr)^.Precision - PADBcd(FBuffer.Ptr)^.SignSpecialPlaces AND $3F) then
            iMaxNumBefDot := SQLSmallint(PADBcd(FBuffer.Ptr)^.Precision - PADBcd(FBuffer.Ptr)^.SignSpecialPlaces AND $3F);
        end
        else if FOutDataType in C_AD_VarLenTypes then begin
          if (iSrcSize <> 0) and (iDataSize = 0) then
            iDataSize := iSrcSize;
          if SQLUInteger(iDataSize) < AParam.Size then
            iDataSize := AParam.Size;
          if iMaxStrSize < SQLUInteger(iDataSize) then
            iMaxStrSize := iDataSize;
        end;
      end;
    end;
  end;

begin
  if FCommandStatement = nil then
    Exit;

  oParams := GetParams;
  iArraySize := oParams.ArraySize;

  ASSERT((AFromParIndex <> -1) or (iArraySize = 1) or (cpParamSetSupports in FStatementProps));
  CheckParamArraySizesMatching;
  if not MatchParamsetSize(GetParamsetSize(iArraySize), FCommandStatement.PARAMSET_SIZE) then
    FCommandStatement.BindParameters(GetParamsetSize(iArraySize), True);

  oFmtOpts := GetOptions.FormatOptions;
  iActive := 0;

  for i := 0 to oParams.Count - 1 do begin
    oParam := oParams[i];
    if oParam.Active and (oParam.DataType <> ftCursor) then begin
      pParInfo := PDEODBCParInfoRec(FParamsInfo[iActive]);
      CheckParamMatching(oParam, pParInfo);
      if pParInfo^.FVar <> nil then begin
        iMaxNumBefDot := -1;
        iMaxNumScale := -1;
        iMaxStrSize := -1;
        if AFromParIndex = -1 then
          for j := 0 to iArraySize - 1 do
            ProcessArrayItem(oParam, pParInfo, iActive, j, j)
        else
          ProcessArrayItem(oParam, pParInfo, iActive, 0, AFromParIndex);
        with pParInfo^.FVar do begin
          lRebind := False;
          if (ParamType = SQL_PARAM_OUTPUT) and not Binded then
            lRebind := True;
          if ((iMaxNumBefDot >= 0) or (iMaxNumScale >= 0) or (iMaxStrSize >= 0)) and
             ((cpParamsNotSet in FStatementProps) or (ColumnSize < iMaxNumBefDot + iMaxNumScale) or
              (Scale < iMaxNumScale)) then begin
            ColumnSize := iMaxNumBefDot + iMaxNumScale;
            Scale := iMaxNumScale;
            lRebind := True;
          end;
          if (iMaxStrSize >= 0) and (
              (cpParamsNotSet in FStatementProps) or (ColumnSize < iMaxStrSize)) then begin
            if iMaxStrSize = 0 then
              iMaxStrSize := 1;
            ColumnSize := iMaxStrSize;
            lRebind := True;
          end;
          if lRebind then
            Bind;
        end;
      end;
      Inc(iActive);
    end;
  end;
  Exclude(FStatementProps, cpParamsNotSet);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.GetParamValues(AFromParIndex: Integer);
var
  oParams: TADParams;
  oFmtOpts: TADFormatOptions;
  iArraySize, i, j, iActive: Integer;
  oParam: TADParam;
  pParInfo: PDEODBCParInfoRec;

  procedure ProcessArrayItem(AParam: TADParam; ApInfo: PDEODBCParInfoRec;
    AVarNum: Integer; AVarIndex, AParIndex: Integer);
  var
    iSize: SQLInteger;
    pData: SQLPointer;
    iDestDataLen: LongWord;
  begin
    with ApInfo^ do begin
      pData := nil;
      iSize := 0;
      if not FVar.GetData(AVarIndex, pData, iSize, True) then
        AParam.Clear(AParIndex)
      else if FOutDataType = FSrcDataType then begin
        if FOutDataType in [dtAnsiString, dtMemo,
                            dtWideMemo, dtWideString,
                            dtBlob] then
          AParam.SetData(PChar(pData), iSize, AParIndex)
        else begin
          FBuffer.Check(iSize);
          FVar.GetData(AVarIndex, FBuffer.FBuffer, iSize, False);
          AParam.SetData(FBuffer.Ptr, iSize, AParIndex);
        end;
      end
      else begin
        FBuffer.Check(iSize);
        FVar.GetData(AVarIndex, FBuffer.FBuffer, iSize, False);
        iDestDataLen := 0;
        oFmtOpts.ConvertRawData(FOutDataType, FSrcDataType, FBuffer.Ptr,
          iSize, FBuffer.FBuffer, FBuffer.Size, iDestDataLen);
        AParam.SetData(FBuffer.Ptr, iDestDataLen, AParIndex);
      end;
    end;
  end;

begin
  if FCommandStatement = nil then
    Exit;

  oParams := GetParams;
  iArraySize := oParams.ArraySize;
  if (AFromParIndex = -1) and not (cpParamSetSupports in FStatementProps) then
    AFromParIndex := 0;

  CheckParamArraySizesMatching;
  ASSERT(MatchParamsetSize(GetParamsetSize(iArraySize), FCommandStatement.PARAMSET_SIZE));

  oFmtOpts := GetFormatOptions;
  iActive := 0;
  for i := 0 to oParams.Count - 1 do begin
    oParam := oParams[i];
    if oParam.Active then begin
      if (oParam.ParamType in [ptOutput, ptResult, ptInputOutput]) and
         (oParam.DataType <> ftCursor) then begin
        pParInfo := PDEODBCParInfoRec(FParamsInfo[iActive]);
        CheckParamMatching(oParam, pParInfo);
        if pParInfo^.FVar <> nil then
          if AFromParIndex = -1 then
            for j := 0 to iArraySize - 1 do
              ProcessArrayItem(oParam, pParInfo, iActive, j, j)
          else
            ProcessArrayItem(oParam, pParInfo, iActive, 0, AFromParIndex);
      end;
      Inc(iActive);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.InternalExecute(ATimes: LongInt; AOffset: LongInt;
  var ACount: LongInt);
var
  i, iTmpCount: Integer;
  oFO: TADFetchOptions;
  sCmd: String;
  oConnMeta: IADPhysConnectionMetadata;
begin
  FOnNextResult := False;
  ACount := 0;
  oFO := GetFetchOptions;
  try
    try
      if UseExecDirect then
        sCmd := FDbCommandText
      else
        sCmd := '';
      if (cpParamSetSupports in FStatementProps) or (ATimes = 1) and (AOffset = 0) then begin
        SetParamValues(-1);
        Exclude(FStatementProps, cpCursorClosed);
        TADPhysODBCConnectionBase(FConnectionObj).Execute(Self,
          ATimes, AOffset, ACount, oFO.Mode = fmExactRecsMax, sCmd);
        if GetState <> csAborting then begin
          if not FCommandStatement.ResultColsExists then begin
            FOnNextResult := True;
            FOnNextResultValue := GetCursor;
          end;
          GetParamValues(-1);
        end;
      end
      else begin
        for i := AOffset to ATimes - 1 do begin
          SetParamValues(i);
          Exclude(FStatementProps, cpCursorClosed);
          iTmpCount := 0;
          TADPhysODBCConnectionBase(FConnectionObj).Execute(Self,
            1, 0, iTmpCount, oFO.Mode = fmExactRecsMax, sCmd);
          Inc(ACount, iTmpCount);
          if GetState <> csAborting then
            CloseStatement(i, True)
          else
            Break;
        end;
      end;
    finally
      if ACount < 0 then
        ACount := 0
      else if ACount = 0 then begin
        GetConnection.CreateMetadata(oConnMeta);
        if (oConnMeta.Kind = mkMSSQL) and (FCommandStatement.SS_NOCOUNT_STATUS = SQL_NC_ON) then
          ACount := -1;
      end;
    end;
  except
    CloseStatement(-1, True);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.InternalAbort;
begin
  FStatement.Cancel;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.GetCursor: Boolean;
begin
  while not FStatement.ResultColsExists and FStatement.MoreResults do
    ;
  Result := FStatement.ResultColsExists;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.InternalOpen: Boolean;
var
  iTmpCount: Integer;
  sCmd: String;
begin
  FOnNextResult := False;
  try
    sCmd := '';
    if GetMetaInfoKind = mkNone then begin
      SetParamValues(-1);
      if UseExecDirect then
        sCmd := FDbCommandText;
      Exclude(FStatementProps, cpCursorClosed);
    end;
    iTmpCount := 0;
    Result := TADPhysODBCConnectionBase(FConnectionObj).Execute(Self,
      1, 0, iTmpCount, GetFetchOptions.Mode = fmExactRecsMax, sCmd);
    Result := Result and (GetState <> csAborting);

    if Result then begin
      Result := GetCursor;
      if GetMetaInfoKind = mkNone then
        GetParamValues(-1);
      if Result and (FColumnsInfo.Count = 0) then begin
        CreateDescribeInfo;
        if (cpForceNonDefaultCrs in FStatementProps) and (cpDefaultCrs in FStatementProps) then begin
          InternalUnprepare;
          InternalPrepare;
          Result := InternalOpen;
          Exit;
        end;
        FStatement.BindColumns(GetRowsetSize(GetFetchOptions.ActualRowsetSize));
      end;
    end;

    if not Result then
      CloseStatement(-1, True);
  except
    CloseStatement(-1, True);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.InternalClose;
begin
  CloseStatement(-1, False);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.CloseStatement(AIndex: Integer;
  AForceClose: Boolean);
begin
  if AForceClose or not GetNextRecordSet then
    if (FStatement <> nil) and not (cpCursorClosed in FStatementProps) then
      try
        while FStatement.MoreResults do
          ;
        GetParamValues(AIndex);
        FStatement.Close;
      finally
        Include(FStatementProps, cpCursorClosed);
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCCommand.FetchRow(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowIndex: SQLUInteger);
var
  oRow: TADDatSRow;
  pData: SQLPointer;
  iSize: SQLUInteger;
  oFmtOpts: TADFormatOptions;
  pColInfo: PDEODBCColInfoRec;
  j: Integer;
  iDestDataLen: LongWord;
begin
  oFmtOpts := GetFormatOptions;
  oRow := ATable.NewRow(False);
  try
    for j := 0 to ATable.Columns.Count - 1 do
      with ATable.Columns[j] do
        if (SourceID > 0) and CheckFetchColumn(SourceDataType) then begin
          pColInfo := PDEODBCColInfoRec(FColumnsInfo[SourceID - 1]);
          with pColInfo^ do
            if FVar <> nil then begin
              pData := nil;
              iSize := 0;
              if not FVar.GetData(ARowIndex, pData, iSize, True) then
                oRow.SetData(j, nil, 0)
              else if FOutDataType = FDestDataType then
                if FDestDataType in [dtAnsiString, dtMemo,
                                     dtWideString, dtWideMemo,
                                     dtBlob] then
                  oRow.SetData(j, pData, iSize)
                else begin
                  FBuffer.Check(iSize);
                  FVar.GetData(ARowIndex, FBuffer.FBuffer, iSize, False);
                  oRow.SetData(j, FBuffer.Ptr, iSize);
                end
              else begin
                FBuffer.Check(iSize);
                FVar.GetData(ARowIndex, FBuffer.FBuffer, iSize, False);
                iDestDataLen := 0;
                oFmtOpts.ConvertRawData(FOutDataType, FDestDataType, FBuffer.Ptr,
                  iSize, FBuffer.FBuffer, FBuffer.Size, iDestDataLen);
                oRow.SetData(j, FBuffer.Ptr, iDestDataLen);
              end;
            end;
        end;
    if AParentRow <> nil then begin
      oRow.ParentRow := AParentRow;
      AParentRow.Fetched[ATable.Columns.ParentCol] := True;
    end;
    ATable.Rows.Add(oRow);
  except
    oRow.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.InternalFetchRowSet(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowsetSize: LongWord): LongWord;
var
  i, iRowsetSize, iRowsFetched: Integer;
begin
  Result := 0;
  if (GetMetaInfoKind <> mkNone) and not FStatement.IsExecuted then
    Exit;
  iRowsetSize := GetRowsetSize(ARowsetSize);
  while Result < ARowsetSize do begin
    iRowsFetched := FStatement.Fetch(iRowsetSize);
    for i := 0 to iRowsFetched - 1 do
      if GetMetaInfoKind = mkNone then begin
        FetchRow(ATable, AParentRow, i);
        Inc(Result);
      end
      else begin
        if FetchMetaRow(ATable, AParentRow, i) then
          Inc(Result);
      end;
    if iRowsFetched <> iRowsetSize then
      Break;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.InternalNextRecordSet: Boolean;
begin
  Result := False;
  if (GetMetaInfoKind = mkNone) and (FCommandStatement <> nil) then begin
    DestroyDescribeInfo;
    if FOnNextResult then begin
      FOnNextResult := False;
      Result := FOnNextResultValue;
    end
    else
      Result := FStatement.MoreResults and GetCursor;
    if not Result then
      CloseStatement(-1, True)
    else begin
      CreateDescribeInfo;
      FStatement.BindColumns(GetRowsetSize(GetFetchOptions.ActualRowsetSize));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.OpenMetaInfo: Boolean;
var
  sCatalog, sSchema, sName, sTableTypes: String;
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;

  procedure AddTableType(AType: String);
  begin
    if sTableTypes <> '' then
      sTableTypes := sTableTypes + ',';
    sTableTypes := sTableTypes + AType;
  end;

  procedure SetCatalogSchemaFromObj;
  begin
    sCatalog := rName.FCatalog;
    sSchema := rName.FSchema;
  end;

  procedure SetCatalogSchema;
  begin
    sCatalog := GetCatalogName;
    sSchema := GetSchemaName;
  end;

  procedure GetObjName;
  begin
    GetConnection.CreateMetadata(oConnMeta);
    oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self, [doNormalize, doUnquote]);
    CheckMetaInfoParams(rName);
  end;

begin
  Result := True;
  try
    case GetMetaInfoKind of
    mkTables:
      begin
        SetCatalogSchema;
        if tkTable in GetTableKinds then
          AddTableType('TABLE');
        if tkView in GetTableKinds then
          AddTableType('VIEW');
        if tkSynonym in GetTableKinds then
          AddTableType('SYNONYM');
        if tkTempTable in GetTableKinds then
          AddTableType('GLOBAL TEMPORARY');
        if tkLocalTable in GetTableKinds then
          AddTableType('LOCAL TEMPORARY');
        if (osSystem in GetObjectScopes) and (tkTable in GetTableKinds) then
          AddTableType('SYSTEM TABLE');
        FMetainfoStatement.Tables(sCatalog, sSchema, GetWildcard, sTableTypes);
      end;
    mkTableFields:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        { TODO : here we should fetch-all SQLSpecialColumns }
        FMetainfoStatement.Columns(sCatalog, sSchema, rName.FObject, GetWildcard);
      end;
    mkIndexes:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        GetConnection.CreateMetadata(oConnMeta);
        FMetainfoAddonView := oConnMeta.GetTablePrimaryKey(sCatalog, sSchema, GetCommandText);
        FMetainfoStatement.Statistics(sCatalog, sSchema, rName.FObject, SQL_INDEX_ALL);
      end;
    mkIndexFields:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        FMetainfoStatement.Statistics(sCatalog, sSchema, rName.FBaseObject, SQL_INDEX_ALL);
      end;
    mkPrimaryKey:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        if TADPhysODBCConnectionBase(FConnectionObj).FPKFunction then
          FMetainfoStatement.PrimaryKeys(sCatalog, sSchema, rName.FObject)
        else
          FMetainfoStatement.SpecialColumns(sCatalog, sSchema, rName.FObject, SQL_BEST_ROWID);
      end;
    mkPrimaryKeyFields:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        if TADPhysODBCConnectionBase(FConnectionObj).FPKFunction then
          FMetainfoStatement.PrimaryKeys(sCatalog, sSchema, rName.FBaseObject)
        else
          FMetainfoStatement.SpecialColumns(sCatalog, sSchema, rName.FBaseObject, SQL_BEST_ROWID);
      end;
    mkForeignKeys:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        FMetainfoStatement.ForeignKeys('', '', '', sCatalog, sSchema, rName.FObject);
      end;
    mkForeignKeyFields:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        FMetainfoStatement.ForeignKeys('', '', '', sCatalog, sSchema, rName.FBaseObject);
      end;
    mkPackages:
      Result := False;
    mkProcs:
      begin
        GetObjName;
        if rName.FBaseObject <> '' then
          SetCatalogSchemaFromObj
        else
          SetCatalogSchema;
        FMetainfoStatement.Procedures(sCatalog, sSchema, GetWildcard);
      end;
    mkProcArgs:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        if rName.FBaseObject <> '' then
          sName := rName.FBaseObject + '.';
        FMetainfoStatement.ProcedureColumns(sCatalog, sSchema, sName + rName.FObject, GetWildcard);
      end;
    end;
    if Result then
      FMetainfoStatement.Execute;
  except
    on E: EODBCNativeException do begin
      GetConnection.CreateMetadata(oConnMeta);
      if (oConnMeta.Kind = mkMSAccess) and (E.Errors[0].ErrorCode = -1034) then
        Result := False
      else
        raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCCommand.FetchMetaRow(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowIndex: SQLUInteger): Boolean;
var
  oRow: TADDatSRow;
  pData: SQLPointer;
  iSize: SQLUInteger;
  eTableKind: TADPhysTableKind;
  eScope: TADPhysObjectScope;
  iLen: LongWord;
  iPrec, iScale: Integer;
  eType: TADDataType;
  eAttrs: TADDataAttributes;
  iODBCType: SQLSmallint;
  iODBCSize: SQLInteger;
  iODBCDec: SQLSmallint;
  eIndKind: TADPhysIndexKind;
  rName, rName2: TADPhysParsedName;
  lDeleteRow: Boolean;
  oConnMeta: IADPhysConnectionMetadata;
  eProcKind: TADPhysProcedureKind;
  eParType: TParamType;
  eCascade: TADPhysCascadeRuleKind;
  i: Integer;
  pCh: PChar;

  procedure GetScope(ARowColIndex: Integer; var AScope: TADPhysObjectScope);
  begin
    if AnsiCompareText(VarToStr(oRow.GetData(ARowColIndex, rvDefault)),
                       TADPhysODBCConnectionBase(FConnectionObj).FDefaultSchemaName) = 0 then
      AScope := osMy
    else
      AScope := osOther;
  end;

  procedure AdjustMaxVarLen(AODBCType: SQLSmallint; var AODBCSize: SQLInteger);
  begin
    if (oConnMeta.Kind = mkMSSQL) and (AODBCSize = SQL_SS_LENGTH_UNLIMITED) and
       ((AODBCType = SQL_VARCHAR) or (AODBCType = SQL_VARBINARY) or (AODBCType = SQL_WVARCHAR)) then
      AODBCSize := MAXINT;
  end;

begin
  lDeleteRow := False;
  oRow := ATable.NewRow(False);
  pData := FBuffer.Ptr;
  try
    FConnection.CreateMetadata(oConnMeta);
    case GetMetaInfoKind of
    mkTables:
      begin
        oRow.SetData(0, ATable.Rows.Count + 1);
        iSize := 0;
        if FStatement.ColumnList[0].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(1, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(2, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[2].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(3, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[3].GetData(ARowIndex, pData, iSize) then begin
          eTableKind := tkTable;
          eScope := osOther;
          GetScope(2, eScope);
          if StrLIComp(pData, 'TABLE', iSize) = 0 then
            eTableKind := tkTable
          else if StrLIComp(pData, 'VIEW', iSize) = 0 then
            eTableKind := tkView
          else if StrLIComp(pData, 'SYSTEM TABLE', iSize) = 0 then begin
            eTableKind := tkTable;
            eScope := osSystem;
          end
          else if StrLIComp(pData, 'GLOBAL TEMPORARY', iSize) = 0 then
            eTableKind := tkTempTable
          else if StrLIComp(pData, 'LOCAL TEMPORARY', iSize) = 0 then
            eTableKind := tkLocalTable
          else if StrLIComp(pData, 'ALIAS', iSize) = 0 then
            eTableKind := tkSynonym
          else if StrLIComp(pData, 'SYNONYM', iSize) = 0 then
            eTableKind := tkSynonym;
          oRow.SetData(4, Smallint(eTableKind));
          oRow.SetData(5, Smallint(eScope));
        end;
      end;
    mkTableFields:
      begin
        oRow.SetData(0, ATable.Rows.Count + 1);
        iSize := 0;
        if FStatement.ColumnList[0].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(1, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(2, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[2].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(3, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[3].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(4, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList.Count >= 17 then begin
          if FStatement.ColumnList[16].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(5, PSQLInteger(pData)^);
        end
        else
          oRow.SetData(5, ATable.Rows.Count + 1);
        iSize := 0;
        if FStatement.ColumnList[5].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(7, pData, iSize);
        eAttrs := [];
        iSize := 0;
        if FStatement.ColumnList.Count >= 13 then
          if FStatement.ColumnList[12].GetData(ARowIndex, pData, iSize) and (iSize > 0) then
            Include(eAttrs, caDefault);
        iSize := 0;
        if not FStatement.ColumnList[10].GetData(ARowIndex, pData, iSize) or
           (PSQLSmallint(pData)^ <> SQL_NO_NULLS) then
          Include(eAttrs, caAllowNull);
        iSize := 0;
        if FStatement.ColumnList[4].GetData(ARowIndex, pData, iSize) then
          iODBCType := PSQLSmallint(pData)^
        else
          iODBCType := SQL_TYPE_NULL;
        iSize := 0;
        if FStatement.ColumnList[6].GetData(ARowIndex, pData, iSize) then begin
          iODBCSize := PSQLInteger(pData)^;
          AdjustMaxVarLen(iODBCType, iODBCSize);
        end
        else
          iODBCSize := 0;
        iSize := 0;
        if FStatement.ColumnList[8].GetData(ARowIndex, pData, iSize) then
          iODBCDec := PSQLSmallint(pData)^
        else
          iODBCDec := 0;
        eType := dtUnknown;
        iLen := 0;
        iPrec := 0;
        iScale := 0;
        SQL2ADColInfo(iODBCType, iODBCSize, iODBCDec, eType, eAttrs, iLen, iPrec,
          iScale, oConnMeta);
        oRow.SetData(6, Smallint(eType));
        oRow.SetData(8, PWord(@eAttrs)^);
        oRow.SetData(9, iPrec);
        oRow.SetData(10, iScale);
{$IFDEF AnyDAC_D6Base}
        oRow.SetData(11, iLen);
{$ELSE}
        oRow.SetData(11, Integer(iLen));
{$ENDIF}
        { TODO : use SQLSpecialColumns data }
  {
        if iDbxType and eSQLRowId <> 0 then
          Include(eAttrs, caROWID);
        if iDbxType and eSQLRowVersion <> 0 then
          Include(eAttrs, caRowVersion);
        if iDbxType and eSQLAutoIncr <> 0 then
          Include(eAttrs, caAutoInc);
  }
      end;
    mkIndexes:
      begin
        iSize := 0;
        if FStatement.ColumnList[6].GetData(ARowIndex, pData, iSize) and
           (PSQLSmallint(pData)^ = SQL_TABLE_STAT) then
          lDeleteRow := True
        else begin
          oRow.SetData(0, ATable.Rows.Count + 1);
          iSize := 0;
          if FStatement.ColumnList[0].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(1, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(2, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[2].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(3, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[5].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(4, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[3].GetData(ARowIndex, pData, iSize) and
             (PSQLSmallint(pData)^ = SQL_FALSE) then
            eIndKind := ikUnique
          else
            eIndKind := ikNonUnique;
          FMetainfoAddonView.RowFilter := 'INDEX_NAME = ''' + VarToStr(oRow.GetData(4)) + '''';
          if FMetainfoAddonView.Rows.Count > 0 then begin
            eIndKind := ikPrimaryKey;
            oRow.SetData(5, FMetainfoAddonView.Rows[0].GetData(5));
          end;
          oRow.SetData(6, Smallint(eIndKind));
          FMetainfoAddonView.RowFilter := '';
          for i := 0 to ATable.Rows.Count - 1 do
            if ATable.Rows[i].GetData(4, rvDefault) = oRow.GetData(4, rvDefault) then begin
              lDeleteRow := True;
              Break;
            end;
        end;
      end;
    mkIndexFields:
      begin
        iSize := 0;
        if FStatement.ColumnList[6].GetData(ARowIndex, pData, iSize) and
           (PSQLSmallint(pData)^ = SQL_TABLE_STAT) then
          lDeleteRow := True
        else begin
          oRow.SetData(0, ATable.Rows.Count + 1);
          iSize := 0;
          if FStatement.ColumnList[0].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(1, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(2, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[2].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(3, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[5].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(4, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[8].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(5, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[7].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(6, PSQLSmallint(pData)^);
          iSize := 0;
          if FStatement.ColumnList[9].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(7, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[12].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(8, pData, iSize);
          oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self,
            [doNormalize, doUnquote]);
          oConnMeta.DecodeObjName(Trim(VarToStr(oRow.GetData(4, rvDefault))), rName2, Self,
            [doNormalize, doUnquote]);
          lDeleteRow := (AnsiCompareText(rName.FObject, rName2.FObject) <> 0);
        end;
      end;
    mkPrimaryKey:
      begin
        if TADPhysODBCConnectionBase(FConnectionObj).FPKFunction then begin
          oRow.SetData(0, ATable.Rows.Count + 1);
          iSize := 0;
          if FStatement.ColumnList[0].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(1, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(2, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[2].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(3, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[5].GetData(ARowIndex, pData, iSize) then begin
            oRow.SetData(4, pData, iSize);
            oRow.SetData(5, pData, iSize);
          end;
          oRow.SetData(6, Smallint(ikPrimaryKey));
          for i := 0 to ATable.Rows.Count - 1 do
            if ATable.Rows[i].GetData(5, rvDefault) = oRow.GetData(5, rvDefault) then begin
              lDeleteRow := True;
              Break;
            end;
        end
        else begin
          lDeleteRow := ARowIndex > 0;
          if not lDeleteRow then begin
            oRow.SetData(0, ATable.Rows.Count + 1);
            oConnMeta.DecodeObjName(Trim(GetCatalogName), rName, Self,
              [doNormalize, doUnquote]);
            oRow.SetData(1, rName.FObject);
            oConnMeta.DecodeObjName(Trim(GetSchemaName), rName, Self,
              [doNormalize, doUnquote]);
            oRow.SetData(2, rName.FObject);
            oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self,
              [doNormalize, doUnquote]);
            oRow.SetData(3, rName.FObject);
            oRow.SetData(4, C_AD_BestRowID);
            oRow.SetData(5, C_AD_BestRowID);
            oRow.SetData(6, Smallint(ikPrimaryKey));
          end;
        end;
      end;
    mkPrimaryKeyFields:
      begin
        oRow.SetData(0, ATable.Rows.Count + 1);
        if TADPhysODBCConnectionBase(FConnectionObj).FPKFunction then begin
          iSize := 0;
          if FStatement.ColumnList[0].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(1, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(2, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[2].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(3, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[5].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(4, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[3].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(5, pData, iSize);
          iSize := 0;
          if FStatement.ColumnList[4].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(6, PSQLSmallint(pData)^);
        end
        else begin
          oConnMeta.DecodeObjName(Trim(GetCatalogName), rName, Self,
              [doNormalize, doUnquote]);
          oRow.SetData(1, rName.FObject);
          oConnMeta.DecodeObjName(Trim(GetSchemaName), rName, Self,
              [doNormalize, doUnquote]);
          oRow.SetData(2, rName.FObject);
          oConnMeta.DecodeObjName(Trim(GetBaseObjectName), rName, Self,
              [doNormalize, doUnquote]);
          oRow.SetData(3, rName.FObject);
          oRow.SetData(4, C_AD_BestRowID);
          iSize := 0;
          if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(5, pData, iSize);
          oRow.SetData(6, ATable.Rows.Count + 1);
        end;
        oRow.SetData(7, 'A');
      end;
    mkForeignKeys:
      begin
        oRow.SetData(0, ATable.Rows.Count + 1);
        iSize := 0;
        if FStatement.ColumnList[4].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(1, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[5].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(2, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[6].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(3, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[11].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(4, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[0].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(5, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(6, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[2].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(7, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[10].GetData(ARowIndex, pData, iSize) then begin
          eCascade := ckNone;
          case PSQLSmallInt(pData)^ of
          SQL_CASCADE:     eCascade := ckCascade;
          SQL_RESTRICT:    eCascade := ckRestrict;
          SQL_SET_NULL:    eCascade := ckSetNull;
          SQL_SET_DEFAULT: eCascade := ckSetDefault;
          end;
          oRow.SetData(8, SmallInt(eCascade));
        end;
        iSize := 0;
        if FStatement.ColumnList[9].GetData(ARowIndex, pData, iSize) then begin
          eCascade := ckNone;
          case PSQLSmallInt(pData)^ of
          SQL_CASCADE:     eCascade := ckCascade;
          SQL_RESTRICT:    eCascade := ckRestrict;
          SQL_SET_NULL:    eCascade := ckSetNull;
          SQL_SET_DEFAULT: eCascade := ckSetDefault;
          end;
          oRow.SetData(9, SmallInt(eCascade));
        end;
        for i := 0 to ATable.Rows.Count - 1 do
          if ATable.Rows[i].GetData(4, rvDefault) = oRow.GetData(4, rvDefault) then begin
            lDeleteRow := True;
            Break;
          end;
      end;
    mkForeignKeyFields:
      begin
        oRow.SetData(0, ATable.Rows.Count + 1);
        iSize := 0;
        if FStatement.ColumnList[4].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(1, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[5].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(2, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[6].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(3, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[11].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(4, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[7].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(5, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[3].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(6, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[8].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(7, pData, iSize);
        oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self,
          [doNormalize, doUnquote]);
        oConnMeta.DecodeObjName(Trim(VarToStr(oRow.GetData(4, rvDefault))), rName2, Self,
          [doNormalize, doUnquote]);
        lDeleteRow := (AnsiCompareText(rName.FObject, rName2.FObject) <> 0);
      end;
    mkProcs:
      begin
        oRow.SetData(0, ATable.Rows.Count + 1);
        iSize := 0;
        if FStatement.ColumnList[0].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(1, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(2, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[2].GetData(ARowIndex, pData, iSize) then begin
          if oConnMeta.Kind = mkMSSQL then begin
            pCh := StrRScan(PChar(pData), ';');
            if (pCh <> nil) and ((pCh + 1)^ = '1') then
              Dec(iSize, 2);
          end;
          oRow.SetData(4, pData, iSize);
        end;
        iSize := 0;
        if FStatement.ColumnList[7].GetData(ARowIndex, pData, iSize) and
           (PSQLSmallint(pData)^ = SQL_PT_FUNCTION) then
          eProcKind := pkFunction
        else
          eProcKind := pkProcedure;
        oRow.SetData(6, Smallint(eProcKind));
        GetScope(2, eScope);
        oRow.SetData(7, Smallint(eScope));
        iSize := 0;
        if FStatement.ColumnList[3].GetData(ARowIndex, pData, iSize) then
          if PSmallint(pData)^ = -1 then
            oRow.SetData(8, 0)
          else
            oRow.SetData(8, PSmallint(pData)^);
        iSize := 0;
        if FStatement.ColumnList[4].GetData(ARowIndex, pData, iSize) then
          if PSmallint(pData)^ = -1 then
            oRow.SetData(9, 0)
          else
            oRow.SetData(9, PSmallint(pData)^);
      end;
    mkProcArgs:
      begin
        oRow.SetData(0, ATable.Rows.Count + 1);
        iSize := 0;
        if FStatement.ColumnList[0].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(1, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[1].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(2, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[2].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(4, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList[3].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(6, pData, iSize);
        iSize := 0;
        if FStatement.ColumnList.Count >= 18 then begin
          if FStatement.ColumnList[17].GetData(ARowIndex, pData, iSize) then
            oRow.SetData(7, PSQLInteger(pData)^);
        end
        else
          oRow.SetData(7, ATable.Rows.Count + 1);
        eParType := ptUnknown;
        iSize := 0;
        if FStatement.ColumnList[4].GetData(ARowIndex, pData, iSize) then
          case PSQLSmallint(pData)^ of
          SQL_PARAM_INPUT:        eParType := ptInput;
          SQL_PARAM_INPUT_OUTPUT: eParType := ptInputOutput;
          SQL_PARAM_OUTPUT:       eParType := ptOutput;
          SQL_RETURN_VALUE:       eParType := ptResult;
          SQL_RESULT_COL:         lDeleteRow := True;
          end;
        oRow.SetData(8, Smallint(eParType));
        iSize := 0;
        if FStatement.ColumnList[6].GetData(ARowIndex, pData, iSize) then
          oRow.SetData(10, pData, iSize);
        eAttrs := [];
        iSize := 0;
        if FStatement.ColumnList.Count >= 14 then begin
          if FStatement.ColumnList[13].GetData(ARowIndex, pData, iSize) and (iSize > 0) then
            Include(eAttrs, caDefault);
        end;
        iSize := 0;
        if not FStatement.ColumnList[11].GetData(ARowIndex, pData, iSize) or
           (PSQLSmallint(pData)^ <> SQL_NO_NULLS) then
          Include(eAttrs, caAllowNull);
        iSize := 0;
        if FStatement.ColumnList[5].GetData(ARowIndex, pData, iSize) then
          iODBCType := PSQLSmallint(pData)^
        else
          iODBCType := SQL_TYPE_NULL;
        iSize := 0;
        if FStatement.ColumnList[7].GetData(ARowIndex, pData, iSize) then begin
          iODBCSize := PSQLInteger(pData)^;
          AdjustMaxVarLen(iODBCType, iODBCSize);
        end
        else
          iODBCSize := 0;
        iSize := 0;
        if FStatement.ColumnList[9].GetData(ARowIndex, pData, iSize) then
          iODBCDec := PSQLSmallint(pData)^
        else
          iODBCDec := 0;
        SQL2ADColInfo(iODBCType, iODBCSize, iODBCDec, eType, eAttrs, iLen, iPrec,
          iScale, oConnMeta);
        oRow.SetData(9, Smallint(eType));
        oRow.SetData(11, PWord(@eAttrs)^);
        oRow.SetData(12, iPrec);
        oRow.SetData(13, iScale);
{$IFDEF AnyDAC_D6Base}
        oRow.SetData(14, iLen);
{$ELSE}
        oRow.SetData(14, Integer(iLen));
{$ENDIF}
      end;
    end;
    if lDeleteRow then begin
      oRow.Free;
      Result := False;
    end
    else begin
      ATable.Rows.Add(oRow);
      Result := True;
    end;
  except
    oRow.Free;
    raise;
  end;
end;

end.
