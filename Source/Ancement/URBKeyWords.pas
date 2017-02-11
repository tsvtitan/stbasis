unit URBKeyWords;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBKeyWords = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindWord,isFindTreeHeadingName: Boolean;
    FindWord,FindTreeHeadingName: String;
  protected
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    function GetSql: string; override;
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBKeyWords: TfmRBKeyWords;

implementation

uses UMainUnited, UAncementCode, UAncementDM, UAncementData, UEditRBKeyWords;

{$R *.DFM}

procedure TfmRBKeyWords.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkKeyWords;
  
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='treeheadingname';
  cl.Title.Caption:='Рубрика';
  cl.Width:=100;

  cl:=Grid.Columns.Add;
  cl.FieldName:='word';
  cl.Title.Caption:='Слово';
  cl.Width:=150;


  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKeyWords.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBKeyWords:=nil;
end;

function TfmRBKeyWords.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkKeyWords+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBKeyWords.ActiveQuery(CheckPerm: Boolean);
var
 sqls: String;
begin
 try
  Mainqr.Active:=false;
  if CheckPerm then
   if not CheckPermission then exit;

  Screen.Cursor:=crHourGlass;
  Mainqr.DisableControls;
  try
   Mainqr.sql.Clear;
   sqls:=GetSql;
   Mainqr.sql.Add(sqls);
   Mainqr.Transaction.Active:=false;
   Mainqr.Transaction.Active:=true;
   Mainqr.Active:=true;
   SetImageFilter(isFindWord or isFindTreeHeadingName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKeyWords.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('word_id').asString;
   if UpperCase(fn)=UpperCase('treeheadingname') then fn:='th.nameheading';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('word_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKeyWords.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBKeyWords.LoadFromIni;
begin
 inherited;
 try
    FindWord:=ReadParam(ClassName,'word',FindWord);
    FindTreeHeadingName:=ReadParam(ClassName,'treeheadingname',FindTreeHeadingName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKeyWords.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'word',FindWord);
    WriteParam(ClassName,'treeheadingname',FindTreeHeadingName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBKeyWords.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBKeyWords.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBKeyWords;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBKeyWords.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('word_id',fm.oldword_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBKeyWords.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBKeyWords;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBKeyWords.Create(nil);
  try
    fm.fmParent:=Self;
    fm.edWord.Text:=Mainqr.fieldByName('word').AsString;
    fm.treeheading_id:=Mainqr.fieldByName('treeheading_id').AsInteger;
    fm.edTreeHeading.Text:=Mainqr.fieldByName('treeheadingname').AsString;
    fm.oldword_id:=MainQr.FieldByName('word_id').AsInteger;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('word_id',fm.oldword_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBKeyWords.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    tran: TIBTransaction;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   tran:=TIBTransaction.Create(nil);
   try
    result:=false;
    try
     tran.AddDatabase(IBDB);
     IBDB.AddTransaction(tran);
     tran.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=IBDB;
     qr.Transaction:=tran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbKeyWords+' where word_id='+
          Mainqr.FieldByName('word_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
//     ActiveQuery(false);

     IBUpd.DeleteSQL.Clear;
     IBUpd.DeleteSQL.Add(sqls);
     Mainqr.Delete;
     
     ViewCount;

     Result:=true;
    except
     on E: EIBInterBaseError do begin
        TempStr:=TranslateIBError(E.Message);
        ShowErrorEx(TempStr);
        Assert(false,TempStr);
     end;
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
   finally
    tran.Free; 
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('ключевое слово <'+Mainqr.FieldByName('word').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBKeyWords.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBKeyWords;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBKeyWords.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edWord.Text:=Mainqr.fieldByName('word').AsString;
    fm.treeheading_id:=Mainqr.fieldByName('treeheading_id').AsInteger;
    fm.edTreeHeading.Text:=Mainqr.fieldByName('treeheadingname').AsString;
    fm.oldword_id:=MainQr.FieldByName('word_id').AsInteger;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBKeyWords.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBKeyWords;
  filstr: string;
begin
 fm:=TfmEditRBKeyWords.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edTreeHeading.ReadOnly:=false;
  fm.edTreeHeading.Color:=clWindow;

  if Trim(FindWord)<>'' then fm.edWord.Text:=FindWord;
  if Trim(FindTreeHeadingName)<>'' then fm.edTreeHeading.Text:=FindTreeHeadingName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindWord:=Trim(fm.edWord.Text);
    FindTreeHeadingName:=Trim(fm.edTreeHeading.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBKeyWords.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindWord:=Trim(FindWord)<>'';
    isFindTreeHeadingName:=Trim(FindTreeHeadingName)<>'';

    if isFindWord or isFindTreeHeadingName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindWord then begin
        addstr1:=' Upper(word) like '+AnsiUpperCase(QuotedStr(FilInSide+FindWord+'%'))+' ';
     end;

     if isFindTreeHeadingName then begin
        addstr2:=' Upper(th.nameheading) like '+AnsiUpperCase(QuotedStr(FilInSide+FindTreeHeadingName+'%'))+' ';
     end;

     if isFindWord and isFindTreeHeadingName then
       and1:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2;
end;


end.
