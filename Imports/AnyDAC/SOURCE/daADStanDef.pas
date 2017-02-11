{-------------------------------------------------------------------------------}
{ AnyDAC persistent definitions                                                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADStanDef;

interface

function ADLoadConnDefGlobalFileName: String;
procedure ADSaveConnDefGlobalFileName(const AName: String);

implementation

uses
  Windows, SysUtils, Classes, Registry, IniFiles,
  daADStanIntf, daADStanFactory, daADStanUtil, daADStanError, daADStanConst,
    daADStanOption, daADStanResStrs;

type
  TADCustomDefinitionStorage = class;
  TADFileDefinitionStorage = class;
{$IFNDEF AnyDAC_FPC}
  TADRegistryDefinitionStorage = class;
{$ENDIF}
  TADDefinition = class;
  TADDefinitions = class;
  TADDefinitionClass = class of TADDefinition;
  TADConnectionDef = class;
  TADConnectionDefs = class;

  TADCustomDefinitionStorage = class (TADObject, IADStanDefinitionStorage)
  private
    FFileName: String;
    FGlobalFileName: String;
    FDefaultFileName: String;
  protected
    // IADStanDefinitionStorage
    function GetFileName: String;
    procedure SetFileName(const AValue: String);
    function GetGlobalFileName: String;
    procedure SetGlobalFileName(const AValue: String);
    function GetDefaultFileName: String;
    procedure SetDefaultFileName(const AValue: String);
    function CreateIniFile: TCustomIniFile; virtual; abstract;
    function ActualFileName: String; virtual; abstract;
  end;

  TADFileDefinitionStorage = class(TADCustomDefinitionStorage)
  public
    function CreateIniFile: TCustomIniFile; override;
    function ActualFileName: String; override;
  end;

{$IFNDEF AnyDAC_FPC}
  TADRegistryDefinitionStorage = class(TADCustomDefinitionStorage)
  public
    function CreateIniFile: TCustomIniFile; override;
    function ActualFileName: String; override;
  end;
{$ENDIF}

  TADDefinition = class (TCollectionItem, IUnknown, IADStanDefinition)
  private
    FOriginalName,
    FPrevName: String;
    FParams: TStrings;
    FState: TADDefinitionState;
    FStyle: TADDefinitionStyle;
    FParentDefinition: IADStanDefinition;
    FParentDefinitionMaybeChanged: Boolean;
    FOnChanging: TNotifyEvent;
    FOnChanged: TNotifyEvent;
    FRefCount: Integer;
    FRefManaged: Boolean;
    FPassCode: LongWord;
    FProtectAgainst: TADStanDefinitionUpdates;
    function GetDefinitionList: TADDefinitions;
    procedure Normalize;
    procedure Migrate;
    procedure ParamsChanging(Sender: TObject);
    procedure CheckRO(AUpdate: TADStanDefinitionUpdate);
    procedure UpdateParentDefinition;
  protected
    // IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    // IADStanDefinition
    function GetName: String;
    function GetParams: TStrings;
    function GetAsBoolean(const AName: String): LongBool;
    function GetAsInteger(const AName: String): LongInt;
    function GetAsString(const AName: String): String;
    function GetState: TADDefinitionState;
    function GetStyle: TADDefinitionStyle;
    function GetParentDefinition: IADStanDefinition;
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
{$IFDEF AnyDAC_MONITOR}
    procedure BaseTrace(const AMonitor: IADMoniClient);
    procedure Trace(const AMonitor: IADMoniClient);
{$ENDIF}
    procedure Apply;
    procedure Clear;
    procedure Cancel;
    procedure Delete;
    procedure MarkPersistent; virtual;
    procedure OverrideBy(const ADefinition: IADStanDefinition; AAll: Boolean);
    function ParseString(const AStr: String; AKeywords: TStrings = nil): String; overload;
    function ParseString(const AStr: String; AKeywords: TStrings; const AFmt: TADParseFmtSettings): String; overload;
    function BuildString(AKeywords: TStrings = nil): String; overload;
    function BuildString(AKeywords: TStrings; const AFmt: TADParseFmtSettings): String; overload;
    function HasValue(const AName: String): Boolean; overload;
    function HasValue(const AName: String; var ALevel: Integer): Boolean; overload;
    function OwnValue(const AName: String): Boolean;
    procedure ToggleUpdates(APassCode: LongWord; AProtectAgainst: TADStanDefinitionUpdates);
    // other
    procedure ParamsChanged(Sender: TObject);
    procedure ReadFrom(AReader: TCustomIniFile);
    procedure WriteTo(AWriter: TCustomIniFile; AIfModified: Boolean = True);
  public
    constructor Create(ACollection: TCollection); override;
    constructor CreateStandalone;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    class function NewInstance: TObject; override;
    property OriginalName: String read FOriginalName;
    property DefinitionList: TADDefinitions read GetDefinitionList;
  end;

  { TADDefinitionStandalone }

  TADDefinitionStandalone = class(TADObject, IADStanDefinition)
  private
    FDef: IADStanDefinition;
  protected
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
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

  TADDefinitionsState = (dsNotLoaded, dsLoading, dsLoaded);
  TADDefinitions = class (TADObject, IADStanDefinitions)
  private
    FAutoLoad: Boolean;
    FState: TADDefinitionsState;
    FStorage: IADStanDefinitionStorage;
    FList: TCollection;
    FLock: TADMREWSynchronizer;
    FBeforeLoad,
    FAfterLoad: TNotifyEvent;
    FHasCommonSettings: Boolean;
    procedure InternalDelete(ADefinition: TADDefinition);
    function InternalAdd: TADDefinition;
    procedure CheckLoaded;
    function InternalFindDefinition(const AName: String;
      AExclude: TADDefinition): TADDefinition;
    function BuildUniqueName(const AName: String; AItem: TADDefinition): String;
    function IsUniqueName(const AName: String; AItem: TADDefinition): Boolean;
  protected
    // IADStanDefinitions
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
    // other
    function CreateIniFile: TCustomIniFile;
    function GetItemClass: TADDefinitionClass; virtual;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

  TADConnectionDef = class (TADDefinition, IADStanConnectionDef)
  protected
    // IADStanConnectionDef
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
    procedure WriteOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
    procedure ReadOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
  public
    procedure MarkPersistent; override;
  end;

  { TADConnectionDefStandalone }

  TADConnectionDefStandalone = class(TADDefinitionStandalone, IADStanConnectionDef)
  private
    FConDef: IADStanConnectionDef;
  protected
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
    procedure WriteOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
    procedure ReadOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

  TADConnectionDefs = class (TADDefinitions, IADStanConnectionDefs)
  protected
    // IADStanConnectionDefs
    function GetConnectionDefs(AIndex: Integer): IADStanConnectionDef;
    function AddConnectionDef: IADStanConnectionDef;
    function FindConnectionDef(const AName: String): IADStanConnectionDef;
    function ConnectionDefByName(const AName: String): IADStanConnectionDef;
    // other
    function GetItemClass: TADDefinitionClass; override;
  public
    procedure Initialize; override;
  end;

  TADOptsComponent = class(TADComponent)
  private
    FFetchOptions: TADFetchOptions;
    FFormatOptions: TADFormatOptions;
    FUpdateOptions: TADUpdateOptions;
    FResourceOptions: TADResourceOptions;
  published
    property FetchOptions: TADFetchOptions read FFetchOptions write FFetchOptions;
    property FormatOptions: TADFormatOptions read FFormatOptions write FFormatOptions;
    property UpdateOptions: TADUpdateOptions read FUpdateOptions write FUpdateOptions;
    property ResourceOptions: TADResourceOptions read FResourceOptions write FResourceOptions;
  end;

{-------------------------------------------------------------------------------}
{ TADCustomDefinitionStorage                                                    }
{-------------------------------------------------------------------------------}
function TADCustomDefinitionStorage.GetDefaultFileName: String;
begin
  Result := FDefaultFileName;
end;

{-------------------------------------------------------------------------------}
function TADCustomDefinitionStorage.GetFileName: String;
begin
  Result := FFileName;
end;

{-------------------------------------------------------------------------------}
function TADCustomDefinitionStorage.GetGlobalFileName: String;
begin
  Result := FGlobalFileName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomDefinitionStorage.SetDefaultFileName(const AValue: String);
begin
  FDefaultFileName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomDefinitionStorage.SetFileName(const AValue: String);
begin
  FFileName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomDefinitionStorage.SetGlobalFileName(const AValue: String);
begin
  FGlobalFileName := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADFileDefinitionStorage                                                      }
{-------------------------------------------------------------------------------}
function TADFileDefinitionStorage.ActualFileName: String;
begin
  Result := ADGetBestPath(GetFileName, GetGlobalFileName, GetDefaultFileName);
