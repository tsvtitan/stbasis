{-------------------------------------------------------------------------------}
{ AnyDAC MySQL driver                                                           }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysMySQL;

interface

uses
  daADPhysManager;

type
  TADPhysMySQLDriverLink = class(TADPhysDriverLinkBase)
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  Windows, Classes, SysUtils, DB,
{$IFDEF AnyDAC_D6Base}
  Variants,
  {$IFDEF AnyDAC_D6}
  FmtBCD, SqlTimSt, DateUtils,
  {$ENDIF}
{$ENDIF}
  daADStanIntf, daADStanOption, daADStanParam, daADStanError, daADStanUtil,
    daADStanConst,
  daADGUIxIntf,
  daADDatSManager,
  daADPhysIntf, daADPhysMySQLWrapper, daADPhysCmdGenerator, daADPhysMySQLCli,
    daADPhysMySQLMeta;

type
  TADPhysMySQLDriver = class;
  TADPhysMySQLConnection = class;

  TADPhysMySQLDriver = class(TADPhysDriver)
  private
    FLib: TMySQLLib;
  protected
    function GetDescription: String; override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer;
      var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  public
    constructor Create(ADrvHost: TADPhysDriverHost); override;
    destructor Destroy; override;
    class function GetDriverID: String; override;
  end;

  TADPhysMySQLResultMode = (hrStore, hrUse, hrChoose);
  TADPhysMySQLCharset = (csAnsi, csUtf8, csUcs2);

  TADPhysMySQLConnection = class(TADPhysConnection)
  private
    FSession: TMySQLSession;
{$IFDEF AnyDAC_D7}
    FFormatSettings: TFormatSettings;
{$ENDIF}
    FServerVersion, FClientVersion: LongWord;
    FLock: TRTLCriticalSection;
    FResultMode: TADPhysMySQLResultMode;
    FNameCaseSensitive: Boolean;
    FCharset: TADPhysMySQLCharset;
  protected
    procedure InternalConnect; override;
    procedure InternalDisconnect; override;
    function InternalCreateCommand: TADPhysCommand; override;
    procedure InternalTxBegin(ATxID: LongWord); override;
    procedure InternalTxCommit(ATxID: LongWord); override;
    procedure InternalTxRollback(ATxID: LongWord); override;
    procedure InternalTxSetSavepoint(const AName: String); override;
    procedure InternalTxRollbackToSavepoint(const AName: String); override;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; override;
{$ENDIF}
    function GetItemCount: Integer; override;
    procedure GetItem(AIndex: Integer; var AName: String; var AValue: Variant;
      var AKind: TADDebugMonitorAdapterItemKind); override;
    procedure InternalTxChanged; override;
    procedure InternalChangePassword(const AUserName, AOldPassword, ANewPassword: String); override;
    function InternalCreateMetadata: TObject; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand):
      TADPhysCommandGenerator; override;
    function GetMessages: EADDBEngineException; override;
    function GetCliObj: TObject; override;
    function GetLastAutoGenValue(const AName: String): Variant; override;
    procedure Execute(const ACmd: String);
    function QueryValue(const ACmd: String; AColIndex: Integer): String;
    procedure DoQuery(const ACmd: String; AInitiator: TObject = nil);
  public
    constructor Create(ADriverObj: TADPhysDriver; const ADriver: IADPhysDriver;
      AConnHost: TADPhysConnectionHost); override;
    destructor Destroy; override;
    class function GetDriverClass: TADPhysDriverClass; override;
  end;

  TADPhysMySQLCommand = class(TADPhysCommand)
  private
    FMetaInfoSQLs: array of String;
    FColIndex: LongWord;
    FCursor: TMySQLResult;
    procedure GenerateMetaInfoSQL;
    function GetExpandedSQL(ATimes, AOffset: Integer): String;
    function DataValue2MySQL(AData: Pointer; ALen: LongWord; AType: TADDataType;
      out ATypeSupported: Boolean): String;
    function MySQL2DataValue(ASrcData: PChar; ASrcLen: LongWord;
      var ADestData: Pointer; var ADestLen: LongWord; AType: TADDataType;
      AAttributes: TADDataAttributes; out ATypeSupported: Boolean): Boolean;
    procedure FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    procedure FetchMetaRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    procedure MySQLType2ADType(const AStr: String; var AType: TADDataType;
      var AAttrs: TADDataAttributes; var ALen: LongWord; var APrec, AScale: Integer);
    function GetResultMode: TADPhysMySQLResultMode;
    function FetchFKRows(ATable: TADDatSTable; AParentRow: TADDatSRow): Integer;
    function GetCrsData(ACrsCol: Integer; var AData: Pointer;
      var ALen: LongWord; AType: TADDataType): Boolean;
    function FetchSPParamRows(ATable: TADDatSTable;
      AParentRow: TADDatSRow): Integer;
    function GenerateSPSQL(const ACatalog, ASchema, APackage,
      ACmd: String): String;
    procedure GetParamValues;
    procedure GetCursor;
    procedure CloseStatement(AForceClose: Boolean);
  protected
    procedure InternalClose; override;
    procedure InternalExecute(ATimes, AOffset: Integer; var ACount: Integer); override;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; override;
    function InternalOpen: Boolean; override;
    function InternalNextRecordSet: Boolean; override;
    procedure InternalPrepare; override;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; override;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; override;
    procedure InternalUnprepare; override;
  end;

const
  S_AD_CharacterSets = 'big5;dec8;cp850;hp8;koi8r;latin1;latin2;swe7;ascii;ujis;' +
    'sjis;cp1251;hebrew;tis620;euckr;koi8u;gb2312;greek;cp1250;gbk;latin5;armscii8;' +
    'utf8;ucs2;cp866;keybcs2;macce;macroman;cp852;latin7;cp1256;cp1257;binary';

  S_AD_StoreResult = 'Store';
  S_AD_UseResult = 'Use';
  S_AD_ChooseResult = 'Choose';

  S_AD_UTF8 = 'utf8';
  S_AD_UCS2 = 'ucs2';

  S_AD_Utf8MapString = 'String';
  S_AD_Utf8MapWideString = 'WideString';

var
  FGLock: TRTLCriticalSection;

{-------------------------------------------------------------------------------}
{ TADPhysMySQLDriver                                                            }
{-------------------------------------------------------------------------------}
constructor TADPhysMySQLDriver.Create(ADrvHost: TADPhysDriverHost);
var
  sHome, sLib: String;
begin
  inherited Create(ADrvHost);
  InitializeCriticalSection(FGLock);
  sHome := '';
  sLib := '';
  ADrvHost.GetVendorParams(sHome, sLib);
  FLib := TMySQLLib.Create(sHome, sLib, ADPhysManagerObj);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysMySQLDriver.Destroy;
begin
  FreeAndNil(FLib);
  DeleteCriticalSection(FGLock);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADPhysMySQLDriver.GetDriverID: String;
begin
  Result := S_AD_MySQLId;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLDriver.GetDescription: String;
begin
  Result := 'MySQL Driver';
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 11;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then
      ALoginIndex := 4;
  end
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_MySQL_Host;
        AType := S_AD_Local;
        ADefVal := S_AD_Local;
        ALoginIndex := 2;
      end;
    1:
      begin
        AName := S_AD_ConnParam_MySQL_Port;
        AType := '@I';
        ADefVal := '3306';
        ALoginIndex := 3;
      end;
    2:
      begin
        AName := S_AD_ConnParam_MySQL_Autocommit;
        AType := '@L';
        ADefVal := S_AD_True;
      end;
    3:
      begin
        AName := S_AD_ConnParam_Common_Transisolation;
        AType := S_AD_DirtyRead + ';' + S_AD_ReadCommitted + ';' +
          S_AD_RepeatRead + ';' + S_AD_Serializible;
        ADefVal := S_AD_ReadCommitted;
      end;
    4:
      begin
        AName := S_AD_ConnParam_MySQL_Compress;
        AType := '@L';
        ADefVal := S_AD_True;
      end;
    5:
      begin
        AName := S_AD_ConnParam_MySQL_UseSSL;
        AType := '@L';
        ADefVal := S_AD_False;
      end;
    6:
      begin
        AName := S_AD_ConnParam_Common_LoginTimeout;
        AType := '@I';
        ADefVal := '';
      end;
    7:
      begin
        AName := S_AD_ConnParam_MySQL_ResultMode;
        AType := S_AD_StoreResult + ';' + S_AD_UseResult + ';' + S_AD_ChooseResult;
        ADefVal := S_AD_StoreResult;
      end;
    8:
      begin
        AName := S_AD_ConnParam_MySQL_CharacterSet;
        AType := S_AD_CharacterSets;
        ADefVal := '';
      end;
    9:
      begin
        AName := S_AD_ConnParam_MySQL_Utf8Mapping;
        AType := S_AD_Utf8MapString + ';' + S_AD_Utf8MapWideString;
        ADefVal := S_AD_Utf8MapWideString;
      end;
    10:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
        ADefVal := '';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMySQLConnection                                                        }
{-------------------------------------------------------------------------------}
constructor TADPhysMySQLConnection.Create(ADriverObj: TADPhysDriver;
  const ADriver: IADPhysDriver; AConnHost: TADPhysConnectionHost);
begin
  InitializeCriticalSection(FLock);
  inherited Create(ADriverObj, ADriver, AConnHost);
{$IFDEF AnyDAC_D7}
  FFormatSettings.DecimalSeparator := '.';
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
destructor TADPhysMySQLConnection.Destroy;
begin
  inherited Destroy;
  DeleteCriticalSection(FLock);
end;

