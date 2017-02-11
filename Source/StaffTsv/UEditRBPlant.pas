unit UEditRBPlant;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPlant = class(TfmEditRB)
    lbJuristAddress: TLabel;
    edJuristAddress: TEdit;
    lbInn: TLabel;
    edInn: TEdit;
    lbSmallName: TLabel;
    edSmallName: TEdit;
    lbFullName: TLabel;
    edFullName: TEdit;
    lbAccount: TLabel;
    edAccount: TEdit;
    lbOkonh: TLabel;
    edOkonh: TEdit;
    lbOkpo: TLabel;
    edOkpo: TEdit;
    lbPostAddress: TLabel;
    edPostAddress: TEdit;
    lbBank: TLabel;
    edBank: TEdit;
    bibBank: TBitBtn;
    lbContactPeople: TLabel;
    edContactPeople: TEdit;
    lbPhone: TLabel;
    edPhone: TEdit;
    bibAddAccount: TBitBtn;
    procedure edFactorChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtpInDateChange(Sender: TObject);
    procedure edInnKeyPress(Sender: TObject; var Key: Char);
    procedure edInnChange(Sender: TObject);
    procedure bibBankClick(Sender: TObject);
    procedure bibAddAccountClick(Sender: TObject);
    procedure edBankKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldplant_id: Integer;
    bank_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPlant: TfmEditRBPlant;

implementation