end;

{-------------------------------------------------------------------------------}
function TADFileDefinitionStorage.CreateIniFile: TCustomIniFile;
begin
  Result := TIniFile.Create(ActualFileName);
end;

{$IFNDEF AnyDAC_FPC}
{-------------------------------------------------------------------------------}
{ TADRegistryDefinitionStorage                                                  }
{-------------------------------------------------------------------------------}
function TADRegistryDefinitionStorage.ActualFileName: String;
begin
  if GetFileName = '' then
    Result := GetGlobalFileName {S_AD_CfgKeyName} + '\' + GetDefaultFileName
  else
    Result := GetFileName;
end;

{-------------------------------------------------------------------------------}
function TADRegistryDefinitionStorage.CreateIniFile: TCustomIniFile;
begin
  Result := TRegistryIniFile.Create(ActualFileName);
  TRegistryIniFile(Result).RegIniFile.RootKey := HKEY_LOCAL_MACHINE;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{- TADDefinitionCollection                                                     -}
{-------------------------------------------------------------------------------}
type
  TADDefinitionCollection = class(TCollection)
  private
    FDefinitionList: TADDefinitions;
  public
    constructor Create(AList: TADDefinitions;
      AItemClass: TADDefinitionClass);
  end;

{-------------------------------------------------------------------------------}
constructor TADDefinitionCollection.Create(AList: TADDefinitions;
  AItemClass: TADDefinitionClass);
begin
  inherited Create(AItemClass);
  FDefinitionList := AList;
end;

{-------------------------------------------------------------------------------}
{- TADDefinition                                                               -}
{-------------------------------------------------------------------------------}
constructor TADDefinition.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FParams := TStringList.Create;
  TStringList(FParams).OnChange := ParamsChanged;
  TStringList(FParams).OnChanging := ParamsChanging;
  Clear;
end;

{-------------------------------------------------------------------------------}
constructor TADDefinition.CreateStandalone;
begin
  Create(nil);
  FParams.Clear;
  FStyle := atInternal;
  FRefManaged := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDefinition.Destroy;
begin
  CheckRO(auDelete);
  SetParentDefinition(nil);
  FreeAndNil(FParams);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.AfterConstruction;
begin
  InterlockedDecrement(FRefCount);
end;

{-------------------------------------------------------------------------------}
class function TADDefinition.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TADDefinition(Result).FRefCount := 1;
end;

{-------------------------------------------------------------------------------}
function TADDefinition._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount)
end;

{-------------------------------------------------------------------------------}
function TADDefinition._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if (Result = 0) and FRefManaged then
    Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetDefinitionList: TADDefinitions;
begin
  if Collection <> nil then
    Result := TADDefinitionCollection(Collection).FDefinitionList
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetParentDefinition(const AValue: IADStanDefinition);
begin
  if (AValue <> nil) and (AValue = Self as IADStanDefinition) then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefCircular, [GetName]);
  if FParentDefinition <> AValue then begin
    FParentDefinition := AValue;
    Normalize;
    Migrate;
  end;
  FParentDefinitionMaybeChanged := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.UpdateParentDefinition;
var
  s: String;
begin
  if FParentDefinitionMaybeChanged and (GetDefinitionList <> nil) then begin
    FParentDefinitionMaybeChanged := False;
    s := GetAsString(S_AD_DefinitionParam_Common_Parent);
    if s = '' then
      s := GetAsString(S_AD_DefinitionParam_Common_ConnectionDef);
    if s <> '' then
      SetParentDefinition(GetDefinitionList.DefinitionByName(s));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Normalize;
var
  i, j: Integer;
  sName: String;
begin
  if FParentDefinition <> nil then begin
    FParams.BeginUpdate;
    try
      i := FParams.Count - 1;
      while i >= 0 do begin
        sName := FParams.Names[i];
        j := FParams.IndexOfName(sName);
        if j < i then begin
          FParams.Delete(j);
          Dec(i);
        end;
        if AnsiCompareText(FParentDefinition.GetAsString(sName), FParams.Values[sName]) = 0 then
          FParams.Delete(i);
        Dec(i);
      end;
    finally
      FParams.EndUpdate;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Migrate;
var
  i: Integer;
begin
  // v 1.4.0
  i := FParams.IndexOfName(S_AD_ConnParam_Common_DriverID);
  if (i <> -1) and (AnsiCompareText(FParams.Values[S_AD_ConnParam_Common_DriverID], S_AD_MSSQLId) = 0) then
    FParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_MSSQL2000Id;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.OverrideBy(const ADefinition: IADStanDefinition; AAll: Boolean);
