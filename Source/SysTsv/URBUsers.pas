unit URBUsers;

interface

{$I stbasis.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  URBMainGrid, Db, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, dbgrids, IBDatabase, IBEvents, IBSQLMonitor, IB,
  Menus, tsvDbGrid, IBUpdateSQL, IBServices;

type
   TfmRBUsers = class(TfmRBMainGrid)
    Button1: TButton;
    IBSecServ: TIBSecurityService;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bibRefreshClick(Sender: TObject);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibViewClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

    isFindName,isFindSqlName: Boolean;
    FindName,FindSqlName: String;
  protected  
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort); override;
    procedure GridDblClick(Sender: TObject); override;
    procedure SaveToIni;override;
    procedure LoadFromIni; override;
    function GetFilterString: string; override;
    function GetSql: string; override;
    
  public
    procedure ActiveQuery(CheckPerm: Boolean);override;
  end;

var
  fmRBUsers: TfmRBUsers;

implementation

uses UMainUnited, USysTsvCode, USysTsvDM, USysTsvData, UEditRBUsers;

{$R *.DFM}

var
//  PCTBar: TCreateToolBar;
  tbar1: THandle;
  hMenu: THandle;

procedure TfmRBUsers.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
 inherited;
 try
  Caption:=NameRbkUsers;

  Mainqr.Database:=IBDB;
  IBTran.AddDatabase(IBDB);
  IBDB.AddTransaction(IBTran);

  cl:=Grid.Columns.Add;
  cl.FieldName:='name';
  cl.Title.Caption:='Имя пользователя';
  cl.Width:=150;

  cl:=Grid.Columns.Add;
  cl.FieldName:='user_name';
  cl.Title.Caption:='SQL пользователь';
  cl.Width:=150;

  LoadFromIni;

 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmRBUsers.FormDestroy(Sender: TObject);
begin
  _FreeToolBar(tbar1);
  _FreeMenu(hMenu);
  inherited;
  if FormState=[fsCreatedMDIChild] then
   fmRBUsers:=nil;
end;

function TfmRBUsers.GetSql: string;
begin
  Result:= inherited GetSql;
  if Trim(Result)<>'' then exit;
  Result:=SQLRbkUsers+GetFilterString+GetLastOrderStr;
end;

procedure TfmRBUsers.ActiveQuery(CheckPerm: Boolean);
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
   SetImageFilter(isFindName or isFindSqlName);
   ViewCount;
  finally
   Mainqr.EnableControls;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsers.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: string;
begin
 try
   if not MainQr.Active then exit;
   fn:=Column.FieldName;
   id:=MainQr.fieldByName('user_id').asString;
   SetLastOrderFromTypeSort(fn,TypeSort);
   ActiveQuery(false);
   MainQr.First;
   MainQr.Locate('user_id',id,[loCaseInsensitive]);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end; 
end;

procedure TfmRBUsers.GridDblClick(Sender: TObject);
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if pnSQL.Visible and bibChange.Enabled then begin
   bibChange.Click;
  end else bibView.Click;
end;

