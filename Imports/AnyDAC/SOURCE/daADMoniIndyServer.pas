{-------------------------------------------------------------------------------}
{ AnyDAC monitor TCP/IP (Indy) based implementation. Server part.               }
{ Copyright (c) 2004-2006 by Dmitry Arefiev (www.da-soft.com)                   }
{                                                                               }
{ All rights reserved.                                                          }
{-------------------------------------------------------------------------------}
{$I daAD.inc}

unit daADMoniIndyServer;

interface

uses
  Classes, Windows, SysUtils,
  IdTCPServer, {$IFDEF AnyDAC_INDY10} IdContext, IdStack, {$ENDIF}
  daADStanIntf, daADStanConst, daADMoniIndyBase;

type
  // server
  TADMoniIndyServerQueueItem = class;
  TADMoniIndyReceiver = class;
  TADMoniIndyServerClientInfo = class;
  TADMoniIndyServer = class;

  TADMoniIndyServerContext = {$IFDEF AnyDAC_INDY10} TIdContext {$ELSE} TIdPeerThread {$ENDIF};

  {----------------------------------------------------------------------------}
  { TADMoniIndyServerQueueItem                                                 }
  {----------------------------------------------------------------------------}
  TADMoniIndyServerQueueItem = class(TADMoniIndyQueueItem)
  public
    FHost: String;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndyReceiver                                                        }
  {----------------------------------------------------------------------------}
  TADMoniIndyReceiver = class(TADMoniIndyQueueWorker)
  private
    FServer: TADMoniIndyServer;
    procedure DoMessage;
  protected
    function GetQueue: TADMoniIndyQueue; override;
    procedure DoAction; override;
  public
    constructor Create(AServer: TADMoniIndyServer);
    destructor Destroy; override;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndyServerClientInfo                                                }
  {----------------------------------------------------------------------------}
  TADMoniIndyServerClientInfo = class (TObject)
  private
    FServer: TADMoniIndyServer;
    FContext: TADMoniIndyServerContext;
    FStream: TADMoniIndyStream;
    FAdapterList: TADMoniIndyAdapterList;
    FProcessID: LongWord;
    FMonitorID: LongWord;
    FVersion: LongWord;
    procedure RemoveAllAdapters;
  public
    constructor Create(AServer: TADMoniIndyServer; AContext: TADMoniIndyServerContext);
    destructor Destroy; override;
    property ProcessID: LongWord read FProcessID write FProcessID;
    property MonitorID: LongWord read FMonitorID write FMonitorID;
    property Version: LongWord read FVersion write FVersion;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniIndyServer                                                          }
  {----------------------------------------------------------------------------}
  TADMoniIndyServerMessageEvent = procedure (Sender: TObject; AMessage: TADMoniIndyQueueItem) of object;
  TADMoniIndyServer = class (TObject)
  private
    FTCPServer: TIdTCPServer;
    FQueue: TADMoniIndyQueue;
    FReceiver: TADMoniIndyReceiver;
    FPackVersion: Integer;
    FSynchronize: TADMoniIndyQueueEventKinds;
    FOnMessage: TADMoniIndyServerMessageEvent;
    procedure DoMessage(AMessage: TADMoniIndyServerQueueItem);
    procedure DoExecute(AContext: TADMoniIndyServerContext);
    function GetClientInfo(AContext: TADMoniIndyServerContext): TADMoniIndyServerClientInfo;
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    function GetPort: Integer;
    procedure SetPort(const AValue: Integer);
    function BuildItem(AClientInfo: TADMoniIndyServerClientInfo): TADMoniIndyServerQueueItem;
  public
    constructor Create;
    destructor Destroy; override;
    property Queue: TADMoniIndyQueue read FQueue;
    property Receiver: TADMoniIndyReceiver read FReceiver;
    property Port: Integer read GetPort write SetPort default C_AD_MonitorPort;
    property Tracing: Boolean read GetTracing write SetTracing default False;
    property Synchronize: TADMoniIndyQueueEventKinds read FSynchronize write FSynchronize default [];
    property OnMessage: TADMoniIndyServerMessageEvent read FOnMessage write FOnMessage;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants,
{$ENDIF}  
  IdException, IdAntiFreezeBase,
  daADStanUtil, daADStanFactory;

{-------------------------------------------------------------------------------}
{ TADMoniIndyReceiver                                                           }
{-------------------------------------------------------------------------------}
constructor TADMoniIndyReceiver.Create(AServer: TADMoniIndyServer);
begin
  inherited Create;
  FServer := AServer;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndyReceiver.Destroy;
begin
  FServer := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyReceiver.GetQueue: TADMoniIndyQueue;
