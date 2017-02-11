unit URBApp;

interface
{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBApp = class(TfmRBMainGrid)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindName,isFindSqlRole: Boolean;
    FindName,FindSqlRole: String;
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
  fmRBApp: TfmRBApp;

implementation

uses UMainUnited, USysTsvCode, USysTsvDM, USysTsvData, UEditRBApp,
  tsvPicture;

{$R *.DFM}

procedure TfmRBApp.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
  inherited;
  try
   Caption:=NameRbkApp;
   
   Mainqr.Database:=IBDB;
   IBTran.AddDatabase(IBDB);
   IBDB.AddTransaction(IBTran);

   cl:=Grid.Columns.Add;
   cl.FieldName:='name';
   cl.Title.Caption:='Приложение';
   cl.Width:=200;

   cl:=Grid.Columns.Add;
   cl.FieldName:='sqlrole';
   cl.Title.Caption:='Роль';
   cl.Width:=120;

   LoadFromIni;
  except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
  end; 
end;

procedure TfmRBApp.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBApp:=nil;
end;

function TfmRBApp.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkApp+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBApp.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName or isFindSqlRole);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBApp.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('app_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('app_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBApp.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBApp.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindSqlRole:=ReadParam(ClassName,'sqlrole',FindSqlRole);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBApp.SaveToIni;
begin
 inherited;
 try
    WriteParam(ClassName,'name',FindName);
    WriteParam(ClassName,'sqlrole',FindSqlRole);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBApp.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBApp.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBApp;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBApp.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('app_id',fm.app_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBApp.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBApp;
  ms: TMemoryStream;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBApp.Create(nil);
  ms:=TMemoryStream.Create;
  try
    fm.TypeEditRBook:=terbChange;
    fm.app_id:=MainQr.FieldByName('app_id').AsInteger;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edRole.Text:=Mainqr.fieldByName('sqlrole').AsString;
    TBlobField(Mainqr.fieldByName('image')).SaveToStream(ms);
    ms.Position:=0;
    try
      TTsvPicture(fm.imImage.Picture).LoadFromStream(ms);
    except
    end;  
    fm.chbImageStretchClick(nil);

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('app_id',fm.app_id,[loCaseInsensitive]);
    end;
  finally
    ms.Free;
    fm.Free;
  end;
end;

procedure TfmRBApp.bibDelClick(Sender: TObject);
var
  but: Integer;

  function DeleteRecord: Boolean;
  var
   qr: TIBQuery;
   sqls: string;
   CU: TInfoConnectUser;
  begin
   Result:=false;
   FillChar(CU,SizeOf(TInfoConnectUser),0);
   _GetInfoConnectUser(@CU);
   if CU.App_id=Mainqr.FieldByName('app_id').AsInteger then exit;
   try
    Screen.Cursor:=crHourGlass;
    qr:=TIBQuery.Create(nil);
    try
     qr.Database:=IBDB;
     qr.Transaction:=IBTran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbApp+' where app_id='+
          Mainqr.FieldByName('app_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     if ExistsRole(Mainqr.FieldByName('sqlrole').AsString) then
      if not DropRole(Mainqr.FieldByName('sqlrole').AsString) then exit;
     qr.Transaction.Commit;
     ActiveQuery(false);
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
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end; 
  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('приложение <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBApp.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBApp;
  ms: TMemoryStream;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBApp.Create(nil);
  ms:=TMemoryStream.Create;
  try
    fm.TypeEditRBook:=terbView;
    fm.app_id:=MainQr.FieldByName('app_id').AsInteger;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edRole.Text:=Mainqr.fieldByName('sqlrole').AsString;
    TBlobField(Mainqr.fieldByName('image')).SaveToStream(ms);
    ms.Position:=0;
    try
      TTsvPicture(fm.imImage.Picture).LoadFromStream(ms);
    except
    end;
    fm.chbImageStretchClick(nil);

    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
    end;
  finally
    ms.Free;
    fm.Free;
  end;
end;

procedure TfmRBApp.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBApp;
  filstr: string;
begin
 fm:=TfmEditRBApp.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;
  fm.lbImage.Enabled:=false;
  fm.imImage.Enabled:=false;
  fm.bibImageLoad.Enabled:=false;
  fm.bibImageSave.Enabled:=false;
  fm.bibImageCopy.Enabled:=false;
  fm.bibImagePaste.Enabled:=false;
  fm.bibImageClear.Enabled:=false;
  fm.chbImageStretch.Enabled:=false;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindSqlRole)<>'' then fm.edRole.Text:=FindSqlRole;

  fm.cbInString.Checked:=FilterInSide;
  
  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);
    FindSqlRole:=Trim(fm.edRole.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBApp.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindSqlRole:=Trim(FindSqlRole)<>'';

    if isFindName or isFindSqlRole then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindSqlRole then begin
        addstr2:=' Upper(sqlrole) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSqlRole+'%'))+' ';
     end;

     if (isFindName and isFindSqlRole)
       then and1:=' and ';

     Result:=wherestr+addstr1+and1+addstr2;
end;


end.