var
  i: Integer;
  sName, sValue: String;
begin
  CheckRO(auModify);
  if ADefinition <> nil then
    for i := 0 to ADefinition.Params.Count - 1 do begin
      sName := ADefinition.Params.Names[i];
      sValue := ADefinition.Params.Values[sName];
      if AAll or (sValue <> '') then
        SetAsString(sName, sValue);
    end;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.ParseString(const AStr: String; AKeywords: TStrings): String;
begin
  Result := ParseString(AStr, AKeywords, GParseFmtSettings);
end;

{-------------------------------------------------------------------------------}
function TADDefinition.ParseString(const AStr: String; AKeywords: TStrings;
  const AFmt: TADParseFmtSettings): String;
var
  i, j: Integer;
  sParam, sValue, sId: String;
  lFound: Boolean;
begin
  i := 1;
  Result := '';
  while i <= Length(AStr) do begin
    sParam := ADExtractFieldName(AStr, i, AFmt);
    j := Pos('=', sParam);
    if j <> 0 then begin
      sId := Copy(sParam, 1, j - 1);
      sValue := Copy(sParam, j + 1, Length(sParam));
    end
    else begin
      sId := sParam;
      sValue := '';
    end;
    if (AKeywords <> nil) and (AKeywords.Count > 0) then begin
      lFound := False;
      for j := 0 to AKeywords.Count - 1 do begin
        if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
           (ADValueFromIndex(AKeywords, j), sId) = 0 then begin
          sId := AKeywords.Names[j];
          lFound := True;
        end
        else if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
                (AKeywords[j], sId) = 0 then
          lFound := True;
        if lFound then
          Break;
      end;
    end
    else
      lFound := True;
    if sId <> '' then
      if lFound then begin
        if (sValue <> '') and (
            (sValue[1] = AFmt.FQuote) and (sValue[Length(sValue)] = AFmt.FQuote) or
            (sValue[1] = AFmt.FQuote1) and (sValue[Length(sValue)] = AFmt.FQuote2)
           ) then
          sValue := Copy(sValue, 2, Length(sValue) - 2);
        SetAsString(sId, sValue);
      end
      else begin
        if Result <> '' then
          Result := Result + AFmt.FDelimiter;
        Result := Result + sParam;
      end;
  end;
  Normalize;
  Migrate;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.BuildString(AKeywords: TStrings): String;
begin
  Result := BuildString(AKeywords, GParseFmtSettings);
end;

{-------------------------------------------------------------------------------}
type
  TADKwdValue = class(TObject)
  private
    FId, FVal: String;
    FKwdPos: Integer;
  public
    constructor Create(const AId, AVal: String; AKwdPos: Integer);
  end;

constructor TADKwdValue.Create(const AId, AVal: String; AKwdPos: Integer);
begin
  inherited Create;
  FId := AId;
  FVal := AVal;
  FKwdPos := AKwdPos;
end;

function SortByKwdPos(AList: TStringList; AIndex1, AIndex2: Integer): Integer;
begin
  Result := TADKwdValue(AList.Objects[AIndex1]).FKwdPos -
    TADKwdValue(AList.Objects[AIndex2]).FKwdPos;
end;

function TADDefinition.BuildString(AKeywords: TStrings; const AFmt: TADParseFmtSettings): String;
var
  i, j, iKwdPos, iParamsProcessed: Integer;
  sId, sVal: String;
  oKeywordValues: TStringList;
  oDef: IADStanDefinition;
  lFound: Boolean;
  oKwdValue: TADKwdValue;

  function AddParam(const AStr, AId, AValue: String): String;
  var
    lSpecialSymbol: Boolean;
    j: Integer;
  begin
    with AFmt do begin
      lSpecialSymbol := False;
      if not ((AValue[1] = FQuote1) and (AValue[Length(AValue)] = FQuote2) or
              (AValue[1] = FQuote) and (AValue[Length(AValue)] = FQuote)) then
        for j := 1 to Length(AValue) do
          if AValue[j] in ['[', ']', '{', '}', '(', ')', ',', ';', '?', '*', '=', '!', '@'] then begin
            lSpecialSymbol := True;
            Break;
          end;
      if lSpecialSymbol then
        Result := Format('%s%s=%s%s%s%s', [AStr, AId, FQuote1, AValue, FQuote2, FDelimiter])
      else
        Result := Format('%s%s=%s%s', [AStr, AId, AValue, FDelimiter]);
    end;
  end;

