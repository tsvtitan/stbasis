unit UDocWarrant;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UDocMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus , tsvDbGrid, IBUpdateSQL,
  ComCtrls,UMainUnited;

type
   TfmDocWarrant = class(TfmDocMainGrid)
    lbDateTo: TLabel;
    dtpDateTo: TDateTimePicker;
    lbGrantee: TLabel;
    edGrantee: TEdit;
    bibGrantee: TBitBtn;
    lbRespondent: TLabel;
    edRespondent: TEdit;
    bibRespondent: TBitBtn;
    lbSupplier: TLabel;
    edSupplier: TEdit;
    bibSupplier: TBitBtn;
    grbBase: TGroupBox;
    lbBaseDocum: TLabel;
    edBaseDocum: TEdit;
    bibBaseDocum: TBitBtn;
    lbBaseText: TLabel;
    lbNote: TLabel;
    meNote: TMemo;
    edBaseText: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibGranteeClick(Sender: TObject);
    procedure bibSupplierClick(Sender: TObject);
    procedure bibRespondentClick(Sender: TObject);
    procedure bibBaseDocumClick(Sender: TObject);
    procedure dtpDateChange(Sender: TObject);
    procedure edBaseDocumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNumberChange(Sender: TObject);
    procedure bibPrintClick(Sender: TObject);
  private
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function CheckFieldsFill: Boolean; override;
    function AddHeadAndRecord: Boolean; override;
    function ChangeHeadAndRecord: Boolean; override;
    procedure RefreshNeededInterface;override;
    procedure AddOrChangeRecord; override;
    procedure DeleteRecords; override;
    function CheckPermissionPrint: Boolean; override;
  public
    grantee_id: Variant;
    supplier_id: Variant;
    respondents_id: Variant;
    basedocum_id: Variant;
    procedure ActiveQuery(CheckPerm: Boolean);override;
    procedure SetDefaultGrantee;
  end;

var
  fmDocWarrant: TfmDocWarrant;

implementation

uses UDocTurnTsvCode, UDocTurnTsvDM, UDocTurnTsvData, UEditDocWarrant;

{$R *.DFM}

const
  WarrantSizeDate=10;

procedure TfmDocWarrant.FormCreate(Sender: TObject);
var
  cl: TColumn;
  curdate: TDate;
  ifl: TIntegerField;
  sfl: TStringField;
  bfl: TIBBCDField;
  blfl: TBooleanField;
begin
 inherited;
 try
  Caption:=NameDocWarrantHead;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  curdate:=_GetDateTimeFromServer;
  dtpDate.Date:=curdate;
  dtpDateTo.Date:=dtpDate.Date+WarrantSizeDate;
  edGrantee.MaxLength:=DomainSmallNameLength;
  edRespondent.MaxLength:=DomainSmallNameLength*3;
  edSupplier.MaxLength:=DomainSmallNameLength;
  edBaseDocum.MaxLength:=DomainSmallNameLength*2;
  edBaseText.MaxLength:=DomainNoteLength;
  meNote.MaxLength:=DomainNoteLength;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='warrantrecord_id';
  ifl.DataSet:=MemTable;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='nomenclature_id';
  ifl.DataSet:=MemTable;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='nomenclaturename';
  sfl.DataSet:=MemTable;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Номенклатура';
  cl.Width:=100;

  ifl:=TIntegerField.Create(nil);
  ifl.FieldName:='unitofmeasure_id';
  ifl.DataSet:=MemTable;

  sfl:=TStringField.Create(nil);
  sfl.FieldName:='unitofmeasurename';
  sfl.DataSet:=MemTable;

  cl:=Grid.Columns.Add;
  cl.Field:=sfl;
  cl.Title.Caption:='Единица измерения';
  cl.Width:=85;

  bfl:=TIBBCDField.Create(nil);
  bfl.FieldName:='amount';
  bfl.Precision:=DomainMoneyPrecision;
  bfl.Size:=DomainMoneySize;
  bfl.Required:=false;
  bfl.DataSet:=MemTable;

  cl:=Grid.Columns.Add;
  cl.Field:=bfl;
  cl.Title.Caption:='Количество';
  cl.Width:=50;

  bfl:=TIBBCDField.Create(nil);
  bfl.FieldName:='calcfactor';
  bfl.Precision:=DomainMoneyPrecision;
  bfl.Size:=DomainMoneySize;
  bfl.Required:=false;
  bfl.DataSet:=MemTable;

  cl:=Grid.Columns.Add;
  cl.Field:=bfl;
  cl.Title.Caption:='Коэффициент пересчета';
  cl.Width:=25;

  blfl:=TBooleanField.Create(nil);
  blfl.FieldName:='change';
  blfl.DataSet:=MemTable;

  blfl:=TBooleanField.Create(nil);
  blfl.FieldName:='isadd';
  blfl.DataSet:=MemTable;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmDocWarrant.FormDestroy(Sender: TObject);
