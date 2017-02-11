
{******************************************}
{                                          }
{             FastReport v4.0              }
{         AD enduser components            }
{                                          }
{     Created by: Serega Glazyrin          }
{     E-mail: glserega@mezonplus.ru        }
{                                          }
{                                          }
{******************************************}

unit frxADComponents;

interface

{$I frx.inc}

uses
  Windows, Classes, SysUtils, frxClass, frxCustomDB, DB, daADCompClient
{$IFDEF Delphi6}
, Variants
{$ENDIF}
{$IFDEF QBUILDER}
, fqbClass
{$ENDIF};


type
  TfrxADComponents = class(TfrxDBComponents)
  private
    FDefaultDatabase: TADConnection;
    FOldComponents: TfrxADComponents;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDescription: String; override;
  published
    property DefaultDatabase: TADConnection read FDefaultDatabase write FDefaultDatabase;
  end;

  TfrxADDatabase = class(TfrxCustomDatabase)
  private
    FDatabase: TADConnection;
    function GetDriverName: string;
    procedure SetDriverName(const Value: string);
    function GetConnectionName: string;
    procedure SetConnectionName(const Value: string);
  protected
    procedure SetConnected(Value: Boolean); override;
    procedure SetDatabaseName(const Value: String); override;
    procedure SetLoginPrompt(Value: Boolean); override;
    procedure SetParams(Value: TStrings); override;
    function GetConnected: Boolean; override;
    function GetDatabaseName: String; override;
    function GetLoginPrompt: Boolean; override;
    function GetParams: TStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    procedure SetLogin(const Login, Password: String); override;
    property Database: TADConnection read FDatabase;
  published
    //property LoginPrompt;
    property Params;
    property Connected;
    property DriverName: string read GetDriverName write SetDriverName;
    property ConnectionName: string read GetConnectionName write SetConnectionName;
    property DatabaseName;
  end;

  TfrxADQuery = class(TfrxCustomQuery)
  private
    FDatabase: TfrxADDatabase;
    FQuery: TADQuery;
    procedure SetDatabase(const Value: TfrxADDatabase);
    function GetConnectionName: string;
    procedure SetConnectionName(const Value: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetMaster(const Value: TDataSource); override;
    procedure SetSQL(Value: TStrings); override;
    function GetSQL: TStrings; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure UpdateParams; override;//
{$IFDEF QBUILDER}
    function QBEngine: TfqbEngine; override;
{$ENDIF}
    property Query: TADQuery read FQuery;
  published
    property Database: TfrxADDatabase read FDatabase write SetDatabase;
    property ConnectionName: string read GetConnectionName write SetConnectionName;
  end;


  TfrxCustomStoredProc = class(TfrxCustomDataset)
  private
    FParams: TfrxParams;
    FSaveOnBeforeOpen: TDataSetNotifyEvent;
    FSQLSchema: String;
    procedure ReadData(Reader: TReader);
    procedure SetParams(Value: TfrxParams);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure OnBeforeOpen(DataSet: TDataSet); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateParams; virtual;
    function ParamByName(const Value: String): TfrxParamItem;
  published
    property Params: TfrxParams read FParams write SetParams;
    property SQLSchema: String read FSQLSchema write FSQLSchema;
  end;

  TfrxADStoredProc = class(TfrxCustomStoredProc)
  private
    FDatabase: TfrxADDatabase;
    FStoredProc: TADStoredProc;
    procedure SetDatabase(const Value: TfrxADDatabase);
    function GetPackageName: String;
    function GetProcName: string;
    procedure SetPackageName(const Value: String);
    procedure SetProcName(const Value: string);
    function GetConnectionName: string;
    procedure SetConnectionName(const Value: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure UpdateParams;override;
    property StoredProc: TADStoredProc read FStoredProc;
  published
    property Database: TfrxADDatabase read FDatabase write SetDatabase;
    property PackageName: String read GetPackageName write SetPackageName;
    property StoredProcName: string read GetProcName write SetProcName;
    property ConnectionName: string read GetConnectionName write SetConnectionName;
  end;


{$IFDEF QBUILDER}
  TfrxEngineAD = class(TfqbEngine)
  private
    FQuery: TADQuery;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadTableList(ATableList: TStrings); override;
    procedure ReadFieldList(const ATableName: string; var AFieldList: TfqbFieldList); override;
    function ResultDataSet: TDataSet; override;
    procedure SetSQL(const Value: string); override;
  end;
{$ENDIF}


var
  ADComponents: TfrxADComponents;


implementation


{$R *.res}

uses
  frxADRTTI,
{$IFNDEF NO_EDITORS}
  frxADEditor,
{$ENDIF}
  frxDsgnIntf, frxUtils, frxRes, daADStanParam;



constructor TfrxADComponents.Create(AOwner: TComponent);
begin
  inherited;
  FOldComponents := ADComponents;
  ADComponents := Self;
end;

destructor TfrxADComponents.Destroy;
begin
  if ADComponents = Self then
    ADComponents := FOldComponents;
  inherited;
end;

function TfrxADComponents.GetDescription: String;
begin
  Result := 'AD';
end;


{ TfrxADDatabase }

constructor TfrxADDatabase.Create(AOwner: TComponent);
begin
  inherited;
  FDatabase := TADConnection.Create(nil);
  Component := FDatabase;
end;

destructor TfrxADDatabase.Destroy;
begin
  inherited;
end;

class function TfrxADDatabase.GetDescription: String;
begin
  Result := 'AD Database';
end;

function TfrxADDatabase.GetConnected: Boolean;
begin
  Result := FDatabase.Connected;
end;

function TfrxADDatabase.GetDatabaseName: String;
begin
  Result := FDatabase.Params.Values['DataBase'];
end;

function TfrxADDatabase.GetLoginPrompt: Boolean;
begin
  Result := FDatabase.LoginPrompt;
end;

function TfrxADDatabase.GetParams: TStrings;
begin
  Result := FDatabase.Params;
end;

procedure TfrxADDatabase.SetConnected(Value: Boolean);
begin
  BeforeConnect(Value);
  FDatabase.Connected := Value;
end;

procedure TfrxADDatabase.SetDatabaseName(const Value: String);
var isConnected:boolean;
begin
  isConnected:=FDatabase.Connected;
  FDatabase.Connected:=False;
  FDatabase.Params.Values['DataBase'] := Value;
  FDatabase.Connected:=isConnected;
end;

procedure TfrxADDatabase.SetLoginPrompt(Value: Boolean);
begin
  FDatabase.LoginPrompt := Value;
end;

procedure TfrxADDatabase.SetParams(Value: TStrings);
begin
  FDatabase.Params := Value;
end;

procedure TfrxADDatabase.SetLogin(const Login, Password: String);
begin
end;


function TfrxADDatabase.GetDriverName: string;
begin
  result:=FDatabase.DriverName;
end;

procedure TfrxADDatabase.SetDriverName(const Value: string);
begin
  FDatabase.DriverName:=Value;
end;

function TfrxADDatabase.GetConnectionName: string;
begin
  result:=FDatabase.ConnectionName;
end;

procedure TfrxADDatabase.SetConnectionName(const Value: string);
var isConnected:boolean;
begin
  isConnected:=FDatabase.Connected;
  FDatabase.Connected:=False;
  FDatabase.ConnectionName:=Value;
  FDatabase.Connected:=isConnected;
end;

{ TfrxADQuery }

constructor TfrxADQuery.Create(AOwner: TComponent);
begin
  FQuery := TADQuery.Create(nil);
  Dataset := FQuery;
  SetDatabase(nil);
  inherited;
end;

constructor TfrxADQuery.DesignCreate(AOwner: TComponent; Flags: Word);
var
  i: Integer;
  l: TList;
begin
  inherited;
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
    if TObject(l[i]) is TfrxADDatabase then
    begin
      SetDatabase(TfrxADDatabase(l[i]));
      break;
    end;
end;

class function TfrxADQuery.GetDescription: String;
begin
  Result := 'AD Query';
end;

procedure TfrxADQuery.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDatabase) then
    SetDatabase(nil);
end;

procedure TfrxADQuery.SetDatabase(const Value: TfrxADDatabase);
begin
  FDatabase := Value;
  if Value <> nil then
    FQuery.Connection := Value.Database
  else if ADComponents <> nil then
    FQuery.Connection := ADComponents.DefaultDatabase
  else
    FQuery.Connection := nil;
end;

function TfrxADQuery.GetSQL: TStrings;
begin
  Result := FQuery.SQL;
end;

procedure TfrxADQuery.SetSQL(Value: TStrings);
begin
  FQuery.SQL := Value;
end;

procedure TfrxADQuery.SetMaster(const Value: TDataSource);
begin
  FQuery.DataSource := Value;
end;

procedure TfrxADQuery.UpdateParams;
var pars:TParams;
  par:TPAram;
  i:integer;
begin
  pars:=TParams.Create;
  try
    for i:=0 to FQuery.Params.Count-1 do
    begin
      par:=pars.CreateParam(FQuery.Params[i].DataType,FQuery.Params[i].Name,FQuery.Params[i].ParamType);
      par.Value:=FQuery.Params[i].Value;
    end;
    frxParamsToTParams(Self, pars);
  finally
    pars.Free;
  end;
end;

procedure TfrxADQuery.BeforeStartReport;
begin
  SetDatabase(FDatabase);
end;

{$IFDEF QBUILDER}
function TfrxADQuery.QBEngine: TfqbEngine;
begin
  Result := TfrxEngineAD.Create(nil);
  TfrxEngineAD(Result).FQuery.Connection := FQuery.Connection;
end;
{$ENDIF}


{$IFDEF QBUILDER}
constructor TfrxEngineAD.Create(AOwner: TComponent);
begin
  inherited;
  FQuery := TADQuery.Create(Self);
end;

destructor TfrxEngineAD.Destroy;
begin
  FQuery.Free;
  inherited;
end;

procedure TfrxEngineAD.ReadFieldList(const ATableName: string;
  var AFieldList: TfqbFieldList);
var
  TempTable: TADTable;
  Fields: TFieldDefs;
  i: Integer;
  tmpField: TfqbField;
begin
  AFieldList.Clear;
  TempTable := TADTable.Create(Self);
  TempTable.Connection := FQuery.Connection;
  TempTable.TableName := ATableName;
  Fields := TempTable.FieldDefs;
  try
    try
      TempTable.Active := True;
      tmpField:= TfqbField(AFieldList.Add);
      tmpField.FieldName := '*';
      for i := 0 to Fields.Count - 1 do
      begin
        tmpField := TfqbField(AFieldList.Add);
        tmpField.FieldName := Fields.Items[i].Name;
        tmpField.FieldType := Ord(Fields.Items[i].DataType)
      end;
    except
    end;
  finally
    TempTable.Free;
  end;
end;

procedure TfrxEngineAD.ReadTableList(ATableList: TStrings);
begin
  ATableList.Clear;
  FQuery.Connection.GetTableNames(FQuery.ConnectionName, '', '', ATableList);
end;

function TfrxEngineAD.ResultDataSet: TDataSet;
begin
  Result := FQuery;
end;

procedure TfrxEngineAD.SetSQL(const Value: string);
begin
  FQuery.SQL.Text := Value;
end;
{$ENDIF}

function TfrxADQuery.GetConnectionName: string;
begin
  result:=FQuery.ConnectionName;
end;

procedure TfrxADQuery.SetConnectionName(const Value: string);
var
  i: Integer;
  c, c1: TfrxComponent;
begin
  FDatabase := nil;
  FQuery.ConnectionName:=Value;
  if self is TfrxReportComponent then
    c := self.Page else
    c := self;
  for i := 0 to c.AllObjects.Count - 1 do
  begin
    c1 := c.AllObjects[i];
    if (c1 <> self) and (c1 is TfrxADDatabase) and (TfrxADDatabase(c1).ConnectionName=Value) then
      Fdatabase:=TfrxADDatabase(c1);
  end;
end;
{ TfrxADStoredProc }

procedure TfrxADStoredProc.BeforeStartReport;
begin
  inherited;
  SetDatabase(FDatabase);
end;

constructor TfrxADStoredProc.Create(AOwner: TComponent);
begin
  FStoredProc := TADStoredProc.Create(nil);
  Dataset := FStoredProc;
  SetDatabase(nil);
  inherited;
end;

constructor TfrxADStoredProc.DesignCreate(AOwner: TComponent; Flags: Word);
var
  i: Integer;
  l: TList;
begin
  inherited;
  l := Report.AllObjects;
  for i := 0 to l.Count - 1 do
    if TObject(l[i]) is TfrxADDatabase then
    begin
      SetDatabase(TfrxADDatabase(l[i]));
      break;
    end;
end;

function TfrxADStoredProc.GetConnectionName: string;
begin
  Result:=FStoredProc.ConnectionName;
end;

class function TfrxADStoredProc.GetDescription: String;
begin
  Result := 'AD StoredProc';
end;

function TfrxADStoredProc.GetPackageName: String;
begin
  Result:=FStoredProc.PackageName;
end;

function TfrxADStoredProc.GetProcName: string;
begin
  Result:=FStoredProc.StoredProcName;
end;

procedure TfrxADStoredProc.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FDatabase) then
    SetDatabase(nil);
