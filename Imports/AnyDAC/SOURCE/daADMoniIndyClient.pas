{-------------------------------------------------------------------------------}
{ AnyDAC monitor TCP/IP (Indy) based implementation. Client part.               }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADMoniIndyClient;

interface

uses
  Classes,
  daADStanIntf, daADStanConst,
  daADMoniBase;

{$IFDEF AnyDAC_MONITOR}
type
  {----------------------------------------------------------------------------}
  { TADMoniIndyClientLink                                                      }
  {----------------------------------------------------------------------------}
  TADMoniIndyClientLink = class(TADMoniClientLinkBase)
  private
    FRemoteClient: IADMoniRemoteClient;
    function IsHS: Boolean;
    function GetHost: String;
    procedure SetHost(const AValue: String);
    function GetPort: Integer;
    procedure SetPort(const AValue: Integer);
    function GetTimeout: Integer;
    procedure SetTimeout(const AValue: Integer);
  protected
    function GetMoniClient: IADMoniClient; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property RemoteClient: IADMoniRemoteClient read FRemoteClient;
  published
    property Host: String read GetHost write SetHost stored IsHS;
    property Port: Integer read GetPort write SetPort default C_AD_MonitorPort;
    property Timeout: Integer read GetTimeout write SetTimeout default C_AD_MonitorTimeout;
  end;
{$ENDIF}

implementation

{$IFDEF AnyDAC_MONITOR}
uses
  Windows, SysUtils,
{$IFDEF AnyDAC_D6}
    Variants,
{$ENDIF}
  IdTCPConnection, IdTCPClient, IdSocketHandle, IdException, IdStackConsts,
{$IFDEF AnyDAC_INDY8}
    IdWinSock,
{$ELSE}
    IdIOHandlerSocket, IdWinSock2,
{$ENDIF}
  daADMoniIndyBase, daADStanFactory;

type
  // client
  TADMoniIndyClientQueueItem = class;
  TADMoniIndyClientAdapterList = class;
  TADMoniIndySender = class;
  TADMoniIndyClient = class;

  {----------------------------------------------------------------------------}
  { TADMoniIndyClientQueueItem                                                 }
  {----------------------------------------------------------------------------}
  TADMoniIndyClientQueueItem = class(TADMoniIndyQueueItem)
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndyClientAdapterList                                               }
  {----------------------------------------------------------------------------}
  TADMoniIndyClientAdapterList = class(TADMoniIndyAdapterList)
  private
    FNextHandle: LongWord;
  public
    function GetUniqueHandle: LongWord;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndySender                                                          }
  {----------------------------------------------------------------------------}
  TADMoniIndySender = class(TADMoniIndyQueueWorker)
  private
    FTCPClient: TIdTCPClient;
    FStream: TADMoniIndyStream;
    FClient: TADMoniIndyClient;
    FTimeout: Integer;
    function GetHost: String;
    function GetPort: Integer;
    procedure SetHost(const AValue: String);
    procedure SetPort(const AValue: Integer);
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    function IsMonitorRunning: Boolean;
  protected
    function GetQueue: TADMoniIndyQueue; override;
    procedure DoAction; override;
  public
    constructor Create(AClient: TADMoniIndyClient);
    destructor Destroy; override;
    property Port: Integer read GetPort write SetPort default C_AD_MonitorPort;
    property Host: String read GetHost write SetHost;
    property Timeout: Integer read FTimeout write FTimeout default C_AD_MonitorTimeout;
    property Tracing: Boolean read GetTracing write SetTracing default False;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndyClient                                                          }
  {----------------------------------------------------------------------------}
  TADMoniIndyClient = class (TADMoniClientBase, IADMoniRemoteClient)
  private
    FSender: TADMoniIndySender;
    FQueue: TADMoniIndyQueue;
    FAdapterList: TADMoniIndyClientAdapterList;
    FPackVersion: Integer;
    FProcessID: LongWord;
    FMonitorID: LongWord;
    FDestroying: Boolean;
    function BuildItem(AEventKind: TADMoniIndyQueueEventKind): TADMoniIndyClientQueueItem;
    procedure DoDisconnected(ASender: TObject);
  protected
    // IADMoniClient
    procedure SetupFromDefinition(const AParams: IADStanDefinition); override;
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const); override;
    function RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord; override;
    procedure UnregisterAdapter(const AAdapter: IADMoniAdapter); override;
    procedure AdapterChanged(const AAdapter: IADMoniAdapter); override;
    // IADMoniRemoteClient
    function GetHost: String;
    procedure SetHost(const AValue: String);
    function GetPort: Integer;
    procedure SetPort(const AValue: Integer);
    function GetTimeout: Integer;
    procedure SetTimeout(const AValue: Integer);
    // other
    function DoTracingChanged: Boolean; override;
    function OperationAllowed: Boolean; override;
  public
    procedure Initialize; override;
    destructor Destroy; override;
    property Sender: TADMoniIndySender read FSender;
  end;

