unit UChangePassword;

interface

{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, adodb, IBServices, Db, IBDatabase;

type
  TfmChangePass = class(TForm)
    Panel1: TPanel;
    btOk: TButton;
    BitBtn2: TButton;
    lbOldPas: TLabel;
    edOldPass: TEdit;
    lbNewPass: TLabel;
    edNewPass: TEdit;
    lbOkPass: TLabel;
    edOkPass: TEdit;
    im: TImage;
    IBSecServ: TIBSecurityService;
    ibdbpass: TIBDatabase;
    procedure btOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function ConnectSecurityService: Boolean;
    function isChangePass: Boolean;
    function isConnectOldPass: Boolean;
  public
    { Public declarations }
  end;

var
  fmChangePass: TfmChangePass;

implementation

uses UMainData, UMainUnited, UMainCode;

{$R *.DFM}

procedure TfmChangePass.btOkClick(Sender: TObject);
begin
  if (Trim(edOldPass.Text)='') then begin
     ShowErrorEx('Введите старый пароль.');
     edOldPass.SetFocus;
     exit;
  end;
  if (Trim(edNewPass.Text)='') then begin
     ShowErrorEx('Введите новый пароль.');
     edNewPass.SetFocus;
     exit;
  end;
  if (Trim(edOkPass.Text)='') then begin
     ShowErrorEx('Введите подтверждение нового пароля.');
     edOkPass.SetFocus;
     exit;
  end;

  if AnsiUpperCase(edNewPass.Text)<>AnsiUpperCase(edOkPass.Text) then begin
     ShowErrorEx('Новый пароль и его подтверждение различны.');
     edOkPass.SetFocus;
     exit;
  end;

  if not isConnectOldPass then begin
    ShowErrorEx('Неверен старый пароль.');
    edOldPass.SetFocus;
    exit;
  end;
  if not isChangePass then begin
    ShowErrorEx('Изменить пароль не удалось.');
    exit;
  end else begin
    RefreshFromBase; 
    ShowInfoEx('Пароль успешно изменен.');
  end;

  MoDalResult:=mrOk;
end;

function TfmChangePass.ConnectSecurityService: Boolean;
var
  Srvname: array[0..ConstSrvName-1] of char;
  protocol: TProtocol;
begin
 Result:=false;
 try
   FillChar(Srvname,ConstSrvName,0);
   GetProtocolAndServerName_(PChar(IBDB.DatabaseName),protocol,Srvname);
   IBSecServ.ServerName := Srvname;
   IBSecServ.Protocol:=protocol;
   IBSecServ.LoginPrompt := False;
   if IBSecServ.Active then
    IBSecServ.Active := false;
   IBSecServ.Params.Clear;
   IBSecServ.Params.Add('user_name='+SqlUserName);
   IBSecServ.Params.Add('password='+UserPass);
   IBSecServ.Active := true;
   Result:=true;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmChangePass.isConnectOldPass: Boolean;
begin
  Screen.Cursor:=crHourGlass;
  try
    Result:=false;
    try
     ibdbpass.LoginPrompt:=false;
     ibdbpass.SQLDialect:=IBDB.SQLDialect;
     ibdbpass.DatabaseName:=IBDB.DatabaseName;
     ibdbpass.Params.Clear;
     ibdbpass.Params.Add('user_name='+SqlUserName);
     ibdbpass.Params.Add('password='+edOldPass.Text);
     ibdbpass.Connected:=true;
     Result:=ibdbpass.Connected;
    except
{     on E: Exception do
      ShowErrorEx(E.Message);}
    end; 
  finally
    Screen.Cursor:=crDefault;
  end;
end;

function TfmChangePass.isChangePass: Boolean;
begin
  Result:=false;
  try
   Screen.Cursor:=crHourGlass;
   try
    if ConnectSecurityService then begin
     IBSecServ.UserName:=SqlUserName;
     IBSecServ.UserID:=0;
     IBSecServ.GroupID:=0;
     IBSecServ.Password:=Trim(edNewPass.Text);
     IBSecServ.ModifyUser;
     UserPass:=Trim(edNewPass.Text);
     IBSecServ.Active := false;
     Result:=true;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmChangePass.FormCreate(Sender: TObject);
begin
  AssignFont(_GetOptions.FormFont,Font);
end;

end.
