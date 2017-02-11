unit UEditRBNomenclature;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBNomenclature = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNdsRate: TLabel;
    edNdsRate: TEdit;
    lbNpRate: TLabel;
    edNpRate: TEdit;
    lbNum: TLabel;
    edNum: TEdit;
    edFullName: TEdit;
    lbFullName: TLabel;
    lbGroup: TLabel;
    edGroup: TEdit;
    bibGroup: TBitBtn;
    lbArticle: TLabel;
    edArticle: TEdit;
    lbOkdp: TLabel;
    edOkdp: TEdit;
    lbViewOfGoods: TLabel;
    cmbViewOfGoods: TComboBox;
    lbTypeOfGoods: TLabel;
    cmbTypeOfGoods: TComboBox;
    lbGtdNum: TLabel;
    edGtdNum: TEdit;
    bibGtdNum: TBitBtn;
    lbCountryName: TLabel;
    edCountryName: TEdit;
    bibCountryName: TBitBtn;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edNpRateKeyPress(Sender: TObject; var Key: Char);
    procedure bibGroupClick(Sender: TObject);
    procedure bibGtdNumClick(Sender: TObject);
    procedure edGtdNumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibCountryNameClick(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    isNoTreeView: Boolean;
    fmParent: TForm;
    oldnomenclaturegroup_id: Integer;
    nomenclaturegroup_id: Integer;
    gtd_id: Integer;
    country_id: Integer;
    oldnomenclature_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
    procedure SetDefaultCountry;
  end;

var
  fmEditRBNomenclature: TfmEditRBNomenclature;

implementation

uses UStoreTsvCode, UStoreTsvData, UMainUnited, URBNomenclature;

{$R *.DFM}

procedure TfmEditRBNomenclature.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclature.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbNomenclature,1));
    sqls:='Insert into '+tbNomenclature+
          ' (nomenclature_id,num,name,fullname,article,okdp,nomenclaturegroup_id,'+
          'viewofgoods,typeofgoods,gtd_id,country_id,ndsrate,nprate) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edNum.Text))+
          ','+QuotedStr(Trim(edName.Text))+
          ','+QuotedStr(Trim(edFullName.Text))+
          ','+QuotedStr(Trim(edArticle.Text))+
          ','+iff(trim(edOkdp.Text)<>'',QuotedStr(Trim(edOkdp.Text)),'null')+
          ','+inttostr(nomenclaturegroup_id)+
          ','+inttostr(cmbViewOfGoods.ItemIndex)+
          ','+inttostr(cmbTypeOfGoods.ItemIndex)+
          ','+iff(trim(edGtdNum.Text)<>'',inttostr(gtd_id),'null')+
          ','+inttostr(country_id)+
          ','+QuotedStr(ChangeChar(Trim(edNdsRate.Text),',','.'))+
          ','+QuotedStr(ChangeChar(Trim(edNpRate.Text),',','.'))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldnomenclature_id:=strtoint(id);

    if (not isNoTreeView and (oldnomenclaturegroup_id=nomenclaturegroup_id)) or
       isNoTreeView then begin

      TfmRBNomenclature(fmParent).IBUpd.InsertSQL.Clear;
      TfmRBNomenclature(fmParent).IBUpd.InsertSQL.Add(sqls);

      with TfmRBNomenclature(fmParent).MainQr do begin
        Insert;
        FieldByName('nomenclature_id').AsInteger:=oldnomenclature_id;
        FieldByName('num').AsString:=Trim(edNum.Text);
        FieldByName('name').AsString:=Trim(edName.Text);
        FieldByName('fullname').AsString:=Trim(edFullName.Text);
        FieldByName('article').AsString:=Trim(edArticle.Text);
        FieldByName('okdp').Value:=iff(trim(edOkdp.Text)<>'',Trim(edOkdp.Text),Null);
        FieldByName('nomenclaturegroup_id').AsInteger:=nomenclaturegroup_id;
        FieldByName('nomenclaturegroupname').AsString:=Trim(edGroup.Text);
        FieldByName('viewofgoods').AsInteger:=cmbViewOfGoods.ItemIndex;
        FieldByName('typeofgoods').AsInteger:=cmbTypeOfGoods.ItemIndex;
        FieldByName('gtd_id').Value:=iff(trim(edGtdNum.Text)<>'',inttostr(gtd_id),Null);
        FieldByName('gtdnum').Value:=iff(trim(edGtdNum.Text)<>'',trim(edGtdNum.Text),Null);
        FieldByName('country_id').AsInteger:=country_id;
        FieldByName('countryname').AsString:=Trim(edCountryName.Text);
        FieldByName('ndsrate').AsFloat:=StrToFloat(Trim(edNdsRate.Text));
        FieldByName('nprate').AsFloat:=StrToFloat(Trim(edNpRate.Text));
        Post;
      end;
      
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

