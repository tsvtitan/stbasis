unit UEditRBNomenclatureTypeOfprice;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBNomenclatureTypeOfPrice = class(TfmEditRB)
    lbUnit: TLabel;
    edUnit: TEdit;
    bibUnit: TBitBtn;
    lbPay: TLabel;
    lbPrice: TLabel;
    edPay: TEdit;
    edPrice: TEdit;
    lbTypeOfPrice: TLabel;
    edTypeOfPrice: TEdit;
    bibTypeOfPrice: TBitBtn;
    lbCurrency: TLabel;
    edCurrency: TEdit;
    bibCurrency: TBitBtn;
    procedure edCodeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibUnitClick(Sender: TObject);
    procedure edPayKeyPress(Sender: TObject; var Key: Char);
    procedure chbIsBaseUnitClick(Sender: TObject);
    procedure bibTypeOfPriceClick(Sender: TObject);
    procedure bibCurrencyClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldtypeofprice_id: Integer;
    nomenclature_id: Integer;
    typeofprice_id: Integer;
    currency_id: Integer;
    unitofmeasure_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    procedure SetDefaultCurrency;
  end;

var
  fmEditRBNomenclatureTypeOfPrice: TfmEditRBNomenclatureTypeOfPrice;

implementation

uses UStoreTsvCode, UStoreTsvData, UMainUnited, URBNomenclature;

{$R *.DFM}

procedure TfmEditRBNomenclatureTypeOfPrice.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureTypeOfPrice.AddToRBooks: Boolean;
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
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbNomenclatureTypeOfPrice+
          ' (nomenclature_id,typeofprice_id,unitofmeasure_id,currency_id,pay,price) values '+
          ' ('+inttostr(nomenclature_id)+
          ','+inttostr(typeofprice_id)+
          ','+inttostr(unitofmeasure_id)+
          ','+inttostr(currency_id)+
          ','+QuotedStr(ChangeChar(Trim(edPay.Text),',','.'))+
          ','+QuotedStr(ChangeChar(Trim(edPrice.Text),',','.'))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBNomenclature(fmParent).updDetail.InsertSQL.Clear;
    TfmRBNomenclature(fmParent).updDetail.InsertSQL.Add(sqls);

    with TfmRBNomenclature(fmParent).qrDetail do begin
      Insert;
      FieldByName('nomenclature_id').AsInteger:=nomenclature_id;
      FieldByName('typeofprice_id').AsInteger:=typeofprice_id;
      FieldByName('typeofpricename').AsString:=Trim(edTypeOfPrice.Text);
      FieldByName('unitofmeasure_id').AsInteger:=unitofmeasure_id;
      FieldByName('unitofmeasurename').AsString:=Trim(edUnit.Text);
      FieldByName('currency_id').AsInteger:=currency_id;
      FieldByName('currencyname').AsString:=Trim(edCurrency.Text);
      FieldByName('pay').AsFloat:=StrToFloat(Trim(edPay.Text));
      FieldByName('price').AsFloat:=StrToFloat(Trim(edPrice.Text));
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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBNomenclatureTypeOfPrice.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureTypeOfPrice.UpdateRBooks: Boolean;
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
    sqls:='Update '+tbNomenclatureTypeOfPrice+
          ' set nomenclature_id='+inttostr(nomenclature_id)+
          ', typeofprice_id='+inttostr(typeofprice_id)+
          ', unitofmeasure_id='+inttostr(unitofmeasure_id)+
          ', currency_id='+inttostr(currency_id)+
          ', pay='+QuotedStr(ChangeChar(Trim(edPay.Text),',','.'))+
          ', price='+QuotedStr(ChangeChar(Trim(edPrice.Text),',','.'))+
          ' where nomenclature_id='+inttostr(nomenclature_id)+
          ' and typeofprice_id='+inttostr(oldtypeofprice_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBNomenclature(fmParent).updDetail.ModifySQL.Clear;
    TfmRBNomenclature(fmParent).updDetail.ModifySQL.Add(sqls);

    with TfmRBNomenclature(fmParent).qrDetail do begin
      Edit;
      FieldByName('nomenclature_id').AsInteger:=nomenclature_id;
      FieldByName('typeofprice_id').AsInteger:=typeofprice_id;
      FieldByName('typeofpricename').AsString:=Trim(edTypeOfPrice.Text);
      FieldByName('unitofmeasure_id').AsInteger:=unitofmeasure_id;
      FieldByName('unitofmeasurename').AsString:=Trim(edUnit.Text);
      FieldByName('currency_id').AsInteger:=currency_id;
      FieldByName('currencyname').AsString:=Trim(edCurrency.Text);
      FieldByName('pay').AsFloat:=StrToFloat(Trim(edPay.Text));
      FieldByName('price').AsFloat:=StrToFloat(Trim(edPrice.Text));
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
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmEditRBNomenclatureTypeOfPrice.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureTypeOfPrice.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edTypeOfPrice.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTypeOfPrice.Caption]));
    bibTypeOfPrice.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edUnit.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbUnit.Caption]));
    bibUnit.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edCurrency.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCurrency.Caption]));
    bibCurrency.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPay.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPay.Caption]));
    edPay.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edPrice.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPrice.Caption]));
    edPrice.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBNomenclatureTypeOfPrice.edCodeChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBNomenclatureTypeOfPrice.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edTypeOfPrice.MaxLength:=DomainNameLength;
  edUnit.MaxLength:=DomainNameLength;
  edCurrency.MaxLength:=DomainNameLength;
  edPay.MaxLength:=DomainNameMoney;
  edPrice.MaxLength:=DomainNameMoney;
end;

procedure TfmEditRBNomenclatureTypeOfPrice.bibUnitClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='unitofmeasure_id';
  TPRBI.Locate.KeyValues:=unitofmeasure_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkUnitOfMeasure,@TPRBI) then begin
   ChangeFlag:=true;
   unitofmeasure_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'unitofmeasure_id');
   edUnit.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBNomenclatureTypeOfPrice.edPayKeyPress(
  Sender: TObject; var Key: Char);
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

procedure TfmEditRBNomenclatureTypeOfPrice.chbIsBaseUnitClick(
  Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBNomenclatureTypeOfPrice.bibTypeOfPriceClick(
  Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='typeofprice_id';
  TPRBI.Locate.KeyValues:=typeofprice_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTypeOfPrice,@TPRBI) then begin
   ChangeFlag:=true;
   typeofprice_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'typeofprice_id');
   edTypeOfPrice.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBNomenclatureTypeOfPrice.bibCurrencyClick(
  Sender: TObject);
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

procedure TfmEditRBNomenclatureTypeOfPrice.SetDefaultCurrency;
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Валюта'))+' ');
  if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
    currency_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
    edCurrency.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
  end;
end;

end.
