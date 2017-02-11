unit UEditRBToolbar;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls;

type
  TfmEditRBToolbar = class(TfmEditRB)
    lbName: TLabel;
    edName: TEdit;
    lbHint: TLabel;
    meHint: TMemo;
    lbShortCut: TLabel;
    htShortCut: THotKey;
    procedure edNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure htShortCutEnter(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldtoolbar_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBToolbar: TfmEditRBToolbar;

implementation

uses UDesignTsvCode, UDesignTsvData, UMainUnited, URBToolBar;

{$R *.DFM}

procedure TfmEditRBToolbar.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBToolbar.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbToolBar,1));
    sqls:='Insert into '+tbToolBar+
          ' (toolbar_id,name,hint,shortcut) values '+
          ' ('+id+
          ','+QuotedStr(Trim(edName.Text))+
          ','+Iff(Trim(meHint.Lines.Text)<>'',QuotedStr(Trim(meHint.Lines.Text)),'null')+
          ','+inttostr(htShortCut.HotKey)+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldtoolbar_id:=strtoint(id);

    TfmRBToolbar(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBToolbar(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBToolbar(fmParent).MainQr do begin
      Insert;
      FieldByName('toolbar_id').AsInteger:=oldtoolbar_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('hint').Value:=iff(Trim(meHint.Lines.Text)<>'',Trim(meHint.Lines.Text),Null);
      FieldByName('shortcut').AsInteger:=htShortCut.HotKey;
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

procedure TfmEditRBToolbar.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBToolbar.UpdateRBooks: Boolean;
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

    id:=inttostr(oldtoolbar_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbToolbar+
          ' set name='+QuotedStr(Trim(edName.text))+
          ', hint='+Iff(Trim(meHint.Lines.Text)<>'',QuotedStr(Trim(meHint.Lines.Text)),'null')+
          ', shortcut='+inttostr(htShortCut.HotKey)+
          ' where toolbar_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBToolBar(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBToolBar(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBToolBar(fmParent).MainQr do begin
      Edit;
      FieldByName('toolbar_id').AsInteger:=oldtoolbar_id;
      FieldByName('name').AsString:=Trim(edName.Text);
      FieldByName('hint').Value:=iff(Trim(meHint.Lines.Text)<>'',Trim(meHint.Lines.Text),Null);
      FieldByName('shortcut').AsInteger:=htShortCut.HotKey;
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

procedure TfmEditRBToolbar.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBToolbar.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edName.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbName.Caption]));
    edName.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBToolbar.edNameChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBToolbar.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edName.MaxLength:=DomainNameLength;
  meHint.MaxLength:=DomainNoteLength;
end;

procedure TfmEditRBToolbar.htShortCutEnter(Sender: TObject);
begin
  ChangeFlag:=true;
end;

end.