{-------------------------------------------------------------------------------}
class function TADPhysMySQLConnection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysMySQLDriver;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysMySQLCommand.Create;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysMySQLMetadata.Create(
    {$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self, FServerVersion,
    FClientVersion, FNameCaseSensitive);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysMySQLCommandGenerator.Create(ACommand)
  else
    Result := TADPhysMySQLCommandGenerator.Create(Self);
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalTracingChanged;
begin
  if FSession <> nil then
    FSession.Tracing := GetTracing;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalConnect;
var
  sHostName, sDbName, sUserName, sPwd, s: String;
  iPort: Integer;
  uiTimeout, uiClientFlag: LongWord;
begin
  FAllowReconnect := GetConnectionDef.AsBoolean[S_AD_ConnParam_Common_AllowReconnect];
  sHostName := GetConnectionDef.AsString[S_AD_ConnParam_MySQL_Host];
  if CompareText(sHostName, S_AD_Local) = 0 then
    sHostName := '127.0.0.1';
  if GetConnectionDef.HasValue(S_AD_ConnParam_MySQL_Port) then
    iPort := GetConnectionDef.AsInteger[S_AD_ConnParam_MySQL_Port]
  else
    iPort := MYSQL_PORT;
  sDbName := GetConnectionDef.ExpandedDatabase;
  sUserName := GetConnectionDef.UserName;
  sPwd := GetConnectionDef.Password;

  FSession := TMySQLSession.Create(TADPhysMySQLDriver(DriverObj).FLib,
    {$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  try
{$IFDEF AnyDAC_MONITOR}
    FSession.Tracing := GetTracing;
{$ENDIF}
    FClientVersion := ADVerStr2Int(FSession.ClientInfo);
    FSession.Init;

    FResultMode := hrStore;
    if GetConnectionDef.HasValue(S_AD_ConnParam_MySQL_ResultMode) then begin
      s := GetConnectionDef.AsString[S_AD_ConnParam_MySQL_ResultMode];
      if CompareText(s, S_AD_StoreResult) = 0 then
        FResultMode := hrStore
      else if CompareText(s, S_AD_UseResult) = 0 then
        FResultMode := hrUse
      else if CompareText(s, S_AD_ChooseResult) = 0 then
        FResultMode := hrChoose;
    end;

    if GetConnectionDef.AsBoolean[S_AD_ConnParam_MySQL_Compress] then
      FSession.Options[MYSQL_OPT_COMPRESS] := nil;
    if GetConnectionDef.HasValue(S_AD_ConnParam_Common_LoginTimeout) then begin
      uiTimeout := GetConnectionDef.AsInteger[S_AD_ConnParam_Common_LoginTimeout];
      FSession.Options[MYSQL_OPT_CONNECT_TIMEOUT] := @uiTimeout;
    end;

    uiClientFlag := CLIENT_FOUND_ROWS or CLIENT_LONG_FLAG;
    if FADGUIxInteractive then
      uiClientFlag := uiClientFlag or CLIENT_INTERACTIVE;
    if sDbName <> '' then
      uiClientFlag := uiClientFlag or CLIENT_CONNECT_WITH_DB;
    if GetConnectionDef.AsBoolean[S_AD_ConnParam_MySQL_UseSSL] then
      uiClientFlag := uiClientFlag or CLIENT_SSL;
    if FClientVersion >= mvMySQL050000 then
      uiClientFlag := uiClientFlag or AD_50_CLIENT_PROTOCOL_41 or CLIENT_MULTI_QUERIES or
        CLIENT_MULTI_RESULTS
    else if FClientVersion >= mvMySQL040100 then
      uiClientFlag := uiClientFlag or CLIENT_PROTOCOL_41 or CLIENT_MULTI_STATEMENTS;

    EnterCriticalSection(FGLock);
    try
      FSession.Connect(sHostName, sUserName, sPwd, sDbName, iPort, uiClientFlag);
    finally
      LeaveCriticalSection(FGLock);
    end;

    FServerVersion := ADVerStr2Int(FSession.ServerInfo);
    if FServerVersion < mvMySQL032000 then
      ADException(Self, [S_AD_LPhys, S_AD_MySQLId], er_AD_MySQLBadVersion, [FServerVersion]);

    if GetConnectionDef.HasValue(S_AD_ConnParam_MySQL_CharacterSet) then
      FSession.CharacterSetName := GetConnectionDef.AsString[S_AD_ConnParam_MySQL_CharacterSet];
{$IFDEF AnyDAC_D6Base}
    if FSession.CharacterSetName = S_AD_UTF8 then
      if GetConnectionDef.HasValue(S_AD_ConnParam_MySQL_Utf8Mapping) and
         (CompareText(GetConnectionDef.AsString[S_AD_ConnParam_MySQL_Utf8Mapping], S_AD_Utf8MapString) = 0) then
        FCharset := csAnsi
      else
        FCharset := csUtf8
    else
{$ENDIF}
    if FSession.CharacterSetName = S_AD_UCS2 then
      FCharset := csUcs2
    else
      FCharset := csAnsi;
    FNameCaseSensitive :=
      QueryValue('SHOW VARIABLES LIKE ''lower_case_table_names''', 1) = '0';

    if GetConnectionDef.HasValue(S_AD_ConnParam_Common_Transisolation) then
      GetTxOptions.SetIsolationAsStr(GetConnectionDef.AsString[S_AD_ConnParam_Common_Transisolation]);
    if GetConnectionDef.HasValue(S_AD_ConnParam_MySQL_Autocommit) then
      GetTxOptions.AutoCommit := GetConnectionDef.AsBoolean[S_AD_ConnParam_MySQL_Autocommit];
    UpdateTx;
  except
    InternalDisconnect;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalDisconnect;
begin
  if FSession <> nil then begin
    EnterCriticalSection(FGLock);
    try
      FSession.Disconnect;
    finally
      LeaveCriticalSection(FGLock);
    end;
    FreeAndNil(FSession);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.DoQuery(const ACmd: String; AInitiator: TObject = nil);
var
  lExecuted: Boolean;
  iTrials: Integer;
begin
  EnterCriticalSection(FLock);
  try
    lExecuted := False;
    iTrials := 0;
    repeat
      try
        Inc(iTrials);
        FSession.Query(ACmd, AInitiator);
        lExecuted := True;
      except
        on E: EMySQLNativeException do begin
          if AllowReconnect and (E.Kind = ekServerGone) and (iTrials = 1) then begin
            InternalDisconnect;
            InternalConnect;
          end
          else
            raise;
        end;
      end;
    until lExecuted;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.Execute(const ACmd: String);
begin
  DoQuery(ACmd);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.QueryValue(const ACmd: String; AColIndex: Integer): String;
var
  oRes: TMySQLResult;
  pData: Pointer;
  iLen: LongWord;
begin
  DoQuery(ACmd);
  oRes := FSession.StoreResult;
  try
    oRes.Fetch(1);
    pData := nil;
    iLen := 0;
    oRes.GetData(AColIndex, pData, iLen);
    SetString(Result, PChar(pData), iLen);
  finally
    oRes.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalTxBegin(ATxID: LongWord);
begin
  Execute('BEGIN');
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalTxCommit(ATxID: LongWord);
begin
  Execute('COMMIT');
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalTxRollback(ATxID: LongWord);
begin
  Execute('ROLLBACK');
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalTxSetSavepoint(const AName: String);
begin
  if FServerVersion >= mvMySQL040100 then
    Execute('SAVEPOINT '  + AName)
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_MySQLId]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalTxRollbackToSavepoint(const AName: String);
begin
  if FServerVersion >= mvMySQL040100 then
    Execute('ROLLBACK TO SAVEPOINT '  + AName)
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_MySQLId]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalTxChanged;
var
  s: String;
begin
  if xoAutoCommit in GetTxOptions.Changed then
    Execute('SET AUTOCOMMIT = ' + IntToStr(Integer(GetTxOptions.AutoCommit)));
  if xoIsolation in GetTxOptions.Changed then begin
    case GetTxOptions.Isolation of
    xiDirtyRead:      s := 'READ UNCOMMITTED';
    xiReadCommitted:  s := 'READ COMMITTED';
    xiRepeatableRead: s := 'REPEATABLE READ';
    xiSerializible:   s := 'SERIALIZABLE';
    end;
    Execute('SET SESSION TRANSACTION ISOLATION LEVEL ' + s);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalChangePassword(const AUserName, AOldPassword,
  ANewPassword: String);
var
  s: String;
begin
  EnterCriticalSection(FLock);
  try
    s := QueryValue('SELECT CONCAT(SUBSTRING_INDEX(USER(), ''@'', 1), ''@"'', SUBSTRING_INDEX(USER(), ''@'', -1), ''"'')', 0);
    Execute('SET PASSWORD FOR ' + s + ' = PASSWORD("' + ANewPassword + '")');
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.GetLastAutoGenValue(const AName: String): Variant;
begin
{$IFDEF AnyDAC_D6Base}
  Result := FSession.Insert_ID;
{$ELSE}
  Result := Integer(FSession.Insert_ID);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  Inc(Result, 2);
  if FSession <> nil then
    Inc(Result, 5);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.GetItem(AIndex: Integer; var AName: String;
  var AValue: Variant; var AKind: TADDebugMonitorAdapterItemKind);
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'DLL';
        AValue := TADPhysMySQLDriver(DriverObj).FLib.FMySQLDllName;
        AKind := ikClientInfo;
      end;
    1:
      begin
        AName := 'Version';
        AValue := IntToStr(TADPhysMySQLDriver(DriverObj).FLib.FMySQLVersion);
        AKind := ikClientInfo;
      end;
    2:
      begin
        AName := 'ServerInfo';
        AValue := FSession.ServerInfo;
        AKind := ikSessionInfo;
      end;
    3:
      begin
        AName := 'ClientInfo';
        AValue := FSession.ClientInfo;
        AKind := ikSessionInfo;
      end;
    4:
      begin
        AName := 'CharacterSetName';
        AValue := FSession.CharacterSetName;
        AKind := ikSessionInfo;
      end;
    5:
      begin
        AName := 'HostInfo';
        AValue := FSession.HostInfo;
        AKind := ikSessionInfo;
      end;
    6:
      begin
        AName := 'NameCaseSensitive';
        AValue := FNameCaseSensitive;
        AKind := ikSessionInfo;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.GetMessages: EADDBEngineException;
begin
  Result := FSession.Info;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.GetCliObj: TObject;
begin
  Result := FSession;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMySQLCommand                                                           }
{-------------------------------------------------------------------------------}
function TrimQuotes(const AStr: String): String;
var
  i1, i2: Integer;
begin
  Result := Trim(AStr);
  i1 := 1;
  i2 := Length(Result);
  if AStr[1] = '`' then
    Inc(i1);
  if Result[Length(Result)] = '`' then
    Dec(i2);
  Result := Copy(Result, i1, i2 - i1 + 1);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.GenerateSPSQL(const ACatalog, ASchema,
  APackage, ACmd: String): String;
var
  i: Integer;
  oParams: TADParams;
  oParam: TADParam;
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
  sSET, sCALL, sSELECT, sFUNC, sName, sVar, sPar: String;
  lFunction: Boolean;
  oResOpts: TADResourceOptions;
begin
  oParams := GetParams;
  sSET := '';
  sCALL := '';
  sSELECT := '';
  sFUNC := '';
  lFunction := False;
  oResOpts := GetResourceOptions;

  GetConnection.CreateMetadata(oConnMeta);
  rName.FCatalog := ACatalog;
  rName.FSchema := ASchema;
  rName.FBaseObject := APackage;
  rName.FObject := ACmd;
  sName := oConnMeta.EncodeObjName(rName, Self, [eoQuote, eoNormalize]);

  rName.FCatalog := '';
  rName.FSchema := '';
  rName.FBaseObject := '';

  for i := 0 to oParams.Count - 1 do begin
    oParam := oParams[i];
    if oParam.ParamType = ptUnknown then
      oParam.ParamType := oResOpts.DefaultParamType;
    if oParam.Active then begin
      sVar := '@P' + IntToStr(i + 1);
      if oParam.ParamType in [ptInput, ptInputOutput] then begin
        if sSET <> '' then
          sSET := sSET + ', ';
        sSET := sSET + sVar + ' = ?';
      end;
