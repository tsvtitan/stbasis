unit tsvSyncClient;

interface

uses Windows, Classes, WinInet,
     Ras, RasUtils, RasHelperClasses,
     IdTCPClient, IdComponent,
     tsvPinger, StbasisSCrypter;

type
  TtsvSyncClient=class;

  TSyncTCPClient=class(TIdTCPClient)
  end;

  TConnectionType=(ctDirect,ctRemote,ctModem);

  TTypeConnection=(tcUnknown,tcModem,tcLan,tcProxy);

  TLogEvent=procedure (Message: string) of object;
  TGetDataEvent=procedure (InStream, OutStream: TMemoryStream) of object;
  TSetDataEvent=procedure (Stream: TMemoryStream) of object;

  TtsvSyncClient=class(TComponent)
  private
    FTCPClient: TSyncTCPClient;
    FDialer: TRasDialer;
    FConnected: Boolean;
    FBreak: Boolean;
    FConnectionType: TConnectionType;
    FDisplayName: String;
    FServerName: String;
    FServerPort: Integer;
    FOfficeName: String;
    FOfficeKey: String;
    FProxyName: String;
    FProxyPort: Integer;
    FProxyUserName: String;
    FProxyUserPass: String;
    FProxyByPass: String;
    FRemoteAuto: Boolean;
    FRemoteName: String;
    FModemUserName: String;
    FModemUserPass: String;
    FModemDomain: String;
    FModemPhone: String;
    FOnLog: TLogEvent;
    FCurrentIncremet: Integer;
    FParentHandle: THandle;
    FInternetConnection: DWord;
    FOnGetDataDesc: TGetDataEvent;
    FOnSetData: TSetDataEvent;
    FKeyOutHash: string;
    FOfficeKeyHash: string;
    FCrypter: TStbasisSCrypter;
    FOnSuccessData: TNotifyEvent;

    function GetTypeConnection: TTypeConnection;
    procedure ConnectToServer;
    procedure DisconnectFromServer;
    function Ping(var Error: String): Boolean;
    procedure SetOfficeKey(Value: String);
    function GetOnWorkBegin: TWorkBeginEvent;
    procedure SetOnWorkBegin(Value: TWorkBeginEvent);
    function GetOnWork: TWorkEvent;
    procedure SetOnWork(Value: TWorkEvent);
    function GetOnWorkEnd: TWorkEndEvent;
    procedure SetOnWorkEnd(Value: TWorkEndEvent);

    function TranslateError(ErrorCode: Integer): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;
    function Synchronize: Boolean;
    procedure Stop;
    procedure ConnectDirect;
    procedure ConnectRemote;
    procedure ConnectModem;

    procedure DisconnectDirect;
    procedure DisconnectRemote;
    procedure DisconnectModem;
    procedure LogWrite(Message: String);

    property ConnectionType: TConnectionType read FConnectionType write FConnectionType;
    property DisplayName: String read FDisplayName write FDisplayName;
    property ServerName: String read FServerName write FServerName;
    property ServerPort: Integer read FServerPort write FServerPort;
    property OfficeName: String read FOfficeName write FOfficeName;
    property OfficeKey: String read FOfficeKey write SetOfficeKey;
    property ProxyName: String read FProxyName write FProxyName;
    property ProxyPort: Integer read FProxyPort write FProxyPort;
    property ProxyUserName: String read FProxyUserName write FProxyUserName;
    property ProxyUserPass: String read FProxyUserPass write FProxyUserPass;
    property ProxyByPass: String read FProxyByPass write FProxyByPass;
    property RemoteAuto: Boolean read FRemoteAuto write FRemoteAuto;
    property RemoteName: String read FRemoteName write FRemoteName;
    property ModemUserName: String read FModemUserName write FModemUserName;
    property ModemUserPass: String read FModemUserPass write FModemUserPass;
    property ModemDomain: String read FModemDomain write FModemDomain;
    property ModemPhone: String read FModemPhone write FModemPhone;

    property CurrentIncremet: Integer read FCurrentIncremet write FCurrentIncremet;
    property ParentHandle: THandle read FParentHandle write FParentHandle;

    property OnLog: TLogEvent read FOnLog write FOnLog;
    property OnGetDataDesc: TGetDataEvent read FOnGetDataDesc write FOnGetDataDesc;
    property OnSetData: TSetDataEvent read FOnSetData write FOnSetData;
    property OnSuccessData: TNotifyEvent read FOnSuccessData write FOnSuccessData;  
    property OnWorkBegin: TWorkBeginEvent read GetOnWorkBegin write SetOnWorkBegin;
    property OnWork: TWorkEvent read GetOnWork write SetOnWork;
    property OnWorkEnd: TWorkEndEvent read GetOnWorkEnd write SetOnWorkEnd;

  end;

