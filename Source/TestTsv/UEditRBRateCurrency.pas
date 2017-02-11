unit UEditRBRateCurrency;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBRateCurrency = class(TfmEditRB)
    lbFactor: TLabel;
    edFactor: TEdit;
    lbCurrency: TLabel;
    edCurrency: TEdit;
    bibCurrency: TBitBtn;
    lbInDate: TLabel;
    dtpInDate: TDateTimePicker;
    procedure edFactorChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edFactorKeyPress(Sender: TObject; var Key: Char);
    procedure bibCurrencyClick(Sender: TObject);
    procedure dtpInDateChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldratecurrency_id: Integer;
    currency_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBRateCurrency: TfmEditRBRateCurrency;

implementation

uses UTestTsvCode, UTestTsvData, UMainUnited;

{$R *.DFM}

procedure TfmEditRBRateCurrency.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBRateCurrency.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbRateCurrency,1));
    sqls:='Insert into '+tbRateCurrency+
          ' (ratecurrency_id,currency_id,indate,factor) values '+
          ' ('+id+
          ','+inttostr(currency_id)+
          ','+QuotedStr(DateTimeToStr(dtpInDate.Date))+
          ','+QuotedStr(ChangeChar(Trim(edFactor.Text),',','.'))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldratecurrency_id:=strtoint(id);

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

procedure TfmEditRBRateCurrency.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBRateCurrency.UpdateRBooks: Boolean;
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

    id:=inttostr(oldratecurrency_id);//fmRBRateCurrency.MainQr.FieldByName('ratecurrency_id').AsString;
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbRateCurrency+
          ' set currency_id='+inttostr(currency_id)+
          ', indate='+QuotedStr(DateTimeToStr(dtpInDate.Date))+
          ', factor='+QuotedStr(ChangeChar(Trim(edFactor.Text),',','.'))+
          ' where ratecurrency_id='+id;
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

procedure TfmEditRBRateCurrency.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBRateCurrency.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edCurrency.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCurrency.Caption]));
    bibCurrency.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edFactor.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFactor.Caption]));
    edFactor.SetFocus;
    Result:=false;
    exit;
  end else begin
    if not isFloat(edFactor.Text) then begin
     ShowErrorEx(Format(ConstFieldFormatInvalid,[lbFactor.Caption]));
     edFactor.SetFocus;
     Result:=false;
     exit;
    end;
  end;
end;

procedure TfmEditRBRateCurrency.edFactorChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBRateCurrency.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edFactor.MaxLength:=DomainNameMoney;
  edCurrency.MaxLength:=DomainNameLength;
  dtpInDate.Date:=_GetDateTimeFromServer;
end;

procedure TfmEditRBRateCurrency.edFactorKeyPress(Sender: TObject;
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

procedure TfmEditRBRateCurrency.bibCurrencyClick(Sender: TObject);
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

procedure TfmEditRBRateCurrency.dtpInDateChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
