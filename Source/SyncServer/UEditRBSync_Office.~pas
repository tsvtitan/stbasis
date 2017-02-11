unit UEditRBSync_Office;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBSync_Office = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNote: TLabel;
    edNote: TEdit;
    lbKeys: TLabel;
    edKeys: TEdit;
    edContact: TEdit;
    lbContact: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldsync_office_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBSync_Office: TfmEditRBSync_Office;

implementation

uses USyncServerCode, USyncServerData, UMainUnited, URBSync_Office;

{$R *.DFM}

procedure TfmEditRBSync_Office.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBSync_Office.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbSync_Office,1));
    sqls:='Insert into '+tbSync_Office+
          ' (sync_office_id,name,note,keys,contact) values '+
          ' ('+id+','+QuotedStr(Trim(edName.text))+','+
          iff(Trim(edNote.Text)<>'',QuotedStr(Trim(edNote.text)),'null')+','+
          iff(Trim(edKeys.Text)<>'',QuotedStr(Trim(edKeys.text)),'null')+','+
          iff(Trim(edContact.Text)<>'',QuotedStr(Trim(edContact.text)),'null')+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldsync_office_id:=strtoint(id);

    TfmRBSync_Office(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBSync_Office(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBSync_Office(fmParent).MainQr do begin
      Insert;
      FieldByName('sync_office_id').AsInteger:=oldsync_office_id;
      FieldByName('name').AsString:=Trim(edName.text);
      FieldByName('note').Value:=iff(Trim(edNote.Text)<>'',edNote.text,Null);
      FieldByName('keys').Value:=iff(trim(edKeys.Text)<>'',edKeys.Text,Null);
      FieldByName('contact').Value:=iff(trim(edContact.Text)<>'',edContact.Text,Null);
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

procedure TfmEditRBSync_Office.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBSync_Office.UpdateRBooks: Boolean;
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

    id:=inttostr(oldsync_office_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbSync_Office+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', note='+iff(Trim(edNote.Text)<>'',QuotedStr(Trim(edNote.text)),'null')+
          ', keys='+iff(Trim(edKeys.Text)<>'',QuotedStr(Trim(edKeys.text)),'null')+
          ', contact='+iff(Trim(edContact.Text)<>'',QuotedStr(Trim(edContact.text)),'null')+
          ' where sync_office_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBSync_Office(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBSync_Office(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBSync_Office(fmParent).MainQr do begin
      Edit;
      FieldByName('sync_office_id').AsInteger:=oldsync_office_id;
      FieldByName('name').AsString:=Trim(edName.text);
      FieldByName('note').Value:=iff(Trim(edNote.Text)<>'',edNote.text,Null);
      FieldByName('keys').Value:=iff(trim(edKeys.Text)<>'',edKeys.Text,Null);
      FieldByName('contact').Value:=iff(trim(edContact.Text)<>'',edContact.Text,Null);
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

procedure TfmEditRBSync_Office.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBSync_Office.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBSync_Office.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainSmallNameLength;
  edNote.MaxLength:=DomainNoteLength;
  edKeys.MaxLength:=DomainNoteLength;
  edContact.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBSync_Office.edNameChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBSync_Office.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Byte(Key)=VK_SPACE then Key:=#0;
end;

end.

