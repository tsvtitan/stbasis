unit URBUserApp;

interface

{$I stbasis.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IB, Menus, tsvDbGrid, IBUpdateSQL;

type
   TfmRBUserApp = class(TfmRBMainGrid)
    IBTranNew: TIBTransaction;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
  private
    isFindUserName,isFindApp: Boolean;
    FindUserName,FindApp: String;
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
  fmRBUserApp: TfmRBUserApp;

implementation

uses UMainUnited, USysTsvCode, USysTsvDM, USysTsvData, UEditRBUserApp;

{$R *.DFM}

procedure TfmRBUserApp.FormCreate(Sender: TObject);
var
 cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkUserApp;
  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  IBTranNew.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTranNew);

  cl:=Grid.Columns.Add;
  cl.FieldName:='appname';
  cl.Title.Caption:='Приложение';
  cl.Width:=180;

  cl:=Grid.Columns.Add;
  cl.FieldName:='usersname';
  cl.Title.Caption:='Пользователь';
  cl.Width:=180;
  LoadFromIni;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmRBUserApp.FormDestroy(Sender: TObject);
begin
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBUserApp:=nil;
end;

function TfmRBUserApp.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkUserApp+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBUserApp.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindUserName or isFindApp);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserApp.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id1,id2: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('usersname') then fn:='tu.name';
   if UpperCase(fn)=UpperCase('appname') then fn:='ta.name';
   id2:=MainQr.fieldByName('app_id').asString;
   id1:=MainQr.fieldByName('user_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('user_id;app_id',VarArrayOf([id1,id2]),[LocaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserApp.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBUserApp.LoadFromIni;
begin
 inherited;
 try
    FindUserName:=ReadParam(ClassName,'username',FindUserName);
    FindApp:=ReadParam(ClassName,'app',FindApp);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserApp.SaveToIni;
begin
 Inherited;
 try
    WriteParam(ClassName,'username',FindUserName);
    WriteParam(ClassName,'app',FindApp);
    WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUserApp.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBUserApp.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBUserApp;
begin
 try
  if not Mainqr.Active then exit;
  fm:=TfmEditRBUserApp.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('app_id;user_id',VarArrayOf([fm.App_id,fm.user_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmRBUserApp.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBUserApp;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBUserApp.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.SqlRoleOld:=Mainqr.fieldByName('sqlrole').AsString;
    fm.App_id:=Mainqr.fieldByName('app_id').AsInteger;
    fm.oldApp_id:=fm.App_id;
    fm.edApp.Text:=Mainqr.fieldByName('appname').AsString;
    fm.User_id:=Mainqr.fieldByName('user_id').AsInteger;
    fm.oldUser_id:=fm.User_id;
    fm.edUserName.Text:=Mainqr.fieldByName('usersname').AsString;
    fm.User_name:=Trim(Mainqr.fieldByName('user_name').AsString);
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('app_id;user_id',VarArrayOf([fm.App_id,fm.user_id]),[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBUserApp.bibDelClick(Sender: TObject);
var
  but: Integer;

  function Revoke(SqlRole,UserName: string): Boolean;
  var
    qr: TIBQuery;
    sqls: string;
  begin
   Result:=false;
   try
    Screen.Cursor:=crHourGlass;
    qr:=TIBQuery.Create(nil);
    try
      qr.Database:=IBDB;
      qr.Transaction:=IBTranNew;
      qr.Transaction.Active:=true;
      sqls:='revoke '+SqlRole+' from "'+UserName+'"';
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.Transaction.Commit;
      Result:=true;
    finally
      qr.Free;
      Screen.Cursor:=crDefault;
    end;
   except
    {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end;
  end;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
  begin
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try
     qr.Database:=IBDB;
     qr.Transaction:=IBTran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbUserApp+
           ' where user_id='+ QuotedStr(Mainqr.FieldByName('user_id').asString)+
           ' and app_id='+Mainqr.FieldByName('app_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     if not Revoke(Trim(Mainqr.FieldByName('sqlrole').asString),
                   Trim(Mainqr.FieldByName('user_name').asString)) then exit;
     qr.Transaction.Commit;
     ActiveQuery(false);
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
    qr.Free;
    Screen.Cursor:=crDefault;
   end;

  end;

begin
  if Mainqr.RecordCount=0 then exit;
  but:=DeleteWarningEx('доступ к приложению <'+Mainqr.FieldByName('appname').AsString+
                        '> у пользователя <'+Mainqr.FieldByName('usersname').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBUserApp.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBUserApp;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBUserApp.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.SqlRoleOld:=Mainqr.fieldByName('sqlrole').AsString;
    fm.App_id:=Mainqr.fieldByName('app_id').AsInteger;
    fm.oldApp_id:=fm.App_id;
    fm.edApp.Text:=Mainqr.fieldByName('appname').AsString;
    fm.User_id:=Mainqr.fieldByName('user_id').AsInteger;
    fm.oldUser_id:=fm.User_id;
    fm.edUserName.Text:=Mainqr.fieldByName('usersname').AsString;
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBUserApp.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBUserApp;
  filstr: string;
begin
 fm:=TfmEditRBUserApp.Create(nil);
 try
  fm.TypeEditRBook:=terbFilter;
  fm.edApp.Color:=clWindow;
  fm.edApp.ReadOnly:=false;
  fm.edUsername.Color:=clWindow;
  fm.edUsername.ReadOnly:=false;

  if Trim(FindApp)<>'' then fm.edApp.Text:=FindApp;
  if Trim(FindUserName)<>'' then fm.edUsername.Text:=FindUserName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindApp:=Trim(fm.edApp.Text);
    FindUserName:=Trim(fm.edUserName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.Free;
 end;
end;

function TfmRBUserApp.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindApp:=Trim(FindApp)<>'';
    isFindUserName:=Trim(FindUserName)<>'';

    if isFindApp or isFindUserName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindApp then begin
        addstr1:=' Upper(ta.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindApp+'%'))+' ';
     end;

     if isFindUserName then begin
        addstr2:=' Upper(tu.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindUserName+'%'))+' ';
     end;

     if (isFindApp and isFindUserName)
       then and1:=' and ';

     Result:=wherestr+addstr1+and1+addstr2;
end;


end.
