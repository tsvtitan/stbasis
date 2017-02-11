unit UEditRBPms_Water;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBPms_Water = class(TfmEditRB)
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
    oldPms_Water_id: Variant;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBPms_Water: TfmEditRBPms_Water;

implementation

uses UPremisesTsvCode, UPremisesTsvData, UMainUnited, URBPms_Water;

{$R *.DFM}

procedure TfmEditRBPms_Water.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Water.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbPms_Water,1));
    sqls:='Insert into '+tbPms_Water+
          ' (Pms_Water_id,name,sortnumber,note) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+inttostr(udSort.Position)+
          ','+QuotedStr(Trim(edNote.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldPms_Water_id:=strtoint(id);

    TfmRBPms_Water(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBPms_Water(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBPms_Water(fmParent).MainQr do begin
      Insert;
      FieldByName('Pms_Water_id').AsInteger:=oldPms_Water_id;
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

procedure TfmEditRBPms_Water.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Water.UpdateRBooks: Boolean;
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

    id:=inttostr(oldPms_Water_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbPms_Water+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', note='+QuotedStr(Trim(edNote.text))+
          ', sortnumber='+inttostr(udSort.Position)+
          ' where Pms_Water_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBPms_Water(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBPms_Water(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBPms_Water(fmParent).MainQr do begin
      Edit;
      FieldByName('Pms_Water_id').AsInteger:=oldPms_Water_id;
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

procedure TfmEditRBPms_Water.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBPms_Water.CheckFieldsFill: Boolean;
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

procedure TfmEditRBPms_Water.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Water.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainShortNameLength;
  edNote.MaxLength:=DomainNoteLength;
  edSort.MaxLength:=3;
end;

procedure TfmEditRBPms_Water.udSortChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBPms_Water.edSortChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
