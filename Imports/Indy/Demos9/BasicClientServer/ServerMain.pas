unit ServerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer;

type
  TForm1 = class(TForm)
    TCPServer: TIdTCPServer;
    procedure FormCreate(Sender: TObject);
    procedure TCPServerExecute(AThread: TIdPeerThread);
  private
  public
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  TCPServer.Active := True;
end;

procedure TForm1.TCPServerExecute(AThread: TIdPeerThread);
begin
  with AThread.Connection do
  begin
    WriteLn('Hello from Basic Indy Server server.');
    Disconnect;
  end;
end;

end.