implementation

uses SysUtils, Dialogs, UMainUnited,
     IdException, IdStackConsts,
     StbasisSGlobal;

{ TtsvSyncClient }

constructor TtsvSyncClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCrypter:=TStbasisSCrypter.Create(nil);
  FTCPClient:=TSyncTCPClient.Create(nil);
  FDialer:=TRasDialer.Create;
  FDialer.Mode:=dmSync;
end;

destructor TtsvSyncClient.Destroy;
begin
  FDialer.Free;
  FTCPClient.Free;
  FCrypter.Free;
  inherited;
end;

function TtsvSyncClient.TranslateError(ErrorCode: Integer): String;
begin
  Result := '';    
  case ErrorCode of
    Id_WSAEINTR: Result           := 'Прерванный системный вызов.';
    Id_WSAEBADF: Result           := 'Плохой файловый номер.';
    Id_WSAEACCES: Result          := 'Доступ запрещён.';
    Id_WSAEFAULT: Result          := 'Плохой адрес.';
    Id_WSAEINVAL: Result          := 'Неправильный аргумент.';
    Id_WSAEMFILE: Result          := 'Слишком много открытых файлов.';

    Id_WSAEWOULDBLOCK: Result     := 'Действие должно блокироваться.';
    Id_WSAEINPROGRESS: Result     := 'Действие теперь в процессе развития.';
    Id_WSAEALREADY: Result        := 'Действие уже в процессе развития.';
    Id_WSAENOTSOCK: Result        := 'Действие сокета в не-сокете.';
    Id_WSAEDESTADDRREQ: Result    := 'Требуется адрес назначения.';
    Id_WSAEMSGSIZE: Result        := 'Сообщение слишком длинное.';
    Id_WSAEPROTOTYPE: Result      := 'Неправильный тип протокола для сокета.';
    Id_WSAENOPROTOOPT: Result     := 'Плохой выбор протокола.';
    Id_WSAEPROTONOSUPPORT: Result := 'Протокол не поддерживается.';
    Id_WSAESOCKTNOSUPPORT: Result := 'Тип сокета не поддерживается.';
    Id_WSAEOPNOTSUPP: Result      := 'Действие не поддерживается в сокете.';
    Id_WSAEPFNOSUPPORT: Result    := 'Семейство протокола не поддерживается.';
    Id_WSAEAFNOSUPPORT: Result    := 'Семейство адреса не поддерживается семейством протокола.';
    Id_WSAEADDRINUSE: Result      := 'Адрес уже в используется.';
    Id_WSAEADDRNOTAVAIL: Result   := 'Не могу назначить запрошенный адрес.';
    Id_WSAENETDOWN: Result        := 'Сеть выключена.';
    Id_WSAENETUNREACH: Result     := 'Сеть является нечитабельной.';
    Id_WSAENETRESET: Result       := 'Сеть разорвала связь.';
    Id_WSAECONNABORTED: Result    := 'Программное обеспечение вызывало отказ связи.';
    Id_WSAECONNRESET: Result      := 'Связь была разорвана на другой стороне.';
    Id_WSAENOBUFS: Result         := 'Нет доступного пустого буфера.';
    Id_WSAEISCONN: Result         := 'Сокет уже связан.';
    Id_WSAENOTCONN: Result        := 'Сокет не связан.';
    Id_WSAESHUTDOWN: Result       := 'Не могу отправить или получить после того, как сокет будет закрыт.';
    Id_WSAETOOMANYREFS: Result    := 'Слишком много ссылок, не могу совместить.';
    Id_WSAETIMEDOUT: Result       := 'Время связи вышло.';
    Id_WSAECONNREFUSED: Result    := 'Связь отказала.';
    Id_WSAELOOP: Result           := 'Слишком много уровней символических связей.';
    Id_WSAENAMETOOLONG: Result    := 'Файловое имя слишком длинное.';
    Id_WSAEHOSTDOWN: Result       := 'Хост выключен.';
    Id_WSAEHOSTUNREACH: Result    := 'Нет маршрутов к хосту.';
    Id_WSAENOTEMPTY: Result       := 'Директория не пуста.';
    else begin
      Result:=Format('Ошибка сокета %d.',[ErrorCode]);
    end;
  end;
end;

function TtsvSyncClient.Ping(var Error: String): Boolean;
var
  Pinger: TtsvPinger;
