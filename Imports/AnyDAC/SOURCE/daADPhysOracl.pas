{-------------------------------------------------------------------------------}
{ AnyDAC Oracle driver                                                          }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysOracl;

interface

uses
  daADPhysManager;

type
  TADPhysOraclDriverLink = class(TADPhysDriverLinkBase)
  end;

{-------------------------------------------------------------------------------}
implementation

uses
{$IFDEF Win32}
  Windows,
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}  
  Classes, SysUtils, DB,
  daADStanIntf, daADStanParam, daADStanError, daADStanOption, daADStanUtil,
    daADStanConst,
  daADDatSManager,
  daADPhysIntf, daADPhysOraclMeta, daADPhysCmdGenerator, daADPhysOraclCli,
    daADPhysOraclWrapper;

type
  TADPhysOraclDriver = class;
  TADPhysOraclConnection = class;
  TADPhysOraclCommand = class;

  TADOraCommandHasParams = set of (hpHBlobsRet, hpInput, hpOutput, hpCursors,
    hpLongData, hpManyVLobs);
  TADOraCommandHasFields = set of (hfNChar, hfManyNChars, hfLongData, hfBlob);

  TADPhysOraclDriver = class(TADPhysDriver)
  private
    FLib: TOCILib;
  protected
    function GetDescription: String; override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; Index: Integer;
      var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  public
    constructor Create(ADrvHost: TADPhysDriverHost); override;
    destructor Destroy; override;
    class function GetDriverID: String; override;
  end;

  TADPhysOraclConnection = class(TADPhysConnection)
  private
    FMode: ub4;
    FEnv: TOCIEnv;
    FService: TOCIService;
    FSession: TOCISession;
    FServer: TOCIServer;
    FTransaction: TOCITransaction;
    FServerVersion: Integer;
    FUseDBAViews: Boolean;
    FDecimalSep: Char;
    FPieceBuffLen: ub4;
    FBooleanValues: String;
{$IFDEF AnyDAC_MONITOR}
    FNLSParams: TStrings;
{$ENDIF}
    FLastServerOutput: Boolean;
    FLastServerOutputSize: Integer;
    procedure DirectExec(const ASQL: String);
    procedure ParseAliasOther;
    procedure ParseAliasConnStr(var AUsr, APwd, ASrv: String; var AAuthMode: ub4);
    procedure GetServerInfo;
    function GetAutoCommit: Boolean;
    procedure AlterSession;
    procedure UpdateServerOutput;
    procedure GetServerOutput;
  protected
    procedure InternalConnect; override;
    procedure InternalDisconnect; override;
    function InternalCreateCommand: TADPhysCommand; override;
    procedure InternalTxBegin(ATxID: LongWord); override;
    procedure InternalTxCommit(ATxID: LongWord); override;
    procedure InternalTxRollback(ATxID: LongWord); override;
    procedure InternalTxSetSavepoint(const AName: String); override;
    procedure InternalTxRollbackToSavepoint(const AName: String); override;
    procedure InternalChangePassword(const AUserName, AOldPassword, ANewPassword: String); override;
    function InternalCreateMetadata: TObject; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand):
      TADPhysCommandGenerator; override;
    procedure GetItem(AIndex: Integer; var AName: String;
      var AValue: Variant; var AKind: TADDebugMonitorAdapterItemKind); override;
    function GetItemCount: Integer; override;
    function GetMessages: EADDBEngineException; override;
    function GetCliObj: TObject; override;
  public
    constructor Create(ADriverObj: TADPhysDriver; const ADriver: IADPhysDriver;
      AConnHost: TADPhysConnectionHost); override;
    class function GetDriverClass: TADPhysDriverClass; override;
  end;

  TADOraCrsDataRec = record
    FStmt: TOCIStatement;
    FColInfos: TList;
    FColIndex: Integer;
    FExecuted: Boolean;
    FHasFields: TADOraCommandHasFields;
  end;
  PADOraCrsDataRec = ^TADOraCrsDataRec;

  TADOraVarInfoRec = record
    FName,
    FExtName:     String;
    FPos:         sb4;
    FOSrcType,
    FOOutputType: TOCIVarDataType;
    FSrcType,
    FOutputType,
    FDestType:    TADDataType;
    FByteSize,
    FLogSize:     ub4;
    FVar:         TOCIVariable;
    case FVarType: TOCIVarType of
    odDefine: (
      FPrec:     ub4;
      FScale:    ub4;
      FIsNull:   Boolean;
      FCrsInfo:  PADOraCrsDataRec;
    );
    odIn, odOut, odInOut, odRet: (
      FArrayLen:        ub4;
      FIsCaseSensitive: Boolean;
      FIsPLSQLTable:    Boolean;
      FParType:         TParamType;
      FDataType:        TFieldType;
    )
  end;
  PDEOraColInfoRec = ^TADOraVarInfoRec;
  PDEOraParInfoRec = ^TADOraVarInfoRec;

  TADPhysOraclCommand = class(TADPhysCommand)
  private
    FBase: TADOraCrsDataRec;
    FCurrentCrsInfo: PADOraCrsDataRec;
    FParInfos: TList;
    FCrsInfos: TList;
    FActiveCrs: Integer;
    FInfoStack: TList;
    FCursorCanceled: Boolean;
    FBindVarsDirty: Boolean;
    FHasParams: TADOraCommandHasParams;
    function GenerateSPSQLFromDB: String;
    function GenerateSPSQLFromParams: String;
    procedure DefParInfos(const ANm: String; AVt: TOCIVarType;
      ADt: TOCIVarDataType; ASz, APrec, ASCale: sb4; AIsTable, AIsResult: Boolean);
    function GenerateMetaInfoSQL: String;
    procedure SetParamValues(AIntoReturning: Boolean; AFromParIndex: Integer = -1);
    procedure GetParamValues;
    procedure CreateDefineInfo(ACrsInfo: PADOraCrsDataRec);
    procedure CreateBindInfo;
    procedure DestroyDefineInfo(ACrsInfo: PADOraCrsDataRec);
    procedure DestroyBindInfo;
    procedure ResetDefVars(ACrsInfo: PADOraCrsDataRec;
      ARowsetSize: LongWord);
    function ProcessRowSet(ACrsInfo: PADOraCrsDataRec;
      ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): Integer;
    procedure SetupStatement(AStmt: TOCIStatement);
    procedure DestroyStmt(ACrsInfo: PADOraCrsDataRec);
    procedure CheckParamMatching(APar: TADParam;
      AParInfo: PDEOraParInfoRec);
    function GetActiveCursor: PADOraCrsDataRec;
    procedure RebindCursorParams;
    procedure DestroyCrsInfo;
    function IsActiveCursorValid: Boolean;
    function GetRowsetSize(ACrsInfo: PADOraCrsDataRec; ARowsetSize: Integer): Integer;
    function ADType2OCIType(AType: TADDataType; AFixedLen: Boolean): TOCIVarDataType;
    procedure InitCrsData(ACrsInfo: PADOraCrsDataRec);
  protected
    procedure InternalAbort; override;
    procedure InternalClose; override;
    procedure InternalExecute(ATimes: LongInt; AOffset: LongInt; var ACount: LongInt); override;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; override;
    function InternalOpen: Boolean; override;
    function InternalNextRecordSet: Boolean; override;
    procedure InternalPrepare; override;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; override;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; override;
    procedure InternalUnprepare; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

const
  CSysNormal = 'Normal';
  SSysDba = 'SysDBA';
  SSysOper = 'SysOper';

  SService = 'Service';
  SMode = 'Mode';

  ovdt2addt: array [TOCIVarDataType] of TADDataType = (
    dtUnknown, dtInt32, dtDouble, dtFmtBCD, dtAnsiString, dtAnsiString,
    dtWideString, dtWideString, dtByteString, dtDateTimeStamp, dtMemo,
    dtWideMemo, dtBlob, dtAnsiString, dtCursorRef, dtRowSetRef, dtHMemo,
    dtWideHMemo, dtHBlob, dtHBFile, dtHBFile);

  addt2ovdt: array [TADDataType] of TOCIVarDataType = (
    otUnknown,
    otInteger,
    otInteger, otInteger, otInteger, otNumber,
    otInteger, otInteger, otInteger, otNumber,
    otFloat, otNumber, otNumber, otNumber,
    otDateTime, otDateTime, otDateTime, otDateTime,
    otString, otNString, otRaw,
    otLongRaw, otLong, otNLong,
    otBLOB, otCLOB, otNCLOB,
    otBFile,
    otNestedDataSet, otCursor, otUnknown,
      otUnknown, otUnknown,
    otUnknown, otUnknown);

  pt2vt: array [TParamType] of TOCIVarType = (
    odUnknown, odIn, odOut, odInOut, odOut);
  vt2pt: array [TOCIVarType] of TParamType = (
    ptUnknown, ptInput, ptOutput, ptInputOutput, ptOutput, ptUnknown);

{-------------------------------------------------------------------------------}
{ TADPhysOraclDriver                                                            }
{-------------------------------------------------------------------------------}
constructor TADPhysOraclDriver.Create(ADrvHost: TADPhysDriverHost);
var
  sHome, sLib: String;
begin
  inherited Create(ADrvHost);
  sHome := '';
  sLib := '';
  ADrvHost.GetVendorParams(sHome, sLib);
  FLib := TOCILib.Create(sHome, sLib, ADPhysManagerObj);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysOraclDriver.Destroy;
begin
  FreeAndNil(FLib);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADPhysOraclDriver.GetDriverID: String;
begin
  Result := S_AD_OraId;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclDriver.GetDescription: String;
begin
  Result := 'Oracle Driver';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 10;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclDriver.GetConnParams(AKeys: TStrings; Index: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  oList: TStringList;
  i: Integer;
begin
  ALoginIndex := -1;
  if Index < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, Index, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then begin
      oList := TStringList.Create;
      try
        FLib.GetTNSServicesList(oList);
        AType := '';
        for i := 0 to oList.Count - 1 do begin
          if AType <> '' then
            AType := AType + ';';
          AType := AType + oList[i];
        end;
      finally
        oList.Free;
      end;
      ACaption := SService;
      ALoginIndex := 2;
    end;
  end
  else
    case Index - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_Oracl_AuthMode;
        AType := CSysNormal + ';' + SSysDba + ';' + SSysOper;
        ADefVal := CSysNormal;
        ACaption := SMode;
        ALoginIndex := 3;
      end;
    1:
      begin
        AName := S_AD_ConnParam_Oracl_Autocommit;
        AType := '@L';
        ADefVal := S_AD_True;
        ACaption := AName;
      end;
    2:
      begin
        AName := S_AD_ConnParam_Common_TransIsolation;
        AType := S_AD_DirtyRead + ';' + S_AD_ReadCommitted + ';' +
          S_AD_RepeatRead + ';' + S_AD_Serializible;
        ADefVal := S_AD_ReadCommitted;
        ACaption := AName;
      end;
{    4:
      begin
        AName := S_AD_ConnParam_Oracl_Distributed;
        AType := '@L';
        ADefVal := S_AD_False;
      end;
    5:
      begin
        AName := S_AD_ConnParam_Oracl_SrvIntName;
        AType := '@S';
        ADefVal := '';
      end;
}
    3:
      begin
        AName := S_AD_ConnParam_Oracl_PieceSize;
        AType := '@I';
        ADefVal := IntToStr(IDefPieceBuffLen);
        ACaption := AName;
      end;
    4:
      begin
        AName := S_AD_ConnParam_Oracl_BoolValues;
        AType := '@S';
        ADefVal := S_AD_DefBoolValues;
        ACaption := AName;
      end;
    5:
      begin
        AName := S_AD_ConnParam_Oracl_SQL_TRACE;
        AType := '@L';
        ADefVal := '';
        ACaption := AName;
      end;
    6:
      begin
        AName := S_AD_ConnParam_Oracl_OPTIMIZER_GOAL;
        AType := 'ALL_ROWS;FIRST_ROWS;RULE;CHOOSE';
        ADefVal := '';
        ACaption := AName;
      end;
    7:
      begin
        AName := S_AD_ConnParam_Oracl_HASH_JOIN_ENABLED;
        AType := '@L';
        ADefVal := '';
        ACaption := AName;
      end;
    8:
      begin
        AName := S_AD_ConnParam_Oracl_BytesPerChar;
        AType := '@I';
        ADefVal := '1';
        ACaption := AName;
      end;
    9:
      begin
        AName := S_AD_ConnParam_Common_MetaDefSchema;
        AType := '@S';
        ADefVal := '';
        ACaption := AName;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysOraclConnection                                                        }
{-------------------------------------------------------------------------------}
constructor TADPhysOraclConnection.Create(ADriverObj: TADPhysDriver;
  const ADriver: IADPhysDriver; AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, ADriver, AConnHost);
end;

{-------------------------------------------------------------------------------}
class function TADPhysOraclConnection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysOraclDriver;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysOraclCommand.Create;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysOraCommandGenerator.Create(ACommand)
  else
    Result := TADPhysOraCommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysOraMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF}
    Self, FServerVersion, TADPhysOraclDriver(DriverObj).FLib.FOCIVersion);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.ParseAliasConnStr(var AUsr, APwd, ASrv: String;
  var AAuthMode: ub4);
var
  s, sRest, sAuth: String;
  i1, i2, i3: Integer;
