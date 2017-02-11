{-------------------------------------------------------------------------------}
{ AnyDAC dbExpress driver                                                       }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADPhysDBExp;

interface

uses
  SysUtils, DBXpress,
  daADStanError,
  daADPhysIntf, daADPhysManager;

type
{$IFDEF AnyDAC_D10}
  SQLChar = WideChar;
  PSQLChar = PWideChar;
  SQLString = WideString;
{$ELSE}
  SQLChar = AnsiChar;
  PSQLChar = PAnsiChar;
  SQLString = AnsiString;
{$ENDIF}

  EDBXNativeException = class;
  TADPhysDBXDriverLink = class;
  IADPhysDBXConnection = interface;

  EDBXNativeException = class(EADDBEngineException)
  end;

  TADPhysDBXDriverLink = class(TADPhysDriverLinkBase)
  end;

  IADPhysDBXConnection = interface(IADPhysConnection)
    ['{3E9B315B-F456-4175-A864-B2573C4A2120}']
    // private
    function GetDBXConnection: {$IFDEF AnyDAC_D10} ISQLConnection30 {$ELSE}
      ISQLConnection {$ENDIF};
    // public
    procedure Check(AResultCode: SQLResult; AExclNotSup: Boolean = False);
    property DBXConnection: {$IFDEF AnyDAC_D10} ISQLConnection30 {$ELSE}
      ISQLConnection {$ENDIF} read GetDBXConnection;
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
{$IFDEF AnyDAC_D10}
  DBCommonTypes,
{$ENDIF}
  Variants, Classes, DB, FmtBcd, IniFiles, SqlConst,
  daADStanIntf, daADStanParam, daADStanConst, daADStanUtil, daADStanOption,
    daADStanFactory, daADStanResStrs,
  daADDatSManager,
  daADPhysCmdGenerator, daADPhysDBExpReg, daADPhysConnMeta, daADPhysMSAccMeta,
    daADPhysMSSQLMeta, daADPhysMySQLMeta, daADPhysOraclMeta, daADPhysDb2Meta,
    daADPhysASAMeta, daADPhysADSMeta, daADPhysDBExpMeta;

const
{$IFDEF AnyDAC_D10}
  fldstUNICODE = fldstWIDEMEMO;
  CSQLCharLen = SizeOf(WideChar);
{$ELSE}
  CSQLCharLen = SizeOf(AnsiChar);
{$ENDIF}

