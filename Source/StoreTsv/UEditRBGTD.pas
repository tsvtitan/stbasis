unit UEditRBGTD;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB;

type
  TfmEditRBGTD = class(TfmEditRB)
    lbNum: TLabel;
    edNum: TEdit;
    lbNote: TLabel;
    meNote: TMemo;
    procedure edNumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldgtd_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBGTD: TfmEditRBGTD;

implementation

uses UStoreTsvCode, UStoreTsvData, UMainUnited, URBGTD;

{$R *.DFM}

procedure TfmEditRBGTD.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBGTD.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbGTD,1));
    sqls:='Insert into '+tbGTD+
          ' (gtd_id,num,note) values '+     
          ' ('+id+
          ','+QuotedStr(Trim(edNum.Text))+
          ','+QuotedStr(Trim(meNote.Lines.Text))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldgtd_id:=strtoint(id);

    TfmRBGTD(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBGTD(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBGTD(fmParent).MainQr do begin
      Insert;
      FieldByName('gtd_id').AsInteger:=oldgtd_id;
      FieldByName('num').AsString:=Trim(edNum.Text);
      FieldByName('note').AsString:=Trim(meNote.Lines.Text);
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

procedure TfmEditRBGTD.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBGTD.UpdateRBooks: Boolean;
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

    id:=inttostr(oldgtd_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbGTD+
          ' set num='+QuotedStr(Trim(edNum.text))+
          ', note='+QuotedStr(Trim(meNote.LInes.text))+
          ' where gtd_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBGTD(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBGTD(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBGTD(fmParent).MainQr do begin
      Edit;
      FieldByName('gtd_id').AsInteger:=oldgtd_id;
      FieldByName('num').AsString:=Trim(edNum.Text);
      FieldByName('note').AsString:=Trim(meNote.Lines.Text);
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

procedure TfmEditRBGTD.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBGTD.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edNum.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbNum.Caption]));
    edNum.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBGTD.edNumChange(Sender: TObject);
begin
  inherited;
  ChangeFlag:=true;
end;

procedure TfmEditRBGTD.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edNum.MaxLength:=DomainSmallNameLength;
  meNote.MaxLength:=DomainNoteLength;
end;

end.