begin
  Pinger:=TtsvPinger.Create(nil);
  try
    Result:=false;
    try
      Result:=Pinger.PingHost(ServerName);
    except
      On E: EIdSocketError do begin
        Error:=TranslateError(E.LastError);
      end;  
    end;
  finally
    Pinger.Free;
  end;
end;

procedure TtsvSyncClient.SetOfficeKey(Value: String);
begin
  FOfficeKey:=Value;
  FOfficeKeyHash:=FCrypter.HashString(Value,haMD5,hfHEX);
end;

function TtsvSyncClient.GetOnWorkBegin: TWorkBeginEvent;
begin
  Result:=FTCPClient.OnWorkBegin;
end;

procedure TtsvSyncClient.SetOnWorkBegin(Value: TWorkBeginEvent);
begin
  FTCPClient.OnWorkBegin:=Value;
end;

function TtsvSyncClient.GetOnWork: TWorkEvent;
begin
  Result:=FTCPClient.OnWork;
end;

procedure TtsvSyncClient.SetOnWork(Value: TWorkEvent);
begin
  FTCPClient.OnWork:=Value;
end;

function TtsvSyncClient.GetOnWorkEnd: TWorkEndEvent;
begin
  Result:=FTCPClient.OnWorkEnd;
end;

procedure TtsvSyncClient.SetOnWorkEnd(Value: TWorkEndEvent);
begin
  FTCPClient.OnWorkEnd:=Value;
end;

procedure TtsvSyncClient.LogWrite(Message: String);
begin
  if Assigned(FOnLog) then
    FOnLog(Trim(Message));
end;

procedure TtsvSyncClient.ConnectToServer;
var
  Error: string;
begin
  LogWrite(Format('Поиск сервера %s ...',[FServerName]));
  if Ping(Error) then
    LogWrite('Поиск сервера завершен успешно')
  else
    LogWrite(Format('Поиск сервера завершен с ошибкой: %s',[Error]));

  LogWrite(Format('Соединение с сервером %s на порт %d ...',[FServerName,FServerPort]));
  try
    FTCPClient.Host:=FServerName;
    FTCPClient.Port:=FServerPort;
    FTCPClient.Connect;
    with FTCPClient.Socket.Binding do begin
      FKeyOutHash:='';
//      FKeyOutHash:=FCrypter.HashString(Format('%s:%d',[PeerIp,PeerPort]),haMD5,hfHEX); не работает через прокси
    end;
    LogWrite('Соединение с сервером прошло успешно');
  except
    On E: Exception do begin
      if E is EIdSocketError then
        Error:=TranslateError(EIdSocketError(E).LastError)
      else Error:=E.Message;
      LogWrite(Format('Соединение с сервером прошло с ошибкой: %s',[Error]));
    end;
  end;
end;

procedure TtsvSyncClient.DisconnectFromServer;
begin
  FTCPClient.Disconnect;
end;

procedure TtsvSyncClient.ConnectDirect;
begin
  LogWrite('Использование прямого соединения ...'); 
  ConnectToServer;
end;

function TtsvSyncClient.GetTypeConnection: TTypeConnection;
var
  Connected: Bool;
  dwFlags: Dword;
begin
  Result:=tcUnknown;
  Connected:=InternetGetConnectedState(@dwFlags,0) and ((dwFlags and INTERNET_CONNECTION_MODEM_BUSY)=0);
  if Connected then begin
    if (dwFlags and INTERNET_CONNECTION_MODEM)=1 then Result:=tcModem;
    if (dwFlags and INTERNET_CONNECTION_LAN)=1 then Result:=tcLan;
    if (dwFlags and INTERNET_CONNECTION_PROXY)=1 then Result:=tcProxy;
  end;
end;

procedure TtsvSyncClient.ConnectRemote;
var
  TypeCon: TTypeConnection;
  InetConnected: Boolean;
  Ret: Dword;
  dwConnection: DWord;
  NewRemoteName: string;
begin
  if FRemoteAuto then
    NewRemoteName:='Авто'
  else
    NewRemoteName:=RemoteName;
  LogWrite(Format('Использование удаленного соединения %s ...',[NewRemoteName]));
  InetConnected:=false;
  TypeCon:=GetTypeConnection;
  Ret:=ERROR_SUCCESS;
  if TypeCon<>tcLan then begin
    if RemoteAuto then begin
      InetConnected:=InternetAutoDial(INTERNET_AUTODIAL_FORCE_UNATTENDED,FParentHandle);
      Ret:=GetLastError;
    end else begin
      Ret:=InternetDial(FParentHandle,PChar(RemoteName),INTERNET_AUTODIAL_FORCE_UNATTENDED,@dwConnection,0);
      if Ret=ERROR_SUCCESS then begin
        FInternetConnection:=dwConnection;
        InetConnected:=true;
      end;
    end;
  end else InetConnected:=true;

  if InetConnected then begin
    LogWrite(Format('Соединение через %s прошло успешно',[NewRemoteName]));
  end else
    LogWrite(Format('Соединение через %s прошло с ошибкой: %s',[NewRemoteName,RasErrorMessage(Ret)]));

  ConnectToServer;
