unit ADSpeedBaseDB;

interface

uses
  Classes, DB,
  daADStanIntf,
  ADSpeedBase;

type
  TADSpeedCustomDBDataSet = class;
  TADSpeedCustomDBDataSetTest = class;

  {---------------------------------------------------------------------------}
  { TADSpeedCustomDBDataSet                                                   }
  {---------------------------------------------------------------------------}
  TADSpeedCustomDBDataSet = class(TADSpeedCustomDataSet)
  private
    FArraySize: Integer;
    FConnection: TObject;
  protected
    FArrayIndex: Integer;
    procedure SetArraySize(ATimes: Integer); virtual;
    procedure SetConnection(AConnection: TObject); virtual;
    procedure SetParam(AIndex: Integer; const AValue: Variant); virtual; abstract;
    function GetParam(AIndex: Integer): Variant; virtual; abstract;
    function GetSQL: String; virtual; abstract;
    procedure SetSQL(const Value: String); virtual; abstract;
  public
    procedure Prepare; virtual;
    procedure UnPrepare; virtual;
    procedure Execute; virtual; abstract;
    procedure StartTransaction; virtual; abstract;
    procedure RollbackTransaction; virtual; abstract;
    procedure Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean); virtual;
    procedure DefineParam(const AName: String; ADataType: TFieldType;
      ADataSize: Integer; AParamType: TParamType); virtual; abstract;
    class function AllocConnection: TObject; virtual; abstract;
    class procedure OpenConnection(AConnection: TObject; const AConnDef: IADStanConnectionDef); virtual; abstract;
    class procedure CloseConnection(AConnection: TObject); virtual; abstract;
{$IFDEF AnyDACSPEED_ORA}
    class procedure SetOraSrvClientInfo(AConnection: TObject; const AInfo: String); virtual;
    class procedure SetOraSrvTestInfo(AConnection: TObject; const AInfo: String); virtual;
{$ENDIF}
    property ArraySize: Integer read FArraySize write SetArraySize;
    property Connection: TObject read FConnection write SetConnection;
    property Params[AIndex: Integer]: Variant read GetParam write SetParam;
    property SQL: String read GetSQL write SetSQL;
  end;
  TADSpeedCustomDBDataSetClass = class of TADSpeedCustomDBDataSet;

  {---------------------------------------------------------------------------}
  { TADSpeedCustomDBDataSetTest                                               }
  {---------------------------------------------------------------------------}
  TADSpeedCustomDBDataSetTest = class(TADSpeedCustomDataSetTest)
  private
    function GetTestingDBDataSet: TADSpeedCustomDBDataSet;
  protected
    procedure InternalPrepare; override;
    procedure InternalUnPrepare; override;
  public
    property TestingDBDataSet: TADSpeedCustomDBDataSet read GetTestingDBDataSet;
  end;

  {---------------------------------------------------------------------------}
  { TADSpeedDBTestManager                                                     }
  {---------------------------------------------------------------------------}
  TADSpeedDBTestManager = class(TADSpeedTestManager)
  private
    FDSConnectionList: TList;
    FConnDefs: IADStanConnectionDefs;
    FConnDef: IADStanConnectionDef;
    FConnDefName: String;
    function GetDSConnection(AIndex: Integer): TObject;
  protected
    procedure SetupDataSet(ADS: TADSpeedCustomDataSet; ADataSetIndex: Integer); override;
    function GetIsValid: Boolean; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterDS(ADS: TADSpeedCustomDataSetClass); override;
    procedure OpenConnection(AIndex: Integer);
    procedure OpenConnections;
    procedure CloseConnections;
    property ConnDef: IADStanConnectionDef read FConnDef;
    property ConnDefName: String read FConnDefName write FConnDefName;
    property DSConnection[AIndex: Integer]: TObject read GetDSConnection;
  end;

implementation

uses
  Windows, SysUtils,
  daADStanFactory;

{---------------------------------------------------------------------------}
{ TADSpeedCustomDBDataSet                                                   }
{---------------------------------------------------------------------------}
procedure TADSpeedCustomDBDataSet.Prepare;
begin
  // nothing
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDBDataSet.SetConnection(AConnection: TObject);
begin
  FConnection := AConnection;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDBDataSet.SetArraySize(ATimes: Integer);
begin
  FArraySize := ATimes;
  FArrayIndex := 0;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDBDataSet.UnPrepare;
begin
  // nothing
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDBDataSet.Setup(AFetchAll, AWithBlobs, AReadOnly: Boolean);
begin
  // nothing
end;

{$IFDEF AnyDACSPEED_ORA}
{---------------------------------------------------------------------------}
class procedure TADSpeedCustomDBDataSet.SetOraSrvClientInfo(
  AConnection: TObject; const AInfo: String);
var
  oDS: TADSpeedCustomDBDataSet;