(*
      if sSET <> '' then
        sSET := sSET + ', ';
      if oParam.ParamType in [ptInput, ptInputOutput] then
        sSET := sSET + sVar + ' = ?'
      else begin
        sSET := sSET + sVar + ' = ';
        case oParam.DataType of
        ftString, ftBytes, ftVarBytes, ftBlob, ftMemo, ftFmtMemo,
        ftFixedChar, ftWideString:
          sSET := sSET + '''''';
        ftSmallint, ftInteger, ftWord, ftBoolean, ftAutoInc, ftLargeint:
          sSET := sSET + '0';
        ftFloat, ftCurrency, ftBCD, ftFMTBcd:
          sSET := sSET + '0.0';
        ftDate:
          sSET := sSET + 'DATE(''0000-00-00'')';
        ftTime:
          sSET := sSET + 'TIME(''00:00:00'')';
        ftDateTime, ftTimeStamp:
          sSET := sSET + 'TIMESTAMP(''0000-00-00 00:00:00'')';
        end;
      end;
*)
      if oParam.ParamType in [ptInputOutput, ptOutput] then begin
        if sSELECT <> '' then
          sSELECT := sSELECT + ', ';

        rName.FObject := oParam.Name;
        sPar := oConnMeta.EncodeObjName(rName, Self, [eoQuote, eoNormalize]);
        sSELECT := sSELECT + sVar + ' AS ' + sPar;
        if sFUNC = '' then
          sFUNC := sName + '(' + sVar
        else
          sFUNC := sFUNC + ', ' + sVar;
      end;
      if oParam.ParamType = ptInput then
        if sFUNC = '' then
          sFUNC := sName + '(' + sVar
        else
          sFUNC := sFUNC + ', ' + sVar;
      if oParam.ParamType = ptResult then
        lFunction := True;
    end;
  end;

  if sFUNC = '' then
    sFUNC := sName + '()'
  else
    sFUNC := sFUNC + ')';

  if lFunction then begin
    if sSELECT <> '' then
      sSELECT := sFUNC + ' AS RESULT, ' + sSELECT
    else
      sSELECT := sFUNC + ' AS RESULT';
  end
  else
    sCALL := sFUNC;

  Result := '';
  if sSET <> '' then begin
    if Result <> '' then
      Result := Result + '; ';
    Result := Result + 'SET ' + sSET;
  end;
  if sCALL <> '' then begin
    if Result <> '' then
      Result := Result + '; ';
    Result := Result + 'CALL ' + sCALL;
  end;
  if sSELECT <> '' then begin
    if Result <> '' then
      Result := Result + '; ';
    Result := Result + 'SELECT ' + sSELECT;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.GenerateMetaInfoSQL;
var
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
  sSQL, sWildcard, sName: String;
  lWasWhere: Boolean;

  function NormName(const AName: String): String;
  begin
    FConnection.CreateMetadata(oConnMeta);
    oConnMeta.DecodeObjName(Trim(AName), rName, nil, []);
    if (GetMetaInfoKind in [mkIndexFields, mkPrimaryKeyFields]) and
       (rName.FBaseObject = '') and (rName.FObject <> '') then begin
      rName.FBaseObject := rName.FObject;
      rName.FObject := '';
    end
    else
      CheckMetaInfoParams(rName);
    Result := oConnMeta.EncodeObjName(rName, nil, [eoQuote, eoNormalize]);
  end;

  procedure AddWhere(const ACond: String);
  begin
    if lWasWhere then
      sSQL := sSQL + ' AND ' + ACond
    else begin
      sSQL := sSQL + ' WHERE ' + ACond;
      lWasWhere := True;
    end;
  end;

