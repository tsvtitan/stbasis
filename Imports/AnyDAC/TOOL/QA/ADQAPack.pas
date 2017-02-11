{-------------------------------------------------------------------------------}
{ AnyDAC QA test package manager implementation                                 }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit ADQAPack;

interface

uses
  Classes, SysUtils, Windows, Forms,
{$IFDEF AnyDAC_D6}
    StrUtils, Variants,
{$ENDIF}
  ADQAVarField,
  daADStanIntf,
  daADDatSManager,
  daADGUIxIntf,
  daADPhysIntf,
  daADCompClient;

type
  TADQATestExecMethod = procedure of object;

  TADQATestGroup =  class;
  TADQATestGroupList =  class;
  TADQATsHolderBase = class;

  TADQARDBMSKinds = set of TADRDBMSKind;

  TADQATsInfo = class (TObject)
  private
    FPack:   TADQATsHolderBase;
    FDEQATestName: String;
    FMethod: TADQATestExecMethod;
    FRDBMSKind: TADRDBMSKind;
    FRunBefore: Boolean;
  public
    procedure Run(ATraceList: TStrings);
    property ADQATestName: String read FDEQATestName write FDEQATestName;
    property Pack: TADQATsHolderBase read FPack write FPack;
    property Method: TADQATestExecMethod read FMethod write FMethod;
    property RDBMS: TADRDBMSKind read FRDBMSKind write FRDBMSKind;
    property RunBefore: Boolean read FRunBefore write FRunBefore;
  end;

  TADQATestListBase = class (TObject)
  private
    FDEQATests: TList;
    function GetCount: Integer;
    function GetDEQATestNames(AIndex: Integer): String;
    function GetDEQATsInfo(AIndex: Integer): TADQATsInfo;
  protected
    FPack:   TADQATsHolderBase;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const daADEQATestName: String; AMethod: TADQATestExecMethod;
      AKind: TADRDBMSKind = mkUnknown; ARunBeforeTest: Boolean = True); virtual;
    procedure Clear; virtual;
    property Count: Integer read GetCount;
    property ADQATestNames[Index: Integer]: String read GetDEQATestNames;
    property ADQATsInfo[Index: Integer]: TADQATsInfo read GetDEQATsInfo; default;
  end;

  TADQATestGroup = class (TADQATestListBase)
  private
    FParent: TADQATestGroup;
    FChildGroups: TADQATestGroupList;
    FName: String;
    function GetHasChildren: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    property Children: TADQATestGroupList read FChildGroups;
    property HasChildren: Boolean read GetHasChildren;
    property Name: String read FName write FName;
    property Parent: TADQATestGroup read FParent write FParent;
    property Pack: TADQATsHolderBase read FPack write FPack;
  end;

  TADQATestGroupList =  class (TObject)
  private
    FList: TStringList;
    FNext: Integer;
    function GetCount: Integer;
    function GetGroup(AIndex: Integer): TADQATestGroup;
    function GetGroupByName(AName: String): TADQATestGroup;
    function GetGroupName(AIndex: Integer): String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(AObj: TADQATestGroup);
    procedure Clear;
    function Find(AName: String; var AIndex: Integer): Boolean;
    function GetFirst: TADQATestGroup;
    function GetNext: TADQATestGroup;
    property Count: Integer read GetCount;
    property GroupByName[Name: String]: TADQATestGroup read GetGroupByName;
    property GroupNames[Index: Integer]: String read GetGroupName;
    property Groups[Index: Integer]: TADQATestGroup read GetGroup; default;
  end;

  TADQATsHolderBase = class (TObject)
  private
    FInfoList:  TList;
    FTraceList: TStrings;
    FName:      String;
    FRootGroup: TADQATestGroup;
    FCriticalSection: TRTLCriticalSection;
    function GetLastErrorCount: Integer;
    function GetInfoList: TList;
    procedure GetParamsArrayDB2;
    procedure GetParamsArrayMSAccess;
    procedure GetParamsArrayMSSQL;
    procedure GetParamsArrayASA;
    procedure GetParamsArrayMySQL;
    procedure GetParamsArrayOra;
    function ParsePath(const APath: String; out ATestName: String): TADQATestGroup;
  protected
    FDatSManager:  TADDatSManager;
    FConnIntf:     IADPhysConnection;
    FCommIntf:     IADPhysCommand;
    FTab:          TADDatSTable;
    FConnection:   TADConnection;
    FQuery:        TADQuery;
    FVarFieldList: TADQAVariantFieldList;
    FRDBMSKind:    TADRDBMSKind;
    function Avg  (ACol, ARowID: Integer; ATab: TADDatSTable = nil): Variant;
    function Count(ACol, ARowID: Integer; ATab: TADDatSTable = nil): Variant;
    function Max  (ACol, ARowID: Integer; ATab: TADDatSTable = nil): Variant;
    function Min  (ACol, ARowID: Integer; ATab: TADDatSTable = nil): Variant;
    function Sum  (ACol, ARowID: Integer; ATab: TADDatSTable = nil): Variant;
    function AvgGr  (ACol, ARowID, AGroupLevel: Integer; ATab: TADDatSTable = nil): Variant;
    function CountGr(ACol, ARowID, AGroupLevel: Integer; ATab: TADDatSTable = nil): Variant;
    function MaxGr  (ACol, ARowID, AGroupLevel: Integer; ATab: TADDatSTable = nil): Variant;
    function MinGr  (ACol, ARowID, AGroupLevel: Integer; ATab: TADDatSTable = nil): Variant;
    function SumGr  (ACol, ARowID, AGroupLevel: Integer; ATab: TADDatSTable = nil): Variant;
    function CompConnSwitch: Boolean;
    function ConnectionSwitch: Boolean;
    function CheckColumnsCount(ATab: TADDatSTable;
      ACount: Integer; ACheckedCount: Integer = -1; AComment: String = ''): Boolean;
    procedure CheckCommandState(AState: TADPhysCommandState;
      ACommIntf: IADPhysCommand; AComment: String = '');
    function CheckRowsCount(ATab: TADDatSTable;
      ACount: Integer; ACheckedCount: Integer = -1): Boolean;
    procedure DeleteFromSource;
    function GetDataType(AName: String): TADDatatype;
    function GetInsertString(AForDTM: Boolean = False): String;
    procedure GetParamsArray;
    function Insert(AForDTM: Boolean = False): Boolean;
  public
    constructor Create(const AName: String = ''); virtual;
    destructor Destroy; override;
    function RunBeforeTest: Boolean; virtual;     // this proc is run before test
    procedure ClearAfterTest; virtual;            // this proc is run after test
    procedure ClearHistory;
    procedure Error(const ErrorMsg: String);
    procedure Trace(const TraceMsg: String);
    procedure InitInfoList;
    procedure InitTraceList;
    procedure LockHolder;
    procedure UnlockHolder;
    procedure RegisterTest(APath: String; AMethod: TADQATestExecMethod;
      AKind: TADRDBMSKind = mkUnknown; ARunBeforeTest: Boolean = True);
    procedure RegisterTests; virtual; abstract;
    // properties
    property InfoList: TList read GetInfoList;
    property TraceList: TStrings read FTraceList write FTraceList;
    property LastErrorCount: Integer read GetLastErrorCount;
    property RootGroup: TADQATestGroup read FRootGroup;
    property DataTypeByName[Name: String]: TADDataType read GetDataType;
    property RDBMSKind: TADRDBMSKind read FRDBMSKind write FRDBMSKind;
  end;

  TADQATsHolderBaseClass = class of TADQATsHolderBase;

  TADQAPackManager = class (TObject)
  private
    FList: TStringList;
    function GetCount: Integer;
    function GetItems(AIndex: Integer): TADQATsHolderBase;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterPack(APackName: String; AClass: TADQATsHolderBaseClass);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TADQATsHolderBase read GetItems; default;
  end;

  TADQATsThreadCounter = class (TObject)
  private
    FCounter: Integer;
    FEvent:   THandle;
    FLock:    TRTLCriticalSection;
  public
    constructor Create(AInitCount: Integer);
    destructor Destroy; override;
    procedure Decrease;
    procedure Wait;
  end;

