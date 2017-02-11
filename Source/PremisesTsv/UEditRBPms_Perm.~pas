unit UEditRBPms_Perm;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPms_Perm = class(TfmEditRB)
    lbUserName: TLabel;
    edUserName: TEdit;
    lbPerm: TLabel;
    btUserName: TButton;
    cmbPerm: TComboBox;
    lbTypeOperation: TLabel;
    cmbTypeOperation: TComboBox;
    procedure edUserNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edSortChange(Sender: TObject);
    procedure btUserNameClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    user_id: Variant;
    oldPms_Perm_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    procedure SetPerm(Value: string);
  end;

var
  fmEditRBPms_Perm: TfmEditRBPms_Perm;

function GetTypeOperationName(Value: Integer): string;  

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Perm;

const
   ConstTypeOperationSale='Продажа';
   ConstTypeOperationLease='Аренда';
   ConstTypeOperationShare='Долевое';
   ConstTypeOperationLand='Земля';

function GetTypeOperationName(Value: Integer): string;
begin
  Result:='';
  case Value of
    0: Result:=ConstTypeOperationSale;
    1: Result:=ConstTypeOperationLease;
    2: Result:=ConstTypeOperationShare;
    3: Result:=ConstTypeOperationLand;
  end;
end;


{$R *.DFM}

procedure TfmEditRBPms_Perm.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Perm.AddToRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    id:=inttostr(GetGenId(IBDB,tbPms_Perm,1));
    sqls:='Insert into '+tbPms_Perm+
          ' (Pms_Perm_id,user_id,perm,typeoperation) values '+
          ' ('+id+
          ','+inttostr(user_id)+
          ','+QuotedStr(Trim(Copy(cmbPerm.Text,1,1)))+
          ','+inttostr(cmbTypeOperation.ItemIndex)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_Perm_id:=strtoint(id);

    TfmRBPms_Perm(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Perm(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Perm(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_Perm_id').AsInteger:=oldPms_Perm_id;
      FieldByName('user_id').AsInteger:=user_id;
      FieldByName('username').AsString:=Trim(edUserName.Text);
      FieldByName('perm').AsString:=Trim(Copy(cmbPerm.Text,1,1));
      FieldByName('typeoperation').AsInteger:=cmbTypeOperation.ItemIndex;
      Post;
    end;

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBPms_Perm.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Perm.UpdateRBooks: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
begin
 Result:=false;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(oldPms_Perm_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPms_Perm+
          ' set user_id='+inttostr(user_id)+
          ', perm='+QuotedStr(Trim(Copy(cmbPerm.Text,1,1)))+
          ', typeoperation='+inttostr(cmbTypeOperation.ItemIndex)+
          ' where Pms_Perm_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_Perm(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Perm(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Perm(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_Perm_id').AsInteger:=oldPms_Perm_id;
      FieldByName('user_id').AsInteger:=user_id;
      FieldByName('username').AsString:=Trim(edUserName.Text);
      FieldByName('perm').AsString:=Trim(Copy(cmbPerm.Text,1,1));
      FieldByName('typeoperation').AsInteger:=cmbTypeOperation.ItemIndex;
      Post;
    end;

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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBPms_Perm.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Perm.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edUserName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbUserName.Caption]));
    btUserName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_Perm.edUserNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Perm.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edUserName.MaxLength:=DomainNameLength;
  cmbPerm.MaxLength:=DomainShortNameLength;
  cmbPerm.Items.Add(Format(fmtPerm,[SelConst,ConstSelect]));
  cmbPerm.Items.Add(Format(fmtPerm,[InsConst,ConstInsert]));
  cmbPerm.Items.Add(Format(fmtPerm,[UpdConst,ConstUpdate]));
  cmbPerm.Items.Add(Format(fmtPerm,[DelConst,ConstDelete]));
  cmbPerm.ItemIndex:=0;

  cmbTypeOperation.MaxLength:=DomainShortNameLength;
  cmbTypeOperation.Items.Add(ConstTypeOperationSale);
  cmbTypeOperation.Items.Add(ConstTypeOperationLease);
  cmbTypeOperation.Items.Add(ConstTypeOperationShare);
  cmbTypeOperation.Items.Add(ConstTypeOperationLand);
  cmbTypeOperation.ItemIndex:=0;

end;

procedure TfmEditRBPms_Perm.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Perm.edSortChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Perm.btUserNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='user_id';
  TPRBI.Locate.KeyValues:=user_id;
  if _ViewInterfaceFromName(NameRbkUser,@TPRBI) then begin
    edUserName.Text:=GetFirstValueFromPRBI(@TPRBI,'name');
    user_id:=GetFirstValueFromPRBI(@TPRBI,'user_id');
    ChangeFlag:=true;
  end;
end;

procedure TfmEditRBPms_Perm.SetPerm(Value: string);
begin
  if Value=SelConst then cmbPerm.ItemIndex:=0;
  if Value=InsConst then cmbPerm.ItemIndex:=1;
  if Value=UpdConst then cmbPerm.ItemIndex:=2;
  if Value=DelConst then cmbPerm.ItemIndex:=3;
end;


end.