begin
  Result := FServer.FQueue;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyReceiver.DoAction;
begin
  if GetQueue.GetNextEvent in FServer.Synchronize then
    Synchronize(DoMessage)
  else
    DoMessage;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyReceiver.DoMessage;
var
  oItem: TADMoniIndyServerQueueItem;
  i: Integer;
begin
  i := 5;
  repeat
    oItem := TADMoniIndyServerQueueItem(GetQueue.GetItem);
    if oItem <> nil then
      try
        FServer.DoMessage(oItem);
      finally
        oItem.Free;
      end;
    Dec(i);
  until (GetQueue.Count = 0) or (i = 0) or
        not (GetQueue.GetNextEvent in FServer.Synchronize);
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndyServerClientInfo                                                   }
{-------------------------------------------------------------------------------}
constructor TADMoniIndyServerClientInfo.Create(AServer: TADMoniIndyServer;
  AContext: TADMoniIndyServerContext);
begin
  inherited Create;
  FServer := AServer;
  FContext := AContext;
  FAdapterList := TADMoniIndyAdapterList.Create;
  FStream := TADMoniIndyStream.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndyServerClientInfo.Destroy;
begin
  FServer := nil;
  FContext := nil;
  FreeAndNil(FAdapterList);
  FreeAndNil(FStream);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyServerClientInfo.RemoveAllAdapters;
var
  i: Integer;
  oItem: TADMoniIndyServerQueueItem;
begin
  try
    for i := 0 to FAdapterList.Count - 1 do begin
      oItem := FServer.BuildItem(Self);
      oItem.FEvent := ptUnRegisterAdapter;
      oItem.FHandle := FAdapterList.Handles[i];
      oItem.FPath := FAdapterList.Paths[i];
      FServer.FQueue.PostItem(oItem);
    end;
  finally
    FAdapterList.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMoniIndyServer                                                             }
{-------------------------------------------------------------------------------}
constructor TADMoniIndyServer.Create;
begin
  inherited Create;
  FTCPServer := TIdTCPServer.Create(nil);
  FTCPServer.OnExecute := DoExecute;
  FTCPServer.DefaultPort := C_AD_MonitorPort;
  FReceiver := TADMoniIndyReceiver.Create(Self);
  FQueue := TADMoniIndyQueue.Create(FReceiver);
  FPackVersion := C_AD_Mon_PacketVersion;
  FSynchronize := [];
  //FReceiver.PingTime := 1000000;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniIndyServer.Destroy;
begin
  Tracing := False;
  FreeAndNil(FTCPServer);
  FreeAndNil(FReceiver);
  FreeAndNil(FQueue);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyServer.GetTracing: Boolean;
begin
  Result := FTCPServer.Active;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyServer.SetTracing(const AValue: Boolean);
begin
  if Tracing <> AValue then
    if AValue then begin
      FTCPServer.Bindings.Clear;
      FTCPServer.Active := True;
      FReceiver.Resume;
    end
    else begin
      FTCPServer.Active := False;
      while FReceiver.GetQueue.Count > 0 do begin
        if (FReceiver.GetQueue.GetNextEvent in Synchronize) and
           (GAntiFreeze <> nil) and (GetCurrentThreadID = MainThreadID) and GAntiFreeze.Active then
          TIdAntiFreezeBase.DoProcess(False, True)
        else
          Sleep(0);
      end;
      FReceiver.Suspend;
    end;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyServer.GetPort: Integer;
begin
  Result := FTCPServer.DefaultPort;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyServer.SetPort(const AValue: Integer);
begin
  FTCPServer.DefaultPort := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyServer.BuildItem(AClientInfo: TADMoniIndyServerClientInfo): TADMoniIndyServerQueueItem;
begin
  Result := TADMoniIndyServerQueueItem.Create;
{$IFDEF AnyDAC_INDY10}
  if (AClientInfo.FContext.Connection.Socket <> nil) and
     (AClientInfo.FContext.Connection.Socket.Binding <> nil) then
    Result.FHost := AClientInfo.FContext.Connection.Socket.Binding.IP;
{$ENDIF}
{$IFDEF AnyDAC_INDY9}
  if not AClientInfo.FContext.Terminated then
    Result.FHost := AClientInfo.FContext.Connection.Socket.Binding.IP;
{$ENDIF}
{$IFDEF AnyDAC_INDY8}
  if not AClientInfo.FContext.Terminated then
    Result.FHost := AClientInfo.FContext.Connection.Binding.IP;
{$ENDIF}
  Result.FProcessID := AClientInfo.FProcessID;
  Result.FMonitorID := AClientInfo.FMonitorID;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyServer.DoExecute(AContext: TADMoniIndyServerContext);
