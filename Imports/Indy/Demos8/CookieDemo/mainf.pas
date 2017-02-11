unit mainf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, idCookieManager, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, IdAntiFreezeBase, IdAntiFreeze,
  ExtCtrls, ComCtrls, IdIntercept, IdSSLIntercept, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Memo2: TMemo;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    IdCookieManager1: TIdCookieManager;
    IdConnectionInterceptOpenSSL1: TIdConnectionInterceptOpenSSL;
    procedure Button1Click(Sender: TObject);
    procedure IdHTTP1Status(axSender: TObject; const axStatus: TIdStatus;
      const asStatusText: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses loginF;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
Var
  S, S1: TStringStream;
  i: Integer;
begin
  if frmLogin.ShowModal = mrOK then begin
    S := TStringStream.Create('');
    S1 := TStringStream.Create('');
    try
      S.WriteString('edLoginName=' + frmLogin.edtLogin.Text + '&');
      S.WriteString('edPassword=' + frmLogin.edtPassword.Text + '&');
      S.WriteString('edSaveCookie=90&');
      S.WriteString('redirect=http://community.borland.com');
      IdHttp1.Request.ContentType := 'application/x-www-form-urlencoded';
      try
        IdHttp1.Post('https://community.borland.com/cgi-bin/login/login.cgi', S, S1);
      except
        IdHttp1.Get(IdHttp1.Response.Location, S1);
      end;

      Memo1.Lines.Text := S1.DataString;

      Memo2.Lines.Clear;
      for i := 0 to IdCookieManager1.CookieCollection.Count - 1 do
        Memo2.Lines.Add(IdCookieManager1.CookieCollection.Items[i].CookieText);
    finally
      S.Free;
      S1.Free;
    end;
  end;
end;

procedure TForm1.IdHTTP1Status(axSender: TObject;
  const axStatus: TIdStatus; const asStatusText: String);
begin
  StatusBar1.SimpleText := asStatusText;
end;

end.
