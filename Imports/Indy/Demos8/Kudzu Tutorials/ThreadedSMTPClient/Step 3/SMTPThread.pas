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
    FCmdResult: string;
    //
    procedure Run; override;
    procedure Status;
  end;

implementation

uses
  IdMessage, IdSMTP,
  Main;

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
        Synchronize(formMain.Connected);
        Send(LMsg);
        FCmdResult := CmdResult;
        Synchronize(Status);
      finally Disconnect; end;
      Synchronize(formMain.Disconnected);
    finally Free; end;
  finally LMsg.Free; end;
  Terminate;
end;

procedure TSMTPThread.Status;
begin
  formMain.Status('Mail accepted ok.');
  formMain.Status('Server said ' + FCmdResult);
end;

end.
