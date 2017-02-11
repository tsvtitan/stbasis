unit URBSync_Office;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, grids, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBSync_Office = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName: Boolean;
    FindName: String;

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
  fmRBSync_Office: TfmRBSync_Office;

implementation

uses UMainUnited, USyncServerCode, USyncServerDM, USyncServerData, UEditRBSync_Office;

{$R *.DFM}

procedure TfmRBSync_Office.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkSync_Office;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Наименование';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='note';
  cl.Title.Caption:='Описание';
  cl.Width:=200;

  cl:=Grid.Columns.Add;
  cl.FieldName:='contact';
  cl.Title.Caption:='Телефон';
  cl.Width:=100;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Office.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBSync_Office:=nil;
end;

function TfmRBSync_Office.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkSync_Office+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBSync_Office.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Office.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('sync_office_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('sync_office_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Office.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBSync_Office.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Office.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Office.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBSync_Office.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBSync_Office;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBSync_Office.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('sync_office_id',fm.oldsync_office_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_Office.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBSync_Office;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBSync_Office.Create(nil);
  try
    fm.fmParent:=Self;
    fm.bibOk.OnClick:=fm.ChangeClick;
    fm.Caption:=CaptionChange;
    fm.oldsync_office_id:=Mainqr.fieldByName('sync_office_id').AsInteger;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edNote.Text:=Mainqr.fieldByName('note').AsString;
    fm.edKeys.Text:=Mainqr.fieldByName('keys').AsString;
    fm.edContact.Text:=Mainqr.fieldByName('contact').AsString;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     MainQr.Locate('sync_office_id',fm.oldsync_office_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_Office.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbSync_Office+' where sync_office_id='+
            Mainqr.FieldByName('sync_office_id').asString;
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
  but:=DeleteWarningEx('наименование <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBSync_Office.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBSync_Office;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBSync_Office.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.oldsync_office_id:=Mainqr.fieldByName('sync_office_id').AsInteger;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edNote.Text:=Mainqr.fieldByName('note').AsString;
    fm.edKeys.Text:=Mainqr.fieldByName('keys').AsString;
    fm.edContact.Text:=Mainqr.fieldByName('contact').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_Office.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBSync_Office;
  filstr: string;
begin
 fm:=TfmEditRBSync_Office.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  fm.edNote.Enabled:=false;
  fm.edNote.Color:=clBtnFace;
  fm.lbNote.Enabled:=false;
  fm.edKeys.Enabled:=false;
  fm.edKeys.Color:=clBtnFace;
  fm.lbKeys.Enabled:=false;
  fm.edContact.Enabled:=false;
  fm.edContact.Color:=clBtnFace;
  fm.lbContact.Enabled:=false;
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    Inherited;

    FindName:=Trim(fm.edName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBSync_Office.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';

    if isFindName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     Result:=wherestr+addstr1;
end;


end.


