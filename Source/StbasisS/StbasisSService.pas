unit StbasisSService;

interface

uses Windows, SvcMgr, Classes,
     StbasisSLog, StbasisSConfig;

type

  TChangeServiceConfig2A = function (hService: Integer; dwInfoLevel: DWORD; lpBuffer: PByte): BOOL; stdcall;

  TStbasisSService=class(TService)
  private
    FServiceController: TServiceController;
    FDescription: String;
    FConfig: TStbasisSConfig;
    FAfterInstall: TServiceEvent;
    FChangeServiceConfig2A: TChangeServiceConfig2A;
    procedure DoAfterInstall(Sender: TService);
    procedure SetDescription;
    function GetChangeServiceConfig2A: Boolean;
    procedure Start(Sender: TService; var Started: Boolean);
    procedure Stop(Sender: TService; var Stopped: Boolean);
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer); override;
    function GetServiceController: TServiceController; override;
    procedure Controller(CtrlCode: DWord);
    procedure AssignLogMessages(Strings: TStrings);
    procedure LogWrite(const Message: string; LogType: TStbasisSLogType);

    procedure Init;

    property ServiceController: TServiceController read FServiceController write FServiceController;
    property Description: String read FDescription write FDescription;
    property Config: TStbasisSConfig read FConfig write FConfig;
  published
    property AfterInstall: TServiceEvent read FAfterInstall;
  end;

implementation

uses SysUtils, WinSvc,
     StbasisSUtils, StbasisSData, StbasisSCode;

const
  advapi32 = 'advapi32.dll';
  SERVICE_CONFIG_DESCRIPTION     = 1;
  SERVICE_CONFIG_FAILURE_ACTIONS = 2;

type
  LPSERVICE_DESCRIPTIONA = ^SERVICE_DESCRIPTIONA;
  _SERVICE_DESCRIPTIONA = record
    lpDescription: LPSTR;
  end;
  SERVICE_DESCRIPTIONA = _SERVICE_DESCRIPTIONA;
  TServiceDescriptionA = SERVICE_DESCRIPTIONA;
  PServiceDescriptionA = LPSERVICE_DESCRIPTIONA;

constructor TStbasisSService.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner,Dummy);
  inherited AfterInstall:=DoAfterInstall;
  OnStart:=Start;
  OnStop:=Stop;
end;

function TStbasisSService.GetServiceController: TServiceController;
begin
  Result:=FServiceController;
end;

procedure TStbasisSService.Controller(CtrlCode: DWord);
begin
  inherited Controller(CtrlCode);
end;

procedure TStbasisSService.DoAfterInstall(Sender: TService);
begin
  SetDescription;
end;

procedure TStbasisSService.SetDescription;
var
  Svc: Integer;
  Mgr: Integer;
  Proc: TChangeServiceConfig2A;
  Desc: TServiceDescriptionA;
begin
  if not GetChangeServiceConfig2A then exit;
  Proc:=FChangeServiceConfig2A;
  if Assigned(Proc) then begin
    Mgr:=OpenSCManager(nil,nil,SC_MANAGER_ALL_ACCESS);
    if Mgr=0 then RaiseLastWin32Error;
    try
      Svc:=OpenService(Mgr,PChar(Name),SERVICE_ALL_ACCESS);
      if Svc=0 then RaiseLastWin32Error;
      try
        FillChar(Desc,SizeOf(Desc),0);
        Desc.lpDescription:=PChar(FDescription);
        if not Proc(Svc,SERVICE_CONFIG_DESCRIPTION,@Desc) then
          FDescription:='';
      finally
        CloseServiceHandle(Svc);
      end;
    finally
      CloseServiceHandle(Mgr);
    end;
  end;  
end;

function TStbasisSService.GetChangeServiceConfig2A: Boolean;
var
  H: THandle;
const
  SChangeServiceConfig2='ChangeServiceConfig2A';
begin
  Result:=false;
  FChangeServiceConfig2A:=nil;

  If (Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion >= 5) then begin
    H:=GetModuleHandle(advapi32);
    if H<>0 then begin
      FChangeServiceConfig2A:=GetProcAddress(H,SChangeServiceConfig2);
    end;
  end;
  
  if Assigned(FChangeServiceConfig2A) then
    Result:=true;

end;

procedure TStbasisSService.AssignLogMessages(Strings: TStrings);
var
  i: Integer;
begin
  if Assigned(Strings) then begin
    for i:=0 to Strings.Count-1 do
      LogWrite(Strings.Strings[i],ltInformation);
  end;
end;

procedure TStbasisSService.LogWrite(const Message: string; LogType: TStbasisSLogType);
var
  EventType: DWord;
begin
  EventType:=EVENTLOG_INFORMATION_TYPE;
  case LogType of
    ltInformation: EventType:=EVENTLOG_INFORMATION_TYPE;
    ltWarning: EventType:=EVENTLOG_WARNING_TYPE;
    ltError: EventType:=EVENTLOG_ERROR_TYPE;
  end;
  LogMessage(Message,EventType);
end;

procedure TStbasisSService.Start(Sender: TService; var Started: Boolean);
begin
  StartApplication;
  Started:=true;
end;

procedure TStbasisSService.Stop(Sender: TService; var Stopped: Boolean);
begin
  StopApplication;
  Stopped:=true;
end;

procedure TStbasisSService.Init;
var
  List: TStringList;
  Values: String;
  i: Integer;
  AName: string;
  AEnabled: Boolean;
  Depend: TDependency;
begin
  AllowPause:=false;
  DisplayName:=FDisplayName;
  Name:=FName;
  Description:=FDescription;
  StartType:=stAuto;
  
  Dependencies.Clear;
  List:=TStringList.Create;
  try
    FConfig.ReadSection(SSectionDependencies,Values);
    List.Text:=Values;
    for i:=0 to List.Count-1 do begin
      AName:=List.Strings[i];
      if Trim(AName)<>'' then begin
        AEnabled:=FConfig.ReadBool(SSectionDependencies,AName,false);
        if AEnabled then begin
          Depend:=TDependency(Dependencies.Add);
          if Assigned(Depend) then begin
            Depend.IsGroup:=false;
            Depend.Name:=AName;
          end;
        end;
      end;
    end;
  finally
    List.Free;
  end;
end;

end.
