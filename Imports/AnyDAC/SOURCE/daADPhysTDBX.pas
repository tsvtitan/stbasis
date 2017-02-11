{-------------------------------------------------------------------------------}
{ AnyDAC TDBX driver                                                            }
{ Copyright (c) 2004-2007 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysTDBX;

interface

uses
  SysUtils, DBXCommon,
  daADStanError,
  daADPhysIntf, daADPhysManager;

type
  ETDBXNativeException = class;
  TADPhysTDBXDriverLink = class;
  IADPhysTDBXConnection = interface;

  ETDBXNativeException = class(EADDBEngineException)
  end;

  TADPhysTDBXDriverLink = class(TADPhysDriverLinkBase)
  end;

  IADPhysTDBXConnection = interface(IADPhysConnection)
    ['{3E9B315B-F456-4175-A864-B2573C4A2120}']
    // private
    function GetDBXConnection: TDBXConnection;
    // public
    property DBXConnection: TDBXConnection read GetDBXConnection;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
{$IFDEF Win32}
  Windows, Registry,
{$ENDIF}
{$IFDEF LINUX}
  Libc,
{$ENDIF}
  DBCommon, DBCommonTypes, DBConnAdmin, Variants, Classes, DB, FmtBcd, IniFiles,
    SqlConst, WideStrings,
  daADStanIntf, daADStanParam, daADStanConst, daADStanUtil, daADStanOption,
    daADStanFactory, daADStanResStrs,
  daADDatSManager,
  daADPhysCmdGenerator, daADPhysConnMeta, daADPhysMSAccMeta, daADPhysMSSQLMeta,
    daADPhysMySQLMeta, daADPhysOraclMeta, daADPhysDb2Meta, daADPhysASAMeta,
    daADPhysADSMeta, daADPhysTDBXMeta;

type
  TADPhysTDBXLib = class;
  TADPhysTDBXDriver = class;
  TADPhysTDBXConnection = class;
  TADPhysTDBXCommand = class;

  TADPhysTDBXLib = class(TObject)
  private
    FOwningObj: TObject;
    FDrivers: IADStanDefinitions;
{$IFDEF AnyDAC_MONITOR}
    FMonitor: IADMoniClient;
    FMonitorConns: Integer;
    function DoTrace(TraceInfo: TDBXTraceInfo): CBRType;
{$ENDIF}
    class function GetDriverRegistryFile(DesignMode: Boolean = False): string;
    class function GetRegistryFile(const Setting, Default: string;
      DesignMode: Boolean): string;
    function GetDrivers: IADStanDefinitions;
    procedure DoError(ADBXError: TDBXError);
  public
    constructor Create(AOwningObj: TObject = nil);
    destructor Destroy; override;
    procedure ResolveDriverInfo(const ADriverName: String; var ALibName,
      AGetFunc, AVendLib: String);
{$IFDEF AnyDAC_MONITOR}
    procedure UpdateTracing(const AMonitor: IADMoniClient; AOn: Boolean);
{$ENDIF}
    property OwningObj: TObject read FOwningObj;
  end;

  TADPhysTDBXDriver = class(TADPhysDriver)
  private
    FDesignMode: Boolean;
    FCfgFile: String;
    FLib: TADPhysTDBXLib;
    function GetDriverParams(AKeys: TStrings): TStrings;
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

  TADPhysDBXExceptionType = (etConnection, etCommand, etCursor, etMetaData, etUseLast);
  TADPhysTDBXConnection = class(TADPhysConnection, IADPhysTDBXConnection)
  private
    FDriverName: String;
    FLibraryName: String;
    FVendorLib: String;
    FGetDriverFunc: String;
    FConnected: Boolean;
    FTransactions: TStringList;
    procedure CheckConnParams;
    procedure GetConnInterfaces;
    procedure SetConnParams;
    procedure DirectExec(const ASQL: String);
    function GetRDBMSKindFromAlias: TADRDBMSKind;
    function GetTxIsolationLevel: TDBXIsolation;
  protected
    FDbxConnection: TDBXConnection;
    FRdbmsKind: TADRDBMSKind;
    procedure InternalConnect; override;
    procedure InternalDisconnect; override;
    function InternalCreateCommand: TADPhysCommand; override;
    procedure InternalTxBegin(ATxID: LongWord); override;
    procedure InternalTxCommit(ATxID: LongWord); override;
    procedure InternalTxRollback(ATxID: LongWord); override;
    procedure InternalTxSetSavepoint(const AName: String); override;
    procedure InternalTxRollbackToSavepoint(const AName: String); override;
    procedure InternalTxCommitSavepoint(const AName: String); override;
    function InternalCreateMetadata: TObject; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand):
      TADPhysCommandGenerator; override;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; override;
{$ENDIF}
    procedure GetItem(AIndex: Integer; var AName: String;
      var AValue: Variant; var AKind: TADDebugMonitorAdapterItemKind); override;
    function GetItemCount: Integer; override;
    // IADPhysTDBXConnection
    function GetDBXConnection: TDBXConnection;
  public
    constructor Create(ADriverObj: TADPhysDriver; const ADriver: IADPhysDriver;
      AConnHost: TADPhysConnectionHost); override;
    destructor Destroy; override;
    class function GetDriverClass: TADPhysDriverClass; override;
  end;

  TADPhysTDBXCommand = class(TADPhysCommand)
  private
    FDBXCommand: TDBXCommand;
    FDBXReader: TDBXReader;
    FColumnIndex: Word;
    FParamChildPos: array of Word;
    procedure FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    procedure GetCmdParamValues(AParams: TADParams);
    procedure SetCmdParamValues(AParams: TADParams; AValueIndex: Integer);
    procedure CalcUnits(const AParams: TADParams; const AIndex, AActiveIndex: Integer;
      var AChildPos: array of Word; var ASubItems, AActiveSubItems: Integer);
    procedure OpenMetaInfo;
    function FetchMetaRow(ATable: TADDatSTable; AParentRow: TADDatSRow): Boolean;
    procedure Dbx2ADColInfo(ADbxType, ADbxSubType: TDBXType; ADbxPrec: Integer;
      ADbxScale: SmallInt; var AType: TADDataType; var AAtrs: TADDataAttributes;
      var ALen: LongWord; var APrec, AScale: Integer);
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

var
  FGLock: TRTLCriticalSection;

const
  C_AD_ConnParam_DBX_Count = 3;

  txi2dbxi: array[TADTxIsolation] of TDBXIsolation = (
    TDBXIsolations.DirtyRead, TDBXIsolations.ReadCommitted,
    TDBXIsolations.RepeatableRead, TDBXIsolations.Serializable);
  dbxi2txi: array[0 .. TDBXIsolations.SnapShot] of TADTxIsolation = (
    xiReadCommitted, xiRepeatableRead, xiDirtyRead, xiSerializible,
    xiRepeatableRead);

{-------------------------------------------------------------------------------}
{ TADPhysTDBXLib                                                                }
{-------------------------------------------------------------------------------}
constructor TADPhysTDBXLib.Create(AOwningObj: TObject);
begin
  inherited Create;
  FOwningObj := AOwningObj;
  TDBXConnectionFactory.GetConnectionFactory.OnError := DoError;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysTDBXLib.Destroy;
begin
  TDBXConnectionFactory.GetConnectionFactory.OnError := nil;
  TDBXConnectionFactory.GetConnectionFactory.OnTrace := nil;
  FDrivers := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXLib.DoError(ADBXError: TDBXError);
var
  oEx: ETDBXNativeException;
begin
  oEx := ETDBXNativeException.Create(er_AD_DBXGeneral,
    ADExceptionLayers([S_AD_LPhys, S_AD_TDBXId, '<unknown>' {???}]) + ' ' + ADBXError.Message);
  oEx.Append(TADDBError.Create(1, ADBXError.ErrorCode, ADBXError.Message, '', ekOther, 0));
  ADException(nil {???}, oEx);
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADPhysTDBXLib.DoTrace(TraceInfo: TDBXTraceInfo): CBRType;
begin
  FMonitor.Notify(ekVendor, esProgress, FOwningObj, TraceInfo.Message, []);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXLib.UpdateTracing(const AMonitor: IADMoniClient;
  AOn: Boolean);
begin
  FMonitor := AMonitor;
  if AOn then begin
    Inc(FMonitorConns);
    if FMonitorConns = 1 then
      TDBXConnectionFactory.GetConnectionFactory.OnTrace := DoTrace;
  end
  else begin
    Dec(FMonitorConns);
    if FMonitorConns = 0 then
      TDBXConnectionFactory.GetConnectionFactory.OnTrace := nil;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADPhysTDBXLib.GetRegistryFile(const Setting, Default: string;
  DesignMode: Boolean): string;
var
{$IFDEF MSWINDOWS}
  Reg: TRegistry;
{$ENDIF}
{$IFDEF LINUX}
  GlobalFile: string;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly(TDBXRegistryKey) then
      Result := Reg.ReadString(Setting)
    else
      Result := '';
    Result := ADGetBestPath('', Result, TDBXDriverFile);
  finally
    Reg.Free;
  end;
{$ENDIF}
{$IFDEF LINUX}
  Result := ExtractFileDir(ParamStr(0)) + '/' + Default;
  if not FileExists(Result) then begin
    Result := getenv('HOME') + SDBEXPRESSREG_USERPATH + Default;    { do not localize }
    if not FileExists(Result) then
    begin
      GlobalFile := SDBEXPRESSREG_GLOBALPATH + Default + SConfExtension;
      if FileExists(GlobalFile) then
      begin
        if DesignMode then
        begin
          if not CopyConfFile(GlobalFile, Result) then
            DatabaseErrorFmt(SConfFileMoveError, [GlobalFile, Result])
        end else
          Result := GlobalFile;
      end else
        DatabaseErrorFmt(SMissingConfFile, [GlobalFile]);
    end;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
