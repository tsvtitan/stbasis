unit tsvPinger;

interface

uses Classes,

     IdIcmpClient;

type

  TtsvIdIcmpClient=class(TIdIcmpClient)
  end;

  TtsvPinger=class(TtsvIdIcmpClient)
  public
    function PingHost(const AHostName: string): Boolean;
  end;

implementation

uses StbasisSUtils;

{ TtsvPinger }

function TtsvPinger.PingHost(const AHostName: string): Boolean;
begin
  Host:=AHostName;
  Ping(CreateUniqueId);
  Result:=ReplyStatus.ReplyStatusType=rsEcho;
end;

end.
