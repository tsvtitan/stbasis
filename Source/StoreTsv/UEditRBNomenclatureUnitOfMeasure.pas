unit UEditRBNomenclatureUnitOfMeasure;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBNomenclatureUnitOfMeasure = class(TfmEditRB)
    lbCode: TLabel;
    edCode: TEdit;
    lbUnit: TLabel;
    edUnit: TEdit;
    bibUnit: TBitBtn;
    chbIsBaseUnit: TCheckBox;
    lbWeigth: TLabel;
    lbCalcFactor: TLabel;
    edWeigth: TEdit;
    edCalcFactor: TEdit;
    procedure edCodeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibUnitClick(Sender: TObject);
    procedure edWeigthKeyPress(Sender: TObject; var Key: Char);
    procedure chbIsBaseUnitClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldunitofmeasure_id: Integer;
    nomenclature_id: Integer;
    unitofmeasure_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBNomenclatureUnitOfMeasure: TfmEditRBNomenclatureUnitOfMeasure;

implementation

uses UStoreTsvCode, UStoreTsvData, UMainUnited, URBNomenclature;

{$R *.DFM}

procedure TfmEditRBNomenclatureUnitOfMeasure.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureUnitOfMeasure.AddToRBooks: Boolean;
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
    sqls:='Insert into '+tbNomenclatureUnitOfMeasure+
          ' (nomenclature_id,unitofmeasure_id,isbaseunit,code,weigth,calcfactor) values '+
          ' ('+inttostr(nomenclature_id)+
          ','+inttostr(unitofmeasure_id)+
          ','+inttostr(Integer(chbIsBaseUnit.Checked))+
          ','+iff(trim(edCode.Text)<>'',QuotedStr(Trim(edCode.Text)),'null')+
          ','+QuotedStr(ChangeChar(Trim(edWeigth.Text),',','.'))+
          ','+QuotedStr(ChangeChar(Trim(edCalcFactor.Text),',','.'))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBNomenclature(fmParent).updDetail.InsertSQL.Clear;
    TfmRBNomenclature(fmParent).updDetail.InsertSQL.Add(sqls);

    with TfmRBNomenclature(fmParent).qrDetail do begin
      Insert;
      FieldByName('nomenclature_id').AsInteger:=nomenclature_id;
      FieldByName('unitofmeasure_id').AsInteger:=unitofmeasure_id;
      FieldByName('unitofmeasurename').AsString:=Trim(edUnit.Text);
      FieldByName('isbaseunit').AsInteger:=Integer(chbIsBaseUnit.Checked);
      FieldByName('code').Value:=iff(trim(edCode.Text)<>'',Trim(edCode.Text),Null);
      FieldByName('weigth').AsFloat:=StrToFloat(Trim(edWeigth.Text));
      FieldByName('calcfactor').AsFloat:=StrToFloat(Trim(edCalcFactor.Text));
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

procedure TfmEditRBNomenclatureUnitOfMeasure.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureUnitOfMeasure.UpdateRBooks: Boolean;
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
    sqls:='Update '+tbNomenclatureUnitOfMeasure+
          ' set nomenclature_id='+inttostr(nomenclature_id)+
          ', unitofmeasure_id='+inttostr(unitofmeasure_id)+
          ', isbaseunit='+inttostr(Integer(chbIsBaseUnit.Checked))+
          ', code='+iff(trim(edCode.Text)<>'',QuotedStr(Trim(edCode.Text)),'null')+
          ', weigth='+QuotedStr(ChangeChar(Trim(edWeigth.Text),',','.'))+
          ', calcfactor='+QuotedStr(ChangeChar(Trim(edCalcFactor.Text),',','.'))+
          ' where nomenclature_id='+inttostr(nomenclature_id)+
          ' and unitofmeasure_id='+inttostr(oldunitofmeasure_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBNomenclature(fmParent).updDetail.ModifySQL.Clear;
    TfmRBNomenclature(fmParent).updDetail.ModifySQL.Add(sqls);

    with TfmRBNomenclature(fmParent).qrDetail do begin
      Edit;
      FieldByName('nomenclature_id').AsInteger:=nomenclature_id;
      FieldByName('unitofmeasure_id').AsInteger:=unitofmeasure_id;
      FieldByName('unitofmeasurename').AsString:=Trim(edUnit.Text);
      FieldByName('isbaseunit').AsInteger:=Integer(chbIsBaseUnit.Checked);
      FieldByName('code').Value:=iff(trim(edCode.Text)<>'',Trim(edCode.Text),Null);
      FieldByName('weigth').AsFloat:=StrToFloat(Trim(edWeigth.Text));
      FieldByName('calcfactor').AsFloat:=StrToFloat(Trim(edCalcFactor.Text));
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

procedure TfmEditRBNomenclatureUnitOfMeasure.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureUnitOfMeasure.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edUnit.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbUnit.Caption]));
    bibUnit.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edWeigth.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbWeigth.Caption]));
    edWeigth.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edCalcFactor.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCalcFactor.Caption]));
    edCalcFactor.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBNomenclatureUnitOfMeasure.edCodeChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBNomenclatureUnitOfMeasure.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edUnit.MaxLength:=DomainNameLength;
  edCode.MaxLength:=DomainSmallNameLength;
  edWeigth.MaxLength:=DomainNameMoney;
  edCalcFactor.MaxLength:=DomainNameMoney;
end;

procedure TfmEditRBNomenclatureUnitOfMeasure.bibUnitClick(Sender: TObject);
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

procedure TfmEditRBNomenclatureUnitOfMeasure.edWeigthKeyPress(
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

procedure TfmEditRBNomenclatureUnitOfMeasure.chbIsBaseUnitClick(
  Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