var
  FClients: TList;

{-------------------------------------------------------------------------------}
{ TADMoniIndyClientAdapterList                                                  }
{-------------------------------------------------------------------------------}
function TADMoniIndyClientAdapterList.GetUniqueHandle: LongWord;
begin
  Inc(FNextHandle);
  Result := FNextHandle;
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndySender                                                             }
{-------------------------------------------------------------------------------}
constructor TADMoniIndySender.Create(AClient: TADMoniIndyClient);
begin
  inherited Create;
  FClient := AClient;
  FStream := TADMoniIndyStream.Create;
  FTCPClient := TIdTCPClient.Create(nil);
  FTCPClient.Host := '127.0.0.1';
  FTCPClient.Port := C_AD_MonitorPort;
  FTimeout := C_AD_MonitorTimeout;
  Priority := tpHighest;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndySender.Destroy;
begin
  Tracing := False;
  Sleep(0);
  FreeAndNil(FTCPClient);
  FreeAndNil(FStream);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndySender.GetTracing: Boolean;
begin
  Result := FTCPClient.Connected;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_INDY8}
function TADMoniIndySender.IsMonitorRunning: Boolean;
var
  iSock: Integer;
  rAddr: sockaddr_in;
  prHost: PHostEnt;
  pCh: PChar;
begin
  Result := False;
  try
    iSock := socket(Id_PF_INET, Id_SOCK_STREAM, Id_IPPROTO_IP);
    if iSock <> INVALID_SOCKET then begin
      rAddr.sin_family := Id_PF_INET;
      rAddr.sin_addr.s_addr := INADDR_ANY;
      rAddr.sin_port := 0;
      if bind(iSock, rAddr, SizeOf(rAddr)) <> SOCKET_ERROR then begin
        rAddr.sin_family := Id_PF_INET;
        prHost := gethostbyname(PChar(FTCPClient.Host));
        if prHost <> nil then begin
          pCh := prHost^.h_addr_list^;
          rAddr.sin_addr.S_un_b.s_b1 := pCh[0];
          rAddr.sin_addr.S_un_b.s_b2 := pCh[1];
          rAddr.sin_addr.S_un_b.s_b3 := pCh[2];
          rAddr.sin_addr.S_un_b.s_b4 := pCh[3];
          rAddr.sin_port := htons(FTCPClient.Port);
          if connect(iSock, rAddr, SizeOf(rAddr)) <> SOCKET_ERROR then
            Result := True;
        end;
      end;
      shutdown(iSock, 1);
{$IFDEF MSWINDOWS}
      closesocket(iSock);
{$ELSE}
  {$IFDEF LINUX}
      Libc.__close(iSock);
  {$ENDIF}
{$ENDIF}
    end;
  except
    // no exceptions visible
  end;
end;

{$ELSE}

function TADMoniIndySender.IsMonitorRunning: Boolean;
var
  iSock: TSocket;
  rAddr: TSockAddrIn;
  prHost: PHostEnt;
  pCh: PChar;