class function TADPhysTDBXLib.GetDriverRegistryFile(DesignMode: Boolean = False): string;
begin
  Result := GetRegistryFile(TDBXRegistryDriverValue, TDBXDriverFile, DesignMode);
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXLib.GetDrivers: IADStanDefinitions;
begin
  if FDrivers = nil then begin
    ADCreateInterface(IADStanDefinitions, FDrivers);
    with FDrivers.Storage do begin
      DefaultFileName := TDBXDriverFile;
      GlobalFileName := GetDriverRegistryFile;
    end;
    if not FileExists(FDrivers.Storage.ActualFileName) then
      ADException(OwningObj, [S_AD_LPhys, S_AD_DBXId], er_AD_DBXNoDriverCfg,
        [FDrivers.Storage.ActualFileName]);
    FDrivers.Load;
  end;
  Result := FDrivers;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXLib.ResolveDriverInfo(const ADriverName: String;
  var ALibName, AGetFunc, AVendLib: String);
var
  oDrv: IADStanDefinition;
begin
  if (ALibName = '') or (AGetFunc = '') or (AVendLib = '') then begin
    oDrv := GetDrivers.FindDefinition(ADriverName);
    if oDrv <> nil then begin
      if ALibName = '' then
        ALibName := oDrv.AsString[DLLLIB_KEY];
      if AGetFunc = '' then
        AGetFunc := oDrv.AsString[GETDRIVERFUNC_KEY];
      if AVendLib = '' then
        AVendLib := oDrv.AsString[VENDORLIB_KEY];
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysTDBXDriver                                                             }
{-------------------------------------------------------------------------------}
constructor TADPhysTDBXDriver.Create(ADrvHost: TADPhysDriverHost);
begin
  inherited Create(ADrvHost);
  FLib := TADPhysTDBXLib.Create;
  FDesignMode := False; // ???
  FCfgFile := FLib.GetRegistryFile(TDBXRegistryDriverValue, TDBXDriverFile, FDesignMode);
  InitializeCriticalSection(FGLock);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysTDBXDriver.Destroy;
begin
  DeleteCriticalSection(FGLock);
  FreeAndNil(FLib);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADPhysTDBXDriver.GetDriverID: String;
begin
  Result := S_AD_TDBXId;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXDriver.GetDescription: String;
begin
  Result := 'TDBX Driver'; 
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXDriver.GetDriverParams(AKeys: TStrings): TStrings;
var
  sDrv, sName, sType, sDefVal, sCaption: String;
  oIniFile: TCustomIniFile;
  i, j, iLogin: Integer;
begin
  Result := TStringList.Create;
  try
    sDrv := AKeys.Values[TDBXPropertyNames.DriverName];
    if sDrv <> '' then begin
      oIniFile := TIniFile.Create(FCfgFile);
      try
        oIniFile.ReadSectionValues(sDrv, Result);
        i := inherited GetConnParamCount(AKeys) - 1;
        while i >= 0 do begin
          inherited GetConnParams(AKeys, i, sName, sType, sDefVal, sCaption, iLogin);
          j := Result.IndexOfName(sName);
          if j <> -1 then
            Result.Delete(j);
          Dec(i);
        end;
      finally
        oIniFile.Free;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXDriver.GetConnParamCount(AKeys: TStrings): Integer;
var
  oList: TStrings;
begin
  Result := inherited GetConnParamCount(AKeys);
  oList := GetDriverParams(AKeys);
  try
    Result := Result + oList.Count + C_AD_ConnParam_DBX_Count;
  finally
    oList.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXDriver.GetConnParams(AKeys: TStrings; Index: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  oList, oList2: TStrings;
  oIniFile: TIniFile;
  j: TADRDBMSKind;
begin
  ALoginIndex := -1;
  if Index = 1 then begin
    AName := DRIVERNAME_KEY;
    oIniFile := TIniFile.Create(FCfgFile);
    oList := TStringList.Create;
    oList.Delimiter := ';';
    oList.QuoteChar := '"';
    try
      oIniFile.ReadSection(DRIVERS_KEY, oList);
      AType := oList.DelimitedText;
    finally
      oList.Free;
      oIniFile.Free;
    end;
    ADefVal := '';
    ACaption := AName;
    Exit;
  end;

  if Index < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, Index, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then
      ALoginIndex := 2;
  end
  else begin
    Index := Index - inherited GetConnParamCount(AKeys);
    oList := GetDriverParams(AKeys);
    try
      if Index < oList.Count then begin
        AName := oList.Names[Index];
        ADefVal := oList.Values[oList.Names[Index]];
        oIniFile := TIniFile.Create(FCfgFile);
        oList2 := TStringList.Create;
        oList2.Delimiter := ';';
        oList2.QuoteChar := '"';
        try
          oIniFile.ReadSection(AName, oList2);
          AType := oList2.DelimitedText;
        finally
          oList2.Free;
          oIniFile.Free;
        end;
      end
      else
        case Index - oList.Count of
        0:
          begin
            AName := S_AD_ConnParam_Common_MetaDefSchema;
            AType := '@S';
            ADefVal := '';
          end;
        1:
          begin
            AName := S_AD_ConnParam_Common_MetaDefCatalog;
            AType := '@S';
            ADefVal := '';
          end;
        2:
          begin
            AName := S_AD_ConnParam_Common_RDBMSKind;
            AType := '';
            for j := Low(TADRDBMSKind) to High(TADRDBMSKind) do begin
              if AType <> '' then
                AType := AType + ';';
              AType := AType + C_AD_PhysRDBMSKinds[j];
            end;
            ADefVal := '';
          end;
        end;
    finally
      oList.Free;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysTDBXConnection                                                         }
{-------------------------------------------------------------------------------}
constructor TADPhysTDBXConnection.Create(ADriverObj: TADPhysDriver;
  const ADriver: IADPhysDriver; AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, ADriver, AConnHost);
  FTransactions := TStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysTDBXConnection.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FTransactions);
end;

{-------------------------------------------------------------------------------}
class function TADPhysTDBXConnection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysTDBXDriver;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXConnection.GetDBXConnection: TDBXConnection;
begin
  Result := FDbxConnection;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    case GetRDBMSKindFromAlias of
    mkOracle:   Result := TADPhysOraCommandGenerator.Create(ACommand);
    mkMSSQL:    Result := TADPhysMSSQLCommandGenerator.Create(ACommand);
    mkMSAccess: Result := TADPhysMSAccCommandGenerator.Create(ACommand);
    mkMySQL:    Result := TADPhysMySQLCommandGenerator.Create(ACommand);
    mkDb2:      Result := TADPhysDb2CommandGenerator.Create(ACommand);
    mkASA:      Result := TADPhysASACommandGenerator.Create(ACommand);
    mkADS:      Result := TADPhysADSCommandGenerator.Create(ACommand);
    else        Result := TADPhysCommandGenerator.Create(ACommand);
    end
  else
    case GetRDBMSKindFromAlias of
    mkOracle:   Result := TADPhysOraCommandGenerator.Create(Self);
    mkMSSQL:    Result := TADPhysMSSQLCommandGenerator.Create(Self);
    mkMSAccess: Result := TADPhysMSAccCommandGenerator.Create(Self);
    mkMySQL:    Result := TADPhysMySQLCommandGenerator.Create(Self);
    mkDb2:      Result := TADPhysDb2CommandGenerator.Create(Self);
    mkASA:      Result := TADPhysASACommandGenerator.Create(Self);
    mkADS:      Result := TADPhysADSCommandGenerator.Create(Self);
    else        Result := TADPhysCommandGenerator.Create(Self);
    end
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXConnection.InternalCreateMetadata: TObject;
begin
  case GetRDBMSKindFromAlias of
  mkOracle:   Result := TADPhysOraMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self, 0, 0);
  mkMSSQL:    Result := TADPhysMSSQLMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  mkMSAccess: Result := TADPhysMSAccMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  mkMySQL:    Result := TADPhysMySQLMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self, 0, 0, False);
  mkDb2:      Result := TADPhysDb2Metadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  mkASA:      Result := TADPhysASAMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  mkADS:      Result := TADPhysADSMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF} Self);
  else        Result := nil;
  end;
  Result := TADPhysTDBXMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF}
    Self, TADPhysConnectionMetadata(Result));
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXConnection.GetRDBMSKindFromAlias: TADRDBMSKind;
var
  s: String;
  i: TADRDBMSKind;
begin
  Result := FRdbmsKind;
  if Result = mkUnknown then begin
    s := UpperCase(GetConnectionDef.AsString[S_AD_ConnParam_Common_RDBMSKind]);
    for i := Low(TADRDBMSKind) to High(TADRDBMSKind) do
      if C_AD_PhysRDBMSKinds[i] = s then begin
        Result := i;
        Break;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysTDBXCommand.Create;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.CheckConnParams;
