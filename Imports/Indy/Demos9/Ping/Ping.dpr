program ping;

{$APPTYPE CONSOLE}

uses
  IdGlobal,
  SysUtils,
  IdIcmpClient;

type
  TIdPing = class(TIdIcmpClient)
    procedure Reply(const ReplyStatus: TReplyStatus);
  end;

procedure TIdPing.Reply(const ReplyStatus: TReplyStatus);
var
  sTime: string;
begin
  if ReplyStatus.MsRoundTripTime = 0 then begin
    sTime := '<1'
  end else begin
    sTime := '=';
  end;

  WriteLn(Format('%d bytes from %s: icmp_seq=%d ttl=%d time%s%d ms',
   [ReplyStatus.BytesReceived, ReplyStatus.FromIpAddress, ReplyStatus.SequenceId
   , ReplyStatus.TimeToLive, sTime, ReplyStatus.MsRoundTripTime]));
end;

procedure Main;
var
  i: integer;
begin
  if ParamCount < 1 then begin
    writeln('Usage: ping [hostname]');
  end else begin
    with TIdPing.Create(nil) do try
      Host := ParamStr(1);
      OnReply := Reply;
      for i := 1 to 4 do begin
        Ping;
        Sleep(1000);
      end;
    finally Free; end;
  end;
end;

begin
  Main;
end.
