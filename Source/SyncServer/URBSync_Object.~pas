unit URBSync_Object;

interface
{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBSync_Object = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindPackage,isFindName: Boolean;
    FindPackage,FindName: String;
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
  fmRBSync_Object: TfmRBSync_Object;

implementation

uses UMainUnited, USyncServerCode, USyncServerDM, USyncServerData, UEditRBSync_Object;

{$R *.DFM}

procedure TfmRBSync_Object.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkSync_Object;
  
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Наименование';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='package_name';
  cl.Title.Caption:='Пакет';
  cl.Width:=150;

  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Object.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBSync_Object:=nil;
end;

function TfmRBSync_Object.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkSync_Object+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBSync_Object.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindPackage or isFindName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Object.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('sync_object_id').asString;
   if UpperCase(fn)=UpperCase('package_name') then fn:='sp.name';
   if UpperCase(fn)=UpperCase('name') then fn:='so.name';
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('sync_object_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Object.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBSync_Object.LoadFromIni;
begin
 inherited;
 try
    FindPackage:=ReadParam(ClassName,'package',FindPackage);
    FindName:=ReadParam(ClassName,'name',FindName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Object.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'package',FindPackage);
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBSync_Object.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBSync_Object.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBSync_Object;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBSync_Object.Create(nil);
  try
    fm.fmParent:=Self;
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ViewCount;
     MainQr.Locate('sync_object_id',fm.oldsync_object_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_Object.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBSync_Object;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBSync_Object.Create(nil);
  try
    fm.fmParent:=Self;
    fm.sync_package_id:=Mainqr.fieldByName('sync_package_id').AsInteger;
    fm.edPackage.Text:=Mainqr.fieldByName('package_name').AsString;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.oldsync_object_id:=MainQr.FieldByName('sync_object_id').AsInteger;
    fm.meFieldsKey.Lines.Text:=Mainqr.fieldByName('fields_key').AsString;
    fm.meFieldsSync.Lines.Text:=Mainqr.fieldByName('fields_sync').AsString;
    fm.meCondition.Lines.Text:=Mainqr.fieldByName('condition').AsString;
    fm.meSqlBefore.Lines.Text:=Mainqr.fieldByName('sql_before').AsString;
    fm.meSqlAfter.Lines.Text:=Mainqr.fieldByName('sql_after').AsString;
    fm.TypeEditRBook:=terbChange;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
      MainQr.Locate('sync_object_id',fm.oldsync_object_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_Object.bibDelClick(Sender: TObject);
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
     sqls:='Delete from '+tbSync_Object+' where sync_object_id='+
            Mainqr.FieldByName('sync_object_id').asString;
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

procedure TfmRBSync_Object.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBSync_Object;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  fm:=TfmEditRBSync_Object.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.sync_package_id:=Mainqr.fieldByName('sync_package_id').AsInteger;
    fm.edPackage.Text:=Mainqr.fieldByName('package_name').AsString;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.oldsync_object_id:=MainQr.FieldByName('sync_object_id').AsInteger;
    fm.meFieldsKey.Lines.Text:=Mainqr.fieldByName('fields_key').AsString;
    fm.meFieldsSync.Lines.Text:=Mainqr.fieldByName('fields_sync').AsString;
    fm.meCondition.Lines.Text:=Mainqr.fieldByName('condition').AsString;
    fm.meSqlBefore.Lines.Text:=Mainqr.fieldByName('sql_before').AsString;
    fm.meSqlAfter.Lines.Text:=Mainqr.fieldByName('sql_after').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBSync_Object.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBSync_Object;
  filstr: string;
begin
 fm:=TfmEditRBSync_Object.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;

  fm.edPackage.ReadOnly:=false;
  fm.edPackage.Color:=clWindow;

  if Trim(FindPackage)<>'' then fm.edPackage.Text:=FindPackage;
  if Trim(FindName)<>'' then fm.edName.Text:=FindName;

  fm.meFieldsKey.Enabled:=false;
  fm.meFieldsKey.Color:=clBtnFace;
  fm.lbFieldsKey.Enabled:=false;

  fm.meFieldsSync.Enabled:=false;
  fm.meFieldsSync.Color:=clBtnFace;
  fm.lbFieldsSync.Enabled:=false;

  fm.meCondition.Enabled:=false;
  fm.meCondition.Color:=clBtnFace;
  fm.lbCondition.Enabled:=false;

  fm.meSqlBefore.Enabled:=false;
  fm.meSqlBefore.Color:=clBtnFace;
  fm.lbSqlBefore.Enabled:=false;

  fm.meSqlAfter.Enabled:=false;
  fm.meSqlAfter.Color:=clBtnFace;
  fm.lbSqlAfter.Enabled:=false;
  
  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindPackage:=Trim(fm.edPackage.Text);
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

function TfmRBSync_Object.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindPackage:=Trim(FindPackage)<>'';
    isFindName:=Trim(FindName)<>'';

    if isFindPackage or isFindName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindPackage then begin
        addstr1:=' Upper(sp.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindPackage+'%'))+' ';
     end;

     if isFindName then begin
        addstr2:=' Upper(so.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindPackage and isFindName then
       and1:=' and ';

     Result:=wherestr+addstr1+and1+
                      addstr2;
end;


end.