end;

procedure TtsvSyncClient.ConnectModem;
var
  TypeCon: TTypeConnection;
  Ret: Dword;
  InetConnected: Boolean;
begin
  LogWrite(Format('Использование модема, телефон %s ...',[FModemPhone]));
  InetConnected:=false;
  Ret:=ERROR_SUCCESS;
  TypeCon:=GetTypeConnection;
  if TypeCon<>tcLan then begin
    try
      with FDialer do begin
        PhoneNumber:=FModemPhone;
        UserName:=FModemUserName;
        Password:=FModemUserPass;
        Domain:=FModemDomain;
        Dial;
      end;
    except
      On E: EWin32Error do begin
        Ret:=E.ErrorCode;
      end;
    end;
    if Ret=ERROR_SUCCESS then begin
      FInternetConnection:=FDialer.ConnHandle;
      InetConnected:=true;
    end;
  end else InetConnected:=true;

  if InetConnected then begin
    LogWrite(Format('Соединение через модем, телефон %s прошло успешно',[FModemPhone]));
  end else begin
    LogWrite(Format('Соединение через модем, телефон %s прошло с ошибкой: %s',[FModemPhone,RasErrorMessage(Ret)]));
  end;

  ConnectToServer;
end;

procedure TtsvSyncClient.Connect;
begin
  if not FConnected then begin
    LogWrite(RepeatStr('-',60));
    LogWrite(Format('Соединение %s попытка №%d ...',[FDisplayName,FCurrentIncremet]));
    try
      case FConnectionType of
        ctDirect: ConnectDirect;
        ctRemote: ConnectRemote;
        ctModem: ConnectModem;
      end;
      FConnected:=true;
    except
      on E: Exception do begin
      end;
    end;
  end;
end;

procedure TtsvSyncClient.DisconnectDirect;
begin
  DisconnectFromServer;
end;

procedure TtsvSyncClient.DisconnectRemote;
var
  TypeCon: TTypeConnection;
begin
  DisconnectFromServer;
  TypeCon:=GetTypeConnection;
  if TypeCon<>tcLan then begin
    if FRemoteAuto then
      InternetAutodialHangup(0)
    else begin
      InternetHangUp(FInternetConnection,0);
    end;
  end;
end;

procedure TtsvSyncClient.DisconnectModem;
var
  TypeCon: TTypeConnection;
begin
  DisconnectFromServer;
  TypeCon:=GetTypeConnection;
  if TypeCon<>tcLan then begin
    try
      if FDialer.Active then
        FDialer.HangUp;
    except
    end;
  end;
end;

procedure TtsvSyncClient.Disconnect;
begin
  if FConnected then begin
    LogWrite(Format('Разрыв соединения %s ...',[FDisplayName]));
    try
      case FConnectionType of
        ctDirect: DisconnectDirect;
        ctRemote: DisconnectRemote;
        ctModem: DisconnectModem;
      end;
      LogWrite('Разрыв соединения прошел успешно');
      FConnected:=false;
    except
      on E: Exception do begin
        LogWrite(Format('Разрыв соединения прошел с ошибкой: %s',[E.Message]));
      end;
    end;
  end;  
end;

