unit UEditRBInterfacePermission;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls, ExtDlgs, IBTable, clipbrd;

type
  TfmEditRBInterfacePermission = class(TfmEditRB)
    lbInterface: TLabel;
    edInterface: TEdit;
    bibInterface: TButton;
    lbInterfaceAction: TLabel;
    cmbInterfaceAction: TComboBox;
    lbObject: TLabel;
    edObject: TEdit;
    bibObject: TButton;
    lbPermission: TLabel;
    cmbPermission: TComboBox;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibInterfaceClick(Sender: TObject);
    procedure bibObjectClick(Sender: TObject);
  private
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldinterfacepermission_id: Integer;
    interface_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBInterfacePermission: TfmEditRBInterfacePermission;

implementation

uses UDesignTsvCode, UDesignTsvData, UMainUnited, URBInterfacePermission, menus;

{$R *.DFM}

procedure TfmEditRBInterfacePermission.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBInterfacePermission.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbInterfacePermission,1));
    sqls:='Insert into '+tbInterfacePermission+
          ' (interfacepermission_id,interfaceaction,interface_id,dbobject,permission) values '+
          ' ('+id+
          ','+inttostr(cmbInterfaceAction.ItemIndex)+
          ','+inttostr(interface_id)+
          ','+QuotedStr(Trim(edObject.Text))+
          ','+inttostr(cmbPermission.ItemIndex)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldinterfacepermission_id:=strtoint(id);

    TfmRBInterfacePermission(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBInterfacePermission(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBInterfacePermission(fmParent).MainQr do begin
      Insert;
      FieldByName('interfacepermission_id').AsInteger:=oldinterfacepermission_id;
      FieldByName('interface_id').AsInteger:=interface_id;
      FieldByName('interfacename').AsString:=Trim(edInterface.Text);
      FieldByName('interfaceaction').AsInteger:=cmbInterfaceAction.ItemIndex;
      FieldByName('dbobject').AsString:=Trim(edObject.Text);
      FieldByName('permission').AsInteger:=cmbPermission.ItemIndex;
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

procedure TfmEditRBInterfacePermission.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBInterfacePermission.UpdateRBooks: Boolean;
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

    id:=inttostr(oldinterfacepermission_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbInterfacePermission+
          ' set interfaceaction='+inttostr(cmbInterfaceAction.ItemIndex)+
          ', interface_id='+inttostr(interface_id)+
          ', dbobject='+QuotedStr(Trim(edObject.Text))+
          ', permission='+inttostr(cmbPermission.ItemIndex)+
          ' where interfacepermission_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBInterfacePermission(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBInterfacePermission(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBInterfacePermission(fmParent).MainQr do begin
      Edit;
      FieldByName('interfacepermission_id').AsInteger:=oldinterfacepermission_id;
      FieldByName('interface_id').AsInteger:=interface_id;
      FieldByName('interfacename').AsString:=Trim(edInterface.Text);
      FieldByName('interfaceaction').AsInteger:=cmbInterfaceAction.ItemIndex;
      FieldByName('dbobject').AsString:=Trim(edObject.Text);
      FieldByName('permission').AsInteger:=cmbPermission.ItemIndex;
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

procedure TfmEditRBInterfacePermission.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBInterfacePermission.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edInterface.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbInterface.Caption]));
    bibInterface.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(cmbInterfaceAction.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbInterfaceAction.Caption]));
    cmbInterfaceAction.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edObject.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbObject.Caption]));
    bibObject.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(cmbPermission.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbPermission.Caption]));
    cmbPermission.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBInterfacePermission.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBInterfacePermission.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;

  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edInterface.MaxLength:=DomainNameLength;
  cmbInterfaceAction.MaxLength:=DomainSmallNameLength;
  edObject.MaxLength:=31;
  cmbPermission.MaxLength:=DomainSmallNameLength;

  cmbInterfaceAction.Clear;
  for i:=Integer(ttiaView) to Integer(ttiaDelete) do
    cmbInterfaceAction.Items.Add(GetInterfaceActionByValue(TTypeInterfaceAction(i)));
  cmbInterfaceAction.ItemIndex:=0;

  cmbPermission.Clear;
  for i:=Integer(ttpSelect) to Integer(ttpExecute) do
    cmbPermission.Items.Add(GetDbPermissionByValue(TTypeDBPermission(i)));
  cmbPermission.ItemIndex:=0;
  
end;

procedure TfmEditRBInterfacePermission.bibInterfaceClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='interface_id';
  TPRBI.Locate.KeyValues:=interface_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkInterface,@TPRBI) then begin
   ChangeFlag:=true;
   interface_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'interface_id');
   edInterface.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'name');
  end;
end;

procedure TfmEditRBInterfacePermission.bibObjectClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.SQL.Select:='select r.rdb$relation_name as name '+
                    'from '+tbSysRelations+' r '+
                    'where r.rdb$system_flag=0 '+
                    'union all '+
                    'select rdb$procedure_name as name '+
                    'from '+tbSysProcedures+' '+
                    'order by 1';
  TPRBI.Locate.KeyFields:='name';
  TPRBI.Locate.KeyValues:=Trim(edObject.text);
  TPRBI.Locate.Options:=[loPartialKey,loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkQuery,@TPRBI) then begin
   ChangeFlag:=true;
   edObject.text:=Trim(GetFirstValueFromParamRBookInterface(@TPRBI,'name'));
  end;
end;

end.
