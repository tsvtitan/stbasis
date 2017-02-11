unit UEditRBNomenclatureProperties;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBNomenclatureProperties = class(TfmEditRB)
    lbNameProperties: TLabel;
    edNameProperties: TEdit;
    lbValueProperties: TLabel;
    edValueProperties: TEdit;
    bibValueProperties: TBitBtn;
    procedure edNamePropertiesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibValuePropertiesClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    nomenclature_id: Integer;
    valueproperties_id: Integer;
    oldvalueproperties_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBNomenclatureProperties: TfmEditRBNomenclatureProperties;

implementation

uses UStoreTsvCode, UStoreTsvData, UMainUnited, URBNomenclature;

{$R *.DFM}

procedure TfmEditRBNomenclatureProperties.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureProperties.AddToRBooks: Boolean;
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
    sqls:='Insert into '+tbNomenclatureValueProperties+
          ' (nomenclature_id,valueproperties_id) values '+
          ' ('+inttostr(nomenclature_id)+
          ','+inttostr(valueproperties_id)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBNomenclature(fmParent).updDetail.InsertSQL.Clear;
    TfmRBNomenclature(fmParent).updDetail.InsertSQL.Add(sqls);

    with TfmRBNomenclature(fmParent).qrDetail do begin
      Insert;
      FieldByName('nomenclature_id').AsInteger:=nomenclature_id;
      FieldByName('valueproperties_id').AsInteger:=valueproperties_id;
      FieldByName('nameproperties').AsString:=Trim(edNameProperties.Text);
      FieldByName('valueproperties').AsString:=Trim(edValueProperties.Text);
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

procedure TfmEditRBNomenclatureProperties.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureProperties.UpdateRBooks: Boolean;
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
    sqls:='Update '+tbNomenclatureValueProperties+
          ' set nomenclature_id='+inttostr(nomenclature_id)+
          ', valueproperties_id='+inttostr(valueproperties_id)+
          ' where nomenclature_id='+inttostr(nomenclature_id)+
          ' and valueproperties_id='+inttostr(oldvalueproperties_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBNomenclature(fmParent).updDetail.ModifySQL.Clear;
    TfmRBNomenclature(fmParent).updDetail.ModifySQL.Add(sqls);

    with TfmRBNomenclature(fmParent).qrDetail do begin
      Edit;
      FieldByName('nomenclature_id').AsInteger:=nomenclature_id;
      FieldByName('valueproperties_id').AsInteger:=valueproperties_id;
      FieldByName('nameproperties').AsString:=Trim(edNameProperties.Text);
      FieldByName('valueproperties').AsString:=Trim(edValueProperties.Text);
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

procedure TfmEditRBNomenclatureProperties.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclatureProperties.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edValueProperties.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbValueProperties.Caption]));
    bibValueProperties.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBNomenclatureProperties.edNamePropertiesChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBNomenclatureProperties.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNameProperties.MaxLength:=DomainNameLength;
  edValueProperties.MaxLength:=DomainNameLength;
end;

procedure TfmEditRBNomenclatureProperties.bibValuePropertiesClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='valueproperties_id';
  TPRBI.Locate.KeyValues:=valueproperties_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkValueProperties,@TPRBI) then begin
   ChangeFlag:=true;
   valueproperties_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueproperties_id');
   edValueProperties.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueproperties');
   edNameProperties.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'nameproperties');
  end;
end;

end.