begin
  inherited;
  ListDocums.Remove(Self);
  if FormState=[fsCreatedMDIChild] then
   fmDocWarrant:=nil;
end;

procedure TfmDocWarrant.ActiveQuery(CheckPerm: Boolean);
var
  TPRBI: TParamRBookInterface;
  TPRBIRecord: TParamRBookInterface;
  i,S,E: Integer;
begin
  try
    inherited;
    if TypeOperation<>todAdd then begin
      FillChar(TPRBI,SizeOf(TPRBI),0);
      TPRBI.Visual.TypeView:=tviOnlyData;
      TPRBI.SQL.Select:=PChar(SQLDocWarrantHead);
      TPRBI.Condition.WhereStr:=PChar(' wh.docum_id='+inttostr(DocumentId)+' ');
      if _ViewInterfaceFromName(NameRbkQuery,@TPRBI) then begin
       if ifExistsDataInParamRBookInterface(@TPRBI) then begin
        dtpDateTo.Date:=GetFirstValueFromPRBI(@TPRBI,'realydate');
        edGrantee.Text:=GetFirstValueFromPRBI(@TPRBI,'granteesmallname');
        grantee_id:=GetFirstValueFromPRBI(@TPRBI,'grantee_id');
        edRespondent.Text:=GetFirstValueFromPRBI(@TPRBI,'respondentsname');
        respondents_id:=GetFirstValueFromPRBI(@TPRBI,'respondents_id');
        edSupplier.Text:=GetFirstValueFromPRBI(@TPRBI,'suppliersmallname');
        supplier_id:=GetFirstValueFromPRBI(@TPRBI,'supplier_id');
        if not VarIsEmpty(GetFirstValueFromPRBI(@TPRBI,'basedocumtypedocname')) then 
         edBaseDocum.Text:=GetFirstValueFromPRBI(@TPRBI,'basedocumtypedocname')+' '+
                           GetFirstValueFromPRBI(@TPRBI,'basedocumnum')+' от '+
                           VarToStr(GetFirstValueFromPRBI(@TPRBI,'basedocumdatedoc'));
        basedocum_id:=GetFirstValueFromPRBI(@TPRBI,'basedocum_id');
        edBaseText.Text:=GetFirstValueFromPRBI(@TPRBI,'basetext');
        meNote.Lines.Text:=GetFirstValueFromPRBI(@TPRBI,'note');

        Screen.Cursor:=crHourGlass;
        MemTable.DisableControls;
        try
          MemTable.Active:=true;
          FillChar(TPRBIRecord,SizeOf(TPRBIRecord),0);
          TPRBIRecord.Visual.TypeView:=tviOnlyData;
          TPRBIRecord.SQL.Select:=PChar(SQLDocWarrantRecord);
          TPRBIRecord.Condition.WhereStr:=PChar(' wr.docum_id='+inttostr(DocumentId)+' ');
          if _ViewInterfaceFromName(NameRbkQuery,@TPRBIRecord) then begin
            GetStartAndEndByPRBI(@TPRBIRecord,S,E);
            for i:=S to E do begin
              with MemTable do begin
                Append;
                FieldByName('warrantrecord_id').AsInteger:=GetValueByPRBI(@TPRBIRecord,i,'warrantrecord_id');
                FieldByName('nomenclature_id').AsInteger:=GetValueByPRBI(@TPRBIRecord,i,'nomenclature_id');
                FieldByName('nomenclaturename').AsString:=GetValueByPRBI(@TPRBIRecord,i,'nomenclaturename');
                FieldByName('unitofmeasure_id').AsInteger:=GetValueByPRBI(@TPRBIRecord,i,'unitofmeasure_id');
                FieldByName('unitofmeasurename').AsString:=GetValueByPRBI(@TPRBIRecord,i,'unitofmeasurename');
                FieldByName('amount').AsFloat:=GetValueByPRBI(@TPRBIRecord,i,'amount');
                FieldByName('calcfactor').AsFloat:=GetValueByPRBI(@TPRBIRecord,i,'calcfactor');
                FieldByName('change').AsBoolean:=false;
                FieldByName('isadd').AsBoolean:=false;
                Post;
              end;
            end;
          end;
        finally
          MemTable.First;
          MemTable.EnableControls;
          Screen.Cursor:=crDefault;
        end;
       end;
      end;
    end else begin
      SetDefaultGrantee;
    end;
    MemTable.Active:=true;
    ViewCount;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmDocWarrant.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
