unit UEditRBRusWords;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBRusWords = class(TfmEditRB)
    lbWord: TLabel;
    edWord: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure edWordChange(Sender: TObject);
    procedure edWordKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldrusword_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBRusWords: TfmEditRBRusWords;

implementation

uses UAncementCode, UAncementData, UMainUnited, URBKeyWords;

{$R *.DFM}

procedure TfmEditRBRusWords.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBRusWords.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbRuswords,1));
    sqls:='Insert into '+tbRuswords+
          ' (rusword_id,name) values '+
          ' ('+id+
          ','+QuotedStr(ChangeString(Trim(edWord.text),' ',''))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldrusword_id:=strtoint(id);

    TfmRBKeyWords(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBKeyWords(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBKeyWords(fmParent).MainQr do begin
      Insert;
      FieldByName('rusword_id').AsInteger:=oldrusword_id;
      FieldByName('name').AsString:=ChangeString(Trim(edWord.text),' ','');
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

procedure TfmEditRBRusWords.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBRusWords.UpdateRBooks: Boolean;
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

    id:=inttostr(oldrusword_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbRuswords+
          ' set name='+QuotedStr(ChangeString(Trim(edWord.text),' ',''))+
          ' where rusword_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBKeyWords(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBKeyWords(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBKeyWords(fmParent).MainQr do begin
      Edit;
      FieldByName('rusword_id').AsInteger:=oldrusword_id;
      FieldByName('name').AsString:=ChangeString(Trim(edWord.text),' ','');
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

procedure TfmEditRBRusWords.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBRusWords.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edWord.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbWord.Caption]));
    edWord.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBRusWords.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edWord.MaxLength:=DomainSmallNameLength;
end;

procedure TfmEditRBRusWords.edWordChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBRusWords.edWordKeyPress(Sender: TObject; var Key: Char);
begin
  if Byte(Key)=VK_SPACE then Key:=#0;
end;

end.