begin
  sWildcard := GetWildcard;
  lWasWhere := False;
  sSQL := '';
  if GetMetaInfoKind = mkProcArgs then
    SetLength(FMetaInfoSQLs, 2)
  else
    SetLength(FMetaInfoSQLs, 1);
  case GetMetaInfoKind of
  mkTables:
    begin
      sSQL := 'SHOW TABLES';
      if sWildcard <> '' then
        sSQL := sSQL + ' LIKE ''' + sWildcard + '''';
    end;
  mkTableFields:
    begin
      sSQL := 'SHOW COLUMNS';
      if sWildcard <> '' then
        sSQL := sSQL + ' LIKE ''' + sWildcard + '''';
      sSQL := sSQL + ' FROM ' + NormName(GetCommandText);
    end;
  mkIndexes,
  mkIndexFields,
  mkPrimaryKey,
  mkPrimaryKeyFields:
    begin
      sSQL := 'SHOW INDEX';
      if sWildcard <> '' then
        sSQL := sSQL + ' LIKE ''' + sWildcard + '''';
      sSQL := sSQL + ' FROM ';
      if GetMetaInfoKind in [mkIndexFields, mkPrimaryKeyFields] then
        sSQL := sSQL + NormName(GetBaseObjectName)
      else
        sSQL := sSQL + NormName(GetCommandText);
    end;
  mkForeignKeys,
  mkForeignKeyFields:
    if TADPhysMySQLConnection(FConnectionObj).FServerVersion < mvMySQL032300 then
      sSQL := ''
    else begin
      if rName.FCatalog = '' then
        rName.FCatalog := TADPhysMySQLConnection(FConnectionObj).FSession.DB;
      sSQL := 'SHOW TABLE STATUS FROM ' + rName.FCatalog + ' LIKE ''';
      if GetMetaInfoKind = mkForeignKeyFields then
        sSQL := sSQL + TrimQuotes(GetBaseObjectName)
      else
        sSQL := sSQL + TrimQuotes(GetCommandText);
      sSQL := sSQL + '''';
    end;
  mkProcs:
    if TADPhysMySQLConnection(FConnectionObj).FServerVersion < mvMySQL050000 then
      sSQL := ''
    else begin
      sSQL := 'SELECT CAST(NULL AS UNSIGNED) AS RECNO, ROUTINE_SCHEMA AS CATALOG_NAME, ' +
        'CAST(NULL AS CHAR) AS SCHEMA_NAME, CAST(NULL AS CHAR) AS PACK_NAME, ROUTINE_NAME AS PROC_NAME, ' +
        'CAST(NULL AS UNSIGNED) AS OVERLOAD, CASE ROUTINE_TYPE ' +
          'WHEN ''FUNCTION'' THEN ' + IntToStr(Integer(pkFunction)) + ' WHEN ' +
          '''PROCEDURE'' THEN ' + IntToStr(Integer(pkProcedure)) + ' END AS PROC_TYPE, ' +
        IntToStr(Integer(osMy)) + ' AS PROC_SCOPE, CAST(NULL AS UNSIGNED) AS IN_PARAMS, ' +
        'CAST(NULL AS UNSIGNED) AS OUT_PARAMS ' +
        'FROM INFORMATION_SCHEMA.ROUTINES';
      if GetCatalogName <> '' then
        AddWhere('UPPER(ROUTINE_SCHEMA) = UPPER(''' + GetCatalogName + ''')');
      if sWildcard <> '' then
        AddWhere('ROUTINE_NAME LIKE ''' + sWildcard + '''');
      sSQL := sSQL + ' ORDER BY 3, 5';
    end;
  mkProcArgs:
    begin
      sName := NormName(GetCommandText);
      SetLength(FMetaInfoSQLs, 2);
      sSQL := 'SHOW CREATE PROCEDURE ' + sName;
      FMetaInfoSQLs[1] := 'SHOW CREATE FUNCTION ' + sName;
    end;
  else
    ASSERT(False);
  end;
  FMetaInfoSQLs[0] := sSQL;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.InternalPrepare;
var
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
begin
  if GetMetaInfoKind = mkNone then begin
    if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
      GetConnection.CreateMetadata(oConnMeta);
      oConnMeta.DecodeObjName(Trim(GetCommandText()), rName, Self, [doNormalize, doUnquote]);
      with rName do begin
        if fiMeta in GetFetchOptions.Items then
          FillStoredProcParams(FCatalog, FSchema, FBaseObject, FObject);
        FDbCommandText := GenerateSPSQL(FCatalog, FSchema, FBaseObject, FObject);
      end;
    end
    else
      SetLength(FMetaInfoSQLs, 0);
  end
  else
    GenerateMetaInfoSQL;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.InternalUnprepare;
begin
  CloseStatement(True);
  SetLength(FMetaInfoSQLs, 0);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean;
begin
  ASSERT(ATabInfo.FSourceID = -1);
  Result := OpenBlocked;
  if Result then
    if ATabInfo.FSourceID = -1 then begin
      ATabInfo.FSourceName := GetCommandText;
      ATabInfo.FSourceID := 1;
      ATabInfo.FOriginName := '';
      FColIndex := 0;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  oFld:       TMySQLField;
  name:       PChar;
  srcname:    PChar;
  table:      PChar;
  type_:      Byte;
  length:     LongWord;
  flags:      LongWord;
  decimals:   LongWord;
  oConnMeta:  IADPhysConnectionMetadata;
  oFmtOpts:   TADFormatOptions;
begin
  if FColIndex >= FCursor.FieldCount then begin
    Result := False;
    Exit;
  end;
  oFmtOpts := GetFormatOptions;
  oFld := FCursor.Fields[FColIndex];
  with AColInfo do begin
    name := nil;
    srcname := nil;
    table := nil;
    type_ := 0;
    length := 0;
    flags := 0;
    decimals := 0;
    oFld.GetInfo(name, srcname, table, type_, length, flags, decimals);

    FSourceID := FColIndex + 1;
    FSourceName := String(name);

    FConnection.CreateMetadata(oConnMeta);
    // we dont need following INSERT:
    // insert into `aaa` (`aaa`.`f1`, `aaa`.`f2`) values (...)
//    if (table <> nil) and (table^ <> #0) then
//      FSourceName := oConnMeta.NameQuotaChar1 + String(table) + oConnMeta.NameQuotaChar2 +
//        '.' + oConnMeta.NameQuotaChar1 + String(srcname) + oConnMeta.NameQuotaChar2
//    else
    FOriginName := oConnMeta.NameQuotaChar1 + String(srcname) + oConnMeta.NameQuotaChar2;
    FTypeName := '';
    FAttrs := [];
    FForceRemOpts := [];
    FForceAddOpts := [];
    if (flags and NOT_NULL_FLAG) = 0 then
      Include(FAttrs, caAllowNull);
    if not (type_ in [FIELD_TYPE_TINY_BLOB, FIELD_TYPE_MEDIUM_BLOB,
                      FIELD_TYPE_LONG_BLOB, FIELD_TYPE_BLOB]) then
      Include(FAttrs, caSearchable);
    if (flags and AUTO_INCREMENT_FLAG) <> 0 then begin
      Include(FAttrs, caAutoInc);
      Include(FAttrs, caAllowNull);
      Include(FForceAddOpts, coAfterInsChanged);
    end;

    FType := dtUnknown;
    FLen := 0;
    FPrec := 0;
    FScale := 0;

    case type_ of
    FIELD_TYPE_TINY:
      if (flags and UNSIGNED_FLAG) <> 0 then
        FType := dtByte
      else
        FType := dtSByte;
    FIELD_TYPE_SHORT:
      if (flags and UNSIGNED_FLAG) <> 0 then
        FType := dtUInt16
      else
        FType := dtInt16;
    FIELD_TYPE_LONG,
    FIELD_TYPE_INT24:
      if (flags and UNSIGNED_FLAG) <> 0 then
        FType := dtUInt32
      else
        FType := dtInt32;
    FIELD_TYPE_LONGLONG:
      if (flags and UNSIGNED_FLAG) <> 0 then
        FType := dtUInt64
      else
        FType := dtInt64;
    FIELD_TYPE_FLOAT,
    FIELD_TYPE_DOUBLE:
      begin
        FType := dtDouble;
        FScale := decimals;
      end;
    FIELD_TYPE_DECIMAL,
    FIELD_TYPE_NEWDECIMAL:
      begin
        if decimals = 0 then
          if (flags and UNSIGNED_FLAG) <> 0 then begin
            if length <= 3 then
              FType := dtByte
            else if length <= 5 then
              FType := dtUInt16
            else if length <= 10 then
              FType := dtUInt32
            else if length <= 21 then
              FType := dtUInt64;
          end
          else begin
            if length <= 2 then
              FType := dtSByte
            else if length <= 4 then
              FType := dtInt16
            else if length <= 9 then
              FType := dtInt32
            else if length <= 20 then
              FType := dtInt64;
          end;
        if FType = dtUnknown then begin
          FPrec := length;
          if decimals > 0 then
            Dec(FPrec);
          if (flags and UNSIGNED_FLAG) = 0 then
            Dec(FPrec);
          FScale := decimals;
          if (FScale <= oFmtOpts.MaxBcdScale) and
             (FPrec <= oFmtOpts.MaxBcdPrecision) then
            FType := dtBCD
          else
            FType := dtFmtBCD;
        end;
      end;
    FIELD_TYPE_DATE,
    FIELD_TYPE_NEWDATE:
      FType := dtDate;
    FIELD_TYPE_TIME:
      FType := dtTime;
    FIELD_TYPE_DATETIME:
      FType := dtDateTime;
    FIELD_TYPE_YEAR:
      FType := dtUInt16;
    FIELD_TYPE_TIMESTAMP:
      begin
        FType := dtDateTimeStamp;
        Include(FAttrs, caRowVersion);
        Include(FAttrs, caAllowNull);
      end;
    FIELD_TYPE_ENUM,
    FIELD_TYPE_SET,
    FIELD_TYPE_VAR_STRING,
    FIELD_TYPE_STRING,
    FIELD_TYPE_VARCHAR,
    FIELD_TYPE_BIT:
      if length <= oFmtOpts.MaxStringSize then begin
        if TADPhysMySQLConnection(FConnectionObj).FCharset in [csUtf8, csUcs2] then
          FType := dtWideString
        else
          FType := dtAnsiString;
        FLen := length;
        if type_ = FIELD_TYPE_STRING then
          Include(FAttrs, caFixedLen);
      end
      else begin
        if (flags and BINARY_FLAG) <> 0 then
          FType := dtBlob
        else if TADPhysMySQLConnection(FConnectionObj).FCharset in [csUtf8, csUcs2] then
          FType := dtWideMemo
        else
          FType := dtMemo;
        Include(FAttrs, caBlobData);
      end;
    FIELD_TYPE_TINY_BLOB,
    FIELD_TYPE_MEDIUM_BLOB,
    FIELD_TYPE_LONG_BLOB,
    FIELD_TYPE_BLOB:
      if length <= oFmtOpts.MaxStringSize then begin
        if (flags and BINARY_FLAG) <> 0 then
          FType := dtByteString
        else if TADPhysMySQLConnection(FConnectionObj).FCharset in [csUtf8, csUcs2] then
          FType := dtWideString
        else
          FType := dtAnsiString;
        FLen := length;
      end
      else begin
        if (flags and BINARY_FLAG) <> 0 then
          FType := dtBlob
        else if TADPhysMySQLConnection(FConnectionObj).FCharset in [csUtf8, csUcs2] then
          FType := dtWideMemo
        else
          FType := dtMemo;
        Include(FAttrs, caBlobData);
      end;
    FIELD_TYPE_NULL:
      if (flags and NUM_FLAG) <> 0 then
        FType := dtInt32
      else if TADPhysMySQLConnection(FConnectionObj).FCharset in [csUtf8, csUcs2] then
        FType := dtWideString
      else
        FType := dtAnsiString;
    end;
  end;
  Inc(FColIndex);
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.DataValue2MySQL(AData: Pointer; ALen: LongWord;
  AType: TADDataType; out ATypeSupported: Boolean): String;
var
  iSz: Integer;
  aBuff: array [0..65] of AnsiChar;
{$IFDEF AnyDAC_D6Base}
  pUtf8: Pointer;
{$ENDIF}
  sFmt: String;
{$IFNDEF AnyDAC_D7}
  cPrevDecSep: Char;
{$ENDIF}
begin
  ATypeSupported := True;
  case AType of
  dtBoolean:
    if PWordBool(AData)^ then
      Result := '''Y'''
    else
      Result := '''N''';
  dtSByte:
    Result := IntToStr(PShortInt(AData)^);
  dtInt16:
    Result := IntToStr(PSmallInt(AData)^);
  dtInt32:
    Result := IntToStr(PInteger(AData)^);
  dtInt64:
    Result := IntToStr(PInt64(AData)^);
  dtByte:
    Result := Format('%u', [LongWord(PByte(AData)^)]);
  dtUInt16:
    Result := Format('%u', [LongWord(PWord(AData)^)]);
  dtUInt32:
    Result := Format('%u', [PLongWord(AData)^]);
  dtUInt64:
    Result := IntToStr(PInt64(AData)^);
  dtCurrency:
{$IFDEF AnyDAC_D7}
    Result := CurrToStr(PCurrency(AData)^, TADPhysMySQLConnection(FConnectionObj).FFormatSettings);
{$ELSE}
    begin
      cPrevDecSep := DecimalSeparator;
      DecimalSeparator := '.';
      try
        Result := CurrToStr(PCurrency(AData)^);
      finally
        DecimalSeparator := cPrevDecSep;
      end;
    end;
{$ENDIF}
  dtDouble:
{$IFDEF AnyDAC_D7}
    Result := FloatToStr(PDouble(AData)^, TADPhysMySQLConnection(FConnectionObj).FFormatSettings);
{$ELSE}
    begin
      cPrevDecSep := DecimalSeparator;
      DecimalSeparator := '.';
      try
        Result := FloatToStr(PDouble(AData)^);
      finally
        DecimalSeparator := cPrevDecSep;
      end;
    end;
{$ENDIF}
  dtBCD,
  dtFmtBCD:
    begin
      iSz := 0;
      ADBCD2Str(aBuff, iSz, PADBcd(AData)^, '.');
      SetString(Result, aBuff, iSz);
    end;
  dtDate:
    Result := '''' + FormatDateTime('yyyy-mm-dd', ADDate2DateTime(PLongint(AData)^)) + '''';
  dtTime:
    Result := '''' + FormatDateTime('hh:nn:ss', ADTime2DateTime(PLongint(AData)^)) + '''';
  dtDateTime:
    Result := '''' + FormatDateTime('yyyy-mm-dd hh:nn:ss',
      TimeStampToDateTime(MSecsToTimeStamp(PADDateTimeData(AData)^.DateTime))) + '''';
  dtDateTimeStamp:
    begin
      if TADPhysMySQLConnection(FConnectionObj).FServerVersion >= mvMySQL040100 then
        sFmt := 'yyyy-mm-dd hh:nn:ss'
      else
        sFmt := 'yyyymmddhhnnss';
{$IFDEF AnyDAC_D6}
      Result := '''' + SQLTimeStampToStr(sFmt, PADSQLTimeStamp(AData)^) + '''';
{$ELSE}
      DateTimeToString(Result, sFmt, ADSQLTimeStampToDateTime(PADSQLTimeStamp(AData)^));
      Result := '''' + Result + '''';
{$ENDIF}
    end;
  dtByteString,
  dtAnsiString,
  dtBlob,
  dtMemo:
    begin
      if (ALen = 0) and GetFormatOptions.StrsEmpty2Null then
        Result := 'NULL'
      else begin
        SetLength(Result, ALen * 2 + 3);
        iSz := TADPhysMySQLConnection(FConnectionObj).FSession.
          EscapeString(PChar(Result) + 1, PChar(AData), ALen);
        PChar(Result)^ := '''';
        (PChar(Result) + iSz + 1)^ := '''';
        SetLength(Result, iSz + 2);
      end;
    end;
  dtWideString,
  dtWideMemo:
    begin
      if (ALen = 0) and GetFormatOptions.StrsEmpty2Null then                 
        Result := 'NULL'
      else if (TADPhysMySQLConnection(FConnectionObj).FCharset = csUcs2) then begin
        SetLength(Result, ALen * 4 + 8);
        iSz := TADPhysMySQLConnection(FConnectionObj).FSession.
          EscapeString(PChar(Result) + 6, PChar(AData), ALen * 2);
        ADMove(PChar('_usc2''')^, Result[1], 6);
        (PChar(Result) + iSz + 6)^ := '''';
        SetLength(Result, iSz + 7);
      end
{$IFDEF AnyDAC_D6Base}
      else if (TADPhysMySQLConnection(FConnectionObj).FCharset = csUtf8) then begin
        if AData = FBuffer.Ptr then begin
          // If FBuffer already contains Unicode value of length (ALen + 1) * 2
          // bytes, then extend it and append utf8 value right after unicode.
          FBuffer.Check((ALen + 1) * SizeOf(WideChar) + ALen * 4 + 1);
          AData := FBuffer.Ptr;
          pUtf8 := Pointer(LongWord(FBuffer.Ptr) + (ALen + 1) * SizeOf(WideChar));
        end
        else begin
          FBuffer.Check(ALen * 4 + 1);
          pUtf8 := FBuffer.Ptr;
        end;
        iSz := UnicodeToUtf8(pUtf8, ALen * 4 + 1, PWideChar(AData), ALen) - 1;
        SetLength(Result, iSz * 2 + 8);
        iSz := TADPhysMySQLConnection(FConnectionObj).FSession.
          EscapeString(PChar(Result) + 6, pUtf8, iSz);
        ADMove(PChar('_utf8''')^, Result[1], 6);
        (PChar(Result) + iSz + 6)^ := '''';
        SetLength(Result, iSz + 7);
      end
{$ENDIF}      
      else begin
        if AType = dtWideString then
          AType := dtAnsiString
        else
          AType := dtMemo;
        Result := DataValue2MySQL(PChar(WideCharToString(PWideChar(AData))), ALen,
          AType, ATypeSupported);
      end;
    end;
  else
    ATypeSupported := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.MySQL2DataValue(ASrcData: PChar; ASrcLen: LongWord;
  var ADestData: Pointer; var ADestLen: LongWord; AType: TADDataType;
  AAttributes: TADDataAttributes; out ATypeSupported: Boolean): Boolean;
var
  E: Extended;
  wYear, wMonth, wDay, wHour, wMin, wSec: Word;
  iBase: Integer;
{$IFNDEF AnyDAC_D7}
  cPrevDecSep: Char;
{$ENDIF}
begin
  Result := True;
  ADestLen := 0;
  ATypeSupported := True;
  case AType of
  dtBoolean:
    PWordBool(ADestData)^ := PChar(ASrcData)^ in ['1', 'Y', 'y', 'T', 't'];
  dtSByte:
    ADStr2Int(ASrcData, ASrcLen, ADestData, SizeOf(ShortInt), False);
  dtInt16:
    ADStr2Int(ASrcData, ASrcLen, ADestData, SizeOf(SmallInt), False);
  dtInt32:
    ADStr2Int(ASrcData, ASrcLen, ADestData, SizeOf(Integer), False);
  dtInt64:
    ADStr2Int(ASrcData, ASrcLen, ADestData, SizeOf(Int64), False);
  dtByte:
    ADStr2Int(ASrcData, ASrcLen, ADestData, SizeOf(Byte), True);
  dtUInt16:
    ADStr2Int(ASrcData, ASrcLen, ADestData, SizeOf(Word), True);
  dtUInt32:
    ADStr2Int(ASrcData, ASrcLen, ADestData, SizeOf(LongWord), True);
  dtUInt64:
    ADStr2Int(ASrcData, ASrcLen, ADestData, SizeOf(UInt64), True);
  dtDouble:
    begin
{$IFDEF AnyDAC_D7}
      TextToFloat(ASrcData, E, fvExtended,
        TADPhysMySQLConnection(FConnectionObj).FFormatSettings);
{$ELSE}
      cPrevDecSep := DecimalSeparator;
      DecimalSeparator := '.';
      try
        E := 0.0;
        TextToFloat(ASrcData, E, fvExtended);
      finally
        DecimalSeparator := cPrevDecSep;
      end;
{$ENDIF}
      PDouble(ADestData)^ := E;
    end;
  dtCurrency:
{$IFDEF AnyDAC_D7}
    TextToFloat(ASrcData, ADestData^, fvCurrency,
      TADPhysMySQLConnection(FConnectionObj).FFormatSettings);
{$ELSE}
    begin
      cPrevDecSep := DecimalSeparator;
      DecimalSeparator := '.';
      try
        TextToFloat(ASrcData, ADestData^, fvCurrency);
      finally
        DecimalSeparator := cPrevDecSep;
      end;
    end;
{$ENDIF}
  dtBCD,
  dtFmtBCD:
    ADStr2BCD(ASrcData, ASrcLen, PADBcd(ADestData)^, '.');
  dtDate:
    begin
      ADStr2Int(ASrcData,     4, @wYear, SizeOf(Word), True);
      ADStr2Int(ASrcData + 5, 2, @wMonth, SizeOf(Word), True);
      ADStr2Int(ASrcData + 8, 2, @wDay, SizeOf(Word), True);
      if (wYear = 0) and (wMonth = 0) and (wDay = 0) then begin
        PLongint(ADestData)^ := 0;
        Result := False;
      end
      else
        PLongint(ADestData)^ := ADDateTime2Date(EncodeDate(wYear, wMonth, wDay));
    end;
  dtTime:
    begin
      ADStr2Int(ASrcData,     2, @wHour, SizeOf(Word), True);
      ADStr2Int(ASrcData + 3, 2, @wMin, SizeOf(Word), True);
      ADStr2Int(ASrcData + 6, 2, @wSec, SizeOf(Word), True);
      PLongint(ADestData)^ := ADDateTime2Time(EncodeTime(wHour, wMin, wSec, 0));
    end;
  dtDateTime:
    begin
      ADStr2Int(ASrcData,     4, @wYear, SizeOf(Word), True);
      ADStr2Int(ASrcData + 5, 2, @wMonth, SizeOf(Word), True);
      ADStr2Int(ASrcData + 8, 2, @wDay, SizeOf(Word), True);
      if ASrcData[10] = #0 then begin
        wHour := 0;
        wMin := 0;
        wSec := 0;
      end
      else begin
        ADStr2Int(ASrcData + 11,2, @wHour, SizeOf(Word), True);
        ADStr2Int(ASrcData + 14,2, @wMin, SizeOf(Word), True);
        ADStr2Int(ASrcData + 17,2, @wSec, SizeOf(Word), True);
      end;
      if (wYear = 0) and (wMonth = 0) and (wDay = 0) and
         (wHour = 0) and (wMin = 0) and (wSec = 0) then begin
        PADDateTimeData(ADestData)^.DateTime := 0;
        Result := False;
      end
      else
        PADDateTimeData(ADestData)^.DateTime := TimeStampToMSecs(DateTimeToTimeStamp(
          EncodeDate(wYear, wMonth, wDay) + EncodeTime(wHour, wMin, wSec, 0)));
    end;
  dtDateTimeStamp:
    begin
      if ASrcLen = 19 then begin
        ADStr2Int(ASrcData,     4, @wYear, SizeOf(Word), True);
        ADStr2Int(ASrcData + 5, 2, @wMonth, SizeOf(Word), True);
        ADStr2Int(ASrcData + 8, 2, @wDay, SizeOf(Word), True);
        ADStr2Int(ASrcData + 11,2, @wHour, SizeOf(Word), True);
        ADStr2Int(ASrcData + 14,2, @wMin, SizeOf(Word), True);
        ADStr2Int(ASrcData + 17,2, @wSec, SizeOf(Word), True);
      end
      else begin
        wYear := 0;
        wMonth := 0;
        wDay := 0;
        wHour := 0;
        wMin := 0;
        wSec := 0;
        if (ASrcLen = 14) or (ASrcLen = 8) then begin
          ADStr2Int(ASrcData, 4, @wYear, SizeOf(Word), True);
          iBase := 4;
        end
        else begin
          ADStr2Int(ASrcData, 2, @wYear, SizeOf(Word), True);
          iBase := 2;
        end;
        if ASrcLen > 2 then begin
          ADStr2Int(ASrcData + iBase, 2, @wMonth, SizeOf(Word), True);
          if ASrcLen > 4 then begin
            ADStr2Int(ASrcData + iBase + 2, 2, @wDay, SizeOf(Word), True);
            if ASrcLen >= 10 then begin
              ADStr2Int(ASrcData + iBase + 4, 2, @wHour, SizeOf(Word), True);
              ADStr2Int(ASrcData + iBase + 6, 2, @wMin, SizeOf(Word), True);
              if ASrcLen > 10 then
                ADStr2Int(ASrcData + iBase + 8, 2, @wSec, SizeOf(Word), True);
            end;
          end;
        end;
      end;
      if (wYear = 0) and (wMonth = 0) and (wDay = 0) and
         (wHour = 0) and (wMin = 0) and (wSec = 0) then begin
        ADFillChar(PADSQLTimeStamp(ADestData)^, SizeOf(TADSQLTimeStamp), #0);
        Result := False;
      end
      else
        PADSQLTimeStamp(ADestData)^ := ADDateTimeToSQLTimeStamp(EncodeDate(
          wYear, wMonth, wDay) + EncodeTime(wHour, wMin, wSec, 0));
    end;
  dtAnsiString,
  dtMemo:
    begin
      ADestData := ASrcData;
      ADestLen := ASrcLen;
      if (caFixedLen in AAttributes) and GetOptions.FormatOptions.StrsTrim then
        while (ADestLen > 0) and (PChar(ADestData)[ADestLen - 1] = ' ') do
          Dec(ADestLen);
      if (ADestLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
        Result := False;
    end;
  dtWideString,
  dtWideMemo:
    begin
      case TADPhysMySQLConnection(FConnectionObj).FCharset of
      csUcs2:
        begin
          ADestData := ASrcData;
          ADestLen := ASrcLen;
        end;
{$IFDEF AnyDAC_D6Base}
      csUtf8:
        ADestLen := Utf8ToUnicode(ADestData, ASrcLen + 1, ASrcData, ASrcLen);
{$ENDIF}        
      else
        ASSERT(False);
      end;
      if (caFixedLen in AAttributes) and GetOptions.FormatOptions.StrsTrim then
        while (ADestLen > 0) and (PWideChar(ADestData)[ADestLen - 1] = ' ') do
          Dec(ADestLen);
      if (ADestLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
        Result := False;
    end;
  dtByteString,
  dtBlob:
    begin
      ADestData := ASrcData;
      ADestLen := ASrcLen;
      if (ADestLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
        Result := False;
    end;
  else
    Result := False;
    ATypeSupported := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.GetExpandedSQL(ATimes, AOffset: Integer): String;
var
  pSrcCh, pDestCh, pDestEnd: PChar;
  i, iSQLLen, iPar, iRow: Integer;
  sSQL, sSubst, sValues: String;
  oParam: TADParam;
  iSize, iSrcDataLen, iDestDataLen: LongWord;
  iPrec: Integer;
  iFieldType: TFieldType;
  iSrcDataType, iDestDataType: TADDataType;
  oFmtOpts: TADFormatOptions;
  oResOpts: TADResourceOptions;
  lTypeSupported: Boolean;

  procedure ErrorParamType(const AReason: String);
  begin
    ADException(Self, [S_AD_LPhys, S_AD_MySQLId], er_AD_MySQLBadParams,
      [oParam.Name, AReason]);
  end;

  procedure ExtendDest(AMinLen: Integer);
  var
    iPos: Integer;
  begin
    if AMinLen < 1024 then
      AMinLen := 1024;
    if pDestCh = nil then
      iPos := 0
    else
      iPos := pDestCh - PChar(Result);
    SetLength(Result, Length(Result) + AMinLen);
    pDestCh := PChar(Result) + iPos;
    pDestEnd := PChar(Result) + Length(Result);
  end;

begin
  sSQL := FDbCommandText;
  if (GetCommandKind = skInsert) and (FSQLValuesPos > 0) and (ATimes - AOffset > 1) then begin
    sValues := ',' + Copy(sSQL, FSQLValuesPos + 6, Length(sSQL));
    iSQLLen := Length(sSQL);
    SetLength(sSQL, iSQLLen + (ATimes - 2 - AOffset + 1) * Length(sValues));
    for i := AOffset to ATimes - 2 do
      ADMove(sValues[1], sSQL[iSQLLen + 1 + (i - AOffset) * Length(sValues)], Length(sValues));
  end;
  if GetParams().Count = 0 then
    Result := sSQL
  else begin
    oFmtOpts := GetOptions.FormatOptions;
    oResOpts := GetOptions.ResourceOptions;
    pSrcCh := PChar(sSQL);
    pDestCh := nil;
    ExtendDest(0);
    iPar := 0;
    iRow := AOffset;
    while True do begin
      { TODO : If command text will contain char constant with '?' in it, then that will fail }
      while (pSrcCh^ <> #0) and (pSrcCh^ <> '?') do begin
        if pDestCh = pDestEnd then
          ExtendDest(0);
        pDestCh^ := pSrcCh^;
        Inc(pDestCh);
        Inc(pSrcCh);
      end;
      if pSrcCh^ = #0 then
        Break
      else if pSrcCh^ = '?' then begin
        // find next active parameter
        oParam := GetParams().Items[iPar];
        if oParam.ParamType = ptUnknown then
          oParam.ParamType := oResOpts.DefaultParamType;
        while (not oParam.Active or not (oParam.ParamType in [ptInput, ptInputOutput])) and
              (iPar < GetParams().Count - 1) do begin
          Inc(iPar);
          oParam := GetParams().Items[iPar];
          if oParam.ParamType = ptUnknown then
            oParam.ParamType := oResOpts.DefaultParamType;
        end;
        // check parameter definition
        if not oParam.Active then
          ErrorParamType('Parameter is not active');
        if oParam.ParamType in [ptOutput, ptResult] then
          ErrorParamType('Output parameters are not supported');
        if oParam.DataType = ftUnknown then
          ParTypeUnknownError(oParam);
        iFieldType := ftUnknown;
        iSize := 0;
        iPrec := 0;
        iSrcDataType := dtUnknown;
        iDestDataType := dtUnknown;
        iDestDataLen := 0;
        oFmtOpts.ResolveFieldType(oParam.DataType, oParam.ADDataType, oParam.Size,
          oParam.Precision, iFieldType, iSize, iPrec, iSrcDataType, iDestDataType, False);
        iSrcDataLen := oParam.GetDataSize(iRow);
        if oParam.IsNulls[iRow] then
          sSubst := 'NULL'
        else begin
          // approximating destination data size and allocate buffer
          FBuffer.Extend(iSrcDataLen, iDestDataLen, iSrcDataType, iDestDataType);
          // fill buffer with value, converting it, if required
          oParam.GetData(FBuffer.Ptr, iRow);
          oFmtOpts.ConvertRawData(iSrcDataType, iDestDataType, FBuffer.Ptr,
            iSrcDataLen, FBuffer.FBuffer, FBuffer.Size, iDestDataLen);
          if iDestDataType in [dtAnsiString, dtWideString] then
            Dec(iDestDataLen);
          sSubst := DataValue2MySQL(FBuffer.Ptr, iDestDataLen, iDestDataType,
            lTypeSupported);
          if not lTypeSupported then
            ParTypeMapError(oParam);
        end;
        if pDestCh + Length(sSubst) >= pDestEnd then
          ExtendDest(Length(sSubst));
        ADMove(PChar(sSubst)^, pDestCh^, Length(sSubst));
        Inc(pDestCh, Length(sSubst));
        Inc(iPar);
        if iPar >= GetParams().Count then begin
          iPar := 0;
          Inc(iRow);
        end;
      end;
      Inc(pSrcCh);
    end;
    SetLength(Result, pDestCh - PChar(Result));
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.GetResultMode: TADPhysMySQLResultMode;
var
  oCon: TADPhysMySQLConnection;
begin
  oCon := TADPhysMySQLConnection(FConnectionObj);
  case oCon.FResultMode of
  hrStore:
    Result := hrStore;
  hrUse:
    Result := hrUse;
  hrChoose:
    if GetFetchOptions.Mode in [fmAll, fmExactRecsMax] then
      Result := hrStore
    else
      Result := hrUse;
  else
    Result := hrStore;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.GetCursor;
var
  oCon: TADPhysMySQLConnection;
begin
  oCon := TADPhysMySQLConnection(FConnectionObj);
  repeat
    FreeAndNil(FCursor);
    if GetResultMode = hrStore then
      FCursor := oCon.FSession.StoreResult
    else
      FCursor := oCon.FSession.UseResult;
  until (FCursor <> nil) or
        not oCon.FSession.MoreResults or
        not oCon.FSession.NextResult;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.InternalExecute(ATimes, AOffset: Integer;
  var ACount: Integer);
var
  sSQL: String;
  oCon: TADPhysMySQLConnection;
  i, iCount: Integer;
  iRows: Int64;
begin
  ACount := 0;
  if (GetCommandKind = skInsert) and (FSQLValuesPos > 0) and (ATimes - AOffset > 1) then
    sSQL := GetExpandedSQL(ATimes, AOffset)
  else if ATimes - AOffset > 1 then begin
    for i := AOffset to ATimes - 1 do begin
      try
        iCount := 0;
        InternalExecute(i + 1, i, iCount);
      except
        on E: EMySQLNativeException do begin
          E.Errors[0].RowIndex := i;
          raise;
        end;
      end;
      Inc(ACount, iCount);
    end;
    Exit;
  end
  else
    sSQL := GetExpandedSQL(ATimes, AOffset);
  oCon := TADPhysMySQLConnection(FConnectionObj);
  EnterCriticalSection(oCon.FLock);
  try
    try
      oCon.DoQuery(sSQL, Self);
      CloseStatement(True);
    finally
      if FCursor = nil then begin
        iRows := oCon.FSession.AffectedRows;
        if iRows > 0 then
          Inc(ACount, iRows);
      end;
    end;
  finally
    LeaveCriticalSection(oCon.FLock);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalOpen: Boolean;
var
  sSQL: String;
  iSQL: Integer;
  oCon: TADPhysMySQLConnection;
begin
  if FCursor = nil then begin
    oCon := TADPhysMySQLConnection(FConnectionObj);
    iSQL := 0;
    if GetMetaInfoKind <> mkNone then
      sSQL := FMetaInfoSQLs[0]
    else
      sSQL := GetExpandedSQL(1, 0);
    while sSQL <> '' do begin
      EnterCriticalSection(oCon.FLock);
      try
        try
          oCon.DoQuery(sSQL, Self);
          sSQL := '';
          GetCursor;
          if GetMetaInfoKind = mkNone then
            GetParamValues;
        except
          on E: EMySQLNativeException do
            if GetMetaInfoKind <> mkNone then begin
              Inc(iSQL);
              if iSQL = Length(FMetaInfoSQLs) then
                if E.Kind = ekObjNotExists then
                  sSQL := ''
                else
                  raise
              else
                sSQL := FMetaInfoSQLs[iSQL];
            end
            else
              raise;
        end;
      finally
        LeaveCriticalSection(oCon.FLock);
      end;
    end;
  end;
  Result := (FCursor <> nil);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalNextRecordSet: Boolean;
var
  oCon: TADPhysMySQLConnection;
begin
  oCon := TADPhysMySQLConnection(FConnectionObj);
  EnterCriticalSection(oCon.FLock);
  try
    InternalClose;
    Result := oCon.FSession.MoreResults;
    if Result then begin
      Result := oCon.FSession.NextResult;
      if Result then begin
        GetCursor;
        if GetMetaInfoKind = mkNone then
          GetParamValues;
      end;
    end;
  finally
    LeaveCriticalSection(oCon.FLock);
  end;
  Result := (FCursor <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.GetParamValues;
var
  oTab: TADDatSTable;
  i, j: Integer;
  s: String;
  oPar: TADParam;
  ePrevState: TADPhysCommandState;
begin
  if (FCursor <> nil) and not TADPhysMySQLConnection(FConnectionObj).FSession.MoreResults and
     (GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs]) then begin
    oTab := TADDatSTable.Create;
    ePrevState := GetState;
    SetState(csOpen);
    try
      Define(oTab);
      FCursor.Fetch(1);
      FetchRow(oTab, nil);
      for i := 0 to oTab.Columns.Count - 1 do begin
        oPar := GetParams.FindParam(oTab.Columns[i].Name);
        if (oPar <> nil) and (oPar.ParamType in [ptOutput, ptInputOutput, ptResult]) then begin
          if (oPar.DataType in [ftFloat, ftCurrency, ftBCD {$IFDEF AnyDAC_D6}, ftFMTBcd {$ENDIF}]) and
             (DecimalSeparator <> '.') then begin
            s := oTab.Rows[0].GetData(i);
            j := Pos('.', s);
            if j <> 0 then
              s[j] := DecimalSeparator;
            oPar.Value := s;
          end
          else
            oPar.Value := oTab.Rows[0].GetData(i);
        end;
      end;
      GetCursor;
    finally
      SetState(ePrevState);
      oTab.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.InternalClose;
begin
  CloseStatement(False);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.CloseStatement(AForceClose: Boolean);
var
  oCon: TADPhysMySQLConnection;
begin
  if AForceClose or not GetNextRecordSet then begin
    oCon := TADPhysMySQLConnection(FConnectionObj);
    while oCon.FSession.MoreResults and oCon.FSession.NextResult do begin
      GetCursor;
      if GetMetaInfoKind = mkNone then
        GetParamValues;
    end;
  end;
  FreeAndNil(FCursor);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
var
  oRow: TADDatSRow;
  j: Integer;
  iSrcLen, iDestLen: LongWord;
  pSrcData: PChar;
  pDestData: Pointer;
  lHasValue, lTypeSupported: Boolean;
begin
  oRow := ATable.NewRow(False);
  try
    for j := 0 to ATable.Columns.Count - 1 do
      with ATable.Columns[j] do                                
        if (SourceID > 0) and CheckFetchColumn(SourceDataType) then begin
          lTypeSupported := True;
          // if need conversion
          if SourceDataType <> DataType then begin
            pSrcData := nil;
            iSrcLen := 0;
            lHasValue := FCursor.GetData(SourceID - 1, Pointer(pSrcData), iSrcLen);
            if lHasValue then begin
              FBuffer.Check((iSrcLen + 1) * SizeOf(WideChar));
              pDestData := FBuffer.Ptr;
              iDestLen := 0;
              lHasValue := MySQL2DataValue(pSrcData, iSrcLen, pDestData, iDestLen,
                SourceDataType, Attributes, lTypeSupported);
            end;
            if lHasValue then
              GetFormatOptions.ConvertRawData(SourceDataType, DataType, pDestData,
                iDestLen, pDestData, FBuffer.Size, iDestLen);
          end
          // if dont need conversion
          else begin
            lHasValue := FCursor.GetData(SourceID - 1, Pointer(pSrcData), iSrcLen);
            if lHasValue then begin
              FBuffer.Check((iSrcLen + 1) * SizeOf(WideChar));
              pDestData := FBuffer.Ptr;
              lHasValue := MySQL2DataValue(pSrcData, iSrcLen, pDestData, iDestLen,
                SourceDataType, Attributes, lTypeSupported);
            end;
          end;
          if not lTypeSupported then
            ColTypeMapError(ATable.Columns[j]);
          // set data
          if lHasValue then
            oRow.SetData(j, pDestData, iDestLen)
          else
            oRow.SetData(j, nil, 0);
        end;
    ATable.Rows.Add(oRow);
  except
    oRow.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.MySQLType2ADType(const AStr: String; var AType: TADDataType;
  var AAttrs: TADDataAttributes; var ALen: LongWord; var APrec, AScale: Integer);
var
  i1, i2: Integer;
  iLen: LongWord;
  sType, sArgs, sArgs2, sMod: String;
  lUnsigned: Boolean;

  procedure SetPrecScale(ADefPrec, ADefScale: Integer);
  var
    sPrec, sScale: String;
    i: Integer;
  begin
    i := Pos(',', sArgs);
    if i = 0 then
      sPrec := sArgs
    else begin
      sPrec := Copy(sArgs, 1, i - 1);
      sScale := Copy(sArgs, i + 1, Length(sArgs));
    end;
    APrec := StrToIntDef(sPrec, ADefPrec);
    AScale := StrToIntDef(sScale, ADefScale);
  end;

  procedure SetLen(ADefLen: Integer);
  begin
    ALen := StrToIntDef(sArgs, ADefLen);
  end;

begin
  i1 := Pos('(', AStr);
  i2 := Pos(')', AStr);
  if i1 = 0 then begin
    i1 := Pos(' ', AStr);
    if i1 = 0 then begin
      sType := UpperCase(AStr);
      sArgs := '';
      sMod := '';
    end
    else begin
      sType := UpperCase(Copy(AStr, 1, i1 - 1));
      sArgs := '';
      sMod := UpperCase(Copy(AStr, i1 + 1, Length(AStr)));
    end;
  end
  else begin
    sType := UpperCase(Copy(AStr, 1, i1 - 1));
    sArgs := Copy(AStr, i1 + 1, i2 - i1 - 1);
    sMod := UpperCase(Copy(AStr, i2 + 1, Length(AStr)));
  end;
  lUnsigned := Pos(' UNSIGNED', sMod) <> 0;
  AType := dtUnknown;
  AAttrs := [caSearchable];
  ALen := 0;
  APrec := 0;
  AScale := 0;
  if sType = 'ENUM' then begin
    sArgs2 := UpperCase(sArgs);
    if (sArgs2 = '''Y'',''N''') or (sArgs2 = '''N'',''Y''') or
       (sArgs2 = '''T'',''F''') or (sArgs2 = '''F'',''T''') or
       (sArgs2 = '''TRUE'',''FALSE''') or (sArgs2 = '''FALSE'',''TRUE''') or
       (sArgs2 = '''YES'',''NO''') or (sArgs2 = '''NO'',''YES''') then
      AType := dtBoolean
    else begin
      AType := dtAnsiString;
      AAttrs := [caSearchable];
      i1 := 1;
      repeat
        i2 := ADPosEx(',', sArgs, i1);
        if i2 = 0 then
          i2 := Length(sArgs) + 1;
        iLen := i2 - i1;
        if sArgs[i1] = '''' then
          Dec(iLen, 2);
        if ALen < iLen then
          ALen := iLen;
        i1 := i2 + 1;
      until i2 > Length(sArgs);
    end;
  end
  else if sType = 'SET' then begin
    sArgs2 := UpperCase(sArgs);
    AType := dtAnsiString;
    AAttrs := [caSearchable];
    i1 := 1;
    repeat
      i2 := ADPosEx(',', sArgs, i1);
      if i2 = 0 then
        i2 := Length(sArgs) + 1;
      iLen := i2 - i1;
      if sArgs[i1] = '''' then
        Dec(iLen, 2);
      Inc(ALen, iLen + 1);
      i1 := i2 + 1;
    until i2 > Length(sArgs);
  end
  else if sType = 'TINYINT' then
    if lUnsigned then
      AType := dtByte
    else
      AType := dtSByte
  else if (sType = 'BIT') or (sType = 'BOOL') then
    AType := dtBoolean
  else if sType = 'SMALLINT' then
    if lUnsigned then
      AType := dtUInt16
    else
      AType := dtInt16
  else if (sType = 'MEDIUMINT') or (sType = 'INTEGER') or (sType = 'INT') then
    if lUnsigned then
      AType := dtUInt32
    else
      AType := dtInt32
  else if sType = 'BIGINT' then
    if lUnsigned then
      AType := dtUInt64
    else
      AType := dtInt64
  else if (sType = 'FLOAT') or (sType = 'DOUBLE') or (sType = 'REAL') then begin
    SetPrecScale(0, 0);
    if APrec > 16 then
      with GetFormatOptions do
        if (APrec <= MaxBcdPrecision) and (AScale <= MaxBcdScale) then
          AType := dtBCD
        else
          AType := dtFmtBCD
    else
      AType := dtDouble;
  end
  else if (sType = 'DECIMAL') or (sType = 'DEC') or (sType = 'NUMERIC') then begin
    SetPrecScale(10, 0);
    if AScale = 0 then
      if lUnsigned then begin
        if APrec <= 3 then
          AType := dtByte
        else if APrec <= 5 then
          AType := dtUInt16
        else if APrec <= 10 then
          AType := dtUInt32
        else if APrec <= 21 then
          AType := dtUInt64;
      end
      else begin
        if APrec <= 2 then
          AType := dtSByte
        else if APrec <= 4 then
          AType := dtInt16
        else if APrec <= 9 then
          AType := dtInt32
        else if APrec <= 20 then
          AType := dtInt64;
      end;
    if AType = dtUnknown then
      with GetFormatOptions do
        if (APrec <= MaxBcdPrecision) and (AScale <= MaxBcdScale) then
          AType := dtBCD
        else
          AType := dtFmtBCD
    else
      APrec := 0;
  end
  else if sType = 'DATE' then
    AType := dtDate
  else if sType = 'DATETIME' then
    AType := dtDateTime
  else if sType = 'TIMESTAMP' then begin
    AType := dtDateTimeStamp;
    Include(AAttrs, caRowVersion);
  end
  else if sType = 'TIME' then
    AType := dtTime
  else if sType = 'YEAR' then
    AType := dtUInt16
  else if sType = 'CHAR' then begin
    SetLen(1);
    AType := dtAnsiString;
    Include(AAttrs, caFixedLen);
  end
  else if sType = 'VARCHAR' then begin
    SetLen(255);
    AType := dtAnsiString;
  end
  else if sType = 'TYNIBLOB' then begin
    AType := dtByteString;
    ALen := 255;
  end
  else if sType = 'TYNITEXT' then begin
    AType := dtAnsiString;
    ALen := 255;
  end
  else if (sType = 'BLOB') or (sType = 'MEDIUMBLOB') or (sType = 'LONGBLOB') then begin
    Exclude(AAttrs, caSearchable);
    Include(AAttrs, caBlobData);
    AType := dtBlob;
  end
  else if (sType = 'TEXT') or (sType = 'MEDIUMTEXT') or (sType = 'LONGTEXT') then begin
    Exclude(AAttrs, caSearchable);
    Include(AAttrs, caBlobData);
    AType := dtMemo;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.GetCrsData(ACrsCol: Integer; var AData: Pointer;
  var ALen: LongWord; AType: TADDataType): Boolean;
var
  pSrcData: Pointer;
  iSrcLen: LongWord;
  lTypeSupported: Boolean;
begin
  pSrcData := nil;
  iSrcLen := 0;
  Result := FCursor.GetData(ACrsCol, pSrcData, iSrcLen) and
    MySQL2DataValue(pSrcData, iSrcLen, AData, ALen, AType, [], lTypeSupported) and
    lTypeSupported;
  if not Result then
    ALen := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.FetchMetaRow(ATable: TADDatSTable;
  AParentRow: TADDatSRow);
var
  pData: Pointer;
  uiLen: LongWord;
  oRow: TADDatSRow;
  lDeleteRow: Boolean;
  s: String;
  eType: TADDataType;
  eAttrs: TADDataAttributes;
  iPrec, iScale: Integer;
  eIndKind: TADPhysIndexKind;
  i, iNullFld, iDefFld, iExtraFld: Integer;
  rName: TADPhysParsedName;
  oConnMeta: IADPhysConnectionMetadata;
begin
  pData := FBuffer.Ptr;
  oRow := ATable.NewRow(False);
  lDeleteRow := False;
  case GetMetaInfoKind of
  mkTables:
    begin
      oRow.SetData(0, ATable.Rows.Count + 1);
      oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).FSession.DB);
      oRow.SetData(2, nil, 0);
      uiLen := 0;
      GetCrsData(0, pData, uiLen, dtAnsiString);
      oRow.SetData(3, pData, uiLen);
      oRow.SetData(4, SmallInt(tkTable));
      oRow.SetData(5, SmallInt(osMy));
      lDeleteRow := not (tkTable in GetTableKinds) or
        not (osMy in GetObjectScopes);
    end;
  mkTableFields:
    begin
      oRow.SetData(0, ATable.Rows.Count + 1);
      oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).FSession.DB);
      oRow.SetData(2, nil, 0);
      FConnection.CreateMetadata(oConnMeta);
      oConnMeta.DecodeObjName(GetCommandText, rName, Self, [doUnquote, doNormalize]);
      oRow.SetData(3, rName.FObject);
      GetCrsData(0, pData, uiLen, dtAnsiString);
      oRow.SetData(4, pData, uiLen);
      oRow.SetData(5, ATable.Rows.Count + 1);
      GetCrsData(1, pData, uiLen, dtAnsiString);
      SetString(s, PChar(pData), uiLen);
      eType := dtUnknown;
      eAttrs := [];
      uiLen := 0;
      iPrec := 0;
      iScale := 0;
      MySQLType2ADType(s, eType, eAttrs, uiLen, iPrec, iScale);
{$IFDEF AnyDAC_D6Base}
      oRow.SetData(6, LongWord(eType));
{$ELSE}
      oRow.SetData(6, Integer(eType));
{$ENDIF}
      oRow.SetData(7, Copy(s, 1, 50));
      oRow.SetData(9, iPrec);
      oRow.SetData(10, iScale);
{$IFDEF AnyDAC_D6Base}
      oRow.SetData(11, uiLen);
{$ELSE}
      oRow.SetData(11, Integer(uiLen));
{$ENDIF}
      iNullFld := 2;
      iDefFld := 4;
      iExtraFld := 5;
      if GetCrsData(iNullFld, pData, uiLen, dtAnsiString) and
         (StrIComp(PChar('YES'), PChar(pData)) = 0) then
        Include(eAttrs, caAllowNull);
      if GetCrsData(iDefFld, pData, uiLen, dtAnsiString) and (uiLen > 0) then
        Include(eAttrs, caDefault);
      if GetCrsData(iExtraFld, pData, uiLen, dtAnsiString) and
         (StrIComp(PChar('AUTO_INCREMENT'), PChar(pData)) = 0) then begin
        Include(eAttrs, caAutoInc);
        Include(eAttrs, caAllowNull);
      end;
      oRow.SetData(8, PWord(@eAttrs)^);
    end;
  mkIndexes,
  mkPrimaryKey:
    begin
      oRow.SetData(0, ATable.Rows.Count + 1);
      oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).FSession.DB);
      oRow.SetData(2, nil, 0);
      GetCrsData(0, pData, uiLen, dtAnsiString);
      oRow.SetData(3, pData, uiLen);
      GetCrsData(1, pData, uiLen, dtUInt16);
      if PWord(pData)^ = 0 then
        eIndKind := ikUnique
      else
        eIndKind := ikNonUnique;
      GetCrsData(2, pData, uiLen, dtAnsiString);
      if (eIndKind = ikUnique) and (StrIComp(PChar(pData), PChar('PRIMARY')) = 0) then
        eIndKind := ikPrimaryKey;
      oRow.SetData(4, pData, uiLen);
      if eIndKind = ikPrimaryKey then
        oRow.SetData(5, pData, uiLen)
      else
        oRow.SetData(5, nil, 0);
      oRow.SetData(6, Integer(eIndKind));
      if (GetMetaInfoKind = mkPrimaryKey) and (ATable.Rows.Count > 0) then
        lDeleteRow := True;
      if not lDeleteRow then
        for i := 0 to ATable.Rows.Count - 1 do begin
          if AnsiCompareText(VarToStr(ATable.Rows[i].GetData(4, rvDefault)), VarToStr(oRow.GetData(4, rvDefault))) = 0 then begin
            lDeleteRow := True;
            Break;
          end;
        end;
    end;
  mkIndexFields,
  mkPrimaryKeyFields:
    begin
      oRow.SetData(0, ATable.Rows.Count + 1);
      oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).FSession.DB);
      oRow.SetData(2, nil, 0);
      GetCrsData(0, pData, uiLen, dtAnsiString);
      oRow.SetData(3, pData, uiLen);
      GetCrsData(1, pData, uiLen, dtInt16);
      if PSmallInt(pData)^ = 0 then
        eIndKind := ikUnique
      else
        eIndKind := ikNonUnique;
      GetCrsData(2, pData, uiLen, dtAnsiString);
      if (eIndKind = ikUnique) and (StrIComp(PChar(pData), PChar('PRIMARY')) = 0) then
        eIndKind := ikPrimaryKey;
      oRow.SetData(4, pData, uiLen);
      GetCrsData(4, pData, uiLen, dtAnsiString);
      oRow.SetData(5, pData, uiLen);
      GetCrsData(3, pData, uiLen, dtInt16);
      oRow.SetData(6, pData, uiLen);
      GetCrsData(5, pData, uiLen, dtAnsiString);
      oRow.SetData(7, pData, uiLen);
      oRow.SetData(8, nil, 0);
      FConnection.CreateMetadata(oConnMeta);
      oConnMeta.DecodeObjName(GetCommandText, rName, Self, [doUnquote, doNormalize]);
      if not lDeleteRow then
        if (GetMetaInfoKind = mkPrimaryKeyFields) and
             ((eIndKind <> ikPrimaryKey) or
              (ATable.Rows.Count > 0) and
              (AnsiCompareText(VarToStr(ATable.Rows[0].GetData(4, rvDefault)), VarToStr(oRow.GetData(4, rvDefault))) <> 0)
             ) or
           (GetMetaInfoKind = mkIndexFields) and
             (AnsiCompareText(VarToStr(oRow.GetData(4, rvDefault)), rName.FObject) <> 0) then
          lDeleteRow := True;
    end;
  mkForeignKeys,
  mkForeignKeyFields:
    ASSERT(False);
  mkProcs:
    begin
      oRow.SetData(0, ATable.Rows.Count + 1);
      if GetCrsData(1, pData, uiLen, dtAnsiString) then
        oRow.SetData(1, pData, uiLen);
      if GetCrsData(2, pData, uiLen, dtAnsiString) then
        oRow.SetData(2, pData, uiLen);
      if GetCrsData(3, pData, uiLen, dtAnsiString) then
        oRow.SetData(3, pData, uiLen);
      if GetCrsData(4, pData, uiLen, dtAnsiString) then
        oRow.SetData(4, pData, uiLen);
      if GetCrsData(5, pData, uiLen, dtInt16) then
        oRow.SetData(5, pData, uiLen);
      if GetCrsData(6, pData, uiLen, dtInt16) then
        oRow.SetData(6, pData, uiLen);
      if GetCrsData(7, pData, uiLen, dtInt16) then
        oRow.SetData(7, pData, uiLen);
      if GetCrsData(8, pData, uiLen, dtInt16) then
        oRow.SetData(8, pData, uiLen);
      if GetCrsData(9, pData, uiLen, dtInt16) then
        oRow.SetData(9, pData, uiLen);
    end;
  mkProcArgs:
    ASSERT(False);
  else
    lDeleteRow := True;
  end;
  if lDeleteRow then
    oRow.Free
  else
    ATable.Rows.Add(oRow);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.FetchSPParamRows(ATable: TADDatSTable;
  AParentRow: TADDatSRow): Integer;

  procedure AddParam(const ASQL: String; AFrom, ATo: Integer);
  var
    iPrev: Integer;
    sName, sCmd: String;
    eDir: TParamType;
    eType: TADDataType;
    eAttrs: TADDataAttributes;
    iPrec, iScale: Integer;
    uiLen: LongWord;
    oRow: TADDatSRow;
  begin
    while (AFrom <= ATo) and (ASQL[AFrom] in [' ', #7, #13, #10]) do
      Inc(AFrom);
    if StrLIComp(PChar(ASQL) + AFrom - 1, PChar('RETURNS'), 7) = 0 then begin
      eDir := ptResult;
      Inc(AFrom, 7);
    end
    else if StrLIComp(PChar(ASQL) + AFrom - 1, PChar('INOUT'), 5) = 0 then begin
      eDir := ptInputOutput;
      Inc(AFrom, 5);
    end
    else if StrLIComp(PChar(ASQL) + AFrom - 1, PChar('IN'), 2) = 0 then begin
      eDir := ptInput;
      Inc(AFrom, 2);
    end
    else if StrLIComp(PChar(ASQL) + AFrom - 1, PChar('OUT'), 3) = 0 then begin
      eDir := ptOutput;
      Inc(AFrom, 3);
    end
    else
      eDir := ptInput;
    if eDir = ptResult then
      sName := 'result'
    else begin
      while (AFrom <= ATo) and (ASQL[AFrom] in [' ', #7, #13, #10]) do
        Inc(AFrom);
      if ASQL[AFrom] = '`' then begin
        iPrev := AFrom;
        repeat
          Inc(AFrom);
        until (AFrom > ATo) or (ASQL[AFrom] = '`');
        sName := Copy(ASQL, iPrev + 1, AFrom - iPrev - 1);
      end
      else begin
        iPrev := AFrom;
        repeat
          Inc(AFrom);
        until (AFrom > ATo) or (ASQL[AFrom] in [')', '(', ',', ' ', #7, #13, #10]);
        sName := Copy(ASQL, iPrev, AFrom - iPrev);
      end;
      Inc(AFrom);
    end;

    if (GetWildcard <> '') and not ADStrLike(sName, GetWildcard) then
      Exit;

    while (AFrom <= ATo) and (ASQL[AFrom] in [' ', #7, #13, #10]) do
      Inc(AFrom);
    eType := dtUnknown;
    eAttrs := [];
    uiLen := 0;
    iPrec := 0;
    iScale := 0;
    MySQLType2ADType(Copy(ASQL, AFrom, ATo - AFrom + 1), eType, eAttrs, uiLen, iPrec, iScale);

    oRow := ATable.NewRow(False);
    oRow.SetData(0, ATable.Rows.Count + 1);
    oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).FSession.DB);
    oRow.SetData(2, nil, 0);
    oRow.SetData(3, nil, 0);
    sCmd := Trim(GetCommandText());
    oRow.SetData(4, PChar(sCmd), Length(sCmd));
    oRow.SetData(5, 0);
    oRow.SetData(6, PChar(sName), Length(sName));
    oRow.SetData(7, Smallint(ATable.Rows.Count + 1));
    oRow.SetData(8, Smallint(eDir));
    oRow.SetData(9, Smallint(eType));
    oRow.SetData(10, nil, 0);
    oRow.SetData(11, PWord(@eAttrs)^);
    oRow.SetData(12, iPrec);
    oRow.SetData(13, iScale);
{$IFDEF AnyDAC_D6Base}
    oRow.SetData(14, uiLen);
{$ELSE}
    oRow.SetData(14, Integer(uiLen));
{$ENDIF}
    ATable.Rows.Add(oRow);
  end;

var
  pData: Pointer;
  iLen: LongWord;
  sMode, sSQL: String;
  lAnsiQuotes, {lNoBackslash,} lInQuote1, lInQuote2: Boolean;
  i, iBraces, iPrev: Integer;
begin
  Result := 0;
  pData := nil;
  iLen := 0;
  GetCrsData(1, pData, iLen, dtAnsiString);
  SetString(sMode, PChar(pData), iLen);
  pData := nil;
  iLen := 0;
  GetCrsData(2, pData, iLen, dtAnsiString);
  SetString(sSQL, PChar(pData), iLen);

  lAnsiQuotes := Pos('ANSI_QUOTES', sMode) <> 0;
  // lNoBackslash := Pos('NO_BACKSLASH_ESCAPES', sMode) <> 0;

  { TODO : Will fail if comment contains '(' }
  i := Pos('(', sSQL) + 1;
  lInQuote1 := False;
  lInQuote2 := False;
  iBraces := 0;
  iPrev := i;
  while i < Length(sSQL) do begin
    case sSQL[i] of
    '`':
      if not lInQuote2 then
        lInQuote1 := not lInQuote1;
    '"':
      if lAnsiQuotes and not lInQuote1 then
        lInQuote2 := not lInQuote2;
    '(':
      if not lInQuote2 and not lInQuote1 then
        Inc(iBraces);
    ')':
      if not lInQuote2 and not lInQuote1 then
        if iBraces = 0 then begin
          if iPrev <= i - 1 then begin
            AddParam(sSQL, iPrev, i - 1);
            Inc(Result);
          end;
          Inc(i);
          Break;
        end
        else
          Dec(iBraces);
    ',':
      if not lInQuote2 and not lInQuote1 and (iBraces = 0) then begin
        AddParam(sSQL, iPrev, i - 1);
        Inc(Result);
        iPrev := i + 1;
      end;
    end;
    Inc(i);
  end;

  while (i < Length(sSQL)) and (sSQL[i] in [' ', #7, #13, #10]) do
    Inc(i);
  if StrLIComp(PChar(sSQL) + i - 1, PChar('RETURNS'), 7) = 0 then begin
    AddParam(sSQL, i, Length(sSQL));
    Inc(Result);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.FetchFKRows(ATable: TADDatSTable;
  AParentRow: TADDatSRow): Integer;
var
  sComment, sFKey, sFKCat, sFKTab, sTabName, sFKName, sFields, sFKFields, s: String;
  iCommentField, i, i1, i2, i3, i4, i5, j1, j2: Integer;
  pData: Pointer;
  uiLen: LongWord;
  oRow: TADDatSRow;
begin
  Result := 0;
  pData := FBuffer.Ptr;
  uiLen := 0;
  if TADPhysMySQLConnection(FConnectionObj).FServerVersion < mvMySQL040100 then
    iCommentField := 14
  else
    iCommentField := 15;
  GetCrsData(iCommentField, pData, uiLen, dtAnsiString);
  SetString(sComment, PChar(pData), uiLen);
  GetCrsData(0, pData, uiLen, dtAnsiString);
  SetString(sTabName, PChar(pData), uiLen);
  if Pos('InnoDB', sComment) = 1 then begin
    i := 1;
    ADExtractFieldName(sComment, i, GSemicolonFmtSettings);
    while i <= Length(sComment) do begin
      sFKey := ADExtractFieldName(sComment, i, GSemicolonFmtSettings);
      i1 := ADPosEx('(', sFKey, 1);
      i2 := ADPosEx(')', sFKey, i1);
      i3 := ADPosEx('/', sFKey, i2);
      i4 := ADPosEx('(', sFKey, i3);
      i5 := ADPosEx(')', sFKey, i4);
      if (i1 <> -1) and (i2 <> -1) and (i3 <> -1) and (i4 <> -1) and (i5 <> -1) then begin
        sFKCat := TrimQuotes(Copy(sFKey, i2 + 8, i3 - i2 - 8));
        sFKTab := TrimQuotes(Copy(sFKey, i3 + 1, i4 - i3 - 1));
        sFKName := sTabName + '_to_' + sFKTab;
        sFields := Copy(sFKey, i1 + 1, i2 - i1 - 1);
        sFKFields := Copy(sFKey, i4 + 1, i5 - i4 - 1);
        if GetMetaInfoKind = mkForeignKeys then begin
          oRow := ATable.NewRow(False);
          oRow.SetData(0, ATable.Rows.Count + 1);
          oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).FSession.DB);
          oRow.SetData(2, nil, 0);
          oRow.SetData(3, PChar(sTabName), Length(sTabName));
          oRow.SetData(4, PChar(sFKName), Length(sFKName));
          oRow.SetData(5, PChar(sFKCat), Length(sFKCat));
          oRow.SetData(6, nil, 0);
          oRow.SetData(7, PChar(sFKTab), Length(sFKTab));
          oRow.SetData(8, IntToStr(Integer(ckCascade)));
          oRow.SetData(9, IntToStr(Integer(ckCascade)));
          ATable.Rows.Add(oRow);
          Inc(Result);
        end
        else if AnsiCompareText(sFKName, TrimQuotes(GetCommandText)) = 0 then begin
          j1 := 1;
          j2 := 1;
          while (j1 <= Length(sFields)) and (j2 <= Length(sFKFields)) do begin
            oRow := ATable.NewRow(False);
            oRow.SetData(0, ATable.Rows.Count + 1);
            oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).FSession.DB);
            oRow.SetData(2, nil, 0);
            oRow.SetData(3, PChar(sTabName), Length(sTabName));
            oRow.SetData(4, PChar(sFKName), Length(sFKName));
            s := TrimQuotes(ADExtractFieldName(sFields, j1, GSpaceFmtSettings));
            oRow.SetData(5, PChar(s), Length(s));
            s := TrimQuotes(ADExtractFieldName(sFKFields, j2, GSpaceFmtSettings));
            oRow.SetData(6, PChar(s), Length(s));
            oRow.SetData(7, Result + 1);
            ATable.Rows.Add(oRow);
            Inc(Result);
          end;
          Break;
        end;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalFetchRowSet(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowsetSize: LongWord): LongWord;
var
  i: LongWord;
begin
  Result := 0;
  if GetMetaInfoKind = mkProcArgs then begin
    if FCursor.Fetch(1) then
      Result := FetchSPParamRows(ATable, AParentRow);
  end
  else if GetMetaInfoKind in [mkForeignKeys, mkForeignKeyFields] then begin
    if FCursor.Fetch(1) then
      Result := FetchFKRows(ATable, AParentRow);
  end
  else
    for i := 1 to ARowsetSize do begin
      if not FCursor.Fetch(i) then
        Break;
      if GetMetaInfoKind = mkNone then
        FetchRow(ATable, AParentRow)
      else
        FetchMetaRow(ATable, AParentRow);
      Inc(Result);
    end;
end;

{-----------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysMySQLConnection);

finalization
//  ADPhysManagerObj.UnRegisterPhysConnectionClass(TADPhysMySQLConnection);

end.
