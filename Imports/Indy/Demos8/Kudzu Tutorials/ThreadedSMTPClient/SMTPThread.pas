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

  TSyncSendResult = class
  private
    FCmdResult: string;
    //
    procedure Sync;
  public
    class procedure SendResult(AThread: TIdThread; ACmdResult: string);
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
        TSyncSendResult.SendResult(Self, CmdResult);
      finally Disconnect; end;
      Synchronize(formMain.Disconnected);
    finally Free; end;
  finally LMsg.Free; end;
  Terminate;
end;

{ TSyncSendResult }

class procedure TSyncSendResult.SendResult(AThread: TIdThread; ACmdResult: string);
begin
  with Create do try
    FCmdResult := ACmdResult;
    AThread.Synchronize(Sync);
  finally Free; end;
end;

procedure TSyncSendResult.Sync;
begin
  formMain.Status('Mail accepted ok.');
  formMain.Status('Server said ' + FCmdResult);
end;

end.
