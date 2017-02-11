unit SMTPThread;

interface

uses
  IdThread;

type
  TSMTPThread = class(TIdThread)
  public
    FFrom: string;
    FMessage: string;
    FRecipient: string;
    FSMTPServer: string;
    FSubject: string;
    //
    procedure Run; override;
  end;

implementation

uses
  IdMessage, IdSMTP;

{ TSMTPThread }

procedure TSMTPThread.Run;
var
  LMsg: TIdMessage;
begin
  LMsg := TIdMessage.Create(nil); try
    with LMsg do begin
      From.Address := FFrom;
      Recipients.Add.Address := FRecipient;
      Subject := FSubject;
      Body.Text := FMessage;
    end;
    with TIdSMTP.Create(nil) do try
      Host := FSMTPServer;
      Connect; try
        Send(LMsg);
      finally Disconnect; end;
    finally Free; end;
  finally LMsg.Free; end;
  Stop;
end;

end.
