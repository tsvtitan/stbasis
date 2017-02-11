unit UEditRBEmpFaceAccount;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  ComCtrls, IB, URBEmp;

type
  TfmEditRBEmpFaceAccount = class(TfmEditRB)
    lbNum: TLabel;
    edNum: TEdit;
    lbPercent: TLabel;
    edPercent: TEdit;
    lbSumm: TLabel;
    edSumm: TEdit;
    lbBank: TLabel;
    edBank: TEdit;
    bibBank: TBitBtn;
    lbCurrency: TLabel;
    edCurrency: TEdit;
    bibCurrency: TBitBtn;
    procedure edhousenumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edConnectionTypeChange(Sender: TObject);
    procedure dtpBirthdateChange(Sender: TObject);
    procedure bibBankClick(Sender: TObject);
    procedure edBankChange(Sender: TObject);
    procedure bibCurrencyClick(Sender: TObject);
    procedure edPercentKeyPress(Sender: TObject; var Key: Char);
    procedure edNumKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    ParentEmpForm: TfmRBEmpMain;
    emp_id: Integer;
    bank_id: Integer;
    currency_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBEmpFaceAccount: TfmEditRBEmpFaceAccount;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBEmpFaceAccount.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBEmpFaceAccount.AddToRBooks: Boolean;
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

    id:=inttostr(GetGenId(IBDB,tbEmpFaceAccount,1));
    qr.Database:=IBDB;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbEmpFaceAccount+
          ' (empfaceaccount_id,currency_id,emp_id,bank_id,num,percent,summ) values '+
          ' ('+
          id+','+
          inttostr(currency_id)+','+
          inttostr(emp_id)+','+
          inttostr(bank_id)+','+
          QuotedStr(Trim(edNum.Text))+','+
          GetStrFromCondition(Trim(edPercent.Text)<>'',
                              QuotedStr(ChangeChar(Trim(edPercent.Text),',','.')),
                              'null')+','+
          GetStrFromCondition(Trim(edSumm.Text)<>'',
                              QuotedStr(ChangeChar(Trim(edSumm.Text),',','.')),
                              'null')+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpFaceAccount(false);
    ParentEmpForm.qrEmpFaceAccount.Locate('empfaceaccount_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpFaceAccount.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBEmpFaceAccount.UpdateRBooks: Boolean;
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

    id:=ParentEmpForm.qrEmpFaceAccount.FieldByName('empfaceaccount_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbEmpFaceAccount+
          ' set emp_id='+inttostr(emp_id)+
          ', bank_id='+inttostr(bank_id)+
          ', currency_id='+inttostr(currency_id)+
          ', num='+QuotedStr(Trim(edNum.Text))+
          ', percent='+GetStrFromCondition(Trim(edPercent.Text)<>'',
                                           QuotedStr(ChangeChar(Trim(edPercent.Text),',','.')),
                                           'null')+
          ', summ='+GetStrFromCondition(Trim(edSumm.Text)<>'',
                                           QuotedStr(ChangeChar(Trim(edSumm.Text),',','.')),
                                           'null')+
          ' where empfaceaccount_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    ParentEmpForm.ActiveEmpFaceAccount(false);
    ParentEmpForm.qrEmpFaceAccount.Locate('empfaceaccount_id',id,[LocaseInsensitive]);
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

procedure TfmEditRBEmpFaceAccount.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBEmpFaceAccount.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNum.Text)<>'' then begin
   if Length(Trim(edNum.Text))<>DomainNameAccount then begin
    ShowErrorEx(Format(ConstFieldLengthInvalid,[lbNum.Caption,DomainNameAccount]));
    edNum.SetFocus;
    Result:=false;
    exit;
   end;
    if not isInteger(edNum.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbNum.Caption]));
     edNum.SetFocus;
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
  if trim(edCurrency.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCurrency.Caption]));
    bibCurrency.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPercent.Text)<>'' then begin
    if not isFloat(edPercent.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbPercent.Caption]));
     edPercent.SetFocus;
     Result:=false;
     exit;
    end;
  end;
  if trim(edSumm.Text)<>'' then begin
    if not isFloat(edSumm.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbSumm.Caption]));
     edSumm.SetFocus;
     Result:=false;
     exit;
    end;
  end;

end;

procedure TfmEditRBEmpFaceAccount.edhousenumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpFaceAccount.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNum.MaxLength:=DomainNameAccount;
  edBank.MaxLength:=DomainNameLength;
  edCurrency.MaxLength:=DomainNameLength;
  edPercent.MaxLength:=DomainNameMoney;
  edSumm.MaxLength:=DomainNameMoney;
end;

procedure TfmEditRBEmpFaceAccount.edConnectionTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpFaceAccount.dtpBirthdateChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBEmpFaceAccount.bibBankClick(Sender: TObject);
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

procedure TfmEditRBEmpFaceAccount.edBankChange(Sender: TObject);
begin
  ChangeFlag:=true;

end;

procedure TfmEditRBEmpFaceAccount.bibCurrencyClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='currency_id';
  TPRBI.Locate.KeyValues:=currency_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCurrency,@TPRBI) then begin
   ChangeFlag:=true;
   currency_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'currency_id');
   edCurrency.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBEmpFaceAccount.edPercentKeyPress(Sender: TObject;
  var Key: Char);
var
  APos: Integer;
begin
  ChangeFlag:=true;
  if (not (Key in ['0'..'9']))and
   (Key<>DecimalSeparator)and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end else begin
   if Key=DecimalSeparator then begin
    Apos:=Pos(String(DecimalSeparator),TEdit(Sender).Text);
    if Apos<>0 then Key:=char(nil);
   end;
  end;
end;

procedure TfmEditRBEmpFaceAccount.edNumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

end.