uses UStaffTsvCode, UStaffTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBPlant.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPlant.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbPlant,1));
    sqls:='Insert into '+tbPlant+
          ' (plant_id,juristaddress,postaddress,'+
          'bank_id,inn,account,smallname,fullname,contactpeople,phone,okonh,okpo) values '+
          ' ('+id+
          ','+GetStrFromCondition(Trim(edJuristAddress.Text)<>'',
                                  QuotedStr(Trim(edJuristAddress.Text)),
                                  'null')+
          ','+GetStrFromCondition(Trim(edPostAddress.Text)<>'',
                                  QuotedStr(Trim(edPostAddress.Text)),
                                  'null')+
          ','+GetStrFromCondition(Trim(edBank.Text)<>'',
                                  inttostr(bank_id),
                                  'null')+
          ','+GetStrFromCondition(Trim(edInn.Text)<>'',
                                  QuotedStr(Trim(edInn.Text)),
                                  'null')+
          ','+GetStrFromCondition(Trim(edAccount.Text)<>'',
                                  QuotedStr(Trim(edAccount.Text)),
                                  'null')+
          ','+QuotedStr(Trim(edSmallName.Text))+
          ','+QuotedStr(Trim(edFullName.Text))+
          ','+GetStrFromCondition(Trim(edContactPeople.Text)<>'',
                                  QuotedStr(Trim(edContactPeople.Text)),
                                  'null')+
          ','+GetStrFromCondition(Trim(edPhone.Text)<>'',
                                  QuotedStr(Trim(edPhone.Text)),
                                  'null')+
          ','+GetStrFromCondition(Trim(edOkonh.Text)<>'',
                                  QuotedStr(Trim(edOkonh.Text)),
                                  'null')+
          ','+GetStrFromCondition(Trim(edOkpo.Text)<>'',
                                  QuotedStr(Trim(edOkpo.Text)),
                                  'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldplant_id:=strtoint(id);

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

procedure TfmEditRBPlant.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPlant.UpdateRBooks: Boolean;
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

    id:=inttostr(oldplant_id);//fmRBPLant.MainQr.FieldByName('plant_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPlant+
          ' set juristaddress='+GetStrFromCondition(Trim(edJuristAddress.Text)<>'',
                                                 QuotedStr(Trim(edJuristAddress.Text)),
                                                 'null')+
          ', postaddress='+GetStrFromCondition(Trim(edPostAddress.Text)<>'',
                                               QuotedStr(Trim(edPostAddress.Text)),
                                               'null')+
          ', bank_id='+GetStrFromCondition(Trim(edBank.Text)<>'',
                                           inttostr(bank_id),
                                          'null')+
          ', inn='+GetStrFromCondition(Trim(edInn.Text)<>'',
                                           QuotedStr(Trim(edInn.Text)),
                                          'null')+
          ', account='+GetStrFromCondition(Trim(edAccount.Text)<>'',
                                           QuotedStr(Trim(edAccount.Text)),
                                          'null')+
          ', smallname='+QuotedStr(Trim(edSmallName.Text))+
          ', fullname='+QuotedStr(Trim(edFullName.Text))+
          ', contactpeople='+GetStrFromCondition(Trim(edContactPeople.Text)<>'',
                                                 QuotedStr(Trim(edContactPeople.Text)),
                                                 'null')+
          ', phone='+GetStrFromCondition(Trim(edPhone.Text)<>'',
                                         QuotedStr(Trim(edPhone.Text)),
                                         'null')+
          ', okonh='+GetStrFromCondition(Trim(edOkonh.Text)<>'',
                                         QuotedStr(Trim(edOkonh.Text)),
                                         'null')+
          ', okpo='+GetStrFromCondition(Trim(edOkpo.Text)<>'',
                                        QuotedStr(Trim(edOkpo.Text)),
                                        'null')+
          ' where plant_id='+id;
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

procedure TfmEditRBPlant.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPlant.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edInn.Text)<>'' then begin
   if Length(Trim(edInn.Text))<>DomainPlantINNLength then begin
    ShowErrorEx(Format(ConstFieldLengthInvalid,[lbInn.Caption,DomainPlantINNLength]));
    edInn.SetFocus;
    Result:=false;
    exit;
   end;
   if not isInteger(edInn.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbInn.Caption]));
     edInn.SetFocus;
     Result:=false;
     exit;
   end;
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
{   if trim(edBank.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbBank.Caption]));
    bibBank.SetFocus;
    Result:=false;
    exit;
   end;}
  end else begin
{   if trim(edBank.Text)<>'' then begin
    ShowErrorEx(Format(ConstFieldEmpty,[lbBank.Caption]));
    bibBank.SetFocus;
    Result:=false;
    exit;
   end;  }
  end;

  if trim(edOkonh.Text)<>'' then begin
   if Length(Trim(edOkonh.Text))<>DomainPlantOkonh then begin
    ShowErrorEx(Format(ConstFieldLengthInvalid,[lbOkonh.Caption,DomainPlantOkonh]));
    edOkonh.SetFocus;
    Result:=false;
    exit;
   end;
   if not isInteger(edOkonh.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbOkonh.Caption]));
     edOkonh.SetFocus;
     Result:=false;
     exit;
   end;
  end;

  if trim(edOkpo.Text)<>'' then begin
   if Length(Trim(edOkpo.Text))<>DomainPlantOkpo then begin
    ShowErrorEx(Format(ConstFieldLengthInvalid,[lbOkpo.Caption,DomainPlantOkpo]));
    edOkpo.SetFocus;
    Result:=false;
    exit;
   end;
   if not isInteger(edOkpo.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbOkpo.Caption]));
     edOkpo.SetFocus;
     Result:=false;
     exit;
   end;
  end;
  if trim(edSmallName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSmallName.Caption]));
    edSmallName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edFullName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFullName.Caption]));
    edFullName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edJuristAddress.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbJuristAddress.Caption]));
    edJuristAddress.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPostAddress.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPostAddress.Caption]));
    edPostAddress.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPlant.edFactorChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPlant.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edInn.MaxLength:=DomainPlantINNLength;
  edAccount.MaxLength:=DomainNameAccount;
  edSmallName.MaxLength:=DomainNameLength;
  edFullName.MaxLength:=DomainNameLength;
  edOkonh.MaxLength:=DomainPlantOkonh;
  edOkpo.MaxLength:=DomainPlantOkpo;
  edJuristAddress.MaxLength:=DomainNameLength;
  edPostAddress.MaxLength:=DomainNameLength;
  edBank.MaxLength:=DomainNameLength;
  edContactPeople.MaxLength:=200;
  edPhone.MaxLength:=DomainSmallNameLength;

end;

procedure TfmEditRBPlant.dtpInDateChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPlant.edInnKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in ['0'..'9']))and((Integer(Key)<>VK_Back)) then Key:=#0;
end;

procedure TfmEditRBPlant.edInnChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPlant.bibBankClick(Sender: TObject);
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

procedure TfmEditRBPlant.bibAddAccountClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Condition.WhereStr:=PChar(' '+tbAddAccount+'.plant_id='+inttostr(oldplant_id)+' ');
  if _ViewInterfaceFromName(NameRbkAddAccount,@TPRBI) then begin
   ChangeFlag:=true;
  end;
end;

procedure TfmEditRBPlant.edBankKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edBank.Text:='';
    bank_id:=0;
  end;
end;

end.