procedure TfmEditRBNomenclature.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclature.UpdateRBooks: Boolean;
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

    id:=inttostr(oldnomenclature_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbNomenclature+
          ' set num='+QuotedStr(Trim(edNum.Text))+
          ', name='+QuotedStr(Trim(edName.Text))+
          ', fullname='+QuotedStr(Trim(edFullName.Text))+
          ', article='+QuotedStr(Trim(edArticle.Text))+
          ', okdp='+iff(trim(edOkdp.Text)<>'',QuotedStr(Trim(edOkdp.Text)),'null')+
          ', nomenclaturegroup_id='+inttostr(nomenclaturegroup_id)+
          ', viewofgoods='+inttostr(cmbViewOfGoods.ItemIndex)+
          ', typeofgoods='+inttostr(cmbTypeOfGoods.ItemIndex)+
          ', gtd_id='+iff(trim(edGtdNum.Text)<>'',inttostr(gtd_id),'null')+
          ', country_id='+inttostr(country_id)+
          ', ndsrate='+QuotedStr(ChangeChar(Trim(edNdsRate.Text),',','.'))+
          ', nprate='+QuotedStr(ChangeChar(Trim(edNpRate.Text),',','.'))+
          ' where nomenclature_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    if (not isNoTreeView and (oldnomenclaturegroup_id=nomenclaturegroup_id)) or
       isNoTreeView then begin

      TfmRBNomenclature(fmParent).IBUpd.ModifySQL.Clear;
      TfmRBNomenclature(fmParent).IBUpd.ModifySQL.Add(sqls);

      with TfmRBNomenclature(fmParent).MainQr do begin
        Edit;
        FieldByName('nomenclature_id').AsInteger:=oldnomenclature_id;
        FieldByName('num').AsString:=Trim(edNum.Text);
        FieldByName('name').AsString:=Trim(edName.Text);
        FieldByName('fullname').AsString:=Trim(edFullName.Text);
        FieldByName('article').AsString:=Trim(edArticle.Text);
        FieldByName('okdp').Value:=iff(trim(edOkdp.Text)<>'',Trim(edOkdp.Text),Null);
        FieldByName('nomenclaturegroup_id').AsInteger:=nomenclaturegroup_id;
        FieldByName('nomenclaturegroupname').AsString:=Trim(edGroup.Text);
        FieldByName('viewofgoods').AsInteger:=cmbViewOfGoods.ItemIndex;
        FieldByName('typeofgoods').AsInteger:=cmbTypeOfGoods.ItemIndex;
        FieldByName('gtd_id').Value:=iff(trim(edGtdNum.Text)<>'',inttostr(gtd_id),Null);
        FieldByName('gtdnum').Value:=iff(trim(edGtdNum.Text)<>'',trim(edGtdNum.Text),Null);
        FieldByName('country_id').AsInteger:=country_id;
        FieldByName('countryname').AsString:=Trim(edCountryName.Text);
        FieldByName('ndsrate').AsFloat:=StrToFloat(Trim(edNdsRate.Text));
        FieldByName('nprate').AsFloat:=StrToFloat(Trim(edNpRate.Text));
        Post;
      end;

    end else begin

      sqls:='Delete from '+tbNomenclature+' where nomenclature_id='+inttostr(oldnomenclature_id);
      
      TfmRBNomenclature(fmParent).IBUpd.DeleteSQL.Clear;
      TfmRBNomenclature(fmParent).IBUpd.DeleteSQL.Add(sqls);

      TfmRBNomenclature(fmParent).MainQr.Delete;

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

procedure TfmEditRBNomenclature.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBNomenclature.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edGroup.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbGroup.Caption]));
    bibGroup.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edFullName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFullName.Caption]));
    edFullName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edArticle.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbArticle.Caption]));
    edArticle.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNdsRate.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNdsRate.Caption]));
    edNdsRate.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edCountryName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCountryName.Caption]));
    bibCountryName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNpRate.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNpRate.Caption]));
    edNpRate.SetFocus;
    Result:=false;
    exit;
  end;

end;

procedure TfmEditRBNomenclature.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBNomenclature.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edGroup.MaxLength:=DomainNameLength;
  edNum.MaxLength:=DomainSmallNameLength;
  edName.MaxLength:=DomainSmallNameLength;
  edFullName.MaxLength:=DomainNameLength;
  edArticle.MaxLength:=DomainSmallNameLength;
  edOkdp.MaxLength:=DomainSmallNameLength;
  edGtdNum.MaxLength:=DomainSmallNameLength;
  edNdsRate.MaxLength:=DomainNameMoney;
  edCountryName.MaxLength:=DomainNameLength;
  edNPRate.MaxLength:=DomainNameMoney;

  cmbViewOfGoods.Clear;
  for i:=0 to 2 do cmbViewOfGoods.Items.Add(GetViewOfGoodsByValue(i));
  cmbViewOfGoods.ItemIndex:=0;

  cmbTypeOfGoods.Clear;
  for i:=0 to 1 do cmbTypeOfGoods.Items.Add(GetTypeOfGoodsByValue(i));
  cmbTypeOfGoods.ItemIndex:=0;
   
end;

procedure TfmEditRBNomenclature.edNpRateKeyPress(Sender: TObject;
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

procedure TfmEditRBNomenclature.bibGroupClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='nomenclaturegroup_id';
  TPRBI.Locate.KeyValues:=nomenclaturegroup_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkNomenclatureGroup,@TPRBI) then begin
   ChangeFlag:=true;
   nomenclaturegroup_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'nomenclaturegroup_id');
   edGroup.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBNomenclature.bibGtdNumClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='gtd_id';
  TPRBI.Locate.KeyValues:=gtd_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkGTD,@TPRBI) then begin
   ChangeFlag:=true;
   gtd_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'gtd_id');
   edGtdNum.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'num');
  end;
end;

procedure TfmEditRBNomenclature.edGtdNumKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);

  procedure ClearGtd;
  begin
    if Length(edGtdNum.Text)=Length(edGtdNum.SelText) then begin
      edGtdNum.Text:='';
      gtd_id:=0;
    end;
  end;

begin
  case Key of
    VK_DELETE,VK_BACK: ClearGtd;
  end;
end;

procedure TfmEditRBNomenclature.bibCountryNameClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='country_id';
  TPRBI.Locate.KeyValues:=country_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkCountry,@TPRBI) then begin
   ChangeFlag:=true;
   country_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'country_id');
   edCountryName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBNomenclature.SetDefaultCountry;
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Страна'))+' ');
  if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
    country_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'valuetable');
    edCountryName.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'valueview');
  end;
end;

end.
