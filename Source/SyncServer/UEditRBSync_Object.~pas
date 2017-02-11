unit UEditRBSync_Object;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBSync_Object = class(TfmEditRB)
    lbPackage: TLabel;
    edPackage: TEdit;
    bibPackage: TButton;
    lbName: TLabel;
    edName: TEdit;
    lbFieldsKey: TLabel;
    meFieldsKey: TMemo;
    lbFieldsSync: TLabel;
    meFieldsSync: TMemo;
    lbCondition: TLabel;
    meCondition: TMemo;
    lbSqlBefore: TLabel;
    meSqlBefore: TMemo;
    lbSqlAfter: TLabel;
    meSqlAfter: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure bibPackageClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldsync_object_id: Integer;
    sync_package_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBSync_Object: TfmEditRBSync_Object;

implementation

uses USyncServerCode, USyncServerData, UMainUnited, URBSync_Object;

{$R *.DFM}

procedure TfmEditRBSync_Object.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBSync_Object.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbSync_Object,1));
    sqls:='Insert into '+tbSync_Object+
          ' (sync_object_id,sync_package_id,name,fields_key,fields_sync,condition,sql_before,sql_after) values '+
          ' ('+id+
          ','+inttostr(sync_package_id)+
          ','+QuotedStr(Trim(edName.text))+
          ','+QuotedStr(Trim(meFieldsKey.Lines.text))+
          ','+QuotedStr(Trim(meFieldsSync.Lines.text))+
          ','+iff(Trim(meCondition.Lines.Text)<>'',QuotedStr(Trim(meCondition.Lines.Text)),'null')+
          ','+iff(Trim(meSqlBefore.Lines.Text)<>'',QuotedStr(Trim(meSqlBefore.Lines.Text)),'null')+
          ','+iff(Trim(meSqlAfter.Lines.Text)<>'',QuotedStr(Trim(meSqlAfter.Lines.Text)),'null')+
          ')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldsync_object_id:=strtoint(id);

    TfmRBSync_Object(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBSync_Object(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBSync_Object(fmParent).MainQr do begin
      Insert;
      FieldByName('sync_object_id').AsInteger:=oldsync_object_id;
      FieldByName('sync_package_id').AsInteger:=sync_package_id;
      FieldByName('name').AsString:=Trim(edName.text);
      FieldByName('fields_key').AsString:=Trim(meFieldsKey.Lines.text);
      FieldByName('fields_sync').AsString:=Trim(meFieldsSync.Lines.text);
      FieldByName('condition').Value:=iff(Trim(meCondition.Lines.Text)<>'',Trim(meCondition.Lines.Text),NULL);
      FieldByName('sql_before').Value:=iff(Trim(meSqlBefore.Lines.Text)<>'',Trim(meSqlBefore.Lines.Text),NULL);
      FieldByName('sql_after').Value:=iff(Trim(meSqlAfter.Lines.Text)<>'',Trim(meSqlAfter.Lines.Text),NULL);
      FieldByName('package_name').AsString:=Trim(edPackage.Text);
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

procedure TfmEditRBSync_Object.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBSync_Object.UpdateRBooks: Boolean;
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

    id:=inttostr(oldsync_object_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbSync_Object+
          ' set sync_package_id='+inttostr(sync_package_id)+
          ', name='+QuotedStr(Trim(edName.text))+
          ', fields_key='+QuotedStr(Trim(meFieldsKey.Lines.text))+
          ', fields_sync='+QuotedStr(Trim(meFieldsSync.Lines.text))+
          ', condition='+iff(Trim(meCondition.Lines.Text)<>'',QuotedStr(Trim(meCondition.Lines.Text)),'null')+
          ', sql_before='+iff(Trim(meSqlBefore.Lines.Text)<>'',QuotedStr(Trim(meSqlBefore.Lines.Text)),'null')+
          ', sql_after='+iff(Trim(meSqlAfter.Lines.Text)<>'',QuotedStr(Trim(meSqlAfter.Lines.Text)),'null')+
          ' where sync_object_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBSync_Object(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBSync_Object(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBSync_Object(fmParent).MainQr do begin
      Edit;
      FieldByName('sync_object_id').AsInteger:=oldsync_object_id;
      FieldByName('sync_package_id').AsInteger:=sync_package_id;
      FieldByName('name').AsString:=Trim(edName.text);
      FieldByName('fields_key').AsString:=Trim(meFieldsKey.Lines.text);
      FieldByName('fields_sync').AsString:=Trim(meFieldsSync.Lines.text);
      FieldByName('condition').Value:=iff(Trim(meCondition.Lines.Text)<>'',Trim(meCondition.Lines.Text),NULL);
      FieldByName('sql_before').Value:=iff(Trim(meSqlBefore.Lines.Text)<>'',Trim(meSqlBefore.Lines.Text),NULL);
      FieldByName('sql_after').Value:=iff(Trim(meSqlAfter.Lines.Text)<>'',Trim(meSqlAfter.Lines.Text),NULL);
      FieldByName('package_name').AsString:=Trim(edPackage.Text);
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

procedure TfmEditRBSync_Object.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBSync_Object.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edPackage.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPackage.Caption]));
    bibPackage.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(meFieldsKey.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFieldsKey.Caption]));
    meFieldsKey.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(meFieldsSync.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbFieldsSync.Caption]));
    meFieldsSync.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBSync_Object.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edPackage.MaxLength:=DomainNameLength;
  meFieldsKey.MaxLength:=DomainNoteLength;
  meFieldsSync.MaxLength:=DomainSqlLength;
  meCondition.MaxLength:=DomainSqlLength;
  meSqlBefore.MaxLength:=DomainSqlLength;
  meSqlAfter.MaxLength:=DomainSqlLength;
end;

procedure TfmEditRBSync_Object.bibPackageClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='sync_package_id';
  TPRBI.Locate.KeyValues:=sync_package_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkSync_Package,@TPRBI) then begin
   ChangeFlag:=true;
   sync_package_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'sync_package_id');
   edPackage.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBSync_Object.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBSync_Object.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Byte(Key)=VK_SPACE then Key:=#0;
end;

end.
