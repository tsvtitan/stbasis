unit UEditRBConsts;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBConsts = class(TfmEditRB)
    lbType: TLabel;
    cmbType: TComboBox;
    lbName: TLabel;
    edName: TEdit;
    lbValueView: TLabel;
    edValueView: TEdit;
    lbAbout: TLabel;
    meAbout: TMemo;
    grbLink: TGroupBox;
    lbCol: TLabel;
    lbObj: TLabel;
    lbValueTable: TLabel;
    cmbObj: TComboBox;
    cmbColumn: TComboBox;
    edValueTable: TEdit;
    bibValueTable: TButton;
    procedure edObjChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edObjKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure cmbColumnChange(Sender: TObject);
    procedure cmbTypeChange(Sender: TObject);
    procedure bibValueTableClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure bibPrevClick(Sender: TObject);
    procedure bibNextClick(Sender: TObject);
  private
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;

    procedure ClearCmbObj;
    function DropTriggers: Boolean;
    function CreateTriggers: Boolean;

  public
    fmParent: TForm;
    oldconstex_id: Integer;
    OldName: string;
    OldValueView: string;
    OldTableName: string;
    OldColumnName: string;

    procedure FillCmbObj;
    procedure FillCmbColumn;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;

  end;

var
  fmEditRBConsts: TfmEditRBConsts;

  function GetBeforeDeleteTriggerName(s1,s2,s3,s4: string): string;

implementation

uses UMainCode, UMainData, UMainUnited, tsvInterbase, URBConsts;

type
  PInfoRelation=^TInfoRelation;
  TInfoRelation=packed record
    Description: string;
    ListFields: TList;
  end;

  PInfoField=^TInfoField;
  TInfoField=packed record
    Name: string;
    Description: string;
    FieldType: TFieldType;
  end;

function GetSumByString(S: string): Integer;
var
  i: Integer;
begin
  Result:=0;
  for i:=1 to Length(s) do begin
    Result:=Result+Byte(S[i]);
  end;
end;

function GetBeforeDeleteTriggerName(s1,s2,s3,s4: string): string;
begin
  Result:=Format('CONST_BD_%d_%d_%d_%d',[GetSumByString(s1),
                                         GetSumByString(s2),
                                         GetSumByString(s3),
                                         GetSumByString(s4)]);
end;

{$R *.DFM}

procedure TfmEditRBConsts.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


function TfmEditRBConsts.DropTriggers: Boolean;
begin
  result:=false;
  try
   ExecSql(IBDB,'Drop trigger '+GetBeforeDeleteTriggerName(OldName,OldValueView,OldTableName,OldColumnName));
   Result:=true;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
  end;
end;

function TfmEditRBConsts.CreateTriggers: Boolean;
var
  PField: PInfoField;
begin
  result:=false;
  try
   PField:=PInfoField(cmbColumn.items.Objects[cmbColumn.ItemIndex]);
   ExecSql(IBDB,'CREATE TRIGGER '+GetBeforeDeleteTriggerName(OldName,OldValueView,OldTableName,OldColumnName)+
           ' FOR '+AnsiUpperCase(cmbObj.Text)+#13+
           'ACTIVE BEFORE DELETE POSITION 0'+#13+
           'AS'+#13+
           'declare variable err varchar(400);'+#13+
           'begin'+#13+
           ' if (Old.'+cmbColumn.Text+'='+Iff(PField.FieldType=ftString,
                                              QuotedStr(edValueTable.Text),
                                              edValueTable.Text)+') then begin'+#13+
           '  err=''Значение <'+Trim(edValueView.Text)+'> используется в константах..'';'+#13+
           '  execute procedure error(err);'+#13+
           ' end'+#13+
           'end');
   Result:=true;
  except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
  end;
end;

