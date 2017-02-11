unit ClientThread;

interface

uses
  Classes, IdBaseComponent, IdException, IdComponent, IdTCPConnection,
  IdTCPClient, sysutils, Windows;

type
  TClientThread = class(TThread)
  private
    { Private declarations }
  idClient : TidTCPClient;
    FPort: integer;
    FServerIP: String;
    fStartTime,
    FRoundTripTime: integer;
    FStatus: String;
    FKill: Boolean;
    FOwner: TComponent;
    FThreadID: Integer;
    FSendString: String;
    procedure SetfPort(const Value: integer);
    procedure SetServerIP(const Value: String);
    procedure SetRoundTripTime(const Value: integer);
    procedure SetStatus(const Value: String);
    procedure SetKill(const Value: Boolean);
    procedure SetThreadID(const Value: Integer);
    procedure SetSendString(const Value: String);
  protected
    procedure Execute; override;
  Published
  Property ThreadID : Integer read FThreadID write SetThreadID;
  Property Kill :Boolean read FKill write SetKill;
  Property ServerIP : String read FServerIP write SetServerIP;
  Property Status : String read FStatus write SetStatus;
  Property Port : integer read FPort write SetfPort;
  Property RoundTripTime : integer read FRoundTripTime write SetRoundTripTime;
  Property SendString : String read FSendString write SetSendString;
  end;

implementation
{We include IdGlobal because Delphi 4 does not have FreeAndNil.  For D4
IdGlobal has an IFDEF'ed FreeAndNil procedure that is compiled if Delphi 4 is
used.}
uses IdGlobal;
{ TClientThread }

procedure TClientThread.Execute;
var
  s,r : string;
  i : integer;
begin
FKill := false;
RandSeed := GetTickCount;

try
idClient := TIdTCPClient.Create(nil);
try
with idClient do
  begin
  Host := FServerIP;
  Port := FPort;
  while FKill = false do
    begin
      try
      if not connected then Connect;

      fStartTime := GetTickCount;
      s := IntToStr(fStartTime);
      FStatus := 'Sending: ' + s;
      WriteLn(s);
      r := ReadLn;
      FStatus := 'Received: ' + r;
      RoundTripTime := (GetTickCount - fStartTime);
      if s <> r then FStatus := r
      else FStatus := 'OK';
      i := random(1000);
      FSendString := IntToStr(i) + #32 + s;
      Sleep(i); // required so we dont take 100% CPU time

      except
        on EidSocketError do
          begin
          fStatus := 'Connection refused';
          fKill := false;
          end;
      end;
    end;
  Disconnect;
  end;

except
on e : exception do
FStatus := E.Message;
end;

finally
if assigned(idClient) then FreeAndNil(idClient);
end;
end;

procedure TClientThread.SetfPort(const Value: integer);
begin
  FPort := Value;
end;

procedure TClientThread.SetKill(const Value: Boolean);
begin
  FKill := Value;
end;


procedure TClientThread.SetRoundTripTime(const Value: integer);
begin
  FRoundTripTime := Value;
end;

procedure TClientThread.SetSendString(const Value: String);
begin
  FSendString := Value;
end;

procedure TClientThread.SetServerIP(const Value: String);
begin
  FServerIP := Value;
end;

procedure TClientThread.SetStatus(const Value: String);
begin
  FStatus := Value;
end;

procedure TClientThread.SetThreadID(const Value: Integer);
begin
  FThreadID := Value;
end;

end.