var
  oItem: TADMoniIndyServerQueueItem;
  oStream: TADMoniIndyStream;
  oClientInfo: TADMoniIndyServerClientInfo;
begin
  oClientInfo := GetClientInfo(AContext);
  oItem := BuildItem(oClientInfo);
  oStream := oClientInfo.FStream;
  try
    oStream.Open(AContext.Connection, omRead);
    try
      oItem.FEvent := TADMoniIndyQueueEventKind(oStream.ReadInteger(S_AD_MsgEvent));
      oStream.ReadBeginBlock(C_AD_Mon_PacketBodyBlockID);
      case oItem.FEvent of
        ptConnectClient:
          begin
            oClientInfo.FProcessID := oStream.ReadInteger(S_AD_MsgProcessId);
            oClientInfo.FMonitorID := oStream.ReadInteger(S_AD_MsgMonitorId);
            oClientInfo.FVersion := oStream.ReadInteger(S_AD_MsgVersion);
            oItem.FProcessID := oClientInfo.FProcessID;
            oItem.FMonitorID := oClientInfo.FMonitorID;
            oItem.FTime := oStream.ReadInteger(S_AD_MsgTime);
            oItem.FMessage := oStream.ReadString(S_AD_MsgText);
          end;
        ptDisConnectClient:
          begin
            oStream.ReadInteger(S_AD_MsgProcessId);
            oStream.ReadInteger(S_AD_MsgMonitorId);
            oStream.ReadInteger(S_AD_MsgTime);
            oClientInfo.RemoveAllAdapters;
{$IFDEF AnyDAC_INDY10}
            AContext.Connection.Disconnect;
{$ELSE}
            AContext.Stop;
{$ENDIF}
          end;
        ptRegisterAdapter:
          begin
            oItem.FHandle := oStream.ReadInteger(S_AD_MsgAdapterHandle);
            oItem.FPath := oStream.ReadString(S_AD_MsgText);
            oClientInfo.FAdapterList.AddAdapter(oItem.FPath, oItem.FHandle);
          end;
        ptUnRegisterAdapter:
          begin
            oItem.FHandle := oStream.ReadInteger(S_AD_MsgAdapterHandle);
            oItem.FPath := oClientInfo.FAdapterList.FindByHandle(oItem.FHandle);
            oClientInfo.FAdapterList.RemoveAdapter(oItem.FHandle);
          end;
        ptUpdateAdapter:
          begin
            oItem.FHandle := oStream.ReadInteger(S_AD_MsgAdapterHandle);
            oStream.ReadBlob(S_AD_MsgArgs, oItem.FArgs);
          end;
        ptNotify:
          begin
            oItem.FHandle := oStream.ReadInteger(S_AD_MsgAdapterHandle);
            if oItem.FHandle > 0 then
              oItem.FPath := oClientInfo.FAdapterList.FindByHandle(oItem.FHandle);
            oItem.FKind := TADMoniEventKind(oStream.ReadInteger(S_AD_MsgNotifyKind));
            oItem.FStep := TADMoniEventStep(oStream.ReadInteger(S_AD_MsgNotifyStep));
            oItem.FTime := oStream.ReadInteger(S_AD_MsgTime);
            oItem.FMessage := oStream.ReadString(S_AD_MsgText);
            oStream.ReadBlob(S_AD_MsgArgs, oItem.FArgs);
          end;
      end;
      oStream.ReadEndBlock;
      FQueue.PostItem(oItem);
    finally
      oStream.Close;
    end;
  except
    on E: Exception do begin
{$IFDEF AnyDAC_INDY10}
      AContext.Connection.Disconnect;
{$ELSE}
      AContext.Stop;
{$ENDIF}
      if (E is EIdSocketError) and (EIdSocketError(E).LastError = 10054) then begin
        // if "connection reset by peer"
        oItem.FEvent := ptDisConnectClient;
        FQueue.PostItem(oItem);
      end
      else begin
        oItem.Free;
        raise;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniIndyServer.DoMessage(AMessage: TADMoniIndyServerQueueItem);
begin
  if Assigned(FOnMessage) then
    FOnMessage(Self, AMessage);
end;

{-------------------------------------------------------------------------------}
function TADMoniIndyServer.GetClientInfo(AContext: TADMoniIndyServerContext): TADMoniIndyServerClientInfo;
begin
  if AContext.Data <> nil then
    Result := TADMoniIndyServerClientInfo(AContext.Data)
  else begin
    Result := TADMoniIndyServerClientInfo.Create(Self, AContext);
    AContext.Data := Result;
  end;
end;

end.
