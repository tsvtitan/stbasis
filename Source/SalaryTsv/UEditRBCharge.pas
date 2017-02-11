unit UEditRBCharge;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBCharge = class(TfmEditRB)
    lbfixedamount: TLabel;
    edfixedamount: TEdit;
    lbstandartoperation: TLabel;
    edstandartoperation: TEdit;
    bibstandartoperation: TBitBtn;
    lbName: TLabel;
    edName: TEdit;
    lbShortName: TLabel;
    edShortName: TEdit;
    lbchargegroup: TLabel;
    edchargegroup: TEdit;
    bibchargegroup: TBitBtn;
    lbroundtype: TLabel;
    edroundtype: TEdit;
    bibroundtype: TBitBtn;
    lbalgorithm: TLabel;
    edalgorithm: TEdit;
    bibalgorithm: TBitBtn;
    chbflag: TCheckBox;
    chbfallsintototal: TCheckBox;
    lbfixedrateathours: TLabel;
    edfixedrateathours: TEdit;
    lbfixedpercent: TLabel;
    edfixedpercent: TEdit;
    lbFlag: TLabel;
    cmbFlag: TComboBox;
    procedure edfixedamountChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edfixedamountKeyPress(Sender: TObject; var Key: Char);
    procedure bibstandartoperationClick(Sender: TObject);
    procedure dtpInDateChange(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure chbflagClick(Sender: TObject);
    procedure bibchargegroupClick(Sender: TObject);
    procedure bibroundtypeClick(Sender: TObject);
    procedure bibalgorithmClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldcharge_id: Integer;
    StandartOperation_id: Integer;
    ChargeGroup_id: Integer;
    RoundType_id: Integer;
    algorithm_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBCharge: TfmEditRBCharge;

implementation

uses USalaryTsvCode, USalaryTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBCharge.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBCharge.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbCharge,1));
    sqls:='Insert into '+tbCharge+
          ' (charge_id,name,shortname,standartoperation_id,chargegroup_id,'+
          'roundtype_id,algorithm_id,flag,fallsintototal,fixedamount,'+
          'fixedrateathours,fixedpercent) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.text))+
          ','+QuotedStr(Trim(edShortName.text))+
          ','+inttostr(standartoperation_id)+
          ','+inttostr(chargegroup_id)+
          ','+inttostr(roundtype_id)+
          ','+inttostr(algorithm_id)+
          ','+GetStrFromCondition(chbflag.checked,'1','0')+
          ','+GetStrFromCondition(chbfallsintototal.checked,'1','0')+
          ','+GetStrFromCondition(Trim(edfixedamount.Text)<>'',
                                  QuotedStr(ChangeChar(Trim(edfixedamount.Text),',','.')),
                                  'null')+
          ','+GetStrFromCondition(Trim(edfixedrateathours.Text)<>'',
                                  QuotedStr(ChangeChar(Trim(edfixedrateathours.Text),',','.')),
                                  'null')+
          ','+GetStrFromCondition(Trim(edfixedpercent.Text)<>'',
                                  QuotedStr(ChangeChar(Trim(edfixedpercent.Text),',','.')),
                                  'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldcharge_id:=strtoint(id);

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

procedure TfmEditRBCharge.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBCharge.UpdateRBooks: Boolean;
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

    id:=inttostr(oldcharge_id);//fmRBRateCurrency.MainQr.FieldByName('ratecurrency_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbCharge+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', shortname='+QuotedStr(Trim(edShortName.text))+
          ', standartoperation_id='+inttostr(standartoperation_id)+
          ', chargegroup_id='+inttostr(chargegroup_id)+
          ', roundtype_id='+inttostr(roundtype_id)+
          ', algorithm_id='+inttostr(algorithm_id)+
          ', flag='+GetStrFromCondition(chbflag.checked,'1','0')+
          ', fallsintototal='+GetStrFromCondition(chbfallsintototal.checked,'1','0')+
          ', fixedamount='+GetStrFromCondition(Trim(edfixedamount.Text)<>'',
                                               QuotedStr(ChangeChar(Trim(edfixedamount.Text),',','.')),
                                               'null')+
          ', fixedrateathours='+GetStrFromCondition(Trim(edfixedrateathours.Text)<>'',
                                                    QuotedStr(ChangeChar(Trim(edfixedrateathours.Text),',','.')),
                                                    'null')+
          ', fixedpercent='+GetStrFromCondition(Trim(edfixedpercent.Text)<>'',
                                                QuotedStr(ChangeChar(Trim(edfixedpercent.Text),',','.')),
                                                'null')+
          ' where charge_id='+id;

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

procedure TfmEditRBCharge.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBCharge.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edname.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edShortName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbShortName.Caption]));
    edShortName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edstandartoperation.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbstandartoperation.Caption]));
    bibstandartoperation.SetFocus;
    Result:=false;
    exit;
  end;
{  if trim(edchargegroup.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbchargegroup.Caption]));
    bibchargegroup.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edroundtype.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbroundtype.Caption]));
    bibroundtype.SetFocus;
    Result:=false;
    exit;
  end;
 } if trim(edalgorithm.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbalgorithm.Caption]));
    bibalgorithm.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBCharge.edfixedamountChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBCharge.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edShortName.MaxLength:=DomainSmallNameLength;
  edstandartoperation.MaxLength:=DomainNameLength;
  edchargegroup.MaxLength:=DomainNameLength;
  edroundtype.MaxLength:=DomainNameLength;
  edalgorithm.MaxLength:=DomainNameLength;

  edfixedamount.MaxLength:=DomainNameMoney;
  edfixedrateathours.MaxLength:=DomainNameMoney;
  edfixedpercent.MaxLength:=DomainNameMoney;

  chargegroup_id:=1;
  roundtype_id:=1;

end;

procedure TfmEditRBCharge.edfixedamountKeyPress(Sender: TObject;
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

procedure TfmEditRBCharge.bibstandartoperationClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='StandartOperation_id';
  TPRBI.Locate.KeyValues:=StandartOperation_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkStandartOperation,@TPRBI) then begin
   ChangeFlag:=true;
   StandartOperation_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'StandartOperation_id');
   edStandartOperation.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBCharge.dtpInDateChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBCharge.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBCharge.chbflagClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBCharge.bibchargegroupClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='ChargeGroup_id';
  TPRBI.Locate.KeyValues:=ChargeGroup_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkChargeGroup,@TPRBI) then begin
   ChangeFlag:=true;
   ChargeGroup_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'ChargeGroup_id');
   edchargegroup.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBCharge.bibroundtypeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='RoundType_id';
  TPRBI.Locate.KeyValues:=RoundType_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRoundType,@TPRBI) then begin
   ChangeFlag:=true;
   RoundType_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'RoundType_id');
   edRoundType.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBCharge.bibalgorithmClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='algorithm_id';
  TPRBI.Locate.KeyValues:=algorithm_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkAlgorithm,@TPRBI) then begin
   ChangeFlag:=true;
   algorithm_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'algorithm_id');
   edalgorithm.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

end.