begin
  AUsr := '';
  APwd := '';
  ASrv := '';
  sAuth := '';
  sRest := GetConnectionDef.ExpandedDatabase;
  i1 := Pos('/', sRest);
  i2 := Pos('@', sRest);
  i3 := Pos(' AS ', UpperCase(sRest));
  if (i1 = 0) and (i2 = 0) and (i3 = 0) then
    ASrv := sRest
  else begin
    if i3 > 0 then
      Inc(i3);
    if (i3 <> 0) and
       ((i3 = 1) or (sRest[i3 - 1] = ' ')) and
       ((i3 + 2 > Length(sRest)) or (sRest[i3 + 2] = ' ')) then begin
      sAuth := Trim(Copy(sRest, i3 + 2, Length(sRest)));
      sRest := Copy(sRest, 1, i3 - 1);
    end;
    if i2 <> 0 then begin
      ASrv := Trim(Copy(sRest, i2 + 1, Length(sRest)));
      sRest := Copy(sRest, 1, i2 - 1);
    end;
    if i1 <> 0 then begin
      APwd := Trim(Copy(sRest, i1 + 1, Length(sRest)));
      sRest := Copy(sRest, 1, i1 - 1);
    end;
    AUsr := Trim(Copy(sRest, 1, Length(sRest)));
  end;
  s := GetConnectionDef.UserName;
  if s <> '' then
    AUsr := s;
  s := GetConnectionDef.Password;
  if s <> '' then
    APwd := s;
  if CompareText(ASrv, S_AD_Local) = 0 then
    ASrv := '';
  s := GetConnectionDef.AsString[S_AD_ConnParam_Oracl_AuthMode];
  if s <> '' then
    sAuth := s;
  if CompareText(sAuth, SSysDba) = 0 then
    AAuthMode := OCI_SYSDBA
  else if CompareText(sAuth, SSysOper) = 0 then
    AAuthMode := OCI_SYSOPER
  else
    AAuthMode := OCI_DEFAULT;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.ParseAliasOther;