var
  ADQAPackManager: TADQAPackManager;

implementation

uses
  DB,
{$IFDEF AnyDAC_D6}
  SqlTimSt, FMTBcd,
{$ELSE}
  ActiveX, ComObj, 
{$ENDIF}  
  ADQAConst, ADQAUtils,
  daADStanOption, daADStanUtil, daADCompDataSet;

{-------------------------------------------------------------------------------}
{ TADQATsInfo                                                                   }
{-------------------------------------------------------------------------------}
procedure TADQATsInfo.Run(ATraceList: TStrings);
var
  lRun: Boolean;
begin
  with FPack do begin
    TraceList := ATraceList;
    InitInfoList;
    InitTraceList;
    RDBMSKind := RDBMS;
    lRun := True;
    if FRunBefore then
      lRun := RunBeforeTest;
    if lRun then
      try
        if Assigned(FMethod) then
          FMethod
        else
          raise Exception.Create('There is no test method assigned!');
      finally
        ClearAfterTest;
      end
    else
      raise Exception.Create(CannotContinueTest);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADQATestListBase                                                             }
{-------------------------------------------------------------------------------}
constructor TADQATestListBase.Create;
begin
  FDEQATests := TList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADQATestListBase.Destroy;
begin
  Clear;
  FDEQATests.Free;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQATestListBase.Add(const daADEQATestName: String; AMethod: TADQATestExecMethod;
  AKind: TADRDBMSKind = mkUnknown; ARunBeforeTest: Boolean = True);
var
  oInfo: TADQATsInfo;
begin
  oInfo := TADQATsInfo.Create;
  oInfo.ADQATestName := daADEQATestName;
  oInfo.Method := AMethod;
  oInfo.Pack   := FPack;
  oInfo.RDBMS  := AKind;
  oInfo.RunBefore := ARunBeforeTest;
  FDEQATests.Add(oInfo);
end;

{-------------------------------------------------------------------------------}
procedure TADQATestListBase.Clear;
var
  i :Integer;
begin
  for i := 0 to FDEQATests.Count - 1 do
    TADQATsInfo(FDEQATests[i]).Free;
  FDEQATests.Clear;
end;

{-------------------------------------------------------------------------------}
function TADQATestListBase.GetDEQATestNames(AIndex: Integer): String;
begin
  Result := TADQATsInfo(FDEQATests[AIndex]).ADQATestName;
