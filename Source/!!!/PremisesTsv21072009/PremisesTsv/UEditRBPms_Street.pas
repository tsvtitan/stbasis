unit UEditRBPms_Street;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBPMS_Street = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbShortName: TLabel;
    edShortName: TEdit;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldPms_Street_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPMS_Street: TfmEditRBPMS_Street;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Street;

{$R *.DFM}

procedure TfmEditRBPMS_Street.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPMS_Street.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbPms_Street,1));
    sqls:='Insert into '+tbPms_Street+
          ' (Pms_Street_id,name,shortname) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+QuotedStr(Trim(edShortName.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_Street_id:=strtoint(id);

    TfmRBPms_Street(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Street(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Street(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_Street_id').AsInteger:=oldPms_Street_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('shortname').AsString:=Trim(edShortName.Text);
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

procedure TfmEditRBPMS_Street.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPMS_Street.UpdateRBooks: Boolean;
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

    id:=inttostr(oldPms_Street_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPms_Street+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', shortname='+QuotedStr(Trim(edShortName.text))+
          ' where Pms_Street_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_Street(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Street(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Street(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_Street_id').AsInteger:=oldPms_Street_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('shortname').AsString:=Trim(edShortName.Text);
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

procedure TfmEditRBPMS_Street.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPMS_Street.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edShortName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbShortName.Caption]));
    edShortName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBPMS_Street.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPMS_Street.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  edShortName.MaxLength:=DomainShortNameLength;
end;

end.
