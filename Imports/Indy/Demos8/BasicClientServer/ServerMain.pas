{***************************************************************
 *
 * Project  : Server
 * Unit Name: ServerMain
 * Purpose  : Demonstrates basic use of IdTCPServer
 * Date     : 16/01/2001  -  03:19:36
 * History  :
 *
 ****************************************************************}

unit ServerMain;

interface

uses
  SysUtils, Classes,
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QDialogs,
  {$ELSE}
  Graphics, Controls, Forms, Dialogs,
  {$ENDIF}
  IdBaseComponent, IdComponent, IdTCPServer, StdCtrls;

type
  TfrmServer = class(TForm)
    TCPServer: TIdTCPServer;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TCPServerExecute(AThread: TIdPeerThread);
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  frmServer: TfrmServer;

implementation
{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

procedure TfrmServer.FormCreate(Sender: TObject);
begin
  TCPServer.Active := True;
end;

// Any client that makes a connection is sent a simple message,
// then disconnected.
procedure TfrmServer.TCPServerExecute(AThread: TIdPeerThread);
begin
  with AThread.Connection do
  begin
    while Connected do begin
      ReadLn;
      WriteLn('Hello from Basic Indy Server server.');
    // Disconnect;
    end;
  end;
end;

procedure TfrmServer.Button1Click(Sender: TObject);
begin
  TCPServer.Active := not TCPServer.Active;
  if TCPServer.Active then Button1.Caption := 'Kill'
  else Button1.Caption := 'Activate';
end;

end.