function TtsvSyncClient.Synchronize: Boolean;
var
  Global: TStbasisSGlobal;
  GlobalResult: TStbasisSGlobalResult;

  procedure GlobalClear;
  begin
    FillChar(Global,SizeOf(Global),0);
    FillChar(GlobalResult,SizeOf(GlobalResult),0);
  end;

  procedure CommandInit;
  var
    GlobalInit: TStbasisSGlobalInit;
  begin
    LogWrite(Format('Проверка офиса %s ...',[FOfficeName]));
    GlobalClear;
    FillChar(GlobalInit,SizeOf(GlobalInit),0);
    with FTCPClient do begin
      Global.Command:=gcInit;
      WriteBuffer(Global,SizeOf(Global),true);
      StrPCopy(@GlobalInit.OfficeName,FOfficeName);
      WriteBuffer(GlobalInit,SizeOf(GlobalInit),true);
      ReadBuffer(GlobalResult,SizeOf(GlobalResult));
      if GlobalResult.Code=GLOBAL_RESULT_ERROR then
        raise Exception.Create(GlobalResult.Message);
    end;
  end;

  procedure CommandData;
  var
    GlobalData: TStbasisSGlobalData;
    InStream, OutStream: TMemoryStream;
    Size: Integer;
    RealyKey: String;
    AStreamHash: String;
  begin
    LogWrite('Обмен данными ...');
    GlobalClear;
    FillChar(GlobalData,SizeOf(GlobalData),0);
    with FTCPClient do begin
      Global.Command:=gcData;
      WriteBuffer(Global,SizeOf(Global),true);
      WriteBuffer(GlobalData,SizeOf(GlobalData),true);
      InStream:=TMemoryStream.Create;
      OutStream:=TMemoryStream.Create;
      try

        LogWrite(Format('KeyOutHash: %s',[FKeyOutHash]));
        LogWrite(Format('OfficeKeyHash: %s',[FOfficeKeyHash]));

        LogWrite('Загрузка описаний передаваемых данных ...');
        Size:=ReadInteger;
        ReadStream(InStream,Size,false);
        InStream.Position:=0;
        RealyKey:=Format('%s%s',[FKeyOutHash,FOfficeKeyHash]);
        FCrypter.DecodeStream(RealyKey,InStream,caRC5,cmCTS);
        InStream.Position:=0;
        AStreamHash:=FCrypter.HashStream(InStream,haMD5,hfHEX);
        LogWrite(Format('GetOutDataDesc StreamHash: %s',[AStreamHash]));
        InStream.Position:=0;
        if Assigned(FOnGetDataDesc) then
          FOnGetDataDesc(InStream,OutStream);

        LogWrite('Передача данных на сервер ...');
        OutStream.Position:=0;
        AStreamHash:=FCrypter.HashStream(OutStream,haMD5,hfHEX);
        LogWrite(Format('SetNewData StreamHash: %s',[AStreamHash]));
        OutStream.Position:=0;
        RealyKey:=Format('%s%s',[FKeyOutHash,FOfficeKeyHash]);
        FCrypter.EncodeStream(RealyKey,OutStream,caRC5,cmCTS);
        OutStream.Position:=0;
        OpenWriteBuffer;
        WriteInteger(OutStream.Size);
        WriteStream(OutStream);
        CloseWriteBuffer;

        LogWrite('Получение данных от сервера ...');
        InStream.Clear;
        InStream.Position:=0;
        Size:=ReadInteger;
        ReadStream(InStream,Size,false);
        InStream.Position:=0;
        RealyKey:=Format('%s%s',[FKeyOutHash,FOfficeKeyHash]);
        FCrypter.DecodeStream(RealyKey,InStream,caRC5,cmCTS);
        InStream.Position:=0;
        AStreamHash:=FCrypter.HashStream(InStream,haMD5,hfHEX);
        LogWrite(Format('GetOutData StreamHash: %s',[AStreamHash]));
        InStream.Position:=0;
        if Assigned(FOnSetData) then
          FOnSetData(InStream);

        ReadBuffer(GlobalResult,SizeOf(GlobalResult));
        if GlobalResult.Code=GLOBAL_RESULT_ERROR then
          raise Exception.Create(GlobalResult.Message);

        if GlobalResult.Code=GLOBAL_RESULT_SUCCESS then
          if Assigned(FOnSuccessData) then
            FOnSuccessData(Self); 
      finally
        OutStream.Free;
        InStream.Free;
      end;
    end;
  end;

  procedure CommandDone;
  begin
    GlobalClear;
    with FTCPClient do begin
      Global.Command:=gcDone;
      WriteBuffer(Global,SizeOf(Global),true);
    end;
  end;

var
  Error: String;
begin
  Result:=false;
  if FConnected then begin
    LogWrite('Начало синхронизации ...');
    try
      CommandInit;
      CommandData;
      CommandDone;
      if not FBreak then
        LogWrite('Синхронизация прошла успешно')
      else
        LogWrite('Синхронизация была прервана');
      Result:=true;
    except
      On E: Exception do begin
        if E is EIdSocketError then
          Error:=TranslateError(EIdSocketError(E).LastError)
        else Error:=E.Message;  
        LogWrite(Format('Синхронизация прошла с ошибкой: %s',[Error]));
      end;
    end;
  end;
end;

procedure TtsvSyncClient.Stop;
begin
  FBreak:=true;
end;


end.