function TfmEditRBConsts.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbConstEx,1));
    sqls:='Insert into '+tbConstEx+
          ' (constex_id,consttype,name,note,valueview,tablename,fieldname,valuetable) values '+
          ' ('+id+
          ','+inttostr(cmbType.ItemIndex)+
          ','+QuotedStr(Trim(edName.Text))+
          ','+Iff(Trim(meAbout.Lines.Text)<>'',QuotedStr(Trim(meAbout.Lines.Text)),'null')+
          ','+QuotedStr(Trim(edValueView.Text))+
          ','+Iff(cmbType.ItemIndex<>-1,QuotedStr(Trim(cmbObj.Text)),'null')+
          ','+Iff(cmbType.ItemIndex<>-1,QuotedStr(Trim(cmbColumn.Text)),'null')+
          ','+Iff(cmbType.ItemIndex<>-1,QuotedStr(Trim(edValueTable.Text)),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    if cmbType.ItemIndex=1 then begin
     OldName:=edName.Text;
     OldValueView:=edValueView.Text;
     OldTableName:=cmbObj.Text;
     OldColumnName:=cmbColumn.Text;
     try
      DropTriggers;
     except
     end; 
     if not CreateTriggers then exit;
    end;
    qr.Transaction.Commit;
    oldconstex_id:=strtoint(id);

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

procedure TfmEditRBConsts.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBConsts.UpdateRBooks: Boolean;
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

    id:=inttostr(oldconstex_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbConstEx+
          ' set consttype='+inttostr(cmbType.ItemIndex)+
          ', name='+QuotedStr(Trim(edName.Text))+
          ', note='+Iff(Trim(meAbout.Lines.Text)<>'',QuotedStr(Trim(meAbout.Lines.Text)),'null')+
          ', valueview='+QuotedStr(Trim(edValueView.Text))+
          ', tablename='+Iff(cmbType.ItemIndex<>-1,QuotedStr(Trim(cmbObj.Text)),'null')+
          ', fieldname='+Iff(cmbType.ItemIndex<>-1,QuotedStr(Trim(cmbColumn.Text)),'null')+
          ', valuetable='+Iff(cmbType.ItemIndex<>-1,QuotedStr(Trim(edValueTable.Text)),'null')+
          ' where constex_id='+id;

    qr.SQL.Add(sqls);
    qr.ExecSQL;
    if cmbType.ItemIndex=1 then begin
     try
      DropTriggers;
     except
     end;
     OldName:=edName.Text;
     OldValueView:=edValueView.Text;
     OldTableName:=cmbObj.Text;
     OldColumnName:=cmbColumn.Text;
     if not CreateTriggers then exit;
    end;
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

procedure TfmEditRBConsts.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBConsts.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edValueView.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbValueView.Caption]));
    edValueView.SetFocus;
    Result:=false;
    exit;
  end;
  if cmbType.ItemIndex=1 then begin
   if cmbObj.ItemIndex=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbObj.Caption]));
    cmbObj.SetFocus;
    Result:=false;
    exit;
   end;
   if cmbColumn.ItemIndex=-1 then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbCol.Caption]));
    cmbColumn.SetFocus;
    Result:=false;
    exit;
   end;
   if trim(edValueTable.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbValueTable.Caption]));
    edValueTable.SetFocus;
    Result:=false;
    exit;
   end;
  end;
end;

procedure TfmEditRBConsts.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=50;
  meAbout.MaxLength:=DomainNoteLength;
  edValueView.MaxLength:=DomainNoteLength;
  cmbObj.MaxLength:=31;
  cmbColumn.MaxLength:=31;
  edValueTable.MaxLength:=DomainNoteLength;

  cmbType.Items.Add('По умолчанию');
  cmbType.Items.Add('Ссылка');
  cmbType.ItemIndex:=0;
  cmbTypeChange(nil);

end;

