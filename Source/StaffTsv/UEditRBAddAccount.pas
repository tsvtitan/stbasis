unit UEditRBAddAccount;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBAddAccount = class(TfmEditRB)
    lbAccount: TLabel;
    edAccount: TEdit;
    lbBank: TLabel;
    edBank: TEdit;
    bibBank: TBitBtn;
    procedure edFactorChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtpInDateChange(Sender: TObject);
    procedure edInnKeyPress(Sender: TObject; var Key: Char);
    procedure edInnChange(Sender: TObject);
    procedure bibBankClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldplant_id: Integer;
    oldaddaccount_id: Integer;
    bank_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBAddAccount: TfmEditRBAddAccount;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBAddAccount.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBAddAccount.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbAddAccount,1));
    sqls:='Insert into '+tbAddAccount+
          ' (addaccount_id,plant_id,bank_id,account) values '+
          ' ('+id+
          ','+inttostr(oldplant_id)+
          ','+inttostr(bank_id)+
          ','+QuotedStr(Trim(edAccount.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldaddaccount_id:=strtoint(id);

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

procedure TfmEditRBAddAccount.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBAddAccount.UpdateRBooks: Boolean;
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

    id:=inttostr(oldaddaccount_id);//fmRBAddAccount.MainQr.FieldByName('addaccount_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbAddAccount+
          ' set plant_id='+inttostr(oldplant_id)+
          ', bank_id='+inttostr(bank_id)+
          ', account='+QuotedStr(Trim(edAccount.Text))+
          ' where addaccount_id='+id;
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
    ShowErrorEx(TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBAddAccount.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBAddAccount.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edAccount.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbAccount.Caption]));
    edAccount.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edAccount.Text)<>'' then begin
   if Length(Trim(edAccount.Text))<>DomainNameAccount then begin
    ShowErrorEx(Format(ConstFieldLengthInvalid,[lbAccount.Caption,DomainNameAccount]));
    edAccount.SetFocus;
    Result:=false;
    exit;
   end;
   if not isInteger(edAccount.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbAccount.Caption]));
     edAccount.SetFocus;
     Result:=false;
     exit;
   end;
  end;

  if trim(edBank.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbBank.Caption]));
    bibBank.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBAddAccount.edFactorChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBAddAccount.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edAccount.MaxLength:=DomainNameAccount;
  edBank.MaxLength:=DomainNameLength;
end;

procedure TfmEditRBAddAccount.dtpInDateChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAddAccount.edInnKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBAddAccount.edInnChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBAddAccount.bibBankClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='bank_id';
  TPRBI.Locate.KeyValues:=bank_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkBank,@TPRBI) then begin
   ChangeFlag:=true;
   bank_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'bank_id');
   edBank.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