begin
  oKeywordValues := TStringList.Create;
  oKeywordValues.Sorted := True;
  iParamsProcessed := 0;
  try
    oDef := Self as IADStanDefinition;
    while oDef <> nil do begin
      for i := 0 to oDef.Params.Count - 1 do begin
        sId := oDef.Params.Names[i];
        sVal := ADExpandStr(ADValueFromIndex(oDef.Params, i));
        iKwdPos := iParamsProcessed;
        Inc(iParamsProcessed);
        if (sVal <> '') and (AKeywords <> nil) and (AKeywords.Count > 0) then begin
          lFound := False;
          for j := 0 to AKeywords.Count - 1 do begin
            if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
               (AKeywords.Names[j], sId) = 0 then begin
              sId := ADValueFromIndex(AKeywords, j);
              lFound := True;
            end
            else if {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
                    (AKeywords[j], sId) = 0 then
              lFound := True;
            if lFound then begin
              iKwdPos := j;
              Break;
            end;
          end;
          if not lFound then
            sId := '';
        end;
        if (sVal <> '') and (sId <> '') and (oKeywordValues.IndexOf(sId) = -1) then
          oKeywordValues.AddObject(sId, TADKwdValue.Create(sId, sVal, iKwdPos));
      end;
      oDef := oDef.ParentDefinition;
    end;

    Result := '';
    oKeywordValues.Sorted := False;
    oKeywordValues.CustomSort(SortByKwdPos);
    for i := 0 to oKeywordValues.Count - 1 do begin
      oKwdValue := TADKwdValue(oKeywordValues.Objects[i]);
      Result := AddParam(Result, oKwdValue.FId, oKwdValue.FVal);
      oKwdValue.Free;
    end;
    if (Result <> '') and (Result[Length(Result)] = AFmt.FDelimiter) then
      SetLength(Result, Length(Result) - 1);

  finally
    oKeywordValues.Free;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.CheckRO(AUpdate: TADStanDefinitionUpdate);
var
  s: String;
begin
  if (FPassCode <> 0) and (AUpdate in FProtectAgainst) then begin
    if AUpdate = auModify then
      s := 'change'
    else
      s := 'delete';
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefRO, [s, GetName]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.ParamsChanging(Sender: TObject);
begin
  CheckRO(auModify);
  FPrevName := GetName;
  if Assigned(FOnChanging) then
    FOnChanging(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.ParamsChanged(Sender: TObject);
var
  sNewName: String;
begin
  if FState = asLoaded then
    FState := asModified;
  FParentDefinitionMaybeChanged := True;
  if (Collection <> nil) and (FPrevName <> '') then
    try
      sNewName := GetName;
      if (FPrevName <> sNewName) and not DefinitionList.IsUniqueName(sNewName, Self) then begin
        SetName(FPrevName);
        ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefDupName, [sNewName]);
      end;
    finally
      FPrevName := '';
    end;
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Clear;
begin
  CheckRO(auModify);
  FParams.Clear;
  FOriginalName := '';
  FPrevName := '';
  if Collection <> nil then
    SetName(DefinitionList.BuildUniqueName(S_AD_Unnamed, Self))
  else
    SetName(S_AD_Unnamed);
  if FState <> asLoading then
    FState := asAdded;
  FStyle := atPrivate;
  FRefManaged := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Apply;
var
  oIni: TCustomIniFile;
begin
  if (FStyle = atPersistent) and (FState <> asLoaded) then begin
    oIni := DefinitionList.CreateIniFile;
    try
      WriteTo(oIni, True);
    finally
      oIni.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Cancel;
var
  oIni: TCustomIniFile;
begin
  CheckRO(auModify);
  if (FStyle = atPrivate) or
     (FStyle = atPersistent) and (FState = asAdded) then begin
    DefinitionList.InternalDelete(Self);
    Exit;
  end
  else if (FStyle = atPersistent) and (FState <> asLoaded) then begin
    SetName(FOriginalName);
    oIni := DefinitionList.CreateIniFile;
    try
      if oIni.SectionExists(FOriginalName) then
        ReadFrom(oIni);
    finally
      oIni.Free;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Delete;
begin
  CheckRO(auDelete);
  if (FStyle = atPrivate) or
     (FStyle = atPersistent) and (FState = asAdded) then
    Cancel
  else
    FState := asDeleted;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.MarkPersistent;
begin
  if (DefinitionList = nil) or (GetName = '') then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefCantMakePers, []);
  FStyle := atPersistent;
  FRefManaged := False;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.HasValue(const AName: String): Boolean;
var
  iLevel: Integer;
begin
  iLevel := 0;
  Result := HasValue(AName, iLevel);
end;

{-------------------------------------------------------------------------------}
function TADDefinition.HasValue(const AName: String; var ALevel: Integer): Boolean;
var
  i: Integer;
  s: String;
begin
  Result := False;
  i := FParams.IndexOfName(AName);
  if i = -1 then begin
    if GetParentDefinition <> nil then begin
      Inc(ALevel);
      Result := GetParentDefinition.HasValue(AName, ALevel);
    end;
    if not Result then
      ALevel := $7FFFFFFF;
  end
  else begin
    s := ADValueFromIndex(FParams, i);
    if (s <> '') and ((s[1] <= ' ') or (s[Length(s)] <= ' ')) then
      s := Trim(s);
    Result := (s <> '');
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.OwnValue(const AName: String): Boolean;
begin
  Result := (FParams.IndexOfName(AName) <> -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.ToggleUpdates(APassCode: LongWord; AProtectAgainst: TADStanDefinitionUpdates);
begin
  if FPassCode = 0 then begin
    if AProtectAgainst <> [] then begin
      FPassCode := APassCode;
      FProtectAgainst := AProtectAgainst;
    end;
  end
  else if FPassCode <> APassCode then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefRO, [GetName])
  else begin
    FProtectAgainst := AProtectAgainst;
    if AProtectAgainst = [] then
      FPassCode := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetAsString(const AName: String): String;
var
  i: Integer;
begin
  Result := '';
  i := FParams.IndexOfName(AName);
  if i = -1 then begin
    if GetParentDefinition <> nil then begin
      Result := GetParentDefinition.GetAsString(AName);
      if (AnsiCompareText(AName, S_AD_DefinitionParam_Common_Name) = 0) and
         (AnsiCompareText(Result, S_AD_ConnParam_Common_Settings) = 0) then
        Result := '';
    end;
  end
  else begin
    Result := ADValueFromIndex(FParams, i);
    if (Result <> '') and ((Result[1] <= ' ') or (Result[Length(Result)] <= ' ')) then
      Result := Trim(Result);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetAsBoolean(const AName: String): LongBool;
var
  s: String;
