unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPServer, IdMappedPortTCP,
  IdIntercept, IdSSLIntercept, IdSSLOpenSSL, IdTCPClient, StdCtrls;

type
  TformMain = class(TForm)
    MappedPort: TIdMappedPortTCP;
    lablLocal: TLabel;
    Label2: TLabel;
    lablHost: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure MappedPortBeforeClientConnect(ASender: TComponent;
      AThread: TIdPeerThread; AClient: TIdTCPClient);
    procedure SSLInterceptGetPassword(var Password: String);
  private
  public
  end;

var
  formMain: TformMain;

implementation
{$R *.DFM}

procedure TformMain.FormCreate(Sender: TObject);
begin
  if ParamCount = 3 then begin
    with MappedPort do begin
      DefaultPort := StrToInt(ParamStr(1));
      MappedHost := ParamStr(2);
      MappedPort := StrToInt(ParamStr(3));
      //
      Active := True;
      //
      lablLocal.Caption := 'Local Port: ' + IntToStr(DefaultPort);
      lablHost.Caption := 'Host: ' + MappedHost + ':' + IntToStr(MappedPort);
    end;
    lablLocal.Visible := True;
    lablHost.Visible := True;
  end;
end;

procedure TformMain.MappedPortBeforeClientConnect(ASender: TComponent;
  AThread: TIdPeerThread; AClient: TIdTCPClient);
var
  LIntercept: TIdConnectionInterceptOpenSSL;
begin
  LIntercept := TIdConnectionInterceptOpenSSL.Create(AClient);
  AClient.Intercept := LIntercept;
  with LIntercept do begin
    SSLOptions.Method := sslvSSLv2;
    SSLOptions.Mode := sslmClient;
    SSLOptions.VerifyMode := [];
    SSLOptions.VerifyDepth := 0;
    OnGetPassword := SSLInterceptGetPassword;
  end;
end;

procedure TformMain.SSLInterceptGetPassword(var Password: String);
begin
  Password := 'aaaa';
end;

end.