type
  TADPhysDBXLib = class;
  TADPhysDBXDriver = class;
  TADPhysDBXConnection = class;
  TADPhysDBXCommand = class;

  TADPhysDBXLibRec = class(TObject)
    FLinked: Boolean;
    FDllHandle: THandle;
    FDllEntry: TADPhysDBXGetSQLDriverProc;
    FClients: Integer;
  end;

  TADPhysDBXLib = class(TObject)
  private
    FOwningObj: TObject;
    FLock: TADMREWSynchronizer;
    FDrivers: IADStanDefinitions;
    FLoadedDrivers: TStringList;
    class function GetDriverRegistryFile(DesignMode: Boolean = False): string;
    class function GetRegistryFile(const Setting, Default: string;
      DesignMode: Boolean): string;
    function FindLoadedDriver(const ADriverName, ALibName,
      AGetFunc: String; var AIndex: Integer;
      var AKey: String): TADPhysDBXLibRec;
    function GetDrivers: IADStanDefinitions;
  public
    constructor Create(AOwningObj: TObject = nil);
    destructor Destroy; override;
    function AllocDriverIntf(const ADriverName, ALibName, AGetFunc,
      AVendLib, AResourceFile: String; out AIntf: ISQLDriver): SQLResult;
    procedure ResolveDriverInfo(const ADriverName: String; var ALibName,
      AGetFunc, AVendLib: String; var ALinked: Boolean);
    procedure ReleaseDriverIntf(const ADriverName, ALibName, AGetFunc,
      AVendLib: String; AOnDisconnect: Boolean; var AIntf: ISQLDriver);
    procedure RegisterLinkedDriver(const ADriverName: String;
      AEntry: TADPhysDBXGetSQLDriverProc);
    procedure UnRegisterLinkedDriver(const ADriverName: String);
    property OwningObj: TObject read FOwningObj;
  end;

  TADPhysDBXDriver = class(TADPhysDriver)
  private
    FDesignMode: Boolean;
    FCfgFile: String;
    FLib: TADPhysDBXLib;
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
  TADPhysDBXConnection = class(TADPhysConnection, IADPhysDBXConnection)
  private
    FDriverName: String;
    FDriverLinked: Boolean;
    FLibraryName: String;
    FVendorLib: String;
    FGetDriverFunc: String;
    FLastError: String;
    FConnected: Boolean;
    FBorlMSSQLDriver: Boolean;
    FBorlMySQLDriver: Boolean;
    FOpenODBCDriver: Boolean;
    procedure CheckConnParams;
    procedure GetConnInterfaces;
    procedure SetConnParams;
    procedure DoConnect;
    procedure SQLError(AResultCode: SQLResult; AExSource: TADPhysDBXExceptionType;
      const AIntf: IInterface; AInitiator: TObject = nil);
    procedure DirectExec(const ASQL: String);
    procedure CreateMetaIntf(out AMeta: {$IFDEF AnyDAC_D10} ISQLMetaData30 {$ELSE}
      ISQLMetaData {$ENDIF});
{$IFDEF AnyDAC_MONITOR}
    procedure RegisterCallback(AValue: Boolean);
    procedure DoTraceVendor(ATraceCat: TRACECat; const AMsg: String);
{$ENDIF}
    function GetRDBMSKindFromAlias: TADRDBMSKind;
    function GetTxIsolationLevel: TTransIsolationLevel;
  protected
    FDbxDriver: ISQLDriver;
    FDbxConnection: {$IFDEF AnyDAC_D10} ISQLConnection30 {$ELSE} ISQLConnection {$ENDIF};
    FRdbmsKind: TADRDBMSKind;
    procedure Check(AResultCode: SQLResult; AExclNotSup: Boolean = False);
    procedure InternalConnect; override;
    procedure InternalDisconnect; override;
    function InternalCreateCommand: TADPhysCommand; override;
    procedure InternalTxBegin(ATxID: LongWord); override;
    procedure InternalTxCommit(ATxID: LongWord); override;
    procedure InternalTxRollback(ATxID: LongWord); override;
    procedure InternalTxSetSavepoint(const AName: String); override;
    procedure InternalTxRollbackToSavepoint(const AName: String); override;
    procedure InternalTxCommitSavepoint(const AName: String); override;
    procedure InternalTxChanged; override;
    function InternalCreateMetadata: TObject; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand):
      TADPhysCommandGenerator; override;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; override;
{$ENDIF}
    procedure GetItem(AIndex: Integer; var AName: String;
      var AValue: Variant; var AKind: TADDebugMonitorAdapterItemKind); override;
    function GetItemCount: Integer; override;
    // IADPhysDBXConnection
    function GetDBXConnection: {$IFDEF AnyDAC_D10} ISQLConnection30 {$ELSE} ISQLConnection {$ENDIF};
  public
    constructor Create(ADriverObj: TADPhysDriver; const ADriver: IADPhysDriver;
      AConnHost: TADPhysConnectionHost); override;
    class function GetDriverClass: TADPhysDriverClass; override;
  end;

  TADPhysDBXCommand = class(TADPhysCommand)
  private
    FCommandIntf: {$IFDEF AnyDAC_D10} ISQLCommand30 {$ELSE} ISQLCommand {$ENDIF};
    FCursorMetaIntf: {$IFDEF AnyDAC_D10} ISQLMetaData30 {$ELSE} ISQLMetaData {$ENDIF};
    FCursorIntf: {$IFDEF AnyDAC_D10} ISQLCursor30 {$ELSE} ISQLCursor {$ENDIF};
    FColumnIndex: Word;
    FParamChildPos: array of Word;
    procedure CheckCmd(AStatus: SQLResult; ANotSupIgnore: Boolean = False);
    procedure CheckCrs(AStatus: SQLResult; ANotSupIgnore: Boolean = False);
    procedure FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    procedure GetCmdParamValues(AParams: TADParams);
    procedure SetCmdParamValues(AParams: TADParams; AValueIndex: Integer);
    procedure CheckMeta(AStatus: SQLResult; const AIntf:
      {$IFDEF AnyDAC_D10} ISQLMetaData30 {$ELSE} ISQLMetaData {$ENDIF}; ANotSupIgnore: Boolean = False);
    procedure CalcUnits(const AParams: TADParams; const AIndex, AActiveIndex: Integer;
      var AChildPos: array of Word; var ASubItems, AActiveSubItems: Integer);
    procedure OpenMetaInfo;
    function GetColumnName(AColIndex: Word): SQLString;
    function FetchMetaRow(ATable: TADDatSTable; AParentRow: TADDatSRow): Boolean;
    procedure Dbx2ADColInfo(ADbxType, ADbxSubType: Word; ADbxPrec: Integer;
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
    procedure InternalAbort; override;
  end;

var
  FGLock: TRTLCriticalSection;

const
  C_AD_ConnParam_DBX_Count = 3;
{$IFDEF AnyDAC_D9}
  SQL_SUCCESS = DBXERR_NONE;
{$ENDIF}

  txi2dbxi: array[TADTxIsolation] of TTransIsolationLevel = (
    xilDIRTYREAD, xilREADCOMMITTED, xilREPEATABLEREAD, xilREPEATABLEREAD);
  dbxi2txi: array[TTransIsolationLevel] of TADTxIsolation = (
    xiReadCommitted, xiRepeatableRead, xiDirtyRead, xiRepeatableRead);

{-------------------------------------------------------------------------------}
{ TADPhysDBXLib                                                                 }
{-------------------------------------------------------------------------------}
constructor TADPhysDBXLib.Create(AOwningObj: TObject);
begin
  inherited Create;
  FOwningObj := AOwningObj;
  FLoadedDrivers := TStringList.Create;
  FLoadedDrivers.Sorted := True;
  FLock := TADMREWSynchronizer.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysDBXLib.Destroy;
var
  i: Integer;
begin
  FDrivers := nil;
  if FLoadedDrivers <> nil then begin
    for i := 0 to FLoadedDrivers.Count - 1 do
      with TADPhysDBXLibRec(FLoadedDrivers.Objects[i]) do begin
        if not FLinked then
          FreeLibrary(FDllHandle);
        Free;
      end;
    FreeAndNil(FLoadedDrivers);
  end;
  FreeAndNil(FLock);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADPhysDBXLib.GetRegistryFile(const Setting, Default: string;
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
    if Reg.OpenKeyReadOnly(SDBEXPRESSREG_SETTING) then
      Result := Reg.ReadString(Setting)
    else
      Result := '';
    Result := ADGetBestPath('', Result, SDriverConfigFile);
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
class function TADPhysDBXLib.GetDriverRegistryFile(DesignMode: Boolean = False): string;
begin
  Result := GetRegistryFile(SDRIVERREG_SETTING, sDriverConfigFile, DesignMode);
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXLib.GetDrivers: IADStanDefinitions;
begin
  if FDrivers = nil then begin
    ADCreateInterface(IADStanDefinitions, FDrivers);
    with FDrivers.Storage do begin
      DefaultFileName := SDriverConfigFile;
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
procedure TADPhysDBXLib.ResolveDriverInfo(const ADriverName: String;
  var ALibName, AGetFunc, AVendLib: String; var ALinked: Boolean);
var
  oDrv: IADStanDefinition;
  i: Integer;
begin
  i := FLoadedDrivers.IndexOf(UpperCase(ADriverName));
  if i <> -1 then
    ALinked := TADPhysDBXLibRec(FLoadedDrivers.Objects[i]).FLinked
  else
    ALinked := False;
  if not ALinked and ((ALibName = '') or (AGetFunc = '')) or
     (AVendLib = '') then begin
    oDrv := GetDrivers.FindDefinition(ADriverName);
    if not ALinked and (oDrv <> nil) then begin
      if ALibName = '' then
        ALibName := oDrv.AsString[DLLLIB_KEY];
      if AGetFunc = '' then
        AGetFunc := oDrv.AsString[GETDRIVERFUNC_KEY];
    end;
    if (AVendLib = '') and (oDrv <> nil) then
      AVendLib := oDrv.AsString[VENDORLIB_KEY];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXLib.RegisterLinkedDriver(const ADriverName: String;
  AEntry: TADPhysDBXGetSQLDriverProc);
var
  oRec: TADPhysDBXLibRec;
begin
  oRec := TADPhysDBXLibRec.Create;
  oRec.FLinked := True;
  oRec.FDllHandle := 0;
  oRec.FDllEntry := AEntry;
  oRec.FClients := 0;
  FLoadedDrivers.AddObject(UpperCase(ADriverName), oRec);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXLib.UnRegisterLinkedDriver(const ADriverName: String);
var
  i: Integer;
  oRec: TADPhysDBXLibRec;
begin
  if FLoadedDrivers <> nil then begin
    i := FLoadedDrivers.IndexOf(UpperCase(ADriverName));
    if i <> -1 then begin
      oRec := TADPhysDBXLibRec(FLoadedDrivers.Objects[i]);
      ASSERT(oRec.FLinked);
      oRec.Free;
      FLoadedDrivers.Delete(i);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXLib.FindLoadedDriver(const ADriverName, ALibName,
  AGetFunc: String; var AIndex: Integer; var AKey: String): TADPhysDBXLibRec;
begin
  AKey := AnsiUpperCase(ADriverName) + AnsiUpperCase(ALibName) + AnsiUpperCase(AGetFunc);
  AIndex := FLoadedDrivers.IndexOf(AKey);
  if AIndex <> -1 then
    Result := TADPhysDBXLibRec(FLoadedDrivers.Objects[AIndex])
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXLib.AllocDriverIntf(const ADriverName, ALibName, AGetFunc,
  AVendLib, AResourceFile: String; out AIntf: ISQLDriver): SQLResult;
var
  i: Integer;
  sKey: String;
  iDllHandle: THandle;
  pDllEntry: TADPhysDBXGetSQLDriverProc;
  oRec: TADPhysDBXLibRec;
  lNotChanged: Boolean;
begin
  FLock.BeginRead;
  try
    oRec := FindLoadedDriver(ADriverName, ALibName, AGetFunc, i, sKey);
    if oRec = nil then begin
      lNotChanged := FLock.BeginWrite;
      try
        if not lNotChanged then
          oRec := FindLoadedDriver(ADriverName, ALibName, AGetFunc, i, sKey);
        if oRec = nil then begin
          ASSERT((ALibName <> '') and (AGetFunc <> ''));
          iDllHandle := SafeLoadLibrary(PChar(ALibName));
          if iDllHandle = 0 then
            ADException(OwningObj, [S_AD_LPhys, S_AD_DBXId], er_AD_AccCantLoadLibrary,
              [ALibName, ADLastSystemErrorMsg, ALibName]);
          pDllEntry := GetProcAddress(iDllHandle, PChar(AGetFunc));
          if not Assigned(pDllEntry) then begin
            FreeLibrary(iDllHandle);
            ADException(OwningObj, [S_AD_LPhys, S_AD_DBXId], er_AD_AccCantGetLibraryEntry,
              [AGetFunc, ADLastSystemErrorMsg]);
          end;
          oRec := TADPhysDBXLibRec.Create;
          oRec.FLinked := False;
          oRec.FDllHandle := iDllHandle;
          oRec.FDllEntry := pDllEntry;
          FLoadedDrivers.AddObject(sKey, oRec);
        end;
      finally
        FLock.EndWrite;
      end;
    end;
    with oRec do begin
      Result := FDllEntry(PChar(AVendLib), PChar(AResourceFile), AIntf);
      InterlockedIncrement(FClients);
    end;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXLib.ReleaseDriverIntf(const ADriverName, ALibName, AGetFunc,
  AVendLib: String; AOnDisconnect: Boolean; var AIntf: ISQLDriver);
var
  i: Integer;
  sKey: String;
  oRec: TADPhysDBXLibRec;
begin
  AIntf := nil;
  FLock.BeginWrite;
  try
    oRec := FindLoadedDriver(ADriverName, ALibName, AGetFunc, i, sKey);
    if oRec <> nil then
      with oRec do begin
        if FClients > 0 then
          Dec(FClients);
        if not FLinked and (FClients = 0) and AOnDisconnect then
          try
            FreeLibrary(FDllHandle);
            Free;
          finally
            FLoadedDrivers.Delete(i);
          end;
      end;
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysDBXDriver                                                              }
{-------------------------------------------------------------------------------}
constructor TADPhysDBXDriver.Create(ADrvHost: TADPhysDriverHost);
begin
  inherited Create(ADrvHost);
  FLib := TADPhysDBXLib.Create;
  ADSetDbXpressLibRegistrator(FLib.RegisterLinkedDriver, FLib.UnRegisterLinkedDriver);
  FDesignMode := False; // ???
  FCfgFile := FLib.GetRegistryFile(SDRIVERREG_SETTING, sDriverConfigFile, FDesignMode);
  InitializeCriticalSection(FGLock);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysDBXDriver.Destroy;
var
  i: Integer;
begin
  DeleteCriticalSection(FGLock);
  ADSetDbXpressLibRegistrator(nil, nil);
  if FLib <> nil then begin
    for i := 0 to FLib.FLoadedDrivers.Count - 1 do
      ADRegisterDbXpressLib(FLib.FLoadedDrivers[i],
        TADPhysDBXLibRec(FLib.FLoadedDrivers.Objects[i]).FDllEntry);
    FreeAndNil(FLib);
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADPhysDBXDriver.GetDriverID: String;
begin
  Result := S_AD_DBXId;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXDriver.GetDescription: String;
begin
  Result := 'DBExpress Driver';
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXDriver.GetDriverParams(AKeys: TStrings): TStrings;
var
  sDrv, sName, sType, sDefVal, sCaption: String;
  oIniFile: TCustomIniFile;
  i, j, iLogin: Integer;
begin
  Result := TStringList.Create;
  try
    sDrv := AKeys.Values[DRIVERNAME_KEY];
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
function TADPhysDBXDriver.GetConnParamCount(AKeys: TStrings): Integer;
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
procedure TADPhysDBXDriver.GetConnParams(AKeys: TStrings; Index: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  oList, oList2: TStrings;
  oIniFile: TIniFile;
  j: TADRDBMSKind;
  i: Integer;
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
      for i := 0 to FLib.FLoadedDrivers.Count - 1 do
        if oList.IndexOf(FLib.FLoadedDrivers[i]) = -1 then
          oList.Add(FLib.FLoadedDrivers[i]);
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
{ TADPhysDBXConnection                                                          }
{-------------------------------------------------------------------------------}
constructor TADPhysDBXConnection.Create(ADriverObj: TADPhysDriver;
  const ADriver: IADPhysDriver; AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, ADriver, AConnHost);
end;

{-------------------------------------------------------------------------------}
class function TADPhysDBXConnection.GetDriverClass: TADPhysDriverClass;
begin
  Result := TADPhysDBXDriver;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXConnection.GetDBXConnection:
  {$IFDEF AnyDAC_D10} ISQLConnection30 {$ELSE} ISQLConnection {$ENDIF};
begin
  Result := FDbxConnection;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXConnection.InternalCreateCommandGenerator(
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
function TADPhysDBXConnection.InternalCreateMetadata: TObject;
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
  Result := TADPhysDBExpMetadata.Create({$IFDEF AnyDAC_MONITOR} GetMonitor, {$ENDIF}
    Self, TADPhysConnectionMetadata(Result));
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXConnection.GetRDBMSKindFromAlias: TADRDBMSKind;
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
function TADPhysDBXConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysDBXCommand.Create;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.CheckConnParams;
begin
  FDriverName := GetConnectionDef.AsString[DRIVERNAME_KEY];
  if FDriverName = '' then
    ADException(Self, [S_AD_LPhys, S_AD_DBXId], er_AD_DBXParMBNotEmpty,
      [DRIVERNAME_KEY]);
  FLibraryName := GetConnectionDef.AsString[DLLLIB_KEY];
  FGetDriverFunc := GetConnectionDef.AsString[GETDRIVERFUNC_KEY];
  FVendorLib := GetConnectionDef.AsString[VENDORLIB_KEY];
  TADPhysDBXDriver(DriverObj).FLib.ResolveDriverInfo(FDriverName, FLibraryName,
    FGetDriverFunc, FVendorLib, FDriverLinked);
  if not FDriverLinked then begin
    if FLibraryName = '' then
      ADException(Self, [S_AD_LPhys, S_AD_DBXId], er_AD_DBXParMBNotEmpty,
        [DLLLIB_KEY]);
    if FGetDriverFunc = '' then
      ADException(Self, [S_AD_LPhys, S_AD_DBXId], er_AD_DBXParMBNotEmpty,
        [GETDRIVERFUNC_KEY]);
  end;
// ???  if FVendorLib = '' then
//    ADException(Self, er_AD_DBXParMBNotEmpty, [VENDORLIB_KEY]);
  FBorlMSSQLDriver := (ADCompareText(FDriverName, 'MSSQL') = 0);
  FBorlMySQLDriver := (ADCompareText(FDriverName, 'MYSQL') = 0);
  FOpenODBCDriver := (ADCompareText(FDriverName, 'OPENODBC') = 0);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.GetConnInterfaces;
{$IFDEF AnyDAC_D10}
var
  oConn: ISQLConnection;
{$ENDIF}
begin
  Check(TADPhysDBXDriver(DriverObj).FLib.AllocDriverIntf(FDriverName, FLibraryName,
    FGetDriverFunc, FVendorLib, GetConnectionDef.AsString[ERROR_RESOURCE_KEY], FDbxDriver));
{$IFDEF AnyDAC_D10}
  Check(FDbxDriver.SetOption(eDrvProductVersion, Integer(PAnsiChar(DBXPRODUCTVERSION30))));
  Check(FDbxDriver.getSQLConnection(oConn));
  FDbxConnection := ISQLConnection30(oConn);
{$ELSE}
  Check(FDbxDriver.getSQLConnection(FDbxConnection));
{$ENDIF}
{$IFDEF AnyDAC_MONITOR}
  RegisterCallback(GetTracing);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ TODO -cDBExp : What to do with all that ??! }
// eConnDatabaseName -  not supported on Oracle
// eConnServerVersion - returns 0 on Oracle
// eConnNativeHandle - returns nothing on Oracle
// eConnBlockingMode - does nothing on Oracle
// eConnObjectMode - if we will work with objects ????
// eConnMaxActiveComm - used in SqlExpr
// eConnCommitRetain - for BDE compatibility we should use it ?
// DELPHI7
// eConnRollbackRetain -as eConnCommitRetain
//

procedure TADPhysDBXConnection.SetConnParams;
var
  s: String;
  iLevel: TTransIsolationLevel;
begin
  if GetConnectionDef.HasValue(HOSTNAME_KEY) then
    Check(FDbxConnection.setOption(eConnHostName, LongInt(PSQLChar(SQLString(GetConnectionDef.AsString[HOSTNAME_KEY])))));
  if GetConnectionDef.HasValue(ROLENAME_KEY) then
    Check(FDbxConnection.setOption(eConnRoleName, LongInt(PSQLChar(SQLString(GetConnectionDef.AsString[ROLENAME_KEY])))));
  if GetConnectionDef.HasValue(WAITONLOCKS_KEY) then
    Check(FDbxConnection.setOption(eConnWaitOnLocks, LongInt(GetConnectionDef.AsBoolean[WAITONLOCKS_KEY])));
  if GetConnectionDef.HasValue(COMMITRETAIN_KEY) then
    Check(FDbxConnection.setOption(eConnCommitRetain, LongInt(GetConnectionDef.AsBoolean[COMMITRETAIN_KEY])));
  if GetConnectionDef.HasValue(BLOCKINGMODE_KEY) then
    Check(FDbxConnection.setOption(eConnBlockingMode, LongInt(GetConnectionDef.AsBoolean[BLOCKINGMODE_KEY])));
  if GetConnectionDef.HasValue(SQLSERVER_CHARSET_KEY) then
    Check(FDbxConnection.setOption(eConnServerCharSet, LongInt(PSQLChar(SQLString(GetConnectionDef.AsString[SQLSERVER_CHARSET_KEY])))));
  if GetConnectionDef.HasValue(AUTOCOMMIT_KEY) then
    GetTxOptions.AutoCommit := GetConnectionDef.AsBoolean[AUTOCOMMIT_KEY];
  s := Format(TRANSISOLATION_KEY, [FDriverName]);
  if GetConnectionDef.HasValue(s) then begin
    s := LowerCase(GetConnectionDef.AsString[s]);
    if s = SREPEATREAD then
      iLevel := xilRepeatableRead
    else if s = SDIRTYREAD then
      iLevel := xilDirtyRead
    else if s = SREADCOMMITTED then
      iLevel := xilReadCommitted
    else
      iLevel := xilCustom;
    GetTxOptions.Isolation := dbxi2txi[iLevel];
  end;
  UpdateTx;
  if GetConnectionDef.HasValue(SQLDIALECT_KEY) then
    Check(FDbxConnection.setOption(eConnSQLDialect, GetConnectionDef.AsInteger[SQLDIALECT_KEY]));
  if GetConnectionDef.HasValue(MAXBLOBSIZE_KEY) then
    Check(FDbxConnection.setOption(eConnBlobSize, GetConnectionDef.AsInteger[MAXBLOBSIZE_KEY]), True)
  else
    Check(FDbxConnection.setOption(eConnBlobSize, -1), True);
{$IFDEF AnyDAC_D7}
  if GetConnectionDef.HasValue(OSAUTHENTICATION) then
    Check(FDbxConnection.setOption(eConnOSAuthentication, LongInt(GetConnectionDef.AsBoolean[OSAUTHENTICATION])));
  if GetConnectionDef.HasValue(SERVERPORT) then
    Check(FDbxConnection.setOption(eConnServerPort, LongInt(PSQLChar(SQLString(GetConnectionDef.AsString[SERVERPORT])))));
  if GetConnectionDef.HasValue(MULTITRANSENABLED) then
    Check(FDbxConnection.setOption(eConnMultipleTransaction, LongInt(GetConnectionDef.AsBoolean[MULTITRANSENABLED])));
  if GetConnectionDef.HasValue(TRIMCHAR) then begin
    GetOptions.FormatOptions.StrsTrim := GetConnectionDef.AsBoolean[TRIMCHAR];
    Check(FDbxConnection.setOption(eConnTrimChar, LongInt(GetOptions.FormatOptions.StrsTrim)));
  end;
  if GetConnectionDef.HasValue(CUSTOM_INFO) then
    Check(FDbxConnection.setOption(eConnCustomInfo, LongInt(PSQLChar(SQLString(GetConnectionDef.AsString[CUSTOM_INFO])))));
  if GetConnectionDef.HasValue(CONN_TIMEOUT) then
    Check(FDbxConnection.setOption(eConnTimeOut, GetConnectionDef.AsInteger[CONN_TIMEOUT]));
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.DoConnect;
var
  oConnMeta: IADPhysConnectionMetadata;
  sDB: String;
begin
  CreateMetadata(oConnMeta);
  if oConnMeta.Kind = mkMySQL then
    EnterCriticalSection(FGLock);
  try
    sDB := GetConnectionDef.ExpandedDatabase;
    if (sDB = '') and FOpenODBCDriver then
      sDB := GetConnectionDef.Name;
    Check(FDbxConnection.connect(
      PSQLChar(SQLString(sDB)),
      PSQLChar(SQLString(GetConnectionDef.UserName)),
      PSQLChar(SQLString(GetConnectionDef.Password))));
  finally
    if oConnMeta.Kind = mkMySQL then
      LeaveCriticalSection(FGLock);
  end;
  FConnected := True;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.InternalConnect;
begin
  CheckConnParams;
  try
    GetConnInterfaces;
    SetConnParams;
    DoConnect;
    FRdbmsKind := GetRDBMSKindFromAlias;
  except
    InternalDisconnect;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.InternalDisconnect;
begin
  if FDbxConnection <> nil then begin
    if FConnected then
      Check(FDbxConnection.disconnect);
{$IFDEF AnyDAC_MONITOR}
    RegisterCallback(False);
{$ENDIF}
    FDbxConnection := nil;
  end;
  FRdbmsKind := mkUnknown;
  FConnected := False;
  if FDbxDriver <> nil then
    TADPhysDBXDriver(DriverObj).FLib.ReleaseDriverIntf(FDriverName, FLibraryName,
      FGetDriverFunc, FVendorLib, True, FDbxDriver);
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXConnection.GetTxIsolationLevel: TTransIsolationLevel;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  CreateMetadata(oConnMeta);
  if oConnMeta.Kind = mkMSAccess then
    Result := xilREADCOMMITTED
  else
    Result := txi2dbxi[GetTxOptions.Isolation];
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.InternalTxBegin(ATxID: LongWord);
var
  Status: SQLResult;
  TransDesc: TTransactionDesc;
begin
  ADFillChar(TransDesc, SizeOf(TTransactionDesc), #0);
  TransDesc.IsolationLevel := GetTxIsolationLevel;
  TransDesc.TransactionID := ATxID;
  Status := FDbxConnection.beginTransaction(LongWord(@TransDesc));
  if not (Status in [SQL_SUCCESS, DBXERR_NOTSUPPORTED]) then
    Check(Status);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.InternalTxCommit(ATxID: LongWord);
var
  Status: SQLResult;
  TransDesc: TTransactionDesc;
begin
  ADFillChar(TransDesc, SizeOf(TTransactionDesc), #0);
  TransDesc.IsolationLevel := GetTxIsolationLevel;
  TransDesc.TransactionID := ATxID;
  Status := FDbxConnection.commit(LongWord(@TransDesc));
  if not (Status in [SQL_SUCCESS, DBXERR_NOTSUPPORTED]) then
    Check(Status);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.InternalTxRollback(ATxID: LongWord);
var
  Status: SQLResult;
  TransDesc: TTransactionDesc;
begin
  ADFillChar(TransDesc, SizeOf(TTransactionDesc), #0);
  TransDesc.IsolationLevel := GetTxIsolationLevel;
  TransDesc.TransactionID := ATxID;
  Status := FDbxConnection.rollback(LongWord(@TransDesc));
  if not (Status in [SQL_SUCCESS, DBXERR_NOTSUPPORTED]) then
    Check(Status);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.DirectExec(const ASQL: String);
var
  oCmd: {$IFDEF AnyDAC_D10} ISQLCommand30 {$ELSE} ISQLCommand {$ENDIF};
  oCrs: {$IFDEF AnyDAC_D10} ISQLCursor30 {$ELSE} ISQLCursor {$ENDIF};
begin
  try
    Check(FDbxConnection.getSQLCommand(oCmd));
    Check(oCmd.executeImmediate(PSQLChar(SQLString(ASQL)), oCrs));
  finally
    oCrs := nil;
    oCmd := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.InternalTxRollbackToSavepoint(const AName: String);
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
procedure TADPhysDBXConnection.InternalTxSetSavepoint(const AName: String);
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
procedure TADPhysDBXConnection.InternalTxCommitSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: String;
begin
  CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateCommitSavepoint(AName);
  if s <> '' then
    DirectExec(s);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.InternalTxChanged;
begin
  if xoAutoCommit in GetTxOptions.Changed then
    Check(FDbxConnection.setOption(eConnAutoCommit, LongInt(GetTxOptions.AutoCommit)));
  if xoIsolation in GetTxOptions.Changed then
    Check(FDbxConnection.setOption(eConnTxnIsoLevel, LongInt(GetTxIsolationLevel)));
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D9}
const
  DbxError : array[0.. {$IFDEF AnyDAC_D10} 28 {$ELSE} 26 {$ENDIF}] of String = (
      SqlConst.SNOERROR, SqlConst.SWARNING,
      SqlConst.SNOMEMORY, SqlConst.SINVALIDFLDTYPE, SqlConst.SINVALIDHNDL,
      SqlConst.SNOTSUPPORTED, SqlConst.SINVALIDTIME, SqlConst.SINVALIDXLATION,
      SqlConst.SOUTOFRANGE, SqlConst.SINVALIDPARAM, SqlConst.SEOF,
      SqlConst.SSQLPARAMNOTSET, SqlConst.SINVALIDUSRPASS, SqlConst.SINVALIDPRECISION,
      SqlConst.SINVALIDLEN, SqlConst.SINVALIDXISOLEVEL, SqlConst.SINVALIDTXNID,
      SqlConst.SDUPLICATETXNID, SqlConst.SDRIVERRESTRICTED, SqlConst.SLOCALTRANSACTIVE,
      SqlConst.SMULTIPLETRANSNOTENABLED, SqlConst.SCONNECTIONFAILED,
      SqlConst.SDRIVERINITFAILED, SqlConst.SOPTLOCKFAILED, SqlConst.SINVALIDREF,
      SqlConst.SNOTABLE, SqlConst.SMISSINGPARAMINSQL
{$IFDEF AnyDAC_D10}
      , SqlConst.SNOTIMPLEMENTED, SqlConst.SDRIVERINCOMPATIBLE
{$ENDIF}      
      );
{$ENDIF}

procedure TADPhysDBXConnection.SQLError(AResultCode: SQLResult;
  AExSource: TADPhysDBXExceptionType; const AIntf: IInterface;
  AInitiator: TObject);
var
  sExceptionMessage: {$IFDEF AnyDAC_D10} WideString {$ELSE} AnsiString {$ENDIF};
  pMessageStr: PSQLChar;
  iStatus: SQLResult;
  siMessageLen: SmallInt;
  oEx: EDBXNativeException;
begin
  iStatus := SQL_NULL_DATA;
  sExceptionMessage := SErrorMappingError;
  pMessageStr := nil;
  try
    if (AResultCode > 0) and (AResultCode <= DBX_MAXSTATICERRORS) then
      sExceptionMessage := DbxError[AResultCode]
{$IFNDEF AnyDAC_D9}
    else if (AResultCode > 0) and (AResultCode < MaxReservedStaticErrors) then
      sExceptionMessage := SDBXUNKNOWNERROR
{$ENDIF}
    else begin
      case AExSource of
        etCommand:
          begin
            iStatus := {$IFDEF AnyDAC_D10} ISQLCommand30 {$ELSE} ISQLCommand {$ENDIF}
              (AIntf).getErrorMessageLen(siMessageLen);
            if (iStatus = SQL_SUCCESS) and (siMessageLen > 0) then begin
              pMessageStr := AllocMem((siMessageLen + 1) * CSQLCharLen);
              iStatus := {$IFDEF AnyDAC_D10} ISQLCommand30 {$ELSE} ISQLCommand {$ENDIF}
                (AIntf).getErrorMessage(pMessageStr);
            end;
          end;
        etCursor:
          begin
            iStatus := {$IFDEF AnyDAC_D10} ISQLCursor30 {$ELSE} ISQLCursor {$ENDIF}
              (AIntf).getErrorMessageLen(siMessageLen);
            if (iStatus = SQL_SUCCESS) and (siMessageLen > 0) then begin
              pMessageStr := AllocMem((siMessageLen + 1) * CSQLCharLen);
              iStatus := {$IFDEF AnyDAC_D10} ISQLCursor30 {$ELSE} ISQLCursor {$ENDIF}
                (AIntf).getErrorMessage(pMessageStr);
            end;
          end;
        etConnection:
          begin
            iStatus := FDbxConnection.getErrorMessageLen(siMessageLen);
            if (iStatus = SQL_SUCCESS) and (siMessageLen > 0) then begin
              pMessageStr := AllocMem((siMessageLen + 1) * CSQLCharLen);
              iStatus := FDbxConnection.getErrorMessage(pMessageStr);
            end;
          end;
        etMetaData:
          begin
            iStatus := {$IFDEF AnyDAC_D10} ISQLMetaData30 {$ELSE} ISQLMetaData {$ENDIF}
              (AIntf).getErrorMessageLen(siMessageLen);
            if (iStatus = SQL_SUCCESS) and (siMessageLen> 0) then begin
              pMessageStr := AllocMem((siMessageLen + 1) * CSQLCharLen);
              iStatus := {$IFDEF AnyDAC_D10} ISQLMetaData30 {$ELSE} ISQLMetaData {$ENDIF}
                (AIntf).getErrorMessage(pMessageStr);
            end;
          end;
      end;
      if iStatus = SQL_SUCCESS then
        if siMessageLen > 0 then
          sExceptionMessage := pMessageStr
        else
          sExceptionMessage := SErrorMappingError
      else if FLastError <> '' then
        sExceptionMessage := FLastError;
      if sExceptionMessage = '' then
        sExceptionMessage := FLastError;
    end;
  finally
    if pMessageStr <> nil then
      FreeMem(pMessageStr);
  end;
  FLastError := sExceptionMessage;
  oEx := EDBXNativeException.Create(er_AD_DBXGeneral,
    ADExceptionLayers([S_AD_LPhys, S_AD_DBXId, FDriverName]) + ' ' + sExceptionMessage);
  oEx.Append(TADDBError.Create(1, AResultCode, sExceptionMessage, '', ekOther, 0));
  ADException(AInitiator, oEx);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.Check(AResultCode: SQLResult; AExclNotSup: Boolean);
begin
  if (AResultCode <> 0) and (not AExclNotSup or (AResultCode <> DBXERR_NOTSUPPORTED)) then
    SQLError(AResultCode, etConnection, nil, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.CreateMetaIntf(
  out AMeta: {$IFDEF AnyDAC_D10} ISQLMetaData30 {$ELSE} ISQLMetaData {$ENDIF});
begin
  Check(FDbxConnection.getSQLMetaData(AMeta));
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
type
  pSQLTRACEDesc = ^SQLTRACEDesc;
  SQLTRACEDesc = packed record             { trace callback info }
    pszTrace    : array [0..1023] of SQLChar;
    eTraceCat   : TRACECat;
    ClientData  : Integer;
    uTotalMsgLen: Word;
  end;

function DoCallback(CallType: TRACECat; CBInfo: Pointer): CBRType; stdcall;
var
  s: String;
begin
  case CBType(CallType) of
  {cbTRACE ???} cbRESERVED1:
    with pSQLTRACEDesc(CBInfo)^ do begin
      if uTotalMsgLen = 0 then
        s := pszTrace
      else
        SetString(s, pszTrace, uTotalMsgLen);
      TADPhysDBXConnection(ClientData).DoTraceVendor(eTraceCat, s);
    end;
  end;
  Result := cbrUSEDEF;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.RegisterCallback(AValue: Boolean);
begin
  if FDbxConnection <> nil then
    if AValue then begin
      Check(FDbxConnection.setOption(eConnCallBack, LongWord(@DoCallback)));
      Check(FDbxConnection.setOption(eConnCallBackInfo, Integer(Self)));
    end
    else begin
      Check(FDbxConnection.setOption(eConnCallBack, 0));
      Check(FDbxConnection.setOption(eConnCallBackInfo, 0));
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.DoTraceVendor(ATraceCat: TRACECat; const AMsg: String);
begin
  if GetTracing then
    GetMonitor.Notify(ekVendor, esProgress, Self, AMsg, [-1]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.InternalTracingChanged;
begin
  RegisterCallback(GetTracing);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADPhysDBXConnection.GetItemCount: Integer;
begin
  if FDriverName = '' then
    try
      CheckConnParams;
    except
      // no exceptions visible
    end;
  Result := inherited GetItemCount + 2;
  if not FDriverLinked then
    Result := Result + 3;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXConnection.GetItem(AIndex: Integer; var AName: String;
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
        AName := 'Driver linked';
        AValue := FDriverLinked;
        AKind := ikClientInfo;
      end;
    1:
      begin
        AName := 'DBX driver id';
        AKind := ikClientInfo;
        if FBorlMSSQLDriver then
          AValue := 'BorlMSSQL'
        else if FBorlMySQLDriver then
          AValue := 'BorlMySQL '
        else if FOpenODBCDriver then
          AValue := 'OpenODBC'
        else
          AValue := '';
        if not FDriverLinked then begin
          if AValue <> '' then
            AValue := AValue + ': ';
          if ADGetVersionInfo(FLibraryName, sProduct, sVersion, sVersionName, sCopyright, sInfo) then
            AValue := AValue + sProduct + ', ver ' + sVersionName + ', ' + sCopyright
          else
            AValue := AValue + '<not found>';
        end;
      end;
    2:
      begin
        AName := 'Library name';
        AValue := FLibraryName;
        AKind := ikClientInfo;
      end;
    3:
      begin
        AName := 'Vendor lib';
        AValue := FVendorLib;
        AKind := ikClientInfo;
      end;
    4:
      begin
        AName := 'Get driver func';
        AValue := FGetDriverFunc;
        AKind := ikClientInfo;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysDBXCommand                                                             }
{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.CheckCmd(AStatus: SQLResult; ANotSupIgnore: Boolean = False);
begin
  if (AStatus <> 0) and (not ANotSupIgnore or (AStatus <> DBXERR_NOTSUPPORTED)) then
    TADPhysDBXConnection(FConnectionObj).SQLError(AStatus, etCommand, FCommandIntf, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.CheckCrs(AStatus: SQLResult; ANotSupIgnore: Boolean = False);
begin
  if (AStatus <> 0) and (not ANotSupIgnore or (AStatus <> DBXERR_NOTSUPPORTED)) then
    TADPhysDBXConnection(FConnectionObj).SQLError(AStatus, etCursor, FCursorIntf, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.CheckMeta(AStatus: SQLResult;
  const AIntf: {$IFDEF AnyDAC_D10} ISQLMetaData30 {$ELSE} ISQLMetaData {$ENDIF};
  ANotSupIgnore: Boolean = False);
begin
  if (AStatus <> 0) and (not ANotSupIgnore or (AStatus <> DBXERR_NOTSUPPORTED)) then
    TADPhysDBXConnection(FConnectionObj).SQLError(AStatus, etMetaData, AIntf, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.CalcUnits(const AParams: TADParams;
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
procedure TADPhysDBXCommand.SetCmdParamValues(AParams: TADParams; AValueIndex: Integer);
const
  FldTypeMap: array[TFieldType] of Byte = (
    fldUNKNOWN, fldZSTRING, fldINT16, fldINT32, fldUINT16,
    fldBOOL, fldFLOAT, fldBCD, fldBCD, fldDATE, fldTIME, fldTIMESTAMP,
    fldBYTES, fldVARBYTES, fldINT32, fldBLOB, fldBLOB, fldBLOB, fldBLOB,
    fldBLOB, fldBLOB, fldBLOB, fldCURSOR, fldZSTRING, fldZSTRING,
    fldINT64, fldADT, fldArray, fldREF, fldTABLE, fldBLOB, fldBLOB,
    fldUNKNOWN, fldUNKNOWN, fldUNKNOWN, fldZSTRING, fldDATETIME, fldBCD
{$IFDEF AnyDAC_D10}
    , fldWIDESTRING, fldstWIDEMEMO, fldstORATIMESTAMP, fldstORAINTERVAL
{$ENDIF}
    );
  FldSubTypeMap: array[TFieldType] of Byte = (
    0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    0, 0, fldstAUTOINC, fldstBINARY, fldstMEMO, fldstGRAPHIC, fldstMEMO or fldstUNICODE,
    fldstOLEOBJ, fldstDBSOLEOBJ, fldstTYPEDBINARY, 0, fldstFIXED, fldstUNICODE,
    0, 0, 0, 0, 0, fldstHBINARY, fldstHMEMO,
    0, 0, 0, 0, 0, 0
{$IFDEF AnyDAC_D10}
    , 0, fldstUNICODE, 0, 0
{$ENDIF}
    );
var
  i, iActive: Integer;
  iParType, iSubType: Word;
  iInd, iPrec, iMaxPrecision, iMaxScale, iTmp: Integer;
  iSize, iSrcDataLen, iDestDataLen: LongWord;
  iFieldType: TFieldType;
  iSrcDataType, iDestDataType: TADDataType;
  oParam: TADParam;
  pNilPtr: Pointer;
  oFmtOpts: TADFormatOptions;
  oResOpts: TADResourceOptions;
  iParamType: TParamType;
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
    iParamType := oParam.ParamType;
    if iParamType = ptUnknown then begin
      oParam.ParamType := oResOpts.DefaultParamType;
      iParamType := oParam.ParamType;
    end;
    if oParam.DataType = ftUnknown then
      ParTypeUnknownError(oParam);

    oFmtOpts.ResolveFieldType(oParam.DataType, oParam.ADDataType, oParam.Size,
      oParam.Precision, iFieldType, iSize, iPrec, iSrcDataType, iDestDataType, False);
    if (AValueIndex > 0) and (oParam.ArrayType = atScalar) then
      iSrcDataLen := 0
    else
      iSrcDataLen := oParam.GetDataSize(AValueIndex);
    // approximating destination data size and allocate buffer
    FBuffer.Extend(iSrcDataLen, iDestDataLen, iSrcDataType, iDestDataType);
    // fill buffer with value, converting it, if required
    if (AValueIndex > 0) and (oParam.ArrayType = atScalar) or
       oParam.IsNulls[AValueIndex] and
        (not TADPhysDBXConnection(FConnectionObj).FOpenODBCDriver and (iParamType = ptInput) or
         TADPhysDBXConnection(FConnectionObj).FOpenODBCDriver and (iParamType in [ptResult, ptInput, ptInputOutput])) then
      iInd := 1
    else begin
      iInd := 0;
      if iParamType in [ptInput, ptInputOutput] then begin
        oParam.GetData(FBuffer.Ptr, AValueIndex);
        if iSrcDataType <> iDestDataType then
          oFmtOpts.ConvertRawData(iSrcDataType, iDestDataType, FBuffer.Ptr,
            iSrcDataLen, FBuffer.FBuffer, FBuffer.Size, iDestDataLen);
      end
      else begin
        pNilPtr := nil;
        oFmtOpts.ConvertRawData(iSrcDataType, iDestDataType, nil,
          iSrcDataLen, pNilPtr, FBuffer.Size, iDestDataLen);
        if iDestDataType in [dtWideString, dtWideMemo, dtWideHMemo] then
          ADFillChar(FBuffer.Ptr^, iDestDataLen * SizeOf(WideChar), #0)
        else
          ADFillChar(FBuffer.Ptr^, iDestDataLen, #0)
      end;
    end;
    FParamChildPos[iActive] := 0;
    iParType := FldTypeMap[iFieldType];
    iSubType := FldSubTypeMap[iFieldType];
    if iParType = fldUNKNOWN then
      ParTypeMapError(oParam);
    iMaxPrecision := iDestDataLen;
    iMaxScale := 0;
    case iParType of
    fldBLOB, fldZSTRING, fldBYTES, fldVARBYTES:
      begin
        if iParType = fldZSTRING then begin
          if LongWord(oParam.Size) < iDestDataLen - 1 then
            oParam.Size := iDestDataLen - 1;
        end
        else begin
          if LongWord(oParam.Size) < iDestDataLen then
            oParam.Size := iDestDataLen;
        end;
        iMaxPrecision := oParam.Size;
        if (iParType = fldZSTRING) and ((iSubType and fldstUNICODE) <> 0) or
           (iParType = fldBLOB) and ((iSubType and fldstUNICODE) <> 0) then
          iDestDataLen := iDestDataLen * SizeOf(WideChar);
        if (iMaxPrecision = 0) and (iParamType = ptInput) and
           GetOptions.FormatOptions.StrsEmpty2Null then
          iInd := 1;
      end;
    fldBCD, fldFMTBCD:
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
    fldADT, fldARRAY:
      CalcUnits(AParams, i, iActive, FParamChildPos, iTmp, iMaxScale);
    end;
    CheckCmd(FCommandIntf.setParameter(iActive + 1 - FParamChildPos[iActive],
      FParamChildPos[iActive], TSTMTParamType(iParamType), iParType, iSubType,
      iMaxPrecision, iMaxScale, iDestDataLen, FBuffer.Ptr, iInd));
    Inc(iActive);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.GetCmdParamValues(AParams: TADParams);
var
  i, iActive: Integer;
  iInd: Integer;
  iFieldType: TFieldType;
  iSize: LongWord;
  iPrec: Integer;
  iSrcDataType, iDestDataType: TADDataType;
  oParam: TADParam;
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
      { TODO -cDBExp : Check for ADT too ! - ? uChildPos}
      iInd := 1;
{$IFDEF AnyDAC_DBX_GETPARBUG}
      { TODO -cDBExp : getParameter has a bug. It allways returns iInd = 1
        for string parameters. But it returns value in FBuffer.Ptr with terminating #0 }
      if oParam.DataType in [ftString, ftMemo, ftWideString] then
        ADFillChar(FBuffer.Ptr^, FBuffer.Size, #0);
      CheckCmd(FCommandIntf.getParameter(iActive + 1, 0, FBuffer.Ptr, FBuffer.Size, iInd));
      if not (oParam.DataType in [ftString, ftMemo]) and (iInd = 1) or
         (oParam.DataType in [ftString, ftMemo]) and (StrLen(PChar(FBuffer.Ptr)) = 0) then
        AParams[i].Clear
{$ELSE}
      CheckCmd(FCommandIntf.getParameter(iActive + 1, 0, FBuffer.Ptr, FBuffer.Size, iInd));
      if iInd = 1 then
        AParams[i].Clear
{$ENDIF}
      else begin
        GetOptions.FormatOptions.ResolveFieldType(oParam.DataType, oParam.ADDataType,
          oParam.Size, oParam.Precision, iFieldType, iSize, iPrec, iSrcDataType,
          iDestDataType, False);
        if iSrcDataType <> iDestDataType then
          GetOptions.FormatOptions.ConvertRawData(iDestDataType, iSrcDataType,
            FBuffer.Ptr, oParam.Size, FBuffer.FBuffer, FBuffer.Size, iSize);
        if (iSrcDataType in C_AD_VarLenTypes) and (iSize = 0) and
           GetOptions.FormatOptions.StrsEmpty2Null then
          AParams[i].Clear
        else
          AParams[i].SetData(FBuffer.Ptr, iSize, -1);
      end;
    end;
    Inc(iActive);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.InternalPrepare;
var
  sCatalog, sSchema, sPackage, sCmd: String;
  rName: TADPhysParsedName;
  oConnMeta: IADPhysConnectionMetadata;
begin
  if GetMetaInfoKind = mkNone then begin
    if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
      TADPhysDBXConnection(FConnectionObj).CreateMetadata(oConnMeta);
      oConnMeta.DecodeObjName(Trim(GetCommandText()), rName, Self, [doNormalize, doUnquote]);
      sCatalog := rName.FCatalog;
      sSchema := rName.FSchema;
      sPackage := rName.FBaseObject;
      sCmd := rName.FObject;
      if fiMeta in GetFetchOptions.Items then
        FillStoredProcParams(sCatalog, sSchema, sPackage, sCmd);
    end
    else begin
      sCatalog := GetCatalogName();
      sSchema := GetSchemaName();
      sPackage := GetBaseObjectName();
      sCmd := FDbCommandText;
      if GetCommandKind = skUnknown then
        SetCommandKind(skSelect);
    end;
    with TADPhysDBXConnection(FConnectionObj) do
      Check(FDbxConnection.getSQLCommand(FCommandIntf));
    if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then
      CheckCmd(FCommandIntf.setOption(eCommStoredProc, LongWord(True)));
    if TADPhysDBXConnection(FConnectionObj).GetLastTXID > 0 then
      CheckCmd(FCommandIntf.setOption(eCommTransactionID, TADPhysDBXConnection(FConnectionObj).GetLastTXID), True);
{$IFDEF AnyDAC_D7}
    if sCatalog <> '' then
      CheckCmd(FCommandIntf.setOption(eCommCatalogName, LongWord(PSQLChar(SQLString(sCatalog)))));
    if sSchema <> '' then
      CheckCmd(FCommandIntf.setOption(eCommSchemaName, LongWord(PSQLChar(SQLString(sSchema)))));
    if sPackage <> '' then
      CheckCmd(FCommandIntf.setOption(eCommPackageName, LongWord(PSQLChar(SQLString(sPackage)))));
{$ELSE}
    if sPackage <> '' then
      sCmd := sPackage + '.' + sCmd;
{$ENDIF}
    CheckCmd(FCommandIntf.prepare(PSQLChar(SQLString(sCmd)), GetParams.ActiveCount));
  end
  else
    SetCommandKind(skSelect);
  SetLength(FParamChildPos, GetParams.ActiveCount);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.InternalUnprepare;
begin
  InternalClose;
  FCommandIntf := nil;
  SetLength(FParamChildPos, 0);
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXCommand.GetColumnName(AColIndex: Word): SQLString;
var
  wLen: Word;
begin
  CheckCrs(FCursorIntf.getColumnNameLength(AColIndex, wLen));
  SetLength(Result, wLen);
  CheckCrs(FCursorIntf.getColumnName(AColIndex, @Result[1]));
  if Result[wLen] = #0 then
    SetLength(Result, wLen - 1);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.Dbx2ADColInfo(ADbxType, ADbxSubType: Word;
  ADbxPrec: Integer; ADbxScale: SmallInt; var AType: TADDataType;
  var AAtrs: TADDataAttributes; var ALen: LongWord; var APrec, AScale: Integer);
begin
  AType := dtUnknown;
  ALen := 0;
  APrec := 0;
  AScale := 0;
  AAtrs := [caSearchable];
  case ADbxType of
  fldZSTRING:
    begin
      if (ADbxPrec > C_AD_MaxDlp4StrSize) or (ADbxPrec < 0) then begin
        AType := dtMemo;
        Include(AAtrs, caBlobData);
      end
      else begin
        AType := dtAnsiString;
        ALen := ADbxPrec;
        if (ADbxSubType and fldstUNICODE) <> 0 then
          AType := dtWideString;
        if (ADbxSubType and fldstFIXED) <> 0 then
          Include(AAtrs, caFixedLen);
      end;
    end;
  fldDATE:
    AType := dtDate;
  fldBLOB:
    begin
      case ADbxSubType of
      fldstMEMO:    AType := dtMemo;
      fldstMEMO or fldstUNICODE,
      fldstFMTMEMO:
                    AType := dtWideMemo;
      fldstHMEMO:   AType := dtHMemo;
      fldstBINARY:  AType := dtBlob;
      fldstHBINARY: AType := dtHBlob;
      fldstBFILE:   AType := dtHBFile;
      else          AType := dtBlob;
      end;
      if ADbxPrec = -1 then
        ALen := $7FFFFFFF
      else
        ALen := ADbxPrec;
      Include(AAtrs, caBlobData);
      Exclude(AAtrs, caSearchable);
    end;
  fldBOOL:
    AType := dtBoolean;
  fldINT16:
    AType := dtInt16;
  fldUINT16:
    AType := dtUInt16;
  fldINT32:
    begin
      AType := dtInt32;
      if ADbxSubType = fldstAUTOINC then begin
        Include(AAtrs, caAutoInc);
        Include(AAtrs, caAllowNull);
      end;
    end;
  fldUINT32:
    AType := dtUInt32;
  fldINT64:
    AType := dtInt64;
  fldUINT64:
    AType := dtUInt64;
  fldFLOAT:
    begin
      if ADbxSubType = fldstMONEY then
        AType := dtCurrency
      else
        AType := dtDouble;
    end;
  fldBCD, fldFMTBCD:
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
  fldBYTES, fldVARBYTES:
    begin
      if (ADbxPrec > C_AD_MaxDlp4StrSize) or (ADbxPrec < 0) then begin
        AType := dtBlob;
        Include(AAtrs, caBlobData);
      end
      else begin
        AType := dtByteString;
        ALen := ADbxPrec;
        if ADbxType = fldBYTES then
          Include(AAtrs, caFixedLen);
      end;
    end;
  fldTIME:
    AType := dtTime;
  fldDATETIME:
    AType := dtDateTimeStamp;
  fldCURSOR:
    begin
      AType := dtCursorRef;
      Include(AAtrs, caAllowNull);
      Exclude(AAtrs, caSearchable);
    end;
  fldADT:
    begin
      AType := dtRowRef;
      Exclude(AAtrs, caSearchable);
    end;
  fldARRAY:
    begin
      AType := dtArrayRef;
      Exclude(AAtrs, caSearchable);
    end;
  fldREF:
    begin
      AType := dtRowRef;
      Exclude(AAtrs, caSearchable);
    end;
  fldTABLE:
    begin
      AType := dtRowSetRef;
      Exclude(AAtrs, caSearchable);
    end;
  // fldTIMESTAMP
  // fldFLOATIEEE
  // fldLOCKINFO
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXCommand.InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean;
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
      ATabInfo.FOriginName := GetColumnName(ATabInfo.FSourceID);
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXCommand.InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  wCount: Word;
  wType, wSubType: Word;
  siPrec, siScale, siLen: SmallInt;
  llNull, llRO, llSrch, llAutoInc: LongBool;
  rTypeDesc: {$IFDEF AnyDAC_D10} ObjTypeDesc30 {$ELSE} ObjTypeDesc {$ENDIF};
begin
  with AColInfo do begin
    if FParentTableSourceID <> -1 then begin
      CheckCrs(FCursorIntf.getColumnType(FParentTableSourceID, wType, wSubType));
      if wType in [fldCURSOR, fldADT, fldARRAY, fldREF, fldTABLE] then begin
        CheckCrs(FCursorIntf.getColumnPrecision(FParentTableSourceID, siPrec));
        if FColumnIndex > FParentTableSourceID + Integer(siPrec) then begin
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
      CheckCrs(FCursorIntf.getColumnCount(wCount));
      if FColumnIndex > wCount then begin
        Result := False;
        Exit;
      end;
    end;

    FSourceName := GetColumnName(FColumnIndex);
    FSourceID := FColumnIndex;
    FOriginName := FSourceName;

    CheckCrs(FCursorIntf.getColumnType(FColumnIndex, wType, wSubType));
    if wType in [fldZSTRING, fldBYTES, fldVARBYTES, fldBCD, fldFMTBCD] then begin
      CheckCrs(FCursorIntf.getColumnPrecision(FColumnIndex, siPrec)); // iUnits1
      if (wType = fldZSTRING) and GetOptions.FormatOptions.StrsDivLen2 then
        siPrec := siPrec div 2;
    end
    else
      siPrec := 0;
    if wType in [fldBCD, fldFMTBCD, fldADT, fldARRAY] then
      CheckCrs(FCursorIntf.getColumnScale(FColumnIndex, siScale))    // iUnits2
    else
      siScale := 0;
    Dbx2ADColInfo(wType, wSubType, siPrec, siScale, FType, FAttrs, FLen, FPrec, FScale);

    llNull := False;
    llRO := True;
    llSrch := True;
    llAutoInc := False;
    FForceRemOpts := [];
    FForceAddOpts := [];

    CheckCrs(FCursorIntf.isNullable(FColumnIndex, llNull), True);
    CheckCrs(FCursorIntf.isReadOnly(FColumnIndex, llRO), True);
    CheckCrs(FCursorIntf.isSearchable(FColumnIndex, llSrch), True);
    CheckCrs(FCursorIntf.isAutoIncrement(FColumnIndex, llAutoInc), True);
    if llNull then
      Include(FAttrs, caAllowNull);
    if llRO then
      Include(FAttrs, caReadOnly);
    if llSrch then
      Include(FAttrs, caSearchable);
    if llAutoInc then begin
      Include(FAttrs, caAutoInc);
      Include(FAttrs, caAllowNull);
      Include(FForceAddOpts, coAfterInsChanged);
    end;

    if wType in [fldADT, fldARRAY, fldREF, fldTABLE] then begin
      ADFillChar(rTypeDesc, SizeOf({$IFDEF AnyDAC_D10} ObjTypeDesc30 {$ELSE}
        ObjTypeDesc {$ENDIF}), #0);
      rTypeDesc.iFldNum := FColumnIndex;
      CheckCrs(FCursorIntf.getOption(eCurObjectTypeName, @rTypeDesc,
        SizeOf(rTypeDesc), siLen));
      FTypeName := rTypeDesc.szTypeName;
    end
    else
      FTypeName := '';
  end;
  Inc(FColumnIndex);
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXCommand.InternalOpen: Boolean;
var
  iRes: SQLResult;
  i, wCols: Word;
  wType, wSubType: Word;
  siPrec: SmallInt;
begin
  if FCursorIntf = nil then begin
    if GetMetaInfoKind = mkNone then begin
      SetCmdParamValues(GetParams, 0);
      if not (TADPhysDBXConnection(FConnectionObj).FOpenODBCDriver and
              (TADPhysDBXConnection(FConnectionObj).GetRDBMSKindFromAlias = mkMSSQL)) then begin
        // In case of Open ODBC & MSSQL RowsetSize > 1 speed down
        // Fetch performance 2 times.
        CheckCmd(FCommandIntf.setOption(eCommBlockRead, LongWord(True)), True);
        CheckCmd(FCommandIntf.setOption(eCommRowsetSize, GetFetchOptions.ActualRowsetSize), True);
      end;
      iRes := FCommandIntf.execute(FCursorIntf);
      if GetState = csAborting then
        InternalClose
      else begin
        if iRes <> SQL_SUCCESS then begin
          try
            FCursorIntf := nil;
          except
            // no exceptions visible
          end;
          CheckCmd(iRes);
        end;
        GetCmdParamValues(GetParams);
      end;
    end
    else
      OpenMetaInfo;
    if FCursorIntf <> nil then begin
      // check buffer space
      CheckCrs(FCursorIntf.getColumnCount(wCols));
      for i := 1 to wCols do begin
        CheckCrs(FCursorIntf.getColumnType(i, wType, wSubType));
        if wType in [fldZSTRING, fldBYTES, fldVARBYTES] then begin
          CheckCrs(FCursorIntf.getColumnPrecision(i, siPrec));
          // used for AnsiStr -> WideStr conversion, otherwise
          // buffer will have enough size
          FBuffer.Check(siPrec * SizeOf(WideChar));
        end;
      end;
    end;
  end;
  Result := (FCursorIntf <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.InternalClose;
begin
  try
    FCursorIntf := nil;
    FCursorMetaIntf := nil;
  finally
    if FCommandIntf <> nil then
{$IFDEF AnyDAC_DBX_MYSQLCMDBUG}
    if not TADPhysDBXConnection(FConnectionObj).FBorlMySQLDriver then
{$ENDIF}
      CheckCmd(FCommandIntf.close);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXCommand.InternalNextRecordSet: Boolean;
var
  iRes: SQLResult;
begin
  iRes := FCommandIntf.getNextCursor(FCursorIntf);
  if not (iRes in [SQL_SUCCESS, SQL_NULL_DATA, DBXERR_EOF, DBXERR_NOTSUPPORTED]) then
    CheckCmd(iRes);
  Result := (iRes = SQL_SUCCESS) and (FCursorIntf <> nil);
  if Result then
    GetCmdParamValues(GetParams);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.InternalExecute(ATimes, AOffset: Integer;
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
          CheckCmd(FCommandIntf.execute(FCursorIntf));
        except
          on E: EDBXNativeException do begin
            E.Errors[0].RowIndex := i;
            raise;
          end;
        end;
        FCursorIntf := nil;
        if GetState <> csAborting then begin
          GetCmdParamValues(GetParams);
          CheckCmd(FCommandIntf.getRowsAffected(iAffected));
          if iAffected = $FFFFFFFF then
            iAffected := 0;
          Inc(ACount, iAffected);
        end
        else
          Break;
      finally
        CheckCmd(FCommandIntf.close);
      end;
    end;
end;

{-------------------------------------------------------------------------------}
type
  IOpenOdbcCommand = interface
    ['{136DD9D1-9B9C-4355-9AEF-959662CB095F}']
    procedure cancel;
  end;

procedure TADPhysDBXCommand.InternalAbort;
var
  oCmdExt: IOpenOdbcCommand;
begin
  if Supports(FCommandIntf, IOpenOdbcCommand, oCmdExt) then
    oCmdExt.cancel
  else
    inherited InternalAbort;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDBXCommand.FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
var
  oRow: TADDatSRow;
  j: Integer;
  llIsBlank: LongBool;
  iRes: SQLResult;
  D: Double;
  C: Currency;
  pData: Pointer;
  siNotUsed: SmallInt;
  llCanUseSize: LongBool;
  lwBlobSize: LongWord;
  iLen: LongWord;
  oTab: TADDatSTable;
  oFmtOpts: TADFormatOptions;
begin
  oRow := ATable.NewRow(True);
  oFmtOpts := GetFormatOptions;
  try
    for j := 0 to ATable.Columns.Count - 1 do
      with ATable.Columns[j] do
        if (SourceID > 0) and CheckFetchColumn(SourceDataType) then begin
          pData := FBuffer.Ptr;
          iLen := Size;
          case SourceDataType of
          dtWideString:
            begin
{$IFDEF AnyDAC_D10}
              iRes := FCursorIntf.getWideString(SourceID, pData, llIsBlank);
{$ELSE}
              iRes := FCursorIntf.getString(SourceID, pData, llIsBlank);
{$ENDIF}
              iLen := ADWideStrLen(PWideChar(pData));
              if (caFixedLen in Attributes) and not llIsBlank and
                 GetOptions.FormatOptions.StrsTrim then
                while (iLen > 0) and (PWideChar(pData)[iLen - 1] = ' ') do
                  Dec(iLen);
              if (iLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
                llIsBlank := True;
            end;
          dtAnsiString:
            begin
              iRes := FCursorIntf.getString(SourceID, pData, llIsBlank);
              iLen := StrLen(PChar(pData));
              if (caFixedLen in Attributes) and not llIsBlank and
                 GetOptions.FormatOptions.StrsTrim then
                while (iLen > 0) and (PChar(pData)[iLen - 1] = ' ') do
                  Dec(iLen);
              if (iLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
                llIsBlank := True;
            end;
          dtDate:
            iRes := FCursorIntf.getDate(SourceID, pData, llIsBlank);
          dtTime:
            iRes := FCursorIntf.getTime(SourceID, pData, llIsBlank);
          dtDateTimeStamp:
            iRes := FCursorIntf.getTimeStamp(SourceID, pData, llIsBlank);
          dtBoolean:
            iRes := FCursorIntf.getShort(SourceID, pData, llIsBlank);
          dtInt16, dtUInt16:
            iRes := FCursorIntf.getShort(SourceID, pData, llIsBlank);
          dtInt32, dtUInt32:
            iRes := FCursorIntf.getLong(SourceID, pData, llIsBlank);
          dtInt64, dtUInt64:
{$IFDEF AnyDAC_D10}
            iRes := FCursorIntf.getInt64(SourceID, pData, llIsBlank);
{$ELSE}
            iRes := FCursorIntf.getLong(SourceID, pData, llIsBlank);
{$ENDIF}
          dtCurrency:
            begin
              iRes := FCursorIntf.getDouble(SourceID, @D, llIsBlank);
              C := D;
              pData := @C;
            end;
          dtDouble:
            iRes := FCursorIntf.getDouble(SourceID, pData, llIsBlank);
          dtByteString:
            begin
              iRes := FCursorIntf.getBytes(SourceID, pData, llIsBlank);
              if not (caFixedLen in Attributes) and not llIsBlank then begin
                iLen := PWord(pData)^;
                if (iLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
                  llIsBlank := True
                else
                  pData := PChar(pData) + SizeOf(Word);
              end;
            end;
          dtBCD, dtFmtBCD:
            iRes := FCursorIntf.getBcd(SourceID, pData, llIsBlank);
          dtMemo, dtBlob, dtHMemo, dtHBlob, dtHBFile, dtWideMemo, dtWideHMemo:
            if fiBlobs in GetFetchOptions.Items then begin
              iRes := FCursorIntf.getBlobSize(SourceID, lwBlobSize, llIsBlank);
              if iRes <> SQL_SUCCESS then begin
                llIsBlank := False;
                iRes := FCursorIntf.isBlobSizeExact(SourceID, llCanUseSize);
                if (iRes = SQL_SUCCESS) and not llCanUseSize then
                  iRes := TADPhysDBXConnection(FConnectionObj).FDbxConnection.getOption(
                    eConnBlobSize, @lwBlobSize, SizeOf(LongWord), siNotUsed);
              end;
              if (iRes = SQL_SUCCESS) and not (
                  llIsBlank or
                  (lwBlobSize = 0) and GetOptions.FormatOptions.StrsEmpty2Null
                 ) then begin
                pData := oRow.WriteBlobDirect(j, lwBlobSize);
                iRes := FCursorIntf.getBlob(SourceID, pData, llIsBlank, lwBlobSize);
              end
              else
                oRow.SetData(j, nil, 0);
            end
            else
              iRes := SQL_SUCCESS;
          dtRowRef, dtArrayRef:
            begin
              oTab := NestedTable;
              FetchRow(oTab, oRow);
              iRes := SQL_SUCCESS;
            end;
          dtRowSetRef, dtCursorRef:
            if fiDetails in GetFetchOptions.Items then begin
              { TODO -cDBExp : Check for RowRef (ADT) }
              iRes := DBXERR_INVALIDFLDTYPE;
            end
            else
              iRes := SQL_SUCCESS;
          else

            iRes := DBXERR_INVALIDFLDTYPE;
          end;
          if iRes in [DBXERR_EOF, SQL_NULL_DATA {$IFNDEF AnyDAC_D7}, SQL_ERROR_EOF {$ENDIF}] then
            Break;
          if (iRes = SQL_SUCCESS) and
             not (SourceDataType in [dtMemo, dtBlob, dtHMemo, dtHBlob, dtHBFile,
                                     dtWideMemo, dtWideHMemo,
                                     dtRowRef, dtArrayRef, dtRowSetRef, dtCursorRef]) then begin
            if llIsBlank then
              oRow.SetData(j, nil, 0)
            else begin
              oFmtOpts.ConvertRawData(SourceDataType, DataType, pData,
                iLen, pData, FBuffer.Size, iLen);
              oRow.SetData(j, pData, iLen);
            end;
          end
          else
            CheckCrs(iRes);
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
function TADPhysDBXCommand.InternalFetchRowSet(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowsetSize: LongWord): LongWord;
var
  i: LongWord;
  iRes: SQLResult;
begin
  Result := 0;
  for i := 1 to ARowsetSize do begin
    iRes := FCursorIntf.next;
    if iRes in [DBXERR_EOF, SQL_NULL_DATA {$IFNDEF AnyDAC_D7}, SQL_ERROR_EOF {$ENDIF}] then
      Break;
    CheckCrs(iRes);
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

procedure TADPhysDBXCommand.OpenMetaInfo;
var
  liScope: LongWord;
  qsWildcard, qsCmd: SQLString;
  pWildCard, pCmd: PSQLChar;
  rName: TADPhysParsedName;

  procedure GetObjWildcard;
  begin
    if GetWildcard = '' then
      pWildCard := nil
    else begin
      qsWildcard := GetWildcard;
      pWildCard := PSQLChar(qsWildcard);
    end;
  end;

  procedure GetObjName;
  var
    oConnMeta: IADPhysConnectionMetadata;
  begin
    TADPhysDBXConnection(FConnectionObj).CreateMetadata(oConnMeta);
    oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self, [doNormalize, doUnquote]);
    CheckMetaInfoParams(rName);
    if rName.FObject = '' then
      pCmd := nil
    else begin
      qsCmd := rName.FObject;
      pCmd := PSQLChar(qsCmd);
    end;
  end;

  procedure SetCatalogSchemaFromObj;
  begin
    if rName.FCatalog <> '' then
      FCursorMetaIntf.setOption(eMetaCatalogName, LongInt(PSQLChar(SQLString(rName.FCatalog))));
    if rName.FSchema <> '' then
      FCursorMetaIntf.setOption(eMetaSchemaName, LongInt(PSQLChar(SQLString(rName.FSchema))));
  end;

  procedure SetCatalogSchemaFilter;
  begin
    if GetCatalogName <> '' then
      FCursorMetaIntf.setOption(eMetaCatalogName, LongInt(PSQLChar(SQLString(GetCatalogName))));
    if GetSchemaName <> '' then
      FCursorMetaIntf.setOption(eMetaSchemaName, LongInt(PSQLChar(SQLString(GetSchemaName))));
  end;

begin
  if GetMetaInfoKind in [mkForeignKeys, mkForeignKeyFields] then
    Exit;
  try
    TADPhysDBXConnection(FConnectionObj).CreateMetaIntf(FCursorMetaIntf);
    case GetMetaInfoKind of
    mkTables:
      begin
        GetObjWildcard;
        SetCatalogSchemaFilter;
        liScope := 0;
        if tkTable in GetTableKinds then
          liScope := liScope or eSQLTable;
        if tkView in GetTableKinds then
          liScope := liScope or eSQLView;
        if tkSynonym in GetTableKinds then
          liScope := liScope or eSQLSynonym;
{$IFDEF AnyDAC_D7}
        if tkTempTable in GetTableKinds then
          liScope := liScope or eSQLTempTable;
        if tkLocalTable in GetTableKinds then
          liScope := liScope or eSQLLocal;
{$ENDIF}
        if (osSystem in GetObjectScopes) and (tkTable in GetTableKinds) then
          liScope := liScope or eSQLSystemTable;
        CheckMeta(FCursorMetaIntf.getTables(pWildCard, liScope, FCursorIntf), FCursorMetaIntf);
      end;
    mkTableFields:
      begin
        GetObjWildcard;
        GetObjName;
        SetCatalogSchemaFromObj;
        CheckMeta(FCursorMetaIntf.getColumns(pCmd, pWildCard, 0, FCursorIntf), FCursorMetaIntf);
      end;
    mkIndexes:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        CheckMeta(FCursorMetaIntf.getIndices(pCmd, 0, FCursorIntf), FCursorMetaIntf);
      end;
    mkPrimaryKey:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        CheckMeta(FCursorMetaIntf.getIndices(pCmd, 0, FCursorIntf), FCursorMetaIntf);
      end;
    mkIndexFields:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        CheckMeta(FCursorMetaIntf.getIndices(PSQLChar(SQLString(rName.FBaseObject)),
          0, FCursorIntf), FCursorMetaIntf);
      end;
    mkPrimaryKeyFields:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        CheckMeta(FCursorMetaIntf.getIndices(PSQLChar(SQLString(rName.FBaseObject)),
          0, FCursorIntf), FCursorMetaIntf);
      end;
    mkPackages:
      begin
        GetObjWildcard;
        SetCatalogSchemaFilter;
{$IFDEF AnyDAC_D7}
        CheckMeta(FCursorMetaIntf.getObjectList(eObjTypePackage, FCursorIntf), FCursorMetaIntf);
{$ELSE}
        CheckMeta(FCursorMetaIntf.getProcedures(pWildCard, eSQLPackage, FCursorIntf), FCursorMetaIntf);
{$ENDIF}
      end;
    mkProcs:
      begin
        GetObjName;
        GetObjWildcard;
{$IFDEF AnyDAC_D7}
        if rName.FBaseObject <> '' then begin
          SetCatalogSchemaFromObj;
          FCursorMetaIntf.setOption(eMetaPackageName, LongInt(PSQLChar(SQLString(rName.FBaseObject))));
        end
        else
          SetCatalogSchemaFilter;
{$ENDIF}
        liScope := eSQLProcedure or eSQLFunction;
        if osSystem in GetObjectScopes then
          liScope := liScope or eSQLSysProcedure;
        CheckMeta(FCursorMetaIntf.getProcedures(pWildCard, liScope, FCursorIntf), FCursorMetaIntf);
      end;
    mkProcArgs:
      begin
        GetObjName;
        SetCatalogSchemaFromObj;
        GetObjWildcard;
{$IFDEF AnyDAC_D7}
        if rName.FBaseObject <> '' then
          FCursorMetaIntf.setOption(eMetaPackageName, LongInt(PSQLChar(SQLString(rName.FBaseObject))));
{$ENDIF}
        CheckMeta(FCursorMetaIntf.getProcedureParams(pCmd, pWildCard, FCursorIntf), FCursorMetaIntf);
      end;
    end;
  except
    FCursorMetaIntf := nil;
    FCursorIntf := nil;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBXCommand.FetchMetaRow(ATable: TADDatSTable;
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
    iLen: Integer;
    iRes: SQLResult;
    llIsNull: LongBool;
{$IFDEF AnyDAC_DBX_ORASCHBUG}
    rName: TADPhysParsedName;
{$ENDIF}
  begin
    iLen := 0;
    llIsNull := False;
    case oRow.Table.Columns.ItemsI[ARowColIndex].DataType of
    dtInt16:
      iRes := FCursorIntf.getShort(ACrsColIndex, FBuffer.Ptr, llIsNull);
    dtInt32:
      iRes := FCursorIntf.getLong(ACrsColIndex, FBuffer.Ptr, llIsNull);
    dtAnsiString:
      begin
        iRes := FCursorIntf.getString(ACrsColIndex, FBuffer.Ptr, llIsNull);
        if not llIsNull then
          iLen := StrLen(PChar(FBuffer.Ptr));
      end;
    else
      iRes := SQL_SUCCESS;
      ASSERT(False);
    end;
    if iRes in [DBXERR_NOTSUPPORTED, DBXERR_EOF,
                SQL_NULL_DATA {$IFNDEF AnyDAC_D7}, SQL_ERROR_EOF {$ENDIF}] then
      Result := True
    else if iRes <> SQL_SUCCESS then
      CheckCrs(iRes);
    if llIsNull then begin
{$IFDEF AnyDAC_DBX_ORASCHBUG}
      if ACrsColIndex = 3 then begin
        oConnMeta.DecodeObjName(GetCommandText, rName, Self, [doNormalize]);
        if rName.FSchema = '' then
          oRow.SetData(ARowColIndex, nil, 0)
        else
          oRow.SetData(ARowColIndex, PChar(rName.FSchema), Length(rName.FSchema));
      end
      else
{$ENDIF}
      oRow.SetData(ARowColIndex, nil, 0);
    end
    else begin
{$IFDEF AnyDAC_DBX_ORACATBUG}
      if (ACrsColIndex = 2) and (StrLComp(PChar(FBuffer.Ptr), PChar('<NULL>'), 6) = 0) then
        oRow.SetData(ARowColIndex, nil, 0)
      else
{$ENDIF}
      oRow.SetData(ARowColIndex, FBuffer.Ptr, iLen);
    end;
  end;

  procedure GetIndexKind(ACrsColIndex: Integer; var AIndexKind: TADPhysIndexKind; var ADeleteRow: Boolean);
  var
    wDbxIndexKind: Word;
    llIsBlank: LongBool;
  begin
    wDbxIndexKind := 0;
    FCursorIntf.getShort(ACrsColIndex, @wDbxIndexKind, llIsBlank);
    if wDbxIndexKind and eSQLPrimaryKey <> 0 then
      AIndexKind := ikPrimaryKey
    else if wDbxIndexKind and eSQLUnique <> 0 then
      AIndexKind := ikUnique
    else
      AIndexKind := ikNonUnique;
{$IFDEF AnyDAC_DBX_GETINDBUG}
    if TADPhysDBXConnection(FConnectionObj).FBorlMSSQLDriver then begin
      if AIndexKind = ikUnique then
        AIndexKind := ikNonUnique
      else if AIndexKind = ikNonUnique then
        AIndexKind := ikUnique;
      if (GetMetaInfoKind = mkPrimaryKey) and (AIndexKind = ikNonUnique) then
        ADeleteRow := True;
    end
    else
{$ENDIF}
    if GetMetaInfoKind in [mkPrimaryKey, mkPrimaryKeyFields] then begin
      if TADPhysDBXConnection(FConnectionObj).GetRDBMSKindFromAlias = mkMSAccess then begin
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
                       TADPhysDBXConnection(FConnectionObj).FDefaultSchemaName) = 0 then
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
        iDbxTableType := 0;
        FCursorIntf.getLong(5, @iDbxTableType, llIsBlank);
        GetScope(2, eScope);
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
        iDbxType := 0;
        FCursorIntf.getLong(7, @iDbxType, llIsBlank);
        wDbxDataType := 0;
        FCursorIntf.getShort(8, @wDbxDataType, llIsBlank);
        wDbxSubType := 0;
        FCursorIntf.getShort(10, @wDbxSubType, llIsBlank);
        iDbxPrec := 0;
        FCursorIntf.getLong(11, @iDbxPrec, llIsBlank);
        siDbxScale := 0;
        FCursorIntf.getShort(12, @siDbxScale, llIsBlank);
        wDbxNullable := 0;
        FCursorIntf.getShort(14, @wDbxNullable, llIsBlank);
        Dbx2ADColInfo(wDbxDataType, wDbxSubType, iDbxPrec, siDbxScale,
          eType, eAttrs, iLen, iPrec, iScale);
        if wDbxNullable <> 0 then
          Include(eAttrs, caAllowNull);
        if iDbxType and eSQLRowId <> 0 then
          Include(eAttrs, caROWID);
        if iDbxType and eSQLRowVersion <> 0 then
          Include(eAttrs, caRowVersion);
        if iDbxType and eSQLAutoIncr <> 0 then
          Include(eAttrs, caAutoInc);
        if iDbxType and eSQLDefault <> 0 then
          Include(eAttrs, caDefault);
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
            (sSchema, TADPhysDBXConnection(FConnectionObj).GetConnectionDef.AsString[szUSERNAME]) = 0 then
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
        iDbxProcType := 0;
        FCursorIntf.getLong(5, @iDbxProcType, llIsBlank);
        if iDbxProcType and eSQLPackage <> 0 then
          lDeleteRow := True
        else begin
          GetScope(2, eScope);
          if iDbxProcType and eSQLProcedure <> 0 then
            eProcType := pkProcedure
          else if iDbxProcType and eSQLFunction <> 0 then
            eProcType := pkFunction
          else if iDbxProcType and eSQLSysProcedure <> 0 then begin
            eProcType := pkProcedure;
            eScope := osSystem;
          end
          else
            eProcType := pkProcedure;
          oRow.SetData(6, Integer(eProcType));
          oRow.SetData(7, SmallInt(eScope));
          SetData(6, 8);
          SetData(7, 9);
        end;
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
        wDbxParamType := 0;
        FCursorIntf.getShort(7, @wDbxParamType, llIsBlank); // PARAM_TYPE
        case TSTMTParamType(wDbxParamType) of
        paramIN:    eParamType := ptInput;
        paramOUT:   eParamType := ptOutput;
        paramINOUT: eParamType := ptInputOutput;
        paramRET:   eParamType := ptResult;
        else        eParamType := ptUnknown;
        end;
        oRow.SetData(8, Integer(eParamType));
        SetData(10, 10);
        wDbxDataType := 0;
        FCursorIntf.getShort(8, @wDbxDataType, llIsBlank);  // PARAM_DATATYPE
        wDbxSubType := 0;
        FCursorIntf.getShort(9, @wDbxSubType, llIsBlank);   // PARAM_SUBTYPE
        iDbxPrec := 0;
        FCursorIntf.getLong(12, @iDbxPrec, llIsBlank);      // PARAM_PRECISION
        siDbxScale := 0;
        FCursorIntf.getShort(13, @siDbxScale, llIsBlank);   // PARAM_SCALE
        wDbxNullable := 0;
        FCursorIntf.getShort(14, @wDbxNullable, llIsBlank); // PARAM_NULLABLE
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
  {$IFDEF AnyDAC_DBX_ODBCINDBUG}
        if TADPhysDBXConnection(FConnectionObj).FOpenODBCDriver then begin
          SetData(7, 5); // column_name
          SetData(8, 6); // column_position
        end
        else begin
  {$ENDIF}
          SetData(6, 5); // column_name
          SetData(7, 6); // column_position
  {$IFDEF AnyDAC_DBX_ODBCINDBUG}
        end;
  {$ENDIF}
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
  ADPhysManagerObj.RegisterPhysConnectionClass(TADPhysDBXConnection);

finalization
//  ADPhysManagerObj.UnRegisterPhysConnectionClass(TADPhysDBXConnection);

end.