begin
  Result := False;
  try
    iSock := socket({$IFDEF AnyDAC_INDY9} Id_PF_INET {$ELSE} Id_PF_INET4 {$ENDIF},
      Id_SOCK_STREAM, Id_IPPROTO_IP);
    if iSock <> INVALID_SOCKET then begin
      rAddr.sin_family := {$IFDEF AnyDAC_INDY9} Id_PF_INET {$ELSE} Id_PF_INET4 {$ENDIF};
      rAddr.sin_addr.s_addr := INADDR_ANY;
      rAddr.sin_port := 0;
      if bind(iSock, @rAddr, SizeOf(rAddr)) <> SOCKET_ERROR then begin
        rAddr.sin_family := {$IFDEF AnyDAC_INDY9} Id_PF_INET {$ELSE} Id_PF_INET4 {$ENDIF};
        prHost := gethostbyname(PChar(FTCPClient.Host));
        if prHost <> nil then begin
          pCh := prHost^.h_address_list^;
          rAddr.sin_addr.S_un_b.s_b1 := Ord(pCh[0]);
          rAddr.sin_addr.S_un_b.s_b2 := Ord(pCh[1]);
          rAddr.sin_addr.S_un_b.s_b3 := Ord(pCh[2]);
          rAddr.sin_addr.S_un_b.s_b4 := Ord(pCh[3]);
          rAddr.sin_port := htons(FTCPClient.Port);
          if connect(iSock, @rAddr, SizeOf(rAddr)) <> SOCKET_ERROR then
            Result := True;
        end;
      end;
      shutdown(iSock, Id_SD_Both);
{$IFDEF MSWINDOWS}
      closesocket(iSock);
{$ELSE}
  {$IFDEF LINUX}
      Libc.__close(iSock);
  {$ENDIF}
{$ENDIF}
    end;
  except
    // no exceptions visible
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADMoniIndySender.SetTracing(const AValue: Boolean);
begin
  if Tracing <> AValue then
    if AValue then begin
      if IsMonitorRunning then begin
{$IFDEF AnyDAC_INDY10}
        FTCPClient.ConnectTimeout := FTimeout;
        FTCPClient.Connect;
{$ENDIF}
{$IFDEF AnyDAC_INDY9}
        FTCPClient.Connect(FTimeout);
{$ENDIF}
{$IFDEF AnyDAC_INDY8}
        FTCPClient.Connect;
{$ENDIF}
      end
    end
    else
      try
        FTCPClient.Disconnect;
      except
        // no exceptions visible
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndySender.DoAction;
var
  oItem: TADMoniIndyClientQueueItem;
begin
  oItem := TADMoniIndyClientQueueItem(GetQueue.GetItem);
  if oItem <> nil then
  try
    FStream.Open(FTCPClient, omWrite);
    try
      FStream.WriteInteger(S_AD_MsgEvent, Integer(oItem.FEvent));
      FStream.WriteBeginBlock(C_AD_Mon_PacketBodyBlockID);
      case oItem.FEvent of
        ptConnectClient:
          begin
            FStream.WriteInteger(S_AD_MsgProcessId, oItem.FProcessID);
            FStream.WriteInteger(S_AD_MsgMonitorId, oItem.FMonitorID);
            FStream.WriteInteger(S_AD_MsgVersion, FClient.FPackVersion);
            FStream.WriteInteger(S_AD_MsgTime, oItem.FTime);
            FStream.WriteString(S_AD_MsgText, oItem.FMessage);
          end;
        ptDisConnectClient:
          begin
            FStream.WriteInteger(S_AD_MsgProcessId, oItem.FProcessID);
            FStream.WriteInteger(S_AD_MsgMonitorId, oItem.FMonitorID);
            FStream.WriteInteger(S_AD_MsgTime, oItem.FTime);
          end;
        ptRegisterAdapter:
          begin
            FStream.WriteInteger(S_AD_MsgAdapterHandle, oItem.FHandle);
            FStream.WriteString(S_AD_MsgText, oItem.FPath);
          end;
        ptUnRegisterAdapter:
          FStream.WriteInteger(S_AD_MsgAdapterHandle, oItem.FHandle);
        ptUpdateAdapter:
          begin
            FStream.WriteInteger(S_AD_MsgAdapterHandle, oItem.FHandle);
            FStream.WriteBlob(S_AD_MsgArgs, oItem.FArgs);
          end;
        ptNotify:
          begin
            FStream.WriteInteger(S_AD_MsgAdapterHandle, oItem.FHandle);
            FStream.WriteInteger(S_AD_MsgNotifyKind, Integer(oItem.FKind));
            FStream.WriteInteger(S_AD_MsgNotifyStep, Integer(oItem.FStep));
            FStream.WriteInteger(S_AD_MsgTime, oItem.FTime);
            FStream.WriteString(S_AD_MsgText, oItem.FMessage);
            FStream.WriteBlob(S_AD_MsgArgs, oItem.FArgs);
          end;
      end;
      FStream.WriteEndBlock;
    finally
      try
        FStream.Close;
      except
        if not FTCPClient.Connected then
          FClient.SetTracing(False);
        raise;
      end;
    end;
  finally
    oItem.Free;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndySender.GetQueue: TADMoniIndyQueue;
begin
  Result := FClient.FQueue;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndySender.GetHost: String;
begin
  Result := FTCPClient.Host;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndySender.SetHost(const AValue: String);
begin
  FTCPClient.Host := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndySender.GetPort: Integer;
begin
  Result := FTCPClient.Port;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndySender.SetPort(const AValue: Integer);
begin
  FTCPClient.Port := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndyClient                                                             }
{-------------------------------------------------------------------------------}
var
  ADMonitorLastID: Integer = 0;