procedure TfmRBUsers.LoadFromIni;
begin
 inherited;
 try
    FindName:=ReadParam(ClassName,'name',FindName);
    FindSqlName:=ReadParam(ClassName,'sqlname',FindSqlName);
    FilterInside:=ReadParam(ClassName,'Inside',FilterInside);
 except
   {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsers.SaveToIni;
begin
 inherited;
 try
   WriteParam(ClassName,'name',FindName);
   WriteParam(ClassName,'sqlname',FindSqlName);
   WriteParam(ClassName,'Inside',FilterInside);
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

procedure TfmRBUsers.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery(true);
end;

procedure TfmRBUsers.bibAddClick(Sender: TObject);
var
  fm: TfmEditRBUser;
begin
  if not Mainqr.Active then exit;
  fm:=TfmEditRBUser.Create(nil);
  try
    fm.TypeEditRBook:=terbAdd;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('user_id',fm.olduser_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBUsers.bibChangeClick(Sender: TObject);
var
  fm: TfmEditRBUser;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  if AnsiUpperCase(Mainqr.FieldByName('user_name').asString)=
      AnsiUpperCase(ConstConnectUserName) then begin
      ShowErrorEx(
               'Пользователя <'+Mainqr.FieldByName('name').AsString+'> нельзя изменить.');
      exit;
  end;
  if AnsiUpperCase(Mainqr.FieldByName('user_name').asString)=
      AnsiUpperCase(ConstUserSysDba) then begin
      ShowErrorEx(
               'Пользователя <'+Mainqr.FieldByName('name').AsString+'> нельзя изменить.');
      exit;
  end;
  fm:=TfmEditRBUser.Create(nil);
  try
    fm.TypeEditRBook:=terbChange;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edSqlName.Text:=Mainqr.fieldByName('user_name').AsString;
    fm.edSqlName.Enabled:=false;
    fm.edSqlName.Color:=clBtnFace;
    fm.olduser_id:=Mainqr.fieldByName('user_id').AsInteger;
    fm.edPass.Text:=fm.GetPassword(Mainqr.fieldByName('user_name').AsString);
    fm.olduser_name:=Mainqr.fieldByName('user_name').AsString;
    fm.ChangeFlag:=false;
    if fm.ShowModal=mrok then begin
     ActiveQuery(false);
     MainQr.Locate('user_id',fm.olduser_id,[loCaseInsensitive]);
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBUsers.bibDelClick(Sender: TObject);
var
  but: Integer;

  function ConnectSecurityService: Boolean;
  var
    Srvname: array[0..ConstSrvName-1] of char;
    protocol: TProtocol;
    P: PInfoConnectUser;
  begin
   Result:=false;
   try
    new(P);
    try
     ZeroMemory(P,sizeof(TInfoConnectUser));
     FillChar(Srvname,ConstSrvName,0);
     _GetProtocolAndServerName(PChar(IBDB.DatabaseName),protocol,Srvname);
     IBSecServ.ServerName := Srvname;
     IBSecServ.Protocol:=protocol;
     IBSecServ.LoginPrompt := False;
     if IBSecServ.Active then
      IBSecServ.Active := false;
     IBSecServ.Params.Clear;
     _GetInfoConnectUser(P);
     IBSecServ.Params.Add('user_name='+P.SqlUserName);
     IBSecServ.Params.Add('password='+P.UserPass);
  //   IBSecServ.Params.Add('sql_role_name='+P.SqlRole);
     IBSecServ.Active := true;
     Result:=true;
    finally
     dispose(P);
    end;
   except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
   end;
  end;

  function DelUser: Boolean;
  begin
    Result:=false;
    try
      if ConnectSecurityService then begin
       IBSecServ.UserName:=Trim(Mainqr.FieldByName('user_name').asString);
       IBSecServ.UserID:=Mainqr.FieldByName('user_id').asInteger;
       IBSecServ.GroupID:=0;

       IBSecServ.DeleteUser;
       IBSecServ.Active := false;
       Result:=true;
      end;
    except
     {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
    end;
  end;

  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
    CU: TInfoConnectUser;
  begin
   Result:=false;
   FillChar(CU,SizeOf(TInfoConnectUser),0);
   _GetInfoConnectUser(@CU);
   if CU.User_id=Mainqr.FieldByName('user_id').AsInteger then exit;
   
   if AnsiUpperCase(Mainqr.FieldByName('user_name').asString)=
      AnsiUpperCase(ConstConnectUserName) then begin
      ShowErrorEx(
               'Пользователь <'+Mainqr.FieldByName('name').AsString+'> используется.');
      exit;
   end;
   if AnsiUpperCase(Mainqr.FieldByName('user_name').asString)=
      AnsiUpperCase(ConstUserSysDba) then begin
      ShowErrorEx(
               'Пользователь <'+Mainqr.FieldByName('name').AsString+'> используется.');
      exit;
   end;
   Screen.Cursor:=crHourGlass;
   qr:=TIBQuery.Create(nil);
   try
    result:=false;
    try
     if not DelUser then exit;
     qr.Database:=IBDB;
     qr.Transaction:=IBTran;
     qr.Transaction.Active:=true;
     sqls:='Delete from '+tbUsers+' where user_id='+
          Mainqr.FieldByName('user_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
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
  but:=DeleteWarningEx('пользователя <'+Mainqr.FieldByName('name').AsString+'> ?');
  if but=mrYes then begin
    if not deleteRecord then begin
    end;
  end;
end;

procedure TfmRBUsers.bibViewClick(Sender: TObject);
var
  fm: TfmEditRBUser;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  fm:=TfmEditRBUser.Create(nil);
  try
    fm.TypeEditRBook:=terbView;
    fm.edName.Text:=Mainqr.fieldByName('name').AsString;
    fm.edSqlName.Text:=Mainqr.fieldByName('user_name').AsString;
    fm.edPass.Text:=fm.GetPassword(Mainqr.fieldByName('user_name').AsString);
    if fm.ShowModal=mrok then begin
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmRBUsers.bibFilterClick(Sender: TObject);
var
  fm: TfmEditRBUser;
  filstr: string;
begin
 fm:=nil;
 try
  fm:=TfmEditRBUser.Create(nil);

  fm.TypeEditRBook:=terbFilter;
  fm.lbPass.Enabled:=false;
  fm.edPass.Enabled:=false;
  fm.edPass.Color:=clBtnFace;
  fm.chbHidePass.Enabled:=false;

  if Trim(FindName)<>'' then fm.edName.Text:=FindName;
  if Trim(FindSqlName)<>'' then fm.edSqlName.Text:=FindSqlName;

  fm.cbInString.Checked:=FilterInSide;

  fm.ChangeFlag:=false;

  if fm.ShowModal=mrOk then begin

    inherited;

    FindName:=Trim(fm.edName.Text);
    FindSQlName:=Trim(fm.edSqlName.Text);

    FilterInSide:=fm.cbInString.Checked;
    if FilterInSide then filstr:='%';

    ActiveQuery(false);
    ViewCount;
  end;
 finally
  fm.free;
 end;
end; 

function TfmRBUsers.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2: string;
  and1: string;
begin
    Result:=Inherited GetFilterString;
    if Trim(Result)<>'' then exit;

    isFindName:=Trim(FindName)<>'';
    isFindSQlName:=Trim(FindSQlName)<>'';

    if isFindName or isFindSqlName then begin
     wherestr:=' where ';
    end else begin
    end;

    if FilterInside then FilInSide:='%';

     if isFindName then begin
        addstr1:=' Upper(name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindName+'%'))+' ';
     end;

     if isFindSqlName then begin
        addstr2:=' Upper(user_name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindSqlName+'%'))+' ';
     end;


     if (isFindName and isFindSqlName)
        then and1:=' and ';


      Result:=wherestr+addstr1+and1+addstr2
end;

var
  SSS: string;

procedure GetInterfaceProc(Owner: Pointer; PGI: PGetInterface); stdcall;
begin
  SSS:=SSS+PGI.Name+#13;
end;

procedure TfmRBUsers.Button1Click(Sender: TObject);
{var
{  PCTButton: TCreateToolButton;
  PCMenu: TCreateMenu;
  hMenuHelp: Thandle;}
{  TRBI: TParamRBookInterface;
  i: Integer;
  l,h: Integer;
  A: array of Variant;
  j: Integer;
  Value: Variant;
  TRBR: TRBookResult;}
begin
{  FillChar(TRBI,SizeOf(TParamRBookInterface),0);
  _ViewINterfaceFromName(NameRbkInterfaces,@TRBI);
{  SSS:='';
  _GetInterfaces(nil,GetInterfaceProc);
  ShowMessage(SSS);}


{  FillChar(TRBI,SizeOf(TParamRBookInterface),0);
  TRBI.Visual.TypeView:=tvibvModal;
  TRBI.Visual.MultiSelect:=true;
  if _ViewInterfaceFromName(NameRbkInterfaces,@TRBI) then begin
  end;

{  FillCHar(PCTBar,SizeOf(TCreateToolBar),0);
  PCTBar.Name:='test2';
  PCTBar.Visible:=false;
  PCTBar.Position:=tbpFloat;
  tbar1:=_CreateToolBar(@PCTBar);
  FillCHar(PCTButton,SizeOf(TCreateToolButton),0);
  PCTButton.Name:='fuck';
  _CreateToolButton(tbar1,@PCTButton);
  _RefreshToolBar(tbar1);
  FillCHar(PCMenu,SizeOf(TCreateMenu),0);
  PCMenu.Name:='test';
  PCMenu.Hint:='test';
  PCMenu.ShortCut:=ShortCut(Ord('A'),[ssCtrl]);
  PCMenu.TypeCreateMenu:=tcmAddFirst;
  hMenuHelp:=_GetMenuHandleFromName(MENU_ROOT_HANDLE,ConstsMenuHelp);
  if _FreeMenu(hMenuHelp) then begin
//  hMenuHelp:=MENU_ROOT_HANDLE;
   hMenu:=_CreateMenu(hMenuHelp,@PCMenu);
  end;   }

//  _RefreshToolBar(tbar1);
end;

end.
