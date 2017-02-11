unit UEditDocWarrant;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase,
  IB, ComCtrls;

type
  TfmEditDocWarrant = class(TfmEditRB)
    lbNomenclature: TLabel;
    edNomenclature: TEdit;
    lbUnitOfMeasure: TLabel;
    edUnitOfMeasure: TEdit;
    bibNomenclature: TBitBtn;
    bibUnitOfMeasure: TBitBtn;
    lbAmount: TLabel;
    lbCalcFactor: TLabel;
    edAmount: TEdit;
    edCalcFactor: TEdit;
    procedure edNomenclatureChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibNomenclatureClick(Sender: TObject);
    procedure bibUnitOfMeasureClick(Sender: TObject);
    procedure edCalcFactorKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldwarrantrecord_id: Integer;

    nomenclature_id: Integer;
    unitofmeasure_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditDocWarrant: TfmEditDocWarrant;

implementation

uses UDocTurnTsvCode, UDocTurnTsvData, UMainUnited, UDocWarrant;

{$R *.DFM}

procedure TfmEditDocWarrant.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditDocWarrant.AddToRBooks: Boolean;
begin
  result:=false;
  try
   oldwarrantrecord_id:=GetGenId(IBDB,tbWarrantRecord,1);
   with TfmDocWarrant(fmParent).MemTable do begin
    Append;
    FieldByName('warrantrecord_id').AsInteger:=oldwarrantrecord_id;
    FieldByName('nomenclature_id').AsInteger:=nomenclature_id;
    FieldByName('nomenclaturename').AsString:=Trim(edNomenclature.Text);
    FieldByName('unitofmeasure_id').AsInteger:=unitofmeasure_id;
    FieldByName('unitofmeasurename').AsString:=Trim(edUnitOfMeasure.Text);
    FieldByName('calcfactor').Value:=iff(Trim(edCalcFactor.Text)<>'',StrToFloat(edCalcFactor.Text),null);
    FieldByName('amount').Value:=iff(Trim(edAmount.Text)<>'',StrToFloat(edAmount.Text),null);
    FieldByName('change').AsBoolean:=true;
    FieldByName('isadd').AsBoolean:=true;
    Post;
   end;
   Result:=true;
  except
    on E: Exception do TfmDocWarrant(fmParent).MemTable.Cancel;
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmEditDocWarrant.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditDocWarrant.UpdateRBooks: Boolean;
begin
  result:=false;
  try
   with TfmDocWarrant(fmParent).MemTable do begin
    Edit;
    FieldByName('warrantrecord_id').AsInteger:=oldwarrantrecord_id;
    FieldByName('nomenclature_id').AsInteger:=nomenclature_id;
    FieldByName('nomenclaturename').AsString:=Trim(edNomenclature.Text);
    FieldByName('unitofmeasure_id').AsInteger:=unitofmeasure_id;
    FieldByName('unitofmeasurename').AsString:=Trim(edUnitOfMeasure.Text);
    FieldByName('calcfactor').Value:=iff(Trim(edCalcFactor.Text)<>'',StrToFloat(edCalcFactor.Text),null);
    FieldByName('amount').Value:=iff(Trim(edAmount.Text)<>'',StrToFloat(edAmount.Text),null);
    FieldByName('change').AsBoolean:=true;
    FieldByName('isadd').AsBoolean:=false;
    Post;
   end;
   Result:=true;
  except
    on E: Exception do TfmDocWarrant(fmParent).MemTable.Cancel;
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end;
end;

procedure TfmEditDocWarrant.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditDocWarrant.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNomenclature.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNomenclature.Caption]));
    bibNomenclature.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edUnitOfMeasure.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbUnitOfMeasure.Caption]));
    bibUnitOfMeasure.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditDocWarrant.edNomenclatureChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditDocWarrant.FormCreate(Sender: TObject);
begin
  inherited;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNomenclature.MaxLength:=DomainSmallNameLength;
  edUnitOfMeasure.MaxLength:=DomainNameLength;
  edCalcFactor.MaxLength:=DomainNameMoney;
  edAmount.MaxLength:=DomainNameMoney;

end;

procedure TfmEditDocWarrant.bibNomenclatureClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='nomenclature_id';
  TPRBI.Locate.KeyValues:=nomenclature_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkNomenclature,@TPRBI) then begin
   ChangeFlag:=true;
   nomenclature_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'nomenclature_id');
   edNomenclature.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditDocWarrant.bibUnitOfMeasureClick(Sender: TObject);
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
   edUnitOfMeasure.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditDocWarrant.edCalcFactorKeyPress(Sender: TObject;
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