end;

{-------------------------------------------------------------------------------}
function TADQATestListBase.GetDEQATsInfo(AIndex: Integer): TADQATsInfo;
begin
  Result := TADQATsInfo(FDEQATests[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADQATestListBase.GetCount: Integer;
begin
  Result := FDEQATests.Count;
end;

{-------------------------------------------------------------------------------}
{ TADQATestGroup                                                                }
{-------------------------------------------------------------------------------}
constructor TADQATestGroup.Create;
begin
  inherited Create;
  FChildGroups := TADQATestGroupList.Create;
  FParent := nil;
end;

{-------------------------------------------------------------------------------}
destructor TADQATestGroup.Destroy;
begin
  inherited Destroy;
  FChildGroups.Free;
end;

{-------------------------------------------------------------------------------}
procedure TADQATestGroup.Clear;
begin
  FChildGroups.Clear;
  inherited Clear;
end;

{-------------------------------------------------------------------------------}
function TADQATestGroup.GetHasChildren: Boolean;
begin
  Result := Children.Count > 0;
end;

{-------------------------------------------------------------------------------}
{ TADQATestGroupList                                                            }
{-------------------------------------------------------------------------------}
constructor TADQATestGroupList.Create;
begin
  FList := TStringList.Create;
  FList.Sorted := True;
  FNext := 0;
end;

{-------------------------------------------------------------------------------}
destructor TADQATestGroupList.Destroy;
begin
  Clear;
  FList.Free;
end;

{-------------------------------------------------------------------------------}
procedure TADQATestGroupList.Add(AObj: TADQATestGroup);
var
  i: Integer;
begin
  if not FList.Find(AObj.Name, i) then
    FList.AddObject(AObj.Name, AObj)
  else
    raise Exception.Create(ThisGroupAdded);
end;

{-------------------------------------------------------------------------------}
procedure TADQATestGroupList.Clear;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    TADQATestGroup(FList.Objects[i]).Free;
  FList.Clear;
end;

{-------------------------------------------------------------------------------}
function TADQATestGroupList.Find(AName: String; var AIndex: Integer): Boolean;
begin
  Result := FList.Find(AName, AIndex);
end;

{-------------------------------------------------------------------------------}
function TADQATestGroupList.GetCount: Integer;
begin
  Result := FList.Count;
end;

{-------------------------------------------------------------------------------}
function TADQATestGroupList.GetGroupName(AIndex: Integer): String;
begin
  ASSERT(AIndex < FList.Count);
  Result := FList[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADQATestGroupList.GetGroup(AIndex: Integer): TADQATestGroup;
begin
  ASSERT(AIndex < FList.Count);
  Result := TADQATestGroup(FList.Objects[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADQATestGroupList.GetGroupByName(AName: String): TADQATestGroup;
var
  i: Integer;
begin
  if Find(AName, i) then
    Result := Groups[i]
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADQATestGroupList.GetFirst: TADQATestGroup;
begin
  Result := Groups[0];
  FNext := 0;
end;

{-------------------------------------------------------------------------------}
function TADQATestGroupList.GetNext: TADQATestGroup;
begin
  if FNext >= Count then
    Result := nil
  else begin
    Result := Groups[FNext];
    Inc(FNext);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADQATsHolderBase                                                             }
{-------------------------------------------------------------------------------}
constructor TADQATsHolderBase.Create(const AName: String = '');
begin
  FName := AName;
  FRootGroup := TADQATestGroup.Create;
  FRootGroup.Parent := nil;
  FRootGroup.Pack := Self;

  FInfoList      := TList.Create;
  FDatSManager   := TADDatSManager.Create;
  FConnection    := TADConnection.Create(nil);
  FQuery         := TADQuery.Create(nil);
  FVarFieldList  := TADQAVariantFieldList.Create;

  FConnection.LoginPrompt := False;
  FQuery.Connection := FConnection;
  FRDBMSKind := mkUnknown;

  InitializeCriticalSection(FCriticalSection);
end;

{-------------------------------------------------------------------------------}
destructor TADQATsHolderBase.Destroy;
begin
  ClearHistory;
  FInfoList.Free;
  FInfoList := nil;
  FRootGroup.Free;
  FRootGroup := nil;
  FDatSManager.Free;
  FDatSManager := nil;
  FConnection.Free;
  FConnection := nil;
  FVarFieldList.Free;
  FVarFieldList := nil;
  FQuery.Free;
  FQuery := nil;
  DeleteCriticalSection(FCriticalSection);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.RunBeforeTest: Boolean;
begin
  Result := True;
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.ClearAfterTest;
begin
  FCommIntf := nil;
  FConnIntf := nil;
  FDatSManager.Reset;
  FConnection.Close;
  FQuery.Close;
  FQuery.Aggregates.Clear;
  FQuery.FormatOptions.MapRules.Clear;
  FQuery.DataSource := nil;
  FQuery.UpdateObject := nil;
  FQuery.CachedUpdates := False;
  FRDBMSKind := mkUnknown;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.ClearHistory;
var
  i: Integer;
begin
  for i := 0 to FInfoList.Count - 1 do
    TStringList(FInfoList[i]).Free;
  FInfoList.Clear;
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.GetInfoList: TList;
begin
  Result := FInfoList;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.Error(const ErrorMsg: String);
var
  oErrorList: TStringList;
begin
  LockHolder;
  try
    oErrorList := TStringList(FInfoList[FInfoList.Count - 1]);
    oErrorList.Add(ErrorMsg);
    Application.ProcessMessages;
    Sleep(0);
  finally
    UnlockHolder;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.Trace(const TraceMsg: String);
begin
  LockHolder;
  try
    FTraceList.Add(TimeToStr(Time) + '   ' + TraceMsg);
  finally
    UnlockHolder;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.InitInfoList;
begin
  FInfoList.Add(TStringList.Create);
  Application.ProcessMessages;
  Sleep(0);
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.InitTraceList;
begin
  if Assigned(FTraceList) then begin
    FTraceList.Clear;
    Application.ProcessMessages;
    Sleep(0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.LockHolder;
begin
  EnterCriticalSection(FCriticalSection);
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.UnlockHolder;
begin
  LeaveCriticalSection(FCriticalSection);
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.RegisterTest(APath: String;
  AMethod: TADQATestExecMethod; AKind: TADRDBMSKind = mkUnknown; ARunBeforeTest: Boolean = True);
var
  sTestName: String;
begin
  ParsePath(APath, sTestName).Add(sTestName, AMethod, AKind, ARunBeforeTest);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.GetLastErrorCount: Integer;
begin
  Result := TStringList(FInfoList[FInfoList.Count - 1]).Count;
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.Avg(ACol, ARowID: Integer; ATab: TADDatSTable): Variant;
var
  i: Integer;
begin
  Result := 0;
  if ATab = nil then
    ATab := FTab;
  for i := 0 to ARowID do
    Result := Result + VarAsType(ATab.Rows[i].GetData(ACol), varDouble);
  Result := Result / (ARowID + 1);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.Max(ACol, ARowID: Integer; ATab: TADDatSTable): Variant;
var
  i: Integer;
begin
  if ATab = nil then
    ATab := FTab;
  Result := ATab.Rows[0].GetData(ACol);
  for i := 1 to ARowID do
    if Result < ATab.Rows[i].GetData(ACol) then Result := ATab.Rows[i].GetData(ACol);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.Sum(ACol, ARowID: Integer; ATab: TADDatSTable): Variant;
var
  i: Integer;
begin
  if ATab = nil then
    ATab := FTab;
  Result := ATab.Rows[0].GetData(ACol);
  for i := 1 to ARowID do
    Result := ADFixFMTBcdAdd(Result, ATab.Rows[i].GetData(ACol));
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.Min(ACol, ARowID: Integer; ATab: TADDatSTable): Variant;
var
  i: Integer;
begin
  if ATab = nil then
    ATab := FTab;
  Result := ATab.Rows[0].GetData(ACol);
  for i := 1 to ARowID do
    if Result > ATab.Rows[i].GetData(ACol) then
      Result := ATab.Rows[i].GetData(ACol);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.Count(ACol, ARowID: Integer; ATab: TADDatSTable): Variant;
begin
  if ATab = nil then
    ATab := FTab;
  Result := ATab.Rows.Count;
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.MaxGr(ACol, ARowid, AGroupLevel: Integer; ATab: TADDatSTable): Variant;
begin
  if ATab = nil then
    ATab := FTab;
  // in group first n columns
  Result := ATab.Rows[ATab.Rows.Count - 1 - AGroupLevel].GetData(ACol);
  if ARowID > ATab.Rows.Count - 1 - AGroupLevel then
    Result := ATab.Rows[ARowid].GetData(ACol);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.MinGr(ACol, ARowid, AGroupLevel: Integer; ATab: TADDatSTable): Variant;
begin
  if ATab = nil then
    ATab := FTab;
  // in group first n columns
  Result := ATab.Rows[0].GetData(ACol);
  if ARowID > ATab.Rows.Count - 1 - AGroupLevel then
    Result := ATab.Rows[ARowid].GetData(ACol);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.AvgGr(ACol, ARowid, AGroupLevel: Integer; ATab: TADDatSTable): Variant;
begin
  if ATab = nil then
    ATab := FTab;
  // in group first n columns
  Result := Avg(ACol, ATab.Rows.Count - 1 - AGroupLevel, ATab);
  if ARowID > ATab.Rows.Count - 1 - AGroupLevel then
    Result := ATab.Rows[ARowid].GetData(ACol);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.SumGr(ACol, ARowid, AGroupLevel: Integer; ATab: TADDatSTable): Variant;
begin
  if ATab = nil then
    ATab := FTab;
  // in group first n columns
  Result := Sum(ACol, ATab.Rows.Count - 1 - AGroupLevel, ATab);
  if ARowID > ATab.Rows.Count - 1 - AGroupLevel then
    Result := ATab.Rows[ARowid].GetData(ACol);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.CountGr(ACol, ARowid, AGroupLevel: Integer; ATab: TADDatSTable): Variant;
begin
  if ATab = nil then
    ATab := FTab;
  // in group first n columns
  Result := ATab.Rows.Count - AGroupLevel;
  if ARowID > ATab.Rows.Count - 1 - AGroupLevel then
    Result := ATab.Rows[ARowid].GetData(ACol);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.CompConnSwitch: Boolean;
begin
  Result := True;
  SetConnectionDefFileName(CONN_DEF_STORAGE, True);
  FConnection.Close;
  FConnection.ConnectionDefName := GetConnectionDef(FRDBMSKind);
  FConnection.LoginPrompt := False;
  FConnection.Open;
  FDatSManager.Reset;
  FTab := FDatSManager.Tables.Add;

  FConnIntf := FConnection.ConnectionIntf;
  FConnIntf.CreateCommand(FCommIntf);
  try
    FConnIntf.TxOptions.Isolation := xiReadCommitted;
    FConnIntf.TxBegin;
    with FCommIntf do begin
      Prepare('delete from {id ADQA_All_types}');
      Execute;

      Prepare('select * from {id ADQA_All_types}');
      Define(FTab);
      Disconnect;
    end;
    FConnIntf.TxCommit;
  except
    on E: Exception do begin
      FConnIntf.TxRollback;
      Error(ErrorTableDefine(GetConnectionDef(FRDBMSKind), E.Message));
      Result := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.ConnectionSwitch: Boolean;
begin
  Result := True;
  SetConnectionDefFileName(CONN_DEF_STORAGE);
  OpenPhysManager;

  ADPhysManager.CreateConnection(GetConnectionDef(FRDBMSKind), FConnIntf);
  FConnIntf.LoginPrompt := False;
  FConnIntf.Open;
  FConnIntf.CreateCommand(FCommIntf);

  FDatSManager.Reset;
  FTab := FDatSManager.Tables.Add;
  try
    with FCommIntf do begin
      Prepare('select * from {id ADQA_All_types}');
      Define(FTab);
    end
  except
    on E: Exception do begin
      Error(ErrorTableDefine(GetConnectionDef(FRDBMSKind), E.Message));
      Result := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.CheckCommandState(AState: TADPhysCommandState;
  ACommIntf: IADPhysCommand; AComment: String = '');
begin
  if ACommIntf.State <> AState then
    Error(StateIsNotWaited(CommandState[AState], CommandState[ACommIntf.State]) +
          ' ' + AComment);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.CheckRowsCount(ATab: TADDatSTable;
  ACount: Integer; ACheckedCount: Integer): Boolean;
begin
  Result := True;
  if ACheckedCount = -1 then
    ACheckedCount := ATab.Rows.Count;
  if ACheckedCount <> ACount then begin
    Error(WrongRowCount(ACount, ACheckedCount));
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.DeleteFromSource;
begin
  with FCommIntf do begin
    Prepare('delete from {id ADQA_All_types}');
    try
      try
        Execute;
      except
        on E: Exception do
          Error(ErrorOnCommExec('see above', 'Proc.: DeleteFromSource.' + E.Message));
      end;
    finally
      Unprepare;
    end;
  end
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.GetDataType(AName: String): TADDataType;
var
  i: Integer;
begin
  Result := dtUnknown;
  for i := 0 to 33 do
    if AnsiCompareText(AName, ADDataTypesNames[TADDataType(i)]) = 0 then
      Result := TADDataType(i);
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.GetInsertString(AForDTM: Boolean = False): String;
var
  i, j: Integer;
  s1, s2, sTab: String;
begin
  with FVarFieldList do begin
    if not AForDTM then
      sTab := 'ADQA_All_types'
    else
      sTab := 'ADQA_All_types_DTM';

    j := 0;
    while IsOfUnknownType(j) do
      Inc(j);
    s1 := FTab.Columns[j].Name;
    s2 := ':' + FTab.Columns[j].Name;
    Inc(j);
    for i := j to FTab.Columns.Count - 1 do
      if not IsOfUnknownType(i) then begin
        s1 := Format('%s, %s', [s1, FTab.Columns[i].Name]);
        s2 := Format('%s, :%s', [s2, FTab.Columns[i].Name]);
      end;
    Result := Format('insert into {id %s}(%s) values(%s)', [sTab, s1, s2]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.GetParamsArrayDB2;
{$IFNDEF AnyDAC_D6}
var
  V: Variant;
{$ENDIF}
begin
  with FVarFieldList do begin
    Clear;
{$IFDEF AnyDAC_D6}
    Add('bigint',            LargeInts[3],     ftLargeint);
{$ELSE}
    TVarData(V).VType := varInt64;
    Decimal(V).Lo64 := LargeInts[3];
    Add('bigint',            V,                ftLargeint);
{$ENDIF}
    Add('blob',              Blobs[0],         ftBlob);
    Add('char',              Strings[0],       ftFixedChar, 6);
    Add('char for bit data', Bytes[0],         ftBytes);
    Add('clob',              Blobs[1],         ftMemo);
    Add('date',              Dates[0],         ftDate);
    Add('decimal(19,4)',     Currencies[0],    ftBCD);
    Add('double',            Floats[0],        ftFloat);
    Add('graphic',           WideStrings[1],   ftWideString);
    Add('integer',           Integers[0],      ftInteger);
    Add('long varchar',      Memos[0],         ftMemo);
    Add('long vargraphic',   WideMemos[2],     ftFmtMemo);
    Add('real',              Floats[1],        ftFloat);
    Add('smallint',          SmallInts[0],     ftSmallint);
    Add('time',              Times[2],         ftTime);
{$IFDEF AnyDAC_D6}
    Add('timestamp',         VarSQLTimeStampCreate(TimeStamps[0]),
                                               ftTimeStamp);
{$ELSE}
    Add('timestamp',         ADSQLTimeStampToDateTime(TimeStamps[0]),
                                               ftDateTime);
{$ENDIF}
    Add('varchar',           Strings[1],       ftString);
    Add('varchar for bit data',
                             Bytes[3],         ftVarBytes);
    Add('vargraphic',        WideStrings[2],   ftWideString);
    Add('dbclob',            WideMemos[2],     ftFmtMemo);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.GetParamsArrayMSAccess;
begin
  with FVarFieldList do begin
    Clear;
    Add('int1',      ShortInts[0], ftSmallint);
    Add('int2',      SmallInts[0], ftSmallint);
    Add('int4',      Integers[0],  ftInteger);
    Add('single',    Floats[0],    ftFloat);
    Add('double',    Floats[1],    ftFloat);
    Add('decimal(16,6)',
                     Bcds[4],      ftBCD);
    Add('text',      Strings[0],   ftString);
    Add('memo',      Memos[0],     ftMemo);
{$IFDEF AnyDAC_D6}
    Add('datetime',  VarSQLTimeStampCreate(TimeStamps[0]),
                                   ftTimeStamp);
{$ELSE}
    Add('datetime',  ADSQLTimeStampToDateTime(TimeStamps[0]),
                                   ftDateTime);
{$ENDIF}
    Add('currency',  Currencies[0],ftCurrency);
    Add('boolean',   Booleans[0],  ftBoolean);
    Add('oleobject', Blobs[0],     ftBlob);
    Add('guid',      Guids[0],     ftGuid);
    Add('binary',    Binary,       ftBlob);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.GetParamsArrayMSSQL;
{$IFNDEF AnyDAC_D6}
var
  V: Variant;
{$ENDIF}
begin
  with FVarFieldList do begin
    Clear;
{$IFDEF AnyDAC_D6}
    Add('bigint',           LargeInts[3],   ftLargeint);
{$ELSE}
    TVarData(V).VType := varInt64;
    Decimal(V).Lo64 := LargeInts[3];
    Add('bigint',           V,              ftLargeint);
{$ENDIF}
    Add('binary',           Binary,         ftBytes);
    Add('bit',              Booleans[0],    ftBoolean);
    Add('char',             Strings[0],     ftFixedChar, 6);
{$IFDEF AnyDAC_D6}
    Add('datetime',         VarSQLTimeStampCreate(TimeStamps[0]),
                                            ftTimeStamp);
{$ELSE}
    Add('datetime',         ADSQLTimeStampToDateTime(TimeStamps[0]),
                                            ftDateTime);
{$ENDIF}
    Add('float',            Floats[0],      ftFloat);
    Add('image',            Blobs[0],       ftBlob);
    Add('int',              Integers[0],    ftInteger);
    Add('money',            Bcds[1],        ftBCD);
    Add('nchar',            WideStrings[1], ftWideString);
    Add('ntext',            Memos[0],       ftFmtMemo);
    Add('numeric',          Bcds[2],        ftBCD);
    Add('nvarchar',         WideStrings[2], ftWideString);
    Add('real',             Floats[2],      ftFloat);
{$IFDEF AnyDAC_D6}
    Add('smalldatetime',    VarSQLTimeStampCreate(TimeStamps[3]),
                                            ftTimeStamp);
{$ELSE}
    Add('smalldatetime',    ADSQLTimeStampToDateTime(TimeStamps[3]),
                                            ftDateTime);
{$ENDIF}
    Add('smallint',         SmallInts[0],   ftSmallint);
    Add('smallmoney',       Bcds[3],        ftBCD);
    Add('sql_variant',      Strings[1],     ftVarBytes);
    Add('text',             Memos[1],       ftMemo);
    Add('timestamp',        Unassigned,     ftUnknown);
    Add('tinyint',          SmallInts[1],   ftSmallint);
    Add('uniqueidentifier', Guids[3],       ftGuid);
    Add('varbinary',        Bytes[2],       ftVarBytes);
    Add('varchar',          Strings[5],     ftString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.GetParamsArrayASA;
{$IFNDEF AnyDAC_D6}
var
  V: Variant;
{$ENDIF}  
begin
  with FVarFieldList do begin
    Clear;
{$IFDEF AnyDAC_D6}
    Add('bigint',           LargeInts[2],   ftLargeint);
    Add('ubigint',          LargeInts[3],   ftLargeint);
{$ELSE}
    TVarData(V).VType := varInt64;
    Decimal(V).Lo64 := LargeInts[2];
    Add('bigint',           V,              ftLargeint);
    TVarData(V).VType := varInt64;
    Decimal(V).Lo64 := LargeInts[3];
    Add('ubigint',          V,              ftLargeint);
{$ENDIF}
    Add('binary',           Binary,         ftBytes);
    Add('bit',              Booleans[0],    ftBoolean);
    Add('char',             Strings[0],     ftFixedChar, 6);
    Add('date',             Dates[0],       ftDate);
    Add('time',             Times[3],       ftTime);
    Add('decimal',          Currencies[6],  ftCurrency);
    Add('double',           Floats[0],      ftFloat);
    Add('float',            Floats[1],      ftFloat);
    Add('long binary',      Blobs[0],       ftBlob);
    Add('int',              Integers[1],    ftInteger);
    Add('uint',             Integers[0],    ftInteger);
    Add('numeric',          Bcds[0],        ftBCD);
    Add('real',             Floats[2],      ftFloat);
    Add('smallint',         SmallInts[2],   ftSmallint);
    Add('usmallint',        SmallInts[0],   ftSmallint);
    Add('long varchar',     Memos[2],       ftMemo);
{$IFDEF AnyDAC_D6}
    Add('timestamp',        VarSQLTimeStampCreate(TimeStamps[0]),
                                            ftTimeStamp);
{$ELSE}
    Add('timestamp',        ADSQLTimeStampToDateTime(TimeStamps[0]),
                                            ftDateTime);
{$ENDIF}
    Add('tinyint',          SmallInts[1],   ftSmallint);
    Add('varbinary',        Bytes[0],       ftVarBytes);
    Add('varchar',          Strings[6],     ftString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.GetParamsArrayMySQL;
{$IFNDEF AnyDAC_D6}
var
  V: Variant;
{$ENDIF}  
begin
  with FVarFieldList do begin
    Clear;
    Add('tinyint',    SmallInts[0], ftSmallint);
    Add('bit',        Booleans[0],  ftBoolean);
    Add('bool',       Booleans[1],  ftBoolean);
    Add('smallint',   SmallInts[1], ftSmallint);
    Add('mediumint',  Integers[0],  ftInteger);
    Add('int',        Integers[1],  ftInteger);
    Add('integer',    Integers[2],  ftInteger);
{$IFDEF AnyDAC_D6}
    Add('bigint',     LargeInts[3], ftLargeint);
{$ELSE}
    TVarData(V).VType := varInt64;
    Decimal(V).Lo64 := LargeInts[3];
    Add('bigint',     V,            ftLargeint);
{$ENDIF}
    Add('real',       Floats[0],    ftFloat);
    Add('double',     Floats[1],    ftFloat);
    Add('float',      Floats[2],    ftFloat);
    Add('decimal',    Bcds[5],      ftBCD);
{$IFDEF AnyDAC_D6}
    Add('numeric',    LargeInts[2], ftLargeint);
{$ELSE}
    TVarData(V).VType := varInt64;
    Decimal(V).Lo64 := LargeInts[2];
    Add('numeric',     V,           ftLargeint);
{$ENDIF}
    Add('char',       Strings[0],   ftFixedChar, 6);
    Add('varchar',    Strings[1],   ftString);
    Add('date',       Dates[0],     ftDate);
    Add('time',       Times[0],     ftTime);
    Add('year',       Bytes2[0],    ftSmallint);
{$IFDEF AnyDAC_D6}
    Add('timestamp',  VarSQLTimeStampCreate(TimeStamps[0]),
                                    ftTimeStamp);
{$ELSE}
    Add('timestamp',  ADSQLTimeStampToDateTime(TimeStamps[0]),
                                    ftDateTime);
{$ENDIF}
    Add('datetime',   DateTimes[4], ftDateTime);
    Add('tinyblob',   Blobs[0],     ftBlob);
    Add('blob',       Blobs[1],     ftBlob);
    Add('mediumblob', Blobs[2],     ftBlob);
    Add('longblob',   Blobs[3],     ftBlob);
    Add('tinytext',   Memos[0],     ftMemo);
    Add('text',       Memos[1],     ftMemo);
    Add('mediumtext', Memos[2],     ftMemo);
    Add('longtext',   Memos[3],     ftMemo);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsHolderBase.GetParamsArrayOra;  // Oracle
{$IFNDEF AnyDAC_D6}
var
  cr: Currency;
{$ENDIF}
begin
// Attention!!! If you comment some fields below, remember that this procedure
// is used by several tests and your changes may affect them. Mainly it may
// affect tests with stored procedures.
//
// This are the tests, using this procedure:
// 1. TestCommandInsOracle
// 2. TestDefineStdProcParamOra
// 3. TestStoredProcOra

  with FVarFieldList do begin
    Clear;
    Add('nvarchar2', WideStrings[0], ftWideString);
    Add('varchar2',  Strings[0],     ftString);
{$IFDEF AnyDAC_D6}
    Add('number',    VarFMTBcdCreate(FMTBcds[0]),
                                     ftFMTBcd);
{$ELSE}
    BCDToCurr(FMTBcds[0], cr);
    Add('number',    cr,             ftBcd);
{$ENDIF}
    Add('float',     Floats[0],      ftFloat);
    Add('long',      Memos[0],       ftMemo);
    Add('varchar',   Strings[1],     ftString);
{$IFDEF AnyDAC_D6}
    Add('date',      VarSQLTimeStampCreate(TimeStamps[0]),
                                     ftTimeStamp);
{$ELSE}
    Add('date',      ADSQLTimeStampToDateTime(TimeStamps[0]),
                                     ftDateTime);
{$ENDIF}
    Add('raw(18)',   Rowids[0],      ftVarBytes);
    Add('rowid',     Rowids[1],      ftFixedChar, 18);
    Add('nchar',     WideStrings[1], ftWideString);
    Add('char(5)',   Strings[3],     ftFixedChar, 5);
    Add('nclob',     WideHMemos[0],  ftUnknown);
    Add('clob',      HMemos[0],      ftOraClob);
    Add('bclob',     HBlobs[0],      ftOraBlob);
    Add('bfile',     HBlobs[0],      ftUnknown);
    Add('urowid',    Strings[4],     ftUnknown);
  end;
end;

procedure TADQATsHolderBase.GetParamsArray;
begin
  case FRDBMSKind of
  mkOracle:   GetParamsArrayOra;
  mkMSSQL:    GetParamsArrayMSSQL;
  mkMSAccess: GetParamsArrayMSAccess;
  mkMySQL:    GetParamsArrayMySQL;
  mkASA:      GetParamsArrayASA;
  mkDB2:      GetParamsArrayDB2;
  end;
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.ParsePath(const APath: String; out ATestName: String): TADQATestGroup;
var
  oGroup: TADQATestGroup;
  oGroupNames: TStringList;
  sPath: String;
  i, j: Integer;
begin
  Result := FRootGroup;
  oGroupNames := TStringList.Create;
  oGroupNames.Add(FName);
  try
    i := 1;
    while i <= Length(APath) do begin
      sPath := ADExtractFieldName(APath, i);
      oGroupNames.Add(sPath);
    end;
    ATestName := oGroupNames.Strings[oGroupNames.Count - 1];
    oGroupNames.Delete(oGroupNames.Count - 1);
    for i := 0 to oGroupNames.Count - 1 do begin
      if Result.Children.Find(oGroupNames[i], j) then
        Result := Result.Children[j]
      else begin
        oGroup := TADQATestGroup.Create;
        oGroup.Name := oGroupNames[i];
        oGroup.Pack := Self;
        Result.Children.Add(oGroup);
        oGroup.Parent := Result;
        Result := oGroup;
      end;
    end;
  finally
    oGroupNames.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.Insert(AForDTM: Boolean = False): Boolean;
var
  j, k: Integer;
begin
  Result := True;
  k := 0;
  with FCommIntf do begin
    CommandText := GetInsertString(AForDTM);
    for j := 0 to FTab.Columns.Count - 1 do
      with FVarFieldList do
        if not IsOfUnknownType(j) then
          with Params[k] do begin
            ParamType := ptInput;
            Inc(k);
            try
              DataType := Types[j];
              Size     := Sizes[j];
              Value    := VarValues[j];
            except
              on E: Exception do begin
                Error(ErrorOnSetParamValue(VarToStr(VarValues[j]), E.Message));
                Result := False;
                Exit;
              end
            end
          end
        else
          continue;
    try
      try
        Prepare;
        Execute;
      except
        on E: Exception do begin
          Error(ErrorOnCommExec(C_AD_PhysRDBMSKinds[FRDBMSKind], E.Message));
          Result := False;
        end
      end
    finally
      Unprepare;
      CommandKind := skUnknown;
    end
  end;
end;

{-------------------------------------------------------------------------------}
function TADQATsHolderBase.CheckColumnsCount(ATab: TADDatSTable;
  ACount: Integer; ACheckedCount: Integer; AComment: String): Boolean;
var
  iCheck: Integer;
begin
  Result := True;
  if ATab <> nil then
    iCheck := ATab.Columns.Count
  else
    iCheck := ACheckedCount;
  if iCheck <> ACount then begin
    Error(WrongColumnCount(ACount, iCheck) + '. ' + AComment);
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADQAPackManager                                                              }
{-------------------------------------------------------------------------------}
constructor TADQAPackManager.Create;
begin
  FList := TStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADQAPackManager.Destroy;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    TADQATsHolderBase(FList.Objects[i]).Free;
  FList.Free;
  ADPhysManager.Close;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADQAPackManager.GetCount: Integer;
begin
  Result := FList.Count;
end;

{-------------------------------------------------------------------------------}
function TADQAPackManager.GetItems(AIndex: Integer): TADQATsHolderBase;
begin
  ASSERT(AIndex < FList.Count);
  Result := TADQATsHolderBase(FList.Objects[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADQAPackManager.RegisterPack(APackName: String;
  AClass: TADQATsHolderBaseClass);
var
  oObj: TADQATsHolderBase;
begin
  oObj := AClass.Create(APackName);
  FList.AddObject(APackName, oObj);
  oObj.RegisterTests;
end;

{-------------------------------------------------------------------------------}
{ TADQATsThreadCounter                                                          }
{-------------------------------------------------------------------------------}
constructor TADQATsThreadCounter.Create(AInitCount: Integer);
begin
  FCounter := AInitCount;
  FEvent := CreateEvent(nil, False, False, nil);
  InitializeCriticalSection(FLock);
end;

{-------------------------------------------------------------------------------}
procedure TADQATsThreadCounter.Decrease;
begin
  EnterCriticalSection(FLock);
  try
    Dec(FCounter);
    SetEvent(FEvent);
  finally
    LeaveCriticalSection(FLock);
  end;
end;

{-------------------------------------------------------------------------------}
destructor TADQATsThreadCounter.Destroy;
begin
  CloseHandle(FEvent);
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADQATsThreadCounter.Wait;
begin
  while True do begin
    WaitForSingleObject(FEvent, 500);
    if FCounter <= 0 then
      break;
  end;
end;

initialization

  ADQAPackManager := TADQAPackManager.Create;

finalization

  ADQAPackManager.Free;
  ADQAPackManager := nil;

end.
