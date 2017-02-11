unit UEditRBUsersGroup;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBUsersGroup = class(TfmEditRB)
    edNameUsersGroup: TEdit;
    lbNameUsersGroup: TLabel;
    cmbInterfaceName: TComboBox;
    lbInterfaceName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure chbInFirstClick(Sender: TObject);
    procedure edNameUsersGroupChange(Sender: TObject);
  private
    procedure FillInterfaces;  

  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    oldUserGroup_id: Integer;
    UserGroup_id: Integer;
    fmParent:TForm;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBUsersGroup: TfmEditRBUsersGroup;

implementation

uses USysVAVCode, USysVAVData, UMainUnited, URBUsersGroup;

{$R *.DFM}

procedure TfmEditRBUsersGroup.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBUsersGroup.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbUsersGroup,1));
    sqls:='Insert into '+ tbUsersGroup +
          ' (UserGroup_id,GroupName,InterfaceName) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edNameUsersGroup.text))+
          ','+Iff(cmbInterfaceName.ItemIndex<>-1,QuotedStr(Trim(cmbInterfaceName.Text)),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    oldUserGroup_id:=strtoint(id);

    TfmRBUsersGroup(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBUsersGroup(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBUsersGroup(fmParent).Mainqr do begin
      Insert;
      FieldByName('UserGroup_id').AsInteger:=StrToInt(id);
      FieldByName('GroupName').AsString:=Trim(edNAmeUsersGroup.text);
      FieldByName('interfacename').Value:=Iff(cmbInterfaceName.ItemIndex<>-1,Trim(cmbInterfaceName.Text),Null);
      Post;
    end;
    oldUserGroup_id:=StrToInt(id);
    qr.Transaction.Commit;
    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
 {$IFDEF DEBUG}
     on E: Exception do Assert(false,E.message);
    {$ENDIF}
 end;
end;

procedure TfmEditRBUsersGroup.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBUsersGroup.UpdateRBooks: Boolean;
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

    id:=inttostr(oldUserGroup_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbUsersGroup+
          ' set GroupName='+QuotedStr(Trim(edNameUsersGroup.text))+
          ', interfacename='+Iff(cmbInterfaceName.ItemIndex<>-1,QuotedStr(Trim(cmbInterfaceName.Text)),'null')+
          ' where UserGroup_id='+id;

    qr.SQL.Add(sqls);
    qr.ExecSQL;

    TfmRBUsersGroup(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBUsersGroup(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBUsersGroup(fmParent).Mainqr do begin
      Edit;
      FieldByName('UserGroup_id').AsInteger:=StrToInt(id);
      FieldByName('GroupName').AsString:=Trim(edNAmeUsersGroup.text);
      FieldByName('interfacename').Value:=Iff(cmbInterfaceName.ItemIndex<>-1,Trim(cmbInterfaceName.Text),Null);
      Post;
    end;
    oldUserGroup_id:=StrToInt(id);
    qr.Transaction.Commit;

    Result:=true;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: EIBInterBaseError do begin
    TempStr:=TranslateIBError(E.Message);
    ShowError(Handle,TempStr);
    Assert(false,TempStr);
  end;
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message);{$ENDIF}
 end;
end;

procedure TfmEditRBUsersGroup.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end;
  ModalResult:=mrOk;
end;

function TfmEditRBUsersGroup.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNameUsersGroup.Text)='' then begin
    ShowError(Handle,Format(ConstFieldNoEmpty,[lbNameUsersGroup.Caption]));
    edNameUsersGroup.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBUsersGroup.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNameUsersGroup.MaxLength:=DomainSmallNameLength;
//  meAbout.MaxLength:=DomainNoteLength;
  FillInterfaces;
end;

procedure TfmEditRBUsersGroup.chbInFirstClick(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBUsersGroup.edNameUsersGroupChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure fmRBUsersGroupGetInterfaceProc(Owner: Pointer; PGI: PGetInterface); stdcall;
begin
  if PGI.TypeInterface=ttiRBook then
    TfmEditRBUsersGroup(Owner).cmbInterfaceName.Items.Add(PGI.Name);
end;

procedure TfmEditRBUsersGroup.FillInterfaces;
begin
  cmbInterfaceName.Clear;
//  _GetInterfaces(nil,GetInterfaceProc);
  _GetInterfaces(Self,fmRBUsersGroupGetInterfaceProc);
end;


end.