begin
 try
   if not MemTable.Active then exit;
   fn:=Column.FieldName;
   case TypeSort of
     tcsAsc: MemTable.SortOnFields(fn,true,false);
     tcsDesc: MemTable.SortOnFields(fn,true,true);
   end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmDocWarrant.GridDblClick(Sender: TObject);
begin
  if not MemTable.Active then exit;
  if MemTable.RecordCount=0 then exit;
  if bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmDocWarrant.LoadFromIni;
begin
 inherited;
end;

procedure TfmDocWarrant.SaveToIni;
begin
 inherited;
end;

procedure TfmDocWarrant.bibAddClick(Sender: TObject);
var
  fm: TfmEditDocWarrant;
begin
  if not MemTable.Active then exit;
  fm:=TfmEditDocWarrant.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.AddClick;
    fm.Caption:=CaptionAdd;
    if fm.ShowModal=mrok then begin
     ChangeFlag:=true;
     ViewCount;
     MemTable.Locate('warrantrecord_id',fm.oldwarrantrecord_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmDocWarrant.bibChangeClick(Sender: TObject);
var
  fm: TfmEditDocWarrant;
begin
  if not MemTable.Active then exit;
  if MemTable.IsEmpty then exit;
  fm:=TfmEditDocWarrant.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.edNomenclature.Text:=MemTable.fieldByName('nomenclaturename').AsString;
    fm.nomenclature_id:=MemTable.fieldByName('nomenclature_id').AsInteger;
    fm.edUnitOfMeasure.Text:=MemTable.fieldByName('unitofmeasurename').AsString;
    fm.unitofmeasure_id:=MemTable.fieldByName('unitofmeasure_id').AsInteger;
    fm.edCalcFactor.Text:=MemTable.fieldByName('calcfactor').AsString;
    fm.edAmount.Text:=MemTable.fieldByName('amount').AsString;
    fm.oldwarrantrecord_id:=MemTable.FieldByName('warrantrecord_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ChangeFlag:=true;
     MemTable.Locate('warrantrecord_id',fm.oldwarrantrecord_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmDocWarrant.bibDelClick(Sender: TObject);
var
  but: Integer;
begin
  if MemTable.IsEmpty then exit;
  but:=DeleteWarningEx('текущую запись ?');
  if but=mrYes then begin
    ChangeFlag:=true;
    ListDeleteRecords.Add(Pointer(MemTable.FieldByName('warrantrecord_id').AsInteger));
    MemTable.Delete;
    ViewCount;
  end;
end;

procedure TfmDocWarrant.bibViewClick(Sender: TObject);
var
  fm: TfmEditDocWarrant;
begin
  if not MemTable.Active then exit;
  if MemTable.IsEmpty then exit;
  fm:=TfmEditDocWarrant.Create(nil);
  try
    fm.bibOk.OnClick:=nil;
    fm.bibOk.Visible:=false;
    fm.bibCancel.Caption:=CaptionClose;
    fm.Caption:=CaptionView;
    fm.edNomenclature.Text:=MemTable.fieldByName('nomenclaturename').AsString;
    fm.nomenclature_id:=MemTable.fieldByName('nomenclature_id').AsInteger;
    fm.edUnitOfMeasure.Text:=MemTable.fieldByName('unitofmeasurename').AsString;
    fm.unitofmeasure_id:=MemTable.fieldByName('unitofmeasure_id').AsInteger;
    fm.edCalcFactor.Text:=MemTable.fieldByName('calcfactor').AsString;
    fm.edAmount.Text:=MemTable.fieldByName('amount').AsString;
    fm.oldwarrantrecord_id:=MemTable.FieldByName('warrantrecord_id').AsInteger;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmDocWarrant.bibGranteeClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='plant_id';
  TPRBI.Locate.KeyValues:=grantee_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPlant,@TPRBI) then begin
   ChangeFlag:=true;
   grantee_id:=GetFirstValueFromPRBI(@TPRBI,'plant_id');
   edGrantee.Text:=GetFirstValueFromPRBI(@TPRBI,'smallname');
  end;
end;

procedure TfmDocWarrant.bibSupplierClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='plant_id';
  TPRBI.Locate.KeyValues:=supplier_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkPlant,@TPRBI) then begin
   ChangeFlag:=true;
   supplier_id:=GetFirstValueFromPRBI(@TPRBI,'plant_id');
   edSupplier.Text:=GetFirstValueFromPRBI(@TPRBI,'smallname');
  end;
end;

procedure TfmDocWarrant.bibRespondentClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='respondents_id';
  TPRBI.Locate.KeyValues:=respondents_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkRespondents,@TPRBI) then begin
   ChangeFlag:=true;
   respondents_id:=GetFirstValueFromPRBI(@TPRBI,'respondents_id');
   edRespondent.Text:=GetFirstValueFromPRBI(@TPRBI,'fname')+' '+
                      GetFirstValueFromPRBI(@TPRBI,'name')+' '+
                      GetFirstValueFromPRBI(@TPRBI,'sname');
  end;
