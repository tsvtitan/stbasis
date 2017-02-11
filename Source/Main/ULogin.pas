unit ULogin;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, IBQuery, UMainUnited, IBDatabase, Db;

type
  TfmLogin = class(TForm)
    pn: TPanel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Panel2: TPanel;
    lbUser: TLabel;
    lbPass: TLabel;
    im: TImage;
    edPass: TEdit;
    cbUsers: TComboBox;
    lbApp: TLabel;
    cbApp: TComboBox;
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TButton;
    bibCancel: TButton;
    procedure bibOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAppEnter(Sender: TObject);
    procedure cbUsersChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    function CheckFields: Boolean;
  public
    LoginCount: Integer;
    procedure FillUsers;
    function Connect(var SqlUser_Name: String): Boolean;

    procedure FillApp;
    function ConnectAsRole: Boolean;
    function GetRole: String;
    function Prepeare: Boolean;
    procedure AppOnExcept(Sender: TObject; E: Exception);
  end;

var
  fmLogin: TfmLogin;

implementation

uses UMain, UMainData, UMainCode;

{$R *.DFM}


procedure TfmLogin.bibOkClick(Sender: TObject);
const
  Sorry='Не удалось запустить приложение ';
begin
  if not ConnectAsRole then begin
    ShowErrorEx(Sorry+cbApp.Text);
    exit;
  end;
 
  LoadDataIniFromBase;
  ModalResult:=mrOk;
end;

procedure TfmLogin.FillUsers;
var
  qr: TIBQuery;
  sqls: string;
begin
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDBLogin;
    sqls:='Select *  from '+tbUsers+' order by name';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    cbUsers.Items.Clear;
    while not qr.Eof do begin
      cbUsers.Items.AddObject(qr.FieldByName('name').AsString,
                              TObject(Pointer(qr.FieldByName('user_id').AsInteger)));
      qr.Next;
    end;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

function GetInfoUser(P: PUserParams; UsersText: string): Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  if not isValidPointer(P) then exit;
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDBLogin;
    sqls:='Select user_name,name from '+tbUsers+' where Upper(name)='''+AnsiUpperCase(Trim(UsersText))+'''';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if qr.RecordCount=1 then begin
      result:=true;
      StrCopy(P.Name,Pchar(qr.FieldByName('name').AsString));
      StrCopy(P.user_name,Pchar(qr.FieldByName('user_name').AsString));
    end;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmLogin.Connect(var sqluser_name: string): Boolean;
var
  P: PUserParams;
  val: Integer;
begin
 Result:=false;
 try
  new(P);
  try
   ZeroMemory(P,sizeof(TUserParams));
   if not GetInfoUser(P,cbUsers.Text) then exit;
   if ConnectServer(MainDataBaseName,P.user_name,edPass.text,'')then begin
     UserName:=P.name;
     UserPass:=edPass.text;
     val:=cbUsers.Items.IndexOf(cbUsers.Text);
     UserId:=Integer(cbUsers.Items.Objects[val]);
     SqlUserName:=P.user_name;
     sqluser_name:=SqlUserName;
     Result:=true;
   end;
  finally
   dispose(P);
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmLogin.FillApp;
var
  qr: TIBQuery;
  sqls: string;
  val: Integer;
  UserId: Integer;
begin
 val:=cbUsers.Items.IndexOf(cbUsers.Text);
 if val=-1 then exit;
 UserId:=Integer(cbUsers.Items.Objects[val]);
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDBLogin;
    sqls:='Select ta.name as taname,tua.app_id from '+
          tbUserApp+' tua join '+
          tbUsers+' tu on tua.user_id=tu.user_id join '+
          tbApp+' ta on tua.app_id=ta.app_id '+
          ' where tua.user_id='+inttostr(UserId)+
          ' order by ta.name';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    cbApp.Items.Clear;
    while not qr.Eof do begin
      cbApp.Items.AddObject(qr.FieldByName('taname').AsString,TObject(qr.FieldByName('app_id').AsInteger));
      qr.Next;
    end;
    if cbApp.Items.Count>0 then begin
      cbApp.ItemIndex:=0;
    end;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmLogin.ConnectAsRole: Boolean;
var
  role: string;
begin
 result:=false;
 try
  role:=GetRole;
  if Trim(role)='' then exit;
  if MainConnect(MainDataBaseName,SqlUserName,UserPass,role)then begin
    Result:=true;
    if Result then begin
      SqlRole:=role;
      MainCaption:=cbApp.Text;
      AppName:=MainCaption;
      AppId:=Integer(cbApp.Items.Objects[cbApp.ItemIndex]);
    end;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmLogin.GetRole: String;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:='';
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDBLogin;
    sqls:='Select sqlrole from '+tbApp+' where Upper(name)='''+AnsiUpperCase(cbApp.Text)+'''';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if qr.RecordCount=1 then begin
      result:=Trim(qr.FieldByname('sqlrole').AsString);
    end;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmLogin.FormCreate(Sender: TObject);
begin
  CurrentHandle:=Handle;
  Application.OnException:=AppOnExcept;
  cbUsers.Text:=UserName;
{$IFDEF DEVELOPER}
  edPass.Text:='adminusers';
{$ENDIF}
end;

function TfmLogin.Prepeare: Boolean;
var
  dbname: string;
begin
  result:=false;
  if Trim(SecurityDataBaseName)<>'' then begin
   dbname:=SecurityDataBaseName;
  end else begin
//   dbname:=GetSecurityDatabaseName;
    dbname:=MainDataBaseName;
  end;
  try
   Screen.Cursor:=crHourGlass;
   try
    if SecurityConnect(dbname,ConstConnectUserName,ConstConnectUserPass,'') then begin
      SecurityDataBaseName:=dbName;
      Result:=CheckFields;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  except
    raise;
  end;
end;

procedure TfmLogin.cbAppEnter(Sender: TObject);
var
  user_name: string;
  val: Integer;
begin
  if LoginCount>2 then begin
    ModalResult:=mrCancel;
    Close;
  end;
  if not Connect(user_name) then begin
//    ShowErrorEx('Неверный пользователь или пароль.');
    edPass.Text:='';
    cbUsers.SetFocus;
    cbApp.Clear;
    inc(LoginCount);
  end else begin
    FillApp;
    val:=cbApp.Items.IndexOf(AppName);
    if val<>-1 then
      cbApp.ItemIndex:=val;
    if cbApp.ItemIndex<>-1 then begin
      bibOk.Enabled:=true;
    end;
  end;
end;

procedure TfmLogin.cbUsersChange(Sender: TObject);
begin
  edPass.Text:='';
  cbApp.Clear;
end;

function TfmLogin.CheckFields: Boolean;
var
  qr: TIBQuery;
 // sqls: string;
begin
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmLogin.FormActivate(Sender: TObject);
{$IFDEF DEVELOPER}
var
  pt: TPoint;
{$ENDIF}
begin
 {$IFDEF DEVELOPER}
  edPass.SetFocus;
  cbApp.SetFocus;
  pt:=Point(bibOk.left+bibOk.width div 2,bibOk.Top+bibOk.Height div 2);
  pt:=bibOk.ClientToScreen(pt);
  SetCursorPos(pt.x,pt.y);
  mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
  mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
{  sleep(500);
  bibOk.Click;}
 {$ENDIF}
end;

procedure TfmLogin.AppOnExcept(Sender: TObject; E: Exception);
begin
   AddErrorToJournal_(Pchar(E.Message),E.ClassType);
end;


end.
