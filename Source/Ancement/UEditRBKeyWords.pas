unit UEditRBKeyWords;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UEditRB, StdCtrls, Buttons, ExtCtrls, IBServices, IBQuery, db, IBDatabase, IB,
  ComCtrls,tsvStdCtrls, tsvComCtrls;

type
  TfmEditRBKeyWords = class(TfmEditRB)
    lbTreeHeading: TLabel;
    edTreeHeading: TEdit;
    bibTreeHeading: TButton;
    lbWord: TLabel;
    edWord: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure bibTreeHeadingClick(Sender: TObject);
    procedure edWordChange(Sender: TObject);
    procedure edWordKeyPress(Sender: TObject; var Key: Char);
  protected
    function AddToRBooks: Boolean; override;
    function UpdateRBooks: Boolean; override;
    function CheckFieldsFill: Boolean; override;
  public
    fmParent: TForm;
    oldword_id: Integer;
    treeheading_id: Integer;
    procedure AddClick(Sender: TObject); override;
    procedure ChangeClick(Sender: TObject); override;
    procedure FilterClick(Sender: TObject); override;
  end;

var
  fmEditRBKeyWords: TfmEditRBKeyWords;

implementation

uses UAncementCode, UAncementData, UMainUnited, URBKeyWords;

{$R *.DFM}

procedure TfmEditRBKeyWords.FilterClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

function TfmEditRBKeyWords.AddToRBooks: Boolean;
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
    id:=inttostr(GetGenId(IBDB,tbKeyWords,1));
    sqls:='Insert into '+tbKeyWords+
          ' (word_id,treeheading_id,word) values '+
          ' ('+id+
          ','+inttostr(treeheading_id)+
          ','+QuotedStr(ChangeString(Trim(edWord.text),' ',''))+')';
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
    oldword_id:=strtoint(id);

    TfmRBKeyWords(fmParent).IBUpd.InsertSQL.Clear;
    TfmRBKeyWords(fmParent).IBUpd.InsertSQL.Add(sqls);

    with TfmRBKeyWords(fmParent).MainQr do begin
      Insert;
      FieldByName('word_id').AsInteger:=oldword_id;
      FieldByName('treeheading_id').AsInteger:=treeheading_id;
      FieldByName('word').AsString:=ChangeString(Trim(edWord.text),' ','');
      FieldByName('treeheadingname').AsString:=Trim(edTreeHeading.Text);
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

procedure TfmEditRBKeyWords.AddClick(Sender: TObject);
begin
  if not CheckFieldsFill then exit;
  if not AddToRBooks then exit;
  ModalResult:=mrOk;
end;

function TfmEditRBKeyWords.UpdateRBooks: Boolean;
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

    id:=inttostr(oldword_id);
    qr.Database:=IBDB;
    qr.Transaction:=IBTran;
    qr.Transaction.Active:=true;
    sqls:='Update '+tbKeyWords+
          ' set treeheading_id='+inttostr(treeheading_id)+
          ', word='+QuotedStr(ChangeString(Trim(edWord.text),' ',''))+
          ' where word_id='+id;
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;

    TfmRBKeyWords(fmParent).IBUpd.ModifySQL.Clear;
    TfmRBKeyWords(fmParent).IBUpd.ModifySQL.Add(sqls);

    with TfmRBKeyWords(fmParent).MainQr do begin
      Edit;
      FieldByName('word_id').AsInteger:=oldword_id;
      FieldByName('treeheading_id').AsInteger:=treeheading_id;
      FieldByName('word').AsString:=ChangeString(Trim(edWord.text),' ','');
      FieldByName('treeheadingname').AsString:=Trim(edTreeHeading.Text);
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

procedure TfmEditRBKeyWords.ChangeClick(Sender: TObject);
begin
  if ChangeFlag then begin
   if not CheckFieldsFill then exit;
   if not UpdateRBooks then exit;
  end; 
  ModalResult:=mrOk;
end;

function TfmEditRBKeyWords.CheckFieldsFill: Boolean;
begin
  Result:=true;
  if trim(edWord.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbWord.Caption]));
    edWord.SetFocus;
    Result:=false;
    exit;
  end;
  if trim(edTreeHeading.Text)='' then begin
    ShowErrorEx(Format(ConstFieldNoEmpty,[lbTreeHeading.Caption]));
    bibTreeHeading.SetFocus;
    Result:=false;
    exit;
  end;
end;

procedure TfmEditRBKeyWords.FormCreate(Sender: TObject);
begin
  inherited;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  edWord.MaxLength:=DomainSmallNameLength;
  edTreeHeading.MaxLength:=DomainNameLength;
end;

procedure TfmEditRBKeyWords.bibTreeHeadingClick(Sender: TObject);
var
  TPRBI: TParamRBookInterface;
begin
  FillChar(TPRBI,SizeOf(TPRBI),0);
  TPRBI.Visual.TypeView:=tvibvModal;
  TPRBI.Locate.KeyFields:='treeheading_id';
  TPRBI.Locate.KeyValues:=treeheading_id;
  TPRBI.Locate.Options:=[loCaseInsensitive];
  if _ViewInterfaceFromName(NameRbkTreeHeading,@TPRBI) then begin
   ChangeFlag:=true;
   treeheading_id:=GetFirstValueFromParamRBookInterface(@TPRBI,'treeheading_id');
   edTreeHeading.Text:=GetFirstValueFromParamRBookInterface(@TPRBI,'nameheading');
  end;
end;

procedure TfmEditRBKeyWords.edWordChange(Sender: TObject);
begin
  ChangeFlag:=true;
end;

procedure TfmEditRBKeyWords.edWordKeyPress(Sender: TObject; var Key: Char);
begin
  if Byte(Key)=VK_SPACE then Key:=#0;
end;

end.