end;

procedure TfmDocWarrant.bibBaseDocumClick(Sender: TObject);
var
  TPJI: TParamJournalInterface;
begin
  FillChar(TPJI,SizeOf(TPJI),0);
  TPJI.Visual.TypeView:=tvibvModal;
  TPJI.Locate.KeyFields:='docum_id';
  TPJI.Locate.KeyValues:=basedocum_id;
  TPJI.Locate.Options:=[loCaseInsensitive];
  TPJI.Condition.WhereStrNoRemoved:=PChar(' '+tbDocum+'.typedoc_id in (select whattypedoc_id from '+
                                          tbBasisTypeDoc+' where fortypedoc_id='+inttostr(TypeDocID)+') ');
  if _ViewInterfaceFromName(NameJrDocum,@TPJI) then begin
   if ifExistsDataInPJI(@TPJI) then begin
    ChangeFlag:=true;
    basedocum_id:=GetFirstValueFromPJI(@TPJI,'docum_id');
    edBaseDocum.Text:=GetFirstValueFromPJI(@TPJI,'typedocname')+' '+
                     GetFirstValueFromPJI(@TPJI,'prefixnumsufix')+' от '+
                     VarToStr(GetFirstValueFromPJI(@TPJI,'datedoc'));
    if Trim(edBaseText.Text)='' then edBaseText.Text:=edBaseDocum.Text;
   end;  
  end;
end;

procedure TfmDocWarrant.dtpDateChange(Sender: TObject);
begin
  inherited;
  dtpDateTo.Date:=dtpDate.Date+WarrantSizeDate;
end;

