unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent,
  IdSSLOpenSSL, IdIntercept, IdSSLIntercept, IdAntiFreezeBase, IdAntiFreeze;

type
  TForm1 = class(TForm)
    HTTP: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    Panel1: TPanel;
    edURL: TEdit;
    Button1: TButton;
    memoHTML: TMemo;
    IdConnectionInterceptOpenSSL1: TIdConnectionInterceptOpenSSL;
    Splitter1: TSplitter;
    logMemo: TMemo;
    procedure Button1Click(Sender: TObject);
    function IdConnectionInterceptOpenSSL1VerifyPeer(
      Certificate: TIdX509): Boolean;
    procedure IdConnectionInterceptOpenSSL1GetPassword(
      var Password: String);
    procedure IdConnectionInterceptOpenSSL1StatusInfo(Msg: String);
    procedure FormDestroy(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

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

function TForm1.IdConnectionInterceptOpenSSL1VerifyPeer(
  Certificate: TIdX509): Boolean;
begin
//  ShowMessage(DateTimeToStr(Certificate.notBefore));
//  ShowMessage(Certificate.Issuer.OneLine);
//  ShowMessage(Certificate.Subject.OneLine);
  Result := True;
end;

procedure TForm1.IdConnectionInterceptOpenSSL1GetPassword(
  var Password: String);
begin
  Password := 'aaaa';
end;

procedure TForm1.IdConnectionInterceptOpenSSL1StatusInfo(Msg: String);
begin
  logMemo.Lines.Add(Msg);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  HTTP.DisconnectSocket; 
end;

end.