begin
//  if GetConnectionDef.AsBoolean[S_AD_ConnParam_Oracl_Distributed] and
//     GetConnectionDef.HasValue(S_AD_ConnParam_Oracl_SrvIntName) then
//    FServer.INTERNAL_NAME := GetConnectionDef.AsString[S_AD_ConnParam_Oracl_SrvIntName];
  if GetConnectionDef.HasValue(S_AD_ConnParam_Oracl_Autocommit) then
    GetTxOptions.AutoCommit := GetConnectionDef.AsBoolean[S_AD_ConnParam_Oracl_Autocommit];
  if GetConnectionDef.HasValue(S_AD_ConnParam_Common_TransIsolation) then
    GetTxOptions.SetIsolationAsStr(GetConnectionDef.AsString[S_AD_ConnParam_Common_TransIsolation]);
  if GetConnectionDef.HasValue(S_AD_ConnParam_Oracl_PieceSize) then
    FPieceBuffLen := GetConnectionDef.AsInteger[S_AD_ConnParam_Oracl_PieceSize]
  else
    FPieceBuffLen := IDefPieceBuffLen;
  if GetConnectionDef.HasValue(S_AD_ConnParam_Oracl_BoolValues) then
    FBooleanValues := GetConnectionDef.AsString[S_AD_ConnParam_Oracl_BoolValues]
  else
    FBooleanValues := S_AD_DefBoolValues;
  if GetConnectionDef.HasValue(S_AD_ConnParam_Oracl_BytesPerChar) then
    FService.BytesPerChar := ub1(GetConnectionDef.AsInteger[S_AD_ConnParam_Oracl_BytesPerChar]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.GetServerInfo;
var
  oStmt: TOCIStatement;
  oVar1, oVar2, oVar3, oVar4: TOCIVariable;
  pBuff: pUb1;
  uiSize: ub4;
  i, iFrom: Integer;
  s: String;
{$IFDEF AnyDAC_MONITOR}
  sName, sVal: String;
{$ENDIF}
begin
  FUseDBAViews := False;
  FServerVersion := cvOracle90000;
  FDecimalSep := DecimalSeparator;
{$IFDEF AnyDAC_MONITOR}
  FNLSParams := nil;
{$ENDIF}
  try
    oStmt := TOCIStatement.Create(FEnv, FService, Self);
    oVar1 := nil;
    oVar2 := nil;
    oVar3 := nil;
    oVar4 := nil;
    try
      oStmt.Prepare(
        'BEGIN ' +
          'SELECT COUNT(*) INTO :PRV FROM SESSION_PRIVS WHERE PRIVILEGE = ''SELECT ANY TABLE'' OR PRIVILEGE = ''SELECT ANY DICTIONARY''; ' +
          'SELECT BANNER INTO :VER FROM V$VERSION WHERE ROWNUM = 1; ' +
          'SELECT VALUE INTO :NUM FROM V$NLS_PARAMETERS WHERE PARAMETER = ''NLS_NUMERIC_CHARACTERS''; ' +
          'SELECT GREATEST(LENGTH(CHR(2000000000)), LENGTH(CHR(2000000)), LENGTH(CHR(20000))) INTO :BTS FROM DUAL; ' +
        'END;'
      );
      oVar1 := oStmt.AddVar(':PRV', odOut, otInteger, 0);
      oVar2 := oStmt.AddVar(':VER', odOut, otString, 64);
      oVar3 := oStmt.AddVar(':NUM', odOut, otString, 64);
      oVar4 := oStmt.AddVar(':BTS', odOut, otInteger, 0);
      oStmt.Execute(1, 0, False, True);
      // select any privilege
      pBuff := nil;
      uiSize := 0;
      oVar1.GetDataPtr(0, pBuff, uiSize, dfDataSet);
      FUseDBAViews := (PInteger(pBuff)^ = 2);
      // server version
      pBuff := nil;
      uiSize := 0;
      oVar2.GetDataPtr(0, pBuff, uiSize, dfDataSet);
      SetString(s, PChar(pBuff), uiSize);
      s := AnsiUpperCase(FServer.ServerVersion);
      i := Pos('RELEASE', s);
      if i <> 0 then begin
        Inc(i, 7);
        while (s[i] = ' ') do
          Inc(i);
        iFrom := i;
        while s[i] in ['0'..'9', '.'] do
          Inc(i);
        FServerVersion := ADVerStr2Int(Copy(s, iFrom, i - iFrom));
      end;
      // decimal separator
      pBuff := nil;
      uiSize := 0;
      oVar3.GetDataPtr(0, pBuff, uiSize, dfDataSet);
      if uiSize > 0 then
        FDecimalSep := PChar(pBuff)^;
      // bytes per character
      pBuff := nil;
      uiSize := 0;
      oVar4.GetDataPtr(0, pBuff, uiSize, dfDataSet);
      FService.BytesPerChar := ub1(PInteger(pBuff)^);
    finally
      oVar1.Free;
      oVar2.Free;
      oVar3.Free;
      oVar4.Free;
      oStmt.Free;
    end;
{$IFDEF AnyDAC_MONITOR}
    oStmt := TOCIStatement.Create(FEnv, FService, Self);
    oVar1 := nil;
    oVar2 := nil;
    FNLSParams := TStringList.Create;
    try
      try
        oStmt.Prepare('SELECT * FROM V$NLS_PARAMETERS');
        oVar1 := oStmt.AddVar(1, odDefine, otString, 100);
        oVar2 := oStmt.AddVar(2, odDefine, otString, 100);
        oStmt.Execute(1, 0, False, True);
        while not oStmt.Eof do begin
          oVar1.GetDataPtr(0, pBuff, uiSize, dfDataSet);
          SetString(sName, PChar(pBuff), uiSize);
          oVar2.GetDataPtr(0, pBuff, uiSize, dfDataSet);
          SetString(sVal, PChar(pBuff), uiSize);
          FNLSParams.Add(sName + '=' + sVal);
          oStmt.Fetch(1);
        end;
      except
        // no exceptions visible
      end;
    finally
      oVar1.Free;
      oVar2.Free;
      oStmt.Free;
    end;
{$ENDIF}
  except
    on E: EOCINativeException do
      // If we are connecting to not open database, then
      // where will be no dictionary
      if (E.ErrorCount > 0) and (E.Errors[0].ErrorCode = 1219) then
        with GetOptions.FetchOptions do
          Items := Items - [fiMeta]
      else
        raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.AlterSession;
var
  sCmd: String;
  oStmt: TOCIStatement;
begin
  sCmd := '';
  if GetConnectionDef.HasValue(S_AD_ConnParam_Oracl_SQL_TRACE) then
    sCmd := sCmd + ' SQL_TRACE = ' +
      GetConnectionDef.AsString[S_AD_ConnParam_Oracl_SQL_TRACE];
  if GetConnectionDef.HasValue(S_AD_ConnParam_Oracl_OPTIMIZER_GOAL) then
    sCmd := sCmd + ' OPTIMIZER_GOAL = ' +
      GetConnectionDef.AsString[S_AD_ConnParam_Oracl_OPTIMIZER_GOAL];
  if GetConnectionDef.HasValue(S_AD_ConnParam_Oracl_HASH_JOIN_ENABLED) then
    sCmd := sCmd + ' HASH_JOIN_ENABLED = ' +
      GetConnectionDef.AsString[S_AD_ConnParam_Oracl_HASH_JOIN_ENABLED];
  if sCmd <> '' then begin
    oStmt := TOCIStatement.Create(FEnv, FService, Self);
    try
      oStmt.Prepare('ALTER SESSION' + sCmd);
      oStmt.Execute(1, 0, False, True);
    finally
      oStmt.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.InternalConnect;
var
  iAuthMode: ub4;
  sUsr, sPwd, sSrv: String;
{$IFDEF AnyDAC_MONITOR}
  oMon: IADMoniClient;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then
    oMon := GetMonitor
  else
    oMon := nil;
{$ENDIF}
  try
    FMode := OCI_THREADED or OCI_OBJECT;
    FEnv := TOCIEnv.Create(TADPhysOraclDriver(DriverObj).FLib, FMode,
      {$IFDEF AnyDAC_MONITOR} oMon, {$ENDIF} Self);
    FService := TOCIService.Create(FEnv, Self);
    FService.NONBLOCKING_MODE := False;
    FServer := TOCIServer.Create(FService);
    FSession := TOCISession.Create(FService);
    sUsr := '';
    sPwd := '';
    sSrv := '';
    iAuthMode := 0;
    ParseAliasConnStr(sUsr, sPwd, sSrv, iAuthMode);
    FServer.Attach(sSrv);
    ParseAliasOther;
    if GetConnectionDef.NewPassword <> '' then begin
      FSession.Select;
      FSession.ChangePassword(sUsr, sPwd, GetConnectionDef.NewPassword);
      sPwd := GetConnectionDef.NewPassword;
    end;
    FSession.Start(sUsr, sPwd, iAuthMode);
    FTransaction := TOCITransaction.Create(FService);
    FTransaction.Select;
    GetServerInfo;
    AlterSession;
  except
    InternalDisconnect;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.InternalDisconnect;
begin
{$IFDEF AnyDAC_MONITOR}
  FreeAndNil(FNLSParams);
{$ENDIF}
  FreeAndNil(FSession);
  FreeAndNil(FServer);
  FreeAndNil(FTransaction);
  FreeAndNil(FService);
  FreeAndNil(FEnv);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.InternalTxBegin(ATxID: LongWord);
const
  ntisol2oci: array[TADTxIsolation] of TOCITransactionMode = (
    tmReadWrite, tmReadWrite, tmReadOnly, tmSerializable);
begin
  FTransaction.StartLocal(ntisol2oci[GetTxOptions.Isolation]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.InternalTxCommit(ATxID: LongWord);
begin
  FTransaction.Commit;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.InternalTxRollback(ATxID: LongWord);
begin
  FTransaction.RollBack;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.DirectExec(const ASQL: String);
var
  oStmt: TOCIStatement;
begin
  oStmt := TOCIStatement.Create(FEnv, FService, Self);
  try
    oStmt.Prepare(ASQL);
    oStmt.Execute(1, 0, False, False);
  finally
    oStmt.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.InternalTxRollbackToSavepoint(const AName: String);
begin
  DirectExec('ROLLBACK TO SAVEPOINT ' + AName);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.InternalTxSetSavepoint(const AName: String);
begin
  DirectExec('SAVEPOINT ' + AName);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclConnection.GetAutoCommit: Boolean;
begin
  Result := GetTxOptions.AutoCommit and not GetTxIsActive;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.InternalChangePassword(const AUserName, AOldPassword,
  ANewPassword: String);
begin
  FSession.ChangePassword(FSession.USERNAME, FSession.PASSWORD, ANewPassword);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclConnection.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  Inc(Result, 4);
  if FSession <> nil then begin
    Inc(Result, 3);
{$IFDEF AnyDAC_MONITOR}
    if FNLSParams <> nil then
      Inc(Result, FNLSParams.Count);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.GetItem(AIndex: Integer; var AName: String;
  var AValue: Variant; var AKind: TADDebugMonitorAdapterItemKind);
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'Home';
        if TADPhysOraclDriver(DriverObj).FLib.FOCIInstantClient then
          AValue := '<instant client at> ' + TADPhysOraclDriver(DriverObj).FLib.FOCIOracleHome
        else
          AValue := TADPhysOraclDriver(DriverObj).FLib.FOCIOracleHome;
        AKind := ikClientInfo;
      end;
    1:
      begin
        AName := 'Version';
        AValue := TADPhysOraclDriver(DriverObj).FLib.FOCIVersion;
        AKind := ikClientInfo;
      end;
    2:
      begin
        AName := 'OCI DLL name';
        AValue := TADPhysOraclDriver(DriverObj).FLib.FOCIDllName;
        AKind := ikClientInfo;
      end;
    3:
      begin
        AName := 'TNSNAMES dir';
        AValue := TADPhysOraclDriver(DriverObj).FLib.FOCITnsNames;
        AKind := ikClientInfo;
      end;
    4:
      begin
        AName := 'Server ver';
        AValue := FServer.ServerVersion;
        AKind := ikSessionInfo;
      end;
    5:
      begin
        AName := 'Use DBA views';
        AValue := FUseDBAViews;
        AKind := ikSessionInfo;
      end;
    6:
      begin
        AName := 'Decimal sep';
        AValue := FDecimalSep;
        AKind := ikSessionInfo;
      end;
    else
{$IFDEF AnyDAC_MONITOR}
      if FNLSParams <> nil then begin
        AName := FNLSParams.Names[AIndex - inherited GetItemCount - 7];
        AValue := FNLSParams.Values[AName];
        AKind := ikSessionInfo;
      end;
{$ENDIF}      
    end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysOraclConnection.GetMessages: EADDBEngineException;
begin
  Result := FEnv.Error.Info;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclConnection.GetCliObj: TObject;
begin
  Result := FService;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.UpdateServerOutput;
var
  oStmt: TOCIStatement;
  oVar: TOCIVariable;
  iSize: Integer;
begin
  with GetResourceOptions as TADTopResourceOptions do begin
    if not ((FLastServerOutput <> ServerOutput) or
            ServerOutput and (FLastServerOutputSize <> ServerOutputSize)) then
      Exit;
    oVar := nil;
    oStmt := TOCIStatement.Create(FEnv, FService, Self);
    try
      if ServerOutput then begin
        oStmt.Prepare('BEGIN DBMS_OUTPUT.ENABLE(:SIZE); END;');
        oVar := oStmt.AddVar(':SIZE', odIn, otInteger, 0);
        iSize := ServerOutputSize;
        oVar.SetData(0, @iSize, 0, dfOCI);
      end
      else
        oStmt.Prepare('BEGIN DBMS_OUTPUT.DISABLE; END;');
      oStmt.Execute(1, 0, False, GetAutoCommit());
      FLastServerOutput := ServerOutput;
      FLastServerOutputSize := ServerOutputSize;
    finally
      oStmt.Free;
      oVar.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclConnection.GetServerOutput;
var
  oStmt: TOCIStatement;
  oVar1: TOCIVariable;
  oVar2: TOCIVariable;
  pLine: pUb1;
  uiSize: ub4;
  sLine: String;
  iStatus: Integer;
begin
  if not (GetResourceOptions as TADTopResourceOptions).ServerOutput then
    Exit;
  oVar1 := nil;
  oVar2 := nil;
  oStmt := TOCIStatement.Create(FEnv, FService, Self);
  try
    oStmt.Prepare('BEGIN DBMS_OUTPUT.GET_LINE(:LINE, :STATUS); END;');
    oVar1 := oStmt.AddVar(':LINE', odOut, otString, 256);
    oVar2 := oStmt.AddVar(':STATUS', odOut, otInteger, 0);
    repeat
      oStmt.Execute(1, 0, False, GetAutoCommit());
      oVar2.GetData(0, @iStatus, uiSize, dfDataSet);
      if iStatus = 0 then begin
        oVar1.GetDataPtr(0, pLine, uiSize, dfDataSet);
        SetString(sLine, PChar(pLine), uiSize);
        FEnv.Error.Info.Append(TADDBError.Create(0, 0, sLine, '', ekServerOutput, 0));
      end;
    until iStatus = 1;
  finally
    oStmt.Free;
    oVar1.Free;
    oVar2.Free;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysOraclCommand                                                           }
{-------------------------------------------------------------------------------}
constructor TADPhysOraclCommand.Create;
begin
  inherited Create;
  FParInfos := TList.Create;
  FInfoStack := TList.Create;
  FCrsInfos := TList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysOraclCommand.Destroy;
begin
  Disconnect;
  FreeAndNil(FParInfos);
  FreeAndNil(FInfoStack);
  FreeAndNil(FCrsInfos);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.DefParInfos(const ANm: String; AVt: TOCIVarType;
  ADt: TOCIVarDataType; ASz, APrec, AScale: sb4; AIsTable, AIsResult: Boolean);
var
  eSrcType, eDestType: TADDataType;
  eDestFldType: TFieldType;
  iSize: LongWord;
  iPrec: Integer;
begin
  if fiMeta in GetFetchOptions.Items then begin
    with GetParams.Add do
      try
        Name := ANm;
        if AIsResult then
          ParamType := ptResult
        else
          ParamType := vt2pt[AVt];
        with GetFormatOptions do begin
          eSrcType := ovdt2addt[ADt];
          if (eSrcType = dtFmtBCD) and
             (APrec <= MaxBcdPrecision) and (AScale <= MaxBcdScale) then
            eSrcType := dtBCD;
          eDestType := dtUnknown;
          ResolveDataType(eSrcType, ASz, APrec, AScale, eDestType, True);
          eDestFldType := ftUnknown;
          iSize := 0;
          iPrec := 0;
          ColumnDef2FieldDef(eDestType, AScale, APrec, ASz, [], eDestFldType, iSize, iPrec);
        end;
        DataType := eDestFldType;
        ADDataType := eDestType;
        if iSize <> 0 then
          Size := iSize;
        if iPrec <> 0 then
          Precision := iPrec;
        if AIsTable then
          ArrayType := atPLSQLTable
        else
          ArrayType := atScalar;
      except
        Free;
        raise;
      end;
    if (GetCommandKind = skStoredProc) and (ADt in [otCursor, otNestedDataSet]) then
      SetCommandKind(skStoredProcWithCrs);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.GenerateSPSQLFromDB: String;
var
  sPackName, sProcName: String;
  oDescr: TOCIPLSQLDescriber;
  s: String;
  i: Integer;
begin
  GetParams.Clear;
  sProcName := TrimRight(GetCommandText);
  if GetBaseObjectName <> '' then begin
    if GetSchemaName <> '' then
      sPackName := GetSchemaName + '.' + GetBaseObjectName
    else
      sPackName := GetBaseObjectName;
  end
  else begin
    sPackName := '';
    if GetSchemaName <> '' then
      sProcName := GetSchemaName + '.' + sProcName
  end;
  oDescr := TOCIPLSQLDescriber.CreateForProc(TADPhysOraclConnection(FConnectionObj).FService,
    sPackName, sProcName, GetOverload, Self);
  try
    s := TADPhysOraclConnection(FConnectionObj).FBooleanValues;
    i := Pos(';', s);
    if i <> 0 then begin
      oDescr.BoolFalse := Copy(s, 1, i - 1);
      oDescr.BoolTrue := Copy(s, i + 1, Length(s));
      if s[1] = '''' then begin
        oDescr.BoolType := otString;
        if Length(oDescr.BoolFalse) < Length(oDescr.BoolTrue) then
          oDescr.BoolSize := Length(oDescr.BoolTrue) - 2
        else
          oDescr.BoolSize := Length(oDescr.BoolFalse) - 2;
      end
      else
        oDescr.BoolType := otInteger;
    end;
    oDescr.Describe;
    oDescr.LocateProc;
    Result := oDescr.BuildSQL(DefParInfos);
  finally
    oDescr.Free;
  end;
  if GetCommandKind = skStoredProc then
    SetCommandKind(skStoredProcNoCrs);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.GenerateSPSQLFromParams: String;
var
  i: Integer;
  oParams: TADParams;
  oParam: TADParam;
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
  lWasParam: Boolean;

  function BuildParamStr(AParam: TADParam): String;
  begin
    if (GetParamBindMode = pbByName) and (AParam.ParamType <> ptResult) then
      if AParam.IsCaseSensitive then
        Result := '"' + AParam.Name + '" => '
      else
        Result := AParam.Name + ' => ';
    if AParam.IsCaseSensitive then
      Result := Result + ':"' + AParam.Name + '"'
    else
      Result := Result + ':' + AParam.Name;
  end;

begin
  oParams := GetParams;
  Result := 'BEGIN ';
  for i := 0 to oParams.Count - 1 do
    if oParams[i].ParamType = ptResult then begin
      Result := Result + BuildParamStr(oParams[i]) + ' ::= ';
      Break;
    end;

  GetConnection.CreateMetadata(oConnMeta);
  rName.FSchema := GetSchemaName;
  rName.FBaseObject := GetBaseObjectName;
  rName.FObject := TrimRight(GetCommandText);
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
      Result := Result + BuildParamStr(oParam);
    end;
  end;

  if lWasParam then
    Result := Result + ')';
  Result := Result + '; END;';
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.GenerateMetaInfoSQL: String;
var
  sKinds, sScope, sWildcard, sViewPrefix: String;
  sCharLen, sUniCharLen, sUniVarCharLen: String;
  sIndexName, sOwnerName, sToChar: String;
  sIndexName2, sOwnerName2, sToChar2: String;
  rName: TADPhysParsedName;
  lWasWhere: Boolean;
  oConnMeta: IADPhysConnectionMetadata;

  procedure AddWhere(const ACond: String);
  begin
    if lWasWhere then
      Result := Result + ' AND ' + ACond
    else begin
      Result := Result + ' WHERE ' + ACond;
      lWasWhere := True;
    end;
  end;

  procedure AddTopScope;
  begin
    if rName.FSchema <> '' then
      AddWhere('OWNER = ''' + rName.FSchema + '''')
    else if GetObjectScopes <> [osMy, osSystem, osOther] then begin
      sScope := '';
      if osMy in GetObjectScopes then
        sScope := sScope + 'OWNER = USER OR ';
      if osSystem in GetObjectScopes then
        sScope := sScope + 'OWNER IN (''SYS'', ''SYSTEM'') OR ';
      if osOther in GetObjectScopes then
        sScope := sScope + 'OWNER NOT IN (''SYS'', ''SYSTEM'', USER) OR ';
      if sScope <> '' then
        AddWhere('(' + Copy(sScope, 1, Length(sScope) - 4) + ')');
    end;
  end;

  function EncodeDataType(const AFieldName: String): String;

    function DT2Str(AType: TADDataType): String;
    begin
      Result := IntToStr(Integer(AType));
    end;

  begin
    Result := 'DECODE(' + AFieldName + ', ' +
      '''CHAR'', ' + DT2Str(dtAnsiString) + ', ' +
      '''VARCHAR'', ' + DT2Str(dtAnsiString) + ', ' +
      '''VARCHAR2'', ' + DT2Str(dtAnsiString) + ', ' +
      '''NCHAR'', ' + DT2Str(dtWideString) + ', ' +
      '''NCHAR VARYING'', ' + DT2Str(dtWideString) + ', ' +
      '''NVARCHAR2'', ' + DT2Str(dtWideString) + ', ' +
      '''NUMBER'', ' + DT2Str(dtFmtBCD) + ', ' +
      '''FLOAT'', ' + DT2Str(dtDouble) + ', ' +
      '''DATE'', ' + DT2Str({$IFDEF AnyDAC_D6Base} dtDateTimeStamp {$ELSE} dtDateTime {$ENDIF}) + ', ' +
      '''RAW'', ' + DT2Str(dtByteString) + ', ' +
      '''LONG'', ' + DT2Str(dtMemo) + ', ' +
      '''LONG RAW'', ' + DT2Str(dtBlob) + ', ' +
      '''ROWID'', ' + DT2Str(dtAnsiString) + ', ' +
      '''UROWID'', ' + DT2Str(dtAnsiString) + ', ' +
      '''NCLOB'', ' + DT2Str(dtWideHMemo) + ', ' +
      '''CLOB'', ' + DT2Str(dtHMemo) + ', ' +
      '''BLOB'', ' + DT2Str(dtHBlob) + ', ' +
      '''BFILE'', ' + DT2Str(dtHBFile) + ', ' +
      '''CFILE'', ' + DT2Str(dtHBFile) + ', ' +
      '''NATIVE INTEGER'', ' + DT2Str(dtInt32) + ', ' +
      '''BINARY_INTEGER'', ' + DT2Str(dtInt32) + ', ' +
      '''REF CURSOR'', ' + DT2Str(dtCursorRef) + ', ' +
      '''PL/SQL BOOLEAN'', ' + DT2Str(dtBoolean) + ', ' +
      DT2Str(dtUnknown) + ')';
  end;

  function EncodeAttrs(const ATypeFieldName, ANullableFieldName,
    ADefaultLengthFieldName: String): String;

    function Attrs2Str(AAtrs: TADDataAttributes): String;
    begin
      Result := IntToStr(PWord(@AAtrs)^);
    end;

  begin
    Result := 'DECODE(' + ATypeFieldName + ', ' +
      '''CHAR'', ' + Attrs2Str([caFixedLen, caSearchable]) + ', ' +
      '''VARCHAR'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''VARCHAR2'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''NCHAR'', ' + Attrs2Str([caFixedLen, caSearchable]) + ', ' +
      '''NCHAR VARYING'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''NVARCHAR2'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''NUMBER'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''FLOAT'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''DATE'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''RAW'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''LONG'', ' + Attrs2Str([caBlobData]) + ', ' +
      '''LONG RAW'', ' + Attrs2Str([caBlobData]) + ', ' +
      '''ROWID'', ' + Attrs2Str([caAllowNull, caFixedLen, caSearchable, caROWID]) + ', ' +
      '''UROWID'', ' + Attrs2Str([caAllowNull, caSearchable, caROWID]) + ', ' +
      '''NCLOB'', ' + Attrs2Str([caBlobData]) + ', ' +
      '''CLOB'', ' + Attrs2Str([caBlobData]) + ', ' +
      '''BLOB'', ' + Attrs2Str([caBlobData]) + ', ' +
      '''BFILE'', ' + Attrs2Str([caBlobData, caVolatile]) + ', ' +
      '''CFILE'', ' + Attrs2Str([caBlobData, caVolatile]) + ', ' +
      '''NATIVE INTEGER'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''BINARY_INTEGER'', ' + Attrs2Str([caSearchable]) + ', ' +
      '''REF CURSOR'', ' + Attrs2Str([caAllowNull]) + ', ' +
      '''PL/SQL BOOLEAN'', ' + Attrs2Str([]) + ', ' +
      Attrs2Str([]) + ') + ';
    if ANullableFieldName <> '' then
      Result := Result + 'DECODE(' + ANullableFieldName +
        ', ''Y'', ' + Attrs2Str([caAllowNull]) + ', ' + Attrs2Str([]) + ')'
    else
      Result := Result + Attrs2Str([caAllowNull]);
    if ADefaultLengthFieldName <> '' then
      Result := Result + ' + DECODE(' + ADefaultLengthFieldName + ', NULL, ' +
        Attrs2Str([]) + ', ' + Attrs2Str([caDefault]) + ')';
  end;

  function EncodeScope(const AOwnerFieldName: String): String;
  begin
    Result := 'DECODE(' + AOwnerFieldName + ', ' +
      'USER, ' +       IntToStr(Integer(osMy)) + ', ' +
      '''SYS'', ' +    IntToStr(Integer(osSystem)) + ', ' +
      '''SYSTEM'', ' + IntToStr(Integer(osSystem)) + ', ' +
                       IntToStr(Integer(osOther)) + ')';
  end;

  procedure GetLengthExpressions(var ACharLen, AUniCharLen, AUniVarCharLen: String);
  begin
    if TADPhysOraclConnection(FConnectionObj).FServerVersion >= cvOracle90000 then begin
      ACharLen := 'CHAR_LENGTH';
      AUniCharLen := 'CHAR_LENGTH';
      AUniVarCharLen := 'CHAR_LENGTH';
    end
    else begin
      ACharLen := 'DATA_LENGTH';
      AUniCharLen := 'DATA_LENGTH';
      AUniVarCharLen := AUniCharLen;
    end;
  end;

  procedure GetIndexExpressions(var AIndexName, AOwnerName, AToChar: String;
    const AAlias: String);
  begin
    if TADPhysOraclConnection(FConnectionObj).FServerVersion >= cvOracle90000 then begin
      AIndexName := AAlias + '.INDEX_NAME';
      AOwnerName := 'NVL(' + AAlias + '.INDEX_OWNER, ' + AAlias + '.OWNER)';
      AToChar := 'TO_CHAR(';
    end
    else begin
      AIndexName := AAlias + '.CONSTRAINT_NAME';
      AOwnerName := AAlias + '.OWNER';
      AToChar := '(';
    end;
  end;

begin
  FConnection.CreateMetadata(oConnMeta);
  oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self, [doNormalize, doUnquote]);
  CheckMetaInfoParams(rName);
  if TADPhysOraclConnection(FConnectionObj).FUseDBAViews then
    sViewPrefix := 'SYS.DBA'
  else
    sViewPrefix := 'SYS.ALL';
  lWasWhere := False;
  sWildCard := GetWildcard;
  case GetMetaInfoKind of
  mkTables:
    begin
      sKinds := '';
      if tkTable in GetTableKinds then
        sKinds := sKinds + '''TABLE'', ';
      if tkView in GetTableKinds then
        sKinds := sKinds + '''VIEW'', ''MATERIALIZED VIEW'', ';
      if tkSynonym in GetTableKinds then
        sKinds := sKinds + '''SYNONYM'', ';
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        'OWNER AS SCHEMA_NAME, OBJECT_NAME AS TABLE_NAME, ' +
        'DECODE(TEMPORARY, ' +
            '''Y'', ' +       InttoStr(Integer(tkTempTable)) + ', ' +
          'DECODE(OBJECT_TYPE, ' +
            '''TABLE'', ' +   IntToStr(Integer(tkTable)) + ', ' +
            '''SYNONYM'', ' + IntToStr(Integer(tkSynonym)) + ', ' +
                              IntToStr(Integer(tkView)) + ')) AS TABLE_TYPE, ' +
        EncodeScope('OWNER') + ' AS TABLE_SCOPE ' +
        'FROM ' + sViewPrefix + '_OBJECTS';
      if sKinds <> '' then
        AddWhere('OBJECT_TYPE IN (' + Copy(sKinds, 1, Length(sKinds) - 2) + ')');
      if sWildcard <> '' then
        AddWhere('OBJECT_NAME LIKE ''' + sWildcard + '''');
      AddTopScope;
      if TADPhysOraclConnection(FConnectionObj).FServerVersion >= cvOracle81500 then
        if not (tkTempTable in GetTableKinds) then
          AddWhere('TEMPORARY = ''N''');
      Result := Result + ' ORDER BY 3, 4';
    end;
  mkTableFields:
    begin
      sCharLen := '';
      sUniCharLen := '';
      sUniVarCharLen := '';
      GetLengthExpressions(sCharLen, sUniCharLen, sUniVarCharLen);
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        'OWNER AS SCHEMA_NAME, TABLE_NAME, COLUMN_NAME, ' +
        'COLUMN_ID AS COLUMN_POSITION, ' +
        EncodeDataType('DATA_TYPE') + ' AS COLUMN_DATATYPE, ' +
        'DECODE(DATA_TYPE_OWNER, NULL, DATA_TYPE, ''"'' || DATA_TYPE_OWNER || ''"."'' || DATA_TYPE || ''"'') AS COLUMN_TYPENAME, ' +
        EncodeAttrs('DATA_TYPE', 'NULLABLE', 'DEFAULT_LENGTH') + ' AS COLUMN_ATTRIBUTES, ' +
        'LEAST(DATA_PRECISION, 38) AS COLUMN_PRECISION, GREATEST(DATA_SCALE, 0) AS COLUMN_SCALE, ' +
        'DECODE(DATA_TYPE, ''CHAR'', ' + sCharLen + ', ''VARCHAR'', ' + sCharLen + ', ' +
                          '''VARCHAR2'', ' + sCharLen + ', ''NCHAR'', ' + sUniCharLen + ', ' +
                          '''NCHAR VARYING'', ' + sUniVarCharLen + ', ''NVARCHAR2'', ' + sUniVarCharLen + ', ' +
                          '''RAW'', DATA_LENGTH, ''ROWID'', 18, NULL) AS COLUMN_LENGTH ' +
        'FROM ' + sViewPrefix + '_TAB_COLUMNS ' +
        'WHERE OWNER = ';
      if rName.FSchema <> '' then
        Result := Result + '''' + rName.FSchema + ''''
      else
        Result := Result + 'USER';
      Result := Result + ' AND TABLE_NAME = ''' + rName.FObject + '''';
      if sWildcard <> '' then
        Result := Result + ' AND COLUMN_NAME LIKE ''' + sWildcard + '''';
      Result := Result + ' ORDER BY 6';
    end;
  mkIndexes:
    begin
      sIndexName := '';
      sOwnerName := '';
      sToChar := '';
      GetIndexExpressions(sIndexName, sOwnerName, sToChar, 'C');
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        'I.OWNER AS SCHEMA_NAME, I.TABLE_NAME, I.INDEX_NAME, ';
      if TADPhysOraclConnection(FConnectionObj).FServerVersion >= cvOracle81000 then
        Result := Result + sToChar + '(' +
            'SELECT C.CONSTRAINT_NAME ' +
            'FROM ' + sViewPrefix + '_CONSTRAINTS C ' +
            'WHERE ' + sOwnerName + ' = I.OWNER AND ' + sIndexName + ' = I.INDEX_NAME' +
          ')) AS PKEY_NAME, ' +
          'DECODE(UNIQUENESS, ' +
            '''NONUNIQUE'', ' + IntToStr(Integer(ikNonUnique)) + ', ' +
            '''UNIQUE'', ' +
              'NVL((SELECT DECODE(CONSTRAINT_TYPE, ' +
                '''P'', ' + IntToStr(Integer(ikPrimaryKey)) + ', ' +
                            IntToStr(Integer(ikUnique)) + ') ' +
                'FROM ' + sViewPrefix + '_CONSTRAINTS C ' +
                'WHERE ' + sOwnerName + ' = I.OWNER AND ' + sIndexName + ' = I.INDEX_NAME' +
              '), ' + IntToStr(Integer(ikUnique)) +
          ')) INDEX_TYPE '
      else
        Result := Result +
          'C.CONSTRAINT_NAME AS PKEY_NAME, ' +
          'DECODE(I.UNIQUENESS, ' +
            '''NONUNIQUE'', ' + IntToStr(Integer(ikNonUnique)) + ', ' +
            '''UNIQUE'', ' +
              'NVL(DECODE(C.CONSTRAINT_TYPE, ' +
                '''P'', ' + IntToStr(Integer(ikPrimaryKey)) + ', ' +
                            IntToStr(Integer(ikUnique)) +
              '), ' + IntToStr(Integer(ikUnique)) +
          ')) INDEX_TYPE ';
      Result := Result +
        'FROM ' + sViewPrefix + '_INDEXES I';
      if TADPhysOraclConnection(FConnectionObj).FServerVersion < cvOracle81000 then
        Result := Result + ', ' + sViewPrefix + '_CONSTRAINTS C';
      Result := Result +
        ' WHERE I.TABLE_OWNER = ';
      if rName.FSchema <> '' then
        Result := Result + '''' + rName.FSchema + ''''
      else
        Result := Result + 'USER';
      Result := Result + ' AND I.TABLE_NAME = ''' + rName.FObject + '''';
      if TADPhysOraclConnection(FConnectionObj).FServerVersion < cvOracle81000 then
        Result := Result + ' AND I.OWNER = C.OWNER (+) AND I.INDEX_NAME = C.CONSTRAINT_NAME (+)';
      if sWildcard <> '' then
        Result := Result + ' AND I.INDEX_NAME LIKE ''' + sWildcard + '''';
      Result := Result +
        ' ORDER BY 7 DESC, 5 ASC';
    end;
  mkIndexFields:
    begin
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        'INDEX_OWNER AS SCHEMA_NAME, TABLE_NAME, INDEX_NAME, SUBSTR(COLUMN_NAME, 1, 30) AS COLUMN_NAME, ' +
        'COLUMN_POSITION, ';
      if TADPhysOraclConnection(FConnectionObj).FServerVersion >= cvOracle81500 then
        Result := Result + 'DECODE(DESCEND, ''ASC'', ''A'', ''D'') AS SORT_ORDER, '
      else
        Result := Result + '''A'' AS SORT_ORDER, ';
      Result := Result +
        'TO_CHAR(NULL) AS FILTER ' +
        'FROM ' + sViewPrefix + '_IND_COLUMNS ' +
        'WHERE TABLE_OWNER = ';
      if rName.FSchema <> '' then
        Result := Result + '''' + rName.FSchema + ''''
      else
        Result := Result + 'USER';
      Result := Result + ' AND TABLE_NAME = ''' + rName.FBaseObject + ''' ' +
        'AND INDEX_NAME = ''' + rName.FObject + '''';
      if sWildcard <> '' then
        Result := Result + ' AND COLUMN_NAME LIKE ''' + sWildcard + '''';
      Result := Result + ' ORDER BY 7';
    end;
  mkPrimaryKey:
    begin
      sIndexName := '';
      sOwnerName := '';
      sToChar := '';
      GetIndexExpressions(sIndexName, sOwnerName, sToChar, 'C');
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        sOwnerName + ' AS SCHEMA_NAME, C.TABLE_NAME, ' + sIndexName + ', C.CONSTRAINT_NAME AS PKEY_NAME, ' +
        IntToStr(Integer(ikPrimaryKey)) + ' AS INDEX_TYPE ' +
        'FROM ' + sViewPrefix + '_CONSTRAINTS C ' +
        'WHERE C.CONSTRAINT_TYPE = ''P'' AND ' + sOwnerName + ' = ';
      if rName.FSchema <> '' then
        Result := Result + '''' + rName.FSchema + ''''
      else
        Result := Result + 'USER';
      Result := Result + ' AND C.TABLE_NAME = ''' + rName.FObject + '''';
      if sWildcard <> '' then
        Result := Result + ' AND C.CONSTRAINT_NAME LIKE ''' + sWildcard + '''';
      Result := Result + ' ORDER BY 5';
    end;
  mkPrimaryKeyFields:
    begin
      sIndexName := '';
      sOwnerName := '';
      sToChar := '';
      GetIndexExpressions(sIndexName, sOwnerName, sToChar, 'C');
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        'INDEX_OWNER AS SCHEMA_NAME, TABLE_NAME, INDEX_NAME, SUBSTR(COLUMN_NAME, 1, 30) AS COLUMN_NAME, ' +
        'COLUMN_POSITION, ';
      if TADPhysOraclConnection(FConnectionObj).FServerVersion >= cvOracle81500 then
        Result := Result + 'DECODE(DESCEND, ''ASC'', ''A'', ''D'') AS SORT_ORDER, '
      else
        Result := Result + '''A'' AS SORT_ORDER, ';
      Result := Result +
        'TO_CHAR(NULL) AS FILTER ' +
        'FROM ' + sViewPrefix + '_IND_COLUMNS ' +
        'WHERE (INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME) = (' +
          'SELECT ' + sOwnerName + ', ' + sIndexName + ', ' + sOwnerName + ', C.TABLE_NAME ' +
          'FROM ' + sViewPrefix + '_CONSTRAINTS C ' +
          'WHERE C.CONSTRAINT_TYPE = ''P'' AND ' + sOwnerName + ' = ';
      if rName.FSchema <> '' then
        Result := Result + '''' + rName.FSchema + ''''
      else
        Result := Result + 'USER';
      Result := Result + ' AND C.TABLE_NAME = ''' + rName.FBaseObject + ''')';
      if sWildcard <> '' then
        Result := Result + ' AND COLUMN_NAME LIKE ''' + sWildcard + '''';
      Result := Result + '  ORDER BY 7';
    end;
  mkForeignKeys:
    begin
      sIndexName := '';
      sOwnerName := '';
      sToChar := '';
      GetIndexExpressions(sIndexName, sOwnerName, sToChar, 'C');
      sIndexName2 := '';
      sOwnerName2 := '';
      sToChar2 := '';
      GetIndexExpressions(sIndexName2, sOwnerName2, sToChar2, 'C2');
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        sOwnerName + ' AS SCHEMA_NAME, C.TABLE_NAME, C.CONSTRAINT_NAME AS FKEY_NAME, ' +
        'TO_CHAR(NULL) AS PKEY_CATALOG_NAME, ' + sOwnerName2 + ' AS PKEY_SCHEMA_NAME, ' +
        'C2.TABLE_NAME AS PKEY_TABLE_NAME, '+
        'DECODE(C.DELETE_RULE, ''CASCADE'', ' + IntToStr(Integer(ckCascade)) +
          ', ''SET NULL'', ' + IntToStr(Integer(ckSetNull)) + ', ' + IntToStr(Integer(ckNone)) +
          ') AS DELETE_RULE, 0 AS UPDATE_RULE ' +
        'FROM ' + sViewPrefix + '_CONSTRAINTS C, ' + sViewPrefix + '_CONSTRAINTS C2 ' +
        'WHERE C.R_OWNER = C2.OWNER AND C.R_CONSTRAINT_NAME = C2.CONSTRAINT_NAME AND ' +
          'C.CONSTRAINT_TYPE = ''R'' AND C.OWNER = ';
      if rName.FSchema <> '' then
        Result := Result + '''' + rName.FSchema + ''''
      else
        Result := Result + 'USER';
      Result := Result + ' AND C.TABLE_NAME = ''' + rName.FObject + '''';
      if sWildcard <> '' then
        Result := Result + ' AND C.CONSTRAINT_NAME LIKE ''' + sWildcard + '''';
      Result := Result + ' ORDER BY 5';
    end;
  mkForeignKeyFields:
    begin
      sIndexName := '';
      sOwnerName := '';
      sToChar := '';
      GetIndexExpressions(sIndexName, sOwnerName, sToChar, 'C');
      sIndexName2 := '';
      sOwnerName2 := '';
      sToChar2 := '';
      GetIndexExpressions(sIndexName2, sOwnerName2, sToChar2, 'C2');
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        sOwnerName + ' AS SCHEMA_NAME, C.TABLE_NAME, C.CONSTRAINT_NAME AS FKEY_NAME, '+
        'L.COLUMN_NAME, L2.COLUMN_NAME AS PKEY_COLUMN_NAME, NVL(L.POSITION, 1) AS COLUMN_POSITION ' +
        'FROM ' + sViewPrefix + '_CONSTRAINTS C, ' + sViewPrefix + '_CONSTRAINTS C2, ' +
          sViewPrefix + '_CONS_COLUMNS L, ' + sViewPrefix + '_CONS_COLUMNS L2 ' +
        'WHERE C.R_OWNER = C2.OWNER AND C.R_CONSTRAINT_NAME = C2.CONSTRAINT_NAME AND ' +
          'L.OWNER = C.OWNER AND L.TABLE_NAME = C.TABLE_NAME AND L.CONSTRAINT_NAME = C.CONSTRAINT_NAME AND ' +
          'L2.OWNER = C2.OWNER AND L2.TABLE_NAME = C2.TABLE_NAME AND L2.CONSTRAINT_NAME = C2.CONSTRAINT_NAME AND ' +
          'NVL(L.POSITION, 1) = NVL(L2.POSITION, 1) and C.CONSTRAINT_TYPE = ''R'' AND ' +
          sOwnerName + ' = ';
      if rName.FSchema <> '' then
        Result := Result + '''' + rName.FSchema + ''''
      else
        Result := Result + 'USER';
      Result := Result + ' AND C.TABLE_NAME = ''' + rName.FBaseObject + ''' AND ' +
        'C.CONSTRAINT_NAME = ''' + rName.FObject + '''';
      if sWildcard <> '' then
        Result := Result + ' AND C.COLUMN_NAME LIKE ''' + sWildcard + '''';
      Result := Result + ' ORDER BY 7';
    end;
  mkPackages:
    begin
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        'OWNER AS SCHEMA_NAME, OBJECT_NAME AS PACKAGE_NAME, ' +
        EncodeScope('OWNER') + ' AS PACKAGE_SCOPE ' +
        'FROM ' + sViewPrefix + '_OBJECTS ' +
        'WHERE OBJECT_TYPE = ''PACKAGE''';
      lWasWhere := True;
      AddTopScope;
      if sWildcard <> '' then
        Result := Result + ' AND OBJECT_NAME LIKE ''' + sWildcard + '''';
      Result := Result + ' ORDER BY 3, 4';
    end;
  mkProcs:
    begin
      if rName.FBaseObject = '' then begin
        Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
          'OWNER AS SCHEMA_NAME, TO_CHAR(NULL) AS PACK_NAME, OBJECT_NAME AS PROC_NAME, ' +
          'TO_NUMBER(NULL) AS OVERLOAD, DECODE(OBJECT_TYPE, ' +
            '''FUNCTION'', ' + IntToStr(Integer(pkFunction)) + ', ' +
            '''PROCEDURE'', ' + IntToStr(Integer(pkProcedure)) + ') AS PROC_TYPE, ' +
          EncodeScope('OWNER') + ' AS PROC_SCOPE, TO_NUMBER(NULL) AS IN_PARAMS, ' +
          'TO_NUMBER(NULL) AS OUT_PARAMS ' +
          'FROM ' + sViewPrefix + '_OBJECTS ' +
          'WHERE OBJECT_TYPE IN (''PROCEDURE'', ''FUNCTION'')';
        lWasWhere := True;
        AddTopScope;
        if sWildcard <> '' then
          Result := Result + ' AND OBJECT_NAME LIKE ''' + sWildcard + '''';
        Result := Result + ' ORDER BY 3, 5';
      end
      else begin
        Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, A.* ' +
          'FROM ( ' +
            'SELECT OWNER AS SCHEMA_NAME, PACKAGE_NAME AS PACK_NAME, OBJECT_NAME AS PROC_NAME, ' +
              'TO_NUMBER(OVERLOAD) AS OVERLOAD, DECODE(COUNT(DECODE(ARGUMENT_NAME, NULL, 1, NULL)), ' +
                '1, ' + IntToStr(Integer(pkFunction)) + ', ' +
                        IntToStr(Integer(pkProcedure)) + ') AS PROC_TYPE, ' +
              EncodeScope('OWNER') + ' AS PROC_SCOPE, ' +
              'COUNT(DECODE(IN_OUT, ''IN'', DECODE(DATA_TYPE, NULL, NULL, 1), ''IN/OUT'', 1, NULL)) AS IN_PARAMS, ' +
              'COUNT(DECODE(IN_OUT, ''OUT'', 1, ''IN/OUT'', 1, NULL)) AS OUT_PARAMS ' +
            'FROM ALL_ARGUMENTS ' +
            'WHERE PACKAGE_NAME = ''' + rName.FBaseObject + ''' AND OWNER = ';
        if rName.FSchema <> '' then
          Result := Result + '''' + rName.FSchema + ''''
        else
          Result := Result + 'USER';
        if sWildcard <> '' then
          Result := Result + ' AND OBJECT_NAME LIKE ''' + sWildcard + '''';
        Result := Result + ' AND DATA_LEVEL = 0 ' +
            ' GROUP BY OWNER, PACKAGE_NAME, OBJECT_NAME, OVERLOAD ' +
          ') A ORDER BY 3, 4, 5';
      end;
    end;
  mkProcArgs:
    begin
      sCharLen := '';
      sUniCharLen := '';
      sUniVarCharLen := '';
      GetLengthExpressions(sCharLen, sUniCharLen, sUniVarCharLen);
      Result := 'SELECT TO_NUMBER(NULL) AS RECNO, TO_CHAR(NULL) AS CATALOG_NAME, ' +
        'OWNER AS SCHEMA_NAME, PACKAGE_NAME AS PACK_NAME, ' +
        'OBJECT_NAME AS PROC_NAME, OVERLOAD, NVL(ARGUMENT_NAME, ''Result'') AS PARAM_NAME, ' +
        'POSITION AS PARAM_POSITION, ' +
        'DECODE(IN_OUT, ''IN'', 1, ''IN/OUT'', 3, ''OUT'', DECODE(ARGUMENT_NAME, NULL, 4, 2)) AS PARAM_TYPE, ' +
        EncodeDataType('DATA_TYPE') + ' AS PARAM_DATATYPE, ' +
        'DECODE(DATA_TYPE, ''UNDEFINED'', ''"'' || TYPE_OWNER || ''"."'' || TYPE_NAME || ' +
          'DECODE(TYPE_SUBNAME, NULL, '''', ''."'' || TYPE_SUBNAME || ''"''), DATA_TYPE) AS PARAM_TYPENAME, ' +
        EncodeAttrs('DATA_TYPE', '', '') + ' AS PARAM_ATTRIBUTES, ' +
        'LEAST(DATA_PRECISION, 38) AS PARAM_PRECISION, GREATEST(DATA_SCALE, 0) AS PARAM_SCALE, ' +
        'DECODE(DATA_TYPE, ''CHAR'', ' + sCharLen + ', ''VARCHAR'', ' + sCharLen + ', ' +
                          '''VARCHAR2'', ' + sCharLen + ', ''NCHAR'', ' + sUniCharLen + ', ' +
                          '''NCHAR VARYING'', ' + sUniVarCharLen + ', ''NVARCHAR2'', ' + sUniVarCharLen + ', ' +
                          '''RAW'', DATA_LENGTH, ''ROWID'', 18, NULL) AS PARAM_LENGTH ' +
        'FROM ALL_ARGUMENTS ' +
        'WHERE PACKAGE_NAME ';
      if rName.FBaseObject <> '' then
        Result := Result + '= ''' + rName.FBaseObject + ''''
      else
        Result := Result + 'IS NULL';
      Result := Result + ' AND OWNER = ';
      if rName.FSchema <> '' then
        Result := Result + '''' + rName.FSchema + ''''
      else
        Result := Result + 'USER';
      Result := Result + ' AND OBJECT_NAME = ''' + rName.FObject + '''';
      if sWildcard <> '' then
        Result := Result + ' AND ARGUMENT_NAME LIKE ''' + sWildcard + '''';
      if GetOverload <> 0 then
        Result := Result + ' AND OVERLOAD = ' + IntToStr(GetOverload)
      else
        Result := Result + ' AND OVERLOAD IS NULL';
      Result := Result + ' AND DATA_LEVEL = 0 AND DATA_TYPE IS NOT NULL ORDER BY 7';
    end;
  end;
  SetCommandKind(skSelect);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.ADType2OCIType(AType: TADDataType;
  AFixedLen: Boolean): TOCIVarDataType;
begin
  Result := addt2ovdt[AType];
  if AFixedLen then
    if Result = otString then
      Result := otChar
    else if Result = otNString then
      Result := otNChar;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.InitCrsData(ACrsInfo: PADOraCrsDataRec);
begin
  ADFillChar(ACrsInfo^, SizeOf(TADOraCrsDataRec), #0);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.CreateDefineInfo(ACrsInfo: PADOraCrsDataRec);
var
  i, iNChars: Integer;
  oSelItem: TOCISelectItem;
  pColInfo: PDEOraColInfoRec;
  oFmtOpts: TADFormatOptions;
  rName: TADPhysParsedName;
  oConnMeta: IADPhysConnectionMetadata;
  lMetadata: Boolean;
begin
  FConnection.CreateMetadata(oConnMeta);
  oFmtOpts := GetFormatOptions;
  lMetadata := GetMetaInfoKind <> daADPhysIntf.mkNone;

  with ACrsInfo^ do begin
    iNChars := 0;
    FHasFields := [];
    FColInfos := TList.Create;

    for i := 1 to FStmt.PARAM_COUNT do begin
      oSelItem := TOCISelectItem.Create(FStmt);
      try
        oSelItem.Position := i;
        oSelItem.Bind;
        New(pColInfo);
        pColInfo^.FCrsInfo := nil;
        pColInfo^.FVar := nil;
        FColInfos.Add(pColInfo);

        with pColInfo^ do begin
          FCrsInfo := nil;
          FName := oSelItem.NAME;
          FPos := i;
          FVarType := odDefine;
          FOSrcType := oSelItem.DataType;
          if lMetadata then
            case FOSrcType of
            otNChar:   FOSrcType := otChar;
            otNString: FOSrcType := otString;
            otNLong:   FOSrcType := otLong;
            end;
          FSrcType := ovdt2addt[FOSrcType];
          FPrec := oSelItem.DataPrecision;
          FScale := oSelItem.DataScale;
          if (FSrcType = dtFmtBCD) and
             (FPrec <= LongWord(oFmtOpts.MaxBcdPrecision)) and
             (FScale <= LongWord(oFmtOpts.MaxBcdScale)) then
            FSrcType := dtBCD;
          if FOSrcType in [otNChar, otNString, otNLong] then begin
            FByteSize := oSelItem.DataSize;
            FLogSize := oSelItem.CharSize;
            if {(TADPhysOraclConnection(FConnectionObj).FServerVersion < cvOracle90000) and}
               (FByteSize < FLogSize * SizeOf(WideChar)) then
              FByteSize := FLogSize * SizeOf(WideChar);
          end
          else begin
            FByteSize := oSelItem.DataSize;
            FLogSize := FByteSize;
          end;
          if GetMetaInfoKind <> daADPhysIntf.mkNone then
            FDestType := FSrcType
          else
            oFmtOpts.ResolveDataType(FSrcType, FLogSize, FPrec, FScale, FDestType, True);
          FOOutputType := ADType2OCIType(FDestType, FOSrcType in [otChar, otNChar]);
          if FOOutputType = otUnknown then begin
            FOutputType := ovdt2addt[FOSrcType];
            FOOutputType := FOSrcType;
          end
          else begin
            if FSrcType = FDestType then
              FOOutputType := FOSrcType;
            FOutputType := ovdt2addt[FOOutputType];
            if (FSrcType = dtBCD) and (FOutputType = dtFmtBCD) then
              FOutputType := dtBCD;
          end;
          if oSelItem.TYPE_NAME <> '' then begin
            rName.FSchema := oSelItem.SCHEMA_NAME;
            rName.FBaseObject := oSelItem.TYPE_NAME;
            rName.FObject := oSelItem.SUB_NAME;
            FExtName := oConnMeta.EncodeObjName(rName, Self, [eoNormalize]);
          end;
          if FOOutputType <> FOSrcType then begin
            if FDestType in [dtAnsiString, dtByteString] then
              FByteSize := oSelItem.DISP_SIZE
            else if FDestType = dtWideString then
              FByteSize := oSelItem.DISP_SIZE * SizeOf(WideChar);
          end;
          FIsNull := oSelItem.IsNull;

          if CheckFetchColumn(FDestType) or
             (FDestType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef]) then begin
            FVar := TOCIVariable.Create(FStmt);
            with FVar do begin
              VarType := odDefine;
              Position := FPos;
              DumpLabel := FName;
              DataType := FOOutputType;
              if FOOutputType in [otString, otChar, otNString, otNChar, otRaw] then begin
                DataSize := FByteSize;
                CharSize := FLogSize;
              end;
              if FOOutputType in [otNString, otNChar, otNLong] then begin
                Include(FHasFields, hfNChar);
                Inc(iNChars);
              end
              else if FOOutputType in otHBlobs then
                Include(FHasFields, hfBlob)
              else if LongData then
                Include(FHasFields, hfLongData);
            end;
          end
          else
            FVar := nil;
        end;

      finally
        oSelItem.Free;
      end;
    end;

    if iNChars > 2 then
      Include(FHasFields, hfManyNChars);

    if ACrsInfo^.FStmt.Handle <> nil then
      ResetDefVars(ACrsInfo, GetRowsetSize(ACrsInfo, GetFetchOptions.ActualRowsetSize));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.DestroyDefineInfo(ACrsInfo: PADOraCrsDataRec);
var
  i: Integer;
  pColInfo: PDEOraColInfoRec;
begin
  with ACrsInfo^ do
    if FColInfos <> nil then
      try
        for i := 0 to FColInfos.Count - 1 do begin
          pColInfo := PDEOraColInfoRec(FColInfos.Items[i]);
          with pColInfo^ do begin
            if FCrsInfo <> nil then begin
              try
                try
                  DestroyDefineInfo(FCrsInfo);
                finally
                  DestroyStmt(FCrsInfo);
                end;
              except
                // no exceptions visible
              end;
              FreeMem(FCrsInfo);
              FCrsInfo := nil;
            end;
            if FVar <> nil then begin
              try
                FVar.BindOff;
              except
                // no exceptions visible
              end;
              FreeAndNil(FVar);
            end;
          end;
          Dispose(pColInfo);
        end;
      finally
        FreeAndNil(FColInfos);
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.DestroyStmt(ACrsInfo: PADOraCrsDataRec);
begin
  FreeAndNil(ACrsInfo^.FStmt);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.CreateBindInfo;
var
  i: Integer;
  oParams: TADParams;
  pParInfo: PDEOraParInfoRec;
  oPar: TADParam;
  oFmtOpts: TADFormatOptions;
  oResOpts: TADResourceOptions;
  eDestFldType: TFieldType;
  iDestPrec: Integer;
  lWasVBlob: Boolean;
begin
  FBindVarsDirty := False;
  FHasParams := [];
  oParams := GetParams;
  if oParams.Count = 0 then
    Exit;

  oFmtOpts := GetFormatOptions;
  oResOpts := GetResourceOptions;
  lWasVBlob := False;

  for i := 0 to oParams.Count - 1 do begin
    oPar := oParams[i];
    if not oPar.Active then
      Continue;

    New(pParInfo);
    pParInfo^.FVar := nil;
    FParInfos.Add(pParInfo);

    with pParInfo^ do begin
      // fill in base info
      case GetParamBindMode of
      pbByName:
        begin
          FPos := 0;
          FName := ':' + oPar.Name;
          if Length(FName) > 30 then
            FName := Copy(FName, 1, 30 - 1 - Length(IntToStr(i + 1))) + '_' + IntToStr(i + 1);
          FExtName := FName;
        end;
      pbByNumber:
        begin
          FPos := oPar.Position;
          FName := '';
          FExtName := IntToStr(FPos);
        end;
      end;
      FIsCaseSensitive := oPar.IsCaseSensitive;
      FIsPLSQLTable := (oPar.ArrayType = atPLSQLTable);
      if oPar.ParamType = ptUnknown then
        oPar.ParamType := oResOpts.DefaultParamType;
      FParType := oPar.ParamType;
      FDataType := oPar.DataType;
      FVarType := pt2vt[FParType];

      // resolve data type
      if oPar.DataType = ftUnknown then
        ParTypeUnknownError(oPar);
      eDestFldType := ftUnknown;
      iDestPrec := 0;
      oFmtOpts.ResolveFieldType(oPar.DataType, oPar.ADDataType, oPar.Size,
        oPar.Precision, eDestFldType, FLogSize, iDestPrec, FSrcType, FDestType, False);

      // Oracle does not support Delphi Currency data type,
      // so map it to BCD
      if FDestType = dtCurrency then
        FDestType := dtBCD;
      FOSrcType := ADType2OCIType(FSrcType, oPar.DataType in [ftFixedChar, ftBytes]);
      FOOutputType := ADType2OCIType(FDestType, eDestFldType in [ftFixedChar, ftBytes]);
      if (FOOutputType = otUnknown) or (eDestFldType = ftBytes) then
        ParTypeMapError(oPar);
      FOutputType := ovdt2addt[FOOutputType];
      // for driver dtBCD and dtFtmBCD are the same
      if (FDestType = dtBCD) and (FOutputType = dtFmtBCD) then
        FOutputType := dtBCD;

      // Long's & InOut & PL/SQL & pice-wise will be followed by
      // ORA-03127: no new operations allowed until the active operation ends.
      // Although statement execution finished with OCI_SUCCESS
      if (FOOutputType in otVBlobs) and (FVarType = odInOut) and
         (FBase.FStmt.STMT_TYPE in [OCI_STMT_BEGIN, OCI_STMT_DECLARE]) and
         (FLogSize = 0) and (oFmtOpts.InlineDataSize < 0) then
        FLogSize := FBase.FStmt.InrecDataSize;
      if FOOutputType in [otNString, otNChar, otNLong] then
        FByteSize := FLogSize * SizeOf(WideChar)
      else
        FByteSize := FLogSize;

      // At moment provider handles BLOB's in UPDATE and INSERT only
      // in RETURNING phrase -> MUST BE CHANGED !!!!
      // Otherwise, INSERT INTO All_types (TCLOB) VALUES (:TCLOB) with
      // temporary CLOB will not work - "capability not supported"
      // TB???
      if (FOOutputType in otHBlobs) and (FVarType in [odIn, odOut, odInOut]) and
         (TADPhysOraclConnection(FConnectionObj).FEnv.Lib.FOCIVersion < cvOracle81000) and
         (FBase.FStmt.STMT_TYPE in [OCI_STMT_UPDATE, OCI_STMT_INSERT]) then begin
        FVarType := odRet;
        Include(FHasParams, hpHBlobsRet);
      end
      else begin
        if FVarType in [odUnknown, odIn, odInOut] then
          Include(FHasParams, hpInput);
        if FVarType in [odOut, odInOut, odRet] then
          Include(FHasParams, hpOutput);
      end;
      if FOOutputType in otCrsTypes then
        Include(FHasParams, hpCursors);
      if FOOutputType in otVBlobs then
        if lWasVBlob then
          Include(FHasParams, hpManyVLobs)
        else
          lWasVBlob := True;

      // check if is array
      FArrayLen := oPar.ArraySize;

      // create OCI variable
      FVar := TOCIVariable.Create(FBase.FStmt);
      with FVar do begin
        VarType := FVarType;
        Position := FPos;
        Name := FName;
        DumpLabel := FExtName;
        IsCaseSensitive := FIsCaseSensitive;
        IsPLSQLTable := FIsPLSQLTable;
        DataType := FOOutputType;
        if (FByteSize <> 0) and
           ((FOOutputType in [otString, otChar, otNString, otNChar, otRaw]) or (FOOutputType in otVBlobs)) then begin
          DataSize := FByteSize;
          CharSize := FLogSize;
        end;
        ArrayLen := FArrayLen;
        if LongData then
          Include(FHasParams, hpLongData);
        Bind;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.DestroyBindInfo;
var
  i: Integer;
  pParInfo: PDEOraParInfoRec;
begin
  try
    for i := 0 to FParInfos.Count - 1 do begin
      pParInfo := PDEOraParInfoRec(FParInfos.Items[i]);
      with pParInfo^ do
        if FVar <> nil then begin
          try
            FVar.BindOff;
          except
            // no exceptions visible
          end;
          FreeAndNil(FVar);
        end;
      Dispose(pParInfo);
    end;
  finally
    FParInfos.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.DestroyCrsInfo;
var
  i: Integer;
  pCrsInfo: PADOraCrsDataRec;
  lBaseDestroyed: Boolean;
begin
  lBaseDestroyed := (FCrsInfos.Count > 0) and (FCrsInfos[0] = @FBase);
  try
    for i := 0 to FCrsInfos.Count - 1 do begin
      pCrsInfo := PADOraCrsDataRec(FCrsInfos[i]);
      DestroyDefineInfo(pCrsInfo);
      DestroyStmt(pCrsInfo);
      if pCrsInfo <> @FBase then
        FreeMem(pCrsInfo, SizeOf(TADOraCrsDataRec));
    end;
  finally
    FCrsInfos.Clear;
    if not lBaseDestroyed then begin
      DestroyDefineInfo(@FBase);
      DestroyStmt(@FBase);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.SetupStatement(AStmt: TOCIStatement);
var
  oFmtOpts: TADFormatOptions;
begin
  oFmtOpts := GetFormatOptions;
  with TADPhysOraclConnection(FConnectionObj) do begin
    AStmt.DecimalSep := FDecimalSep;
    AStmt.PieceBuffOwn := (OCI_THREADED and FMode) <> 0;
    AStmt.PieceBuffLen := FPieceBuffLen;
    if oFmtOpts.InlineDataSize < 0 then
      // see comment in CreateBindInfo about Long's
      if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs,
                            skExecute] then
        AStmt.InrecDataSize := IMaxPLSQLInOutLongSize
      else
        AStmt.InrecDataSize := IDefInrecDataSize
    else
      AStmt.InrecDataSize := oFmtOpts.InlineDataSize;
    AStmt.StrsTrim := oFmtOpts.StrsTrim;
    AStmt.StrsEmpty2Null := oFmtOpts.StrsEmpty2Null;
    AStmt.StrsMaxSize := oFmtOpts.MaxStringSize;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.InternalPrepare;
var
  sSQL: String;
  i: Integer;
  pParInfo: PDEOraParInfoRec;
  pCrsInfo: PADOraCrsDataRec;
  hndl: pOCIHandle;
  uiTmp: ub4;
begin
  FInfoStack.Clear;
  FCurrentCrsInfo := nil;
  FActiveCrs := -1;
  InitCrsData(@FBase);
  if GetMetaInfoKind <> daADPhysIntf.mkNone then
    sSQL := GenerateMetaInfoSQL
  else if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then
    if fiMeta in GetFetchOptions.Items then
      sSQL := GenerateSPSQLFromDB
    else
      sSQL := GenerateSPSQLFromParams
  else
    sSQL := FDbCommandText;
  with FBase, TADPhysOraclConnection(FConnectionObj) do begin
    FStmt := TOCIStatement.Create(FEnv, FService, Self);
    try
      SetupStatement(FStmt);
      FStmt.Prepare(sSQL);
      CreateBindInfo;
      FCursorCanceled := True;
      if FStmt.STMT_TYPE = OCI_STMT_SELECT then begin
        FStmt.Describe;
        CreateDefineInfo(@FBase);
        FCrsInfos.Add(@FBase);
        FActiveCrs := 0;
        if GetCommandKind = skUnknown then
          SetCommandKind(skSelect);
      end
      else if FStmt.STMT_TYPE in [OCI_STMT_BEGIN, OCI_STMT_DECLARE] then begin
        for i := 0 to FParInfos.Count - 1 do begin
          pParInfo := PDEOraParInfoRec(FParInfos.Items[i]);
          if (pParInfo^.FOOutputType = otCursor) and (pParInfo^.FVar <> nil) then begin
            uiTmp := 0;
            pParInfo^.FVar.GetData(0, @hndl, uiTmp, dfOCI);
            GetMem(pCrsInfo, SizeOf(TADOraCrsDataRec));
            InitCrsData(pCrsInfo);
            FCrsInfos.Add(pCrsInfo);
            pCrsInfo^.FStmt := TOCIStatement.CreateUsingHandle(FEnv, FService, hndl);
            SetupStatement(pCrsInfo^.FStmt);
          end;
        end;
        if FCrsInfos.Count > 0 then begin
          if GetCommandKind in [skUnknown, skStoredProc] then
            SetCommandKind(skStoredProcWithCrs);
          FActiveCrs := 0;
        end
        else begin
          if GetCommandKind in [skUnknown, skStoredProc] then
            SetCommandKind(skStoredProcNoCrs);
        end;
      end
      else
        if GetCommandKind = skUnknown then
          SetCommandKind(skOther);
    except
      InternalUnprepare;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.InternalUnprepare;
begin
  InternalClose;
  DestroyBindInfo;
  DestroyCrsInfo;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.IsActiveCursorValid: Boolean;
begin
  Result := (FActiveCrs >= 0) and (FActiveCrs < FCrsInfos.Count);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.GetActiveCursor: PADOraCrsDataRec;
begin
  if not IsActiveCursorValid then begin
    if (GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs]) and
       (GetParams.Count = 0) and not (fiMeta in GetFetchOptions.Items) then
      ADException(Self, [S_AD_LPhys, S_AD_OraId], er_AD_OraNoCursorParams, [])
    else
      ADException(Self, [S_AD_LPhys, S_AD_OraId], er_AD_OraNoCursor, []);
  end;
  Result := PADOraCrsDataRec(FCrsInfos[FActiveCrs]);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean;
var
  pColInfo: PDEOraColInfoRec;
  hndl: pOCIHandle;
  uiTmp: ub4;
begin
  Result := OpenBlocked;
  if Result then
    if ATabInfo.FSourceID = -1 then begin
      ATabInfo.FSourceName := GetCommandText;
      ATabInfo.FSourceID := 1;
      ATabInfo.FOriginName := '';
      FCurrentCrsInfo := GetActiveCursor;
      FCurrentCrsInfo^.FColIndex := 1;
    end
    else begin
      pColInfo := PDEOraColInfoRec(FCurrentCrsInfo^.FColInfos.Items[ATabInfo.FSourceID - 1]);
      ATabInfo.FSourceName := pColInfo^.FName;
      ATabInfo.FSourceID := ATabInfo.FSourceID;
      ATabInfo.FOriginName := '';
      if pColInfo^.FCrsInfo = nil then begin
        ASSERT(pColInfo^.FVar <> nil);
        pColInfo^.FCrsInfo := nil;
        uiTmp := 0;
        GetMem(pColInfo^.FCrsInfo, SizeOf(TADOraVarInfoRec));
        pColInfo^.FVar.GetData(0, @hndl, uiTmp, dfOCI);
        pColInfo^.FCrsInfo.FStmt := TOCIStatement.CreateUsingHandle(
          TADPhysOraclConnection(FConnectionObj).FEnv,
          TADPhysOraclConnection(FConnectionObj).FService, hndl);
        SetupStatement(pColInfo^.FCrsInfo.FStmt);
        // I mean here - nested into nested cursors will not work
        //pColInfo^.FCrsInfo.FStmt.Describe; //Execute(0, 0, False, False, False);
        CreateDefineInfo(pColInfo^.FCrsInfo);
      end;
      FInfoStack.Add(FCurrentCrsInfo);
      FCurrentCrsInfo := pColInfo^.FCrsInfo;
      FCurrentCrsInfo^.FColIndex := 1;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  pColInfo: PDEOraColInfoRec;
begin
  with FCurrentCrsInfo^ do
    if FColIndex > FColInfos.Count then begin
      if FInfoStack.Count > 0 then begin
        FCurrentCrsInfo := PADOraCrsDataRec(FInfoStack.Last);
        FInfoStack.Delete(FInfoStack.Count - 1);
      end;
      Result := False;
      Exit;
    end;
  with FCurrentCrsInfo^ do begin
    pColInfo := PDEOraColInfoRec(FColInfos.Items[FColIndex - 1]);
    AColInfo.FSourceName := pColInfo^.FName;
    AColInfo.FSourceID := pColInfo^.FPos;
    AColInfo.FOriginName := pColInfo^.FName;
    AColInfo.FType := pColInfo^.FDestType;
    AColInfo.FTypeName := pColInfo^.FExtName;
    if pColInfo^.FDestType in [dtAnsiString, dtWideString, dtByteString] then
      AColInfo.FLen := pColInfo^.FLogSize
    else
      AColInfo.FLen := 0;
    if pColInfo^.FDestType in [dtDouble, dtCurrency, dtBCD, dtFmtBCD] then begin
      AColInfo.FPrec := pColInfo^.FPrec;
      AColInfo.FScale := pColInfo^.FScale;
    end
    else begin
      AColInfo.FPrec := 0;
      AColInfo.FScale := 0;
    end;
    AColInfo.FAttrs := [];
    if pColInfo^.FOOutputType in [otChar, otNChar, otROWID] then
      Include(AColInfo.FAttrs, caFixedLen);
    if pColInfo^.FIsNull or
       (pColInfo^.FOOutputType in [otROWID, otCursor, otNestedDataSet]) then
      Include(AColInfo.FAttrs, caAllowNull);
    if not (pColInfo^.FDestType in C_AD_NonSearchableDataTypes) then
      Include(AColInfo.FAttrs, caSearchable);
    if pColInfo^.FOOutputType in [otROWID] then
      Include(AColInfo.FAttrs, caROWID);
    if pColInfo^.FOOutputType in otAllBlobs then
      Include(AColInfo.FAttrs, caBlobData);
    if pColInfo^.FOOutputType in [otCFile, otBFile] then
      Include(AColInfo.FAttrs, caVolatile);
    Inc(FColIndex);
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.CheckParamMatching(APar: TADParam;
  AParInfo: PDEOraParInfoRec);
begin
  if (AParInfo^.FParType <> APar.ParamType) or
     (AParInfo^.FDataType <> APar.DataType) then
    ParDefChangedError(APar);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.SetParamValues(AIntoReturning: Boolean; AFromParIndex: Integer);
var
  j, i, iInfoIndex: Integer;
  uiLen: ub4;
  oParams: TADParams;
  oPar: TADParam;
  pParInfo: PDEOraParInfoRec;
  oFmt: TADFormatOptions;

  function CreateLocator(AParInfo: PDEOraParInfoRec; AType: TOCIVarDataType; AIndex: ub4): TOCIIntLocator;
  var
    hndl: pOCIHandle;
    uiTmp: ub4;
  begin
    if AType in [otCFile, otBFile] then
      ADException(Self, [S_AD_LPhys, S_AD_OraId], er_AD_OraCantAssFILE,
        [AParInfo^.FExtName]);
    uiTmp := 0;
    if AParInfo^.FVar.GetData(AIndex, @hndl, uiTmp, dfOCI) then begin
      Result := TOCIIntLocator.CreateUseHandle(
        TADPhysOraclConnection(FConnectionObj).FService, hndl);
      Result.National := (AType = otNCLOB);
    end
    else begin
      Result := nil;
      ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_OraId]);
    end;
  end;

  procedure ProcessArrayItem(APar: TADParam; AParInfo: PDEOraParInfoRec; AVarIndex, AParIndex: Integer);
  var
    pData: pUb1;
    uiSrcDataLen, uiDestDataLen, uiLen: LongWord;
    oIntLoc: TOCIIntLocator;
  begin
    with AParInfo^ do begin
      // if null
      if APar.IsNulls[AParIndex] then
        FVar.SetData(AVarIndex, nil, 0, dfOCI)

      // if conversion is not required
      else if FSrcType = FOutputType then begin
        // if byte string data, then optimizing - get data directly
        if FOOutputType in [otString, otChar, otNString, otNChar, otLong, otNLong,
                            otLongRaw, otCLOB, otNCLOB, otBLOB, otCFile, otBFile] then begin
          uiLen := 0;
          pData := nil;
          APar.GetBlobRawData(uiLen, PChar(pData), AParIndex);
          if FOOutputType in [otString, otChar, otNString, otNChar, otLong,
                              otNLong, otLongRaw] then
            FVar.SetData(AVarIndex, pData, uiLen, dfDataSet)
          else if FOOutputType in [otCLOB, otNCLOB, otBLOB, otCFile, otBFile] then begin
            oIntLoc := CreateLocator(AParInfo, FOOutputType, AVarIndex);
            try
              oIntLoc.Write(pData, uiLen, uiLen, 1);
            finally
              oIntLoc.Free;
            end;
          end;
        end
        else begin
          FBuffer.Check;
          APar.GetData(FBuffer.Ptr, AParIndex);
          FVar.SetData(AVarIndex, FBuffer.Ptr, APar.GetDataSize(AParIndex), dfDataSet);
        end;
      end

      // if conversion is required
      else begin
        // calculate buffer size to move param values
        uiSrcDataLen := APar.GetDataSize(AParIndex);
        uiDestDataLen := 0;
        FBuffer.Extend(uiSrcDataLen, uiDestDataLen, FSrcType, FOutputType);

        // get, convert and set parameter value
        APar.GetData(FBuffer.Ptr, AParIndex);
        oFmt.ConvertRawData(FSrcType, FOutputType, FBuffer.Ptr, uiSrcDataLen,
          FBuffer.FBuffer, FBuffer.Size, uiDestDataLen);
        if FOOutputType in [otCLOB, otNCLOB, otBLOB, otCFile, otBFile] then begin
          oIntLoc := CreateLocator(AParInfo, FOOutputType, AVarIndex);
          try
            if FOOutputType = otNCLOB then
              uiLen := uiDestDataLen * SizeOf(WideChar)
            else
              uiLen := uiDestDataLen;
            oIntLoc.Write(FBuffer.Ptr, uiDestDataLen, uiDestDataLen, 1);
          finally
            oIntLoc.Free;
          end;
        end
        else
          FVar.SetData(AVarIndex, FBuffer.Ptr, uiDestDataLen, dfDataSet);
      end;
    end;
  end;

begin
  oParams := GetParams;
  oFmt := GetFormatOptions;
  iInfoIndex := 0;
  for i := 0 to oParams.Count - 1 do begin
    oPar := oParams[i];
    if oPar.Active then begin
      pParInfo := PDEOraParInfoRec(FParInfos.Items[iInfoIndex]);
      CheckParamMatching(oPar, pParInfo);
      with pParInfo^ do
        if FVar <> nil then
          if not AIntoReturning then begin
            if FBindVarsDirty then
              FVar.ResetBuffer(-1);
            if (FVarType in [odUnknown, odIn, odInOut]) {TB??? and not (FOOutputType in otHTypes)} then
              if oPar.ArrayType <> atScalar then begin
                if AFromParIndex = -1 then begin
                  uiLen := oPar.ArraySize;
                  if FVar.ArrayLen <> uiLen then begin
                    FVar.ArrayLen := uiLen;
                    FVar.Bind;
                  end;
                  for j := 0 to uiLen - 1 do
                    ProcessArrayItem(oPar, pParInfo, j, j);
                end
                else begin
                  if FVar.ArrayLen <> 1 then begin
                    FVar.ArrayLen := 1;
                    FVar.Bind;
                  end;
                  ProcessArrayItem(oPar, pParInfo, 0, AFromParIndex);
                end;
              end
              else
                ProcessArrayItem(oPar, pParInfo, 0, -1);
          end
          else begin
            if (FVarType = odRet) and (FOOutputType in otHBlobs) then
              ProcessArrayItem(oPar, pParInfo, 0, -1);
          end;
      Inc(iInfoIndex);
    end;
  end;
  if not AIntoReturning then
    FBindVarsDirty := True;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.GetParamValues;
var
  i, j, iInfoIndex: Integer;
  uiLen: ub4;
  oParams: TADParams;
  oPar: TADParam;
  pParInfo: PDEOraParInfoRec;
  oFmt: TADFormatOptions;

  function CreateLocator(AParInfo: PDEOraParInfoRec; AType: TOCIVarDataType;
    AIndex: ub4): TOCILobLocator;
  var
    hndl: pOCIHandle;
    uiTmp: ub4;
  begin
    uiTmp := 0;
    AParInfo^.FVar.GetData(AIndex, @hndl, uiTmp, dfOCI);
    if AType in [otCLOB, otNCLOB, otBLOB] then begin
      Result := TOCIIntLocator.CreateUseHandle(
        TADPhysOraclConnection(FConnectionObj).FService, hndl);
      Result.National := (AType = otNCLOB);
    end
    else begin
      Result := TOCIExtLocator.CreateUseHandle(
        TADPhysOraclConnection(FConnectionObj).FService, hndl);
      if not Result.IsOpen then
        Result.Open(True);
    end;
  end;

  procedure ProcessArrayItem(APar: TADParam; AParInfo: PDEOraParInfoRec; AVarIndex, AParIndex: Integer);
  var
    pData: pUb1;
    uiLen: ub4;
    iDestDataLen: LongWord;
    oLoc: TOCILobLocator;
  begin
    with AParInfo^ do begin
      // if null
      pData := nil;
      uiLen := 0;
      if not FVar.GetDataPtr(AVarIndex, pData, uiLen, dfDataSet) then
        APar.Clear(AParIndex)

      // if conversion is not required
      else if FOutputType = FSrcType then begin
        // if byte string data, then optimizing - get data directly
        if FOOutputType in [otCLOB, otNCLOB, otBLOB, otCFile, otBFile] then begin
          oLoc := CreateLocator(AParInfo, FOOutputType, AVarIndex);
          try
            uiLen := oLoc.Length;
            pData := pUb1(APar.SetBlobRawData(uiLen, nil, AParIndex));
            if uiLen > 0 then
              oLoc.Read(pData, uiLen, uiLen, 1);
          finally
            oLoc.Free;
          end;
        end
        else if FOOutputType in [otString, otChar, otLong, otLongRaw] then
          APar.SetBlobRawData(uiLen, PChar(pData), AParIndex)
        else if FOOutputType in [otNChar, otNString, otNLong] then begin
          // Oracle returns for Unicode output parameters size in bytes,
          // not in chars
          uiLen := uiLen div SizeOf(WideChar);
          APar.SetData(PChar(pData), uiLen, AParIndex);
        end
        else begin
          FBuffer.Check(uiLen);
          FVar.GetData(AVarIndex, FBuffer.Ptr, uiLen, dfDataSet);
          APar.SetData(FBuffer.Ptr, uiLen, AParIndex);
        end;
      end

      // if conversion is required
      else begin
        if FOOutputType in [otCLOB, otNCLOB, otBLOB, otCFile, otBFile] then begin
          oLoc := CreateLocator(AParInfo, FOOutputType, AVarIndex);
          try
            uiLen := oLoc.Length;
            pData := pUb1(APar.SetBlobRawData(uiLen, nil, AParIndex));
            if uiLen > 0 then
              oLoc.Read(pData, uiLen, uiLen, 1);
          finally
            oLoc.Free;
          end;
        end
        else begin
          FBuffer.Check(uiLen);
          FVar.GetData(AVarIndex, FBuffer.Ptr, uiLen, dfDataSet);
          if FOOutputType in [otNChar, otNString, otNLong] then
            uiLen := uiLen div SizeOf(WideChar);
        end;
        iDestDataLen := 0;
        oFmt.ConvertRawData(FOutputType, FSrcType, FBuffer.Ptr, uiLen,
          FBuffer.FBuffer, FBuffer.Size, iDestDataLen);
        APar.SetData(FBuffer.Ptr, iDestDataLen, AParIndex);
      end;
    end;
  end;

begin
  oParams := GetParams;
  oFmt := GetFormatOptions;
  iInfoIndex := 0;
  for i := 0 to oParams.Count - 1 do begin
    oPar := oParams[i];
    if oPar.Active then begin
      pParInfo := PDEOraParInfoRec(FParInfos.Items[iInfoIndex]);
      CheckParamMatching(oPar, pParInfo);
      with pParInfo^ do
        if (FVar <> nil) and
           (FVarType in [odOut, odInOut, odRet]) and
           not (FOOutputType in [otCursor, otNestedDataSet]) and
           (not (FOOutputType in otHBlobs) or (FParType <> ptInput)) then
          if oPar.ArrayType <> atScalar then begin
            uiLen := FVar.ArrayLen;
            oPar.ArraySize := uiLen;
            for j := 0 to uiLen - 1 do
              ProcessArrayItem(oPar, pParInfo, j, j);
          end
          else
            ProcessArrayItem(oPar, pParInfo, 0, -1);
      Inc(iInfoIndex);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.RebindCursorParams;
var
  i, j, iCrsInfo: Integer;
  pParInfo: PDEOraParInfoRec;
  pCrsInfo: PADOraCrsDataRec;
  pColInfo: PDEOraColInfoRec;
  hndl: pOCIHandle;
  uiTmp: ub4;
begin
  if FCrsInfos.Count = 0 then
    Exit;
  iCrsInfo := 0;
  for i := 0 to FParInfos.Count - 1 do begin
    pParInfo := PDEOraParInfoRec(FParInfos.Items[i]);
    if (pParInfo^.FOOutputType = otCursor) and (pParInfo^.FVar <> nil) then begin
      uiTmp := 0;
      pParInfo^.FVar.GetData(0, @hndl, uiTmp, dfOCI);
      pCrsInfo := PADOraCrsDataRec(FCrsInfos[iCrsInfo]);
      pCrsInfo^.FStmt.Handle := hndl;
      pCrsInfo^.FExecuted := False;
      DestroyDefineInfo(pCrsInfo);
      CreateDefineInfo(pCrsInfo);
      for j := 0 to pCrsInfo^.FColInfos.Count - 1 do begin
        pColInfo := PDEOraColInfoRec(pCrsInfo^.FColInfos[j]);
        pColInfo^.FVar.BindOff;
        pColInfo^.FVar.BindTo(pCrsInfo^.FStmt);
      end;
      Inc(iCrsInfo);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.InternalExecute(ATimes: LongInt; AOffset: LongInt;
  var ACount: LongInt);
var
  i: Integer;
  oFO: TADFetchOptions;
begin
  ACount := 0;
  with TADPhysOraclConnection(FConnectionObj) do
    UpdateServerOutput;
  oFO := GetFetchOptions;
  if (hpLongData in FHasParams) and
     not (GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs,
                             skExecute]) then
    for i := AOffset to ATimes - 1 do begin
      if FHasParams <> [] then
        SetParamValues(False, i);
      with TADPhysOraclConnection(FConnectionObj) do
        FBase.FStmt.Execute(1, 0, oFO.Mode = fmExactRecsMax, GetAutoCommit);
      Inc(ACount, FBase.FStmt.LastRowCount);
    end
  else begin
    if FHasParams <> [] then
      SetParamValues(False, -1);
    try
      with TADPhysOraclConnection(FConnectionObj) do
        FBase.FStmt.Execute(ATimes, AOffset, oFO.Mode = fmExactRecsMax, GetAutoCommit);
    finally
      ACount := FBase.FStmt.LastRowCount;
    end;
  end;
  FBase.FExecuted := True;
  if hpHBlobsRet in FHasParams then
    SetParamValues(True, -1);
  if hpOutput in FHasParams then
    GetParamValues;
  if hpCursors in FHasParams then
    RebindCursorParams;
  with TADPhysOraclConnection(FConnectionObj) do
    GetServerOutput;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.InternalAbort;
begin
  with TADPhysOraclConnection(FConnectionObj).FService do
    Break(True);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.GetRowsetSize(ACrsInfo: PADOraCrsDataRec; ARowsetSize: Integer): Integer;
begin
  Result := ARowsetSize;
  with ACrsInfo^ do
    if (hfNChar in FHasFields) and ([hfLongData, hfBlob] * FHasFields <> []) or
       (hfManyNChars in FHasFields) then
      Result := 1;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.InternalOpen: Boolean;
var
  oFO: TADFetchOptions;
  pCrsInfo: PADOraCrsDataRec;
  lMainCursor: Boolean;
  iCount, iRowsetSize: Integer;
begin
  if not GetNextRecordSet then
    FActiveCrs := 0;
  if not FCursorCanceled then begin
    Result := True;
    Exit;
  end;
  if not IsActiveCursorValid then begin
    Result := False;
    Exit;
  end;
  pCrsInfo := GetActiveCursor;
  oFO := GetFetchOptions;
  iRowsetSize := GetRowsetSize(pCrsInfo, oFO.ActualRowsetSize);
  lMainCursor := (pCrsInfo = @FBase);
  if lMainCursor then begin
    if FHasParams <> [] then
      SetParamValues(False, -1);
  end
  else begin
    iCount := 0;
    if not FBase.FExecuted then
      InternalExecute(1, 0, iCount);
  end;
  ResetDefVars(pCrsInfo, iRowsetSize);
  try
    if oFO.Mode = fmExactRecsMax then
      pCrsInfo^.FStmt.PREFETCH_ROWS := oFO.RecsMax;
    with TADPhysOraclConnection(FConnectionObj) do
      pCrsInfo^.FStmt.Execute(iRowsetSize, 0,
        oFO.Mode = fmExactRecsMax, GetAutoCommit);
    if lMainCursor then begin
      if hpHBlobsRet in FHasParams then
        SetParamValues(True, -1);
      if hpOutput in FHasParams then
        GetParamValues;
    end;
    FCursorCanceled := False;
    pCrsInfo^.FExecuted := True;
    Result := True;
  except
    FCursorCanceled := True;
    InternalClose;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.InternalClose;
var
  pCrsInfo: PADOraCrsDataRec;
begin
  if IsActiveCursorValid then begin
    pCrsInfo := GetActiveCursor;
    if not FCursorCanceled then begin
      FCursorCanceled := True;
      if pCrsInfo^.FExecuted then
        pCrsInfo^.FStmt.CancelCursor;
    end;
    pCrsInfo^.FExecuted := False;
  end;
  FInfoStack.Clear;
  FCurrentCrsInfo := nil;
  if not GetNextRecordSet then
    FBase.FExecuted := False;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysOraclCommand.ResetDefVars(ACrsInfo: PADOraCrsDataRec;
  ARowsetSize: LongWord);
var
  i: Integer;
begin
  with ACrsInfo^ do
    for i := 0 to FColInfos.Count - 1 do
      with PDEOraColInfoRec(FColInfos[i])^ do
        if FVar <> nil then
          if (FVar.Handle = nil) or (FVar.ArrayLen <> ARowsetSize) then begin
            FVar.ArrayLen := ARowsetSize;
            FVar.Bind;
          end
          else if not FExecuted then
            FVar.ResetBuffer(-1);
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.ProcessRowSet(ACrsInfo: PADOraCrsDataRec;
  ATable: TADDatSTable; AParentRow: TADDatSRow; ARowsetSize: LongWord): Integer;
var
  i, j: Integer;
  oRow: TADDatSRow;
  oFmt: TADFormatOptions;
  lMetadata: Boolean;

  function CreateLocator(AColInfo: PDEOraColInfoRec; AType: TOCIVarDataType;
    AIndex: ub4): TOCILobLocator;
  var
    hndl: pOCIHandle;
    uiTmp: ub4;
  begin
    uiTmp := 0;
    AColInfo^.FVar.GetData(AIndex, @hndl, uiTmp, dfOCI);
    if AType in [otCLOB, otNCLOB, otBLOB] then begin
      Result := TOCIIntLocator.CreateUseHandle(
        TADPhysOraclConnection(FConnectionObj).FService, hndl);
      Result.National := (AType = otNCLOB);
    end
    else begin
      Result := TOCIExtLocator.CreateUseHandle(
        TADPhysOraclConnection(FConnectionObj).FService, hndl);
      if not Result.IsOpen then
        Result.Open(True);
    end;
  end;

  procedure ProcessColumn(AColIndex: Integer; ARow: TADDatSRow;
    AColInfo: PDEOraColInfoRec; ARowIndex, ARowsetSize: Integer);
  var
    pData: pUb1;
    uiLen: ub4;
    iDestDataLen: LongWord;
    oLoc: TOCILobLocator;
    pCrsInfo: PADOraCrsDataRec;
    oNestedTable: TADDatSTable;
    i, iRowsetSize: Integer;
  begin
    pData := nil;
    uiLen := 0;
    with AColInfo^ do
      if (FVar = nil) or not CheckFetchColumn(FOutputType) then
        Exit

      else if not FVar.GetDataPtr(ARowIndex, pData, uiLen, dfDataSet) then
        ARow.SetData(AColIndex, nil, 0)

      else if FOOutputType = otNestedDataSet then begin
        pCrsInfo := AColInfo^.FCrsInfo;
        iRowsetSize := GetRowsetSize(pCrsInfo, ARowsetSize);
        with pCrsInfo^ do begin
          FStmt.AttachToHandle(ppOCIHandle(pData)^);
          for i := 0 to FColInfos.Count - 1 do
            with PDEOraColInfoRec(FColInfos[i])^.FVar do begin
              BindOff;
              ArrayLen := iRowsetSize;
              BindTo(FStmt);
            end;
          FExecuted := False;
          with TADPhysOraclConnection(FConnectionObj) do
            FStmt.Execute(iRowsetSize, 0, False, GetAutoCommit);
          FExecuted := True;
        end;
        oNestedTable := ARow.Table.Columns[AColIndex].NestedTable;
        while ProcessRowSet(pCrsInfo, oNestedTable, ARow, iRowsetSize) = iRowsetSize do
          ;
        ARow.Fetched[AColIndex] := True;
      end

      // if conversion is not required
      else if FOutputType = FDestType then begin
        // if byte string data, then optimizing - get data directly
        if FOOutputType in [otCLOB, otNCLOB, otBLOB, otCFile, otBFile] then begin
          oLoc := CreateLocator(AColInfo, FOOutputType, ARowIndex);
          try
            uiLen := oLoc.Length;
            pData := pUb1(ARow.WriteBlobDirect(AColIndex, uiLen));
            if uiLen > 0 then
              oLoc.Read(pData, uiLen, uiLen, 1);
          finally
            oLoc.Free;
          end;
        end
        else if FOOutputType in [otString, otNString, otChar, otNChar, otLong,
                               otNLong, otLongRaw] then
          ARow.SetData(AColIndex, pData, uiLen)
        else begin
          FBuffer.Check(uiLen);
          FVar.GetData(ARowIndex, FBuffer.Ptr, uiLen, dfDataSet);
          ARow.SetData(AColIndex, FBuffer.Ptr, uiLen);
        end;
      end

      // if conversion is required
      else begin
        if FOOutputType in [otCLOB, otBLOB, otCFile, otBFile] then begin
          oLoc := CreateLocator(AColInfo, FOOutputType, ARowIndex);
          try
            uiLen := oLoc.Length;
            pData := pUb1(ARow.WriteBlobDirect(AColIndex, uiLen));
            if uiLen > 0 then
              oLoc.Read(pData, uiLen, uiLen, 1);
          finally
            oLoc.Free;
          end;
        end
        else begin
          FBuffer.Check(uiLen);
          FVar.GetData(ARowIndex, FBuffer.Ptr, uiLen, dfDataSet);
        end;
        iDestDataLen := 0;
        oFmt.ConvertRawData(FOutputType, FDestType, FBuffer.Ptr, uiLen,
          FBuffer.FBuffer, FBuffer.Size, iDestDataLen);
        ARow.SetData(AColIndex, FBuffer.Ptr, iDestDataLen);
      end;
  end;

  procedure ProcessMetaColumn(AColIndex: Integer; ARow: TADDatSRow;
    AColInfo: PDEOraColInfoRec; ARowIndex, ARowsetSize: Integer);
  var
    pData: pUb1;
    uiLen, iDestDataLen: ub4;
  begin
    pData := nil;
    uiLen := 0;
    with AColInfo^ do
      if FVar = nil then
        Exit

      else if FPos = 1 then
        ARow.SetData(0, ATable.Rows.Count + 1)

      else if not FVar.GetDataPtr(ARowIndex, pData, uiLen, dfDataSet) then
        ARow.SetData(AColIndex, nil, 0)

      else if FOOutputType in [otString, otNString, otChar, otNChar] then begin
        if uiLen > ATable.Columns[AColIndex].Size then
          uiLen := ATable.Columns[AColIndex].Size;
        ARow.SetData(AColIndex, pData, uiLen);
      end

      else if FOOutputType in [otLong, otNLong, otLongRaw] then
        ARow.SetData(AColIndex, pData, uiLen)

      else begin
        FBuffer.Check(uiLen);
        FVar.GetData(ARowIndex, FBuffer.Ptr, uiLen, dfDataSet);
        iDestDataLen := 0;
        if FDestType in [dtInt32, dtDouble, dtBCD, dtFmtBCD] then
          oFmt.ConvertRawData(FOutputType, ATable.Columns[AColIndex].DataType,
            FBuffer.Ptr, uiLen, FBuffer.FBuffer, FBuffer.Size, iDestDataLen);
        ARow.SetData(AColIndex, FBuffer.Ptr, iDestDataLen);
      end;
  end;

begin
  with ACrsInfo^ do begin
    if not FExecuted then begin
      ResetDefVars(ACrsInfo, ARowsetSize);
      FStmt.Fetch(ARowsetSize);
    end
    else
      FExecuted := False;
    oFmt := GetFormatOptions;
    lMetadata := GetMetaInfoKind <> daADPhysIntf.mkNone;
    for i := 0 to Integer(FStmt.LastRowCount) - 1 do begin
      oRow := ATable.NewRow(False);
      try
        for j := 0 to ATable.Columns.Count - 1 do
          with ATable.Columns[j] do
            if SourceID > 0 then
              if lMetadata then
                ProcessMetaColumn(j, oRow, PDEOraColInfoRec(FColInfos[SourceID - 1]),
                  i, ARowsetSize)
              else
                ProcessColumn(j, oRow, PDEOraColInfoRec(FColInfos[SourceID - 1]),
                  i, ARowsetSize);
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
    Result := Integer(FStmt.LastRowCount);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.InternalFetchRowSet(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowsetSize: LongWord): LongWord;
var
  iRowsetSize, iRows: Integer;
  pCrsInfo: PADOraCrsDataRec;
begin
  pCrsInfo := GetActiveCursor;
  iRowsetSize := GetRowsetSize(pCrsInfo, ARowsetSize);
  Result := 0;
  while Result < ARowsetSize do begin
    iRows := ProcessRowSet(pCrsInfo, ATable, AParentRow, iRowsetSize);
    Inc(Result, iRows);
    if iRows <> iRowsetSize then
      Break;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysOraclCommand.InternalNextRecordSet: Boolean;
begin
  if not FBase.FExecuted or (FActiveCrs < 0) then begin
    Result := False;
    Exit;
  end;
  if FActiveCrs < FCrsInfos.Count then
    Inc(FActiveCrs);
  if FActiveCrs < FCrsInfos.Count then
    Result := InternalOpen
  else begin
    FBase.FExecuted := False;
    Result := False;
  end;
end;

{-----------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysOraclConnection);

finalization
//  ADPhysManagerObj.UnRegisterPhysConnectionClass(TADPhysOraclConnection);

end.
