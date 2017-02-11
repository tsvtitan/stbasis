unit RasHelperClasses;

interface

uses
  Windows, Messages, Classes, SysUtils, Forms, Contnrs, Ras, RasError, RasUtils;

type
  TRasBaseList = class(TPersistent)
  private
    FOnRefresh: TNotifyEvent;
    function GetCount: Integer;
  protected
    FItems: TObjectList;
    procedure DoRefresh; dynamic;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Refresh; dynamic; abstract;
    property Count: Integer read GetCount;
    property OnRefresh: TNotifyEvent read FOnRefresh write FOnRefresh;
  end;

  TRasPhonebook = class;

  TRasPhonebookEntry = class(TPersistent)
  private
    FName: String;
    FOwner: TRasPhonebook;
    FPasswordStored: Boolean;
    procedure SetCallbackNumber(const Value: String);
    procedure SetDomain(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetPhoneNumber(const Value: String);
    procedure SetUserName(const Value: String);
    function GetCallbackNumber: String;
    function GetDomain: String;
    function GetPassword: String;
    function GetPhoneNumber: String;
    function GetUserName: String;
    function GetDialParams: TRasDialParams;
    procedure SetDialParams(const Value: TRasDialParams);
    function GetPhoneBook: String;
  public
    constructor Create(AOwner: TRasPhonebook; const AName: String);
    procedure DeleteEntry;
    procedure EditEntry(Wnd: HWND = 0);
    function GetProperties(var Value: PRasEntry): DWORD;
    procedure RenameEntry(const NewName: String);
    function SetProperties(const Value: PRasEntry; Size: DWORD; FreeValue: Boolean = False): DWORD;
    property CallbackNumber: String read GetCallbackNumber write SetCallbackNumber;
    property DialParams: TRasDialParams read GetDialParams write SetDialParams;
    property Domain: String read GetDomain write SetDomain;
    property Password: String read GetPassword write SetPassword;
    property PasswordStored: Boolean read FPasswordStored write FPasswordStored;
    property PhoneBook: String read GetPhoneBook;
    property PhoneNumber: String read GetPhoneNumber write SetPhoneNumber;
    property Name: String read FName;
    property UserName: String read GetUserName write SetUserName;
  end;

  TRasPhonebook = class(TRasBaseList)
  private
    FPBK: PChar;
    FPhoneBook: String;
    function GetItems(Index: Integer): TRasPhonebookEntry;
    procedure SetPhoneBook(const Value: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure CreateEntryInteractive(Wnd: HWND = 0);
    procedure Refresh; override;
    function ValidateName(const EntryName: String): Boolean;
    property Items[Index: Integer]: TRasPhonebookEntry read GetItems; default;
    property PhoneBook: String read FPhoneBook write SetPhoneBook;
  end;

  TRasConnectionsList = class;

  TRasConnectionItem = class(TObject)
  private
    FOwner: TRasConnectionsList;
    FRasConn: TRasConn;
    function GetDeviceName: String;
    function GetDeviceType: String;
    function GetName: String;
    function GetIsConnected: Boolean;
    function GetConnStatus: TRasConnStatus;
    function GetConnStatusStr: String;
  public
    constructor Create(AOwner: TRasConnectionsList; ARasConn: TRasConn);
    procedure HangUp(WaitToCompleteSec: Integer = 5);
    property ConnStatus: TRasConnStatus read GetConnStatus;
    property ConnStatusStr: String read GetConnStatusStr;
    property DeviceName: String read GetDeviceName;
    property DeviceType: String read GetDeviceType;
    property IsConnected: Boolean read GetIsConnected;
    property Name: String read GetName;
    property RasConn: TRasConn read FRasConn;
  end;

  TRasConnectionsList = class(TRasBaseList)
  private
    function GetItems(Index: Integer): TRasConnectionItem;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure Refresh; override;
    property Items[Index: Integer]: TRasConnectionItem read GetItems; default;
  end;

  TRasDialerEvent = procedure (Sender: TObject; State: TRasConnState; ErrorCode: DWORD) of object;

  TRasDialer = class(TPersistent)
  private
    FConnHandle: THRasConn;
    FNotifyMessage: DWORD;
    FNotifyWnd: HWND;
    FParams: TRasDialParams;
    FOnNotify: TRasDialerEvent;
    function GetActive: Boolean;
    function GetPassword: String;
    function GetPhoneNumber: String;
    function GetUserName: String;
    procedure SetPassword(const Value: String);
    procedure SetPhoneNumber(const Value: String);
    procedure SetUserName(const Value: String);
  protected
    procedure DoDialEvent(Message: TMessage);
    procedure WndProc(var Message: TMessage);
  public
    procedure Assign(Source: TPersistent); override;
    constructor Create;
    destructor Destroy; override;
    procedure Dial;
    procedure HangUp;
    property Active: Boolean read GetActive;
    property ConnHandle: THRasConn read FConnHandle;
    property Params: TRasDialParams read FParams write FParams;
    property Password: String read GetPassword write SetPassword;
    property PhoneNumber: String read GetPhoneNumber write SetPhoneNumber;
    property UserName: String read GetUserName write SetUserName;
    property OnNotify: TRasDialerEvent read FOnNotify write FOnNotify;
  end;

  TRasDevicesList = array of TRasDevInfo;
  function GetRasDevicesList: TRasDevicesList;

implementation

function GetRasDevicesList: TRasDevicesList;
var
  BufSize, NumberOfEntries, Res: DWORD;
begin
  SetLength(Result, 1);
  Result[0].dwSize := Sizeof(TRasDevInfo);
  BufSize := Sizeof(TRasDevInfo);
  Res := RasEnumDevices(@Result[0], BufSize, NumberOfEntries);
  if Res = ERROR_BUFFER_TOO_SMALL then
  begin
    SetLength(Result, BufSize div Sizeof(TRasDevInfo));
    Result[0].dwSize := Sizeof(TRasDevInfo);
    Res := RasEnumDevices(@Result[0], BufSize, NumberOfEntries);
  end;
  RasCheck(Res);
end;

procedure ConnectionHangUp(ConnHandle: THRasConn; WaitToCompleteSec: Integer);
var
  Status: TRasConnStatus;
  Res: DWORD;
begin
  RasCheck(RasHangUp(ConnHandle));
  ZeroMemory(@Status, Sizeof(Status));
  Status.dwSize := Sizeof(Status);
  WaitToCompleteSec := WaitToCompleteSec * 10;
  repeat
    Sleep(100);
    Dec(WaitToCompleteSec);
    Res := RasGetConnectStatus(ConnHandle, Status);
  until (WaitToCompleteSec = 0) or (Res = ERROR_INVALID_HANDLE);
end;

{ TRasBaseList }

constructor TRasBaseList.Create;
begin
  inherited Create;
  FItems := TObjectList.Create(True);
  Refresh;
end;

destructor TRasBaseList.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TRasBaseList.DoRefresh;
begin
  if Assigned(FOnRefresh) then FOnRefresh(Self);
end;

function TRasBaseList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

{ TRasPhonebookEntry }

constructor TRasPhonebookEntry.Create(AOwner: TRasPhonebook; const AName: String);
begin
  inherited Create;
  FName := AName;
  FOwner := AOwner;
end;

procedure TRasPhonebookEntry.DeleteEntry;
begin
  RasCheck(RasDeleteEntry(FOwner.FPBK, PChar(FName)));
  FOwner.Refresh;
end;

procedure TRasPhonebookEntry.EditEntry(Wnd: HWND);
begin
  RasCheck(RasEditPhonebookEntry(Wnd, FOwner.FPBK, PChar(FName)));
  FOwner.Refresh;
end;

function TRasPhonebookEntry.GetCallbackNumber: String;
begin
  Result := GetDialParams.szCallbackNumber;
end;

function TRasPhonebookEntry.GetDialParams: TRasDialParams;
var
  B: BOOL;
begin
  ZeroMemory(@Result, Sizeof(Result));
  Result.dwSize := Sizeof(Result);
  StrPCopy(Result.szEntryName, FName);
  if Assigned(FOwner) then
    RasCheck(RasGetEntryDialParams(FOwner.FPBK, Result, B))
  else
    RasCheck(RasGetEntryDialParams(nil, Result, B));
  FPasswordStored := B;
end;

function TRasPhonebookEntry.GetDomain: String;
begin
  Result := GetDialParams.szDomain;
end;

function TRasPhonebookEntry.GetPassword: String;
begin
  Result := GetDialParams.szPassword;
end;

function TRasPhonebookEntry.GetPhoneBook: String;
begin
  Result := FOwner.FPhoneBook;
end;

function TRasPhonebookEntry.GetPhoneNumber: String;
var
  Prop: PRasEntry;
begin
  GetProperties(Prop);
  Result := Prop^.szLocalPhoneNumber;
  FreeMem(Prop);
end;

function TRasPhonebookEntry.GetProperties(var Value: PRasEntry): DWORD;
var
  Res: DWORD;
begin
  Result := 0;
  Res := RasGetEntryProperties(FOwner.FPBK, PChar(FName), nil,
    Result, nil, nil);
  if Res <> ERROR_BUFFER_TOO_SMALL then RasCheck(Res);
  Value := AllocMem(Result);
  Value^.dwSize := Sizeof(TRasEntry);
  Res := RasGetEntryProperties(FOwner.FPBK, PChar(FName), Value,
    Result, nil, nil);
  if Res <> SUCCESS then
  begin
    FreeMem(Value);
    RasCheck(Res);
  end;
end;

function TRasPhonebookEntry.GetUserName: String;
begin
  Result := GetDialParams.szUserName;
end;

procedure TRasPhonebookEntry.RenameEntry(const NewName: String);
begin
  RasCheck(RasRenameEntry(FOwner.FPBK, PChar(FName), PChar(NewName)));
  FOwner.Refresh;
end;

procedure TRasPhonebookEntry.SetCallbackNumber(const Value: String);
var
  P: TRasDialParams;
begin
  P := GetDialParams;
  StrPCopy(P.szCallbackNumber, Value);
  SetDialParams(P);
end;

procedure TRasPhonebookEntry.SetDialParams(const Value: TRasDialParams);
begin
  RasCheck(RasSetEntryDialParams(FOwner.FPBK, @Value, FPasswordStored));
end;

procedure TRasPhonebookEntry.SetDomain(const Value: String);
var
  P: TRasDialParams;
begin
  P := GetDialParams;
  StrPCopy(P.szDomain, Value);
  SetDialParams(P);
end;

procedure TRasPhonebookEntry.SetPassword(const Value: String);
var
  P: TRasDialParams;
begin
  P := GetDialParams;
  StrPCopy(P.szPassword, Value);
  SetDialParams(P);
end;

procedure TRasPhonebookEntry.SetPhoneNumber(const Value: String);
var
  Prop: PRasEntry;
  Size: DWORD;
begin
  Size := GetProperties(Prop);
  StrPCopy(Prop^.szLocalPhoneNumber, Value);
  SetProperties(Prop, Size, True);
end;

function TRasPhonebookEntry.SetProperties(const Value: PRasEntry; Size: DWORD;
  FreeValue: Boolean): DWORD;
begin
  Result := RasSetEntryProperties(FOwner.FPBK, PChar(FName), Value,
    Size, nil, 0);
  if FreeValue then
  begin
    FreeMem(Value);
    RasCheck(Result);
  end;
end;

procedure TRasPhonebookEntry.SetUserName(const Value: String);
var
  P: TRasDialParams;
begin
  P := GetDialParams;
  StrPCopy(P.szUserName, Value);
  SetDialParams(P);
end;

{ TRasPhonebook }

procedure TRasPhonebook.AssignTo(Dest: TPersistent);
var
  I: Integer;
begin
  if Dest is TStrings then
  begin
    with TStrings(Dest) do
    begin
      BeginUpdate;
      try
        Clear;
        for I := 0 to FItems.Count - 1 do
          AddObject(Items[I].Name, Items[I]);
      finally
        EndUpdate;
      end;
    end;
  end else inherited;
end;

procedure TRasPhonebook.CreateEntryInteractive(Wnd: HWND);
var
  S: PChar;
begin
  S:=PChar(FPhoneBook);
  RasCheck(RasCreatePhonebookEntry(Wnd, S));
  Refresh;
end;

function TRasPhonebook.GetItems(Index: Integer): TRasPhonebookEntry;
begin
  Result := TRasPhonebookEntry(FItems[Index]);
end;

procedure TRasPhonebook.Refresh;
var
  Entries, P: PRasEntryName;
  BufSize, NumberOfEntries, Res: DWORD;
  I: Integer;

  procedure InitFirstEntry;
begin
  ZeroMemory(Entries, BufSize);
  Entries^.dwSize := Sizeof(TRasEntryName);
  NumberOfEntries := 0;
end;

begin
  FItems.Clear;
  New(Entries);
  BufSize := Sizeof(TRasEntryName);
  InitFirstEntry;
  Res := RasEnumEntries(nil, FPBK, Entries, BufSize, NumberOfEntries);
  if Res = ERROR_BUFFER_TOO_SMALL then
  begin
    ReallocMem(Entries, BufSize);
    InitFirstEntry;
    Res := RasEnumEntries(nil, FPBK, Entries, BufSize, NumberOfEntries);
  end;
  try
    RasCheck(Res);
    P := Entries;
    for I := 1 to NumberOfEntries do
    begin
      FItems.Add(TRasPhonebookEntry.Create(Self, P^.szEntryName));
      Inc(P);
    end;
    DoRefresh;
  finally
    FreeMem(Entries);
  end;
end;

procedure TRasPhonebook.SetPhoneBook(const Value: String);
begin
  if FPhoneBook <> Value then
  begin
    FPhoneBook := Value;
    FPBK := PChar(FPhoneBook);
    if FPBK^ = #0 then FPBK := nil;
    Refresh;
  end;
end;

function TRasPhonebook.ValidateName(const EntryName: String): Boolean;
var
  Res: DWORD;
begin
  Result := False;
  Res := RasValidateEntryName(FPBK, PChar(EntryName));
  case Res of
    ERROR_SUCCESS, ERROR_ALREADY_EXISTS:
      Result := True;
    ERROR_INVALID_NAME:
      Result := False;
  else
    RasCheck(Res);
  end;
end;

{ TRasConnectionItem }

constructor TRasConnectionItem.Create(AOwner: TRasConnectionsList; ARasConn: TRasConn);
begin
  inherited Create;
  FOwner := AOwner;
  FRasConn := ARasConn;
end;

function TRasConnectionItem.GetConnStatus: TRasConnStatus;
begin
  ZeroMemory(@Result, Sizeof(Result));
  Result.dwSize := Sizeof(Result);
  RasCheck(RasGetConnectStatus(FRasConn.hrasconn, Result));
end;

function TRasConnectionItem.GetConnStatusStr: String;
begin
  with GetConnStatus do
    Result := RasConnStatusString(rasconnstate, dwError);
end;

function TRasConnectionItem.GetDeviceName: String;
begin
  Result := FRasConn.szDeviceName;
end;

function TRasConnectionItem.GetDeviceType: String;
begin
  Result := FRasConn.szDeviceType;
end;

function TRasConnectionItem.GetIsConnected: Boolean;
begin
  Result := (GetConnStatus.rasconnstate = RASCS_DeviceConnected);
end;

function TRasConnectionItem.GetName: String;
begin
  Result := FRasConn.szEntryName;
end;

procedure TRasConnectionItem.HangUp(WaitToCompleteSec: Integer);
begin
  ConnectionHangUp(FRasConn.hrasconn, WaitToCompleteSec);
  FOwner.Refresh;
end;

{ TRasConnectionsList }

procedure TRasConnectionsList.AssignTo(Dest: TPersistent);
var
  I: Integer;
begin
  if Dest is TStrings then
  begin
    with TStrings(Dest) do
    begin
      BeginUpdate;
      try
        Clear;
        for I := 0 to FItems.Count - 1 do
          AddObject(Items[I].Name, Items[I]);
      finally
        EndUpdate;
      end;
    end;
  end else inherited;
end;

function TRasConnectionsList.GetItems(Index: Integer): TRasConnectionItem;
begin
  Result := TRasConnectionItem(FItems[Index]);
end;

procedure TRasConnectionsList.Refresh;
var
  Entries, P: PRasConn;
  BufSize, NumberOfEntries, Res: DWORD;
  I: Integer;

  procedure InitFirstEntry;
begin
  ZeroMemory(Entries, BufSize);
  Entries^.dwSize := Sizeof(Entries^);
end;

begin
  FItems.Clear;
  New(Entries);
  BufSize := Sizeof(Entries^);
  InitFirstEntry;
  Res := RasEnumConnections(Entries, BufSize, NumberOfEntries);
  if Res = ERROR_BUFFER_TOO_SMALL then
  begin
    ReallocMem(Entries, BufSize);
    InitFirstEntry;
    Res := RasEnumConnections(Entries, BufSize, NumberOfEntries);
  end;
  try
    RasCheck(Res);
    P := Entries;
    for I := 1 to NumberOfEntries do
    begin
      FItems.Add(TRasConnectionItem.Create(Self, P^));
      Inc(P);
    end;
    DoRefresh;
  finally
    FreeMem(Entries);
  end;
end;

{ TRasDialer }

procedure TRasDialer.Assign(Source: TPersistent);
begin
  if Source is TRasPhonebookEntry then
    with TRasPhonebookEntry(Source) do
    begin
      FParams := DialParams;
      FParams.szEntryName := '';
      Self.PhoneNumber := PhoneNumber;
    end else inherited;
end;

constructor TRasDialer.Create;
begin
  inherited Create;
  FNotifyMessage := RegisterWindowMessage(RASDIALEVENT);
  if FNotifyMessage = 0 then FNotifyMessage := WM_RASDIALEVENT;
  FNotifyWnd := AllocateHWnd(WndProc);
  ZeroMemory(@FParams, Sizeof(FParams));
  FParams.dwSize := Sizeof(FParams);
end;

destructor TRasDialer.Destroy;
begin
  DeallocateHWnd(FNotifyWnd);
  inherited;
end;

procedure TRasDialer.Dial;
begin
  FConnHandle := 0;
  RasCheck(RasDial(nil, nil, @FParams, $FFFFFFFF, Pointer(FNotifyWnd), FConnHandle));
end;

procedure TRasDialer.DoDialEvent(Message: TMessage);
begin
  with Message do
  begin
    if WParam = RASCS_Disconnected then FConnHandle := 0;
    if Assigned(FOnNotify) then FOnNotify(Self, WParam, LParam);
  end;
end;

function TRasDialer.GetActive: Boolean;
begin
  Result := FConnHandle <> 0;
end;

function TRasDialer.GetPassword: String;
begin
  Result := FParams.szPassword;
end;

function TRasDialer.GetPhoneNumber: String;
begin
  Result := FParams.szPhoneNumber;
end;

function TRasDialer.GetUserName: String;
begin
  Result := FParams.szUserName;
end;

procedure TRasDialer.HangUp;
begin
  ConnectionHangUp(FConnHandle, 3);
end;

procedure TRasDialer.SetPassword(const Value: String);
begin
  StrPCopy(FParams.szPassword, Value);
end;

procedure TRasDialer.SetPhoneNumber(const Value: String);
begin
  StrPCopy(FParams.szPhoneNumber, Value);
end;

procedure TRasDialer.SetUserName(const Value: String);
begin
  StrPCopy(FParams.szUserName, Value);
end;

procedure TRasDialer.WndProc(var Message: TMessage);
begin
  with Message do
    if Msg = FNotifyMessage then
      try
        DoDialEvent(Message);
      except
        Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(FNotifyWnd, Msg, wParam, lParam);
end;

end.