procedure TADMoniIndyClient.Initialize;
begin
  inherited Initialize;
  FSender := TADMoniIndySender.Create(Self);
  FSender.FTCPClient.OnDisconnected := DoDisconnected;
  FSender.Host := '127.0.0.1';
  FSender.Port := C_AD_MonitorPort;
  FSender.Timeout := C_AD_MonitorTimeout;
  FQueue := TADMoniIndyQueue.Create(FSender);
  FAdapterList := TADMoniIndyClientAdapterList.Create;
  FPackVersion := C_AD_Mon_PacketVersion;
  FProcessID := GetCurrentProcessId;
  FMonitorID := InterlockedIncrement(ADMonitorLastID);
  if FClients <> nil then
    FClients.Add(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndyClient.Destroy;
begin
  if FClients <> nil then
    FClients.Remove(Self);
  FDestroying := True;
  SetTracing(False);
  FreeAndNil(FQueue);
  FreeAndNil(FSender);
  FreeAndNil(FAdapterList);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClient.SetupFromDefinition(const AParams: IADStanDefinition);
var
  i: Integer;
begin
  ASSERT(AParams <> nil);
  if AParams.HasValue(S_AD_MoniIndyHost) then
    FSender.Host := AParams.AsString[S_AD_MoniIndyHost];
  if AParams.HasValue(S_AD_MoniIndyPort) then
    FSender.Port := AParams.AsInteger[S_AD_MoniIndyPort];
  if AParams.HasValue(S_AD_MoniIndyTimeout) then
    FSender.Timeout := AParams.AsInteger[S_AD_MoniIndyTimeout];
  if AParams.HasValue(S_AD_MoniCategories) then begin
    i := AParams.AsInteger[S_AD_MoniCategories];
    SetEventKinds(PADMoniEventKinds(@i)^ * [ekLiveCycle .. ekVendor]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClient.DoDisconnected(ASender: TObject);
begin
  SetTracing(False);
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClient.BuildItem(AEventKind: TADMoniIndyQueueEventKind): TADMoniIndyClientQueueItem;
begin
  Result := TADMoniIndyClientQueueItem.Create;
  Result.FProcessID := FProcessID;
  Result.FMonitorID := FMonitorID;
  Result.FEvent := AEventKind;
  Result.FTime := GetTickCount();
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClient.DoTracingChanged: Boolean;
var
  oItem: TADMoniIndyClientQueueItem;
  i: Integer;
begin
  Result := True;
  if GetTracing then begin
    FSender.Resume;
    FSender.Tracing := True;
    if FSender.Tracing then begin
      oItem := BuildItem(ptConnectClient);
      oItem.FMessage := ParamStr(0) + ';' + GetName;
      FQueue.PostItem(oItem);
    end
    else begin
      Result := False;
      FSender.Suspend;
    end;
  end
  else begin
    FQueue.Clear;
    if FSender.Tracing then begin
      oItem := BuildItem(ptDisConnectClient);
      FQueue.PostItem(oItem);
      for i := 1 to 10 do begin
        if FQueue.Count = 0 then
          Break;
        Sleep(0);
      end;
    end;
    FAdapterList.Clear;
    FSender.Tracing := False;
    if not FDestroying then
      FSender.Suspend;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClient.OperationAllowed: Boolean;
begin
  Result := (FClients <> nil);
end;

{-------------------------------------------------------------------------------}
type
  __TInterfacedObject = class(TInterfacedObject)
  end;

procedure TADMoniIndyClient.Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
  ASender: TObject; const AMsg: String; const AArgs: array of const);
var
  oItem: TADMoniIndyClientQueueItem;
  hHandle: LongWord;
  oMAIntf: IADMoniAdapter;
  iRefCount: Integer;
begin
  if GetTracing and (AKind in GetEventKinds) then begin
    hHandle := 0;
    if (ASender <> nil) and (ASender is TInterfacedObject) then begin
      iRefCount := __TInterfacedObject(ASender).FRefCount;
      __TInterfacedObject(ASender).FRefCount := 2;
      try
        if Supports(ASender, IADMoniAdapter, oMAIntf) then begin
          hHandle := oMAIntf.GetHandle;
          oMAIntf := nil;
        end;
      finally
        __TInterfacedObject(ASender).FRefCount := iRefCount;
      end;
    end;
    oItem := BuildItem(ptNotify);
    oItem.FKind := AKind;
    oItem.FStep := AStep;
    oItem.FHandle := hHandle;
    oItem.FMessage := AMsg;
    oItem.SetArgs(AArgs);
    FQueue.PostItem(oItem);
    if GetOutputHandler <> nil then
      GetOutputHandler.HandleOutput('', '', AMsg); // ???
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClient.RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord;
var
  oItem: TADMoniIndyClientQueueItem;
  sPath: string;
  oObj: IADStanObject;
begin
  if GetTracing then begin
    oObj := AAdapter as IADStanObject;
    sPath := '';
    repeat
      if sPath <> '' then
        sPath := '.' + sPath;
      sPath := oObj.Name + sPath;
      oObj := oObj.Parent;
    until oObj = nil;
    Result := FAdapterList.FindByPath(sPath);
    if Result = 0 then begin
      Result := FAdapterList.GetUniqueHandle;
      oItem := BuildItem(ptRegisterAdapter);
      oItem.FPath := sPath;
      oItem.FHandle := Result;
      FQueue.PostItem(oItem);
    end;
  end
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClient.UnRegisterAdapter(const AAdapter: IADMoniAdapter);
var
  oItem: TADMoniIndyClientQueueItem;
  hHandle: LongWord;
begin
  if GetTracing then begin
    hHandle := AAdapter.GetHandle;
    if hHandle <> 0 then begin
      FAdapterList.RemoveAdapter(hHandle);
      oItem := BuildItem(ptUnRegisterAdapter);
      oItem.FHandle := hHandle;
      FQueue.PostItem(oItem);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClient.AdapterChanged(const AAdapter: IADMoniAdapter);
var
  oItem: TADMoniIndyClientQueueItem;
  hHandle: LongWord;
  V: Variant;
  i: Integer;
  sName: String;
  vValue: Variant;
  eKind: TADDebugMonitorAdapterItemKind;
begin
  if GetTracing then begin
    hHandle := AAdapter.GetHandle;
    if hHandle <> 0 then begin
      oItem := BuildItem(ptUpdateAdapter);
      oItem.FHandle := hHandle;
      V := VarArrayCreate([0, AAdapter.ItemCount * 3 - 1], varVariant);
      for i := 0 to AAdapter.ItemCount - 1 do begin
        AAdapter.GetItem(i, sName, vValue, eKind);
        V[i * 3 + 0] := sName;
        V[i * 3 + 1] := vValue;
        V[i * 3 + 2] := Byte(eKind);
      end;
      oItem.SetArgs(V);
      FQueue.PostItem(oItem);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClient.GetHost: String;
begin
  Result := FSender.Host;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClient.SetHost(const AValue: String);
begin
  FSender.Host := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClient.GetPort: Integer;
begin
  Result := FSender.Port;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClient.SetPort(const AValue: Integer);
begin
  FSender.Port := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClient.GetTimeout: Integer;
begin
  Result := FSender.Timeout;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClient.SetTimeout(const AValue: Integer);
begin
  FSender.Timeout := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndyClientLink                                                         }
{-------------------------------------------------------------------------------}
constructor TADMoniIndyClientLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRemoteClient := MoniClient as IADMoniRemoteClient;
  Host := '127.0.0.1';
  Port := C_AD_MonitorPort;
  Timeout := C_AD_MonitorTimeout;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndyClientLink.Destroy;
