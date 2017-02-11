unit UEditRBPms_Phone;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPms_Phone = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbNote: TLabel;
    edNote: TEdit;
    lbSortNumber: TLabel;
    edSort: TEdit;
    udSort: TUpDown;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure udSortChanging(Sender: TObject; var AllowChange: Boolean);
    procedure edSortChange(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldPms_Phone_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPms_Phone: TfmEditRBPms_Phone;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Phone,
  UPremisesTsvOptions;

{$R *.DFM}

procedure TfmEditRBPms_Phone.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Phone.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbPms_Phone,1));
    sqls:='Insert into '+tbPms_Phone+
          ' (Pms_Phone_id,name,sortnumber,note) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+inttostr(udSort.Position)+
          ','+QuotedStr(Trim(edNote.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_Phone_id:=strtoint(id);

    TfmRBPms_Phone(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Phone(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Phone(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_Phone_id').AsInteger:=oldPms_Phone_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
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

procedure TfmEditRBPms_Phone.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Phone.UpdateRBooks: Boolean;
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

    id:=inttostr(oldPms_Phone_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPms_Phone+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', note='+QuotedStr(Trim(edNote.text))+
          ', sortnumber='+inttostr(udSort.Position)+
          ' where Pms_Phone_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_Phone(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Phone(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Phone(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_Phone_id').AsInteger:=oldPms_Phone_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('note').AsString:=Trim(edNote.Text);
      FieldByName('sortnumber').AsInteger:=udSort.Position;
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

procedure TfmEditRBPms_Phone.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Phone.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edNote.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNote.Caption]));
    edNote.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPms_Phone.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Phone.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainShortNameLength;
  edName.Font.Assign(fmOptions.edPhoneColumn.Font);
  edNote.MaxLength:=DomainNoteLength;
  edSort.MaxLength:=3;
end;

procedure TfmEditRBPms_Phone.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Phone.edSortChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
