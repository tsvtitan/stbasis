unit UEditRBUserEmp;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB;

type
  TfmEditRBUserEmp = class(TfmEditRB)
    lbEmp: TLabel;
    edEmp: TEdit;
    lbUsername: TLabel;
    edUsername: TEdit;
    bibEmp: TBitBtn;
    bibUserName: TBitBtn;
    procedure edEmpChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibEmpClick(Sender: TObject);
    procedure bibUserNameClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    olduser_name: string;
    emp_id: Integer;
    user_name: string;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBUserEmp: TfmEditRBUserEmp;

implementation

uses UKassaKDMCode, UKassaKDMData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBUserEmp.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


function TfmEditRBUserEmp.AddToRBooks: Boolean;
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
    sqls:='Insert into '+tbUserEmp+
          ' (emp_id,username,user_name) values '+
          ' ('+inttostr(emp_id)+','+
               QuotedStr(Trim(edUsername.Text))+','+
               QuotedStr(user_name)+
               ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBUserEmp.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBUserEmp.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id2: string;
begin
 result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try
    id2:=olduser_name;//fmRBUserEmp.MainQr.FieldByname('username').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbUserEmp+
          ' set emp_id='+inttostr(emp_id)+
          ', username='+QuotedStr(Trim(edUsername.Text))+
          ', user_name='+QuotedStr(User_name)+
          ' where username='+QuotedStr(id2);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowError(Handle,TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBUserEmp.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBUserEmp.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edEmp.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbEmp.Caption]));
    bibEmp.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edUserName.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbUserName.Caption]));
    bibUserName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBUserEmp.edEmpChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBUserEmp.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

end;

procedure TfmEditRBUserEmp.bibEmpClick(Sender: TObject);
var
  P: PEmpParams;
begin
 try
  getMem(P,sizeof(TEmpParams));
  try
   ZeroMemory(P,sizeof(TEmpParams));
   P.emp_id:=emp_id;
   if _ViewEntryFromMain(tte_rbksemp,p,true) then begin
     ChangeFlag:=true;
     emp_id:=P.emp_id;
     edEmp.Text:=P.fname+' '+P.name+' '+P.sname;
   end;
  finally
    FreeMem(P,sizeof(TEmpParams));
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmEditRBUserEmp.bibUserNameClick(Sender: TObject);
var
  P: PUserParams;
begin
 try
  getMem(P,sizeof(TUserParams));
  try
   ZeroMemory(P,sizeof(TUserParams));
   StrCopy(P.user_name,Pchar(user_name));
   if ViewEntry_(tte_rbksUsers,p,true) then begin
     ChangeFlag:=true;
     edUsername.Text:=P.name;
     user_name:=P.user_name;
   end;
  finally
    FreeMem(P,sizeof(TUserParams));
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

end.