begin
  FRemoteClient := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClientLink.GetMoniClient: IADMoniClient;
var
  oRemClient: IADMoniRemoteClient;
begin
  ADCreateInterface(IADMoniRemoteClient, oRemClient);
  Result := oRemClient as IADMoniClient;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClientLink.GetHost: String;
begin
  Result := RemoteClient.Host;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClientLink.SetHost(const AValue: String);
begin
  RemoteClient.Host := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClientLink.IsHS: Boolean;
begin
  Result := ADMoniIndyIsLocalHost(GetHost);
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClientLink.GetPort: Integer;
begin
  Result := RemoteClient.Port;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClientLink.SetPort(const AValue: Integer);
begin
  RemoteClient.Port := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyClientLink.GetTimeout: Integer;
begin
  Result := RemoteClient.Timeout;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyClientLink.SetTimeout(const AValue: Integer);
begin
  RemoteClient.Timeout := AValue;
end;

{-------------------------------------------------------------------------------}
procedure StopAllClients;
var
  i: Integer;
begin
  for i := 0 to FClients.Count - 1 do
    with TADMoniIndyClient(FClients[i]) do begin
      FDestroying := True;
      SetTracing(False);
    end;
end;

initialization
  FClients := TList.Create;
  TADSingletonFactory.Create(TADMoniIndyClient, IADMoniRemoteClient);

finalization
  StopAllClients;
  FreeAndNil(FClients);
{$ENDIF}

end.
