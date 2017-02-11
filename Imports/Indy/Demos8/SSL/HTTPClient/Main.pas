unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent,
  IdSSLOpenSSL, IdIntercept, IdSSLIntercept, IdAntiFreezeBase, IdAntiFreeze,
  IdLogBase, IdLogEvent, IdIOHandler, IdIOHandlerSocket;

type
  TForm1 = class(TForm)
    IdAntiFreeze1: TIdAntiFreeze;
    Panel1: TPanel;
    edURL: TEdit;
    Button1: TButton;
    memoHTML: TMemo;
    Splitter1: TSplitter;
    logMemo: TMemo;
    HTTP: TIdHTTP;
    IdSSLIOHandler: TIdSSLIOHandlerSocket;
    procedure Button1Click(Sender: TObject);
    function VerifyPeer(Certificate: TIdX509): Boolean;
    procedure GetPassword(var Password: String);
    procedure StatusInfo(Msg: String);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    SSLHandler: TIdSSLIOHandlerSocket;
  end;

var
  Form1: TForm1;

implementation
{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}


procedure TForm1.Button1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass; try
    memoHTML.Clear;
    if edURL.Text ='' then begin
      ShowMessage('Specify a URL and a output file first!')
    end else begin
      memoHTML.Lines.Text := HTTP.Get(edURL.Text);
    end;
  finally Screen.Cursor := crDefault; end;
end;

function TForm1.VerifyPeer(
  Certificate: TIdX509): Boolean;
begin
  logMemo.Lines.Add(DateTimeToStr(Certificate.notBefore));
  logMemo.Lines.Add(Certificate.Issuer.OneLine);
  logMemo.Lines.Add(Certificate.Subject.OneLine);
  Result := True;
end;

procedure TForm1.GetPassword(var Password: String);
begin
  Password := 'aaaa';
end;

procedure TForm1.StatusInfo(Msg: String);
begin
  logMemo.Lines.Add(Msg);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  HTTP.DisconnectSocket;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{
  SSLHandler := TIdSSLIOHandlerSocket.Create(nil);
  SSLHandler.SSLOptions.Method := sslvSSLv23;
  SSLHandler.OnGetPassword := GetPassword;
  SSLHandler.OnStatusInfo := StatusInfo;
  HTTP.IOHandler := SSLHandler;
}  
end;

end.
