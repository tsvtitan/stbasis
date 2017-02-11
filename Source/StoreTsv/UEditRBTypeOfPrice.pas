unit UEditRBTypeOfPrice;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBTypeOfPrice = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNote: TLabel;
    meNote: TMemo;
    lbTradingPay: TLabel;
    edTradingPay: TEdit;
    lbTaxFromSale: TLabel;
    edTaxFromSale: TEdit;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edTaxFromSaleKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldtypeofprice_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBTypeOfPrice: TfmEditRBTypeOfPrice;

implementation

uses UStoreTsvCode, UStoreTsvData, UMainUnited, URBTypeOfPrice;

{$R *.DFM}

procedure TfmEditRBTypeOfPrice.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBTypeOfPrice.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbTypeOfPrice,1));
    sqls:='Insert into '+tbTypeOfPrice+
          ' (typeofprice_id,name,note,tradingpay,taxfromsale) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+QuotedStr(Trim(meNote.Lines.Text))+
          ','+QuotedStr(ChangeChar(Trim(edTradingPay.Text),',','.'))+
          ','+QuotedStr(ChangeChar(Trim(edTaxFromSale.Text),',','.'))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldtypeofprice_id:=strtoint(id);

    TfmRBTypeOfPrice(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBTypeOfPrice(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBTypeOfPrice(fmParent).MainQr do begin
      Insert;
      FieldByName('typeofprice_id').AsInteger:=oldtypeofprice_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(meNote.Lines.Text);
      FieldByName('tradingpay').AsFloat:=StrToFloat(Trim(edTradingPay.Text));
      FieldByName('taxfromsale').AsFloat:=StrToFloat(Trim(edTaxFromSale.Text));
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

procedure TfmEditRBTypeOfPrice.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBTypeOfPrice.UpdateRBooks: Boolean;
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

    id:=inttostr(oldtypeofprice_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbTypeOfPrice+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', note='+QuotedStr(Trim(meNote.Lines.Text))+
          ', tradingpay='+QuotedStr(ChangeChar(Trim(edTradingPay.Text),',','.'))+
          ', taxfromsale='+QuotedStr(ChangeChar(Trim(edTaxFromSale.Text),',','.'))+
          ' where typeofprice_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBTypeOfPrice(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBTypeOfPrice(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBTypeOfPrice(fmParent).MainQr do begin
      Edit;
      FieldByName('typeofprice_id').AsInteger:=oldtypeofprice_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(meNote.Lines.Text);
      FieldByName('tradingpay').AsFloat:=StrToFloat(Trim(edTradingPay.Text));
      FieldByName('taxfromsale').AsFloat:=StrToFloat(Trim(edTaxFromSale.Text));
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

procedure TfmEditRBTypeOfPrice.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBTypeOfPrice.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edTradingPay.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTradingPay.Caption]));
    edTradingPay.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edTaxFromSale.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTaxFromSale.Caption]));
    edTaxFromSale.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBTypeOfPrice.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBTypeOfPrice.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  meNote.MaxLength:=DomainNoteLength;
  edTradingPay.MaxLength:=DomainNameMoney;
  edTaxFromSale.MaxLength:=DomainNameMoney;
end;

procedure TfmEditRBTypeOfPrice.edTaxFromSaleKeyPress(Sender: TObject;
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

end.