procedure TfmDocWarrant.SetDefaultGrantee;
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tviOnlyData;
  TPRBI.Condition.WhereStr:=PChar(' Upper(name)='+QuotedStr(AnsiUpperCase('Предприятие'))+' ');
  if _ViewInterfaceFromName(NameRbkConsts,@TPRBI) then begin
    grantee_id:=GetFirstValueFromPRBI(@TPRBI,'valuetable');
    edGrantee.Text:=GetFirstValueFromPRBI(@TPRBI,'valueview');
  end;
end;

function TfmDocWarrant.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNumber.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNumber.Caption]));
    edNumber.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edGrantee.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbGrantee.Caption]));
    pcMain.ActivePage:=tsRequisitions;
    bibGrantee.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edRespondent.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbRespondent.Caption]));
    pcMain.ActivePage:=tsRequisitions;
    bibRespondent.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edSupplier.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbSupplier.Caption]));
    pcMain.ActivePage:=tsRequisitions;
    bibSupplier.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmDocWarrant.edBaseDocumKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_DELETE)or(Key=VK_BACK) then begin
    edBaseDocum.Text:='';
    basedocum_id:=0;
  end;
end;

function TfmDocWarrant.AddHeadAndRecord: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: string;
begin
 Result:=false;
 if not AddToJournalDocument(IBDB) then exit;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=Inttostr(DocumentId);
    qr.Database:=IBDB;
    qr.ParamCheck:=false;
    qr.Transaction:=ibtran;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+tbWarrantHead+
          ' (docum_id,basedocum_id,basetext,grantee_id,supplier_id,respondents_id,realydate,note) values'+
          ' ('+id+
          ','+iff(Trim(edBaseDocum.Text)<>'',inttostr(basedocum_id),'null')+
          ','+iff(Trim(edBaseText.Text)<>'',QuotedStr(Trim(edBaseText.Text)),'null')+
          ','+inttostr(grantee_id)+
          ','+inttostr(supplier_id)+
          ','+inttostr(respondents_id)+
          ','+QuotedStr(DateToStr(dtpDateTo.Date))+
          ','+iff(Trim(meNote.Lines.Text)<>'',QuotedStr(Trim(meNote.Lines.Text)),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    AddOrChangeRecord;

    DeleteRecords;
    
    qr.Transaction.Commit;

    RefreshNeededInterface;
    
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

function TfmDocWarrant.ChangeHeadAndRecord: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  id: String;
begin
 Result:=false;
 if not ChangeJournalDocument(IBDB) then exit;
 try
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  try

    id:=inttostr(DocumentId);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbWarrantHead+
          ' set basedocum_id='+iff(Trim(edBaseDocum.Text)<>'',inttostr(basedocum_id),'null')+
          ', basetext='+iff(Trim(edBaseText.Text)<>'',QuotedStr(Trim(edBaseText.Text)),'null')+
          ', grantee_id='+inttostr(grantee_id)+
          ', supplier_id='+inttostr(supplier_id)+
          ', respondents_id='+inttostr(respondents_id)+
          ', realydate='+QuotedStr(DateToStr(dtpDateTo.Date))+
          ', note='+iff(Trim(meNote.Lines.Text)<>'',QuotedStr(Trim(meNote.Lines.Text)),'null')+
          ' where docum_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;

    AddOrChangeRecord;

    DeleteRecords;
    
    qr.Transaction.Commit;
    
    RefreshNeededInterface;

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

procedure TfmDocWarrant.AddOrChangeRecord;
var
  id: string;
  qr: TIBQuery;
  sqls: string;
  Change,isAdd: Boolean;
begin
  qr:=TIBQuery.Create(nil);
  MemTable.DisableControls;
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    MemTable.First;
    while not MemTable.Eof do begin
      Change:=MemTable.FieldByName('change').AsBoolean;
      isAdd:=MemTable.FieldByName('isadd').AsBoolean;
      if isAdd then begin
        if Change then begin
          id:=inttostr(MemTable.FieldByName('warrantrecord_id').AsInteger);
          sqls:='Insert into '+tbWarrantRecord+
                ' (warrantrecord_id,docum_id,unitofmeasure_id,nomenclature_id,calcfactor,amount) '+
                'values ('+id+
                ','+inttostr(DocumentId)+
                ','+MemTable.FieldByName('unitofmeasure_id').AsString+
                ','+MemTable.FieldByName('nomenclature_id').AsString+
                ','+iff(MemTable.FieldByName('calcfactor').Value<>Null,
                        QuotedStr(ChangeChar(Trim(MemTable.FieldByName('calcfactor').AsString),',','.')),
                        'null')+
                ','+iff(MemTable.FieldByName('amount').Value<>Null,
                        QuotedStr(ChangeChar(Trim(MemTable.FieldByName('amount').AsString),',','.')),
                        'null')+')';

        end;
      end else begin
        if Change then begin
          id:=inttostr(MemTable.FieldByName('warrantrecord_id').AsInteger);
          sqls:='Update '+tbWarrantRecord+
                ' set docum_id='+inttostr(DocumentId)+
                ', unitofmeasure_id='+MemTable.FieldByName('unitofmeasure_id').AsString+
                ', nomenclature_id='+MemTable.FieldByName('nomenclature_id').AsString+
                ', calcfactor='+iff(MemTable.FieldByName('calcfactor').Value<>Null,
                                    QuotedStr(ChangeChar(Trim(MemTable.FieldByName('calcfactor').AsString),',','.')),
                                    'null')+
                ', amount='+iff(MemTable.FieldByName('amount').Value<>null,
                                QuotedStr(ChangeChar(Trim(MemTable.FieldByName('amount').AsString),',','.')),
                                'null')+
                ' where warrantrecord_id='+id;
        end;
      end;

      if Change then begin
       qr.Transaction.Active:=true;
       qr.SQL.Clear;
       qr.SQL.Add(sqls);
       qr.ExecSQL;
      end;
      MemTable.Next;
    end;
  finally
    MemTable.EnableControls;
    qr.Free;
  end;
end;

procedure TfmDocWarrant.DeleteRecords; 
var
  qr: TIBQuery;
  sqls: string;
  i: integer;
  id: Integer;
begin
  if ListDeleteRecords.Count=0 then exit;
  qr:=TIBQuery.Create(nil);
  try
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    for i:=ListDeleteRecords.Count-1 downto 0 do begin
     id:=Integer(ListDeleteRecords.Items[i]);
     sqls:='Delete from '+tbWarrantRecord+
           ' where warrantrecord_id='+inttostr(id);
     qr.Transaction.Active:=true;
     qr.SQL.Clear;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     ListDeleteRecords.Delete(i);
    end; 
  finally
    qr.Free;
  end;
end;

procedure TfmDocWarrant.RefreshNeededInterface;
var
  TPRJI: TParamRefreshJournalInterface;
begin
  FillChar(TPRJI,SizeOf(TPRJI),0);
  TPRJI.Locate.KeyFields:='docum_id';
  TPRJI.Locate.KeyValues:=DocumentId;
  TPRJI.Locate.Options:=[loCaseInsensitive];
  _RefreshInterface(_GetInterfaceHandleFromName(NameJrDocum),@TPRJI);
end;

procedure TfmDocWarrant.edNumberChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

function TfmDocWarrant.CheckPermissionPrint: Boolean;
begin
  if TypeOperation in [todChange,todView] then
   Result:=_isPermissionOnInterface(_GetInterfaceHandleFromName(NameRptWarrant),ttiaView)
  else Result:=inherited CheckPermissionPrint;
end;

procedure TfmDocWarrant.bibPrintClick(Sender: TObject);
var
  TPERI: TParamExecProcReportInterface;
begin
  FillChar(TPERI,Sizeof(TPERI),0);
  TPERI.ProcName:='ShowReport';
  SetLength(TPERI.Params,1);
  TPERI.Params[0].Value:=DocumentId;
  _ExecProcInterface(_GetInterfaceHandleFromName(NameRptWarrant),@TPERI);
end;

end.

