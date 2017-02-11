unit UEditRBUserApp;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB;

type
  TfmEditRBUserApp = class(TfmEditRB)
    lbApp: TLabel;
    edApp: TEdit;
    lbUsername: TLabel;
    edUsername: TEdit;
    bibApp: TButton;
    bibUserName: TButton;
    IBTranSec: TIBTransaction;
    procedure edAppChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibAppClick(Sender: TObject);
    procedure bibUserNameClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
    function Grant(NewSqlRole: string): Boolean;
    function Revoke(OldSqlRole: String): Boolean;
  public
    oldApp_id: Integer;
    oldUser_id: Integer;
    App_id: Integer;
    user_id: Integer;
    User_name: string;
    SqlroleNew,SqlRoleOld: string;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBUserApp: TfmEditRBUserApp;

implementation

uses USysTsvCode, USysTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBUserApp.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBUserApp.Grant(NewSqlRole: string): Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='grant '+NewSqlRole+' to "'+User_name+'" with admin option';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmEditRBUserApp.Revoke(OldSqlRole: String): Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='revoke '+Trim(OldSqlRole)+' from "'+User_name+'"';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function TfmEditRBUserApp.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTranSec;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbUserApp+
          ' (app_id,user_id) values '+
          ' ('+inttostr(App_id)+','+inttostr(User_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    if not Grant(SqlRoleNew) then exit;
    qr.Transaction.Commit;

    Result:=true;     
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
    on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
    end;
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBUserApp.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBUserApp.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id1,id2: string;
begin
 result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    id1:=inttostr(oldApp_id);
    id2:=inttostr(oldUser_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTranSec;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbUserApp+
          ' set app_id='+inttostr(App_id)+
          ', user_id='+inttostr(User_id)+
          ' where app_id='+id1+' and user_id='+id2;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    if not revoke(SqlRoleOld) then exit;
    if not grant(SqlRoleNew) then exit;
    qr.Transaction.Commit;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBUserApp.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBUserApp.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edApp.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbApp.Caption]));
    bibApp.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edUserName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbUserName.Caption]));
    bibUserName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBUserApp.edAppChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBUserApp.FormCreate(Sender: TObject);
begin
  inherited;
  IBTranSec.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTranSec);

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

end;

procedure TfmEditRBUserApp.bibAppClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
 FillChar(TPRBI,SizeOf(TPRBI),0);
 TPRBI.Visual.TypeView:=tvibvModal;
 TPRBI.Locate.KeyFields:='app_id';
 TPRBI.Locate.KeyValues:=app_id;
 TPRBI.Locate.Options:=[loCaseInsensitive];
 if _ViewInterfaceFromName(NameRbkApp,@TPRBI) then begin
   ChangeFlag:=true;
   app_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'app_id');
   SqlroleNew:=GetFirstValueFromParamRBookInterface(@TPRBI,'sqlrole');
   edApp.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
 end;
end;

procedure TfmEditRBUserApp.bibUserNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='User_name';
  TPRBI.Locate.KeyValues:=User_name;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkUsers,@TPRBI) then begin
   ChangeFlag:=true;
   edUsername.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
   User_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'user_id');
   User_Name:=GetFirstValueFromParamRBookInterface(@TPRBI,'user_name');
  end;
end;

end.