end;

procedure TfrxADStoredProc.SetConnectionName(const Value: string);
var
  i: Integer;
  c, c1: TfrxComponent;
begin
  FDatabase := nil;
  FStoredProc.ConnectionName:=Value;
  if self is TfrxReportComponent then
    c := self.Page else
    c := self;
  for i := 0 to c.AllObjects.Count - 1 do
  begin
    c1 := c.AllObjects[i];
    if (c1 <> self) and (c1 is TfrxADDatabase) and (TfrxADDatabase(c1).ConnectionName=Value) then
      Fdatabase:=TfrxADDatabase(c1);
  end;
end;

procedure TfrxADStoredProc.SetDatabase(const Value: TfrxADDatabase);
begin
  FDatabase := Value;
  if Value <> nil then
    FStoredProc.Connection := Value.Database
  else if ADComponents <> nil then
    FStoredProc.Connection := ADComponents.DefaultDatabase
  else
    FStoredProc.Connection := nil;
end;

procedure TfrxADStoredProc.SetPackageName(const Value: String);
begin
  FStoredProc.PackageName:=Value;
end;

procedure TfrxADStoredProc.SetProcName(const Value: string);
begin
  FStoredProc.StoredProcName:=Value;
end;

procedure TfrxADStoredProc.UpdateParams;
  procedure frxParamsToTParamsS(Query: TfrxADStoredProc; Params: TParams);
  var
    i: Integer;
    Item: TfrxParamItem;
  begin
    for i := 0 to Params.Count - 1 do
      if Query.Params.IndexOf(Params[i].Name) <> -1 then
      begin
        Item := Query.Params[Query.Params.IndexOf(Params[i].Name)];
        Params[i].Clear;
        if not (Query.IsLoading or Query.IsDesigning) then
          Params[i].Bound := False
        else
          Params[i].Bound := True;
        Params[i].DataType := Item.DataType;
        if Trim(Item.Expression) <> '' then
          if not (Query.IsLoading or Query.IsDesigning) then
            if Query.Report <> nil then
            begin
              Query.Report.CurObject := Query.Name;
              Item.Value := Query.Report.Calc(Item.Expression);
            end;
        if not VarIsEmpty(Item.Value) then
        begin
          Params[i].Bound := True;
          if Params[i].DataType in [ftDate, ftTime, ftDateTime] then
            Params[i].Value := Item.Value
          else
            Params[i].Text := VarToStr(Item.Value);
        end;
      end;
  end;
