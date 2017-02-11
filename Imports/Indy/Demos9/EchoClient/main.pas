unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdComponent, IdTCPConnection, IdTCPClient, IdEcho,
  IdBaseComponent;

type
  TformEchoTest = class(TForm)
    edtSendText: TEdit;
    lblTextToEcho: TLabel;
    lblTotalTime: TLabel;
    edtEchoServer: TEdit;
    lblEchoServer: TLabel;
    btnConnect: TButton;
    btnDisconnect: TButton;
    IdEcoTestConnection: TIdEcho;
    lblReceivedText: TLabel;
    Button1: TButton;
    lablTime: TLabel;
    lablReceived: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure edtEchoServerChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  formEchoTest: TformEchoTest;

implementation
{$R *.DFM}

procedure TformEchoTest.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IdEcoTestConnection.Disconnect;
end;

procedure TformEchoTest.btnConnectClick(Sender: TObject);
begin
  try
    IdEcoTestConnection.Connect;
    {we only can echo after we connect to the server}
    edtSendText.Enabled := True;
    btnConnect.Enabled := False;
    btnDisconnect.Enabled := True;
  except
    IdEcoTestConnection.Disconnect;
  end; //try..except
end;

procedure TformEchoTest.btnDisconnectClick(Sender: TObject);
begin
  IdEcoTestConnection.Disconnect;
  btnConnect.Enabled := True;
  edtSendText.Enabled := False;
  btnDisconnect.Enabled := False;
end;

procedure TformEchoTest.edtEchoServerChange(Sender: TObject);
begin
  IdEcoTestConnection.Host := edtEchoServer.Text;
end;

procedure TformEchoTest.Button1Click(Sender: TObject);
begin
  {This echos the text to the server}
  lablReceived.Caption := IdEcoTestConnection.Echo ( edtSendText.Text );
  {This displays the round trip time}
  lablTime.Caption := IntToStr ( IdEcoTestConnection.EchoTime );
end;

end.
