unit UEditRBTypeDoc;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBTypeDoc = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbInterfaceName: TLabel;
    cmbInterfaceName: TComboBox;
    chbSign: TCheckBox;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbSignClick(Sender: TObject);
  private
    procedure FillInterfaces;  
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldtypedoc_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBTypeDoc: TfmEditRBTypeDoc;

implementation

uses UDocTurnTsvCode, UDocTurnTsvData, UMainUnited, URBTypeDoc;

{$R *.DFM}

procedure TfmEditRBTypeDoc.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBTypeDoc.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbTypeDoc,1));
    sqls:='Insert into '+tbTypeDoc+
          ' (typedoc_id,name,interfacename,sign) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+Iff(cmbInterfaceName.ItemIndex<>-1,QuotedStr(Trim(cmbInterfaceName.Text)),'null')+
          ','+Inttostr(Integer(chbSign.Checked))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldtypedoc_id:=strtoint(id);

    TfmRBTypeDoc(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBTypeDoc(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBTypeDoc(fmParent).MainQr do begin
      Insert;
      FieldByName('typedoc_id').AsInteger:=oldtypedoc_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('interfacename').Value:=Iff(cmbInterfaceName.ItemIndex<>-1,Trim(cmbInterfaceName.Text),Null);
      FieldByName('sign').AsInteger:=Integer(chbSign.Checked);
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

procedure TfmEditRBTypeDoc.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBTypeDoc.UpdateRBooks: Boolean;
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

   id:=inttostr(oldtypedoc_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbTypeDoc+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', interfacename='+Iff(cmbInterfaceName.ItemIndex<>-1,QuotedStr(Trim(cmbInterfaceName.Text)),'null')+
          ', sign='+Inttostr(Integer(chbSign.Checked))+
          ' where typedoc_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBTypeDoc(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBTypeDoc(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBTypeDoc(fmParent).MainQr do begin
      Edit;
      FieldByName('typedoc_id').AsInteger:=oldtypedoc_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('interfacename').Value:=Iff(cmbInterfaceName.ItemIndex<>-1,Trim(cmbInterfaceName.Text),Null);
      FieldByName('sign').AsInteger:=Integer(chbSign.Checked);
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

procedure TfmEditRBTypeDoc.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBTypeDoc.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if chbSign.Checked then
    if cmbInterfaceName.ItemIndex=-1 then begin
      ShowErrorEx(Format(ConstFieldNoEmpty,[lbInterfaceName.Caption]));
      cmbInterfaceName.SetFocus;
      Result:=false;
      exit;
    end;
end;

procedure TfmEditRBTypeDoc.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBTypeDoc.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  cmbInterfaceName.MaxLength:=DomainNameLength;

  FillInterfaces;
end;

procedure TfmEditRBTypeDoc.chbSignClick(Sender: TObject);
begin
  ChangeFlag:=true;
  if chbSign.Checked then begin
   lbInterfaceName.Enabled:=true;
   cmbInterfaceName.Enabled:=true;
   cmbInterfaceName.Color:=clWindow;
  end else begin
   lbInterfaceName.Enabled:=false;
   cmbInterfaceName.Enabled:=false;
   cmbInterfaceName.Color:=clBtnFace;
   cmbInterfaceName.ItemIndex:=-1;
  end;
end;

procedure fmEditRBTypeDocGetInterfaceProc(Owner: Pointer; PGI: PGetInterface); stdcall;
begin
  if PGI.TypeInterface=ttiDocument then
    TfmEditRBTypeDoc(Owner).cmbInterfaceName.Items.Add(PGI.Name);
end;

procedure TfmEditRBTypeDoc.FillInterfaces;
begin
  cmbInterfaceName.Clear;
  _GetInterfaces(Self,fmEditRBTypeDocGetInterfaceProc);
end;

end.