procedure TfmEditRBConsts.edObjKeyPress(Sender: TObject;
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

procedure TfmEditRBConsts.FillCmbObj;
var
  sqls: string;
  RName: string;
  NewName: string;
  PRel: PInfoRelation;
  PField: PInfoField;
  Sv,Ev,i: Integer;
var
  TPRBI: TParamRBookInterface;
begin
  try
   Screen.Cursor:=crHourGlass;
   cmbObj.Items.BeginUpdate;
   try
     ClearCmbObj;
     sqls:='select r.rdb$relation_name, r.rdb$description as d1, rf.rdb$field_name,'+
           'rf.rdb$description as d2, rf.rdb$field_position '+
           'from '+tbSysRelations+' r join '+tbSysRelation_fields+' rf on r.rdb$relation_name=rf.rdb$relation_name  '+
           'where r.rdb$system_flag=0 '+
           'order by r.rdb$relation_name, rf.rdb$field_position';

     FillChar(TPRBI,SizeOf(TPRBI),0);
     TPRBI.Visual.TypeView:=tviOnlyData;
     TPRBI.SQL.Select:=PChar(sqls);
     if ViewInterfaceFromName_(NameRbkQuery,@TPRBI) then begin
      Sv:=0;
      Ev:=0;
      GetStartAndEndByParamRBookInterface(@TPRBI,Sv,Ev);
      Prel:=nil;
      if Sv<Ev then begin
       RName:=Trim(GetValueByParamRBookInterface(@TPRBI,Sv,'rdb$relation_name',varString));
       New(PRel);
       PRel.Description:=Trim(GetValueByParamRBookInterface(@TPRBI,Sv,'d1',varString));
       PRel.ListFields:=TList.Create;
       cmbObj.Items.AddObject(RName,TObject(PRel));
      end;
      for i:=Sv to Ev do begin
       NewName:=Trim(GetValueByParamRBookInterface(@TPRBI,i,'rdb$relation_name',varString));
       if AnsiSameText(RName,NewName) then begin
        New(PField);
        PField.Name:=Trim(GetValueByParamRBookInterface(@TPRBI,i,'rdb$field_name',varString));
        PField.Description:=Trim(GetValueByParamRBookInterface(@TPRBI,i,'d2',varString));
        Prel.ListFields.Add(PField);
       end else begin
        RName:=Trim(GetValueByParamRBookInterface(@TPRBI,i,'rdb$relation_name',varString));
        New(PRel);
        PRel.Description:=Trim(GetValueByParamRBookInterface(@TPRBI,i,'d1',varString));
        PRel.ListFields:=TList.Create;
        cmbObj.Items.AddObject(RName,TObject(PRel));
        New(PField);
        PField.Name:=Trim(GetValueByParamRBookInterface(@TPRBI,i,'rdb$field_name',varString));
        PField.Description:=Trim(GetValueByParamRBookInterface(@TPRBI,i,'d2',varString));
        Prel.ListFields.Add(PField);
       end;
      end;
     end;
   finally
    cmbObj.Items.EndUpdate;
    Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBConsts.edObjChange(Sender: TObject);
begin
  ChangeFlag:=true;
  if cmbObj.ItemIndex<>-1 then begin
    cmbObj.Hint:=PInfoRelation(cmbObj.items.Objects[cmbObj.ItemIndex]).Description;
    cmbColumn.Hint:='';
    edValueTable.Text:='';
    FillCmbColumn;
    if cmbColumn.Items.count>0 then cmbColumn.ItemIndex:=0;
  end;
end;

procedure TfmEditRBConsts.ClearCmbObj;
var
  i,j: Integer;
  PRel: PInfoRelation;
  PField: PInfoField;
begin
  for i:=0 to cmbObj.Items.Count-1 do begin
    PRel:=PInfoRelation(cmbObj.Items.Objects[i]);
    for j:=0 to PRel.ListFields.Count-1 do begin
     PField:=PRel.ListFields.Items[j];
     Dispose(PField);
    end;
    PRel.ListFields.Free;
    Dispose(PRel);
  end;
  cmbObj.Items.Clear;
end;

procedure TfmEditRBConsts.FormDestroy(Sender: TObject);
begin
  ClearCmbObj;
end;

procedure TfmEditRBConsts.FillCmbColumn;
var
  i: Integer;
  PRel: PInfoRelation;
  PField: PInfoField;
  TPRBI: TParamRBookInterface;
begin
  if cmbObj.ItemIndex=-1 then exit;
  cmbColumn.Items.BeginUpdate;
  try
    cmbColumn.Items.Clear;
    Prel:=PInfoRelation(cmbObj.items.Objects[cmbObj.ItemIndex]);
    if Prel.ListFields.Count=0 then exit;
    FillChar(TPRBI,SizeOf(TParamRBookInterface),0);
    TPRBI.Visual.TypeView:=tviOnlyData;
    TPRBI.SQL.Select:=PChar('Select * from '+cmbObj.Text+' where '+PInfoField(Prel.ListFields.Items[0]).Name+' is null');
    if ViewInterfaceFromName_(NameRbkQuery,@TPRBI) then begin
     for i:=0 to Prel.ListFields.Count-1 do begin
      PField:=Prel.ListFields.Items[i];
      PField.FieldType:=GetFieldTypeByParamRBookInterface(@TPRBI,PField.Name);
      cmbColumn.Items.AddObject(PField.Name,TObject(PField));
     end;
    end; 
  finally
    cmbColumn.Items.EndUpdate;
  end;
end;

procedure TfmEditRBConsts.cmbColumnChange(Sender: TObject);
begin
  ChangeFlag:=true;
  if cmbColumn.ItemIndex<>-1 then begin
    cmbColumn.Hint:=PInfoField(cmbColumn.items.Objects[cmbColumn.ItemIndex]).Description;
    edValueTable.Text:='';
  end;
end;

procedure TfmEditRBConsts.cmbTypeChange(Sender: TObject);
begin
  ChangeFlag:=true;
  case cmbType.ItemIndex of
    0: begin
      lbObj.Enabled:=false;
      cmbObj.Enabled:=false;
      cmbObj.Color:=clBtnFace;
      lbCol.Enabled:=false;
      cmbColumn.Enabled:=false;
      cmbColumn.Color:=clBtnFace;
      lbValueTable.Enabled:=false;
      edValueTable.Enabled:=false;
      bibValueTable.Enabled:=false;
    end;
    1: begin
      lbObj.Enabled:=true;
      cmbObj.Enabled:=true;
      cmbObj.Color:=clWindow;
      lbCol.Enabled:=true;
      cmbColumn.Enabled:=true;
      cmbColumn.Color:=clWindow;
      lbValueTable.Enabled:=true;
      edValueTable.Enabled:=true;
      bibValueTable.Enabled:=true;
    end;
  end;
end;

procedure TfmEditRBConsts.bibValueTableClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  if cmbObj.ItemIndex=-1 then begin
   ShowErrorEx(Format(ConstFieldNoEmpty,[lbObj.Caption]));
   cmbObj.SetFocus;
   exit;
  end;
  if cmbColumn.ItemIndex=-1 then begin
   ShowErrorEx(Format(ConstFieldNoEmpty,[lbCol.Caption]));
   cmbColumn.SetFocus;
   exit;
  end;
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  if Trim(edValueTable.Text)<>'' then begin
   TPRBI.Locate.KeyFields:=PChar(cmbColumn.Text);
   TPRBI.Locate.KeyValues:=edValueTable.Text;
   TPRBI.Locate.Options:=[loCaseInsensitive];
  end; 
  TPRBI.SQL.Select:=PChar('Select * from '+cmbObj.Text);
  if ViewInterfaceFromName_(NameRbkQuery,@TPRBI) then begin
   ChangeFlag:=true;
   edValueTable.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,cmbColumn.Text);
  end;
end;

procedure TfmEditRBConsts.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBConsts.bibPrevClick(Sender: TObject);
begin
  if isValidPointer(fmParent) then TfmRBConst(fmParent).PriorRecord;
end;

procedure TfmEditRBConsts.bibNextClick(Sender: TObject);
begin
  if isValidPointer(fmParent) then TfmRBConst(fmParent).NextRecord; 
end;

end.