var pars:TParams;
  par:TPAram;
  i:integer;
begin
  exit;
  pars:=TParams.Create;
  try
    for i:=0 to FStoredProc.Params.Count-1 do
    begin
      par:=pars.CreateParam(FStoredProc.Params[i].DataType,FStoredProc.Params[i].Name,FStoredProc.Params[i].ParamType);
      par.Value:=FStoredProc.Params[i].Value;
    end;
    frxParamsToTParamsS(Self, pars);
  finally
    pars.Free;
  end;
end;


constructor TfrxCustomStoredProc.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TfrxParams.Create;
  FSaveOnBeforeOpen := DataSet.BeforeOpen;
  DataSet.BeforeOpen := OnBeforeOpen;
end;

procedure TfrxCustomStoredProc.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Parameters', ReadData, WriteData, True);
end;

destructor TfrxCustomStoredProc.Destroy;
begin
  FParams.Free;
  inherited;
end;

procedure TfrxCustomStoredProc.OnBeforeOpen(DataSet: TDataSet);
begin
  UpdateParams;
  if Assigned(FSaveOnBeforeOpen) then
    FSaveOnBeforeOpen(DataSet);
end;

function TfrxCustomStoredProc.ParamByName(
  const Value: String): TfrxParamItem;
begin
  Result := FParams.Find(Value);
  if Result = nil then
    raise Exception.Create('Parameter "' + Value + '" not found');
end;

procedure TfrxCustomStoredProc.ReadData(Reader: TReader);
begin
  frxReadCollection(FParams, Reader, Self);
  UpdateParams;
end;

procedure TfrxCustomStoredProc.SetParams(Value: TfrxParams);
begin
  FParams.Assign(Value);
end;

procedure TfrxCustomStoredProc.UpdateParams;
begin
//
end;

procedure TfrxCustomStoredProc.WriteData(Writer: TWriter);
begin
  frxWriteCollection(FParams, Writer, Self);
end;

initialization
  frxObjects.RegisterObject1(TfrxADDataBase , nil, '', '', 0, 37);
  frxObjects.RegisterObject1(TfrxADQuery , nil, '', '', 0, 39);
  frxObjects.RegisterObject1(TfrxADStoredProc , nil, '', '', 0, 39);
finalization
  frxObjects.UnRegister(TfrxADDataBase);
  frxObjects.UnRegister(TfrxADQuery);
  frxObjects.UnRegister(TfrxADStoredProc);
end.
