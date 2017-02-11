unit rshMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdTCPClient, IdComponent, IdTCPServer, IdRemoteCMDServer, IdRSHServer;

type
  TForm1 = class(TForm)
    IdRSHServer1: TIdRSHServer;
    procedure IdRSHServer1Command(AThread: TIdPeerThread;
      AStdError: TIdTCPClient; AClientUserName, AHostUserName,
      ACommand: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.IdRSHServer1Command(AThread: TIdPeerThread;
  AStdError: TIdTCPClient; AClientUserName, AHostUserName,
  ACommand: String);
begin
  IdRSHServer1.SendResults(AThread,AStdError,'RSH Demo Program');
end;

end.