begin
  s := GetAsString(AName);
  Result := (Length(s) > 0) and (s[1] in ['Y', 'y', 'T', 't']);
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetAsInteger(const AName: String): LongInt;
begin
  Result := StrToIntDef(GetAsString(AName), 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetAsString(const AName, AValue: String);
var
  sVal: String;
  i: Integer;
begin
  CheckRO(auModify);
  sVal := Trim(AValue);
  if GetAsString(AName) <> sVal then
    if GetParentDefinition <> nil then
      if AnsiCompareText(GetParentDefinition.GetAsString(AName), sVal) = 0 then begin
        i := FParams.IndexOfName(AName);
        if i <> -1 then
          FParams.Delete(i);
      end
      else
        FParams.Values[AName] := sVal
    else
      FParams.Values[AName] := sVal;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetAsBoolean(const AName: String; const AValue: LongBool);
begin
  if GetAsBoolean(AName) <> AValue then
    if AValue then
      SetAsString(AName, S_AD_True)
    else
      SetAsString(AName, S_AD_False);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetAsYesNo(const AName: String; const AValue: LongBool);
begin
  if GetAsBoolean(AName) <> AValue then
    if AValue then
      SetAsString(AName, S_AD_Yes)
    else
      SetAsString(AName, S_AD_No);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetAsInteger(const AName: String; const AValue: LongInt);
begin
  if GetAsInteger(AName) <> AValue then
    SetAsString(AName, IntToStr(AValue));
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetName: String;
begin
  Result := GetAsString(S_AD_DefinitionParam_Common_Name);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetName(const AValue: string);
begin
  SetAsString(S_AD_DefinitionParam_Common_Name, AValue);
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetParams: TStrings;
begin
  Result := FParams;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetParams(const AValue: TStrings);
begin
  CheckRO(auModify);
  FParams.Assign(AValue);
  Normalize;
  Migrate;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetParentDefinition: IADStanDefinition;
begin
  UpdateParentDefinition;
  Result := FParentDefinition;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetState: TADDefinitionState;
begin
  Result := FState;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetStyle: TADDefinitionStyle;
begin
  Result := FStyle;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetOnChanged: TNotifyEvent;
begin
  Result := FOnChanged;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetOnChanging: TNotifyEvent;
begin
  Result := FOnChanging;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetOnChanged(AValue: TNotifyEvent);
begin
  FOnChanged := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetOnChanging(AValue: TNotifyEvent);
begin
  FOnChanging := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.ReadFrom(AReader: TCustomIniFile);
var
  sName: String;
  lLoaded: Boolean;
begin
  CheckRO(auModify);
  sName := GetName;
  FState := asLoading;
  lLoaded := False;
  try
    Clear;
    if AReader.SectionExists(sName) then
      try
        AReader.ReadSectionValues(sName, FParams);
        Normalize;
        Migrate;
        FStyle := atPersistent;
        FRefManaged := False;
        FOriginalName := sName;
        lLoaded := True;
      except
        Clear;
        raise;
      end;
  finally
    SetName(sName);
    if lLoaded then
      FState := asLoaded
    else
      FState := asAdded;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.WriteTo(AWriter: TCustomIniFile; AIfModified: Boolean = True);
var
  sName: String;
  sOrigName: String;

  procedure DeleteOldSection;
  begin
    if (sOrigName <> '') and AWriter.SectionExists(sOrigName) then
      AWriter.EraseSection(sOrigName);
  end;

  procedure WriteNewSection;
  var
    i: Integer;
  begin
    for i := 0 to FParams.Count - 1 do
      if ADCompareText(FParams.Names[i], S_AD_DefinitionParam_Common_Name) <> 0 then
        AWriter.WriteString(sName, FParams.Names[i], FParams.Values[FParams.Names[i]]);
  end;

begin
  if FStyle = atPersistent then begin
    sName := GetName;
    sOrigName := FOriginalName;
    case FState of
    asLoaded:
      if not AIfModified then
        WriteNewSection;
    asModified:
      begin
        DeleteOldSection;
        WriteNewSection;
        FState := asLoaded;
      end;
    asDeleted:
      begin
        DeleteOldSection;
        DefinitionList.InternalDelete(Self);
      end;
    asAdded:
      begin
        WriteNewSection;
        FState := asLoaded;
      end;
    end;
    FOriginalName := sName;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TADDefinition.BaseTrace(const AMonitor: IADMoniClient);
var
  i: Integer;
  s: String;
begin
  if GetParentDefinition <> nil then
    GetParentDefinition.BaseTrace(AMonitor);
  for i := 0 to FParams.Count - 1 do begin
    if AnsiCompareText(FParams.Names[i], S_AD_ConnParam_Common_Password) = 0 then
      s := S_AD_ConnParam_Common_Password + '=*****'
    else if AnsiCompareText(FParams.Names[i], S_AD_ConnParam_Common_NewPassword) = 0 then
      s := S_AD_ConnParam_Common_NewPassword + '=*****'
    else if (AnsiCompareText(FParams.Names[i], S_AD_DefinitionParam_Common_Name) = 0) and
            (AnsiCompareText(ADValueFromIndex(FParams, i), S_AD_ConnParam_Common_Settings) = 0) then
      Continue
    else
      s := FParams[i];
    AMonitor.Notify(ekConnService, esProgress, Self, s, []);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Trace(const AMonitor: IADMoniClient);
begin
  if (AMonitor <> nil) and AMonitor.Tracing then begin
    AMonitor.Notify(ekConnService, esStart, Self, 'Definition', ['Name', GetName]);
    BaseTrace(AMonitor);
    AMonitor.Notify(ekConnService, esEnd, Self, 'Definition', ['Name', GetName]);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADDefinitionStandalone                                                       }
{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.Initialize;
begin
  inherited Initialize;
  FDef := TADDefinition.CreateStandalone as IADStanDefinition;
end;

{-------------------------------------------------------------------------------}
destructor TADDefinitionStandalone.Destroy;
begin
  FDef := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetName: string;
begin
  Result := FDef.GetName;
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetState: TADDefinitionState;
begin
  Result := FDef.GetState;
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetStyle: TADDefinitionStyle;
begin
  Result := FDef.GetStyle;
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetAsBoolean(const AName: string): LongBool;
begin
  result := FDef.GetAsBoolean(AName);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetAsInteger(const AName: string): LongInt;
begin
  Result := FDef.GetAsInteger(AName);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetAsString(const AName: string): string;
begin
  Result := FDef.GetAsString(AName);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetParentDefinition: IADStanDefinition;
begin
  Result := FDef.GetParentDefinition;
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetParams: TStrings;
begin
  Result := FDef.GetParams;
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetOnChanging: TNotifyEvent;
begin
  Result := FDef.GetOnChanging;
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.GetOnChanged: TNotifyEvent;
begin
  Result := FDef.GetOnChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.SetName(const AValue: string);
begin
  FDef.SetName(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.SetParams(const AValue: TStrings);
begin
  FDef.SetParams(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.SetAsBoolean(const AName: string; const AValue: LongBool);
begin
  FDef.SetAsBoolean(AName, AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.SetAsYesNo(const AName: string; const AValue: LongBool);
begin
  FDef.SetAsYesNo(AName, AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.SetAsInteger(const AName: string; const AValue: LongInt);
begin
  FDef.SetAsInteger(AName, AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.SetAsString(const AName, AValue: string);
begin
  FDef.SetAsString(AName, AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.SetParentDefinition(const AValue: IADStanDefinition);
begin
  FDef.SetParentDefinition(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.SetOnChanging(AValue: TNotifyEvent);
begin
  FDef.SetOnChanging(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.SetOnChanged(AValue: TNotifyEvent);
begin
  FDef.SetOnChanged(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.Apply;
begin
  FDef.Apply;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.Clear;
begin
  FDef.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.Cancel;
begin
  FDef.Cancel;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.Delete;
begin
  FDef.Delete;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.MarkPersistent;
begin
  FDef.MarkPersistent;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.OverrideBy(const ADefinition: IADStanDefinition; AAll: Boolean);
begin
  FDef.OverrideBy(ADefinition, AAll);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.ParseString(const AStr: string; AKeywords: TStrings): string;
begin
  Result := FDef.ParseString(AStr, AKeywords);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.ParseString(const AStr: string; AKeywords: TStrings; const AFmt: TADParseFmtSettings): string;
begin
  Result := FDef.ParseString(AStr, AKeywords, AFmt);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.BuildString(AKeywords: TStrings): string;
begin
  Result := FDef.BuildString(AKeywords);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.BuildString(AKeywords: TStrings; const AFmt: TADParseFmtSettings): string;
begin
  Result := FDef.BuildString(AKeywords, AFmt);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.HasValue(const AName: string): Boolean;
begin
  Result := FDef.HasValue(AName);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.HasValue(const AName: string; var ALevel: Integer): Boolean;
begin
  Result := FDef.HasValue(AName, ALevel);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionStandalone.OwnValue(const AName: string): Boolean;
begin
  Result := FDef.OwnValue(AName);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.ToggleUpdates(APassCode: LongWord; AProtectAgainst: TADStanDefinitionUpdates);
begin
  FDef.ToggleUpdates(APassCode, AProtectAgainst);
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TADDefinitionStandalone.BaseTrace(const AMonitor: IADMoniClient);
begin
  FDef.BaseTrace(AMonitor);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitionStandalone.Trace(const AMonitor: IADMoniClient);
begin
  FDef.Trace(AMonitor);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{- TADDefinitions                                                              -}
{-------------------------------------------------------------------------------}
procedure TADDefinitions.Initialize;
begin
  inherited Initialize;
  FAutoLoad := True;
  FState := dsNotLoaded;
  ADCreateInterface(IADStanDefinitionStorage, FStorage);
  FList := TADDefinitionCollection.Create(Self, GetItemClass);
  FLock := TADMREWSynchronizer.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDefinitions.Destroy;
begin
  FState := dsNotLoaded;
  FStorage := nil;
  FreeAndNil(FList);
  FreeAndNil(FLock);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetItemClass: TADDefinitionClass;
begin
  Result := TADDefinition;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.CreateIniFile: TCustomIniFile;
begin
  Result := FStorage.CreateIniFile;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.CheckLoaded;
begin
  if (FState = dsNotLoaded) and FAutoLoad then
    Load;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetLoaded: Boolean;
begin
  Result := (FState = dsLoaded);
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetAutoLoad: Boolean;
begin
  Result := FAutoLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.SetAutoLoad(AValue: Boolean);
begin
  FAutoLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetStorage: IADStanDefinitionStorage;
begin
  Result := FStorage;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetAfterLoad: TNotifyEvent;
begin
  Result := FAfterLoad;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetBeforeLoad: TNotifyEvent;
begin
  Result := FBeforeLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.SetAfterLoad(AValue: TNotifyEvent);
begin
  FAfterLoad := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.SetBeforeLoad(AValue: TNotifyEvent);
begin
  FBeforeLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.InternalAdd: TADDefinition;
begin
  BeginWrite;
  try
    CheckLoaded;
    Result := TADDefinition(FList.Add);
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.Add: IADStanDefinition;
begin
  Result := InternalAdd as IADStanDefinition;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.AddInternal: IADStanDefinition;
begin
  Result := GetItemClass.CreateStandalone as IADStanDefinition;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.InternalDelete(ADefinition: TADDefinition);
var
  i: Integer;
  oDef: IADStanDefinition;
begin
  BeginWrite;
  try
    oDef := ADefinition as IADStanDefinition;
    for i := 0 to FList.Count - 1 do
      if TADDefinition(FList.Items[i]).GetParentDefinition = oDef then
        TADDefinition(FList.Items[i]).SetParentDefinition(nil);
    ADefinition.FRefManaged := True;
    if ADefinition.FRefCount = 0 then
      ADefinition.Free;
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.Cancel;
var
  i: Integer;
begin
  BeginWrite;
  try
    for i := FList.Count - 1 downto 0 do
      TADDefinition(FList.Items[i]).Cancel;
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.Save(AIfModified: Boolean = True);
var
  i: Integer;
  oIni: TCustomIniFile;
begin
  BeginWrite;
  try
    oIni := CreateIniFile;
    try
      for i := FList.Count - 1 downto 0 do
        TADDefinition(FList.Items[i]).WriteTo(oIni, AIfModified);
    finally
      oIni.Free;
    end;
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.Load: Boolean;
var
  oList: TStringList;
  oIni: TCustomIniFile;
  i, j: Integer;
  oDefinition: TADDefinition;
begin
  BeginWrite;
  try
    if FState <> dsNotLoaded then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefAlreadyLoaded, []);
    FState := dsLoading;
    Result := False;
    FHasCommonSettings := False;
    try
      if Assigned(FBeforeLoad) then
        FBeforeLoad(Self);
      oList := TStringList.Create;
      try
{$IFDEF AnyDAC_D6Base}
        oList.CaseSensitive := False;
{$ENDIF}
        oIni := CreateIniFile;
        try
          if FileExists(GetStorage.ActualFileName) then begin
            Result := True;
            oIni.ReadSections(oList);
            oList.Sort;
{$IFDEF AnyDAC_D6Base}
            j := oList.IndexOf(S_AD_ConnParam_Common_Settings);
{$ELSE}
            j := 0;
            while (j < oList.Count) and (AnsiCompareText(oList[j], S_AD_ConnParam_Common_Settings) <> 0) do
              Inc(j);
            if j = oList.Count then
              j := -1;
{$ENDIF}
            FHasCommonSettings := (j <> -1);
            if j > 0 then
              oList.Move(j, 0);
            for i := 0 to oList.Count - 1 do begin
              oDefinition := InternalAdd;
              oDefinition.SetName(oList[i]);
              oDefinition.ReadFrom(oIni);
            end;
            if FHasCommonSettings then
              for i := 1 to oList.Count - 1 do begin
                oDefinition := TADDefinition(FList.Items[i]);
                if oDefinition.GetParentDefinition = nil then
                  oDefinition.SetParentDefinition(TADDefinition(FList.Items[0]));
              end;
          end;
        finally
          oIni.Free;
        end;
      finally
        oList.Free;
      end;
    finally
      if Result then begin
        FState := dsLoaded;
        if Assigned(FAfterLoad) then
          FAfterLoad(Self);
      end
      else
        FState := dsNotLoaded;
    end;
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.Clear;
begin
  BeginWrite;
  try
    FList.Clear;
    FState := dsNotLoaded;
    FHasCommonSettings := False;
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.InternalFindDefinition(const AName: String;
  AExclude: TADDefinition): TADDefinition;
var
  i: Integer;
  oDefinition: TADDefinition;
begin
  Result := nil;
  FLock.BeginRead;
  try
    CheckLoaded;
    for i := 0 to FList.Count - 1 do begin
      oDefinition := TADDefinition(FList.Items[i]);
      if (oDefinition <> AExclude) and (
         {$IFDEF AnyDAC_NOLOCALE_META} ADCompareText {$ELSE} AnsiCompareText {$ENDIF}
         (oDefinition.GetName, AName) = 0) then begin
        Result := oDefinition;
        Break;
      end;
    end;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.FindDefinition(const AName: String): IADStanDefinition;
begin
  Result := InternalFindDefinition(AName, nil) as IADStanDefinition;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.DefinitionByName(const AName: String): IADStanDefinition;
begin
  Result := FindDefinition(AName);
  if Result = nil then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefNotExists,
      [AName, FStorage.ActualFilename]);
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.BuildUniqueName(const AName: String; AItem: TADDefinition): String;
var
  i: Integer;
begin
  Result := AName;
  i := 0;
  FLock.BeginRead;
  try
    while InternalFindDefinition(Result, AItem) <> nil do begin
      Inc(i);
      Result := AName + '_' + IntToStr(i);
    end;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.IsUniqueName(const AName: String; AItem: TADDefinition): Boolean;
begin
  Result := InternalFindDefinition(AName, AItem) = nil;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetCount: Integer;
begin
  FLock.BeginRead;
  try
    CheckLoaded;
    Result := FList.Count;
    if FHasCommonSettings then
      Dec(Result);
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetItems(AIndex: Integer): IADStanDefinition;
begin
  FLock.BeginRead;
  try
    CheckLoaded;
    if FHasCommonSettings then
      Inc(AIndex);
    Result := TADDefinition(FList.Items[AIndex]) as IADStanDefinition;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.BeginRead;
begin
  FLock.BeginRead;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.EndRead;
begin
  FLock.EndRead;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.BeginWrite;
begin
  FLock.BeginWrite;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.EndWrite;
begin
  FLock.EndWrite;
end;

{-------------------------------------------------------------------------------}
{- TADConnectionDef                                                            -}
{-------------------------------------------------------------------------------}
procedure TADConnectionDef.MarkPersistent;
begin
  if GetDriverID = '' then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefCantMakePers, []);
  inherited MarkPersistent;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetPooled: Boolean;
begin
  Result := GetAsBoolean(S_AD_ConnParam_Common_Pooled);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetPooled(AValue: Boolean);
begin
  SetAsBoolean(S_AD_ConnParam_Common_Pooled, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetDriverID: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_DriverID);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetDriverID(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_DriverID, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetPassword: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_Password);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetPassword(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_Password, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetNewPassword: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_NewPassword);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetNewPassword(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_NewPassword, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetUserName: String;
var
  iLvlStd, iLvlBDE: Integer;
  lStd, lBde: Boolean;
begin
  iLvlStd := 0;
  iLvlBDE := 0;
  lStd := HasValue(S_AD_ConnParam_Common_UserName, iLvlStd);
  lBde := HasValue(S_AD_ConnParam_Common_BDEStyleUserName, iLvlBDE);
  if lStd or lBde then
    if iLvlStd < iLvlBDE then
      Result := GetAsString(S_AD_ConnParam_Common_UserName)
    else
      Result := GetAsString(S_AD_ConnParam_Common_BDEStyleUserName);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetUserName(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_UserName, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetDatabase: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_Database);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetDatabase(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_Database, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetExpandedDatabase: String;
begin
  Result := ADExpandStr(GetDatabase);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetMonitorBy: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_MonitorBy);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetMonitorBy(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_MonitorBy, AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.ReadOptions(AFormatOptions: TObject;
  AUpdateOptions: TObject; AFetchOptions: TObject; AResourceOptions: TObject);
{$IFNDEF AnyDAC_FPC}
var
  oComp: TADOptsComponent;
  oMS: TMemoryStream;
  oStr: TStringStream;
  oRdr: TReader;
  i: Integer;
  s: String;
  oDef: IADStanConnectionDef;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  s := 'object TADOptsComponent' + C_AD_EOL;
  oDef := Self as IADStanConnectionDef;
  while oDef <> nil do begin
    for i := 0 to oDef.Params.Count - 1 do
      if (Pos('fetchoptions.', LowerCase(oDef.Params.Names[i])) <> 0) or
         (Pos('formatoptions.', LowerCase(oDef.Params.Names[i])) <> 0) or
         (Pos('updateoptions.', LowerCase(oDef.Params.Names[i])) <> 0) or
         (Pos('resourceoptions.', LowerCase(oDef.Params.Names[i])) <> 0) then
        s := s + oDef.Params[i] + C_AD_EOL;
    oDef := oDef.ParentDefinition as IADStanConnectionDef;
  end;
  s := s + 'end';
  oComp := TADOptsComponent.Create(nil);
  try
    oComp.FetchOptions := AFetchOptions as TADFetchOptions;
    oComp.UpdateOptions := AUpdateOptions as TADUpdateOptions;
    oComp.FormatOptions := AFormatOptions as TADFormatOptions;
    oComp.ResourceOptions := AResourceOptions as TADResourceOptions;
    oStr := TStringStream.Create(s);
    try
      oMS := TMemoryStream.Create;
      oRdr := TReader.Create(oMS, 4096);
      try
        ObjectTextToBinary(oStr, oMS);
        oMS.Position := 0;
        oRdr.BeginReferences;
        try
          oRdr.ReadSignature;
          oRdr.ReadComponent(oComp);
        finally
          oRdr.EndReferences;
        end;
      finally
        oRdr.Free;
        oMS.Free;
      end;
    finally
      oStr.Free;
    end;
  finally
    oComp.Free;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.WriteOptions(AFormatOptions: TObject;
  AUpdateOptions: TObject; AFetchOptions: TObject; AResourceOptions: TObject);
{$IFNDEF AnyDAC_FPC}
var
  oComp: TADOptsComponent;
  oMS: TMemoryStream;
  oStr: TStringStream;
  i: Integer;
  pCh, pStart, pEnd, pWS: PChar;
  lValue, lCollection: Boolean;
  s: String;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  oComp := TADOptsComponent.Create(nil);
  try
    oComp.FetchOptions := AFetchOptions as TADFetchOptions;
    oComp.UpdateOptions := AUpdateOptions as TADUpdateOptions;
    oComp.FormatOptions := AFormatOptions as TADFormatOptions;
    oComp.ResourceOptions := AResourceOptions as TADResourceOptions;
    oMS := TMemoryStream.Create;
    try
      oMS.WriteComponent(oComp);
      oStr := TStringStream.Create('');
      try
        oMS.Position := 0;
        ObjectBinaryToText(oMS, oStr);
        s := oStr.DataString;
        pCh := PChar(s);
        while pCh^ <> #13 do
          Inc(pCh);
        pEnd := PChar(s) + Length(s) - 1;
        for i := 1 to 2 do begin
          while pEnd^ <> #13 do
            Dec(pEnd);
          if i <> 2 then
            Dec(pEnd)
          else
            Inc(pEnd)
        end;
        lValue := False;
        lCollection := False;
        Inc(pCh, 2);
        pStart := pCh;
        while pCh <= pEnd do begin
          if lCollection then begin
            if pCh^ = '>' then
              lCollection := False
            else if pCh^ = #13 then begin
              pCh^ := ' ';
              (pCh + 1)^ := ' ';
            end;
            if pCh^ = ' ' then begin
              pWS := pCh;
              while pCh^ = ' ' do
                Inc(pCh);
              if pCh - pWS > 1 then begin
                ADMove(pCh^, (pWS + 1)^, pEnd - pCh + 1);
                Dec(pEnd, pCh - pWS - 1);
                Dec(pCh, pCh - pWS - 1);
              end;
            end
            else
              Inc(pCh);
          end
          else begin
            if (pCh^ = ' ') and not lValue then begin
              ADMove((pCh + 1)^, pCh^, pEnd - pCh);
              Dec(pEnd);
            end
            else begin
              if pCh^ = '=' then
                lValue := True
              else if pCh^ = #10 then
                lValue := False
              else if pCh^ = '<' then
                lCollection := True;
              Inc(pCh);
            end;
          end;
        end;
        if pEnd - pStart - 1 > 0 then
          SetString(s, pStart, pEnd - pStart - 1)
        else
          s := '';
        i := 0;
        while i < GetParams.Count do
          if (ADCompareText(GetParams.Names[i], 'FetchOptions') = 0) or
             (ADCompareText(GetParams.Names[i], 'FormatOptions') = 0) or
             (ADCompareText(GetParams.Names[i], 'UpdateOptions') = 0) or
             (ADCompareText(GetParams.Names[i], 'ResourceOptions') = 0) then
            GetParams.Delete(i)
          else
            Inc(i);
        if s <> '' then
          GetParams.Text := GetParams.Text + s;
      finally
        oStr.Free;
      end;
    finally
      oMS.Free;
    end;
  finally
    oComp.Free;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ TADConnectionDefStandalone                                                    }
{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.Initialize;
begin
  FConDef := TADConnectionDef.CreateStandalone as IADStanConnectionDef;
  FDef := FConDef as IADStanDefinition;
end;

{-------------------------------------------------------------------------------}
destructor TADConnectionDefStandalone.Destroy;
begin
  FConDef := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefStandalone.GetPooled: Boolean;
begin
  Result := FConDef.GetPooled;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefStandalone.GetDriverID: String;
begin
  Result := FConDef.GetDriverID;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefStandalone.GetPassword: String;
begin
  Result := FConDef.GetPassword;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefStandalone.GetUserName: String;
begin
  Result := FConDef.GetUserName;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefStandalone.GetDatabase: String;
begin
  Result := FConDef.GetDatabase;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefStandalone.GetNewPassword: String;
begin
  Result := FConDef.GetNewPassword;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefStandalone.GetExpandedDatabase: String;
begin
  Result := FConDef.GetExpandedDatabase;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefStandalone.GetMonitorBy: String;
begin
  Result := FConDef.GetMonitorBy;
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.SetPooled(AValue: Boolean);
begin
  FConDef.SetPooled(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.SetDriverID(const AValue: String);
begin
  FConDef.SetDriverID(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.SetPassword(const AValue: String);
begin
  FConDef.SetPassword(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.SetUserName(const AValue: String);
begin
  FConDef.SetUserName(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.SetDatabase(const AValue: String);
begin
  FConDef.SetDatabase(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.SetNewPassword(const AValue: String);
begin
  FConDef.SetNewPassword(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.SetMonitorBy(const AValue: String);
begin
  FConDef.SetMonitorBy(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.WriteOptions(AFormatOptions: TObject;
  AUpdateOptions: TObject; AFetchOptions: TObject; AResourceOptions: TObject);
begin
  FConDef.WriteOptions(AFormatOptions, AUpdateOptions, AFetchOptions, AResourceOptions);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefStandalone.ReadOptions(AFormatOptions: TObject;
  AUpdateOptions: TObject; AFetchOptions: TObject; AResourceOptions: TObject);
begin
  FConDef.ReadOptions(AFormatOptions, AUpdateOptions, AFetchOptions, AResourceOptions);
end;

{-------------------------------------------------------------------------------}
{- TADConnectionDefs                                                           -}
{-------------------------------------------------------------------------------}
procedure TADConnectionDefs.Initialize;
begin
  inherited Initialize;
  GetStorage.DefaultFileName := S_AD_DefCfgFileName;
  GetStorage.GlobalFileName := ADLoadConnDefGlobalFileName;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.GetItemClass: TADDefinitionClass;
begin
  Result := TADConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.AddConnectionDef: IADStanConnectionDef;
begin
  Result := inherited Add as IADStanConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.FindConnectionDef(const AName: String): IADStanConnectionDef;
begin
  Result := inherited FindDefinition(AName) as IADStanConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.ConnectionDefByName(const AName: String): IADStanConnectionDef;
begin
  Result := inherited DefinitionByName(AName) as IADStanConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.GetConnectionDefs(AIndex: Integer): IADStanConnectionDef;
begin
  Result := inherited GetItems(AIndex) as IADStanConnectionDef;
end;

{-------------------------------------------------------------------------------}
procedure ADSaveConnDefGlobalFileName(const AName: String);
var
  oReg: TRegistry;
begin
  oReg := TRegistry.Create;
  try
    oReg.RootKey := HKEY_LOCAL_MACHINE;
    if oReg.OpenKey(S_AD_CfgKeyName, True) then
      oReg.WriteString(S_AD_CfgValName, AName)
    else
      ADException(nil, [S_AD_LStan, S_AD_LStan_PDef], er_AD_AccCantSaveCfgFileName, []);
  finally
    oReg.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function ADLoadConnDefGlobalFileName: String;
begin
  Result := ADReadRegValue(S_AD_CfgValName);
end;

{-------------------------------------------------------------------------------}
initialization
  TADMultyInstanceFactory.Create(TADFileDefinitionStorage, IADStanDefinitionStorage);
  TADMultyInstanceFactory.Create(TADDefinitionStandalone, IADStanDefinition);
  TADMultyInstanceFactory.Create(TADDefinitions, IADStanDefinitions);
  TADMultyInstanceFactory.Create(TADConnectionDefStandalone, IADStanConnectionDef);
  TADMultyInstanceFactory.Create(TADConnectionDefs, IADStanConnectionDefs);

end.