begin
  FDriverName := GetConnectionDef.AsString[DRIVERNAME_KEY];
  if FDriverName = '' then
    ADException(Self, [S_AD_LPhys, S_AD_DBXId], er_AD_DBXParMBNotEmpty,
      [DRIVERNAME_KEY]);
  FLibraryName := GetConnectionDef.AsString[TDBXPropertyNames.LibraryName];
  FGetDriverFunc := GetConnectionDef.AsString[TDBXPropertyNames.GetDriverFunc];
  FVendorLib := GetConnectionDef.AsString[TDBXPropertyNames.VendorLib];
  TADPhysTDBXDriver(DriverObj).FLib.ResolveDriverInfo(FDriverName, FLibraryName,
    FGetDriverFunc, FVendorLib);
  if FLibraryName = '' then
    ADException(Self, [S_AD_LPhys, S_AD_DBXId], er_AD_DBXParMBNotEmpty,
      [DLLLIB_KEY]);
  if FGetDriverFunc = '' then
    ADException(Self, [S_AD_LPhys, S_AD_DBXId], er_AD_DBXParMBNotEmpty,
      [GETDRIVERFUNC_KEY]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.GetConnInterfaces;
var
  oConnProps: TDBXProperties;
  oConnDef: IADStanDefinition;
  oConnMeta: IADPhysConnectionMetadata;
begin
  CreateMetadata(oConnMeta);
  if oConnMeta.Kind = mkMySQL then
    EnterCriticalSection(FGLock);
  try
    oConnProps := TDBXProperties.Create;
    try
      oConnDef := GetConnectionDef;
      while oConnDef <> nil do begin
        oConnProps.Properties.AddStrings(oConnDef.Params);
        oConnDef := oConnDef.ParentDefinition;
      end;
      oConnProps.Values[TDBXPropertyNames.Database] := GetConnectionDef.ExpandedDatabase;
      oConnProps.Values[TDBXPropertyNames.UserName] := GetConnectionDef.UserName;
      oConnProps.Values[TDBXPropertyNames.Password] := GetConnectionDef.Password;
      FDbxConnection := TDBXConnectionFactory.GetConnectionFactory.GetConnection(oConnProps);
    finally
      // ??? oConnProps.Free;
    end;
  finally
    if oConnMeta.Kind = mkMySQL then
      LeaveCriticalSection(FGLock);
  end;
  FConnected := True;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.SetConnParams;
var
  s: String;
  iLevel: TDBXIsolation;
begin
  if GetConnectionDef.HasValue(AUTOCOMMIT_KEY) then
    GetTxOptions.AutoCommit := GetConnectionDef.AsBoolean[AUTOCOMMIT_KEY];
  s := Format(TRANSISOLATION_KEY, [FDriverName]);
  if GetConnectionDef.HasValue(s) then
    s := LowerCase(GetConnectionDef.AsString[s])
  else if GetConnectionDef.HasValue(TDBXPropertyNames.IsolationLevel) then
    s := LowerCase(GetConnectionDef.AsString[TDBXPropertyNames.IsolationLevel])
  else
    s := '';
  if s <> '' then begin
    if s = SREPEATREAD then
      iLevel := TDBXIsolations.RepeatableRead
    else if s = SDIRTYREAD then
      iLevel := TDBXIsolations.DirtyRead
    else if s = SREADCOMMITTED then
      iLevel := TDBXIsolations.ReadCommitted
    else
      iLevel := TDBXIsolations.RepeatableRead;
    GetTxOptions.Isolation := dbxi2txi[iLevel];
  end;
  UpdateTx;
  if GetConnectionDef.HasValue(TRIMCHAR) then
    GetOptions.FormatOptions.StrsTrim := GetConnectionDef.AsBoolean[TRIMCHAR];
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.InternalConnect;
begin
  CheckConnParams;
  try
    GetConnInterfaces;
    SetConnParams;
    FRdbmsKind := GetRDBMSKindFromAlias;
  except
    InternalDisconnect;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.InternalDisconnect;
begin
  FreeAndNil(FDbxConnection);
  FRdbmsKind := mkUnknown;
  FConnected := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXConnection.GetTxIsolationLevel: TDBXIsolation;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  CreateMetadata(oConnMeta);
  if oConnMeta.Kind = mkMSAccess then
    Result := TDBXIsolations.ReadCommitted
  else
    Result := txi2dbxi[GetTxOptions.Isolation];
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.InternalTxBegin(ATxID: LongWord);
begin
  FTransactions.AddObject(IntToStr(ATxID), FDbxConnection.BeginTransaction(GetTxIsolationLevel));
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.InternalTxCommit(ATxID: LongWord);
var
  oTX: TDBXTransaction;
  i: Integer;
begin
  FTransactions.Find(IntToStr(ATxID), i);
  oTX := TDBXTransaction(FTransactions.Objects[i]);
  FTransactions.Delete(i);
  FDbxConnection.CommitFreeAndNil(oTX);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.InternalTxRollback(ATxID: LongWord);
var
  oTX: TDBXTransaction;
  i: Integer;
begin
  FTransactions.Find(IntToStr(ATxID), i);
  oTX := TDBXTransaction(FTransactions.Objects[i]);
  FTransactions.Delete(i);
  FDbxConnection.RollbackFreeAndNil(oTX);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.DirectExec(const ASQL: String);
var
  oCmd: TDBXCommand;
begin
  oCmd := FDbxConnection.CreateCommand;
  try
    oCmd.CommandType := TDBXCommandTypes.DbxSQL;
    oCmd.Text := ASQL;
    oCmd.ExecuteQuery.Free;
  finally
    oCmd.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.InternalTxRollbackToSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: String;
begin
  CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateRollbackToSavepoint(AName);
  if s <> '' then
    DirectExec(s);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.InternalTxSetSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: String;
begin
  CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateSavepoint(AName);
  if s <> '' then
    DirectExec(s);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.InternalTxCommitSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: String;
begin
  CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateCommitSavepoint(AName);
  if s <> '' then
    DirectExec(s);
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.InternalTracingChanged;
begin
  if DriverObj <> nil then
    TADPhysTDBXDriver(DriverObj).FLib.UpdateTracing(GetMonitor, GetTracing);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADPhysTDBXConnection.GetItemCount: Integer;
begin
  if FDriverName = '' then
    try
      CheckConnParams;
    except
      // no exceptions visible
    end;
  Result := inherited GetItemCount + 4;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXConnection.GetItem(AIndex: Integer; var AName: String;
  var AValue: Variant; var AKind: TADDebugMonitorAdapterItemKind);
var
  sProduct, sVersion, sVersionName, sCopyright, sInfo: String;
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'DBX driver id';
        AKind := ikClientInfo;
        AValue := '';
        if ADGetVersionInfo(FLibraryName, sProduct, sVersion, sVersionName, sCopyright, sInfo) then
          AValue := AValue + sProduct + ', ver ' + sVersionName + ', ' + sCopyright
        else
          AValue := AValue + '<not found>';
      end;
    1:
      begin
        AName := 'Library name';
        AValue := FLibraryName;
        AKind := ikClientInfo;
      end;
    2:
      begin
        AName := 'Vendor lib';
        AValue := FVendorLib;
        AKind := ikClientInfo;
      end;
    3:
      begin
        AName := 'Get driver func';
        AValue := FGetDriverFunc;
        AKind := ikClientInfo;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysTDBXCommand                                                            }
{-------------------------------------------------------------------------------}
procedure TADPhysTDBXCommand.CalcUnits(const AParams: TADParams;
  const AIndex, AActiveIndex: Integer; var AChildPos: array of Word;
  var ASubItems, AActiveSubItems: Integer);
var
  i, iActive, tmpSubItems, tmpActiveSubItems: Integer;
  oBasePar, oPar: TADParam;
begin
  i := AIndex + 1;
  iActive := AActiveIndex + 1;
  ASubItems := 0;
  AActiveSubItems := 0;
  oBasePar := AParams[AIndex];
  while i < AParams.Count do begin
    oPar := AParams[i];
    if oBasePar.Position <> oPar.Position then
      Break;
    Inc(ASubItems);
    if oPar.Active then begin
      Inc(AActiveSubItems);
      AChildPos[iActive] := iActive - AActiveIndex;
    end;
    if oPar.DataType = ftADT then begin
      CalcUnits(AParams, i, iActive, AChildPos, tmpSubItems, tmpActiveSubItems);
      ASubItems := ASubItems + tmpSubItems;
      Inc(i, tmpSubItems);
      if oPar.Active then begin
        AActiveSubItems := AActiveSubItems + tmpActiveSubItems;
        Inc(iActive, tmpActiveSubItems);
      end;
    end
    else begin
      Inc(i);
      if oPar.Active then
        Inc(iActive);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXCommand.SetCmdParamValues(AParams: TADParams; AValueIndex: Integer);
const
  FldTypeMap: array [TADDataType] of TDBXType = (TDBXDataTypes.UnknownType,
    TDBXDataTypes.BooleanType,
    TDBXDataTypes.Int16Type, TDBXDataTypes.Int16Type, TDBXDataTypes.Int32Type, TDBXDataTypes.Int64Type,
    { TODO : Next line - all there must be UIntXXType, but TDBX does not support them.
             Later should be reviewed. }
    TDBXDataTypes.Int16Type, TDBXDataTypes.Int16Type, TDBXDataTypes.Int32Type, TDBXDataTypes.Int64Type,
    TDBXDataTypes.DoubleType, TDBXDataTypes.DoubleType, TDBXDataTypes.BcdType, TDBXDataTypes.BcdType,
    TDBXDataTypes.TimeStampType, TDBXDataTypes.TimeType, TDBXDataTypes.DateType, TDBXDataTypes.TimeStampType,
    TDBXDataTypes.AnsiStringType, TDBXDataTypes.WideStringType, TDBXDataTypes.BytesType,
    TDBXDataTypes.BlobType, TDBXDataTypes.BlobType, TDBXDataTypes.BlobType,
    TDBXDataTypes.BlobType, TDBXDataTypes.BlobType, TDBXDataTypes.BlobType,
    TDBXDataTypes.BlobType,
    TDBXDataTypes.TableType, TDBXDataTypes.CursorType, TDBXDataTypes.AdtType,
      TDBXDataTypes.ArrayType, TDBXDataTypes.UnknownType,
    TDBXDataTypes.AnsiStringType, TDBXDataTypes.UnknownType);
  FldSubTypeMap: array[TADDataType] of TDBXType = (0,
    0,
    0, 0, 0, 0,
    0, 0, 0, 0,
    0, TDBXDataTypes.MoneySubType, 0, 0,
    0, 0, 0, 0,
    0, 0, 0,
    TDBXDataTypes.BinarySubType, TDBXDataTypes.MemoSubType, TDBXDataTypes.WideMemoSubType,
    TDBXDataTypes.HBinarySubType, TDBXDataTypes.HMemoSubType, TDBXDataTypes.WideMemoSubType,
    TDBXDataTypes.HBinarySubType,
    0, 0, 0, 0, 0,
    0, 0);