begin
  try
    oDS := Create;
    try
      if oDS.GetCanExecute then begin
        oDS.Connection := AConnection;
        oDS.Setup(False, False, True);
        oDS.SQL := 'begin dbms_application_info.set_client_info(''' + AInfo + '''); end;';
        oDS.Execute;
      end;
    finally
      oDS.Free;
    end;
  except
  end;
end;

{---------------------------------------------------------------------------}
class procedure TADSpeedCustomDBDataSet.SetOraSrvTestInfo(
  AConnection: TObject; const AInfo: String);
var
  oDS: TADSpeedCustomDBDataSet;
begin
  try
    oDS := Create;
    try
      if oDS.GetCanExecute then begin
        oDS.Connection := AConnection;
        oDS.Setup(False, False, True);
        oDS.SQL := 'begin dbms_application_info.set_module(''' + AInfo + ''', ''''); end;';
        oDS.Execute;
      end;
    finally
      oDS.Free;
    end;
  except
  end;
end;
{$ENDIF}

{---------------------------------------------------------------------------}
{ TADSpeedCustomDBDataSetTest                                               }
{---------------------------------------------------------------------------}
function TADSpeedCustomDBDataSetTest.GetTestingDBDataSet: TADSpeedCustomDBDataSet;
begin
  Result := TADSpeedCustomDBDataSet(TestingDataSet);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDBDataSetTest.InternalPrepare;
begin
  inherited InternalPrepare;
  with TestingDBDataSet do begin
{$IFDEF AnyDACSPEED_ORA}
    SetOraSrvTestInfo(Connection, GetName);
{$ENDIF}
    Prepare;
  end;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedCustomDBDataSetTest.InternalUnPrepare;
begin
  TestingDBDataSet.DataSet.Active := False;
  inherited InternalUnPrepare;
  TestingDBDataSet.Unprepare;
end;

{---------------------------------------------------------------------------}
{ TADSpeedDBTestManager                                                     }
{---------------------------------------------------------------------------}
constructor TADSpeedDBTestManager.Create;
begin
  inherited Create;
  FDSConnectionList := TList.Create;
end;

{---------------------------------------------------------------------------}
destructor TADSpeedDBTestManager.Destroy;
var
  i: Integer;
begin
  ClearTests;
  for i := 0 to FDSConnectionList.Count - 1 do
    TObject(FDSConnectionList[i]).Free;
  FDSConnectionList.Free;
  FDSConnectionList := nil;
  inherited Destroy;
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDBTestManager.SetupDataSet(ADS: TADSpeedCustomDataSet;
  ADataSetIndex: Integer);
begin
  inherited SetupDataSet(ADS, ADataSetIndex);
  TADSpeedCustomDBDataSet(ADS).Connection := DSConnection[ADataSetIndex];
end;

{---------------------------------------------------------------------------}
function TADSpeedDBTestManager.GetIsValid: Boolean;
begin
  Result := inherited GetIsValid and (ConnDef <> nil);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDBTestManager.RegisterDS(ADS: TADSpeedCustomDataSetClass);
begin
  inherited RegisterDS(ADS);
  FDSConnectionList.Add(TADSpeedCustomDBDataSetClass(ADS).AllocConnection);
end;

{---------------------------------------------------------------------------}
function TADSpeedDBTestManager.GetDSConnection(AIndex: Integer): TObject;
begin
  Result := TObject(FDSConnectionList[AIndex]);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDBTestManager.OpenConnection(AIndex: Integer);
begin
  TADSpeedCustomDBDataSetClass(DSClass[AIndex]).OpenConnection(DSConnection[AIndex], FConnDef);
{$IFDEF AnyDACSPEED_ORA}
  TADSpeedCustomDBDataSetClass(DSClass[AIndex]).SetOraSrvClientInfo(DSConnection[AIndex], DSClass[AIndex].GetName);
{$ENDIF}
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDBTestManager.OpenConnections;
var
  i: Integer;
begin
  if Assigned(OnStart) then
    OnStart(Self);
  FConnDef := nil;
  FConnDefs := nil;
  ADCreateInterface(IADStanConnectionDefs, FConnDefs);
  FConnDef := FConnDefs.ConnectionDefByName(FConnDefName);
  for i := 0 to DSCount - 1 do begin
    if Assigned(OnProgress) then
      OnProgress(Self, nil, MulDiv(i + 1, 100, DSCount));
    try
      OpenConnection(i);
    except
      on E: Exception do
        if Assigned(OnError) then
          OnError(Self, E);
    end;
  end;
  if Assigned(OnEnd) then
    OnEnd(Self);
end;

{---------------------------------------------------------------------------}
procedure TADSpeedDBTestManager.CloseConnections;
var
  i: Integer;
begin
  for i := 0 to DSCount - 1 do
    TADSpeedCustomDBDataSetClass(DSClass[i]).CloseConnection(DSConnection[i]);
  FConnDef := nil;
  FConnDefs := nil;
end;

end.
