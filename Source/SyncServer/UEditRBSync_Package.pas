unit UEditRBSync_Package;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBSync_Package = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNote: TLabel;
    edNote: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldsync_package_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBSync_Package: TfmEditRBSync_Package;

implementation

uses USyncServerCode, USyncServerData, UMainUnited, URBSync_Package;

{$R *.DFM}

procedure TfmEditRBSync_Package.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBSync_Package.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbSync_Package,1));
    sqls:='Insert into '+tbSync_Package+
          ' (sync_package_id,name,note) values '+
          ' ('+id+','+QuotedStr(Trim(edName.text))+','+
          iff(Trim(edNote.Text)<>'',QuotedStr(Trim(edNote.text)),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldsync_package_id:=strtoint(id);

    TfmRBSync_Package(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBSync_Package(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBSync_Package(fmParent).MainQr do begin
      Insert;
      FieldByName('sync_package_id').AsInteger:=oldsync_package_id;
      FieldByName('name').AsString:=Trim(edName.text);
      FieldByName('note').Value:=iff(Trim(edNote.Text)<>'',edNote.text,Null);
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

procedure TfmEditRBSync_Package.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBSync_Package.UpdateRBooks: Boolean;
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

    id:=inttostr(oldsync_package_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbSync_Package+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', note='+iff(Trim(edNote.Text)<>'',QuotedStr(Trim(edNote.text)),'null')+
          ' where sync_package_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBSync_Package(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBSync_Package(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBSync_Package(fmParent).MainQr do begin
      Edit;
      FieldByName('sync_package_id').AsInteger:=oldsync_package_id;
      FieldByName('name').AsString:=Trim(edName.text);
      FieldByName('note').Value:=iff(Trim(edNote.Text)<>'',edNote.text,Null);
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

procedure TfmEditRBSync_Package.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBSync_Package.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBSync_Package.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainSmallNameLength;
  edNote.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBSync_Package.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBSync_Package.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Byte(Key)=VK_SPACE then Key:=#0;
end;

end.

