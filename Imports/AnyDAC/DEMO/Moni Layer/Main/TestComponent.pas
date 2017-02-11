unit TestComponent;

interface

uses
  Classes, SysUtils, Variants, ExtCtrls, Forms,
  daADStanIntf, daADStanFactory,
  daADPhysIntf,
  daADGUIxFormsWait;

type
  TTestComp = class(TComponent, IADStanObject, IADMoniAdapter)
  private
    FTimer: TTimer;
    FActive: Boolean;
    FHandle: THandle;
    procedure DoTimer(Sender: TObject);
    function GetPaused: Boolean;
    procedure SetPaused(AValue: Boolean);
  protected
    { IADStanObject }
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    { IADMoniAdapter }
    function GetHandle: THandle;
    function GetItemCount: Integer;
    procedure GetItem(AIndex: Integer; var AName: String; var AValue: Variant;
      var AKind: TADDebugMonitorAdapterItemKind);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Activate;
    property Paused: Boolean read GetPaused write SetPaused;
  end;

function MonitorClient: IADMoniClient;

implementation

var
  FMonitorClient: IADMoniClient;

function MonitorClient: IADMoniClient;
var
  oRemClnt: IADMoniRemoteClient;
begin
  if FMonitorClient = nil then begin
    ADCreateInterface(IADMoniRemoteClient, oRemClnt);
    FMonitorClient := oRemClnt as IADMoniClient;
    FMonitorClient.Tracing := True;
  end;
  Result := FMonitorClient;
end;

constructor TTestComp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := 1000;
  FTimer.OnTimer := DoTimer;
end;

destructor TTestComp.Destroy;
begin
  if not (csDesigning in ComponentState) and FActive then
    MonitorClient.UnregisterAdapter(Self);
  FTimer.Free;
  inherited Destroy;
end;

procedure TTestComp.Activate;
begin
  if not (csDesigning in ComponentState) then begin
    FHandle := MonitorClient.RegisterAdapter(Self);
    FActive := True;
    FTimer.Enabled := True;
  end;
end;

procedure TTestComp.DoTimer(Sender: TObject);
begin
  MonitorClient.Notify(ekConnService, esProgress, Self,
    'Testing '{ + DateToStr(Now)}, [1, 'abdf']);
  MonitorClient.AdapterChanged(Self);
end;

function TTestComp.GetPaused: Boolean;
begin
  Result := not FTimer.Enabled;
end;

procedure TTestComp.SetPaused(AValue: Boolean);
begin
  FTimer.Enabled := not AValue;
end;

// ----------------------------------------------------------------------------
// IADStanObject

function TTestComp.GetName: TComponentName;
begin
  if Name = '' then
    Result := '$' + IntToHex(Integer(Self), 8)
  else
    Result := Name;
end;

function TTestComp.GetParent: IADStanObject;
begin
  Result := nil;
end;

procedure TTestComp.AfterReuse;
begin
  // nothing
end;

procedure TTestComp.BeforeReuse;
begin
  // nothing
end;

procedure TTestComp.SetOwner(const AOwner: TObject; const ARole: TComponentName);
begin
  // nothing
end;

// ----------------------------------------------------------------------------
// IADMoniAdapter

function TTestComp.GetHandle: THandle;
begin
  Result := FHandle;
end;

function TTestComp.GetItemCount: Integer;
begin
  Result := 10;
end;

procedure TTestComp.GetItem(AIndex: Integer; var AName: String; var AValue: Variant;
  var AKind: TADDebugMonitorAdapterItemKind);
begin
  case AIndex of
  7:
    begin
      AName := 'SQL';
      AValue := 'SELECT * FROM QWE';
      AKind := ikSQL;
    end;
  8:
    begin
      AName := 'Param1';
      AValue := Null;
      AKind := ikParam;
    end;
  9:
    begin
      AName := 'Param2';
      AValue := DateTimeToStr(Now());
      AKind := ikParam;
    end;
  else
    AName := IntToStr(AIndex);
    AValue := AIndex * 10;
    AKind := ikStat;
  end;
end;

initialization

finalization

  FMonitorClient := nil;

end.