var
  i, iActive: Integer;
  iParType, iSubType: TDBXType;
  iInd, iPrec, iMaxPrecision, iMaxScale, iTmp: Integer;
  iSize, iSrcDataLen, iDestDataLen: LongWord;
  eFieldType: TFieldType;
  eSrcDataType, eDestDataType: TADDataType;
  oParam: TADParam;
  pNilPtr: Pointer;
  oFmtOpts: TADFormatOptions;
  oResOpts: TADResourceOptions;
  eParamType: TParamType;
  iDbxIndex: Integer;
  oDbxParam: TDBXParameter;
  aBytes: TBytes;
  s: AnsiString;
  ws: WideString;
begin
  if (AParams = nil) or (AParams.Count = 0) or (GetMetaInfoKind <> mkNone) then
    Exit;
  oFmtOpts := GetOptions.FormatOptions;
  oResOpts := GetOptions.ResourceOptions;
  iActive := 0;
  for i := 0 to AParams.Count - 1 do begin
    oParam := AParams[i];
    if not oParam.Active then
      Continue;
    eParamType := oParam.ParamType;
    if eParamType = ptUnknown then begin
      oParam.ParamType := oResOpts.DefaultParamType;
      eParamType := oParam.ParamType;
    end;
    if oParam.DataType = ftUnknown then
      ParTypeUnknownError(oParam);

    oFmtOpts.ResolveFieldType(oParam.DataType, oParam.ADDataType, oParam.Size,
      oParam.Precision, eFieldType, iSize, iPrec, eSrcDataType, eDestDataType, False);
    if (AValueIndex > 0) and (oParam.ArrayType = atScalar) then
      iSrcDataLen := 0
    else
      iSrcDataLen := oParam.GetDataSize(AValueIndex);
    // approximating destination data size and allocate buffer
    FBuffer.Extend(iSrcDataLen, iDestDataLen, eSrcDataType, eDestDataType);
    // fill buffer with value, converting it, if required
    if (AValueIndex > 0) and (oParam.ArrayType = atScalar) or
       oParam.IsNulls[AValueIndex] and (eParamType = ptInput) then
      iInd := 1
    else begin
      iInd := 0;
      if eParamType in [ptInput, ptInputOutput] then begin
        oParam.GetData(FBuffer.Ptr, AValueIndex);
        if eSrcDataType <> eDestDataType then
          oFmtOpts.ConvertRawData(eSrcDataType, eDestDataType, FBuffer.Ptr,
            iSrcDataLen, FBuffer.FBuffer, FBuffer.Size, iDestDataLen);
      end
      else begin
        pNilPtr := nil;
        oFmtOpts.ConvertRawData(eSrcDataType, eDestDataType, nil,
          iSrcDataLen, pNilPtr, FBuffer.Size, iDestDataLen);
        if eDestDataType in [dtWideString, dtWideMemo, dtWideHMemo] then
          ADFillChar(FBuffer.Ptr^, iDestDataLen * SizeOf(WideChar), #0)
        else
          ADFillChar(FBuffer.Ptr^, iDestDataLen, #0)
      end;
    end;
    FParamChildPos[iActive] := 0;
    iParType := FldTypeMap[eDestDataType];
    iSubType := FldSubTypeMap[eDestDataType];
    if iParType = TDBXDataTypes.UnknownType then
      ParTypeMapError(oParam);
    iMaxPrecision := iDestDataLen;
    iMaxScale := 0;
    case iParType of
    TDBXDataTypes.BlobType,
    TDBXDataTypes.AnsiStringType,
    TDBXDataTypes.WideStringType,
    TDBXDataTypes.BytesType,
    TDBXDataTypes.VarBytesType:
      begin
        if (iParType = TDBXDataTypes.AnsiStringType) or
           (iParType = TDBXDataTypes.WideStringType) then begin
          if LongWord(oParam.Size) < iDestDataLen - 1 then
            oParam.Size := iDestDataLen - 1;
        end
        else begin
          if LongWord(oParam.Size) < iDestDataLen then
            oParam.Size := iDestDataLen;
        end;
        iMaxPrecision := oParam.Size;
        if (iParType = TDBXDataTypes.WideStringType) or
           (iParType = TDBXDataTypes.BlobType) and (iSubType = TDBXDataTypes.WideMemoSubType) then
          iDestDataLen := iDestDataLen * SizeOf(WideChar);
{ TODO : This mast be reworked. }
(*
        if (iMaxPrecision = 0) and (eParamType = ptInput) and
           GetOptions.FormatOptions.StrsEmpty2Null then
          iInd := 1;
*)          
      end;
    TDBXDataTypes.BcdType:
      begin
        if iInd = 0 then begin
          if oParam.Precision < PBcd(FBuffer.Ptr)^.Precision then
            oParam.Precision := PBcd(FBuffer.Ptr)^.Precision;
          if oParam.NumericScale < PBcd(FBuffer.Ptr)^.SignSpecialPlaces AND $3F then
            oParam.NumericScale := PBcd(FBuffer.Ptr)^.SignSpecialPlaces AND $3F;
        end;
        if oParam.Precision <> 0 then begin
          iMaxPrecision := oParam.Precision;
          iMaxScale := oParam.NumericScale;
        end;
      end;
    TDBXDataTypes.AdtType,
    TDBXDataTypes.ArrayType:
      CalcUnits(AParams, i, iActive, FParamChildPos, iTmp, iMaxScale);
    else
      iMaxPrecision := 0;
      iMaxScale := 0;
      iDestDataLen := 0;
    end;

    iDbxIndex := iActive - FParamChildPos[iActive];
    oDbxParam := FDBXCommand.Parameters[iDbxIndex];
    if oDbxParam = nil then
    begin
      oDbxParam := FDBXCommand.CreateParameter;
      FDBXCommand.Parameters.SetParameter(iDbxIndex, oDbxParam);
    end;

    with oDbxParam do begin
      ChildPosition      := FParamChildPos[iActive];
      ParameterDirection := TDBXParameterDirection(eParamType);
      DataType           := iParType;
      SubType            := iSubType;
      Size               := iDestDataLen;
      Precision          := iMaxPrecision;
      Scale              := iMaxScale;
      if eParamType in [ptInput, ptInputOutput] then begin
        if iInd <> 0 then
          Value.SetNull
        else
          case eDestDataType of
          dtBoolean:
            Value.SetBoolean(PBoolean(FBuffer.Ptr)^);
          dtSByte:
            Value.SetInt16(PShortInt(FBuffer.Ptr)^);
          dtInt16:
            Value.SetInt16(PSmallInt(FBuffer.Ptr)^);
          dtInt32:
            Value.SetInt32(PInteger(FBuffer.Ptr)^);
          dtInt64:
            Value.SetInt64(PInt64(FBuffer.Ptr)^);
          dtByte:
            Value.SetInt16(PByte(FBuffer.Ptr)^);
          dtUInt16:
            Value.SetInt16(PWord(FBuffer.Ptr)^);
          dtUInt32:
            Value.SetInt32(PLongWord(FBuffer.Ptr)^);
          dtUInt64:
            Value.SetInt64(PUInt64(FBuffer.Ptr)^);
          dtDouble:
            Value.SetDouble(PDouble(FBuffer.Ptr)^);
          dtCurrency:
            Value.SetDouble(PCurrency(FBuffer.Ptr)^);
          dtBCD,
          dtFmtBCD:
            Value.SetBCD(PADBcd(FBuffer.Ptr)^);
          dtDateTime:
            Value.SetTimestamp(ADDateTimeToSQLTimeStamp(TimeStampToDateTime(MSecsToTimeStamp(PADDateTimeData(FBuffer.Ptr)^.DateTime))));
          dtTime:
            Value.SetTime(PADDateTimeData(FBuffer.Ptr)^.Time);
          dtDate:
            Value.SetDate(PADDateTimeData(FBuffer.Ptr)^.Date);
          dtDateTimeStamp:
            Value.SetTimestamp(PADSQLTimeStamp(FBuffer.Ptr)^);
          dtAnsiString:
            begin
              SetString(s, PAnsiChar(FBuffer.Ptr), (iDestDataLen - 1) div SizeOf(AnsiChar));
              Value.SetAnsiString(s);
            end;
          dtMemo,
          dtHMemo:
            begin
              SetString(s, PAnsiChar(FBuffer.Ptr), iDestDataLen div SizeOf(AnsiChar));
              Value.SetAnsiString(s);
            end;
          dtWideString:
            begin
              SetString(ws, PWideChar(FBuffer.Ptr), (iDestDataLen - 1) div SizeOf(WideChar));
              Value.SetWideString(ws);
            end;
          dtWideMemo,
          dtWideHMemo:
            begin
              SetString(ws, PWideChar(FBuffer.Ptr), iDestDataLen div SizeOf(WideChar));
              Value.SetWideString(ws);
            end;
          dtByteString,
          dtBlob,
          dtHBlob,
          dtHBFile:
            begin
              SetLength(aBytes, iDestDataLen);
              ADMove(FBuffer.Ptr^, aBytes[0], iDestDataLen);
              Value.SetDynamicBytes(0, aBytes, 0, iDestDataLen);
            end;
          dtGUID:
            Value.SetAnsiString(GUIDToString(PGUID(FBuffer.Ptr)^));
          else
            { dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef, dtParentRowRef,
              dtObject - unsupported }
            ASSERT(False);
          end;
      end;
    end;
    Inc(iActive);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXCommand.GetCmdParamValues(AParams: TADParams);
var
  i, iActive: Integer;
  eFieldType: TFieldType;
  iSize: LongWord;
  iPrec: Integer;
  eSrcDataType, eDestDataType: TADDataType;
  oParam: TADParam;
  oDbxParam: TDBXParameter;
  s: AnsiString;
  ws: WideString;
  aBytes: TBytes;
begin
  if (AParams = nil) or (AParams.Count = 0) or (GetMetaInfoKind <> mkNone) then
    Exit;
  iActive := 0;
  for i := 0 to AParams.Count - 1 do begin
    oParam := AParams[i];
    if not oParam.Active then
      Continue;
    if (oParam.ParamType in [ptOutput, ptResult, ptInputOutput]) and
       (oParam.DataType <> ftCursor) then begin
      oDbxParam := FDBXCommand.Parameters[iActive];
      with oDbxParam do
        if Value.IsNull then
          oParam.Value := Null
        else begin
          case oParam.DataType of
          ftString,
          ftFixedChar,
          ftMemo,
          ftAdt,
          ftOraClob:
            begin
              s := Value.GetAnsiString;
              if Length(s) <> 0 then
                ADMove(s[1], FBuffer.Ptr^, Length(s) * SizeOf(AnsiChar));
              PAnsiChar(LongWord(FBuffer.Ptr) + LongWord(Length(s)) * LongWord(SizeOf(AnsiChar)))^ := #0;
            end;
          ftWideString,
          ftWideMemo:
            begin
              ws := Value.GetWideString;
              if Length(ws) <> 0 then
                ADMove(ws[1], FBuffer.Ptr^, Length(ws) * SizeOf(WideChar));
              PWideChar(LongWord(FBuffer.Ptr) + LongWord(Length(ws)) * LongWord(SizeOf(WideChar)))^ := #0;
            end;
          ftSmallInt,
          ftWord:
            PSmallInt(FBuffer.Ptr)^ := Value.GetInt16;
          ftAutoInc,
          ftInteger:
            PInteger(FBuffer.Ptr)^ := Value.GetInt32;
          ftTime:
            PADDateTimeData(FBuffer.Ptr)^.Time := Value.GetTime;
          ftDate:
            PADDateTimeData(FBuffer.Ptr)^.Date := Value.GetDate;
          ftTimeStamp:
            PADSQLTimeStamp(FBuffer.Ptr)^ := Value.GetTimeStamp;
          ftBCD,
          ftFMTBCD:
            PADBcd(FBuffer.Ptr)^ := Value.GetBcd;
          ftCurrency:
            PCurrency(FBuffer.Ptr)^ := Value.GetDouble;
          ftFloat:
            PDouble(FBuffer.Ptr)^ := Value.GetDouble;
          ftBoolean:
            PBoolean(FBuffer.Ptr)^ := Value.GetBoolean;
          ftBytes,
          ftVarBytes,
          ftBlob,
          ftGraphic..ftTypedBinary,
          ftOraBlob:
            begin
              SetLength(aBytes, FBuffer.Size);
              Value.GetBytes(0, aBytes, 0, FBuffer.Size);
              ADMove(aBytes[1], FBuffer.Ptr^, FBuffer.Size);
            end;
          end;
          GetOptions.FormatOptions.ResolveFieldType(oParam.DataType, oParam.ADDataType,
            oParam.Size, oParam.Precision, eFieldType, iSize, iPrec, eSrcDataType,
            eDestDataType, False);
          if eSrcDataType <> eDestDataType then
            GetOptions.FormatOptions.ConvertRawData(eDestDataType, eSrcDataType,
              FBuffer.Ptr, oParam.Size, FBuffer.FBuffer, FBuffer.Size, iSize);
          if (eSrcDataType in C_AD_VarLenTypes) and (iSize = 0) and
             GetOptions.FormatOptions.StrsEmpty2Null then
            oParam.Clear
          else
            oParam.SetData(FBuffer.Ptr, iSize, -1);
        end;
    end;
    Inc(iActive);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXCommand.InternalPrepare;
var
  sCmd: String;
  rName: TADPhysParsedName;
  oConnMeta: IADPhysConnectionMetadata;
begin
  if GetMetaInfoKind = mkNone then begin
    if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
      sCmd := Trim(GetCommandText());
      if fiMeta in GetFetchOptions.Items then begin
        TADPhysTDBXConnection(FConnectionObj).CreateMetadata(oConnMeta);
        oConnMeta.DecodeObjName(sCmd, rName, Self, [doNormalize, doUnquote]);
        with rName do
          FillStoredProcParams(FCatalog, FSchema, FBaseObject, FObject);
      end;
    end
    else begin
      sCmd := FDbCommandText;
      if GetCommandKind = skUnknown then
        SetCommandKind(skSelect);
    end;
    FDBXCommand := TADPhysTDBXConnection(FConnectionObj).FDbxConnection.CreateCommand;
    if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then
      FDBXCommand.CommandType := TDBXCommandTypes.DbxStoredProcedure
    else
      FDBXCommand.CommandType := TDBXCommandTypes.DbxSQL;
    FDBXCommand.Text := sCmd;
    FDBXCommand.Parameters.SetCount(GetParams.ActiveCount);
    FDBXCommand.Prepare;
  end
  else
    SetCommandKind(skSelect);
  SetLength(FParamChildPos, GetParams.ActiveCount);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXCommand.InternalUnprepare;
begin
  InternalClose;
  FreeAndNil(FDBXReader);
  FreeAndNil(FDBXCommand);
  SetLength(FParamChildPos, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXCommand.Dbx2ADColInfo(ADbxType, ADbxSubType: TDBXType;
  ADbxPrec: Integer; ADbxScale: SmallInt; var AType: TADDataType;
  var AAtrs: TADDataAttributes; var ALen: LongWord; var APrec, AScale: Integer);
begin
  AType := dtUnknown;
  ALen := 0;
  APrec := 0;
  AScale := 0;
  AAtrs := [caSearchable];
  case ADbxType of
  TDBXDataTypes.AnsiStringType:
    begin
      if (ADbxPrec > C_AD_MaxDlp4StrSize) or (ADbxPrec < 0) then begin
        AType := dtMemo;
        Include(AAtrs, caBlobData);
      end
      else begin
        AType := dtAnsiString;
        ALen := ADbxPrec;
        if ADbxSubType = TDBXDataTypes.FixedSubType then
          Include(AAtrs, caFixedLen);
      end;
    end;
  TDBXDataTypes.WideStringType:
    begin
      if (ADbxPrec > C_AD_MaxDlp4StrSize) or (ADbxPrec < 0) then begin
        AType := dtWideMemo;
        Include(AAtrs, caBlobData);
      end
      else begin
        AType := dtWideString;
        ALen := ADbxPrec;
        if ADbxSubType = TDBXDataTypes.FixedSubType then
          Include(AAtrs, caFixedLen);
      end;
    end;
  TDBXDataTypes.DateType:
    AType := dtDate;
  TDBXDataTypes.BlobType:
    begin
      case ADbxSubType of
      TDBXDataTypes.MemoSubType:     AType := dtMemo;
      TDBXDataTypes.WideMemoSubType: AType := dtWideMemo;
      TDBXDataTypes.HMemoSubType:    AType := dtHMemo;
      TDBXDataTypes.BinarySubType:   AType := dtBlob;
      TDBXDataTypes.HBinarySubType:  AType := dtHBlob;
      TDBXDataTypes.BFileSubType:    AType := dtHBFile;
      else                           AType := dtBlob;
      end;
      if ADbxPrec = -1 then
        ALen := $7FFFFFFF
      else
        ALen := ADbxPrec;
      Include(AAtrs, caBlobData);
      Exclude(AAtrs, caSearchable);
    end;
  TDBXDataTypes.BooleanType:
    AType := dtBoolean;
  TDBXDataTypes.Int16Type:
    AType := dtInt16;
  TDBXDataTypes.UInt16Type:
    AType := dtUInt16;
  TDBXDataTypes.Int32Type:
    begin
      AType := dtInt32;
      if ADbxSubType = TDBXDataTypes.AutoIncSubType then begin
        Include(AAtrs, caAutoInc);
        Include(AAtrs, caAllowNull);
      end;
    end;
  TDBXDataTypes.Uint32Type:
    AType := dtUInt32;
  TDBXDataTypes.Int64Type:
    AType := dtInt64;
  TDBXDataTypes.Uint64Type:
    AType := dtUInt64;
  TDBXDataTypes.DoubleType:
    begin
      if ADbxSubType = TDBXDataTypes.MoneySubType then
        AType := dtCurrency
      else
        AType := dtDouble;
    end;
  TDBXDataTypes.BcdType:
    begin
      AScale := Abs(ADbxScale);
      if ADbxPrec < AScale then
        APrec := AScale
      else
        APrec := ADbxPrec;
      with GetFormatOptions do
        if (APrec <= MaxBcdPrecision) and (AScale <= MaxBcdScale) then
          AType := dtBCD
        else
          AType := dtFmtBCD;
    end;
  TDBXDataTypes.BytesType,
  TDBXDataTypes.VarBytesType:
    begin
      if (ADbxPrec > C_AD_MaxDlp4StrSize) or (ADbxPrec < 0) then begin
        AType := dtBlob;
        Include(AAtrs, caBlobData);
      end
      else begin
        AType := dtByteString;
        ALen := ADbxPrec;
        if ADbxType = TDBXDataTypes.BytesType then
          Include(AAtrs, caFixedLen);
      end;
    end;
  TDBXDataTypes.TimeType:
    AType := dtTime;
  TDBXDataTypes.TimeStampType:
    AType := dtDateTimeStamp;
  TDBXDataTypes.CursorType:
    begin
      AType := dtCursorRef;
      Include(AAtrs, caAllowNull);
      Exclude(AAtrs, caSearchable);
    end;
  TDBXDataTypes.AdtType:
    begin
      AType := dtRowRef;
      Exclude(AAtrs, caSearchable);
    end;
  TDBXDataTypes.ArrayType:
    begin
      AType := dtArrayRef;
      Exclude(AAtrs, caSearchable);
    end;
  TDBXDataTypes.RefType:
    begin
      AType := dtRowRef;
      Exclude(AAtrs, caSearchable);
    end;
  TDBXDataTypes.TableType:
    begin
      AType := dtRowSetRef;
      Exclude(AAtrs, caSearchable);
    end;
  // AdtNestedTableSubType
  // AdtDateSubType
  // OracleTimeStampSubType
  // OracleIntervalSubType
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXCommand.InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean;
begin
  Result := OpenBlocked;
  if Result then
    if ATabInfo.FSourceID = -1 then begin
      ATabInfo.FSourceName := '';
      ATabInfo.FSourceID := 1;
      ATabInfo.FOriginName := GetCommandText;
      FColumnIndex := 1;
    end
    else begin
      ATabInfo.FSourceName := '';
      ATabInfo.FSourceID := ATabInfo.FSourceID;
      ATabInfo.FOriginName := FDBXReader.ValueType[ATabInfo.FSourceID - 1].Name;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXCommand.InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  iCount: Integer;
  wType, wSubType: TDBXType;
  iPrec, iScale: Integer;
  oValType: TDBXValueType;
begin
  with AColInfo do begin
    if FParentTableSourceID <> -1 then begin
      oValType := FDBXReader.ValueType[FParentTableSourceID - 1];
      wType := oValType.DataType;
      if (wType = TDBXDataTypes.CursorType) or (wType = TDBXDataTypes.AdtType) or
         (wType = TDBXDataTypes.ArrayType) or (wType = TDBXDataTypes.RefType) or
         (wType = TDBXDataTypes.TableType) then begin
        iPrec := oValType.Precision;
        if FColumnIndex > FParentTableSourceID + Integer(iPrec) then begin
          Result := False;
          Exit;
        end;
      end
      else begin;
        Result := False;
        Exit;
      end;
    end
    else begin
      iCount := FDBXReader.ColumnCount;
      if FColumnIndex > iCount then begin
        Result := False;
        Exit;
      end;
    end;

    oValType := FDBXReader.ValueType[FColumnIndex - 1];
    FSourceName := oValType.Name;
    FSourceID := FColumnIndex;
    FOriginName := FSourceName;
    wType := oValType.DataType;
    wSubType := oValType.SubType;

    if (wType = TDBXDataTypes.AnsiStringType) or (wType = TDBXDataTypes.WideStringType) or
       (wType = TDBXDataTypes.BytesType) or (wType = TDBXDataTypes.VarBytesType) or
       (wType = TDBXDataTypes.BcdType) then begin
      iPrec := oValType.Precision;
      if ((wType = TDBXDataTypes.AnsiStringType) or (wType = TDBXDataTypes.WideStringType)) and
         GetOptions.FormatOptions.StrsDivLen2 then
        iPrec := iPrec div 2;
    end
    else
      iPrec := 0;

    if (wType = TDBXDataTypes.BcdType) or (wType = TDBXDataTypes.AdtType) or
       (wType = TDBXDataTypes.ArrayType) then
      iScale := oValType.Scale
    else
      iScale := 0;
    Dbx2ADColInfo(wType, wSubType, iPrec, iScale, FType, FAttrs, FLen, FPrec, FScale);

    FForceRemOpts := [];
    FForceAddOpts := [];
    if oValType.Nullable then
      Include(FAttrs, caAllowNull);
    if oValType.ReadOnly then
      Include(FAttrs, caReadOnly);
    if oValType.Searchable then
      Include(FAttrs, caSearchable);
    if oValType.AutoIncrement then begin
      Include(FAttrs, caAutoInc);
      Include(FAttrs, caAllowNull);
      Include(FForceAddOpts, coAfterInsChanged);
    end;

    if (wType = TDBXDataTypes.AdtType) or (wType = TDBXDataTypes.ArrayType) or
       (wType = TDBXDataTypes.RefType) or (wType = TDBXDataTypes.TableType) then
      FTypeName := FDBXReader.GetObjectTypeName(FColumnIndex - 1)
    else
      FTypeName := '';
  end;
  Inc(FColumnIndex);
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXCommand.InternalOpen: Boolean;
var
  i, wCols: Word;
  wType: TDBXType;
  siPrec: SmallInt;
  oValType: TDBXValueType;
begin
  if FDBXReader = nil then begin
    if GetMetaInfoKind = mkNone then begin
      SetCmdParamValues(GetParams, 0);
      if TADPhysTDBXConnection(FConnectionObj).FDbxConnection.DatabaseMetaData.SupportsRowSetSize then
        FDBXCommand.RowSetSize := GetFetchOptions.ActualRowsetSize;
      FDBXReader := FDBXCommand.ExecuteQuery;
      if GetState = csAborting then
        InternalClose
      else
        GetCmdParamValues(GetParams);
    end
    else
      OpenMetaInfo;
    if FDBXReader <> nil then begin
      // check buffer space
      wCols := FDBXReader.ColumnCount;
      for i := 0 to wCols - 1 do begin
        oValType := FDBXReader.ValueType[i];
        wType := oValType.DataType;
        case wType of
        TDBXDataTypes.AnsiStringType,
        TDBXDataTypes.WideStringType,
        TDBXDataTypes.BytesType,
        TDBXDataTypes.VarBytesType:
          begin
            siPrec := oValType.Precision;
            // used for AnsiStr -> WideStr conversion, otherwise
            // buffer will have enough size
            FBuffer.Check(siPrec * SizeOf(WideChar));
          end;
        end;
      end;
    end;
  end;
  Result := (FDBXReader <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXCommand.InternalClose;
begin
  FreeAndNil(FDBXReader);
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXCommand.InternalNextRecordSet: Boolean;
begin
  FreeAndNil(FDBXReader);
  FDBXReader := FDBXCommand.GetNextReader;
  Result := FDBXReader <> nil;
  if Result then
    GetCmdParamValues(GetParams);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXCommand.InternalExecute(ATimes, AOffset: Integer;
  var ACount: Integer);
var
  i: Integer;
  iAffected: LongWord;
begin
  ACount := 0;
  if GetMetaInfoKind = mkNone then
    for i := AOffset to ATimes - 1 do begin
      SetCmdParamValues(GetParams, i);
      try
        try
          FDBXReader := FDBXCommand.executeQuery;
        except
          on E: ETDBXNativeException do begin
            E.Errors[0].RowIndex := i;
            raise;
          end;
        end;
      finally
        FreeAndNil(FDBXReader);
      end;
      if GetState <> csAborting then begin
        GetCmdParamValues(GetParams);
        iAffected := FDBXCommand.RowsAffected;
        if iAffected = $FFFFFFFF then
          iAffected := 0;
        Inc(ACount, iAffected);
      end
      else
        Break;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXCommand.FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
var
  oRow: TADDatSRow;
  j: Integer;
  llIsBlank: LongBool;
  C: Currency;
  pData: Pointer;
  iLen: LongWord;
  liBlobLen: Int64;
  oTab: TADDatSTable;
  oFmtOpts: TADFormatOptions;
  ws: WideString;
  s: AnsiString;
  oVal: TDBXValue;
  aBuff: TBytes;

  procedure DoWideString(AFixedLen: Boolean);
  begin
    ws := oVal.GetWideString;
    pData := PWideChar(ws);
    iLen := Length(ws);
    if AFixedLen and GetOptions.FormatOptions.StrsTrim then
      while (iLen > 0) and (PWideChar(pData)[iLen - 1] = ' ') do
        Dec(iLen);
    if (iLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
      llIsBlank := True;
  end;

  procedure DoAnsiString(AFixedLen: Boolean);
  begin
    s := oVal.GetAnsiString;
    pData := PAnsiChar(s);
    iLen := Length(s);
    if AFixedLen and GetOptions.FormatOptions.StrsTrim then
      while (iLen > 0) and (PChar(pData)[iLen - 1] = ' ') do
        Dec(iLen);
    if (iLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
      llIsBlank := True;
  end;

begin
  oRow := ATable.NewRow(True);
  oFmtOpts := GetFormatOptions;
  try
    for j := 0 to ATable.Columns.Count - 1 do
      with ATable.Columns[j] do
        if (SourceID > 0) and CheckFetchColumn(SourceDataType) then begin
          llIsBlank :=
            not (SourceDataType in [dtMemo, dtBlob, dtHMemo, dtHBlob, dtHBFile, dtWideMemo, dtWideHMemo]) and
            FDBXReader.Value[SourceID - 1].IsNull;
          if not llIsBlank then begin
            pData := FBuffer.Ptr;
            iLen := Size;
            oVal := FDBXReader.Value[SourceID - 1];
            case SourceDataType of
            dtWideString:
              DoWideString(caFixedLen in Attributes);
            dtAnsiString:
              DoAnsiString(caFixedLen in Attributes);
            dtDate:
              PADDateTimeData(pData)^.Date := oVal.GetDate;
            dtTime:
              PADDateTimeData(pData)^.Time := oVal.GetTime;
            dtDateTimeStamp:
              PADSQLTimeStamp(pData)^ := oVal.GetTimeStamp;
            dtBoolean:
              PBoolean(pData)^ := oVal.GetBoolean;
            dtInt16,
            dtUInt16:
              PSmallInt(pData)^ := oVal.GetInt16;
            dtInt32,
            dtUInt32:
              PInteger(pData)^ := oVal.GetInt32;
            dtInt64,
            dtUInt64:
              PInt64(pData)^ := oVal.GetInt64;
            dtCurrency:
              begin
                C := oVal.GetDouble;
                pData := @C;
              end;
            dtDouble:
              PDouble(pData)^ := oVal.GetDouble;
            dtByteString:
              begin
                SetLength(aBuff, oVal.GetValueSize);
                pData := @aBuff[0];
                iLen := FDBXReader.ByteReader.GetBytes(SourceID - 1, 0, aBuff, 0,
                  oVal.GetValueSize, llIsBlank);
                if not llIsBlank and not (caFixedLen in Attributes) and
                   (iLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
                  llIsBlank := True;
              end;
            dtBCD,
            dtFmtBCD:
              PADBcd(pData)^ := oVal.GetBcd;
            dtMemo,
            dtBlob,
            dtHMemo,
            dtHBlob,
            dtHBFile,
            dtWideMemo,
            dtWideHMemo:
              if fiBlobs in GetFetchOptions.Items then
                case FDBXReader.ValueType[SourceID - 1].DataType of
                TDBXDataTypes.AnsiStringType:
                  DoAnsiString(caFixedLen in Attributes);
                TDBXDataTypes.WideStringType:
                  DoWideString(caFixedLen in Attributes);
                else
                  FDBXReader.ByteReader.GetByteLength(SourceID - 1, liBlobLen, llIsBlank);
                  if not llIsBlank and
                     (liBlobLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
                    llIsBlank := True;
                  if not llIsBlank then begin
                    SetLength(aBuff, liBlobLen);
                    pData := @aBuff[0];
                    iLen := FDBXReader.ByteReader.GetBytes(SourceID - 1, 0, aBuff, 0,
                      liBlobLen, llIsBlank);
                  end;
                end
              else
                continue;
            dtRowRef, dtArrayRef:
              begin
                oTab := NestedTable;
                FetchRow(oTab, oRow);
              end;
            dtRowSetRef, dtCursorRef:
              if fiDetails in GetFetchOptions.Items then begin
                { TODO -cDBExp : Check for RowRef (ADT) }
                ASSERT(False);
              end;
            else
              ASSERT(False);
            end;
          end;
          if not (SourceDataType in [dtRowRef, dtArrayRef, dtRowSetRef, dtCursorRef]) then begin
            if llIsBlank then
              oRow.SetData(j, nil, 0)
            else begin
              oFmtOpts.ConvertRawData(SourceDataType, DataType, pData,
                iLen, pData, FBuffer.Size, iLen);
              oRow.SetData(j, pData, iLen);
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
function TADPhysTDBXCommand.InternalFetchRowSet(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowsetSize: LongWord): LongWord;
var
  i: LongWord;
begin
  Result := 0;
  for i := 1 to ARowsetSize do begin
    if not FDBXReader.Next then
      Break;
    if GetMetaInfoKind = mkNone then begin
      FetchRow(ATable, AParentRow);
      Inc(Result);
    end
    else
      if FetchMetaRow(ATable, AParentRow) then
        Inc(Result);
  end;
end;

{-------------------------------------------------------------------------------}
// Meta data handling

procedure TADPhysTDBXCommand.OpenMetaInfo;
var
  sCmd: WideString;

  function GetObjWildcard: WideString;
  var
    rName: TADPhysParsedName;
    oConnMeta: IADPhysConnectionMetadata;
  begin
    TADPhysTDBXConnection(FConnectionObj).CreateMetadata(oConnMeta);
    oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self, []);
    if rName.FCatalog = '' then
      rName.FCatalog := GetCatalogName;
    if rName.FSchema = '' then
      rName.FSchema := GetSchemaName;
    if rName.FObject = '' then
      rName.FObject := GetWildcard;
    Result := oConnMeta.EncodeObjName(rName, Self, [eoQuote, eoNormalize]);
  end;

begin
  FDBXCommand := TADPhysTDBXConnection(FConnectionObj).FDbxConnection.CreateCommand;
  try
    case GetMetaInfoKind of
    mkTables:
      begin
        sCmd := TDBXMetaDataCommands.GetTables + ' ' + GetObjWildcard + ' ';
        if tkTable in GetTableKinds then
          sCmd := sCmd + TDBXMetaDataTableTypes.Table + ';';
        if tkView in GetTableKinds then
          sCmd := sCmd + TDBXMetaDataTableTypes.View + ';';
        if tkSynonym in GetTableKinds then
          sCmd := sCmd + TDBXMetaDataTableTypes.Synonym + ';';
        if (osSystem in GetObjectScopes) and (tkTable in GetTableKinds) then
          sCmd := sCmd + TDBXMetaDataTableTypes.SystemTable + ';';
      end;
    mkTableFields:
      sCmd := TDBXMetaDataCommands.GetColumns + ' ' + GetObjWildcard;
    mkIndexes:
      sCmd := TDBXMetaDataCommands.GetIndexes + ' ' + GetObjWildcard;
    mkIndexFields:
      sCmd := TDBXMetaDataCommands.GetIndexColumns + ' ' + GetObjWildcard;
    mkPrimaryKey:
      sCmd := TDBXMetaDataCommands.GetIndexes + ' ' + GetObjWildcard;
    mkPrimaryKeyFields:
      sCmd := TDBXMetaDataCommands.GetIndexColumns + ' ' + GetObjWildcard;
    mkForeignKeys:
      sCmd := TDBXMetaDataCommands.GetForeignKeys + ' ' + GetObjWildcard;
    mkForeignKeyFields:
      sCmd := TDBXMetaDataCommands.GetForeignKeyColumns + ' ' + GetObjWildcard;
    mkPackages:
      sCmd := TDBXMetaDataCommands.GetPackages + ' ' + GetObjWildcard;
    mkProcs:
      sCmd := TDBXMetaDataCommands.GetProcedures + ' ' + GetObjWildcard;
    mkProcArgs:
      sCmd := TDBXMetaDataCommands.GetProcedureParameters + ' ' + GetObjWildcard;
    end;
    FDBXCommand.CommandType := TDBXCommandTypes.DbxMetaData;
    FDBXCommand.Text := sCmd;
    try
      FDBXReader := FDBXCommand.ExecuteQuery;
    except
      { TODO : Remove that, when "Invalid show command" issues will be resovled }
      FDBXReader := nil;
    end;
  finally
    FreeAndNil(FDBXCommand);
  end;
end;

{-------------------------------------------------------------------------------}
type
  { TODO : Must be replaced with TDBX constants }
  TDBXIndexType = class
    const
      NonUnique                = $0001;
      Unique                   = $0002;
      PrimaryKey               = $0004;
  end;

function TADPhysTDBXCommand.FetchMetaRow(ATable: TADDatSTable;
  AParentRow: TADDatSRow): Boolean;
var
  oRow: TADDatSRow;
  i, iDbxType, iDbxPrec, iDbxTableType, iDbxProcType: Integer;
  siDbxScale: SmallInt;
  wDbxDataType, wDbxSubType, wDbxNullable, wDbxParamType: Word;
  eType: TADDataType;
  eAttrs: TADDataAttributes;
  iLen: LongWord;
  iPrec, iScale: Integer;
  eProcType: TADPhysProcedureKind;
  eTableKind: TADPhysTableKind;
  eScope: TADPhysObjectScope;
  eParamType: TParamType;
  eIndexKind: TADPhysIndexKind;
  sSchema: String;
  lDeleteRow: Boolean;
  llIsBlank: LongBool;
  oConnMeta: IADPhysConnectionMetadata;
  rName, rName2: TADPhysParsedName;

  procedure SetData(ACrsColIndex, ARowColIndex: Integer);
  var
    oVal: TDBXValue;
    s: AnsiString;
  begin
    oVal := FDBXReader.Value[ACrsColIndex - 1];
    if oVal.IsNull then
      oRow.SetData(ARowColIndex, nil, 0)
    else
      case oRow.Table.Columns.ItemsI[ARowColIndex].DataType of
      dtInt16:
        begin
          PSmallInt(FBuffer.Ptr)^ := oVal.GetInt16;
          oRow.SetData(ARowColIndex, FBuffer.Ptr, 0);
        end;
      dtInt32:
        begin
          PInteger(FBuffer.Ptr)^ := oVal.GetInt32;
          oRow.SetData(ARowColIndex, FBuffer.Ptr, 0);
        end;
      dtAnsiString:
        begin
          if oVal.ValueType.DataType = TDBXDataTypes.WideStringType then
            s := oVal.GetWideString
          else
            s := oVal.GetAnsiString;
          oRow.SetData(ARowColIndex, PAnsiChar(s), Length(s));
        end;
      else
        ASSERT(False);
      end;
  end;

  procedure GetIndexKind(ACrsColIndex: Integer; var AIndexKind: TADPhysIndexKind; var ADeleteRow: Boolean);
  var
    wDbxIndexKind: Word;
  begin
    wDbxIndexKind := Word(FDBXReader.Value[ACrsColIndex].GetInt16);
    if wDbxIndexKind and TDBXIndexType.PrimaryKey <> 0 then
      AIndexKind := ikPrimaryKey
    else if wDbxIndexKind and TDBXIndexType.Unique <> 0 then
      AIndexKind := ikUnique
    else
      AIndexKind := ikNonUnique;
    if GetMetaInfoKind in [mkPrimaryKey, mkPrimaryKeyFields] then begin
      if TADPhysTDBXConnection(FConnectionObj).GetRDBMSKindFromAlias = mkMSAccess then begin
        if not (AIndexKind in [ikUnique, ikPrimaryKey]) then
          ADeleteRow := True
        else
          AIndexKind := ikPrimaryKey;
      end
      else if AIndexKind <> ikPrimaryKey then
        ADeleteRow := True;
    end;
  end;

  procedure GetScope(ARowColIndex: Integer; var AScope: TADPhysObjectScope);
  begin
    if AnsiCompareText(VarToStr(oRow.GetData(ARowColIndex, rvDefault)),
                       TADPhysTDBXConnection(FConnectionObj).FDefaultSchemaName) = 0 then
      AScope := osMy
    else
      AScope := osOther;
  end;

begin
  lDeleteRow := False;
  oRow := ATable.NewRow(True);
  try
    FConnection.CreateMetadata(oConnMeta);
    case GetMetaInfoKind of
    mkTables:
      begin
        SetData(1, 0);
        SetData(2, 1);
        SetData(3, 2);
        SetData(4, 3);
        iDbxTableType := FDBXReader.Value[5 - 1].GetInt32;
        GetScope(2, eScope);
{ TODO : Must be replaced with TDBX constants }        
(*
        if eSQLTable and iDbxTableType <> 0 then
          eTableKind := tkTable
        else if eSQLView and iDbxTableType <> 0 then
          eTableKind := tkView
        else if eSQLSynonym and iDbxTableType <> 0 then
          eTableKind := tkSynonym
        else if eSQLTempTable and iDbxTableType <> 0 then
          eTableKind := tkTempTable
        else if eSQLLocal and iDbxTableType <> 0 then
          eTableKind := tkLocalTable
        else if eSQLSystemTable and iDbxTableType <> 0 then begin
          eTableKind := tkTable;
          eScope := osSystem;
        end
        else
*)
          eTableKind := tkTable;
        oRow.SetData(4, SmallInt(eTableKind));
        oRow.SetData(5, SmallInt(eScope));
      end;
    mkTableFields:
      begin
        SetData(1, 0);
        SetData(2, 1);
        SetData(3, 2);
        SetData(4, 3);
        SetData(5, 4);
        SetData(6, 5);
        SetData(9, 7);
        iDbxType := FDBXReader.Value[7 - 1].GetInt32;
        wDbxDataType := FDBXReader.Value[8 - 1].GetInt16;
        wDbxSubType := FDBXReader.Value[10 - 1].GetInt16;
        iDbxPrec := FDBXReader.Value[11 - 1].GetInt32;
        siDbxScale := FDBXReader.Value[12 - 1].GetInt16;
        wDbxNullable := FDBXReader.Value[14 - 1].GetInt16;
        Dbx2ADColInfo(wDbxDataType, wDbxSubType, iDbxPrec, siDbxScale,
          eType, eAttrs, iLen, iPrec, iScale);
        if wDbxNullable <> 0 then
          Include(eAttrs, caAllowNull);
{ TODO : Must be replaced with TDBX constants }          
(*
        if iDbxType and eSQLRowId <> 0 then
          Include(eAttrs, caROWID);
        if iDbxType and eSQLRowVersion <> 0 then
          Include(eAttrs, caRowVersion);
        if iDbxType and eSQLAutoIncr <> 0 then
          Include(eAttrs, caAutoInc);
        if iDbxType and eSQLDefault <> 0 then
          Include(eAttrs, caDefault);
*)
        oRow.SetData(6, SmallInt(eType));
        oRow.SetData(8, PWord(@eAttrs)^);
        oRow.SetData(9, iPrec);
        oRow.SetData(10, iScale);
        oRow.SetData(11, iLen);
      end;
    mkPackages:
      begin
        oRow.SetData(0, ATable.Rows.Count);
        SetData(2, 1);
        SetData(3, 2);
        SetData(4, 3);
        // ???? Oracle specific
        sSchema := oRow.GetData(2, rvDefault);
        if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
            (sSchema, TADPhysTDBXConnection(FConnectionObj).GetConnectionDef.AsString[szUSERNAME]) = 0 then
          eScope := osMy
        else if (sSchema = 'SYS') or (sSchema = 'SYSTEM') then
          eScope := osSystem
        else
          eScope := osOther;
        oRow.SetData(4, Integer(eScope));
        if not ((osMy in GetObjectScopes) and (eScope = osMy) or
            (osSystem in GetObjectScopes) and (eScope = osSystem) or
            (osOther in GetObjectScopes) and (eScope = osOther)) then
          lDeleteRow := True;
      end;
    mkProcs:
      begin
        oRow.SetData(0, ATable.Rows.Count);
        SetData(2, 1);
        SetData(3, 2);
        oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self, [doNormalize, doUnquote]);
        if rName.FBaseObject <> '' then
          oRow.SetData(3, rName.FBaseObject);
        SetData(4, 4);
        oRow.SetData(5, nil, 0);
        iDbxProcType := FDBXReader.Value[5 - 1].GetInt32;
{ TODO : Must be replaced with TDBX constants }        
(*
        if iDbxProcType and eSQLPackage <> 0 then
          lDeleteRow := True
        else begin
*)
          GetScope(2, eScope);
(*
          if iDbxProcType and eSQLProcedure <> 0 then
            eProcType := pkProcedure
          else if iDbxProcType and eSQLFunction <> 0 then
            eProcType := pkFunction
          else if iDbxProcType and eSQLSysProcedure <> 0 then begin
            eProcType := pkProcedure;
            eScope := osSystem;
          end
          else
*)
            eProcType := pkProcedure;
          oRow.SetData(6, Integer(eProcType));
          oRow.SetData(7, SmallInt(eScope));
          SetData(6, 8);
          SetData(7, 9);
//        end;
      end;
    mkProcArgs:
      begin
        SetData(1, 0);                                      // RECNO
        SetData(2, 1);                                      // CATALOG_NAME
        SetData(3, 2);                                      // SCHEMA_NAME
        oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self, [doNormalize, doUnquote]);
        if rName.FBaseObject <> '' then
          oRow.SetData(3, rName.FBaseObject);
        SetData(4, 4);                                      // PROCEDURE_NAME
        oRow.SetData(5, nil, 0);                            // OVERLOAD
        SetData(5, 6);                                      // PARAM_NAME
        SetData(6, 7);                                      // PARAM_POSITION
        wDbxParamType := FDBXReader.Value[7 - 1].GetInt16;  // PARAM_TYPE
        case TDBXParameterDirection(wDbxParamType) of
        TDBXParameterDirections.InParameter:     eParamType := ptInput;
        TDBXParameterDirections.OutParameter:    eParamType := ptOutput;
        TDBXParameterDirections.InOutParameter:  eParamType := ptInputOutput;
        TDBXParameterDirections.ReturnParameter: eParamType := ptResult;
        else                                     eParamType := ptUnknown;
        end;
        oRow.SetData(8, Integer(eParamType));
        SetData(10, 10);
        wDbxDataType := FDBXReader.Value[8 - 1].GetInt16;  // PARAM_DATATYPE
        wDbxSubType := FDBXReader.Value[9 - 1].GetInt16;   // PARAM_SUBTYPE
        iDbxPrec := FDBXReader.Value[12 - 1].GetInt32;     // PARAM_PRECISION
        siDbxScale := FDBXReader.Value[13 - 1].GetInt16;   // PARAM_SCALE
        wDbxNullable := FDBXReader.Value[14 - 1].GetInt16; // PARAM_NULLABLE
        Dbx2ADColInfo(wDbxDataType, wDbxSubType, iDbxPrec, siDbxScale,
          eType, eAttrs, iLen, iPrec, iScale);
        if wDbxNullable <> 0 then
          Include(eAttrs, caAllowNull);
        oRow.SetData(9, SmallInt(eType));
        oRow.SetData(11, PWord(@eAttrs)^);
        oRow.SetData(12, iPrec);
        oRow.SetData(13, iScale);
        oRow.SetData(14, iLen);
      end;
    mkIndexes,
    mkPrimaryKey:
      begin
        oRow.SetData(0, ATable.Rows.Count);
        SetData(2, 1);
        SetData(3, 2);
        SetData(4, 3);
        SetData(5, 4);
        SetData(6, 5);
        GetIndexKind(9 {8???}, eIndexKind, lDeleteRow);
        oRow.SetData(6, SmallInt(eIndexKind));
        if (GetMetaInfoKind = mkPrimaryKey) and (ATable.Rows.Count > 0) then
          lDeleteRow := True;
        if not lDeleteRow then
          for i := 0 to ATable.Rows.Count - 1 do
            if ATable.Rows[i].GetData(4, rvDefault) = oRow.GetData(4, rvDefault) then begin
              lDeleteRow := True;
              Break;
            end;
      end;
    mkIndexFields,
    mkPrimaryKeyFields:
      begin
        oRow.SetData(0, ATable.Rows.Count);
        SetData(2, 1); // catalog_name
        SetData(3, 2); // schema_name
        SetData(4, 3); // table_name
        SetData(5, 4); // index_name
        SetData(6, 5); // column_name
        SetData(7, 6); // column_position
        SetData(10, 7); // sort_order
        SetData(11, 8); // filter
        GetIndexKind(9 {8???}, eIndexKind, lDeleteRow);
        if not lDeleteRow then
          if GetMetaInfoKind = mkIndexFields then begin
            oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self,
              [doNormalize, doUnquote]);
            oConnMeta.DecodeObjName(Trim(oRow.GetData(4, rvDefault)), rName2, Self,
              [doNormalize, doUnquote]);
            lDeleteRow := (AnsiCompareText(rName.FObject, rName2.FObject) <> 0);
          end
          else
            lDeleteRow := eIndexKind <> ikPrimaryKey;
      end;
    end;
    if lDeleteRow then begin
      oRow.Free;
      Result := False;
    end
    else begin
      if AParentRow <> nil then begin
        oRow.ParentRow := AParentRow;
        AParentRow.Fetched[ATable.Columns.ParentCol] := True;
      end;
      ATable.Rows.Add(oRow);
      Result := True;
    end;
  except
    oRow.Free;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysTDBXConnection);

finalization
//  ADPhysManagerObj.UnRegisterPhysConnectionClass(TADPhysTDBXConnection);

end.
