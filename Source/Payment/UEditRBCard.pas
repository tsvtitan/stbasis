unit UEditRBCard;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBCard = class(TfmEditRB)
    lbNum: TLabel;
    edNum: TEdit;
    lbDateBegin: TLabel;
    dtpDateBegin: TDateTimePicker;
    lbDateEnd: TLabel;
    dtpDateEnd: TDateTimePicker;
    lbSer: TLabel;
    edSer: TEdit;
    edNominal: TEdit;
    lbNominal: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNumChange(Sender: TObject);
    procedure edNominalChange(Sender: TObject);
    procedure edNominalKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldcard_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBCard: TfmEditRBCard;

implementation

uses UPaymentCode, UPaymentData, UMainUnited, URBCard;

{$R *.DFM}

procedure TfmEditRBCard.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBCard.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbCard,1));
    sqls:='Insert into '+tbCard+
          ' (card_id,ser_card,num_card,nominal,date_begin,date_end) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edSer.text))+
          ','+QuotedStr(Trim(edNum.text))+
          ','+iff(trim(edNominal.Text)<>'',QuotedStr(ChangeChar(edNominal.Text,',','.')),'null')+
          ','+QuotedStr(DateToStr(dtpDateBegin.Date))+
          ','+QuotedStr(DateToStr(dtpDateEnd.Date))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldcard_id:=strtoint(id);

    TfmRBCard(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBCard(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBCard(fmParent).MainQr do begin
      Insert;
      FieldByName('card_id').AsInteger:=oldcard_id;
      FieldByName('ser_card').AsString:=Trim(edSer.text);
      FieldByName('num_card').AsString:=Trim(edNum.text);
      FieldByName('nominal').Value:=iff(trim(edNominal.Text)<>'',edNominal.Text,Null);
      FieldByName('date_begin').Value:=dtpDateBegin.Date;
      FieldByName('date_end').Value:=dtpDateEnd.Date;
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

procedure TfmEditRBCard.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBCard.UpdateRBooks: Boolean;
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

    id:=inttostr(oldcard_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbCard+
          ' set ser_card='+QuotedStr(Trim(edSer.text))+
          ', num_card='+QuotedStr(Trim(edNum.text))+
          ', nominal='+iff(trim(edNominal.Text)<>'',QuotedStr(ChangeChar(edNominal.Text,',','.')),'null')+
          ', date_begin='+QuotedStr(DateToStr(dtpDateBegin.Date))+
          ', date_end='+QuotedStr(DateToStr(dtpDateEnd.Date))+
          ' where card_id='+id;

    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBCard(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBCard(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBCard(fmParent).MainQr do begin
      Edit;
      FieldByName('card_id').AsInteger:=oldcard_id;
      FieldByName('ser_card').AsString:=Trim(edSer.text);
      FieldByName('num_card').AsString:=Trim(edNum.text);
      FieldByName('nominal').Value:=iff(trim(edNominal.Text)<>'',edNominal.Text,Null);
      FieldByName('date_begin').Value:=dtpDateBegin.Date;
      FieldByName('date_end').Value:=dtpDateEnd.Date;
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

procedure TfmEditRBCard.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBCard.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSer.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSer.Caption]));
    edSer.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNominal.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNominal.Caption]));
    edNominal.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBCard.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edSer.MaxLength:=50;
  edNum.MaxLength:=50;
  edNominal.MaxLength:=DomainNameMoney;
  dtpDateBegin.Date:=_GetDateTimeFromServer;
  dtpDateEnd.Date:=IncMonth(dtpDateBegin.Date,6);
end;

procedure TfmEditRBCard.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBCard.edNumChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBCard.edNominalChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBCard.edNominalKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [',','.',DecimalSeparator] then Key:=DecimalSeparator;
end;

end.
